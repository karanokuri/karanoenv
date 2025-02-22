let s:script_dir = expand('<sfile>:p:h')

let g:lsp_settings_enable_suggestions = 0
let g:lsp_settings_servers_dir = expand("~/.cache/lsp_settings")

function! s:lsp_settings_filetype_typescript() abort
  return empty(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'node_modules/'))
    \ ? ['deno']
    \ : ['typescript-language-server', 'biome']
endfunction

let g:lsp_settings_filetype_typescript      = [function("s:lsp_settings_filetype_typescript")]
let g:lsp_settings_filetype_typescriptreact = [function("s:lsp_settings_filetype_typescript")]

let g:lsp_settings = {
      \ 'rust-analyzer': {
      \   'initialization_options': {
      \     'check': {
      \       'command': 'clippy'
      \       }
      \     }
      \   },
      \ }
