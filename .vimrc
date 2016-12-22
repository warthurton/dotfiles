
function! SafeDirectory(dir)
  let a:expanded = expand(a:dir)
  if !isdirectory(a:expanded)
    call mkdir(a:expanded)
  endif
  return a:expanded
endfunction

if has('nvim')
  let g:vimhome = '~/.config/nvim'
  set viminfo='100,<1000,s1000,:1000

  if executable('osascript')
    set clipboard+=unnamedplus
  endif
else
  let g:vimhome = '~/.vim'
  set viminfo='100,<1000,s1000,:1000,n~/.vim/viminfo

  if has('clipboard')
    set clipboard+=unnamed
  endif
endif

let g:backupdir    = SafeDirectory(g:vimhome . '/backup')
let g:directory    = SafeDirectory(g:vimhome . '/swap')
let g:viewdir      = SafeDirectory(g:vimhome . '/view')
let g:undodir      = SafeDirectory(g:vimhome . '/undo')
let g:autoloadhome = SafeDirectory(g:vimhome . '/autoload')
let g:cachedir     = SafeDirectory(g:vimhome . '/cache')

let mapleader = ","
set autoindent
set background=dark
set backspace=indent,eol,start
set binary
set noex
set noerrorbells
set encoding=utf-8
set expandtab
set exrc
set nofoldenable
set formatoptions=rq
set nohidden
set history=1000
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set list
set listchars=""          " reset the listchars
set listchars+=tab:\ \    " a tab should display as "  ", trailing whitespace as "."
set listchars+=trail:.    " show trailing spaces as dots
set listchars+=extends:>
set listchars+=precedes:<
set matchtime=5
set modeline
set modelines=5
set mouse+=a
set nocompatible
set number
set numberwidth=6
set ruler
set scrolloff=3
set secure
set shiftwidth=2
set shortmess=ilnrxsAI
if version >= 704
  set shortmess+=c
endif
set showcmd
set showmatch
set noshowmode
set showtabline=2
set smartcase
set smartindent
set smarttab
set softtabstop=2
set splitbelow
set splitright
set tabstop=2
set noterse
set viminfo='100,<1000,s1000,:1000,n~/.vim/viminfo
set visualbell
set t_Co=256
set t_vb=
if version >= 800 && empty($TMUX)
  set termguicolors
