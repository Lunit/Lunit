-------------------------------------
-- Test module for test-runner script
--
--
--
local test_runner_module = require("test-runner")

local function main()

  -- test functions
  local returnsTrue = function () return true end
  local returnsFalse = function () return false end
  local fail = function() error("Test failed") end

  -- test object section
  print("\nTest object section:")

  local testObject = test_runner_module.getTestObject(fail)
  local result = testObject:runTest() -- should generate exception
  print(string.format("Exceptions test%30s", result.status == "Exception" and "Passed" or "Failed"))

  testObject = test_runner_module.getTestObject(returnsTrue)
  result = testObject:runTest() -- should return true
  print(string.format("Exceptions test%30s", result.status == "OK" and "Passed" or "Failed"))
  
  testObject = test_runner_module.getTestObject(returnsFalse)
  result = testObject:runTest() -- should return false
  print(string.format("Exceptions test%30s", result.status == "Failed" and "Passed" or "Failed"))
  
  -- test runner section
  print("\nTest runner section")
  
  local testRunner = test_runner_module.createTestRunner()
  local testModule = {
                      testMethod1 = returnsTrue,
                      testMethod2 = returnsTrue,
                      testMethod3 = returnsFalse,
                      testMethod4 = fail}
  local expectedResult = {OK = 2, Failed = 1, Exception = 1}
  result = testRunner:runTestSuite(testModule)
  
  
  for i, status in ipairs({"OK", "Failed", "Exception"}) do
  	print(string.format("Expected %s, got %s", expectedResult[status], result[status]))
  end
  
end

main()
