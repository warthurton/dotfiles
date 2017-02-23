
function! SafeDirectory(dir)
  let expanded = expand(a:dir)
  if !isdirectory(expanded)
    call mkdir(expanded)
  endif
  return expanded
endfunction

if has('nvim')
  let g:vimhome = '~/.config/nvim'
  set shada='100,<1000,s1000,:1000
  set clipboard+=unnamedplus
else
  let g:vimhome = '~/.vim'
  set viminfo='100,<1000,s1000,:1000,n~/.vim/viminfo

  if has('clipboard')
    set guioptions+=aA
    set clipboard+=unnamed
  endif
endif

let &backupdir    = SafeDirectory(g:vimhome . '/backup')
let &directory    = SafeDirectory(g:vimhome . '/swap')
let &viewdir      = SafeDirectory(g:vimhome . '/view')
let &undodir      = SafeDirectory(g:vimhome . '/undo')
let g:autoloadhome = SafeDirectory(g:vimhome . '/autoload')
let g:cachedir     = SafeDirectory(g:vimhome . '/cache')

let g:mapleader = ","
set autoindent
set background=dark
set backspace=indent,eol,start
set binary
set cursorline
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
set shortmess=firxI
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
set visualbell
set t_vb=
set t_Co=256
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

if has('termguicolors')
  set termguicolors
endif

