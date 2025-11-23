local compiler_polyfill_create = require("../Compiler/polyfill")

return function(utils: typeof(require("../Common/utils")()))
    local exports, memory, INDIRECT_FUNCTIONS
    local polyfill, common_polyfill_ready = compiler_polyfill_create(utils)

    local LONGJMP_THROW_SIGN = newproxy(false)
    local FILE_MAP = { {}, {} }
    
    local START_CLOCK, NOW_TIME = os.clock(), os.time() * 1000

    -- returns time since the instance was initialized
    local function now_clock(): number
        return os.clock() - START_CLOCK
    end

    local function fd_flush(file: {string})
        local final = table.concat(file)
        local last = 1
        for index, data in string.gmatch(final, '()([^\n]*)\n') do
            last = index + #data
            print(data)
        end
        table.clear(file)
        file[1] = string.sub(final, last + 1)
    end

    local function invokeHandler(index: number)
        return function(fnIndex: number, ...)
            local stack_ptr = exports.emscripten_stack_get_current()
            local err, stacktrace = "N/A", "N/A"
            local success = xpcall(
                INDIRECT_FUNCTIONS[fnIndex],
                function(_e)
                    err,stacktrace = _e,debug.traceback()
                end,
                ...
            )
            if success then
                return
            end

            exports._emscripten_stack_restore(stack_ptr)
            if err ~= LONGJMP_THROW_SIGN then
                error(`{err}\n\ninvoke stacktrace:\n{stacktrace}`, 2)
            end

            exports.setThrew(1, 0)
        end
    end

    polyfill._tzset_js = utils.stub("_tzset_js", 0)
    polyfill.invoke_vii = invokeHandler(1)

    function polyfill._emscripten_throw_longjmp()
        return error(LONGJMP_THROW_SIGN, 0)
    end

    function polyfill.emscripten_date_now()
        return NOW_TIME + now_clock() * 1000
    end
    
    function polyfill._localtime_js(timer, buf)
        local now = os.time()
        local local_tdata = os.date("*t", rt_convert_u64_to_f64(timer))
        local gmt_offset = os.difftime(now, os.time(os.date("!*t", rt_convert_u64_to_f64(timer))))

        --// https://en.cppreference.com/w/cpp/chrono/c/tm
        rt_store_i32(memory, buf + 0, local_tdata.sec) --// int tm_sec
        rt_store_i32(memory, buf + 4, local_tdata.min) --// int tm_min
        rt_store_i32(memory, buf + 8, local_tdata.hour) --// int tm_hour
        rt_store_i32(memory, buf + 12, local_tdata.day) --// int tm_mday
        rt_store_i32(memory, buf + 16, local_tdata.month - 1) --// int tm_mon
        rt_store_i32(memory, buf + 20, local_tdata.year - 1900) --// int tm_year
        rt_store_i32(memory, buf + 24, local_tdata.wday - 1) --// int tm_wday
        rt_store_i32(memory, buf + 28, local_tdata.yday - 1) --// int tm_yday
        rt_store_i32(memory, buf + 32, if local_tdata.isdst then 1 else 0) --// int tm_isdst
        rt_store_i32(memory, buf + 36, gmt_offset) --// long tm_gmtoff
    end

    function polyfill._gmtime_js(timer, buf)
        local now = os.time()
        local utc_tdata = os.date("!*t", rt_convert_u64_to_f64(timer))
        local gmt_offset = os.difftime(now, os.time(utc_tdata))

        --// https://en.cppreference.com/w/cpp/chrono/c/tm
        rt_store_i32(memory, buf + 0, utc_tdata.sec) --// int tm_sec
        rt_store_i32(memory, buf + 4, utc_tdata.min) --// int tm_min
        rt_store_i32(memory, buf + 8, utc_tdata.hour) --// int tm_hour
        rt_store_i32(memory, buf + 12, utc_tdata.day) --// int tm_mday
        rt_store_i32(memory, buf + 16, utc_tdata.month - 1) --// int tm_mon
        rt_store_i32(memory, buf + 20, utc_tdata.year - 1900) --// int tm_year
        rt_store_i32(memory, buf + 24, utc_tdata.wday - 1) --// int tm_wday
        rt_store_i32(memory, buf + 28, utc_tdata.yday - 1) --// int tm_yday
        rt_store_i32(memory, buf + 32, if utc_tdata.isdst then 1 else 0) --// int tm_isdst
        rt_store_i32(memory, buf + 36, gmt_offset) --// long tm_gmtoff
    end

    function polyfill.clock_time_get(clock_id: number, _ignored_precision: boolean, ptime: number)
        if not (clock_id >= 0 and clock_id <= 3) then
            return 28
        end

        local time_now
        if clock_id == 0 then
            time_now = polyfill.emscripten_date_now()
        elseif true then -- if nowIsMonotonic is 1
            time_now = now_clock()
        end

        local nsec = math.round(time_now * 1000 * 1000)
        rt_store_i64(memory, ptime + 0, nsec)
        return 0
    end

    function polyfill.fd_write(fd, list, count, ret_pointer)
        local file = FILE_MAP[fd]
        if not file then return 8 end
        local total = 0
        for pointer = list, list + (count - 1) * 8, 8 do
            local start = rt_load_i32(memory, pointer)
            local len = rt_load_i32(memory, pointer + 4)
            local read = (function()
                local buf = buffer.create(len)
                buffer.copy(buf, 0, memory[1], start, len)
                return buffer.tostring(buf)
            end)() --rt_load_string(memory, start, len)

            table.insert(file, read)
            total = total + #read
        end
        rt_store_i32(memory, ret_pointer, total)
        fd_flush(file)
        return 0
    end

    return polyfill, function(rt_inst: any)
        exports, memory, INDIRECT_FUNCTIONS = rt_inst, rt_inst.memory, rt_inst.__indirect_function_table
        common_polyfill_ready(rt_inst)
    end
end
