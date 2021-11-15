let s:script_dir = expand('<sfile>:p:h')
let s:snippets = globpath(&runtimepath, 'neosnippets', 1, 1)
call add(s:snippets, s:script_dir.'/snippets')

call deoppet#initialize()
call deoppet#custom#option('snippets',
      \ map(s:snippets, { _, val -> { 'path': val } }))

imap <C-k>  <Plug>(deoppet_expand)
imap <C-f>  <Plug>(deoppet_jump_forward)
imap <C-b>  <Plug>(deoppet_jump_backward)
smap <C-f>  <Plug>(deoppet_jump_forward)
smap <C-b>  <Plug>(deoppet_jump_backward)
