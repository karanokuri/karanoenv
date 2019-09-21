function! VsplitVimShell()
	vs
	VimShell
endfunction
command! Vs :call VsplitVimShell()

let g:vimshell_prompt = "% "
let g:vimshell_secondary_prompt = "> "
let g:vimshell_user_prompt = 'getcwd()'
