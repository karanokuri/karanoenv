lua << EOF
require('mini.cursorword').setup({})
require('mini.pairs').setup({})
require('mini.surround').setup({})
require('mini.trailspace').setup({})
EOF

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" base16

luafile <sfile>:p:h/base16.lua

hi MatchParen ctermfg=228 ctermbg=101 cterm=bold guifg=#eae788 guibg=#857b6f gui=bold

execute "set colorcolumn=" . join(range(81,335), ',')
hi ColorColumn guibg=#262626 ctermbg=235
