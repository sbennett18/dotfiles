" Formatting {
    " set cc=80,120         " Place vertical bar at 80 characters
    set cc=120            " Place vertical bar at 80 characters
    set nowrap            " Don't wrap long lines
    set autoindent        " Indent at the same level of the previous line
    set shiftwidth=4      " Use indents of two spaces
    set tabstop=4         " An indentation every two columns
    set softtabstop=4     " Let backspace delete indent
    set backspace=2
    set expandtab         " Tabs are spaces, not tabs
    set pastetoggle=<F12> " pastetoggle (sane indentation on pastes)
    autocmd FileType c,cpp,java,go,php,javascript,python,twig,xml,yml,json autocmd BufWritePre <buffer> call StripTrailingWhitespace()
" }

" General {
    set encoding=utf-8
    syntax on
    set modeline           " Enable per-file modeline configurations
    " colorscheme default    " https://github.com/nathanaelkane/vim-indent-guides/issues/31#issuecomment-4583981

    " Make tags placed in .git/tags file available in all levels of a repsitory
    " let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
    " if gitroot != ''
    "   let &tags = &tags . ',' . gitroot . '/.git/tags'
    " endif
    set tags=./tags,tags,$HOME/tags,/usr/include/tags;

    if has("autocmd")
        " Enable file type detection.
        " Also load indent files, to automatically do language-dependent indenting.
        filetype plugin indent on
    endif

    set ruler
    set mouse=nvi
    set history=50
    set virtualedit=onemore
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
    " autocmd InsertEnter * set cursorline
    " autocmd InsertLeave * set nocursorline
    set nu                  " Absolute line numbers
    " set nu rnu              " Relative line numbers; absolute for current line
    " augroup numbertoggle
    "     autocmd!
    "     autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set relativenumber   | endif
    "     autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set norelativenumber | endif
    " augroup END
    " augroup resCur
    "     autocmd!
    "     autocmd BufReadPost * call setpos(".", getpos("'\""))
    " augroup END

    set nojoinspaces        " Prevents inserting two spaces after punctuation on a join
    set splitright          " Puts new vsplit windows to the right of the current
    set splitbelow          " Puts new split windows to the bottom of the current

    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:.  " Highlight problematic whitespace

    " Setting up the directories {
        set backup                    " Backups are nice ...
        if has('persistent_undo')
            set undofile          " So is persistent undo ...
            set undolevels=1000   " Maximum number of changes that can be undone
            set undoreload=10000  " Maximum number lines to save for undo on a buffer reload
        endif

        " au BufWinLeave *  if ShouldSaveFile() | mkview | endif
        " au VimEnter * if ShouldSaveFile() | loadview | endif
        " function ShouldSaveFile()
        "     if empty(expand('%'))
        "         return 0
        "     elseif &filetype == "gitcommit"
        "         return 0
        "     endif
        "     return 1
        " endfunction
    " }
" }

" Key (re)Mappings {
    " Any time <leader> appears in a keybinding it means use the key assigned
    " here (i.e. ,)
    let mapleader = ','

    " Allow saving of files as sudo when I forgot to start vim using sudo
    cnoremap w!! w !sudo tee > /dev/null %

    " Stupid shift fixes
    " nmap ; :

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

    " Move lines up or down
    nnoremap <leader>j :m .+1<CR>==
    nnoremap <leader>k :m .-2<CR>==
    inoremap <leader>j <Esc>:m .+1<CR>==gi
    inoremap <leader>k <Esc>:m .-2<CR>==gi
    vnoremap <leader>j :m '>+1<CR>gv=gv
    vnoremap <leader>k :m '<-2<CR>gv=gv

    " Un-highlight search results
    nmap <silent> <leader>/ :nohl<CR>

    nmap <leader><Tab> gt
    nmap <leader><S-Tab> gT
    nmap <leader><leader><Tab> gT

    if (v:version >= 700)
        " Toggle spell-checking
        nmap <silent> <leader>s :silent set spell!<CR>
    endif

    " Find merge conflict markers
    nmap <leader>fc /\v^[<\|=>]{7}( .*\|$)<cr>
    nmap <leader>fd :SignifyFold<cr>

    " Quickly jump to a tag if there's only one match, otherwise show the list
    map <F3> :tj<space>

    " Display a list of included files and quickly jump to one
    map <F4> [I:let nr = input("Which one: ")<bar>exe "normal " . nr ."[\t"<cr>"]"]

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    " nmap <leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Code folding options
    set foldmethod=syntax
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
    nnoremap za zA
    nnoremap zA za
    nnoremap zc zC
    nnoremap zC zc
    nnoremap zo zO
    nnoremap zO zo

    " <C-R>= command inserts the value returned by the invoked function at the
    "   current location in the command-line
    " <C-\>e command replaces the entire command-line with the value returned
    "   by the invoked function
    nnoremap <leader>oh :vsp<CR>:tag <C-R>=expand('%:t:r') . ".h"<CR><CR>
    function! ToggleHeaderCodeFile()
        let current_ext = expand('%:e')
        if current_ext == "c"
            let toggle_ext = ".h"
        else
            let toggle_ext = ".c"
        endif
        let toggle_file = expand('%:t:r') . toggle_ext
        return toggle_file
    endfunction
    nnoremap <C-k><C-o> :vsp<CR>:tag <C-R>=ToggleHeaderCodeFile()<CR><CR>
