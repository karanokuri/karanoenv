if not nyagos then
  print("This is a script for nyagos not lua.exe")
  os.exit()
end

local module = {}

local function is_absolute_path(dir)
  return dir:match("^/") or dir:match("^(\\|[A-Z]:)")
end

function module.is_gitdir(path)
  local stat = nyagos.stat(path)
  if stat == nil then
    return false
  end
  if stat.name ~= ".git" then
    return false
  end
  if stat.isdir then
    return true
  end
  local file = nyagos.open(path, "r")
  if file == nil then
    return false
  end
  local line = file:read("*l")
  if not line:match("^gitdir: ") then
    return false
  end
  local gitdir = line.sub(8)
  local abs_dir
  if is_absolute_path(gitdir) then
    abs_dir = gitdir
  else
    abs_dir = nyagos.pathjoin(nyagos.dirname(path), gitdir)
  end
  local stat = nyagos.stat(abs_dir)
  return stat ~= nil and stat.isdir
end

function module.gitdir(dir)
  local predir = ""
  while predir ~= dir do
    local gitdir = nyagos.pathjoin(dir, ".git")
    if module.is_gitdir(gitdir) then
      return gitdir
    end
    predir = dir
    dir = nyagos.dirname(dir)
  end
  return nil
end

function module.current_branch(gitdir)
  local file = nyagos.open(nyagos.pathjoin(gitdir, "HEAD"), "r")
  if file == nil then
    return nil
  end
  return file:read("*l"):sub(17)
end

return module
