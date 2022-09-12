if not nyagos then
  print("This is a script for nyagos not lua.exe")
  os.exit()
end

local module = {}

local default_envs = {}
local last_localenv_file = nil

local function find(table, value)
  for i, v in ipairs(table) do
    if v == value then
      return i
    end
  end
  return nil
end

local function current_envs()
  return nyagos.raweval("cmd", "/c", "set"):gmatch("([0-9a-zA-z_]+)=([^\r\n]+)")
end

local function load_envs(file)
  local file = nyagos.open(file, "r")
  if file == nil then
    return
  end
  for k, v in file:read("*a"):gmatch("([0-9a-zA-z_]+)=([^\r\n]+)") do
    nyagos.env[k] = v
  end
end

local function reset_envs()
  for k, _ in current_envs() do
    nyagos.env[k] = nil
  end
  for k, v in pairs(default_envs) do
    nyagos.env[k] = v
  end
end

local function get_localenv_files(dir)
  local files = {}
  local predir = ""
  while predir ~= dir do
    local file = nyagos.pathjoin(dir, ".localenv")
    if nyagos.access(file, 4) then
      table.insert(files, 1, file)
    end
    predir = dir
    dir = nyagos.dirname(dir)
  end
  return files
end

function module.regist_default_envs()
  for k, v in current_envs() do
    default_envs[k] = v
  end
end

function module.load()
  local wd = nyagos.getwd()
  local files = get_localenv_files(wd)
  local last_index = nil
  if last_localenv_file ~= nil then
    last_index = find(files, last_localenv_file)
    if last_index == nil then
      reset_envs()
    end
  end
  if #files == 0 then
    last_localenv_file = nil
    return
  end
  for _, file in next, files, last_index do
    load_envs(file)
    last_localenv_file = file
    print("load: " .. file)
  end
end

return module
