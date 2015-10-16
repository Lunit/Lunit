local M = {}
local lunit = require("lunit")
_ENV = M


function M.testMethod1()
	return lunit.assertEquals(3,3.0)
end

function M.testMethod2()
	return lunit.assertEquals("some string","some string")
end

function M.testMethod3()
	return lunit.assertApproximatelyEquals(10, 8, 3)
end

function M.testMethod4()
	return lunit.assertStringMatchPattern("error","No errors detected")
end

return M