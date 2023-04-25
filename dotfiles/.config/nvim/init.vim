let $NVIM_CONFIG_DIR = expand('<sfile>:p:h')

let mapleader = "\<Space>"
set clipboard+=unnamed
set foldmethod=marker
set list
set listchars=tab:»-,extends:»,precedes:«,nbsp:%
set mouse=a
set noundofile
set number
set signcolumn=yes
set termguicolors
set wildignore+=vendor/**,.bundle/**,.git/**,node_modules/**

colorscheme evening

"---------------------------------------------------------------------------
" Terminal

tnoremap <Esc> <C-\><C-n>

"---------------------------------------------------------------------------
" Clipboard

noremap! <S-Insert> <C-R>+

"---------------------------------------------------------------------------
" Encoding

set encoding=utf-8
set fileencodings=utf-8,cp932,utf-16,iso-2022-jp,euc-jp

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
  let g:python_host_prog = expand('$KARANOENV_APPS_DIR/pyenv/pyenv-win/versions/neovim-2/python.exe')
  let g:python3_host_prog = expand('$KARANOENV_APPS_DIR/pyenv/pyenv-win/versions/neovim-3/python.exe')
endif

"---------------------------------------------------------------------------
" zenhan for VS Code Neovim
if exists('g:vscode') && executable('zenhan')
  augroup zenhan
    autocmd!
    autocmd InsertLeave * :call system('zenhan 0')
    autocmd CmdlineLeave * :call system('zenhan 0')
  augroup END
endif

"---------------------------------------------------------------------------
" dein

if executable('git')
  let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
  let s:dein_dir = s:cache_home . '/dein'
  let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
  let s:toml_file = expand('$NVIM_CONFIG_DIR/dein.toml')

  let g:dein#install_process_timeout = 3600

  if !isdirectory(s:dein_repo_dir)
    call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
  endif
  let &runtimepath = s:dein_repo_dir . ',' . &runtimepath
  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    call dein#load_toml(s:toml_file)
    call dein#end()
    call dein#save_state()
  endif
  if dein#check_install()
    call dein#install()
  endif
endif
