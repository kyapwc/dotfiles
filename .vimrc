" Setting leader key
let mapleader=","

" Certain vim settings
set nocompatible
filetype indent on
filetype plugin indent on
syntax on
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

augroup VIMRC
  autocmd!
  autocmd BufLeave *.css,*.scss normal! mC
  autocmd BufLeave *.html normal! mH
  autocmd BufLeave *.js normal! mJ
  autocmd BufLeave *.py normal! mP
augroup END

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

" REMAPS ARE BELOW HERE
" reindent file
nnoremap <leader>f mzgg=G`z
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
nnoremap <silent> <space>q :bd<CR>
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
nnoremap <space>z :q<CR>
nnoremap <space><space>w :only<CR> :wq<CR>
" Jumping lines!
noremap <space>k 20k
noremap <space>j 20j
noremap <c-e> @='10<c-v><c-e>'<cr>
noremap <c-y> @='10<c-v><c-y>'<cr>
" More 'natural' movements
nnoremap j gj
nnoremap k gk
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
" REMAPS END

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

let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 20
let g:netrw_altv = 1

if !has('gui_running')
  set t_Co=256
endif

call plug#begin('~/.vim/plugs')
" Better searching
Plug 'markonm/traces.vim'

" Buffer realted plugs
Plug 'ap/vim-buftabline'
Plug 'Yilin-Yang/vim-markbar'
Plug 'junegunn/vim-peekaboo'

" Index searching
Plug 'henrik/vim-indexed-search'

" extending vim
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'
Plug 'ntpeters/vim-better-whitespace'

" coding related plugs
Plug 'w0rp/ale'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'jiangmiao/auto-pairs'
Plug 'jceb/emmet.snippets'
Plug 'honza/vim-snippets'
Plug 'fatih/vim-go'
Plug 'ap/vim-css-color', {'for': 'html,css'}
Plug 'Valloric/MatchTagAlways'

" Sugaring
Plug 'RRethy/vim-illuminate'
Plug 'mhinz/vim-signify'
Plug 'kshenoy/vim-signature'
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'ryanoasis/vim-devicons'

" utils
Plug 'Yggdroot/indentLine'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-rhubarb'
Plug 'majutsushi/tagbar'
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips'
Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'embear/vim-localvimrc'
Plug 'kien/ctrlp.vim'
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

" indentLine settings
let g:indentLine_char = '|'

" Markbar Settings
map <Leader><Leader>m <Plug>ToggleMarkbar

" Peekaboo settings
nmap <space>` <Plug>OpenMarkbarPeekabooApostrophe
let g:markbar_enable_peekaboo = v:false

" Tagbar settings
nnoremap <F8> :TagbarToggle<CR>

" Colorscheme options
colorscheme gruvbox
let g:quantum_black=1
set background=dark
let g:quantum_italics=1
let g:gruvbox_underline = 1
let g:gruvbox_italic = 1
let g:gruvbox_undercurl = 1
let g:gruvbox_contrast_dark = 'soft'

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

" Git push inside vim on current branch
" Git push function
function! FuGitPush()
  let a:branchName = fugitive#head()
  execute ':Git push origin ' . a:branchName
endfunction
" Fugitive mappings
nnoremap <space>gs :Gstatus<CR>
nnoremap <space>gb :Gblame<CR>
nnoremap <space>ga :Git add .<CR>
nnoremap <space>gc :Git commit -am "
nnoremap <space>gC :Gcommit --verbose<CR>
nnoremap <space>gp :call FuGitPush()<CR>
nnoremap <leader>2 :diffget //2<CR>
nnoremap <leader>3 :diffget //3<CR>

" Signify chunk jumping
nmap <space>c <plug>(signify-next-hunk)
nmap <space>C <plug>(signify-prev-hunk)

" Local vimrc
let g:localvimrc_persistent=1

" CtrlP Settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode='ra'
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
\ }
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

" MatchTagAlways highlighting
highlight MatchTag ctermfg=black ctermbg=lightgreen guifg=lightgreen

" Ignore lastplace
let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"
