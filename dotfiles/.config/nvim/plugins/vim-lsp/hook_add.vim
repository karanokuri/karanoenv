let g:lsp_diagnostics_echo_delay = 1000
let g:lsp_log_verbose = 0
let g:lsp_log_file = ""

augroup vim_lsp
  autocmd!
  autocmd BufRead * nmap <buffer> <f2> <plug>(lsp-rename)
  autocmd BufRead * nmap <buffer> <C-]> :vsp<CR> :LspDefinition<CR>
  " autocmd BufWritePre * LspDocumentFormatSync
augroup END
