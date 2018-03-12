set nocompatible
filetype indent on
filetype plugin on
let mapleader=","
set wrap
set title
set nobackup
set noswapfile
set hlsearch
set autochdir
set hidden

"Fixing arrow keys
noremap <silent> <C-[>OC <Right>|
inoremap <silent> <C-[>OD <Left>|
inoremap <silent> <C-[>OB <Down>|
inoremap <silent> <C-[>OA <Up>|

map <Up> <Nop>
map <Down> <Nop>
map <Left> <Nop>
map <Right> <Nop>

nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader><Tab> :tablast<cr>

nnoremap j gj
nnoremap k gk

set backspace=indent,eol,start
set number relativenumber
syntax on
set guifont=Source\ Code\ Pro
set term=screen-256color

nnoremap <esc> :noh<return><esc>

set list
"hi SpecialKey ctermbg=NONE guifg=NONE
set showbreak=↪\
set listchars=tab:\ \ ,eol:↲,nbsp:␣,extends:⌘,precedes:⛌
noremap <C-x> :bd<CR>

set noshowmode

noremap <silent> <C-E> :Lexplore<CR>
" Making netrw liststyle default
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 3
let g:netrw_winsize = 20
let g:netrw_altv = 1

set laststatus=2
if !has('gui_running')
	set t_Co=256
	" colorscheme vividchalk
endif

call plug#begin('~/.vim/plugs')

Plug 'tpope/vim-fugitive'

Plug 'NLKNguyen/papercolor-theme'
set background=dark
let g:PaperColor_Theme_Options = {
		\ 'theme': {
			\ 'default': {
			\ 'override': {
			\ 'linenumber_bg': ['#000000', '232'],
			\},
			\ 'transparent_background': 1
		\}
	\}
\}
colorscheme PaperColor
set laststatus=2
highlight Normal guibg=NONE ctermbg=NONE
highlight NonText ctermbg=NONE

" Plug 'dikiaap/minimalist'
" set t_Co=256
" syntax on
" colorscheme minimalist

Plug 'mattn/emmet-vim', {'for': 'html,ejs'}
let g:user_emmet_leader_key='<C-Z>'

Plug 'tpope/vim-surround'

"Plug 'scrooloose/syntastic'
"autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_error_symbol = "✗"
"let g:syntastic_css_checkers = ['csslint', 'prettycss']
"let g:syntastic_html_checkers = ['tidy', 'jshint']
"let g:syntastic_html_tidy_exec = 'tidy5'
"let g:syntastic_javascript_checkers = ['eslint', 'jsxhint']
"let g:syntastic_json_checkers = ['jsonlint']
"let g:syntastic_php_checkers = ['php', 'phplint']
"let g:syntastic_python_checkers = ['flake8', 'pylint']
"let g:syntastic_scss_checkers = ['sass']
"let g:syntastic_typescript_checkers = ['tslint', 'tsc']

Plug 'ervandew/supertab'

Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:ycm_key_list_select_completion=['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion=['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType='<C-n>'

Plug 'kien/ctrlp.vim'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode='ra'
nnoremap <Leader>p :CtrlPBuffer<CR>
inoremap <Leader>p <Esc>:CtrlPBuffer<CR>
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist|bin)|\.(git|hg|svn)$'

Plug 'vim-airline/vim-airline'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#whitespace#enabled = 0
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme ="luna"
"let g:airline_theme ="distinguished"
" let g:airline_solarized_bg='dark'
"let g:airline_theme = "powerlineish"

Plug 'w0rp/ale'
let g:ale_linters = { 'javascript': ['eslint', 'jshint'] }
let g:ale_linters = { 'html': ['tidy'] }
let g:ale_linters = { 'json': ['jsonlint'] }
let g:ale_linters = { 'php': ['phpcs'] }
let g:ale_linters = { 'scss': ['sass-lint'] }
let g:ale_linters = { 'css': ['csslint', 'stylelint'] }
let g:ale_linters = { 'typescript': ['eslint', 'tslint', 'tsserver', 'prettier'] }

let g:airline#extensions#ale#enabled = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_sign_error='✗'
let g:ale_sign_warning='--'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_completion_enabled = 1
"nmap <silent> <leader>an :ALENext<cr>
"nmap <silent> <leader>ap :ALEPrevious<cr>
nmap <silent> an <Plug>(ale_previous_wrap)
nmap <silent> ne <Plug>(ale_next_wrap)
highlight ALEError ctermbg=DarkMagenta

Plug 'valloric/youcompleteme'

Plug 'pangloss/vim-javascript'
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

"Plug 'ternjs/tern_for_vim'
"let g:tern_show_argument_hints='on_hold'
"let g:tern_map_keys=1

"Plug 'scrooloose/nerdcommenter'
"inoremap <C-_> <C-o>: call NERDComment(0,"toggle")<C-m>
"nmap <C-_> :call NERDComment(0,"toggle")<Enter>

Plug 'tpope/vim-commentary'
map <C-_> gcc

Plug 'Valloric/MatchTagAlways'
highlight MatchTag ctermfg=black ctermbg=lightgreen guifg=lightgreen

let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"

Plug 'ap/vim-css-color'

Plug 'jiangmiao/auto-pairs'

Plug 'Chiel92/vim-autoformat'
nnoremap <C-F> :Autoformat<CR>
inoremap <C-F> <Esc>:Autoformat<CR>a

Plug 'tpope/vim-abolish'

Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
let g:typescript_indent_disable = 1
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''

Plug 'tpope/vim-sensible'

call plug#end()
