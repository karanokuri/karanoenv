"  dlang {{{ ------------------------------------------------------------------
function! s:dlang_syntastic_config()
  let g:syntastic_d_compiler_options = '-unittest'
  let g:syntastic_d_include_dirs     = ['.', 'src', 'source']

  execute "setlocal tags+=" . expand(system('dcvm tags'))

  if !filereadable('dub.sdl') && !filereadable('dub.json')
    return
  endif

  let l:ip = system('dub describe --import-paths')

  let g:syntastic_d_include_dirs = map(split(l:ip, '\n'), 'v:val[:-2]')
  " let g:syntastic_d_compiler_options = '-unittest -d '
  let g:syntastic_d_compiler_options = '-unittest '
      \ . substitute(
          \ system('dub describe --data=string-import-paths --data=versions'),
          \ '\n', '', 'g')
endfunction

augroup syntastic_d
  autocmd!
  autocmd BufWritePost *.d call vimproc#system('cmd /c "'
        \ . 'dscanner --ctags '
        \ . substitute(join(g:syntastic_d_include_dirs, ' '), '\\', '/', 'g')
        \ . ' > .tags"')
  autocmd FileType d call s:dlang_syntastic_config()
augroup END
"  }}}

"  java {{{ -------------------------------------------------------------------
let g:syntastic_java_checkers=['javac']
let g:syntastic_java_javac_config_file_enabled = 1
let g:syntastic_java_javac_options = 
      \ '-Xlint -J-Duser.language=ja -J-Dfile.encoding=UTF8'
"  }}}

"  golang {{{ -----------------------------------------------------------------
let g:syntastic_go_checkers = ['golint', 'govet', 'gometalinter']
let g:syntastic_go_gometalinter_args = ['--disable-all', '--enable=errcheck']
"  }}}

"  typescript {{{ -------------------------------------------------------------
let g:syntastic_typescript_checkers = ['tsc', 'lynt']
let g:syntastic_typescript_lynt_exec = './node_modules/.bin/lynt'
"  }}}
