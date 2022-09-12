local completion_dir = debug.getinfo(1).source:match("@?(.*/)") .. "/completion"
local completion_files = nyagos.fields(nyagos.eval("__ls__ "..completion_dir.."/*.lua"))

for _, file in ipairs(completion_files) do
  dofile(file)
end
