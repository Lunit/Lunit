--------------------------------------------------------------------------------
-- launcher should extract project path and add it's src/ and test/ folders
-- to path and put all content of test/ folder as argument to runner
--
local M = {}

local test_runner = require("test-runner")
local path_module = require("path")


local function main()
  -- check if required arguments are present
  if #arg < 1 or arg[1] == '--help' or arg[1] == '-h' then
    print(string.format("Usage: %s [pathfile=<pathfile location>]" ..
      " <absolute path to testmodule> [secondTestmodule]", arg[0]))
    os.exit()
  end
  
  -- add project source folders to build path
  local projectBuildPath = ''
  if string.find(arg[1], 'pathfile=') then
    local fileName = string.gsub(arg[1], 'pathfile=', '')
    local file = io.open(fileName, 'r')
    if file then
      projectBuildPath = projectBuildPath .. file:read('*a')
      file:close()
    end
    -- remove first argument
    table.remove(arg, 1)
  end
  
  -- add test moudules location and possible source file location to build path
  local testModuleLocation, fileName = path_module.extractArgumentsLocation(arg[1])
  local moduleUnderTestLocation = M.constructModuleLocation(testModuleLocation)
  package.path = package.path or ""
  package.path = package.path .. ";" .. testModuleLocation .. "/?.lua;"
    .. moduleUnderTestLocation .. "/?.lua;" .. projectBuildPath .. ";"
    
  -- forward test file names to test runner
  local testRunnerArguments = {}

  for i, path in ipairs(arg) do
    local dir, name = path_module.extractArgumentsLocation(path)
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

-------------------------------------------------------------------------------
-- Constructs path to module under test source files, assuming that
-- project has structure, when source file are placed under the src/ folder
-- and tests are under the test/ folder under the same root.
function M.constructModuleLocation(testSuiteLocation)
  return string.match(testSuiteLocation, '(.*/)test') .. "src"
end

main()
return M
