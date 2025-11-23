local task = task or (require)("@lune/task")

return function(utils: typeof(require("../Common/utils")()))
    local exports, memory, INDIRECT_FUNCTIONS
    local polyfill = {}

    local __TIMERS = {}
    local __EXIT_STATUS = nil
    local __ABORT_WASM = false
    local __NO_EXIT_RUNTIME = true
    local __RUNTIME_KEEPALIVE_COUNTER = 0

    function polyfill.__cxa_throw(ptr, type, destructor)
        local info = utils.newCException(type)
        error(`exception occured in c: {info:_UndecoratedName()} ({info:vfptr()})`, 0)
    end

    function polyfill.emscripten_resize_heap(_requestedSize: number)
        error("OOM", 0)
    end

    function polyfill._abort_js(reason: any)
        error(`Aborted({reason})`, 0)
    end
    
    function polyfill._setitimer_js(which, timeoutMs)
        if (not task) then
            print("program is using _setitimer_js but task library not found, timers will NOT work.")
            return 0
        end

        if (__TIMERS[which]) then
            task.cancel(__TIMERS[which].thread)
            __TIMERS[which] = nil
        end
        if (not timeoutMs or timeoutMs == 0) then
            return 0
        end

        local thread = task.delay(function()
            __TIMERS[which] = nil
            if (__ABORT_WASM) then
                return
            end

            local success, result = pcall(function()
                exports._emscripten_timeout(which, os.clock())
                if (__NO_EXIT_RUNTIME or __RUNTIME_KEEPALIVE_COUNTER > 0) then
                    return
                end

                local exit_success, exit_result = pcall(polyfill.proc_exit, __EXIT_STATUS)
                if exit_success then
                    return
                end

                if (string.match(exit_result, "ExitStatus:") ~= nil or exit_result == "unwind") then
                    return __EXIT_STATUS
                end

                error(exit_result, 0)
            end)

            if (not success) then
                if (string.match(result, "ExitStatus:") ~= nil or result == "unwind") then
                    return
                end

                error(result, 0)
            end
        end, timeoutMs / 1000)

        __TIMERS[which] = { thread = thread, timeoutMs = timeoutMs }
        return 0
    end

    function polyfill._emscripten_runtime_keepalive_clear()
        __NO_EXIT_RUNTIME, __RUNTIME_KEEPALIVE_COUNTER = false, 0
    end

    function polyfill.proc_exit(code: number)
        __EXIT_STATUS = code
        if (not (__NO_EXIT_RUNTIME or __RUNTIME_KEEPALIVE_COUNTER > 0)) then
            __ABORT_WASM = true
        end

        error(`ExitStatus: Program exited with code ${code}`, 0)
    end

    return polyfill, function(rt_inst: any)
        exports, memory, INDIRECT_FUNCTIONS = rt_inst, rt_inst.memory, rt_inst.__indirect_function_table
    end
end
