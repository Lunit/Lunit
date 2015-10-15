-----------------------------------------------
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

_ENV = M


local function main()

  local testRunner = M.createTestRunner();
  for i, moduleName in ipairs(arg) do
    testRunner:runTestSuite(moduleName)
  end


end

----------------------------------------------------------
-- Test Object class factory
--
-- @param #function     methodUnderTest one of frameworks assertions
-- @return #table       testCase object
--
function M.getTestObject (methodUnderTest)
  obj = {method = methodUnderTest}
  obj.runTest = function (self)
    local status, result = pcall(function() return self.methodUnderTest() end)
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
  runner.runTestSuite = function (self, modulename)
    if not self and not modulename then
      error("self and modulename not specified")
    end
    -- TODO module import settings adjustment
    local moduleUnderTest = require(modulename)
    local testSuite = {}
    for key, testMethod in pairs(moduleUnderTest) do
      if string.match(key, "test") then
        testSuite[#testSuite + 1] = M.getTestObject(testMethod)
      end
    end

    local testResult = {OK = 0, Failed = 0, Exception = 0}
    for i, test in ipairs(testSuite) do
      local res = test:runTest()
      testResult[res] = testResult[res] + 1
    end
    return testResult

  end
  return runner
end

main()

return M
