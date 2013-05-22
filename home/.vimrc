" Environment {
  " Basics {
    set nocompatible    " Be iMproved - must be first line
    set background=dark
  " }

  " Setup Bundle Support {
    filetype off
    set rtp+=~/.vim/bundle/vundle
    call vundle#rc()
  " }
" }

" Bundles {
  " Deps {
    Bundle 'gmarik/vundle'
  " }

  " General {
    Bundle 'nathanaelkane/vim-indent-guides'
    Bundle 'scrooloose/nerdcommenter'
    Bundle 'tpope/vim-surround'
    Bundle 'tpope/vim-repeat'
    Bundle 'matchit.zip'
    Bundle 'scrooloose/nerdtree'
    Bundle 'jistr/vim-nerdtree-tabs'
    Bundle 'altercation/vim-colors-solarized'
    Bundle 'spf13/vim-autoclose'
    Bundle 'bling/vim-airline'
    Bundle 'vim-scripts/restore_view.vim'
    Bundle 'mbbill/undotree'
  " }

  " General Programming {
    Bundle 'tpope/vim-fugitive'
    Bundle 'airblade/vim-gitgutter'
    Bundle 'ervandew/supertab'
    "Bundle 'xolox/vim-easytags'
    Bundle 'xolox/vim-misc'
    Bundle 'terryma/vim-multiple-cursors'
  " }

  " Python {
    " Pick either python-mode or pyflakes & pydoc
    "Bundle 'klen/python-mode'
    Bundle 'python.vim'
    Bundle 'python_match.vim'
    Bundle 'pythoncomplete'
    Bundle 'nvie/vim-flake8'
  " }

  " Javascript {
    Bundle 'elzr/vim-json'
  " }
" }

" Formatting {
  set cc=80             " Place vertical bar at 80 characters
  set nowrap            " Don't wrap long lines
  set autoindent        " Indent at the same level of the previous line
  set shiftwidth=2      " Use indents of two spaces
  set tabstop=2         " An indentation every two columns
  set softtabstop=2     " Let backspace delete indent
  set expandtab         " Tabs are spaces, not tabs
  set pastetoggle=<F12> " pastetoggle (sane indentation on pastes)
  autocmd FileType c,cpp,java,go,php,javascript,python,twig,xml,yml,json autocmd BufWritePre <buffer> call StripTrailingWhitespace()
" }

" General {
  set encoding=utf-8
  syntax on
  set modeline           " Enable per-file modeline configurations

  " Make tags placed in .git/tags file available in all levels of a repsitory
  let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
  if gitroot != ''
    let &tags = &tags . ',' . gitroot . '/.git/tags'
  endif

  if has("autocmd")
    " Enable file type detection.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on
  endif

  set ruler
  set mouse=nvi
  set history=50
  set virtualedit=onemore
  set number              " Line numbers on
  set showmatch           " Show matching brackets/parenthesis
  set suffixes+=.pyc,.pyo " Don't autocomplete these filetypes
  set wildmenu            " Better ':' command auto-completion
  set wildmode=list:longest,full
  set scrolljump=5        " Lines to scroll when cursor leaves screen
  set scrolloff=3         " Minimum lines to keep above and below the cursor
  set sidescroll=2        " Only scroll horizontally little by little"
  set hlsearch            " Highlight search terms
  set incsearch           " Highlight search terms as you type
  set ignorecase          " Case insensitive search
  set smartcase           " Case sensitive search when uppercase present
  set cursorline          " Highlight the current line

  set nojoinspaces        " Prevents inserting two spaces after punctuation on a join"
  set splitright          " Puts new vsplit windows to the right of the current
  set splitbelow          " Puts new split windows to the bottom of the current

  set list
  set listchars=tab:›\ ,trail:•,extends:#,nbsp:.  " Highlight problematic whitespace

  " Setting up the directories {
    set backup                " Backups are nice ...
    if has('persistent_undo')
        set undofile          " So is persistent undo ...
        set undolevels=1000   " Maximum number of changes that can be undone
        set undoreload=10000  " Maximum number lines to save for undo on a buffer reload
    endif
  " }
" }

" Key (re)Mappings {
  " Any time <leader> appears in a keybinding it means use the key assigned
  " here (i.e. ,)
  let mapleader = ','

  " Stupid shift fixes
  nmap ; :

  " Wrapped lines goes down/up to next row, rather than next line in file.
  noremap j gj
  noremap k gk

  " Easier horizontal scrolling
  map zl zL
  map zh zH

  " Visual shifting (does not exit Visual mode)
  vnoremap < <gv
  vnoremap > >gv

  " Allow using the repeat operator with a visual selection (!)
  " http://stackoverflow.com/a/8064607/127816
  vnoremap . :normal .<cr>

  " Yank from the cursor to the end of the line, to be consistent with C and D.
  nnoremap Y y$

  " Un-highlight search results
  nmap <silent> <leader>/ :nohl<CR>

  if (v:version >= 700)
    " Toggle spell-checking
    nmap <silent> <leader>s :silent set spell!<CR>
  endif

  " Find merge conflict markers
  map <leader>fc /\v^[<\|=>]{7}( .*\|$)<cr>

  " Quickly jump to a tag if there's only one match, otherwise show the list
  map <F3> :tj<space>

  " Display a list of included files and quickly jump to one
  map <F4> [I:let nr = input("Which one: ")<bar>exe "normal " . nr ."[\t"<cr>"]"]

  " Code folding options
  nmap <leader>f0 :set foldlevel=0<CR>
  nmap <leader>f1 :set foldlevel=1<CR>
  nmap <leader>f2 :set foldlevel=2<CR>
  nmap <leader>f3 :set foldlevel=3<CR>
  nmap <leader>f4 :set foldlevel=4<CR>
  nmap <leader>f5 :set foldlevel=5<CR>
  nmap <leader>f6 :set foldlevel=6<CR>
  nmap <leader>f7 :set foldlevel=7<CR>
  nmap <leader>f8 :set foldlevel=8<CR>
  nmap <leader>f9 :set foldlevel=9<CR>

  " Map <Leader>ff to display all lines with keyword under cursor
  " and ask which one to jump to
  nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
