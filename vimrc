""""""""""""""""""""""""
""Plugins(NeoBundle)
""""""""""""""""""""""""
filetype off
if has('vim_starting')
	set nocompatible
	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }
NeoBundle 'Shougo/unite.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'xolox/vim-session', {
            \ 'depends' : 'xolox/vim-misc',
          \ }
NeoBundle 'kana/vim-submode'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'scrooloose/syntastic.git'
NeoBundle 'derekwyatt/vim-scala'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'powerline/powerline'
NeoBundle 'kana/vim-filetype-haskell'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Chiel92/vim-autoformat'
NeoBundle 'Glench/Vim-Jinja2-Syntax'
NeoBundle 'rking/ag.vim'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'davidhalter/jedi-vim'

call neobundle#end()

filetype plugin indent on
NeoBundleCheck

""""""""""
""Plugins(NeoBundle end)
""""""""""

syntax on
syntax enable
au BufRead,BufNewFile *.md set filetype=markdown

""""""""""
" ColorSchemeSetting
if has('mac')
  colorscheme solarized
else
  colorscheme molokai
endif

set background=dark

set number
set cursorline
set laststatus=2

set ts=2 sw=2 et
set autoindent
set cindent 
set smarttab

set incsearch
set ignorecase
set hlsearch

"enable scrolling with mouse
set mouse=a
set ttymouse=xterm2

"Keymap
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sn gt
nnoremap sp gT
nnoremap suf :<C-u>Unite file<CR>
nnoremap sub :<C-u>Unite buffer<CR>
nnoremap <silent> <C-p> :<C-u>call DispatchUniteFileRecAsyncOrGit()<CR>
nnoremap <C-]> g<C-]>
inoremap <silent> jk <ESC>

" For vimgrep
autocmd QuickFixCmdPost *grep* cwindow

"LightLine
set noshowmode
let g:lightline = {
	\	'colorscheme': 'wombat',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'fugitive', 'filename'] ]
  \ },
  \ 'component_function': {
  \   'fugitive': 'MyFugitive'
  \ },
  \ 'separator': {
  \     'left': "\ue0b0", 'right': "\ue0b2"
  \ },
  \ 'subseparator':{
  \     'left': "\ue0b1", 'right': "\ue0b3"
  \ }
  \}

function! MyFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? "\ue0a0 "._ : ''
  endif
  return ''
endfunction

function! DispatchUniteFileRecAsyncOrGit()
  if isdirectory(getcwd()."/.git")
    Unite file_rec/git
  else
    Unite file_rec/async
  endif
endfunction

"vim-session
" 現在のディレクトリ直下の .vimsessions/ を取得 
let s:local_session_directory = xolox#misc#path#merge(getcwd(), '.vimsessions')
" 存在すれば
if isdirectory(s:local_session_directory)
  " session保存ディレクトリをそのディレクトリの設定
  let g:session_directory = s:local_session_directory
  " vimを辞める時に自動保存
  let g:session_autosave = 'yes'
  " 引数なしでvimを起動した時にsession保存ディレクトリのdefault.vimを開く
  let g:session_autoload = 'yes'
  " 1分間に1回自動保存
  let g:session_autosave_periodic = 1
else
  let g:session_autosave = 'no'
  let g:session_autoload = 'no'
endif
unlet s:local_session_directory

"submode
call submode#enter_with('winsize', 'n', '', 's>', '<C-w>>')
call submode#enter_with('winsize', 'n', '', 's<', '<C-w><')
call submode#map('winsize', 'n', '', '>', '<C-w>>')
call submode#map('winsize', 'n', '', '<', '<C-w><')

"vim-indent-guides
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=1
let g:indent_guides_start_level=2

"syntastic
let g:syntastic_mode_map = { 'mode': 'passive',
            \ 'active_filetypes': ['c', 'python', 'ruby'] }
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args="--ignore=E111"

" NeoComplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_ignore_case = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_auto_select = 1
let g:neocomplete#enable_enable_camel_case_completion = 0
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns._ = '\h\w*'
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

"jedi-vim
autocmd FileType python setlocal completeopt-=preview