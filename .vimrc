set nocompatible
filetype indent on
filetype plugin indent on
let mapleader=","
set shortmess=atOI
set ignorecase
set pumheight=20
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

" reindent file
nnoremap <leader>f mzgg=G`z
" buffer commands
nnoremap <space>b :bnext<CR>
nnoremap <space>B :bprev<CR>
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
" kill a buffer
nnoremap <silent> <space>q :bd<CR>
" Setting copy into system clipboard
vmap <c-c> "+y
" Jump to buffer after buffer ls
nnoremap <leader>b :buffers<cr>:b<space> 

" map cgn (Change go next)
" nnoremap <space>cn cgn

" Go to mark
nnoremap <leader><leader> '
set wrap
set title
set nobackup
set noswapfile
" set autochdir
set hidden

set clipboard=exclude:.*

" For Python stuff
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space>f za

let g:ctrlp_use_caching = 0
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects
  " .gitignore
  let g:ctrlp_user_command = 'Ag %s -l --nocolor -g "" --hidden --ignore-dir .git'

  " ag is fast enough that CtrlP doesn't need to cache
endif

nnoremap <c-F> :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>--column<SPACE>

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

" set mapping for replacing word under cursor with word in register
map <leader>r ciw<C-r>0<ESC>

" set vertical resize to bigger
nnoremap <c-w>> :vertical resize +15<CR>
nnoremap <c-w>< :vertical resize -15<CR>
nnoremap <c-w>- :resize -10<CR>
nnoremap <c-w>+ :resize +10<CR>

" Set Esc Delay to have less delay
" set timeout
" set timeoutlen=50
set wildmenu

set guifont=Monaco:h13

nnoremap <Leader>cd :cd %:h<CR>

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

nnoremap j gj
nnoremap k gk

set backspace=indent,eol,start
set number relativenumber

syntax on

set guifont=Source\ Code\ Pro
set term=screen-256color

set list
" set showbreak=↪\
" set listchars=tab:\ \ ,eol:↲,nbsp:␣,extends:⌘,precedes:⛌

set noshowmode

noremap <silent> <space>x :Lexplore<CR>
" Making netrw liststyle default
let g:netrw_liststyle = 3
" Removing useless banner at top
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 20
let g:netrw_altv = 1

set laststatus=2
if !has('gui_running')
  set t_Co=256
endif

call plug#begin('~/.vim/plugs')
Plug 'qwertologe/nextval.vim'

Plug 'ap/vim-buftabline'
let g:buftabline_show=1
let g:buftabline_numbers=2
let g:buftabline_indicators=1
highlight link BufTabLineCurrent LightlineLeft_normal_1
highlight link BufTabLineActive LightlineRight_normal_2
highlight link BufTabLineHidden LightlineRight_normal_2
nnoremap <leader>b :set nomore <Bar> :ls <Bar> :set more <CR>:b<Space>

Plug 'henrik/vim-indexed-search'

Plug 'tpope/vim-eunuch'

Plug 'fatih/vim-go'

Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

Plug 'Yggdroot/indentLine'
let g:indentLine_char = '|'

Plug 'Yilin-Yang/vim-markbar'
map <Leader><Leader>m <Plug>ToggleMarkbar

Plug 'junegunn/vim-peekaboo'
nmap <space>` <Plug>OpenMarkbarPeekabooApostrophe
let g:markbar_enable_peekaboo = v:false

Plug 'terryma/vim-multiple-cursors'

Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

Plug 'matze/vim-move'
let g:move_key_modifier='A'

Plug 'tpope/vim-vinegar'

Plug 'tpope/vim-rhubarb'

Plug 'RRethy/vim-illuminate'

Plug 'majutsushi/tagbar'
nnoremap <F8> :TagbarToggle<CR>

Plug 'morhetz/gruvbox'
colorscheme gruvbox
let g:quantum_black=1
set background=dark
let g:quantum_italics=1
let g:gruvbox_underline = 1
let g:gruvbox_italic = 1
let g:gruvbox_undercurl = 1
let g:gruvbox_contrast_dark = 'soft'

" Config for ultisnips
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
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

set completeopt=longest,menuone,preview

