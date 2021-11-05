let g:lsp_diagnostics_echo_delay = 1000
let g:lsp_diagnostics_enabled = 1
let g:lsp_log_file = ""
let g:lsp_log_verbose = 0

function! s:on_lsp_buffer_enabled() abort
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> <leader>ca <plug>(lsp-code-action)
  nmap <buffer> <leader>r <plug>(lsp-rename)
  nmap <buffer> <leader>e <plug>(lsp-document-diagnostics)
  nmap <buffer> K <plug>(lsp-hover)

  let g:lsp_format_sync_timeout = 1000
  autocmd! BufWritePre * call execute('LspDocumentFormatSync')
endfunction

augroup vim_lsp
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
