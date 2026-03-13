local api_flags_create = require("../Common/api_flags")
local runtime_create = require("../Common/runtime_create")
local vm_common_init = require("../VM/common")

return (function()
    local RuntimeInstance, utils = runtime_create(require("../VM/polyfill"))
    local api_flags = api_flags_create(RuntimeInstance, utils)
    local vm_common = vm_common_init(RuntimeInstance, utils)
    
    return {
        luau_run = vm_common.luau_run,
        luau_load = vm_common.luau_load,
        luau_setflag = api_flags.luau_setflag,
        luau_setallflags = api_flags.luau_setallflags,
        luau_resetflags = api_flags.luau_resetflags,
        macros = require("../VM/luau_macros")(RuntimeInstance, utils),
        wasm = {
            exports = RuntimeInstance,
            utils = utils,
        }
    }
end)()
