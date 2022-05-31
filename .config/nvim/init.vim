let mapleader =","

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'junegunn/goyo.vim'
Plug 'jreybert/vimagit'
Plug 'lukesmithxyz/vimling'
Plug 'vimwiki/vimwiki'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'ap/vim-css-color'
Plug 'srcery-colors/srcery-vim'
Plug 'neoclide/coc.nvim'
call plug#end()

set title
set bg=dark
set go=a
set mouse=a
set nohlsearch
set clipboard+=unnamedplus
set noshowmode
set noruler
set laststatus=0
set noshowcmd

" Modified by me
set tabstop=4
set shiftwidth=4
set expandtab

set t_Co=256
colorscheme srcery

set guifont=Mononoki:h9

" Tab completion for Coc
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
" ==============

" Some basics:
	nnoremap c "_c
	set nocompatible
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number relativenumber
" Enable autocompletion:
	set wildmode=longest,list,full
" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Perform dot commands over visual blocks:
	vnoremap . :normal .<CR>
" Goyo plugin makes text more readable when writing prose:
	map <leader>f :Goyo \| set bg=light \| set linebreak<CR>
" Spell-check set to <leader>o, 'o' for 'orthography':
	map <leader>o :setlocal spell! spelllang=en_us<CR>
" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow splitright

" Nerd tree
	map <leader>n :NERDTreeToggle<CR>
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    if has('nvim')
        let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
    else
        let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
    endif

" vimling:
	nm <leader><leader>d :call ToggleDeadKeys()<CR>
	imap <leader><leader>d <esc>:call ToggleDeadKeys()<CR>a
	nm <leader><leader>i :call ToggleIPA()<CR>
	imap <leader><leader>i <esc>:call ToggleIPA()<CR>a
	nm <leader><leader>q :call ToggleProse()<CR>

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" Replace ex mode with gq
	map Q gq

" Check file in shellcheck:
	map <leader>s :!clear && shellcheck -x %<CR>

" Open my bibliography file in split
	map <leader>b :vsp<space>$BIB<CR>
	map <leader>r :vsp<space>$REFER<CR>

" Replace all is aliased to S.
	nnoremap S :%s//g<Left><Left>

" Compile document, be it groff/LaTeX/markdown/etc.
	map <leader>c :w! \| !compiler "<c-r>%"<CR>

" Open corresponding .pdf/.html or preview
	map <leader>p :!opout <c-r>%<CR><CR>

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
	autocmd VimLeave *.tex !texclear %

