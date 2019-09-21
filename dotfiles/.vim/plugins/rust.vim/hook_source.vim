let s:ctags_cmd = 'ctags -R'
      \ . ' --options='.expand('<sfile>:p:h').'/ctags'
      \ . ' -h .rs'
      \ . ' --languages=Rust'
      \ . ' -f tags'

let g:rustfmt_autosave = 0
let g:rustfmt_command = expand('$CARGO_HOME/bin/rustfmt')
let g:syntastic_rust_checkers = ['cargo']

let s:sysroot = substitute(system('rustc --print sysroot'), '\n', '', 'g')

let $RUST_SRC_PATH = expand(s:sysroot . '/lib/rustlib/src/rust/src')

if !filereadable(expand('$RUST_SRC_PATH/tags'))
  let s:cwd = getcwd()
  silent! exec ":chdir" expand('$RUST_SRC_PATH')
  call vimproc#system(s:ctags_cmd)
  silent! exec ":chdir" s:cwd
endif

function! s:ctags_libs()
  let l:cargo = expand('$CARGO_HOME/bin/cargo')

  call system(l:cargo . ' update')

  let l:metadata = json_decode(system(l:cargo.' metadata --format-version=1'))
  let l:dirs = map(l:metadata['packages'],
               \ {k,v -> substitute(v['manifest_path'], '\\[^\\]*$', '', '')})

  let l:cwd = getcwd()
  for directory in l:dirs
    if !filereadable(directory.'/tags')
      silent! exec ":chdir" directory
      call vimproc#system(s:ctags_cmd)
    endif
  endfor
  silent! exec ":chdir" l:cwd

  let l:tags = map(l:dirs, {k,v -> v.'/tags'})
  silent! exec ":setlocal tags+=" . join(l:tags, ',')
endfunction

augroup rust_tags
  autocmd!
  autocmd FileType rust setlocal tags=$RUST_SRC_PATH/tags
  autocmd FileType rust call s:ctags_libs()
  autocmd BufWritePost *.rs call vimproc#system(s:ctags_cmd . ' src')
augroup END
