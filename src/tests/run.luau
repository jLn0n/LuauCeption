local frktest = require("@frktest/frktest")
local console_reporter = require("@frktest/reporters/console_reporter")
local fs = require("@lune/fs")
local process = require("@lune/process")

for _, name in fs.readDir("./src/tests/suites") do
    local ok = require(`./suites/{string.split(name, ".")[1]}`) :: any
    assert(ok, `could not load suite {name}`)
end

console_reporter.init()
local testOk = frktest.run()
if (not testOk) then
    process.exit(1)
end
