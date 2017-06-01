set encoding=utf-8
scriptencoding

function! SafeDirectory(dir)
  let l:expanded = expand(a:dir)
  if !isdirectory(l:expanded)
    call mkdir(l:expanded, 'p', 0700)
  endif
  return l:expanded
endfunction

if has('nvim')
  let g:vimhome = SafeDirectory('~/.config/nvim')
  set shada='100,<1000,s1000,:1000
  set clipboard+=unnamedplus
else
  let g:vimhome = SafeDirectory('~/.vim')

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

let g:mapleader = ' '
set autoindent
set background=dark
set backspace=indent,eol,start
set binary
set cursorline
set noexrc
set noerrorbells
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
set nolazyredraw
set list
set listchars=""          " reset the listchars
set listchars+=tab:\ \    " a tab should display as "  ", trailing whitespace as "."
set listchars+=trail:.    " show trailing spaces as dots
set listchars+=extends:>
set listchars+=precedes:<
set matchtime=5
set modeline
set modelines=8
set mouse+=a
set number
set numberwidth=6
set preserveindent
set report=0
set ruler
set scrolloff=10
set secure
set shiftwidth=2
" set shortmess=firxI
set noshowcmd
set showmatch
set noshowmode
set showtabline=1
set smartcase
set smartindent
set smarttab
set softtabstop=2
set splitbelow
set splitright
set tabstop=2
set noterse
set viminfo='100,<1000,s1000,:1000
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
  set undolevels=10000
  set undoreload=100000
  set undofile
endif

let g:vimplug_exists=expand(g:autoloadhome . '/plug.vim')

if !filereadable(g:vimplug_exists)
  if !executable('curl')
    echoerr 'You have to install curl or first install vim-plug yourself!'
    execute 'q!'
  endif
  echo 'Installing Vim-Plug...'
  execute 'silent !curl -sflo ' . g:autoloadhome . '/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

  augroup InstallPlug
    autocmd VimEnter * PlugInstall
  augroup END
endif

call plug#begin(SafeDirectory(g:vimhome . '/plugged'))

" Utils
Plug 'albfan/ag.vim'
Plug 'w0rp/ale'
Plug 'chriskempson/base16-vim'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'tpope/vim-dispatch'
Plug 'easymotion/vim-easymotion'
Plug 'mattn/emmet-vim'
Plug 'Konfekt/FastFold'
Plug 'embear/vim-foldsearch'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'dir': '~/.config/fzf', 'do': './install --no-update-rc --key-bindings --completion' }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'jreybert/vimagit'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'terryma/vim-multiple-cursors'
Plug 'chrisbra/NrrwRgn'
Plug 'chrisbra/SaveSigns.vim'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-speeddating'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/SyntaxRange'
Plug 'godlygeek/tabular',              { 'on': 'Tabularize' }
Plug 'majutsushi/tagbar'
Plug 'tomtom/tcomment_vim'
Plug 'mbbill/undotree'
Plug 'tpope/vim-vinegar'
Plug 'skalnik/vim-vroom'
Plug 'christoomey/vim-tmux-navigator'
Plug 'jgdavey/vim-turbux'
Plug 'benmills/vimux'

