local runtime_initialize = (require)("@self/runtime")
local utils_create = require("./utils")

return function(polyfill_create: typeof(require("../Compiler/polyfill")))
    local utils, utils_ready = utils_create()
    local polyfill, polyfill_ready = polyfill_create(utils)
    local RuntimeInstance = runtime_initialize({
        ["env"] = polyfill,
        ["wasi_snapshot_preview1"] = polyfill,
    })

    polyfill_ready(RuntimeInstance)
    utils_ready(RuntimeInstance)
    return RuntimeInstance, utils, polyfill
end
