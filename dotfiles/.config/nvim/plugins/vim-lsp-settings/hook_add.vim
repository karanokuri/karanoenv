let s:script_dir = expand('<sfile>:p:h')

let g:lsp_settings_servers_dir = expand("~/.cache/lsp_settings")
let g:lsp_settings_filetype_typescript = [
      \ 'deno',
      \ 'typescript-language-server',
      \ 'efm-langserver'
      \ ]

let g:lsp_settings = {
      \ 'efm-langserver': {
      \   'args': ['-c='.s:script_dir.'/efm-langserver-config.yml'],
      \   'disabled': v:false,
      \   'allowlist': ['typescript', 'typescriptreact'],
      \   'blocklist': empty(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'node_modules/'))
      \     ? ['typescript', 'typescriptreact']
      \     : []
      \   }
      \ }