" Filetypes
Plug 'kchmck/vim-coffee-script',                   { 'for': 'coffee' }
Plug 'rhysd/vim-crystal',                          { 'for': 'crystal' }
Plug 'JulesWang/css.vim',                          { 'for': [ 'css', 'sass', 'scss' ] }
Plug 'chrisbra/csv.vim',                           { 'for': 'csv' }
Plug 'elixir-lang/vim-elixir',                     { 'for': 'elixir' }
Plug 'spiegela/vimix',                             { 'for': 'elixir' }
Plug 'elmcast/elm-vim',                            { 'for': 'elm' }
Plug 'fatih/vim-go',                               { 'for': 'go' }
Plug 'tpope/vim-haml',                             { 'for': 'haml' }
Plug 'ksauzz/haproxy.vim',                         { 'for': 'haproxy' }
Plug 'othree/html5.vim',                           { 'for': 'html' }
Plug '1995eaton/vim-better-javascript-completion', { 'for': 'javascript' }
Plug 'othree/yajs.vim',                            { 'for': 'javascript' }
Plug 'othree/javascript-libraries-syntax.vim',     { 'for': 'javascript' }
Plug 'mxw/vim-jsx' ,                               { 'for': 'javascript' }
Plug 'othree/jspc.vim',                            { 'for': 'javascript' }
Plug 'plasticboy/vim-markdown',                    { 'for': 'markdown' }
Plug 'mutewinter/nginx.vim',                       { 'for': 'nginx' }
Plug 'jceb/vim-orgmode',                           { 'for': 'org' }
Plug 'mitsuhiko/vim-python-combined',              { 'for': 'python' }
Plug 'tpope/vim-bundler',                          { 'for': 'ruby' }
Plug 'tpope/vim-cucumber',                         { 'for': 'ruby' }
Plug 'tpope/vim-endwise',                          { 'for': 'ruby' }
Plug 'tpope/vim-rails',                            { 'for': 'ruby' }
Plug 'tpope/vim-rake',                             { 'for': 'ruby' }
Plug 'thoughtbot/vim-rspec',                       { 'for': 'ruby' }
Plug 'vim-ruby/vim-ruby',                          { 'for': 'ruby' }
Plug 'hwartig/vim-seeing-is-believing',            { 'for': 'ruby' }
Plug 'kurayama/systemd-vim-syntax',                { 'for': 'systemd' }
Plug 'sheerun/vim-yardoc',                         { 'for': 'yard' }
Plug 'tmux-plugins/vim-tmux',                      { 'for': 'tmux' }

if v:version >= 702
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'ryanoasis/vim-devicons'
endif

if v:version >= 704
  Plug 'xolox/vim-easytags'
  Plug 'xolox/vim-misc'
  Plug 'xolox/vim-shell'
endif

if has('nvim')
  Plug 'roxma/nvim-completion-manager'
  Plug 'roxma/nvim-cm-tern', {'do': 'npm install'}
elseif v:version >= 800
  Plug 'maralla/completor.vim', { 'do': 'make js' }
elseif v:version >= 704 && has('python')
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py --system-libclang --clang-completer --racer-completer --tern-completer' }
endif

call plug#end()
runtime! macros/matchit.vim


" airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.crypt                        = '🔒'
let g:airline_symbols.maxlinenr                    = '☰'
let g:airline_symbols.spell                        = 'Ꞩ'
let g:airline_symbols.notexists                    = '∄'
let g:airline_symbols.whitespace                   = 'Ξ'
let g:airline#extensions#branch#enabled            = 1
let g:airline#extensions#bufferline#enabled        = 1
let g:airline#extensions#csv#enabled               = 1
let g:airline#extensions#hunks#enabled             = 1
let g:airline#extensions#tabline#enabled           = 1
let g:airline#extensions#tagbar#enabled            = 1
let g:airline#extensions#vimagit#enabled           = 1
let g:airline#extensions#nrrwrgn#enabled           = 1
let g:airline#extensions#yc#enabled                = 1
let g:airline_detect_crypt                         = 1
let g:airline_detect_iminsert                      = 1
let g:airline_detect_modified                      = 1
let g:airline_detect_paste                         = 1
let g:airline_inactive_collapse                    = 1
let g:airline_powerline_fonts                      = 1
let g:airline_theme                                = 'tomorrow'
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_buffers      = 0
let g:airline#extensions#tabline#show_splits       = 0
let g:airline#extensions#tabline#show_tabs         = 1
let g:airline#extensions#tabline#show_tab_nr       = 1
let g:airline#extensions#tabline#show_tab_type     = 0
let g:airline#extensions#tabline#tab_nr_type       = 1
let g:airline#extensions#tabline#formatter         = 'unique_tail_improved'
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab


" ale
let g:ale_sign_column_always = 1
let g:ale_sign_error = 'E'
let g:ale_sign_warning = 'W'
let g:ale_emit_conflict_warnings = 0


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


" easytags
let g:easytags_always_enabled = 1
let g:easytags_async = 1
let g:easytags_dynamic_files = 1
let g:easytags_suppress_report = 1
let g:easytags_languages = {
  \   'ruby': {
  \     'cmd': 'ripper-tags',
  \       'args': [],
  \       'fileoutput_opt': '-f',
  \       'stdout_opt': '-f-',
  \       'recurse_flag': '-R'
  \   }
  \}