endif
set ttimeout
set ttimeoutlen=50
set winaltkeys=no
set wildignore+=*/.cache/*,*/tmp/*,*/.git/*,*/.neocon/*,*.log,*.so,*.swp,*.zip,*.gz,*.bz2,*.bmp,*.ppt
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.dll
set wildmenu
set wildmode=longest,list
set writebackup

if has('persistent_undo')
  set undolevels=1000
  set undoreload=10000
  set undofile
endif

if empty(glob(g:autoloadhome . '/plug.vim'))
  execute "silent !curl -sflo " . g:autoloadhome . "/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin(SafeDirectory(g:vimhome . '/plugged'))

" Utils
Plug 'chriskempson/base16-vim'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'bling/vim-bufferline'
Plug 'oplatek/Conque-Shell',           { 'on': 'ConqueTerm' }
Plug 'ctrlpvim/ctrlp.vim',             { 'on': 'CtrlP' }
Plug 'junegunn/fzf'
Plug 'haya14busa/incsearch.vim'
Plug 'scrooloose/nerdtree',            { 'on': 'NERDTreeToggle' }
Plug 'chrisbra/NrrwRgn'
Plug 'tpope/vim-speeddating'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'godlygeek/tabular',              { 'on': 'Tabularize' }
Plug 'majutsushi/tagbar'
Plug 'tomtom/tcomment_vim'
Plug 'mbbill/undotree'
Plug 'tpope/vim-vinegar'
Plug 'skalnik/vim-vroom'

" Filetypes
Plug 'kchmck/vim-coffee-script',       { 'for': 'coffeescript' }
Plug 'rhysd/vim-crystal',              { 'for': 'crystal' }
Plug 'JulesWang/css.vim',              { 'for': [ 'css', 'sass', 'scss' ] }
Plug 'chrisbra/csv.vim',               { 'for': 'csv' }
Plug 'elixir-lang/vim-elixir',         { 'for': 'elixir' }
Plug 'spiegela/vimix',                 { 'for': 'elixir' }
Plug 'elmcast/elm-vim',                { 'for': 'elm' }
Plug 'fatih/vim-go',                   { 'for': 'go' }
Plug 'tpope/vim-haml',                 { 'for': 'haml' }
Plug 'ksauzz/haproxy.vim',             { 'for': 'haproxy' }
Plug 'othree/html5.vim',               { 'for': 'html' }
Plug 'othree/yajs.vim',                { 'for': 'javascript' }
" Plug 'pangloss/vim-javascript',        { 'for': 'javascript' }
Plug 'leshill/vim-json',               { 'for': 'json' }
Plug 'mxw/vim-jsx',                    { 'for': 'javascript' }
Plug 'tpope/vim-markdown',             { 'for': 'markdown' }
Plug 'mutewinter/nginx.vim',           { 'for': 'nginx' }
Plug 'mitsuhiko/vim-python-combined',  { 'for': 'python' }
Plug 'kurayama/systemd-vim-syntax',    { 'for': 'systemd' }
Plug 'acustodioo/vim-tmux',            { 'for': 'tmux' }
Plug 'sheerun/vim-yardoc',             { 'for': 'yard' }

Plug 'tpope/vim-bundler',              { 'for': 'ruby' }
Plug 'tpope/vim-cucumber',             { 'for': 'ruby' }
Plug 'tpope/vim-endwise',              { 'for': 'ruby' }
Plug 'tpope/vim-rails',                { 'for': 'ruby' }
Plug 'tpope/vim-rake',                 { 'for': 'ruby' }
Plug 'tpope/vim-rbenv',                { 'for': 'ruby' }
Plug 'thoughtbot/vim-rspec',           { 'for': 'ruby' }
Plug 'vim-ruby/vim-ruby',              { 'for': 'ruby' }

if has('nvim')
  Plug 'neomake/neomake'
else
  Plug 'scrooloose/syntastic'
endif

if executable('tmux')
  Plug 'christoomey/vim-tmux-navigator', { 'on': [] }
  Plug 'jgdavey/vim-turbux',             { 'on': [] }
  Plug 'benmills/vimux',                 { 'on': [] }
endif

if executable('git')
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
endif

if executable('ag')
  Plug 'rking/ag.vim'
  set grepprg=ag\ --nogroup\ --nocolor\ --numbers\ $*\ /dev/null
  let g:ctrlp_user_command = 'ag --files-with-matches --nocolor -g "" %s'
endif

if version >= 702
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
endif

if version >= 704
  Plug 'xolox/vim-easytags'
  Plug 'xolox/vim-misc'
  Plug 'xolox/vim-shell'
endif

if has('nvim')
  Plug 'Shougo/deoplete.nvim'
elseif version >= 704 && has('lua')
  Plug 'Shougo/neocomplete.vim'
  let g:use_neocomplete = 1
" elseif version >= 704 && has('python')
"   Plug 'Valloric/YouCompleteMe', { 'do': './install.py --all' }
endif

call plug#end()
runtime macros/matchit.vim

" airline
let g:airline_detect_crypt                         = 1
let g:airline_detect_iminsert                      = 0
let g:airline_detect_modified                      = 1
let g:airline_detect_paste                         = 1
let g:airline_inactive_collapse                    = 1
let g:airline_powerline_fonts                      = 1
let g:airline_left_sep                             = ''
let g:airline_right_sep                            = ''
let g:airline#extensions#branch#format             = 1
let g:airline#extensions#bufferline#enabled        = 1
let g:airline#extensions#ctrlspace#enabled         = 1
let g:airline#extensions#nrrwrgn#enabled           = 1
let g:airline#extensions#syntastic#enabled         = 1
let g:airline#extensions#tabline#enabled           = 1
let g:airline#extensions#tagbar#enabled            = 1
let g:airline#extensions#tmuxline#enabled          = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#buffer_idx_mode   = 1
let g:airline#extensions#tabline#show_buffers      = 1
let g:airline#extensions#tabline#show_tabs         = 1
let g:airline_section_b                            = '%{getcwd()}'
let g:airline_theme                                = 'tomorrow'


" bufferline
let g:bufferline_active_buffer_left  = '['
let g:bufferline_active_buffer_right = ']'
let g:bufferline_echo                = 0
let g:bufferline_modified            = '+'
let g:bufferline_rotate              = 0
let g:bufferline_show_bufnr          = 1
let g:bufferline_solo_highlight      = 1


" CoVim
let CoVim_default_name = $USER
let CoVim_default_port = "22222"


" ctrlp.vim
let g:ctrlp_cmd          = 'CtrlP'
let g:ctrlp_map          = '<c-p>'
let g:ctrlp_reuse_window = 'netrw\|help\|quickfix'
let g:ctrlp_show_hidden  = 1
let g:ctrlp_use_caching  = 0


" deoplete
let g:deoplete#enable_at_startup = 1


" easytags
let g:easytags_file = g:cachedir . '/easytags'

" gitgutter
highlight clear SignColumn
let g:gitgutter_eager     = 0
let g:gitgutter_enabled   = 1
let g:gitgutter_max_signs = 10000
let g:gitgutter_realtime  = 0


" incsearch
map <leader>/ <Plug>(incsearch-forward)
map <leader>? <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)


" neocomplete.vim
let g:neocomplete#data_directory                    = SafeDirectory(g:cachedir . '/neocomplete')
let g:neocomplete#auto_completion_start_length      = 2
let g:neocomplete#disable_auto_complete             = 0
let g:neocomplete#enable_at_startup                 = 1
let g:neocomplete#enable_auto_close_preview         = 1
let g:neocomplete#enable_auto_select                = 0
let g:neocomplete#enable_insert_char_pre            = 1
let g:neocomplete#enable_omni_fallback              = 0
let g:neocomplete#enable_smart_case                 = 1
let g:neocomplete#force_omni_input_patterns         = {}
let g:neocomplete#force_omni_input_patterns.ruby    = '[^. *\t]\.\w*\|\h\w*::\w*|\s*#'
let g:neocomplete#force_overwrite_completefunc      = 1
let g:neocomplete#keyword_patterns                  = {}
let g:neocomplete#keyword_patterns._                = '\h\w*'
let g:neocomplete#lock_buffer_name_pattern          = '\*ku\*'
let g:neocomplete#manual_completion_start_length    = 0
let g:neocomplete#min_keyword_length                = 3
let g:neocomplete#same_filetypes                    = {}
let g:neocomplete#same_filetypes._                  = '_'
let g:neocomplete#same_filetypes.gitconfig          = '_'
let g:neocomplete#sources#omni#input_patterns       = {}
let g:neocomplete#sources#syntax#min_keyword_length = 4

" let g:neocomplete#sources#dictionary#dictionaries = {
"     \ 'default' : '',
"     \ 'vimshell' : expand(vimhome . 'vimshell')
"     \ }

if exists('g:use_neocomplete')
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return pumvisible() ? neocomplete#close_popup() : "\<CR>"
  endfunction

  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS>  neocomplete#smart_close_popup()."\<C-h>"
endif


" nerdtree
nmap <leader>n :NERDTreeToggle<CR>
vmap <leader>n :NERDTreeToggle<CR>
let NERDTreeHijackNetrw = 1


" splitjoin.vim
nmap <leader>sj :SplitjoinJoin<cr>
nmap <leader>ss :SplitjoinSplit<cr>


" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_jump                = 1
let g:syntastic_auto_loc_list            = 1
let g:syntastic_check_on_open            = 0
let g:syntastic_check_on_wq              = 0
let g:syntastic_enable_signs             = 1
let g:syntastic_loc_list_height          = 5
let g:syntastic_sh_checkers              = ['shellcheck', 'sh']
let g:syntastic_ruby_checkers            = ['rubocop', 'mri']
let g:syntastic_ruby_rubocop_args        = '--display-cop-names --config "$HOME/.rubocop.yml"'


" tabular
nmap <leader>a= :Tabularize /=<CR>
vmap <leader>a= :Tabularize /=<CR>
nmap <leader>a: :Tabularize /:\zs<CR>
vmap <leader>a: :Tabularize /:\zs<CR>


" tagbar
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_show_linenumbers = 1
let g:tagbar_autoshowtag = 1
let g:tagbar_autopreview = 1
nmap <leader>T :TagbarToggle<CR>
vmap <leader>T :TagbarToggle<CR>


" tcomment_vim
map \\ gcc
vmap \\ gc
if !exists('g:tcomment_types')
  let g:tcomment_types = {}
endif
let g:tcomment_types = { 'java' : '// %s' }
let g:tcomment_types = { 'tmux' : '# %s' }


" tmux-navigator
if !empty($TMUX)
  let g:tmux_navigator_no_mappings = 1
  nnoremap <silent> <A-h> :TmuxNavigateLeft<cr>
  nnoremap <silent> <A-j> :TmuxNavigateDown<cr>
  nnoremap <silent> <A-k> :TmuxNavigateUp<cr>
  nnoremap <silent> <A-l> :TmuxNavigateRight<cr>
  nnoremap <silent> <A-\> :TmuxNavigatePrevious<cr>
endif

" undotree
nmap <leader>u :UndotreeToggle<CR>
vmap <leader>u :UndotreeToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('autocmd')
  augroup GitCommits
    autocmd!
    autocmd FileType gitcommit            nested setlocal nospell
    autocmd VimEnter .git/PULLREQ_EDITMSG nested setlocal filetype=markdown
  augroup END

  if !empty($TMUX)
    augroup RunningTmux
      autocmd!
      autocmd VimEnter * call plug#load('vim-tmux-navigator', 'vim-turbux', 'vimux')
    augroup END
  endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" i just don't hate myself enough
" nnoremap <left> <C-w>h
" nnoremap <right> <C-w>l
" nnoremap <up> <C-w>k
" nnoremap <down> <C-w>j
" inoremap <up> <nop>
" inoremap <down> <nop>
" inoremap <left> <nop>
" inoremap <right> <nop>
nmap Q <nop>

imap jk <Esc>
nmap jk <Esc>
vmap jk <Esc>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nmap <M-f> e
nmap <M-b> b

nmap <leader>[ gt
nmap <leader>] gT
nmap d[ [m
nmap d] ]m
nmap c[ [[
nmap c] ]]

nmap <CR> :nohlsearch<cr>
vmap < <gv
vmap > >gv
vmap <Tab> >gv
vmap <S-Tab> <gv
cmap %% <C-R>=expand('%:h').'/'<cr>

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

syntax on
filetype plugin indent on

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace = 256
  source ~/.vimrc_background
  highlight LineNr ctermfg=236 ctermbg=234
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
  set guifont=Sauce\ Code\ Powerline:h15
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=L  "remove toolbar
  set guioptions-=r  "remove toolbar
  set anti
  set cursorline
  set mousehide
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
