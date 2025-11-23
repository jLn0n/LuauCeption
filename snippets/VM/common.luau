return function(rt_inst: any, utils: typeof(require("../Common/utils")()))
    local exports, memory, INDIRECT_FUNCTIONS = rt_inst, rt_inst.memory, rt_inst.__indirect_function_table
    local module = {}

    function module.luau_run(
        bytecode: string,
        chunkName: string?,
        safeEnv: boolean?
    ): boolean
        -- load bytecode and chunkName to memory
        local bytecode_ptr = utils.cstr(bytecode)
        local chunkName_ptr = utils.cstr(chunkName or "LuauCeptionChunk")

        -- setup Luau state
        local L = exports.luaL_newstate()
        exports.luaL_openlibs(L);
        if safeEnv then
            exports.luaL_sandbox(L)
        end

        -- load bytecode
        local load_result = exports.luau_load(L, chunkName_ptr, bytecode_ptr, #bytecode, 0)

        -- cleanup unused stuff
        exports.free(bytecode_ptr)
        exports.free(chunkName_ptr)

        -- check if load succeded
        if (load_result ~= 0) then
            exports.lua_close(L)
        end
        assert(load_result == 0, "failed to load luau bytecode")

        -- call function
        local clRes = exports.lua_pcall(L, 0, 0, 0)

        -- cleanup state
        exports.lua_close(L)
        return clRes == 0
    end

    function module.luau_load(
        bytecode: string,
        chunkName: string?,
        safeEnv: boolean?
    ): () -> (boolean)
        return function()
            return module.luau_run(bytecode, chunkName, safeEnv)
        end
    end

    return module
end
