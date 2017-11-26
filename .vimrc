filetype indent on
filetype plugin on
filetype indent on
set nocompatible
set autoread
" setting a clipboard, similar to windows;
let &clipboard = has('unnamedplus') ? 'unnamedplus' : 'unnamed'
vm <c-x> "+x
vm <c-c> "+y
cno <c-v> <c-r>+
exe 'ino <script> <C-V>' paste#paste_cmd['i']

" save with ctrl+s
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

set backspace=indent,eol,start
set number
"set relativenumber
syntax on
set guifont=Source\ Code\ Pro
set term=screen-256color

vmap <Tab> >gv
vmap <S-Tab> <gv

set incsearch
set hlsearch
set autoread
nnoremap <esc> :noh<return><esc>
"set textwidth=80
"set colorcolumn=80
"highlight ColorColumn ctermbg=lightgray guibg=lightgray

set list
hi SpecialKey ctermbg=NONE guifg=NONE
set showbreak=↪\ 
set listchars=tab:\ \ ,eol:↲,nbsp:␣,extends:⟩,precedes:⟨

noremap <C-b> :bd<CR>
inoremap <C-o> <Enter><Enter><Esc>ka
noremap <C-o> i<Enter><Enter><Esc>ka
inoremap <Space><Space> <Esc>/<++><Enter>"_c4l
"autocmd FileType html inoremap ;h1 <h1></h1><Esc>FhT>i
"autocmd FileType html inoremap ;p <p></p><Esc>FpT>i
"autocmd FileType html inoremap ;.d <div class=""><++></div><Esc>F"T>i
"autocmd FileType html inoremap ;html <html><Enter><head><Enter><title><++></title><Enter></head><Enter><body><Enter><++><Enter></body><Enter></html><Esc>i
"autocmd FileType html inoremap ;#d <div id=""><++></div><Esc>F"T>i
"autocmd FileType javascript inoremap { {<Enter><Enter>}<Esc>F}T>i
"autocmd FileType typescript inoremap { {<Enter><Enter>}<Esc>F}T>i
"autocmd FileType javascript inoremap ( ()<Esc>F)T>i
"autocmd FileType javascript inoremap ;func function <++>(<++>){<Enter><++><Enter>}
"inoremap ( (<++>)
"inoremap { {<++>}
"inoremap [ [<CR>]<Esc>ko
"inoremap { {<CR>}<Esc>ko
"autocmd FileType css inoremap { {<Enter><++><Enter>}

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" Plugin 'itchyny/lightline.vim'
set laststatus=2
if !has('gui_running')
	set t_Co=256
	colorscheme dracula
endif
set noshowmode
"let g:lightline ={
"\	'colorscheme': 'Dracula'
"\}

Plugin 'scrooloose/nerdtree'
"nmap <Leader>n :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

Plugin 'mattn/emmet-vim'
let g:user_emmet_leader_key='<C-Z>'

Plugin 'tpope/vim-surround'

Plugin 'flazz/vim-colorschemes'

Plugin 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_css_checkers = ['csslint', 'prettycss']
let g:syntastic_html_checkers = ['tidy', 'jshint']
let g:syntastic_html_tidy_exec = 'tidy5'
let g:syntastic_javascript_checkers = ['eslint', 'jsxhint']
let g:syntastic_json_checkers = ['jsonlint']
let g:syntastic_php_checkers = ['php', 'phplint']
let g:syntastic_python_checkers = ['flake8', 'pylint']
let g:syntastic_scss_checkers = ['sass']
let g:syntastic_typescript_checkers = ['tslint', 'tsc']

Plugin 'ervandew/supertab'

Plugin 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:ycm_key_list_select_completion=['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion=['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType='<C-n>'

Plugin 'honza/vim-snippets'

Plugin 'kien/ctrlp.vim'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode='ra'
nnoremap <Leader>p :CtrlPBuffer<CR>
inoremap <Leader>p <Esc>:CtrlPBuffer<CR>
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist|bin)|\.(git|hg|svn)$'
"let g:ctrlp_custom_ignore = {
"			\'dir': 'v[\/]\.(git|hg|svn)$',
"			\'file': '\v\.(exe|so|dll)$'
"			\}

"Plugin 'bling/vim-bufferline'

Plugin 'vim-airline/vim-airline'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#whitespace#enabled = 0
Plugin 'vim-airline/vim-airline-themes'
let g:airline_theme ="luna"
"let g:airline_theme = "powerlineish"

Plugin 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>

Plugin 'valloric/youcompleteme'

Plugin 'jelera/vim-javascript-syntax'

Plugin 'pangloss/vim-javascript'
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

Plugin 'easymotion/vim-easymotion'
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)

Plugin 'haya14busa/incsearch.vim'
Plugin 'haya14busa/incsearch-fuzzy.vim'
Plugin 'haya14busa/incsearch-easymotion.vim'
function! s:config_easyfuzzymotion(...) abort
	return extend(copy({
				\'converters': [incsearch#config#fuzzyword#converter()],
				\'modules': [incsearch#config#easymotion#module({'overwin':1})],
				\'keymap': {"\<CR>": '<Over>(easymotion)'},
				\'is_expr': 0,
				\'is_stay': 1
				\}), get(a:, 1, {}))
endfunction
noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())

Plugin 'ternjs/tern_for_vim'
let g:tern_show_argument_hints='on_hold'
let g:tern_map_keys=1

Plugin 'jeffkreeftmeijer/vim-numbertoggle'
nnoremap <silent> <C-n> :set relativenumber!<CR>

Plugin 'scrooloose/nerdcommenter'
inoremap <C-_> <C-o>: call NERDComment(0,"toggle")<C-m>
nmap <C-_> :call NERDComment(0,"toggle")<Enter>

Plugin 'Shutnik/jshint2.vim'
" Run JSHINT when a file with .js extension is saved.
autocmd BufWritePost *.js silent :JSHint
nnoremap <silent><F1> :JSHint<CR>
inoremap <silent><F1> <C-O>:JSHint<CR>

Plugin 'Valloric/MatchTagAlways'
highlight MatchTag ctermfg=black ctermbg=lightgreen guifg=lightgreen
set cursorline
hi CursorLine term=bold cterm=bold guibg=Grey40

Plugin 'mhinz/vim-startify'

" vim-lastplace config
let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"

Plugin 'ap/vim-css-color'

Plugin 'hail2u/vim-css3-syntax'

Plugin 'jiangmiao/auto-pairs'

Plugin 'juanwolf/browserlink.vim'

"Plugin 'zeekay/vim-beautify'

Plugin 'Chiel92/vim-autoformat'
nnoremap <C-F> :Autoformat<CR>
inoremap <C-F> <Esc>:Autoformat<CR>a

Plugin 'tpope/vim-fugitive'

Plugin 'tpope/vim-abolish'

noremap <silent> <C-E> :Lexplore<CR>
" Making netrw liststyle default
let g:netrw_liststyle = 3
" Removing useless banner at top
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 20
let g:netrw_altv = 1
"set textwidth=80
"highlight ColorColumn ctermbg=red guibg=red
"set colorcolumn=+1
set noshowmode

call vundle#end()
