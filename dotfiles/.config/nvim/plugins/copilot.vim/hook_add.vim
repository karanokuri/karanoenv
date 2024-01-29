let g:copilot_no_tab_map = v:true

let g:copilot_filetypes = #{
      \   gitcommit: v:true,
      \   markdown: v:true,
      \   text: v:true,
      \   ddu-ff-filter: v:false,
      \ }

inoremap <silent><expr> <C-s> copilot#Accept("<CR>")
