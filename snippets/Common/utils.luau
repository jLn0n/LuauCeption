return function()
    local exports, memory, INDIRECT_FUNCTIONS
    local module = {}

    function module.stub(name: string, ret: any)
        return function(...)
            if (STUB_WARN) then
                print(`[WARN]: stub function '{name}' called`)
            end

            return ret
        end
    end

    function module.load_string(addr: number, length: number): string
        local content = buffer.create(length)

        buffer.copy(content, 0, memory[1], addr, length)
        return buffer.tostring(content)
    end

    function module.store_string(addr: number, data: string, length: number?)
        local content = buffer.fromstring(if not length or length == #data then data else string.sub(data, 1, length))

        buffer.copy(memory[1], addr, content)
    end

    function module.insertCFunction(func: (...any) -> (...any)): number
        local ptr = #INDIRECT_FUNCTIONS + 1
        rt_table_set(INDIRECT_FUNCTIONS, ptr, func)

        return ptr
    end

    function module.cstr(value: string): number
        local str_len = #value
        local str_ptr = exports.malloc(str_len + 1)

        rt_store_i32_into_i8(memory, str_ptr + str_len, 0)
        module.store_string(str_ptr, value)
        return str_ptr
    end

    function module.cstr_array(array: {string}): number
        local array_len = #array
        local array_ptr = exports.malloc((array_len + 1) * 4)

        for idx = 0, (array_len - 1) do
            local str_val = array[idx + 1]
            local str_len = #str_val
            local str_ptr = exports.malloc(str_len + 1)

            module.store_string(str_ptr, str_val)
            rt_store_i32_into_i8(memory, str_ptr + str_len, 0)
            rt_store_i32(memory, array_ptr + (idx * 4), str_ptr)
        end

        rt_store_i32(memory, array_ptr + (array_len * 4), 0)
        return array_ptr
    end

    function module.free_array(array_ptr: number)
        local position = 0

        while true do
            local str_ptr = rt_load_i32(memory, array_ptr + position)
            if str_ptr == 0 then
                break
            end

            exports.free(str_ptr)
            position += 4
        end
        exports.free(array_ptr)
    end

    function module.newCException(excPtr: number)
        local CException = {}
        CException.ptr = excPtr

        function CException._UndecoratedName(self)
            local name_ptr = rt_load_i32(memory, self.ptr + 4)
            return module.load_string(name_ptr, exports.strlen(name_ptr))
        end

        function CException.vfptr(self)
            return rt_load_i32(memory, self.ptr)
        end
        return CException
    end

    return module, function(rt_inst: any)
        exports, memory, INDIRECT_FUNCTIONS = rt_inst, rt_inst.memory, rt_inst.__indirect_function_table
    end
end
