nyagos.option.glob = true

-- Set environment variables --------------------------------------------------
set{
  HOME          = nyagos.env.USERPROFILE,

  EDITOR        = "nvim-qt.exe",
  LESSCHARSET   = "utf-8",

  PATHEXT       = ".COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC",
}

addpath "%HOME%\\.bin"
for i,v in pairs(nyagos.glob(nyagos.env.HOME.."\\.tools\\*")) do
  path = nyagos.pathjoin(v, "bin")
  if nyagos.access(path, 0) then addpath(path) end
end

-- aliases --------------------------------------------------------------------
nyagos.alias.l  = "ls"
nyagos.alias.ll  = "ls -l"

nyagos.alias.git = "lab"

nyagos.alias.vim  = "cmd /c start gvim"
nyagos.alias.gvim = "cmd /c start gvim"

nyagos.alias.nvim = "cmd /c start nvim-qt"

-- Set Prompt ----------------------------------------------------------------
-- code from 'http://lua-users.org/wiki/SplitJoin'
share.split = function (str, pat)
    local t = {}
    local fpat = "(.-)"..pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t,cap)
        end
        last_end = e+1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end

-- code from https://qiita.com/JugernautOnishi/items/aae90e9bbbd897c0d5ed
share.gis = function ()
  local gs = {}
  local c  = {}
  c.dc     = "$e[36;40;1m" -- default color
  c.bc     = "$e[33;1m" -- brunch color
  c.ok     = "$e[32;1m✔"
  c.okc    = "$e[32;1m" -- color only
  c.ng     = "$e[31;1m○"
  c.ngc    = "$e[31;1m" -- color only

  gs.gitbool = nyagos.eval('git.exe rev-parse --is-inside-work-tree 2>nul')
  if gs.gitbool ~= 'true' then
    return false
  end
  --nyagos.evalは出力をtrimする(?)ので--branch必須
  gs.gitst = nyagos.eval('git.exe status --porcelain --branch 2>nul')
  local t = {}
  t = share.split(gs.gitst, "\n")
  for i, v in ipairs(t) do
    if i == 1 then
      gs.remote = v:match("^##.*")
      -- ahead or behind
      if gs.remote then
        -- local branch name
        gs.lbn = nyagos.eval("git.exe rev-parse --abbrev-ref HEAD 2>nul")
        -- remote branch name
        gs.rbn = gs.remote:match("%.%.%.(%w*/%S+)") or c.ng.."/"..gs.lbn
        gs.bst = gs.remote:match("%[.*%]")
        if gs.bst then
          local ab = gs.bst:gsub("[%[%]]", "")
          ab = share.split(ab, ",")
          for i, v in ipairs(ab) do
            local oltab = share.split(v," ")
            local lastlng = oltab[2] == "1" and " commit." or " commits."
            if oltab[1] == "ahead" then
              -- ahead
              gs.ahead = c.ngc..oltab[1].." "..c.ngc..oltab[2]..lastlng
              gs.push = c.ng
            elseif oltab[1] == "behind" then
              -- behind
              gs.behind = c.ngc..oltab[1].." "..c.ngc..oltab[2]..lastlng
              gs.pull = c.ng
            end
            gs.ahead = gs.ahead or ""
            gs.behind = gs.behind or ""
            gs.synced = gs.synced or ""
          end
        else
          gs.ahead = gs.ahead or ""
          gs.behind = gs.behind or ""
          if gs.rbn == c.ng.."/"..gs.lbn then
            gs.synced =  c.ng.."Not Yet Add Remote Repository!"
            gs.push = gs.push or c.bc.."-"
            gs.pull = gs.pull or c.bc.."-"
          else
            gs.synced = c.ok.."All Synced!"
            gs.push = gs.push or c.ok
            gs.pull = gs.pull or c.ok
          end
        end
      end
    else
      -- untrackcheck
      if gs.add ~= c.ng then
        gs.add = v:match("^%?%?") and c.ng or c.ok
      end
      -- modifycheck
      if gs.mod ~= c.ng then
        gs.mod = v:match("M%s[^%s]") and c.ng or c.ok
      end
      -- commitcheck
      if gs.commit ~= c.ng then
        gs.commit = v:match("[AM]%s%s") and c.ng or c.ok
      end
    end
  end
  gs.add = gs.add or c.ok
  gs.mod = gs.mod or c.ok
  gs.commit = gs.commit or c.ok
  gs.push = gs.push or c.ok
  gs.pull = gs.pull or c.ok
  gs.result = c.dc.."$_(Untrack:"..gs.add..c.dc.." Modify:"..gs.mod..c.dc.." Commit:"..gs.commit..c.dc.." Push:"..gs.push..c.dc.." Pull:"..gs.pull..c.dc..c.dc.." Branch:("..c.bc..gs.rbn..c.dc..")["..gs.ahead..gs.behind..gs.synced..c.dc.."]"..c.dc..")"
  return gs.result
end

-- Simple Prompt for CMD.EXE
nyagos.env.PROMPT="[$s$P$s]$_$$$s"

nyagos.env.BEEP_FLAG = 'off'
nyagos.alias.beep = function(args)
  if args[1] == 'on' or args[1] == 'off' then
    nyagos.env.BEEP_FLAG = args[1]
  elseif args[1] == nil then
    nyagos.env.BEEP_FLAG = (nyagos.env.BEEP_FLAG == 'on') and 'off' or 'on'
  end
end

share.initialized_env = nyagos.eval("cmd /c set")

-- Coloring Prompt for NYAGOS.exe
nyagos.prompt = function(this)
  local title = "NYAGOS - ".. nyagos.getwd():gsub('\\','/')

  local err_level = tonumber(nyagos.eval("echo %ERRORLEVEL%")) or 0

  local retv = "$sExit:$s"..err_level.."$s"
  local date = "$s"..(os.date("%Y-%m-%d %H:%M:%S")).."$s"
  local beep = "$sBeep:$s"..(nyagos.env.BEEP_FLAG).."$s"
  local info = '['..retv..'|'..date..'|'..beep..']'

  local color = (err_level == 0) and "$_$e[36;40;1m" or "$_$e[35;40;1m"

  local pts = color..info..'[$s$P$s]'..(share.gis() or '')..'$e[37;1m$_$$$s'

  if nyagos.env.BEEP_FLAG == 'on' then
    nyagos.eval("rundll32 user32.dll,MessageBeep")
  end

  -- load spesific environment variables on current directory
  local wd = nyagos.getwd()
  if share.curdir ~= wd then
    share.curdir = wd
    while not nyagos.access(".localenv.lua", 0) do
      nyagos.chdir("..")
      if nyagos.getwd() == wd then break end -- break if reach root dir
      wd = nyagos.getwd()
    end
    if share.loaded_env_dir ~= wd then
      for v in share.initialized_env:gmatch("[^\r\n]+") do set(v) end
      if nyagos.access(".localenv.lua", 0) then dofile(".localenv.lua") end
      share.loaded_env_dir = wd
    end
    nyagos.chdir(share.curdir)
  end

  return nyagos.default_prompt(pts, title)
end

-- environment variables expansion like $PATH and ${PATH}
-- http://qiita.com/nocd5/items/aa155e91a6eef58b3940
share._filter = nyagos.filter
nyagos.filter = function(cmdline)
  local post = cmdline:gsub('${([%w_()]+)}', '%%%1%%')
  post = post:gsub('$([%w_()]+)', '%%%1%%')
  return share._filter(post)
end

-- vim:set ft=lua: --
