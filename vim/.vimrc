" Setting leader key
let mapleader=","

" Certain vim settings
set nocompatible
filetype indent on
filetype plugin indent on
syntax on
set re=1
set shortmess=atOI
set ignorecase
set pumheight=20
set backspace=indent,eol,start
set number relativenumber
set guifont=Source\ Code\ Pro
set term=screen-256color
set list
set noshowmode
set wrap
set title
set nobackup
set noswapfile
set hidden
set clipboard=exclude:.*
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set wildmenu
set guifont=Monaco:h13
set completeopt=longest,menuone,preview
set laststatus=2
set ttyfast
set breakindent
set showcmd
" set showbreak=↳
" set showbreak=∥
set showbreak=\>\ 
" set synmaxcol=200
set wildcharm=<Tab>

" Set shell
" autocmd vimenter * let &shell='/bin/zsh -i'

" Remembering cursor position on file
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction
augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

autocmd VimResized * wincmd =
set autoread

augroup autoRead
  autocmd!
  autocmd CursorHold * silent! checktime
augroup END

" REMAPS ARE BELOW HERE
" reindent file
nnoremap <leader>f gg=G
" buffer commands
nmap <space>1 <Plug>BufTabLine.Go(1)
nmap <space>2 <Plug>BufTabLine.Go(2)
nmap <space>3 <Plug>BufTabLine.Go(3)
nmap <space>4 <Plug>BufTabLine.Go(4)
nmap <space>5 <Plug>BufTabLine.Go(5)
nmap <space>6 <Plug>BufTabLine.Go(6)
nmap <space>7 <Plug>BufTabLine.Go(7)
nmap <space>8 <Plug>BufTabLine.Go(8)
nmap <space>9 <Plug>BufTabLine.Go(9)
nmap <space>0 <Plug>BufTabLine.Go(10)
nnoremap <silent> <space>q :BD<CR>
nnoremap <silent> <c-c> :bd<CR>
" Setting copy into system clipboard
vmap <c-c> "+y
nnoremap <space>b :buffers<cr>:b<space>
nnoremap <c-w>> :vertical resize +15<CR>
nnoremap <c-w>< :vertical resize -15<CR>
nnoremap <c-w>- :resize -10<CR>
nnoremap <c-w>+ :resize +10<CR>
" Go to mark
nnoremap <leader><leader> '
nnoremap <Leader>cd :cd %:h<CR>
nnoremap <space>w :w<CR>
nnoremap <space>z :qa<CR>
nnoremap <space><space>w :only<CR> :wq<CR>
nnoremap <leader>n :cnext<CR>
nnoremap <leader>x :cprev<CR>
" nnoremap <space>d gd
" diff saved changes
nnoremap <space>df :w !diff % -<CR>
" Jumping lines!
noremap <space>k 20k
noremap <space>j 20j
" unsure if below is necessary for scrolling files, feels clunky
" noremap <c-e> @='10<c-v><c-e>'<cr>
" noremap <c-y> @='10<c-v><c-y>'<cr>
" More 'natural' movements
" nnoremap j gj
" nnoremap k gk
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
"Fixing arrow keys
noremap <silent> <C-[>OC <Right>|
inoremap <silent> <C-[>OD <Left>|
inoremap <silent> <C-[>OB <Down>|
inoremap <silent> <C-[>OA <Up>|
" Disabling arrow keys, purism!
map <Up> <Nop>
map <Down> <Nop>
map <Left> <Nop>
map <Right> <Nop>
" Switching windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" Terminal remaps
tnoremap <Esc> <C-W>N
" Operater pending maps
onoremap iq i'
onoremap iQ i"
onoremap aq a'
onoremap aQ a"
onoremap sq s'
onoremap sQ s"
onoremap , t,
vnoremap iq i'
vnoremap iQ i""
" REMAPS END
inoremap <C-J> <C-O>b
inoremap <C-K> <C-O>w
inoremap <C-E> <C-O>e

let g:ctrlp_use_caching = 0
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects
  " .gitignore
  " let g:ctrlp_user_command = 'Ag %s -l --nocolor -g "" --hidden --ignore-dir .git'
endif

if executable('rg')
  " Use rg over grep
  " set grepprg=rg

  " Use rg in CtrlP for listing files. Lightning fast and respects
  " .gitignore
  let g:ctrlp_user_command = 'rg --files --color=never %s'
endif

" nnoremap <c-F> :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 20
let g:netrw_altv = 1

if !has('gui_running')
  set t_Co=256
endif

call plug#begin('~/.vim/plugs')
" Plug 'shime/vim-livedown'

" Plug 'bagrat/vim-buffet'
Plug 'qpkorr/vim-bufkill'

Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/gv.vim'
" Flutter/Dart plugins
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'
Plug 'natebosch/vim-lsc', {'for': 'dart.js,dart'}
Plug 'natebosch/vim-lsc-dart'

" Plug 'JamshedVesuna/vim-markdown-preview'

" VUI for todo
Plug 'waldson/vui'

" vim websearch
Plug 'linluk/vim-websearch'

" Splitjoin
Plug 'AndrewRadev/splitjoin.vim'

" Dirvish for file navigation
Plug 'justinmk/vim-dirvish'

" Better searching
Plug 'markonm/traces.vim'

" Buffer realted plugs
Plug 'ap/vim-buftabline'

" Index searching
Plug 'henrik/vim-indexed-search'

" extending vim
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'
Plug 'ntpeters/vim-better-whitespace'

" coding related plugs
Plug 'w0rp/ale'
" Removing curr js plugins for jsx-improve, uncomment it later
" Plug 'pangloss/vim-javascript', {'for': 'javascript.js,js,javascript'}
" Plug 'mxw/vim-jsx', {'for': 'javascript.js,js,javascript'}
Plug 'jiangmiao/auto-pairs'
Plug 'jceb/emmet.snippets'
Plug 'honza/vim-snippets'
Plug 'fatih/vim-go'
" Disable for testing
" Plug 'Valloric/MatchTagAlways'
Plug 'chemzqm/vim-jsx-improve', {'for': 'javascript.jsx,jsx'}

" Sugaring
Plug 'mhinz/vim-signify'
Plug 'kshenoy/vim-signature'
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'RRethy/vim-hexokinase'

" utils
Plug 'Yggdroot/indentLine'
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips'
Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'embear/vim-localvimrc'
Plug 'kien/ctrlp.vim'

Plug 'taohexxx/lightline-buffer'

" Set UTF 8 for dev icons
set encoding=UTF-8
call plug#end()

" Vim settings to override some plugins settings
set cursorline
set noerrorbells
set visualbell
set smartcase

" Buftabline settings
let g:buftabline_show=1
let g:buftabline_numbers=2
let g:buftabline_indicators=1
highlight link BufTabLineCurrent LightlineLeft_normal_1
highlight link BufTabLineActive LightlineRight_normal_2
highlight link BufTabLineHidden LightlineRight_normal_2
nnoremap <leader>b :set nomore <Bar> :ls <Bar> :set more <CR>:b<Space>

" Buffet settings
" let g:buffet_powerline_separators = 1
" let g:buffet_separator = "|"

" indentLine settings
let g:indentLine_char = '|'

" Colorscheme options
colorscheme desertink
" colorscheme sourcerer
" colorscheme gruvbox
" set background=dark
" let g:gruvbox_underline = 1
" let g:gruvbox_italic = 1
" let g:gruvbox_undercurl = 1
" let g:gruvbox_contrast_dark = 'soft'

" Ultisnips configs along with a few other things
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-tab>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir="~/.vim/UltiSnips"
let g:SuperTabDefaultCompletionType = "<c-n>"
aug vimrc_ultisnips
  au!
  au VimEnter * au! UltiSnips_AutoTrigger
aug END

" Vim gutentags settings
set statusline+=%{gutentags#statusline()}
let g:gutentags_ctags_exclude = ["*.min.js", "*.min.css", "build", "vendor", ".git", "node_modules", "*.vim/bundle/*"]

" Fugitive mappings
nnoremap <space>gs :Gstatus<CR>
nnoremap <space>gb :Gblame<CR>
nnoremap <space>ga :Git add .<CR>
nnoremap <space>gc :Git commit -am "
nnoremap <space>gC :Gcommit --verbose<CR>
nnoremap <space>gp :!git push -u<CR>
nnoremap <leader>2 :diffget //2<CR>
nnoremap <leader>3 :diffget //3<CR>

" Signify chunk jumping
nmap <space>c <plug>(signify-next-hunk)
nmap <space>C <plug>(signify-prev-hunk)
omap ic <plug>(signify-motion-inner-pending)
xmap ic <plug>(signify-motion-inner-visual)
omap ac <plug>(signify-motion-outer-pending)
xmap ac <plug>(signify-motion-outer-visual)

" Local vimrc
let g:localvimrc_persistent=1

" CtrlP Settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode='ra'
let g:ctrlp_open_multiple_files='ri'
nnoremap <space>p :CtrlPBuffer<CR>
nnoremap <Leader><Leader>p :CtrlPTag<CR>
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*
" let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
" let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist|bin)|\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'

" Lightline settings for entire bar
let g:lightline={}
let g:lightline.colorscheme='wombat'
let g:lightline.component_function={
      \ 'gitbranch': 'fugitive#head',
      \ 'filetype': 'MyFiletype',
      \ 'fileformat': 'MyFileformat'
      \
      \}
let g:lightline.component_expand={
      \ 'linter_checking': 'lightline#ale#checking',
      \ 'linter_warnings': 'lightline#ale#warnings',
      \ 'linter_errors': 'lightline#ale#errors'
      \
      \}
let g:lightline.component_type={
      \ 'linter_checking': 'left',
      \ 'linter_warnings': 'warning',
      \ 'linter_errors': 'error'
      \
      \}
let g:lightline.active={
      \ 'left' : [ [ 'mode', 'paste'  ],
      \            [ 'gitbranch', 'readonly', 'relativepath', 'modified'  ] ],
      \ 'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings'  ],
      \            [ 'lineinfo'  ],
      \            [ 'gutentags', 'filetype', 'percent'  ] ]
      \
      \}
let g:lightline#ale#indicator_checking="\uf110 "
let g:lightline#ale#indicator_warnings="\uf071 "
let g:lightline#ale#indicator_errors="\uf05e "
function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ?
        \ &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction
function! MyFileformat()
  return winwidth(0) > 70 ?
        \ (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

" Ale configs
let g:ale_linters = {
\ 'javascript': ['eslint'],
\ 'html': ['tidy'],
\ 'json': ['jsonlint'],
\ 'php': ['phpcs'],
\ 'scss': ['sass-lint'],
\ 'css': ['csslint', 'stylelint'],
\ 'typescript': ['eslint', 'tslint', 'tsserver', 'prettier'],
\ 'dart': ['language_server'],
\ }
" let g:ale_sign_error='●'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_sign_error='✗'
let g:ale_sign_warning='--'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_completion_enabled = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
nmap <silent> <space>E <Plug>(ale_previous_wrap)
nmap <silent> <space>e <Plug>(ale_next_wrap)
highlight ALEError ctermbg=DarkMagenta
let g:ale_javascript_eslint_executable='../node_modules/.bin/eslint'
" let g:ale_javascript_eslint_executable='npx eslint'

" MatchTagAlways highlighting
highlight MatchTag ctermfg=black ctermbg=lightgreen guifg=lightgreen

" Ignore lastplace
let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"

" Dirvish settings
let g:dirvish_mode = ':sort ,^.*[\/],'

" Settings for splitting
set splitright
set splitbelow

" create a session file
nnoremap <space>ms :mksession! ~/.vim/vim-session.vim<CR>

" vim close-tags
let g:closetag_filename = '*.jsx,*.html'
let g:closetag_xhtml_filenames = '*.jsx'

" Vim WebSearch
let g:web_search_engine = "google"
let g:web_search_browser = "firefox"
let g:web_search_command = "open -a Firefox -g"
let g:web_search_query = "http://www.google.com/search?q="
nnoremap <space>gg :WebSearchCursor<CR><CR>
vnoremap <space>gg :WebSearchVisual<CR><CR>

noremap <silent> <space>i :w !ix <Bar> pbcopy<cr>
noremap <space>gi :r !curl -s
nnoremap <space><Tab> :buffer<Space><Tab>

" highlight conflict markers
match Todo '\v^(\<|\=|\>){7}([^=].+)?$'

" jump to conflict markers
nnoremap <silent> [c /\v^(\<\|\=\|\>){7}([^=].+)?$<CR>
nnoremap <silent> [C ?\v^(\<\|\=\|\>){7}([^=].+)\?$<CR>

if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif
nnoremap <space>do :DiffOrig<CR>

" let vim_markdown_preview_hotkey='<C-m>'
" let vim_markdown_preview_browser='Firefox'

" Markdown preview (Livedown)
" nnoremap <C-m> :LivedownToggle<CR>

" changing cursorshape
" let &t_SI = "\<Esc>]50;CursorShape=1\x7"
" let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" Hexokinase
" let g:Hexokinase_ftAutoload = ['css', 'jsx', 'js', 'html', 'xml']
" Dart Vim
" let dart_corelib_highlight=v:false
let dart_style_guide = 2

" Command to open vim
command! Vimrc :vs $MYVIMRC
command! Uniq :sort u
command! Test :!tmux send-keys -t right 'npm test' Enter

" Do not redraw screen in middle of macro
set lazyredraw
" Make it unnecessary to unzip the epub file first
au BufReadCmd *.epub call zip#Browse(expand("<amatch>"))

" Vim go
let g:go_def_mode = 'godef'
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_extra_types = 1