if !empty($TMUX) " vim bug w/ tmux
  set t_8f=[38;2;%lu;%lu;%lum
  set t_8b=[48;2;%lu;%lu;%lum
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
Plug 'tpope/vim-dispatch'
Plug 'Konfekt/FastFold'
Plug 'junegunn/fzf', { 'dir': '~/.config/fzf', 'do': './install --no-update-rc --key-bindings --completion' }
Plug 'junegunn/fzf.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'scrooloose/nerdtree',            { 'on': 'NERDTreeToggle' }
Plug 'terryma/vim-multiple-cursors'
Plug 'chrisbra/NrrwRgn'
Plug 'tpope/vim-rbenv'
Plug 'tpope/vim-speeddating'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'scrooloose/syntastic'
Plug 'godlygeek/tabular',              { 'on': 'Tabularize' }
Plug 'majutsushi/tagbar'
Plug 'tomtom/tcomment_vim'
Plug 'mbbill/undotree'
Plug 'tpope/vim-vinegar'
Plug 'skalnik/vim-vroom'

" Filetypes
Plug 'kchmck/vim-coffee-script',       { 'for': 'coffee' }
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
Plug 'plasticboy/vim-markdown',        { 'for': 'markdown' }
Plug 'mutewinter/nginx.vim',           { 'for': 'nginx' }
Plug 'mitsuhiko/vim-python-combined',  { 'for': 'python' }
Plug 'slim-template/vim-slim',         { 'for': 'slim' }
Plug 'kurayama/systemd-vim-syntax',    { 'for': 'systemd' }
Plug 'sheerun/vim-yardoc',             { 'for': 'yard' }
Plug 'tmux-plugins/vim-tmux',          { 'for': 'tmux' }

Plug '1995eaton/vim-better-javascript-completion', { 'for': 'javascript' }
Plug 'othree/yajs.vim',                            { 'for': 'javascript' }
Plug 'othree/javascript-libraries-syntax.vim',     { 'for': 'javascript' }
Plug 'mxw/vim-jsx' ,                               { 'for': 'javascript' }
Plug 'othree/jspc.vim',                            { 'for': 'javascript' }

if executable('ruby')
  Plug 'tpope/vim-bundler',              { 'for': 'ruby' }
  Plug 'tpope/vim-cucumber',             { 'for': 'ruby' }
  Plug 'tpope/vim-endwise',              { 'for': 'ruby' }
  Plug 'tpope/vim-rails',                { 'for': 'ruby' }
  Plug 'tpope/vim-rake',                 { 'for': 'ruby' }
  Plug 'thoughtbot/vim-rspec',           { 'for': 'ruby' }
  Plug 'vim-ruby/vim-ruby',              { 'for': 'ruby' }
  Plug 'hwartig/vim-seeing-is-believing'
endif

if !empty($TMUX)
  Plug 'christoomey/vim-tmux-navigator', { 'on': [] }
  Plug 'jgdavey/vim-turbux',             { 'on': [] }
  Plug 'benmills/vimux',                 { 'on': [] }
endif

if executable('git')
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
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
elseif version >= 704 && has('python')
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py --all' }
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


" better-javascript-completion
let g:vimjs#casesensistive = 0
let g:vimjs#smartcomplete = 1
let g:vimjs#chromeapis = 1


" bufferline
let g:bufferline_active_buffer_left  = '['
let g:bufferline_active_buffer_right = ']'
let g:bufferline_echo                = 0
let g:bufferline_modified            = '+'
let g:bufferline_rotate              = 0
let g:bufferline_show_bufnr          = 1
let g:bufferline_solo_highlight      = 1


" deoplete
let g:deoplete#enable_at_startup = 1


" easytags
let g:easytags_file = g:cachedir . '/easytags'


" fzf
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --glob "!_build/*" --glob "!deps/*" --glob "!.DS_Store" --glob "!public/*" --glob "!log/*" --glob "!tmp/*" --glob "!vendor/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
map <C-p> :Files<cr>
" map <C-g> :Find
map <C-/> :Lines<cr>
"

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


" javascript-libraries-syntax
let g:used_javascript_libs = 'jquery,react,flux,requirejs,jasmine,chai,d3'


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

if exists('g:use_neocomplete')
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS>  neocomplete#smart_close_popup()."\<C-h>"
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return pumvisible() ? neocomplete#close_popup() : "\<CR>"
  endfunction
endif


" nerdtree
nmap <leader>n :NERDTreeToggle<CR>
vmap <leader>n :NERDTreeToggle<CR>
let g:NERDTreeHijackNetrw = 1


" rspec
let g:rspec_command = "Dispatch rspec {spec}"


" seeing_is_believing
" Annotate every line
" nmap <leader>b :%!seeing_is_believing --timeout 12 --line-length 500 --number-of-captures 300 --alignment-strategy chunk<CR>;
" " Annotate marked lines
" nmap <leader>n :%.!seeing_is_believing --timeout 12 --line-length 500 --number-of-captures 300 --alignment-strategy chunk --xmpfilter-style<CR>;
" " Remove annotations
" nmap <leader>c :%.!seeing_is_believing --clean<CR>;
" " Mark the current line for annotation
" nmap <leader>m A # => <Esc>
" " Mark the highlighted lines for annotation
" vmap <leader>m :norm A # => <Esc>


" splitjoin.vim
nmap <leader>sj :SplitjoinJoin<cr>
nmap <leader>ss :SplitjoinSplit<cr>


" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_jump                = 3
let g:syntastic_auto_loc_list            = 1
let g:syntastic_check_on_open            = 0
let g:syntastic_check_on_wq              = 0
let g:syntastic_enable_signs             = 1
let g:syntastic_loc_list_height          = 5
let g:syntastic_sh_checkers              = ['shellcheck', 'sh']
let g:syntastic_ruby_checkers            = ['rubocop', 'mri']
let g:syntastic_ruby_rubocop_args        = '--display-cop-names --config "$HOME/.rubocop.yml"'
let g:syntastic_ignore_files             = ['\m^/usr/include/', '\m\c\.h$', '\m-min\.js$']


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


" vroom
let g:vroom_cucumber_path = '__run=cucumber ; bundle show spinach >& /dev/null && __run=spinach ; bundle exec $__run'

let g:vroom_use_bundle_exec = 1
let g:vroom_use_binstubs = 0
let g:vroom_ignore_color_flag = 1
let g:vroom_use_dispatch = 1

if has('nvim')
  let g:vroom_use_terminal = 1
elseif !empty($TMUX)
  let g:vroom_use_vimux = 1
endif

map <Leader>t :VroomRunTestFile<cr>
map <Leader>s :VroomRunNearestTest<cr>
map <Leader>l :VroomRunLastTest<CR>
" map <Leader>a :call RunAllSpecs()<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('autocmd')
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

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
  let g:base16colorspace = 256
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
