local api_flags_create = require("../Common/api_flags")
local runtime_create = require("../Common/runtime_create")
local compiler_common_init = require("../Compiler/common")
export type LuauCompileOptions = compiler_common_init.LuauCompileOptions

local RuntimeInstance, utils = runtime_create(require("../Compiler/polyfill"))
local api_flags = api_flags_create(RuntimeInstance, utils)
local compiler_common = compiler_common_init(RuntimeInstance, utils)

return {
    luau_compile = compiler_common.luau_compile,
    luau_setflag = api_flags.luau_setflag,
    luau_setallflags = api_flags.luau_setallflags,
    luau_resetflags = api_flags.luau_resetflags,
    wasm = {
        exports = RuntimeInstance,
        utils = utils,
    }
}