" Ensure files are read as what I want:
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	map <leader>v :VimwikiIndex<CR>
	let g:vimwiki_list = [{'path': '~/.local/share/nvim/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Enable Goyo by default for mutt writing
	autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
	autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo | set bg=light
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>

" Automatically deletes all trailing whitespace and newlines at end of file on save. & reset cursor position
 	autocmd BufWritePre * let currPos = getpos(".")
	autocmd BufWritePre * %s/\s\+$//e
	autocmd BufWritePre * %s/\n\+\%$//e
	autocmd BufWritePre *.[ch] %s/\%$/\r/e
  	autocmd BufWritePre * cal cursor(currPos[1], currPos[2])

" When shortcut files are updated, renew bash and ranger configs with new material:
	autocmd BufWritePost bm-files,bm-dirs !shortcuts
" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
	autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
" Recompile dwmblocks on config edit.
	autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif

" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
"" SNIPPETS
"
"" Navigating with guides
"	inoremap <Space><Tab> <Esc>/<++><Enter>"_c4l
"	vnoremap <Space><Tab> <Esc>/<++><Enter>"_c4l
"	map <Space><Tab> <Esc>/<++><Enter>"_c4l
"
"" LaTeX (Luke's)
"	" Word count:
"	autocmd FileType tex map <leader><leader>o :w !detex \| wc -w<CR>
"	" Code snippets
"	autocmd FileType tex inoremap ,fr \begin{frame}<Enter>\frametitle{}<Enter><Enter><++><Enter><Enter>\end{frame}<Enter><Enter><++><Esc>6kf}i
"	autocmd FileType tex inoremap ,fi \begin{fitch}<Enter><Enter>\end{fitch}<Enter><Enter><++><Esc>3kA
"	autocmd FileType tex inoremap ,exe \begin{exe}<Enter>\ex<Space><Enter>\end{exe}<Enter><Enter><++><Esc>3kA
"	autocmd FileType tex inoremap ,em \emph{}<++><Esc>T{i
"	autocmd FileType tex inoremap ,bf \textbf{}<++><Esc>T{i
"	autocmd FileType tex vnoremap , <ESC>`<i\{<ESC>`>2la}<ESC>?\\{<Enter>a
"	autocmd FileType tex inoremap ,it \textit{}<++><Esc>T{i
"	autocmd FileType tex inoremap ,ct \textcite{}<++><Esc>T{i
"	autocmd FileType tex inoremap ,cp \parencite{}<++><Esc>T{i
"	autocmd FileType tex inoremap ,glos {\gll<Space><++><Space>\\<Enter><++><Space>\\<Enter>\trans{``<++>''}}<Esc>2k2bcw
"	autocmd FileType tex inoremap ,x \begin{xlist}<Enter>\ex<Space><Enter>\end{xlist}<Esc>kA<Space>
"	autocmd FileType tex inoremap ,ol \begin{enumerate}<Enter><Enter>\end{enumerate}<Enter><Enter><++><Esc>3kA\item<Space>
"	autocmd FileType tex inoremap ,ul \begin{itemize}<Enter><Enter>\end{itemize}<Enter><Enter><++><Esc>3kA\item<Space>
"	autocmd FileType tex inoremap ,li <Enter>\item<Space>
"	autocmd FileType tex inoremap ,ref \ref{}<Space><++><Esc>T{i
"	autocmd FileType tex inoremap ,tab \begin{tabular}<Enter><++><Enter>\end{tabular}<Enter><Enter><++><Esc>4kA{}<Esc>i
"	autocmd FileType tex inoremap ,ot \begin{tableau}<Enter>\inp{<++>}<Tab>\const{<++>}<Tab><++><Enter><++><Enter>\end{tableau}<Enter><Enter><++><Esc>5kA{}<Esc>i
"	autocmd FileType tex inoremap ,can \cand{}<Tab><++><Esc>T{i
"	autocmd FileType tex inoremap ,con \const{}<Tab><++><Esc>T{i
"	autocmd FileType tex inoremap ,v \vio{}<Tab><++><Esc>T{i
"	autocmd FileType tex inoremap ,a \href{}{<++>}<Space><++><Esc>2T{i
"	autocmd FileType tex inoremap ,sc \textsc{}<Space><++><Esc>T{i
"	autocmd FileType tex inoremap ,chap \chapter{}<Enter><Enter><++><Esc>2kf}i
"	autocmd FileType tex inoremap ,sec \section{}<Enter><Enter><++><Esc>2kf}i
"	autocmd FileType tex inoremap ,ssec \subsection{}<Enter><Enter><++><Esc>2kf}i
"	autocmd FileType tex inoremap ,sssec \subsubsection{}<Enter><Enter><++><Esc>2kf}i
"	autocmd FileType tex inoremap ,st <Esc>F{i*<Esc>f}i
"	autocmd FileType tex inoremap ,beg \begin{DELRN}<Enter><++><Enter>\end{DELRN}<Enter><Enter><++><Esc>4k0fR:MultipleCursorsFind<Space>DELRN<Enter>c
"	autocmd FileType tex inoremap ,up <Esc>/usepackage<Enter>o\usepackage{}<Esc>i
"	autocmd FileType tex nnoremap ,up /usepackage<Enter>o\usepackage{}<Esc>i
"	autocmd FileType tex inoremap ,tt \texttt{}<Space><++><Esc>T{i
"	autocmd FileType tex inoremap ,bt {\blindtext}
"	autocmd FileType tex inoremap ,nu $\varnothing$
"	autocmd FileType tex inoremap ,col \begin{columns}[T]<Enter>\begin{column}{.5\textwidth}<Enter><Enter>\end{column}<Enter>\begin{column}{.5\textwidth}<Enter><++><Enter>\end{column}<Enter>\end{columns}<Esc>5kA
"	autocmd FileType tex inoremap ,rn (\ref{})<++><Esc>F}i
"
" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "

" Function for toggling the bottom statusbar:
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <leader>h :call ToggleHiddenAll()<CR>
" Load command shortcuts generated from bm-dirs and bm-files via shortcuts script.
" Here leader is ";".
" So ":vs ;cfz" will expand into ":vs /home/<user>/.config/zsh/.zshrc"
" if typed fast without the timeout.
source ~/.config/nvim/shortcuts.vim

" Colors HERE
"highlight Normal guifg=#dfdfdf ctermfg=15 guibg=#000000 ctermbg=none cterm=none
"highlight LineNr guifg=#dfdfdf ctermfg=8 guibg=#000000 ctermbg=none cterm=none
"highlight CursorLineNr guifg=#dfdfdf ctermfg=7 guibg=#000000 ctermbg=none cterm=none
"highlight VertSplit guifg=#dfdfdf ctermfg=0 guibg=#000000 ctermbg=none cterm=none
"highlight Statement guifg=#dfdfdf ctermfg=2 guibg=#000000 ctermbg=none cterm=none
"highlight Directory guifg=#dfdfdf ctermfg=4 guibg=#000000 ctermbg=none cterm=none
"highlight StatusLine guifg=#dfdfdf ctermfg=7 guibg=#000000 ctermbg=none cterm=none
"highlight StatusLineNC guifg=#dfdfdf ctermfg=7 guibg=#000000 ctermbg=none cterm=none
"highlight NERDTreeClosable guifg=#dfdfdf ctermfg=2 guibg=#000000 ctermbg=none cterm=none
"highlight NERDTreeOpenable guifg=#dfdfdf ctermfg=8 guibg=#000000 ctermbg=none cterm=none
"highlight Comment guifg=#dfdfdf ctermfg=4 guibg=#000000 ctermbg=none cterm=none
"highlight Constant guifg=#dfdfdf ctermfg=12 guibg=#000000 ctermbg=none cterm=none
"highlight Special guifg=#dfdfdf ctermfg=4 guibg=#000000 ctermbg=none cterm=none
"highlight Identifier guifg=#dfdfdf ctermfg=6 guibg=#000000 ctermbg=none cterm=none
"highlight PreProc guifg=#dfdfdf ctermfg=5 guibg=#000000 ctermbg=none cterm=none
"highlight String guifg=#dfdfdf ctermfg=12 guibg=#000000 ctermbg=none cterm=none
"highlight Number guifg=#dfdfdf ctermfg=1 guibg=#000000 ctermbg=none cterm=none
"highlight Function guifg=#dfdfdf ctermfg=1 guibg=#000000 ctermbg=none cterm=none
"highlight Visual guifg=#dfdfdf ctermfg=1 guibg=#000000 ctermbg=none cterm=none
