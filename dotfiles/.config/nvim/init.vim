let $NVIM_CONFIG_DIR = expand('<sfile>:p:h')

set noundofile
set number
set foldmethod=marker

colorscheme evening

"---------------------------------------------------------------------------
" Clipboard

noremap! <S-Insert> <C-R>+

"---------------------------------------------------------------------------
" Encoding

set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis

"---------------------------------------------------------------------------
" Filetypes

augroup vagrant
  au!
  au BufRead,BufNewFile Vagrantfile set filetype=ruby
augroup END
 
" "---------------------------------------------------------------------------
" " Tags
" 
" set tags+=.tags
" nnoremap <C-]> :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>
" nnoremap <C-k> :split<CR> :exe("tjump ".expand('<cword>'))<CR>
 
"---------------------------------------------------------------------------
" Indent

set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent
 
" "---------------------------------------------------------------------------
" " Backup
" 
" let s:backup_dir = expand('~/.backup')
" 
" set backup
" set writebackup
" exec "set backupdir=".s:backup_dir
" au BufWritePre * let &bex = '.' . strftime("%Y%m%d_%H%M")
" 
" if !isdirectory(s:backup_dir)
"   call mkdir(s:backup_dir, "p")
" endif
 
" "---------------------------------------------------------------------------
" " 80桁以上に色を付ける
" 
" noremap <Plug>(ToggleColorColumn)
"             \ :<c-u>let &colorcolumn = len(&colorcolumn) > 0
"             \ ? '' : join(range(81, 9999), ',')<CR>
"  
" nmap cc <Plug>(ToggleColorColumn)
 
"---------------------------------------------------------------------------
" python

if has('win32')
  let g:python3_host_prog = expand('$KARANOENV_APPS_DIR/python3/python.exe')
endif

"---------------------------------------------------------------------------
" dein

if executable('git')
  let s:dein_dir = expand('~/.cache/dein')
  let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
  let g:rc_dir    = expand('$NVIM_CONFIG_DIR/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  let g:dein#install_process_timeout = 3600

  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  let &runtimepath = &runtimepath.','.s:dein_repo_dir

  call dein#begin(s:dein_dir, [s:toml, s:lazy_toml])

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()

  if dein#check_install()
    call dein#install()
  endif
endif
