let g:user_emmet_mode = 'i'
"let g:user_emmet_leader_key='<C-E>'
let g:use_emmet_complete_tag = 0
let g:user_emmet_settings = {
  \   'variables': {
  \       'lang': "ja"
  \   },
  \   'indentation': '  '
  \ }

imap <buffer><expr><S-tab>
    \ emmet#isExpandable() ? "\<plug>(emmet-expand-abbr)" : "\<tab>"
