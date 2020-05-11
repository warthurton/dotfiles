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
  set clipboard=unnamedplus
else
  let g:vimhome = SafeDirectory('~/.vim')
  set clipboard+=autoselect
endif

let &backupdir    = SafeDirectory(g:vimhome . '/backup')
let &directory    = SafeDirectory(g:vimhome . '/swap')
let &viewdir      = SafeDirectory(g:vimhome . '/view')
let &undodir      = SafeDirectory(g:vimhome . '/undo')
let g:autoloadhome = SafeDirectory(g:vimhome . '/autoload')
let g:cachedir     = SafeDirectory(g:vimhome . '/cache')
let g:vimplug_exists = expand(g:autoloadhome . '/plug.vim')

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

if executable('git')
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
endif

if executable('go')
  Plug 'fatih/vim-go', { 'for': 'go' }
endif

if executable('node')
  Plug 'othree/yajs.vim', { 'for': 'javascript' }
  Plug 'othree/es.next.syntax.vim', { 'for': 'javascript' }
  Plug 'othree/javascript-libraries-syntax.vim', { 'for': 'javascript' }
  Plug 'isRuslan/vim-es6', { 'for': 'javascript' }
  Plug 'prettier/vim-prettier', { 'do': 'npm i', 'branch': 'release/1.x', 'for': [
      \ 'javascript',
      \ 'typescript',
      \ 'css',
      \ 'less',
      \ 'scss',
      \ 'json',
      \ 'graphql',
      \ 'markdown',
      \ 'vue',
      \ 'lua',
      \ 'python',
      \ 'ruby',
      \ 'html',
      \ 'swift' ] }
  Plug 'moll/vim-node', { 'for': 'javascript' }
  Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
endif

if executable('rails')
  Plug 'tpope/vim-haml', { 'for': 'haml' }
  Plug 'tpope/vim-rails', { 'for': 'ruby' }
  Plug 'tpope/vim-rhubarb'
  Plug 'thoughtbot/vim-rspec', { 'for': 'ruby' }
endif

if executable('ruby')
  Plug 'tpope/vim-bundler', { 'for': 'ruby' }
  Plug 'tpope/vim-endwise', { 'for': 'ruby' }
  Plug 'tpope/vim-rake', { 'for': 'ruby' }
  Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
endif

if executable('rustc')
  Plug 'rust-lang/rust.vim', { 'for': 'rust' }
  Plug 'racer-rust/vim-racer', { 'for': 'rust' }
endif

" if has('nvim')
"   Plug 'norcalli/nvim-colorizer.lua'
" endif

" Plug 'tpope/vim-characterize'
" Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
" Plug 'tpope/vim-vinegar'
Plug 'junegunn/fzf', { 'dir': '~/.config/fzf', 'do': './install --no-update-rc --key-bindings --completion' }
Plug 'junegunn/fzf.vim'


" Plug 'junegunn/gv.vim'
" Plug 'junegunn/rainbow_parentheses.vim'
Plug 'junegunn/vim-easy-align'
" Plug 'junegunn/vim-emoji'
" Plug 'junegunn/vim-slash'
" Plug 'mhinz/vim-signify'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'chriskempson/base16-vim'
Plug 'mbbill/undotree'
Plug 'scrooloose/nerdtree'
Plug 'tomtom/tcomment_vim'
" Plug 'w0rp/ale'
Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'

" Filetypes
Plug 'kchmck/vim-coffee-script',                   { 'for': 'coffee' }
Plug 'rhysd/vim-crystal',                          { 'for': 'crystal' }
Plug 'JulesWang/css.vim',                          { 'for': [ 'css', 'sass', 'scss' ] }
Plug 'chrisbra/csv.vim',                           { 'for': 'csv' }
Plug 'elixir-lang/vim-elixir',                     { 'for': 'elixir' }
Plug 'spiegela/vimix',                             { 'for': 'elixir' }
Plug 'othree/html5.vim',                           { 'for': 'html' }
Plug 'plasticboy/vim-markdown',                    { 'for': 'markdown' }
Plug 'tmux-plugins/vim-tmux',                      { 'for': 'tmux' }
Plug 'ambv/black',                                 { 'for': 'python' }
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'neoclide/jsonc.vim'

if executable('node')
  Plug 'neoclide/coc.nvim', { 'branch' : 'release' }
else
  Plug 'maralla/completor.vim', { 'do': 'make js' }
endif

if v:version >= 702
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'ryanoasis/vim-devicons'
endif

if has('python3')
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
endif

call plug#end()
runtime! macros/matchit.vim

