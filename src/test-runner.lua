-----------------------------------------------------------------------
-- This module provide main fasility for running unit test
-- on lua projects.
--
-- Test suites to run should be specified as arguments to runner script.
-- All test methods should have test in their names.
--
-- @module test-runner
--
--

local M = {}

local ipairs = ipairs
local pairs = pairs
local arg = arg
local string = string
local pcall = pcall
local require = require
local error = error
local print = print

_ENV = M


local function main()

  local testRunner = M.createTestRunner();
  for i = 1, #arg do
    local moduleUnderTest = require(arg[i])
    local testResult = testRunner:runTestSuite(moduleUnderTest)
    print(string.format("\nMoudle under test is %s:", arg[i]))
    for key, var in pairs(testResult) do
      print(string.format("%10s: %s", key, var))
    end
  end


end

----------------------------------------------------------
-- Test Object class factory
--
-- @param #function     methodUnderTest one of frameworks assertions
-- @return #table       testCase object
--
function M.getTestObject (methodUnderTest)
  local obj = {method = methodUnderTest}
  obj.runTest = function (self)
    local status, result = pcall(function() return self.method() end)
    if status and result then return {status = "OK"}
    elseif status then return {status = "Failed"}
    else -- not status - test generated exception
      return {status = "Exception", errMessage = result}
    end
  end
  return obj
end


function M.createTestRunner()
  local runner = {}
  runner.runTestSuite = function (self, moduleUnderTest)
    if not self and not moduleUnderTest then
      error("self and modulename not specified")
    end
    local testSuite = {}
    for key, testMethod in pairs(moduleUnderTest) do
      if string.match(key, "test") then
        testSuite[#testSuite + 1] = M.getTestObject(testMethod)
      end
    end

    local testResult = {OK = 0, Failed = 0, Exception = 0}
    for i, test in ipairs(testSuite) do
      local res = test:runTest()
      testResult[res.status] = testResult[res.status] + 1
    end
    return testResult

  end
  return runner
end

main()

return M
