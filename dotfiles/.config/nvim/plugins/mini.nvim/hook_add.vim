lua << EOF
require('mini.base16').setup({
  palette = {
    -- Default Background
    base00 = "#181818",
    -- Lighter Background (Used for status bars, line number and folding marks)
    base01 = "#282828",
    -- Selection Background
    base02 = "#383838",
    -- Comments, Invisible, Line Highlighting
    base03 = "#9c998e",
    -- Dark Foreground (Used for status bars)
    base04 = "#b8b8b8",
    -- Default Foreground, Caret, Delimiters, Operators
    base05 = "#d8d8d8",
    -- Light Foreground (Not often used)
    base06 = "#e8e8e8",
    -- Light Background (Not often used)
    base07 = "#f8f8f8",
    -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base08 = "#ab4642",
    -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base09 = "#dc9656",
    -- Classes, Markup Bold, Search Text Background
    base0A = "#f7ca88",
    -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0B = "#a1b56c",
    -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0C = "#86c1b9",
    -- Functions, Methods, Attribute IDs, Headings
    base0D = "#7cafc2",
    -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0E = "#ba8baf",
    -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    base0F = "#a16946",
  },
  use_cterm = true,
})
require('mini.cursorword').setup({})
require('mini.pairs').setup({})
require('mini.surround').setup({})
require('mini.trailspace').setup({})
EOF

hi MatchParen ctermfg=228 ctermbg=101 cterm=bold guifg=#eae788 guibg=#857b6f gui=bold

execute "set colorcolumn=" . join(range(81,335), ',')
hi ColorColumn guibg=#262626 ctermbg=235
