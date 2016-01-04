
let g:os=substitute(system('uname'), '\n', '', '')

if v:progname == 'nvim'
  let g:vimhome = '~/.local/share/nvim/site/'
  set viminfo='512,<4096,s512,/512,:512
  if has("gui_running")
    set clipboard+=unnamedplus
  endif
else
  let g:vimhome = '~/.vim/'
  set viminfo='512,<4096,s512,/512,:512,n~/.vim/viminfo
  set clipboard+=unnamed
endif

let config_dirs = ['tmp', 'undo', 'cache', 'autoload', 'plugged', 'backup', 'swap']
for dir in config_dirs
  try
    if !isdirectory(expand(g:vimhome . dir))
      call mkdir(expand(g:vimhome . dir), "p")
    endif
  catch
  endtry
endfor

let mapleader = ","
set autoindent
let &backupdir = expand(g:vimhome . 'backup')
set background=dark
set backspace=indent,eol,start
set binary
let g:cachedir = expand(g:vimhome . 'cache')
let &directory = expand(g:vimhome . 'swap')
set noex
set encoding=utf-8
set noerrorbells
set expandtab
set exrc
set nofoldenable
set formatoptions=rq
set nohidden
set history=8192
set hls
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set list
set listchars=""          " Reset the listchars
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
set visualbell
set t_Co=256
set t_vb=
set wildignore+=*/.cache/*,*/tmp/*,*/.git/*,*/.neocon/*,*.log,*.so,*.swp,*.zip,*.gz,*.bz2,*.bmp,*.ppt
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.dll
set wildmenu
set wildmode=longest,list
set writebackup

if has('persistent_undo')
  let &undodir = expand(g:vimhome . 'undo')
  set undolevels=1000
  set undoreload=10000
  set undofile
endif

if empty(glob(g:vimhome . 'autoload/plug.vim'))
  execute "silent !curl -sfLo " . g:vimhome . "/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall
endif

if has("ruby")
  compiler ruby
endif

let g:use_ag            = 0
let g:use_airline       = 0
let g:use_dash          = 0
let g:use_neocomplete   = 0
let g:use_supertab      = 0
let g:use_youcompleteme = 0

if version >= 702          | let g:use_airline   = 1 | endif
if g:os == 'Darwin'        | let g:use_dash      = 1 | endif

if version >= 704
  if has("lua")
    let g:use_neocomplete = 1
  elseif has("python")
    let g:use_youcompleteme = 1
  endif
endif

if g:use_neocomplete == 0 && g:use_youcompleteme == 0
  let g:use_supertab = 1
endif

if executable('ag')
  let g:use_ag = 1
  set grepprg=ag\ --nogroup\ --nocolor\ --numbers\ $*\ /dev/null
endif

call plug#begin(vimhome . 'plugged')

" Do I really use these?
" Plug 'junegunn/fzf',                  { 'dir': '~/.zsh/fzf', 'do': 'yes \| ./install' }
" Plug 'tpope/vim-repeat'
" Plug 'tpope/vim-sleuth'
" Plug 'tpope/vim-speeddating'
" Plug 'tpope/vim-surround'
" Plug 'vim-scripts/grep.vim'

" Utils
Plug 'AndrewRadev/splitjoin.vim'
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-bufferline'
Plug 'chrisbra/NrrwRgn'
Plug 'chriskempson/base16-vim'
Plug 'godlygeek/tabular'
Plug 'kana/vim-textobj-user'
Plug 'kien/ctrlp.vim'
Plug 'mbbill/undotree'
Plug 'oplatek/Conque-Shell'
Plug 'scrooloose/nerdtree',            { 'on':  'NERDTreeToggle' }
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vividchalk'
if version >= 704
  Plug 'FredKSchott/CoVim'
  Plug 'xolox/vim-easytags'
  Plug 'xolox/vim-misc'
  Plug 'xolox/vim-shell'
endif

" Filetypes
Plug 'JulesWang/css.vim',              { 'for': [ 'css', 'sass', 'scss' ] }
Plug 'acustodioo/vim-tmux',            { 'for': 'tmux' }
Plug 'fatih/vim-go',                   { 'for': 'go' }
Plug 'kchmck/vim-coffee-script',       { 'for': 'coffeescript' }
Plug 'ksauzz/haproxy.vim',             { 'for': 'haproxy' }
Plug 'kurayama/systemd-vim-syntax',    { 'for': 'systemd' }
Plug 'leshill/vim-json',               { 'for': 'json' }
Plug 'mitsuhiko/vim-python-combined',  { 'for': 'python' }
Plug 'mutewinter/nginx.vim',           { 'for': 'nginx' }
Plug 'nelstrom/vim-textobj-rubyblock', { 'for': 'ruby' }
Plug 'othree/html5.vim',               { 'for': 'html' }
Plug 'pangloss/vim-javascript',        { 'for': 'javascript' }
Plug 'sheerun/vim-yardoc',             { 'for': 'yard' }
Plug 'tpope/vim-bundler',              { 'for': 'ruby' }
Plug 'tpope/vim-cucumber',             { 'for': 'ruby' }
Plug 'tpope/vim-haml',                 { 'for': 'haml' }
Plug 'tpope/vim-markdown',             { 'for': 'markdown' }

" tmux / ruby / tests
Plug 'majutsushi/tagbar',              { 'for': 'ruby' }
Plug 'benmills/vimux',                 { 'for': 'ruby' }
Plug 'christoomey/vim-tmux-navigator', { 'for': 'ruby' }
Plug 'jgdavey/vim-turbux',             { 'for': 'ruby' }
Plug 'skalnik/vim-vroom',              { 'for': 'ruby' }
Plug 't9md/vim-ruby-xmpfilter',        { 'for': 'ruby' }
Plug 'thoughtbot/vim-rspec',           { 'for': 'ruby' }
Plug 'tpope/vim-endwise',              { 'for': 'ruby' }
Plug 'tpope/vim-rails',                { 'for': 'ruby' }
Plug 'tpope/vim-rake',                 { 'for': 'ruby' }
Plug 'tpope/vim-rbenv',                { 'for': 'ruby' }
Plug 'vim-ruby/vim-ruby',              { 'for': 'ruby' }
"
Plug 'scrooloose/syntastic'

if g:use_airline == 1       | Plug 'bling/vim-airline'                                | endif
if g:use_ag == 1            | Plug 'rking/ag.vim'                                     | endif
if g:use_dash == 1          | Plug 'rizzatti/dash.vim'                                | endif
if g:use_neocomplete == 1   | Plug 'Shougo/neocomplete.vim'                           | endif
if g:use_youcompleteme == 1 | Plug 'Valloric/YouCompleteMe', { 'do': './install.py' } | endif
if g:use_supertab == 1      | Plug 'ervandew/supertab'                                | endif

call plug#end()
runtime macros/matchit.vim

" airline
let g:airline_detect_crypt                         = 1
let g:airline_detect_iminsert                      = 0
let g:airline_detect_modified                      = 1
let g:airline_detect_paste                         = 1
let g:airline_inactive_collapse                    = 1
let g:airline_powerline_fonts                      = 0
let g:airline_left_sep                             = ''
let g:airline_right_sep                            = ''
let g:airline#extensions#branch#format             = 1
let g:airline#extensions#bufferline#enabled        = 1
let g:airline#extensions#ctrlspace#enabled         = 1
let g:airline#extensions#nrrwrgn#enabled           = 1
let g:airline#extensions#syntastic#enabled         = 0
let g:airline#extensions#tabline#enabled           = 0
let g:airline#extensions#tagbar#enabled            = 0
let g:airline#extensions#tmuxline#enabled          = 0
" let g:airline#extensions#tabline#show_close_button = 0
" let g:airline#extensions#tabline#buffer_idx_mode   = 1
" let g:airline#extensions#tabline#show_buffers      = 1
" let g:airline#extensions#tabline#show_tabs         = 1
let g:airline_section_b                            = '%{getcwd()}'
" nmap <leader>1 <Plug>AirlineSelectTab1
" nmap <leader>2 <Plug>AirlineSelectTab2
" nmap <leader>3 <Plug>AirlineSelectTab3
" nmap <leader>4 <Plug>AirlineSelectTab4
" nmap <leader>5 <Plug>AirlineSelectTab5
" nmap <leader>6 <Plug>AirlineSelectTab6
" nmap <leader>7 <Plug>AirlineSelectTab7
" nmap <leader>8 <Plug>AirlineSelectTab8
" nmap <leader>9 <Plug>AirlineSelectTab9


" base16-vim
if &term == 'xterm-256color' || &term == 'screen-256color' || &t_Co == 256
  let base16colorspace = 256
endif


" bufferline
let g:bufferline_active_buffer_left  = '['
let g:bufferline_active_buffer_right = ']'
let g:bufferline_echo                = 1
let g:bufferline_modified            = '+'
let g:bufferline_rotate              = 0
let g:bufferline_show_bufnr          = 1
let g:bufferline_solo_highlight      = 1


" CoVim
let CoVim_default_name = "chorn"
let CoVim_default_port = "22222"


" ctrlp.vim
let g:ctrlp_extensions     = ['funky']
let g:ctrlp_map            = '<c-t>'
let g:ctrlp_match_window   = 'bottom,order:btt,min:1,max:20,results:20'
let g:ctrlp_show_hidden    = 1
let g:ctrlp_use_caching    = 0
if g:use_ag == 1
  let g:ctrlp_user_command = 'ag --files-with-matches --nocolor -g "" %s'
endif
nnoremap <leader>. :CtrlPTag<cr>


" gitgutter
highlight clear SignColumn
let g:gitgutter_eager     = 0
let g:gitgutter_enabled   = 1
let g:gitgutter_max_signs = 10000
let g:gitgutter_realtime  = 0


" neocomplete.vim
if g:use_neocomplete
  if !isdirectory(expand(g:cachedir . '/neocomplete'))
    call mkdir(expand(g:cachedir . '/neocomplete'), "p")
  endif
  let g:neocomplete#data_directory                    = g:cachedir.'/neocomplete'
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

  let g:neocomplete#sources#dictionary#dictionaries = {
      \ 'default' : '',
      \ 'vimshell' : expand(vimhome . 'vimshell')
      \ }

  " inoremap <expr><C-g> neocomplete#undo_completion()
  " inoremap <expr><C-l> neocomplete#complete_common_string()
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return pumvisible() ? neocomplete#close_popup() : "\<CR>"
  endfunction

  " <TAB>: completion.
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  "" <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS>  neocomplete#smart_close_popup()."\<C-h>"
  " inoremap <expr><C-y> neocomplete#close_popup()
  " inoremap <expr><C-e> neocomplete#cancel_popup()
endif


" nerdtree
nmap <leader>n :NERDTreeToggle<CR>
vmap <leader>n :NERDTreeToggle<CR>


" rspec
let g:rspec_command = "compiler rspec | set makeprg=zeus | Make rspec {spec}"
map <leader>ra :call RunAllSpecs()<CR>
map <leader>rl :call RunLastSpec()<CR>
map <leader>rr :call RunCurrentSpecFile()<CR>
map <leader>rs :call RunNearestSpec()<CR>


" ruby-xmpfilter
let g:xmpfilter_cmd = "xmpfilter --annotations --rails"


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
let g:syntastic_sh_shellcheck_args       = '--exclude=SC2001,SC1090,SC2164'
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

" tags (ctags)
" let g:vim_tags_auto_generate = 1
" " let g:vim_tags_project_tags_command = "{CTAGS} -R {OPTIONS} {DIRECTORY} 2>/dev/null"
" " let g:vim_tags_gems_tags_command = "{CTAGS} -R {OPTIONS} `bundle show --paths` 2>/dev/null"
" let g:vim_tags_use_vim_dispatch = 1
" let g:vim_tags_use_language_field = 1
" let g:vim_tags_ignore_files = ['.gitignore', 'certs', 'checksums', 'coverage', 'data', 'log', 'pkg', 'tmp']
" " let g:vim_tags_main_file = 'tags'
" " let g:vim_tags_extension = '.tags'
" let g:vim_tags_cache_dir = expand(g:cachedir.'/ctags')
" if !isdirectory(expand(g:cachedir . '/ctags'))
"   call mkdir(expand(g:cachedir . '/ctags'), "p")
" endif


" tcomment_vim
map \\ gcc
vmap \\ gc
if !exists('g:tcomment_types')
  let g:tcomment_types = {}
endif
let g:tcomment_types = { 'java' : '// %s' }
let g:tcomment_types = { 'tmux' : '# %s' }


" tmux-navigator
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <A-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <A-j> :TmuxNavigateDown<cr>
nnoremap <silent> <A-k> :TmuxNavigateUp<cr>
nnoremap <silent> <A-l> :TmuxNavigateRight<cr>
nnoremap <silent> <A-\> :TmuxNavigatePrevious<cr>


" undotree
nmap <leader>u :UndotreeToggle<CR>
vmap <leader>u :UndotreeToggle<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('autocmd')
  augroup Ruby
    autocmd!
    autocmd FileType ruby nmap <buffer> <F5> <Plug>(xmpfilter-mark)
    autocmd FileType ruby imap <buffer> <F5> <Plug>(xmpfilter-mark)
    autocmd FileType ruby vmap <buffer> <F5> <Plug>(xmpfilter-mark)
    autocmd FileType ruby nmap <buffer> <F6> <Plug>(xmpfilter-run)
    autocmd FileType ruby imap <buffer> <F6> <Plug>(xmpfilter-run)
    autocmd FileType ruby vmap <buffer> <F6> <Plug>(xmpfilter-run)

    " autocmd BufNewFile,BufRead *.cap      nested setlocal filetype=ruby
    " autocmd BufNewFile,BufRead *.thor     nested setlocal filetype=ruby
    " autocmd BufNewFile,BufRead *.html.erb nested setlocal filetype=eruby.html
    " autocmd BufNewFile,BufRead *.js.erb   nested setlocal filetype=eruby.javascript
    " autocmd BufNewFile,BufRead *.rb.erb   nested setlocal filetype=eruby.ruby
    " autocmd BufNewFile,BufRead *.sh.erb   nested setlocal filetype=eruby.sh
    " autocmd BufNewFile,BufRead *.yml.erb  nested setlocal filetype=eruby.yaml
    " autocmd BufNewFile,BufRead *.txt.erb  nested setlocal filetype=eruby.text
  augroup END

  augroup GitCommits
    autocmd!
    autocmd FileType gitcommit            nested setlocal nospell
    autocmd VimEnter .git/PULLREQ_EDITMSG nested setlocal filetype=markdown
  augroup END

  augroup gitCommitEditMsg
    autocmd!
    autocmd BufReadPost *
      \ if @% == '.git/COMMIT_EDITMSG' |
      \   exe "normal gg" |
      \ endif
  augroup END

  augroup vimrcEx
    autocmd!
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif
  augroup END

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

command! KillWhitespace :normal :%s/ *$//g<cr><c-o><cr>
syntax on
filetype on
filetype plugin on
filetype indent on

for _cs in ['vividchalk', 'base16-twilight']
  try
    execute 'colorscheme' _cs
  catch
  endtry
endfor

" My colorscheme overrides
highlight LineNr ctermfg=236 ctermbg=234

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
  set guifont=Source\ Code\ Pro\ Light:h14
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=L  "remove toolbar
  set guioptions-=r  "remove toolbar
  set anti
  set cursorline
  set mousehide
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

