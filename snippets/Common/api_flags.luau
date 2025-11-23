return function(rt_inst: any, utils: typeof(require("./utils")()))
    local exports, memory, INDIRECT_FUNCTIONS = rt_inst, rt_inst.memory, rt_inst.__indirect_function_table
    local module = {}

    function module.luau_setflag(name: string, state: boolean)
        --// Flag name
        local flagNamePtr = utils.cstr(name)

        --// Set the flag
        exports.set_flag(flagNamePtr, if (state) then 1 else 0)

        --// Cleanup
        exports.free(flagNamePtr)
        return
    end

    function module.luau_setallflags(state: boolean)
        exports.set_all_flags(if (state) then 1 else 0)
        return
    end

    function module.luau_resetflags()
        exports.reset_flags()
        return
    end

    return module
end