set autoindent
set background=dark
set backspace=indent,eol,start
set backup
set binary
set cmdheight=2
set completeopt=menu,menuone,preview,noinsert
set cursorline
set display+=lastline
set noexrc
set noerrorbells
set expandtab
set exrc
set nofoldenable
set foldmethod=marker
set foldopen+=jump
set formatoptions=rq
set guioptions+=P
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
set scrolljump=5
set scrolloff=1
set secure
set shiftwidth=2
set shortmess+=c
set noshowcmd
set showmatch
set signcolumn=yes
set noshowmode
set showtabline=1
set smartcase
set smartindent
set smarttab
set softtabstop=2
set splitbelow
set splitright
set tabstop=2
set tags=./tags;,~/.vimtags
set noterse
set viminfo='100,<1000,s1000,:1000
set visualbell
set t_vb=
set t_Co=256
set ttimeout
set ttimeoutlen=50
set updatetime=300
set winaltkeys=no
set wildignore+=tags,*/.cache/*,*/tmp/*,*/.git/*,*/.svn/*,*.log,*.so,*.swp,*.zip,*.gz,*.bz2,*.bmp,*.ppt,.DS_Store
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.dll
set wildmenu
set wildmode=list:longest:full
set writebackup

if has('persistent_undo')
  set undofile
  set undolevels=10000
  set undoreload=100000
endif

if exists($TMUX)
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

let g:mapleader = ','
let g:is_bash = 1

" airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.crypt                        = '🔒'
let g:airline_symbols.maxlinenr                    = '☰'
let g:airline_symbols.spell                        = 'Ꞩ'
let g:airline_symbols.notexists                    = '∄'
let g:airline_symbols.whitespace                   = 'Ξ'
let g:airline#extensions#ale#enabled               = 1
let g:airline#extensions#branch#enabled            = 1
let g:airline#extensions#bufferline#enabled        = 1
let g:airline#extensions#csv#enabled               = 1
let g:airline#extensions#hunks#enabled             = 1
let g:airline#extensions#tabline#enabled           = 0
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
let g:airline#extensions#tabline#show_buffers      = 1
let g:airline#extensions#tabline#show_splits       = 0
let g:airline#extensions#tabline#show_tabs         = 0
let g:airline#extensions#tabline#show_tab_nr       = 0
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
let g:ale_change_sign_column_color = 0
let g:ale_lint_delay = 50
let g:ale_lint_on_enter = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_column_always = 1
let g:ale_sign_error = 'E'
let g:ale_sign_warning = 'W'
let g:ale_emit_conflict_warnings = 1
let g:ale_javascript_eslint_use_global = 0
let g:ale_javascript_flow_use_global = 0
let g:ale_javascript_standard_use_global = 0
let g:ale_javascript_xo_use_global = 0
let g:ale_ruby_rubocop_options = '-EDS'
let g:ale_fixers = {
  \ 'javascript': ['eslint'],
  \ 'typescript': ['eslint'],
\ }
let g:ale_pattern_options = {
  \ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
  \ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
\}
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)


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


" coc
if executable('node')
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
  " Coc only does snippet and additional edit on confirm.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  " Use `[c` and `]c` to navigate diagnostics
  nmap <silent> [c <Plug>(coc-diagnostic-prev)
  nmap <silent> ]c <Plug>(coc-diagnostic-next)

  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Remap for rename current word
  nmap <leader>rn <Plug>(coc-rename)

  " Remap for format selected region
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap for do codeAction of current line
  nmap <leader>ac  <Plug>(coc-codeaction)
  " Fix autofix problem of current line
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Use `:Format` to format current buffer
  command! -nargs=0 Format :call CocAction('format')

  " Use `:Fold` to fold current buffer
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)


  " Add diagnostic info for https://github.com/itchyny/lightline.vim
  let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
        \ },
        \ 'component_function': {
        \   'cocstatus': 'coc#status'
        \ },
        \ }

  " Using CocList
  " Show all diagnostics
  nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
  " Manage extensions
  nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
  " Show commands
  nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
  " Find symbol of current document
  nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
  " Search workspace symbols
  nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list
  nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
endif

" completor
let g:completor_auto_trigger = 1
let g:completor_filesize_limit = 10240

" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"

" function! Tab_Or_Complete() abort
"   " If completor is already open the `tab` cycles through suggested completions.
"   if pumvisible()
"     return "\<C-N>"
"   " If completor is not open and we are in the middle of typing a word then
"   " `tab` opens completor menu.
"   elseif col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
"     return "\<C-R>=completor#do('complete')\<CR>"
"   else
"     " If we aren't typing a word and we press `tab` simply do the normal `tab`
"     " action.
"     return "\<Tab>"
"   endif
" endfunction
"
" " Use `tab` key to select completions.  Default is arrow keys.
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <Tab> Tab_Or_Complete()

" Use tab to trigger auto completion.  Default suggests completions as you type.
" let g:completor_auto_trigger = 1
" let g:completor_filesize_limit = 10240
" let g:completor_def_split = 'split'


" fzf
if has('nvim')
  function! s:fzf_statusline()
    highlight fzf1 ctermfg=161 ctermbg=251
    highlight fzf2 ctermfg=23 ctermbg=251
    highlight fzf3 ctermfg=237 ctermbg=251
    setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
  endfunction

  augroup FZF
    autocmd! User FzfStatusLine call <SID>fzf_statusline()
  augroup END
endif

let g:fzf_preview_window = 'right:60%'
let g:fzf_buffers_jump = 1
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
let g:fzf_tags_command = 'ctags -R'
let g:fzf_layout = { 'down': '~75%' }
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

" command! -bang -nargs=? -complete=dir Files
"     \ call fzf#vim#files(<q-args>, {'options': ['--info=inline']}, <bang>0)

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

" " Mapping selecting mappings
" nmap <leader><tab> <plug>(fzf-maps-n)
" xmap <leader><tab> <plug>(fzf-maps-x)
" omap <leader><tab> <plug>(fzf-maps-o)
" nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
" nnoremap <silent> <Leader>C        :Colors<CR>
" nnoremap <silent> <Leader><Enter>  :Buffers<CR>
" nnoremap <silent> <Leader>ag       :Ag <C-R><C-W><CR>
" nnoremap <silent> <Leader>AG       :Ag <C-R><C-A><CR>
" xnoremap <silent> <Leader>ag       y:Ag <C-R>"<CR>
" nnoremap <silent> <Leader>`        :Marks<CR>
" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})
" " Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
noremap <C-p> :Files<cr>


" gitgutter
highlight clear SignColumn
let g:gitgutter_eager     = 0
let g:gitgutter_enabled   = 1
let g:gitgutter_max_signs = 10000
let g:gitgutter_realtime  = -1


" javascript-libraries-syntax
let g:used_javascript_libs = 'jquery,angularjs,jasmine,d3'


" nerdtree
nmap <leader>n :NERDTreeToggle<CR>
vmap <leader>n :NERDTreeToggle<CR>


" ruby
let g:ruby_fold = 1
let g:ruby_foldable_groups = ''
let g:ruby_space_errors = 1
let g:ruby_spellcheck_strings = 1
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_rails = 1
let g:rubycomplete_load_gemfile = 1


" rust
set hidden
let g:racer_experimental_completer = 1
let g:racer_insert_paren = 1


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
let g:tagbar_autopreview = 0
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


" ultisnips
let g:UltiSnipsExpandTrigger       = '<tab>'
" let g:UltiSnipsJumpForwardTrigger  = '<c-b>'
" let g:UltiSnipsJumpBackwardTrigger = '<c-z>'
" let g:UltiSnipsEditSplit           = 'vertical'


" undotree
nmap <leader>u :UndotreeToggle<CR>
vmap <leader>u :UndotreeToggle<CR>


" vroom
let g:vroom_map_keys = 1
let g:vroom_use_colors = 1
let g:vroom_use_spring = 0
let g:vroom_use_vimux = 0
if has('nvim')
  let g:vroom_use_terminal = 1
else
  let g:vroom_use_vimshell = 1
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup RememberLastPosition
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  autocmd BufReadPost COMMIT_EDITMSG,PULLREQ_EDITMSG call setpos('.', [0, 1, 1, 0])
augroup END

augroup GitCommits
  autocmd FileType gitcommit nested setlocal spell
augroup END

augroup Python
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent
  autocmd FileType python nnoremap <LocalLeader>= :0,$!yapf<CR>
augroup END

augroup ContentShellScript
  au! BufRead,BufNewFile,BufEnter */src/content/*.sh setlocal noexpandtab
augroup END

augroup Rust
  autocmd FileType rust setlocal tabstop=2 softtabstop=2 shiftwidth=2 textwidth=79 expandtab autoindent
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Just for TMUX
if v:version > 704
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
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

if has('nvim')
  tnoremap <C-w> <C-\><C-N><C-w>
endif

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
" noremap <leader><Tab>  :+tabmove<CR>
" noremap <leader><S-Tab> :-tabmove<CR>

" noremap <Tab> :bn<CR>
" noremap <S-Tab> :bp<CR>
" noremap <leader>[ :bp<CR>
" noremap <leader>] :bn<CR>
" noremap <leader>` :enew<CR>

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

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

function ShutUp()
  :ALEToggle
  set nonumber
  sign unplace *
endfunction

nmap <silent> <leader>z :call ShutUp()<CR>

syntax on
filetype plugin indent on

let g:base16colorspace = 256
let g:base16_shell_path =  SafeDirectory('~/.config/base16-shell/scripts')

if isdirectory(expand(g:vimhome . '/plugged/base16-vim'))
  if filereadable(expand('~/.vimrc_background'))
    execute 'source ' . expand('~/.vimrc_background')
  endif
  hi LineNr ctermfg=236 ctermbg=234
  hi Error ctermfg=11 ctermbg=none guifg='#ffff00' guibg='#000000'
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