" }

" Always switch to the current file directory
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

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

" Cygwin Block Cursor {
    let &t_ti.="\e[1 q"
    let &t_SI.="\e[5 q"
    let &t_EI.="\e[1 q"
    let &t_te.="\e[0 q"
" }

" plug.vim {
    call plug#begin('$HOME/.vim/plugged')

    " Plug 'tpope/vim-sensible'
    Plug 'scrooloose/nerdcommenter'  " , { 'on': ['NERDComToggleComment', 'NERDComInvertComment'] }
    Plug 'scrooloose/syntastic'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'tpope/vim-surround'
    " Plug 'spf13/vim-autoclose'
    Plug 'nvie/vim-flake8'
    Plug 'jnurmine/Zenburn'
    Plug 'altercation/vim-colors-solarized'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'mhinz/vim-signify'
    " Plug 'edkolev/tmuxline.vim'
    Plug 'godlygeek/tabular'
    Plug 'https://github.com/vim-scripts/taglist.vim'
    Plug 'https://github.com/vim-scripts/restore_view.vim.git'
    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    call plug#end()
" }

" restore_view {
    set viewoptions=cursor,folds,slash,unix
    let g:skipview_files = []
" }

" NERDCommenter {
    " Add spaces after comment delimiters by default
    let g:NERDSpaceDelims = 1

    " Align line-wise comment delimiters flush left instead of following code indentation
    let g:NERDDefaultAlign = 'left'

    " Set a language to use its alternate delimiters by default
    let g:NERDAltDelims_c = 1

    " Add your own custom formats or override the defaults
    " let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

    " Allow commenting and inverting empty lines (useful when commenting a region)
    let g:NERDCommentEmptyLines = 1

    " Enable trimming of trailing whitespace when uncommenting
    let g:NERDTrimTrailingWhitespace = 1
" }

" vim-indent-guides {
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_start_level = 2
    let g:indent_guides_guide_size = 1
" }

" vim-flake8 {
    let g:flake8_show_in_file = 1
    let g:flake8_show_in_gutter = 1
    highlight link Flake8_Error       Error
    highlight link FLAKE8_Warning     WarningMsg
    highlight link FLAKE8_Complexity  WarningMsg
    highlight link FLAKE8_Naming      WarningMsg
    highlight link FLAKE8_PyFlake     WarningMsg
" }

" NERDTree {
    nnoremap <leader>nt :NERDTreeToggle<CR>
" }

" Zenburn {
    " colorscheme zenburn
" }

" Solarized {
    let g:solarized_termcolors=256
    set background=dark
    colorscheme solarized
" }

" Airline {
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#whitespace#enabled = 1
    let g:airline_theme='molokai'
" }

" Taglist {
    nnoremap <silent> <leader>tt :TlistToggle<CR>
" }

" Initialize directories {
function! InitializeDirectories()
    let parent = $HOME
    let prefix = '.vim'
    let common_dir = parent . '/' . prefix . '/'

    let dir_list = {
            \ 'backup': 'backupdir',
            \ 'view': 'viewdir',
            \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname
        if exists("*mkdir")
            if !isdirectory(directory)
                echo "mkdir " . directory
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            let cmd = "set " . settingname . "=" . directory . '//'
            exec cmd
        endif
    endfor
endfunction
call InitializeDirectories()
" }

" vim: set sw=4 ts=4 sts=4 expandtab:
