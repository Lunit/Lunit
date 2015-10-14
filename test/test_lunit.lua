

local lunit = require("lunit") 



local function printTestMessage(trueExpected)
  print(trueExpected == true and "OK" or "Failed")
end


local function assertEqualsTest()
  --Booleans
  printTestMessage(lunit.assertEquals(true, (1 == 1)))
  printTestMessage(lunit.assertEquals(false, (2 == 1)))
  
  --Numbers
  printTestMessage(lunit.assertEquals(3,3))
  printTestMessage(lunit.assertEquals(3,3.0))
  printTestMessage(lunit.assertEquals(3.0,3.0))
  
  --Strings
  printTestMessage(lunit.assertEquals("3.0","3.0"))
  printTestMessage(lunit.assertEquals("3.0","3." .."0"))
  printTestMessage(lunit.assertEquals("",""))
  
  --Tables
  printTestMessage(lunit.assertEquals({},{}))
  printTestMessage(lunit.assertEquals({1, 2, 3},{1, 2, 3}))
  printTestMessage(not lunit.assertEquals({1, 2, 3},{2, 1, 3}))
  printTestMessage(not lunit.assertEquals({1, 2, 3},{2, 1, 3, 4}))
  printTestMessage(not lunit.assertEquals({1, 2, 3, 4},{2, 1, 3}))
  printTestMessage(not lunit.assertEquals({1, 2, 3, 4},{2, 4, 1, 3}))
  
end

local function failTest()
	local status, err = pcall(function() lunit.fail() end)
	printTestMessage(status == false)
	printTestMessage(err.message == "Not implemented")
end


local function assertThrowsExceptionsTest()
	printTestMessage(lunit.assertThrowsException(function() error() end))
end


--assertEqualsTest()
--failTest()
assertThrowsExceptionsTest()