" fzf
if executable('ng')
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --glob "!_build/*" --glob "!deps/*" --glob "!.DS_Store" --glob "!public/*" --glob "!log/*" --glob "!tmp/*" --glob "!vendor/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
elseif executable('ag')
  command! -bang -nargs=* Ag
    \ call fzf#vim#ag(<q-args>,
    \                 <bang>0 ? fzf#vim#with_preview('up:60%')
    \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
    \                 <bang>0)
endif

" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

map <C-p> :Files<cr>

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'down': '~50%' }
let g:fzf_tags_command = 'ctags -R'


" gitgutter
highlight clear SignColumn
let g:gitgutter_eager     = 0
let g:gitgutter_enabled   = 1
let g:gitgutter_max_signs = 10000
let g:gitgutter_realtime  = -1


" javascript-libraries-syntax
let g:used_javascript_libs = 'jquery,react,flux,requirejs,jasmine,chai,d3'


" nerdtree
nmap <leader>n <plug>NERDTreeTabsToggle<CR>
vmap <leader>n <plug>NERDTreeTabsToggle<CR>


" rspec
let g:rspec_command = 'Dispatch rspec {spec}'


" ruby
let g:ruby_fold = 1


" seeing_is_believing
" Annotate every line
nmap <leader>b :%!seeing_is_believing --timeout 12 --line-length 500 --number-of-captures 300 --alignment-strategy chunk<CR>;
" Annotate marked lines
nmap <leader>n :%.!seeing_is_believing --timeout 12 --line-length 500 --number-of-captures 300 --alignment-strategy chunk --xmpfilter-style<CR>;
" Remove annotations
nmap <leader>c :%.!seeing_is_believing --clean<CR>;
" Mark the current line for annotation
nmap <leader>m A # => <Esc>
" Mark the highlighted lines for annotation
vmap <leader>m :norm A # => <Esc>


" splitjoin.vim
nmap <leader>sj :SplitjoinJoin<cr>
nmap <leader>ss :SplitjoinSplit<cr>


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


" tmux_naviator
let g:tmux_navigator_no_mappings = 1


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


" Ruby refactory
nnoremap <leader>rap  :RAddParameter<cr>
nnoremap <leader>rcpc :RConvertPostConditional<cr>
nnoremap <leader>rel  :RExtractLet<cr>
vnoremap <leader>rec  :RExtractConstant<cr>
vnoremap <leader>relv :RExtractLocalVariable<cr>
nnoremap <leader>rit  :RInlineTemp<cr>
vnoremap <leader>rrlv :RRenameLocalVariable<cr>
vnoremap <leader>rriv :RRenameInstanceVariable<cr>
vnoremap <leader>rem  :RExtractMethod<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup RememberLastPosition
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

augroup GitCommits
  autocmd!
  autocmd FileType gitcommit            nested setlocal nospell
  autocmd VimEnter .git/PULLREQ_EDITMSG nested setlocal filetype=markdown
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Just for TMUX
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

nnoremap <silent> <A-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <A-j> :TmuxNavigateDown<cr>
nnoremap <silent> <A-k> :TmuxNavigateUp<cr>
nnoremap <silent> <A-l> :TmuxNavigateRight<cr>
nnoremap <silent> <A-\> :TmuxNavigatePrevious<cr>

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

imap jk <Esc>
nmap jk <Esc>
vmap jk <Esc>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nmap <M-f> e
nmap <M-b> b

noremap <Tab> gT
noremap <S-Tab> gt
noremap <leader>[ gt
noremap <leader>] gT
noremap <leader>` :tabnew<CR>
noremap <leader><Tab>  :+tabmove<CR>
noremap <leader><S-Tab> :-tabmove<CR>

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

function ShutUp()
  :ALEToggle
  set nonumber
  sign unplace *
endfunction

nmap <silent> <leader>z :call ShutUp()<CR>

syntax on
filetype plugin indent on

if !empty($BASE16_THEME)
  let g:base16colorspace = 256
  colorscheme $BASE16_THEME
  highlight LineNr ctermfg=236 ctermbg=234
endif

if has('termguicolors') && !&termguicolors
  set termguicolors
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('gui_running')
  set guifont=Sauce\ Code\ Pro\ Nerd\ Font\ Complete:h15
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=L  "remove toolbar
  set guioptions-=r  "remove toolbar
  set antialias
  set cursorline
  set mousehide
endif

