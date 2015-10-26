------------------------------
-- Provide some functions for file path manipulation.
-- @module path
local M = {}

  local string = string

if setfenv then
	setfenv(1, M) -- for 5.1
else
	_ENV = M -- for 5.2
end

---------------------------------------------------------------------------
-- Separates filename from file's location
--
-- @param #string path path to file
-- @return #string path to directory, containing file and filename
--                without extention
function M.extractArgumentsLocation(path)

  -- adding folder path, if absent
  if not string.find(path, '(.*)/(*)') then
    path = './' .. path
  end

  -- adding extension, if not present
  if not  string.find(path, '%.lua') then
    path = path .. '.lua'
  end


  local location, filenameWithExtension, filename =
    string.match(path, '(.*)/(([^./]*)%....)')

  return location, filename
end

return M