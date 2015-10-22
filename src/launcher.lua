--------------------------------------------------------------------------------
-- launcher should extract project path and add it's src/ and test/ folders
-- to path and put all content of test/ folder as argument to runner
--
local M = {}

-- command line arguments list
local arg = arg
-- imported module search path
local search_path = package.path

local print = print
local string_format = string.format
local os_exit =  os.exit
local ipairs = ipairs
local string_match = string.match
local string_find = string.find



_ENV = M

local function main()

  if #arg < 1 then
    print(string_format("Usage: %s <absolute path to testmodule> [secondTestmodule]", arg[0]))
    os_exit()
  end

  local testModuleLocation, fileName = M.extractArgumentsLocation(arg[1])
  local moduleUnderTestLocation = M.constructModuleLocation(testModuleLocation)
  search_path = search_path or ""
  search_path = search_path .. testModuleLocation .. "/?.lua;" .. moduleUnderTestLocation .. "/?.lua;"
  
  -- forward test file names to test runner
  local testRunnerArguments = {}
  
  for i, path in ipairs(arg) do
    local dir, name = M.extractArgumentsLocation(path)
  	testRunnerArguments[#testRunnerArguments + 1] = name
  end
  
  print(testRunnerArguments)
  
end
---------------------------------------------------------------------------
-- Separates filename from file's location
--
-- @param #string absolutePath full (absolute) path to file
-- @return #string path to directory, containing file and filename
--                without extention
function M.extractArgumentsLocation(absolutePath)

  if not string_find(absolutePath, '(.*)/(*)') then
    absolutePath = './' .. absolutePath
  end
  

  local location, filenameWithExtension, filename =
    string_match(absolutePath, '(.*)/(([^./]*)%....)')

  return location, filename
end
-- print(string.match("/home/user/projects/dir/module.submodule.lua", '(.*)/((.*)%.[^%.][^%.][^%.])'))

-------------------------------------------------------------------------------
-- Constructs path to module under test source files, assuming that
-- project has structure, when source file are placed under the src/ folder
-- and tests are under the test/ folder under the same root.
function M.constructModuleLocation(testSuiteLocation)
  return string_match(testSuiteLocation, '(.*/)test') .. "src"
end

main()
return M
