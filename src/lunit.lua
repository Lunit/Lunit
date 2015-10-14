---------------------------------------------------
-- This module provides helper functions for unit
-- testing in lua projects.
-- @module lunit
-------------------------------------------------
local M = {}
-- Import section
-- all module external dependencies are here

local type = type
local error = error
-- import section end

-- protect global environment
_ENV = M


----------------------------------------------------------------------
-- Tests whether expected match got or not.
--
-- Tables considered as equals if they have equals key-value pairs
-- @return               boolean result of test
--
function M.assertEquals(expected, got)
  if (type(got) ~= "table") then
    return (expected == got)
  else

    for k,v in pairs(got) do
      if (not M.assertEquals(expected[k], v)) then
        return false
      end
    end
    return true
  end
end

------------------------------------------------------------------------------------------
-- Always fails.
--
-- Raises and exception with messaged passed as argument or "not implemented"
-- in case of message absence.
--
-- @param msg           [optional] message to be passed as exception
--
function M.fail(msg)
  local message = msg or "Not implemented"
  error({["message"] = message})
end

---------------------------------------------------------------------------------------
-- Return true if tested function throws exception and false otherwise.
--
-- @param expression    expression to test
--
function M.assertThrowsException(expressionToTest)
  return  not pcall(function() expressionToTest() end)
end

-----------------------------------------------------------------------------------------
-- Return true if got approximately equals expected
-- 
-- Return true if abs(got - expected) <= delta and false otherwise
 function M.assertApproximatelyEquals(expected, got, delta)
 	local actualDelta = expected - got
  if actualDelta < 0 then
    actualDelta = actualDelta * -1
  end
  return actualDelta <= delta
 end
return M
