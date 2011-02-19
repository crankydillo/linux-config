" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2002 Sep 19
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set background=dark

" Sam's additions
set expandtab
set tabstop=8
set sw=4
set tw=0
set number
set guifont=Bitstream\ Vera\ Sans\ Mono\ 10
"set lines=50
"set columns=120
set guitablabel=%t

" Use .as for ActionScript files, not Atlas files.
au BufNewFile,BufRead *.as set filetype=actionscript

colorscheme samuel


" Compiling
map <F8> :make<CR>

" omni complete colors
hi Pmenu guibg=#99ccff ctermbg=darkgrey
hi PmenuSel ctermbg=lightgrey ctermfg=black

" NERDTree
let NERDTreeIgnore=['CVS', '\.vim$', '\~$']

" Minibufexplorer stuff
" for buffers that have NOT CHANGED and are NOT VISIBLE.
" MBENormal
" for buffers that HAVE CHANGED and are NOT VISIBLE
hi MBEChanged ctermfg=darkyellow guifg=darkorange
" for buffers that HAVE NOT CHANGED and are VISIBLE
hi MBEVisibleNormal ctermfg=green guifg=red
" for buffers that HAVE CHANGED and are VISIBLE
hi MBEVisibleChanged ctermfg=green guifg=red

let g:miniBufExplorerMoreThanOne= 2
let g:miniBufExplModSelTarget = 1

" Need the following for cygwin urxvt???
hi ErrorMsg ctermfg=white ctermbg=red

let g:SuperTabDefaultCompletionType="<c-x><c-u>"
let Tlist_Ctags_Cmd='/usr/bin/ctags-exuberant'

"let Tlist_Show_One_File = 1
let Tlist_Compact_Format = 1
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Use_Right_Window = 1
let Tlist_Sort_Type = "name"
let Tlist_Display_Tag_Scope = 0
let Tlist_Enable_Fold_Column = 0
let Tlist_GainFocus_On_ToggleOpen = 1

" Navigate quickfix list
map <F5> :cprevious<CR>
map <F6> :cnext<CR>
" Navigate location list errors
"-------------------------------------------------- 
"--------------------------------------------------
" map <F5> :lp<cr>
" map <F6> :lne<cr>
"-------------------------------------------------- 

" Resize windows
map + <C-w>+
map _ <C-w>-
map ( <C-w><
map ) <C-w>>


map <F3> :bp!<CR>
map <F4> :bn!<CR>
map <leader>e :NERDTreeToggle<CR>
nnoremap <silent> <leader>b :TMiniBufExplorer<CR>
nnoremap <silent> <leader>t :TlistToggle<CR>
map <F10> :Bclose<cr>
map <F11> :clo<cr>
map <F12> :bd<cr>
map <Right> <C-w>l
map <Left> <C-w>h
map <Up> <C-w>k
map <Down> <C-w>j
map <F2> :silent 1,$!xmllint --format --recover - 2>/dev/null
"cmap bc Bclose

" Put this into .vimrc or make it a plugin.
" Mapping :Bclose to some keystroke would probably be more useful.
" I like the way buflisted() behaves, but some may like the behavior
" of other buffer testing functions.

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

" Location List stuff
command! LocListToggle call LocListToggle()
function! LocListToggle()
    let bufferName = bufname("*Location*")
    echo bufferName . " TEST!"
    echo bufname(3)
    echo bufname(1)
    if len(bufferName) > 0
        echo "1"
    endif

    " last buffer number
    let l:NBuffers = bufnr("$")
    let l:i = 0                     " Set the buffer index to zero.
    " Loop through every buffer less than the total number of buffers.
    while(l:i <= l:NBuffers)
        let l:i = l:i + 1
        echo bufname(l:i)
    endwhile

endfunction

command! -nargs=1 Find :call Find("<args>")
function! Find(name)
    "let l:list=system("find . -name '".a:name."' | perl -ne \"print \\\"$.\\t$_\\\"\"")
    "let l:list=system("find . -name '".a:name."' | grep -v \".svn/\" | perl -ne 'print \"$.\\t$_\"'")
    "let l:list=system("/cygwin/bin/find . -name '".a:name."' | ruby -ne 'puts \"#{$.}\\t#{$_}\"'")
    if has("win32") || has("win64")
        let l:list=system("/cygwin/bin/find . -iname '".a:name."' | grep -v \"\\(.class\\)\\|\\(.swp\\)\\|\\(.*~\\)\" | ruby -ne 'puts $_.sub(/../, \"\")'")
    else
        let l:list=system("find . -iname '".a:name."' | grep -v \"\\(.class\\)\\|\\(.swp\\)\\|\\(.*~\\)\" | ruby -ne 'puts $_.sub(/../, \"\")'")
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


" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
    set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")
