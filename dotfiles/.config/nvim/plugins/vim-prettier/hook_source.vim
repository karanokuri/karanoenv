let g:prettier#autoformat = 1
let g:prettier#exec_cmd_path = expand(dein#get("vim-prettier").rtp . "/node_modules/.bin/prettier")
autocmd BufWritePre *.js,*.ts,*.tsx,*.vue,*.css,*.scss,*.json,*.md PrettierAsync