" PEP 8 Checking
" Plug 'nvie/vim-flake8', {'for': 'py'}
let python_highlight_all=1

" SimpylFold for code folding
Plug 'tmhedberg/SimpylFold', {'for': 'py'}
let g:SimpylFold_docstring_preview=1

Plug 'ludovicchabant/vim-gutentags'
set statusline+=%{gutentags#statusline()}
let g:gutentags_ctags_exclude = ["*.min.js", "*.min.css", "build", "vendor", ".git", "node_modules", "*.vim/bundle/*"]

" Git push function
function! FuGitPush()
  let a:branchName = fugitive#head()
  execute ':Git push origin ' . a:branchName
endfunction
Plug 'tpope/vim-fugitive'
nnoremap <space>gs :Gstatus<CR>
nnoremap <space>gb :Gblame<CR>
nnoremap <space>ga :Git add .<CR>
nnoremap <space>gc :Git commit -am "
nnoremap <space>gC :Gcommit --verbose<CR>
" nnoremap <space>gp :Git push origin 
nnoremap <space>gp :call FuGitPush()<CR>
nnoremap <leader>2 :diffget //2<CR>
nnoremap <leader>3 :diffget //3<CR>

Plug 'mhinz/vim-signify'
" Signify hunk jumping
nmap <space>c <plug>(signify-next-hunk)
nmap <space>C <plug>(signify-prev-hunk)
Plug 'kshenoy/vim-signature'

highlight Normal guibg=NONE ctermbg=NONE
highlight NonText ctermbg=NONE

Plug 'jceb/emmet.snippets'

Plug 'tpope/vim-surround'

Plug 'embear/vim-localvimrc'
let g:localvimrc_persistent=1

Plug 'kien/ctrlp.vim'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode='ra'
nnoremap <space>p :CtrlPBuffer<CR>
" nnoremap <space>p <Esc>:CtrlPBuffer<CR>
nnoremap <Leader><Leader>p :CtrlPTag<CR>
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*
" let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
" let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist|bin)|\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'

Plug 'itchyny/lightline.vim'
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

Plug 'w0rp/ale'
let g:ale_linters = { 'javascript': ['eslint'] }
" let g:ale_linters = { 'jsx': ['eslint', 'jshint'] }
" let g:ale_linters = { 'html': ['tidy'] }
" let g:ale_linters = { 'json': ['jsonlint'] }
" let g:ale_linters = { 'php': ['phpcs'] }
" let g:ale_linters = { 'scss': ['sass-lint'] }
" let g:ale_linters = { 'css': ['csslint', 'stylelint'] }
" let g:ale_linters = { 'typescript': ['eslint', 'tslint', 'tsserver', 'prettier'] }
" let g:ale_linters = { 'cpp': ['gcc', 'clang'] }
" let g:ale_sign_error='●'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_sign_error='✗'
let g:ale_sign_warning='--'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_completion_enabled = 1
let g:ale_lint_on_text_changed = 'never'
nmap <silent> <space>e <Plug>(ale_previous_wrap)
nmap <silent> <space>E <Plug>(ale_next_wrap)
highlight ALEError ctermbg=DarkMagenta
let g:ale_javascript_eslint_executable='../node_modules/.bin/eslint'
" let g:ale_javascript_eslint_executable='npx eslint'

" Plug 'ternjs/tern_for_vim', {'for': 'js,ts,ejs'}
" let g:tern_show_argument_hints='on_hold'
" let g:tern_map_keys=1

Plug 'tpope/vim-commentary'

Plug 'Valloric/MatchTagAlways'
highlight MatchTag ctermfg=black ctermbg=lightgreen guifg=lightgreen

Plug 'jiangmiao/auto-pairs'

let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"

Plug 'ap/vim-css-color', {'for': 'html,css'}

Plug 'tpope/vim-abolish'

" Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
let g:typescript_indent_disable = 1
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''

Plug 'tpope/vim-sensible'

Plug 'ryanoasis/vim-devicons'
" Set UTF 8 for dev icons
set encoding=UTF-8
call plug#end()
" Highlight over the length
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%101v.\+/
set cursorline
set noerrorbells
set visualbell
set smartcase
