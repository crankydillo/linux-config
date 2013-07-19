call pathogen#infect()
syntax on
filetype plugin indent on

set t_Co=256

if has("gui_running")
    colorscheme default
elseif &t_Co == 256
    colorscheme wombat256mod
endif

set pastetoggle=<F2>

set expandtab
set tabstop=8
set sw=4
set tw=80
set number

map + <C-w>+
map _ <C-w>-
map ( <C-w><
map ) <C-w>>

nnoremap <Right> <C-w>l
nnoremap <Left> <C-w>h
nnoremap <Up> <C-w>k
nnoremap <Down> <C-w>j

map <F3> :bp!<CR>
map <F4> :bn!<CR>
map <leader>e :NERDTreeToggle<CR>
nnoremap <silent> <leader>b :TMiniBufExplorer<CR>
nnoremap <silent> <leader>t :TlistToggle<CR>
map <F10> :Bclose<cr>
map <F11> :clo<cr>
map <F12> :bd<cr>
map <leader>x :silent 1,$!xmllint --format --recover - 2>/dev/null
map <leader>j :%!python3 -m json.tool

" Navigate quickfix list
map <F5> :cprevious<CR>
map <F6> :cnext<CR>

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" MiniBufExpl Colors
hi MBEVisibleActive ctermfg=green guifg=#A6DB29 guibg=fg
hi MBEVisibleChangedActive ctermfg=green guifg=#F1266F guibg=fg
hi MBEVisibleChanged ctermfg=green guifg=#F1266F guibg=fg
hi MBEVisibleNormal ctermfg=green guifg=#5DC2D6 guibg=fg
hi MBEChanged ctermfg=yellow guifg=#CD5907 guibg=fg
hi MBENormal ctermfg=lightgrey guifg=#808080 guibg=fg

command! -nargs=1 Find :call Find("<args>")
function! Find(name)
    "let l:list=system("find . -name '".a:name."' | perl -ne \"print \\\"$.\\t$_\\\"\"")
    "let l:list=system("find . -name '".a:name."' | grep -v \".svn/\" | perl -ne 'print \"$.\\t$_\"'")
    "let l:list=system("/cygwin/bin/find . -name '".a:name."' | ruby -ne 'puts \"#{$.}\\t#{$_}\"'")
    if has("win32") || has("win64")
        let l:list=system("/cygwin/bin/find . -iname '".a:name."' | grep -v \"\\(.class\\)\\|\\(.swp\\)\\|\\(.*~\\)\" | ruby1.9.1 -ne 'puts $_.sub(/../, \"\")'")
    else
        let l:list=system("find . -iname '".a:name."' | grep -v \"\\(.class\\)\\|\\(.swp\\)\\|\\(.*~\\)\" | ruby1.9.1 -ne 'puts $_.sub(/../, \"\")'")
    endif
    let l:entries = split(l:list)
    let l:dicts = []
    for entry in l:entries
        let file = substitute(entry, '\(.\{-}\)|.*', '\1', '')
        let dict = {
                    \ 'filename': entry,
                    \ 'lnum': '1',
                    \ 'col': '1',
                    \ 'text': '',
                    \ 'type': ''}
        call add(l:dicts, dict)
    endfor

    execute setloclist(0, l:dicts)
    lopen
endfunction

command! Bclose call <SID>BufcloseCloseIt()

function! <SID>BufcloseCloseIt()
	let l:currentBufNum = bufnr("%")
	let l:alternateBufNum = bufnr("#")

	if buflisted(l:alternateBufNum)
		buffer #
	else
		bnext
	endif

	if bufnr("%") == l:currentBufNum
		new
	endif

	if buflisted(l:currentBufNum)
		execute("bdelete ".l:currentBufNum)
	endif
endfunction

if has("vms")
    set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

