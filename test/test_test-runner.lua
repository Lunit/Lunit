-------------------------------------
-- Test module for test-runner script
--
--
--
local lunit = require("lunit")
local test_runner = require("test-runner")

local function main()

  -- test object section
  local testObject = test_runner.getTestObject(lunit.fail)
  print(string.format("Exceptions test%30s", testObject.Exception == 1 and "Passed" or "Failed"))

end

main()