" }

" Always switch to the current file directory
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" Vim UI {
  "colorscheme evening
  " Use the solarized colorscheme @ https://github.com/altercation/solarized
  colorscheme solarized
  let g:solarized_termcolors=256

  if &term == 'xterm' || &term == 'screen'
    set t_Co=256
  endif

  if has('statusline')
    set laststatus=2

    " Broken down into easily includeable segments
    set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    set statusline+=%{fugitive#statusline()} " Git Hotness
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
  endif

  highlight clear SignColumn      " SignColumn should match background for
                                  " things like vim-gitgutter
" }

" Plugins {
  " vim-json {
    " Disable concealing of "
    let g:vim_json_syntax_conceal=0
  " }

  " Fugitive {
    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
    nnoremap <silent> <leader>gc :Gcommit<CR>
    nnoremap <silent> <leader>gb :Gblame<CR>
    nnoremap <silent> <leader>gl :Glog<CR>
    nnoremap <silent> <leader>gp :Git push<CR>
    nnoremap <silent> <leader>gw :Gwrite<CR>:GitGutter<CR>
    nnoremap <silent> <leader>gg :GitGutterToggle<CR>
  "}

  " PyMode {
    if !has('python')
      let g:pymode = 1
    endif
    let g:pymode_lint_checker = "pyflakes"
    let g:pymode_utils_whitespaces = 0
    let g:pymode_options = 0
  " }

  " Enable omni completion {
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  " }

  " airline {
    set noshowmode                    " Disable default mode indicator
    let g:airline_left_sep='›'
    let g:airline_right_sep='‹'
    "let g:airline_powerline_fonts=1   " Enable powerline font symbols
  " }

  " indent_guides {
    " For some colorschemes, autocolor will not work (eg: 'desert', 'ir_black')
    let g:indent_guides_auto_colors = 1
    let g:indent_guides_start_level = 2
    let g:indent_guides_guide_size = 1
    let g:indent_guides_enable_on_vim_startup = 1
  " }

  " OmniComplete {
    if has("autocmd") && exists("+omnifunc")
      autocmd Filetype *
        \if &omnifunc == "" |
        \setlocal omnifunc=syntaxcomplete#Complete |
        \endif
    endif

    hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
    hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
    hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

    " Some convenient mappings
    inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
    inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
    inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
    inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
    inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

    " Automatically open and close the popup menu / preview window
    au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
    set completeopt=menu,preview,longest
  " }

  " NerdTree {
    map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
    map <leader>e :NERDTreeFind<CR>
    nmap <leader>nt :NERDTreeFind<CR>

    let NERDTreeShowBookmarks=1
    let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
    let NERDTreeChDirMode=0
    let NERDTreeQuitOnOpen=1
    let NERDTreeMouseMode=2
    let NERDTreeShowHidden=1
    let NERDTreeKeepTreeInNewTab=1
    let g:nerdtree_tabs_open_on_gui_startup=0
  " }

  " Undotree {
    nnoremap <F5> :UndotreeToggle<CR>
    nnoremap <leader>u :UndotreeToggle<CR>
  " }
" }

" Strip whitespace {
  function! StripTrailingWhitespace()
    " Preparation: save last search and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business
    %s/\s\+$//e
    " Clean up: restore previous search history and cursor position
    let @/=_s
    call cursor(l, c)
  endfunction
" }

" Initialize NERDTree as needed {
  function! NERDTreeInitAsNeeded()
    redir => bufoutput
    buffers!
    redir END
    let idx = stridx(bufoutput, "NERD_tree")
    if idx > -1
      NERDTreeMirror
      NERDTreeFind
      wincmd l
    endif
  endfunction
" }

" Initialize directories {
  function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
          \ 'backup': 'backupdir',
          \ 'views': 'viewdir',
          \ 'swap': 'directory' }

    if has('persistent_undo')
      let dir_list['undo'] = 'undodir'
    endif

    let common_dir = $HOME . '/.vim/.vim'

    for [dirname, settingname] in items(dir_list)
      let directory = common_dir . dirname . '/'
      if exists("*mkdir")
        if !isdirectory(directory)
          call mkdir(directory)
        endif
      endif
      if !isdirectory(directory)
        echo "Warning: Unable to create backup directory: " . directory
        echo "Try: mkdir -p " . directory
      else
        let directory = substitute(directory, " ", "\\\\ ", "g")
        exec "set " . settingname . "=" . directory
      endif
    endfor
  endfunction
" }

" Shell command {
  function! s:RunShellCommand(cmdline)
    botright new

    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal noswapfile
    setlocal nowrap
    setlocal filetype=shell
    setlocal syntax=shell

    call setline(1, a:cmdline)
    call setline(2, substitute(a:cmdline, '.', '=', 'g'))
    execute 'silent $read !' . escape(a:cmdline, '%#')
    setlocal nomodifiable
    1
  endfunction
" }

" Grep current file:
"   :Shell grep -Hn <search_term> %

" Finish local initializations {
  call InitializeDirectories()
" }

" Commands {
  " Shell
  command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
" }

" vim:set sw=2 ts=2 sts=2 expandtab:
