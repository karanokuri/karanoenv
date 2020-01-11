"  dlang {{{ ------------------------------------------------------------------
if has('win32')
  let s:dls_path = '$LOCALAPPDATA\dub\packages\.bin\dls-latest\dls.exe'
else
  let s:dls_path = '~/.dub/packages/.bin/dls-latest/dls'
endif

if !executable(expand(s:dls_path))
  call system('dub fetch dls && dub run dls:bootstrap')
endif
"  }}}

"  golang {{{ -----------------------------------------------------------------
let s:golangserver_path = $GOPATH.'/bin/go-langserver'

if !executable(expand(s:golangserver_path))
  call system('go get -u github.com/sourcegraph/go-langserver')
endif
"  }}}

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
      \ 'd': [s:dls_path],
      \ 'rust': ['$RUSTUP_HOME/bin/rustup', 'run', 'stable', 'rls'],
      \ 'go': [s:golangserver_path,
      \        '-format-tool', 'goimports',
      \        '-lint-tool', 'golint'],
      \ }
let g:LanguageClient_rootMarkers = {
      \ 'd': ['dub.json', 'dub.sdl'],
      \ 'rust': ['Cargo.toml'],
      \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> <C-]> :vsp<CR> :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
