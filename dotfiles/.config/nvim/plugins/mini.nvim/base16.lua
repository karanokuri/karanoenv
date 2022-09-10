-- https://zenn.dev/kawarimidoll/articles/c2367b1e2e0849
--
-- define base16 colorscheme palettes
local palettes = {
  -- from https://base16-project.github.io/base16-gallery/
  ayu_mirage = {
    base00 = "#171B24", base01 = "#1F2430",
    base02 = "#242936", base03 = "#707A8C",
    base04 = "#8A9199", base05 = "#CCCAC2",
    base06 = "#D9D7CE", base07 = "#F3F4F5",
    base08 = "#F28779", base09 = "#FFAD66",
    base0A = "#FFD173", base0B = "#D5FF80",
    base0C = "#95E6CB", base0D = "#5CCFE6",
    base0E = "#D4BFFF", base0F = "#F29E74",
  },
  catppuccin = {
    base00 = "#1E1E28", base01 = "#1A1826",
    base02 = "#302D41", base03 = "#575268",
    base04 = "#6E6C7C", base05 = "#D7DAE0",
    base06 = "#F5E0DC", base07 = "#C9CBFF",
    base08 = "#F28FAD", base09 = "#F8BD96",
    base0A = "#FAE3B0", base0B = "#ABE9B3",
    base0C = "#B5E8E0", base0D = "#96CDFB",
    base0E = "#DDB6F2", base0F = "#F2CDCD",
  },
  -- user original
  kawarimidoll = require('mini.base16').mini_palette('#1f1d24', '#8fecd9', 75),
}

local scheme_names = vim.tbl_keys(palettes)

-- :MiniScheme [scheme_name]
-- use colorscheme at random when command argument is empty
vim.api.nvim_create_user_command(
  'MiniScheme',
  function(opts)
    local key = opts.fargs[1]

    if vim.tbl_contains(scheme_names, key) then
      vim.g.scheme_name = key
    else
      math.randomseed(os.time())
      vim.g.scheme_name = scheme_names[math.random(#scheme_names)]
    end

    require('mini.base16').setup({
      palette = palettes[vim.g.scheme_name],
      use_cterm = true,
    })
  end,
  {
    nargs = '?',
    complete = function() return scheme_names end
  }
)

-- run :MiniScheme by VimEnter event
vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  pattern = '*',
  command = 'MiniScheme',
  once = true
})
