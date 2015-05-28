
if v:progname == 'nvim'
  let vimhome = '~/.nvim/'
  set clipboard+=unnamedplus
  set viminfo='512,<4096,s512,/512,:512,n~/.nvim/viminfo
else
  let vimhome = '~/.vim/'
  set clipboard+=unnamed
  set viminfo='512,<4096,s512,/512,:512,n~/.vim/viminfo
  set nocompatible
endif

let config_dirs = ['tmp', 'undo', 'cache', 'autoload', 'plugged', 'backup', 'swap']
for dir in config_dirs
  try
    if !isdirectory(expand(vimhome . dir))
      call mkdir(expand(vimhome . dir), "p")
    endif
  catch
  endtry
endfor

let mapleader = ","
set autoindent
let &backupdir = expand(vimhome . 'backup')
set background=dark
set backspace=indent,eol,start
set binary
let &directory = expand(vimhome . 'swap')
set noex
set encoding=utf-8
set noerrorbells
set expandtab
set nofoldenable
set formatoptions=rq
set nohidden
set history=8192
set hls
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set linespace=0
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
set ruler
set scrolloff=3
set shiftwidth=2
set shortmess+=I
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
" set tags=./tags
set noterse
set visualbell
set t_Co=256
set t_vb=
let &undodir = expand(vimhome . 'undo')
set undolevels=1000
set undoreload=10000
set wildignore+=*/.cache/*,*/tmp/*,*/.git/*,*/.neocon/*,*.log,*.so,*.swp,*.zip,*.gz,*.bz2,*.bmp,*.ppt
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.dll
set wildmenu
set wildmode=longest,list
set writebackup
set winwidth=84 " We have to have a winheight bigger than we want to set winminheight. But if we set winheight to be huge before winminheight, the winminheight set will fail.
set winheight=5
set winminheight=5
set winheight=999

if has("ruby")
  compiler ruby
endif

let g:use_neocomplete = 0
let g:use_youcompleteme = 0

if version >= 704
  if has("lua")
    let g:use_neocomplete = 1
  else
    let g:use_youcompleteme = 1
  endif
endif

let g:cachedir = expand(vimhome . 'cache')

if empty(glob(vimhome . 'autoload/plug.vim'))
  if v:progname == 'nvim'
    silent !curl -sfLo ~/.nvim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim
  else
    silent !curl -sfLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim
  endif
  autocmd VimEnter * PlugInstall
endif

call plug#begin(vimhome . 'plugged')

Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-haml',                { 'for': 'haml' }
Plug 'othree/html5.vim',              { 'for': 'html' }
Plug 'StanAngeloff/php.vim',          { 'for': 'php' }
Plug 'fatih/vim-go',                  { 'for': 'go' }
Plug 'guns/vim-clojure-static',       { 'for': 'clojure' }
Plug 'ksauzz/haproxy.vim',            { 'for': 'haproxy' }
Plug 'kurayama/systemd-vim-syntax',   { 'for': 'systemd' }
Plug 'leshill/vim-json',              { 'for': 'json' }
Plug 'mitsuhiko/vim-python-combined', { 'for': 'python' }
Plug 'mutewinter/nginx.vim',          { 'for': 'nginx' }
Plug 'oscarh/vimerl',                 { 'for': 'erlang' }
Plug 'rodjek/vim-puppet',             { 'for': 'puppet' }
Plug 'sheerun/vim-yardoc',            { 'for': 'yard' }
Plug 'tpope/vim-markdown',            { 'for': 'markdown' }
Plug 'travitch/hasksyn',              { 'for': 'haskell' }
Plug 'vim-scripts/R.vim',             { 'for': 'r' }
Plug 'vim-scripts/ael.vim',           { 'for': 'ael' }
Plug 'acustodioo/vim-tmux'
Plug 'JulesWang/css.vim',             { 'for': [ 'css', 'sass', 'scss' ] }
Plug 'ap/vim-css-color',              { 'for': [ 'css', 'sass', 'scss' ] }
Plug 'powerman/vim-plugin-AnsiEsc'

Plug 'pangloss/vim-javascript',       { 'for': [ 'javascript', 'coffeescript' ] }
Plug 'kchmck/vim-coffee-script',      { 'for': [ 'javascript', 'coffeescript' ] }

Plug 'tpope/vim-rails',               { 'for': 'ruby' }
Plug 'tpope/vim-rake',                { 'for': 'ruby' }
Plug 'vim-ruby/vim-ruby',             { 'for': 'ruby' }
Plug 'ecomba/vim-ruby-refactoring',   { 'for': 'ruby' }
Plug 'henrik/vim-ruby-runner',        { 'for': 'ruby' }
Plug 'tpope/vim-bundler',             { 'for': 'ruby' }
Plug 'tpope/vim-rbenv',               { 'for': 'ruby' }
Plug 'tpope/vim-rvm',                 { 'for': 'ruby' }
Plug 'tpope/vim-cucumber',            { 'for': 'ruby' }
Plug 'thoughtbot/vim-rspec',          { 'for': 'ruby' }
Plug 't9md/vim-ruby-xmpfilter',       { 'for': 'ruby' }

" Plug 'gcmt/wildfire.vim'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'

Plug 'tpope/vim-git'
Plug 'AndrewRadev/splitjoin.vim'
" Plug 'mattn/gist-vim'
Plug 'mbbill/undotree'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
" Plug 'vim-scripts/grep.vim'
Plug 'rking/ag.vim'
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree',           { 'on':  'NERDTreeToggle' }
Plug 'scrooloose/syntastic'
Plug 'godlygeek/tabular'
Plug 'majutsushi/tagbar'
Plug 'tomtom/tcomment_vim'
Plug 'junegunn/fzf' ",                  { 'do': 'yes \| ./install' }
Plug 'Shougo/vimproc.vim',            { 'do': 'make' }

" Colors
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-vividchalk'
Plug 'chriskempson/base16-vim'
Plug 'chrisbra/color_highlight'


if g:use_neocomplete > 0
  Plug 'Shougo/neocomplete.vim'
endif

if g:use_youcompleteme > 0
  Plug 'Valloric/YouCompleteMe',      { 'do': './install.sh' }
endif

call plug#end()

filetype plugin indent on
syntax on
silent! colorscheme vividchalk

" airline
let g:airline_theme                       = 'murmur'
let g:airline_powerline_fonts             = 0
let g:airline_left_sep                    = ''
let g:airline_right_sep                   = ''
let g:airline#extensions#tabline#enabled  = 1
let g:airline#extensions#tmuxline#enabled = 1

" ctrlp
let g:ctrlp_show_hidden                   = 1
let g:ctrlp_extensions                    = ['funky']
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command        = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching         = 0
else
  let g:ctrlp_cache_dir           = cachedir.'/ctrlp'
  let g:ctrlp_use_caching         = 1
  let g:ctrlp_clear_cache_on_exit = 1
endif

" gitgutter
highlight clear SignColumn
let g:gitgutter_enabled                   = 0
let g:gitgutter_realtime                  = 0
let g:gitgutter_eager                     = 0
let g:gitgutter_max_signs                 = 10000

" nerdtree
nmap <leader>n :NERDTreeToggle<CR>
vmap <leader>n :NERDTreeToggle<CR>

" rspec
let g:rspec_command = "compiler rspec | set makeprg=zeus | Make rspec {spec}"
map <leader>ra :call RunAllSpecs()<CR>
map <leader>rl :call RunLastSpec()<CR>
map <leader>rr :call RunCurrentSpecFile()<CR>
map <leader>rs :call RunNearestSpec()<CR>

" syntastic
let g:syntastic_auto_jump                = 1
let g:syntastic_auto_loc_list            = 1
let g:syntastic_auto_loc_list            = 1 " Close the location-list when errors are gone
let g:syntastic_check_on_open            = 0
let g:syntastic_enable_signs             = 1
let g:syntastic_error_symbol             = '✗✗'
let g:syntastic_loc_list_height          = 5
let g:syntastic_ruby_checkers            = ['mri', 'jruby', 'rubocop']
let g:syntastic_ruby_rubocop_args        = '--display-cop-names'
let g:syntastic_sass_checkers            = ['sass']
let g:syntastic_scss_checkers            = ['sass']
let g:syntastic_sh_checkbashisms_args    = '-x'
let g:syntastic_sh_checkers              = ['shellcheck', 'checkbashisms', 'sh']
let g:syntastic_style_error_symbol       = '✗'
let g:syntastic_style_warning_symbol     = '⚠'
let g:syntastic_warning_symbol           = '⚠⚠'
let g:syntastic_xml_checkers             = ['xmllint']
let g:syntastic_xslt_checkers            = ['xmllint']

" tabular
nmap <leader>a= :Tabularize /=<CR>
vmap <leader>a= :Tabularize /=<CR>
nmap <leader>a: :Tabularize /:\zs<CR>
vmap <leader>a: :Tabularize /:\zs<CR>

" tagbar
nmap <leader>t :TagbarToggle<CR>
vmap <leader>t :TagbarToggle<CR>

" undotree
nmap <leader>u :UndotreeToggle<CR>
vmap <leader>u :UndotreeToggle<CR>

" tcomment
map \\ gcc
vmap \\ gc

if !exists('g:tcomment_types')
  let g:tcomment_types = {}
endif
let g:tcomment_types = { 'java' : '// %s' }
let g:tcomment_types = { 'tmux' : '# %s' }

" wildfire
map <SPACE> <Plug>(wildfire-fuel)
vmap <C-SPACE> <Plug>(wildfire-water)
let g:wildfire_objects = ["i'", 'i"', "i)", "i]", "i}", "ip", "it"]
nmap <leader>s <Plug>(wildfire-quick-select)

" neocomplete
if g:use_neocomplete
  let g:neocomplete#data_directory                    = cachedir.'/neocomplete'
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
  let g:neocomplete#keyword_patterns.perl             = '\h\w*->\h\w*\|\h\w*::\w*'
  let g:neocomplete#lock_buffer_name_pattern          = '\*ku\*'
  let g:neocomplete#manual_completion_start_length    = 0
  let g:neocomplete#min_keyword_length                = 3
  let g:neocomplete#same_filetypes                    = {}
  let g:neocomplete#same_filetypes._                  = '_'
  let g:neocomplete#same_filetypes.gitconfig          = '_'
  let g:neocomplete#sources#omni#input_patterns       = {}
  let g:neocomplete#sources#omni#input_patterns.c     = '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplete#sources#omni#input_patterns.cpp   = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:neocomplete#sources#omni#input_patterns.php   = '[^. \t]->\h\w*\|\h\w*::'
  let g:neocomplete#sources#syntax#min_keyword_length = 4

  let g:neocomplete#sources#dictionary#dictionaries = {
      \ 'default' : '',
      \ 'vimshell' : expand(vimhome . 'vimshell')
      \ }

  inoremap <expr><C-g> neocomplete#undo_completion()
  inoremap <expr><C-l> neocomplete#complete_common_string()
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return pumvisible() ? neocomplete#close_popup() : "\<CR>"
  endfunction

  " <TAB>: completion.
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  "" <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS>  neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y> neocomplete#close_popup()
  inoremap <expr><C-e> neocomplete#cancel_popup()
endif

if has('autocmd')
  augroup OmniCompleteModes
    autocmd!
    autocmd FileType python        nested setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType ruby,eruby    nested setlocal omnifunc=rubycomplete#Complete
    autocmd FileType css           nested setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown nested setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript    nested setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType xml           nested setlocal omnifunc=xmlcomplete#CompleteTags
  augroup END
endif

" xmpfilter
if has('autocmd')
  if executable('seeing_is_believing')
    let g:xmpfilter_cmd = "seeing_is_believing"
    autocmd FileType ruby nmap <buffer> <Leader>m <Plug>(seeing_is_believing-mark)
    autocmd FileType ruby xmap <buffer> <Leader>m <Plug>(seeing_is_believing-mark)
    autocmd FileType ruby imap <buffer> <Leader>m <Plug>(seeing_is_believing-mark)
    autocmd FileType ruby nnoremap <buffer> <Leader>c <Plug>(seeing_is_believing-clean)
    autocmd FileType ruby xnoremap <buffer> <Leader>c <Plug>(seeing_is_believing-clean)
    autocmd FileType ruby inoremap <buffer> <Leader>c <Plug>(seeing_is_believing-clean)
    " xmpfilter compatible
    autocmd FileType ruby nmap <buffer> <Leader>r <Plug>(seeing_is_believing-run_-x)
    autocmd FileType ruby xmap <buffer> <Leader>r <Plug>(seeing_is_believing-run_-x)
    autocmd FileType ruby imap <buffer> <Leader>r <Plug>(seeing_is_believing-run_-x)
    " auto insert mark at appropriate spot.
    autocmd FileType ruby nmap <buffer> <F12> <Plug>(seeing_is_believing-run)
    autocmd FileType ruby xmap <buffer> <F12> <Plug>(seeing_is_believing-run)
    autocmd FileType ruby imap <buffer> <F12> <Plug>(seeing_is_believing-run)
  endif
endif

"""""""
" map <leader>' ""yls<c-r>={'"': "'", "'": '"'}[@"]<cr><esc>
map <leader>[ gt
map <leader>] gT
map <leader>e :edit %%
map <leader>v :view %%

command! KillWhitespace :normal :%s/ *$//g<cr><c-o><cr>

" i just don't hate myself enough
" nnoremap <left> <C-w>h
" nnoremap <right> <C-w>l
" nnoremap <up> <C-w>k
" nnoremap <down> <C-w>j
" inoremap <up> <nop>
" inoremap <down> <nop>
" inoremap <left> <nop>
" inoremap <right> <nop>

nnoremap <CR> :nohlsearch<cr>
imap <c-l> <space>=><space>
vnoremap < <gv
vnoremap > >gv
vmap <Tab> >gv
vmap <S-Tab> <gv
cnoremap %% <C-R>=expand('%:h').'/'<cr>
noremap Q <nop>

let g:colorizer_auto_filetype            = 'css,scss,sass,html'

if has("gui_running")
  set guifont=Source\ Code\ Pro\ Light:h14
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=L  "remove toolbar
  set guioptions-=r  "remove toolbar
  set anti
  set browsedir=current
  set columns=179
  set cursorline
  set lines=43
  set mousehide
  set number
  set numberwidth=5
  let g:gitgutter_enabled = 1
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

if has('autocmd')
  autocmd FileType ruby,haml,eruby,yaml,html,sass,cucumber,java,jsp,xml set ai sw=2 sts=2 et

  augroup Ruby
    autocmd!
    autocmd FileType ruby,eruby nested setlocal cinwords=do
    autocmd FileType ruby,eruby nested let g:rubycomplete_buffer_loading = 0
    autocmd FileType ruby,eruby nested let g:rubycomplete_rails = 1
    autocmd FileType ruby,eruby nested let g:rubycomplete_classes_in_global = 1

    " Other ruby
    autocmd BufNewFile,BufRead *.cap      nested setlocal filetype=ruby
    autocmd BufNewFile,BufRead *.thor     nested setlocal filetype=ruby
    autocmd BufNewFile,BufRead *.html.erb nested setlocal filetype=eruby.html
    autocmd BufNewFile,BufRead *.js.erb   nested setlocal filetype=eruby.javascript
    autocmd BufNewFile,BufRead *.rb.erb   nested setlocal filetype=eruby.ruby
    autocmd BufNewFile,BufRead *.sh.erb   nested setlocal filetype=eruby.sh
    autocmd BufNewFile,BufRead *.yml.erb  nested setlocal filetype=eruby.yaml
    autocmd BufNewFile,BufRead *.txt.erb  nested setlocal filetype=eruby.text
  augroup END

  augroup CandFriends
    autocmd!
    autocmd FileType java,c,cpp,objc nested setlocal smartindent expandtab shiftwidth=2 softtabstop=2
  augroup END

  augroup JavaScript
    autocmd!
    autocmd FileType javascript nested setlocal smartindent expandtab shiftwidth=4 softtabstop=4
    if has('conceal')
      autocmd FileType json nested setlocal concealcursor= conceallevel=1
    endif
  augroup END

  augroup GitCommits
    autocmd!
    autocmd FileType gitcommit            nested setlocal spell
    autocmd VimEnter .git/PULLREQ_EDITMSG nested setlocal filetype=markdown
  augroup END

  augroup vimrcEx
    au!
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif
  augroup END

  " autocmd BufWritePre {*.rb,*.js,*.coffee,*.scss,*.sass,*.haml,*.java,*.jsp} :%s/\s\+$//e
  " autocmd BufEnter * lcd %:p:h

endif

function! ToTab(cmd)
  redir => message
  silent execute a:cmd
  redir END
  tabnew
  silent put=message
  set nomodified
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

