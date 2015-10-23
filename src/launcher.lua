--------------------------------------------------------------------------------
-- launcher should extract project path and add it's src/ and test/ folders
-- to path and put all content of test/ folder as argument to runner
--
local M = {}

-- command line arguments list
local arg = arg
---- imported module search path
--local search_path = package.path

local print = print
local string_format = string.format
local os_exit =  os.exit
local ipairs = ipairs
local string_match = string.match
local string_find = string.find
local test_runner = require("test-runner")
-- test runner deps, should be imported before resetting path
local lunit = require("lunit")




--_ENV = M

local function main()

  if #arg < 1 then
    print(string_format("Usage: %s <absolute path to testmodule> [secondTestmodule]", arg[0]))
    os_exit()
  end

  local testModuleLocation, fileName = M.extractArgumentsLocation(arg[1])
  local moduleUnderTestLocation = M.constructModuleLocation(testModuleLocation)
  package.path = ""
  package.path = package.path .. ";" .. testModuleLocation .. "/?.lua;"
   .. moduleUnderTestLocation .. "/?.lua;"
  
  -- forward test file names to test runner
  local testRunnerArguments = {}
  
  for i, path in ipairs(arg) do
    local dir, name = M.extractArgumentsLocation(path)
  	testRunnerArguments[#testRunnerArguments + 1] = name
  end
  
  test_runner.run(testRunnerArguments, package.path)
  
end
---------------------------------------------------------------------------
-- Separates filename from file's location
--
-- @param #string absolutePath full (absolute) path to file
-- @return #string path to directory, containing file and filename
--                without extention
function M.extractArgumentsLocation(path)

  if not string_find(path, '(.*)/(*)') then
    path = './' .. path
  end
  

  local location, filenameWithExtension, filename =
    string_match(path, '(.*)/(([^./]*)%....)')

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
