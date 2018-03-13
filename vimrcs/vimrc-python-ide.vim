"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
"                                                                                                "
"                                          .::::.                                                "
"                             ___________ :;;;;:`____________                                    "
"                             \_________/ ?????L \__________/                                    "
"                               |.....| ????????> :.......'                                      "
"                               |:::::| $$$$$$"`.:::::::' ,                                      "
"                              ,|:::::| $$$$"`.:::::::' .OOS.                                    "
"                            ,7D|;;;;;| $$"`.;;;;;;;' .OOO888S.                                  "
"                          .GDDD|;;;;;| ?`.;;;;;;;' .OO8DDDDDNNS.                                "
"                           'DDO|IIIII| .7IIIII7' .DDDDDDDDNNNF`                                 "
"                             'D|IIIIII7IIIII7' .DDDDDDDDNNNF`                                   "
"                               |EEEEEEEEEE7' .DDDDDDDNNNNF`                                     "
"                               |EEEEEEEEZ' .DDDDDDDDNNNF`                                       "
"                               |888888Z' .DDDDDDDDNNNF`                                         "
"                               |8888Z' ,DDDDDDDNNNNF`                                           "
"                               |88Z'    "DNNNNNNN"                                              "
"                               '"'        "MMMM"                                                "
"                                            ""                                                  "
"                                                                                                "
"      ___    ____                                            __   _         _    ________  ___  "
"     /   |  / / /  __  ______  __  __   ____  ___  ___  ____/ /  (_)____   | |  / /  _/  |/  /  "
"    / /| | / / /  / / / / __ \/ / / /  / __ \/ _ \/ _ \/ __  /  / / ___/   | | / // // /|_/ /   "
"   / ___ |/ / /  / /_/ / /_/ / /_/ /  / / / /  __/  __/ /_/ /  / (__  )    | |/ // // /  / /    "
"  /_/  |_/_/_/   \__, /\____/\__,_/  /_/ /_/\___/\___/\__,_/  /_/____/     |___/___/_/  /_/     "
"                   /_/                                                                          "
"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
" SOURCE: https://github.com/rakshazi/nvim/blob/master/init.vim
" let nvimRoot = '~/.config/nvim'
" let nvimPlugged = nvimRoot.'/plugged'
" let nvimBin = nvimRoot.'/bin'

set nocompatible              " required
let g:loaded_python_provider = 1    " disable python2 support
" let g:python_host_prog = '/home/dev/.pyenv/versions/neovim2/bin/python'
" let g:python3_host_prog = '/home/dev/.pyenv/versions/neovim3/bin/python'
let g:python3_host_prog = '/usr/bin/python3'
" let g:loaded_python3_provider = 1    " disable python3 support

" if has("python3")
"     set pyxversion=3
" endif
" https://github.com/neovim/neovim/wiki/Installing-Neovim

" SOURCE: https://github.com/vim/vim/blob/master/runtime/doc/if_pyth.txt
if has('pythonx')
	  echo 'pyx* commands are available. (Python ' . &pyx . ')'
    if has('python')
        set pyx=2
    elseif has('python3')
        set pyx=3
    endif
endif

filetype off                  " required
set hidden
set showtabline=0

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
"-------------------=== Code/Project navigation ===-------------
Plugin 'scrooloose/nerdtree'                                               " Project and file navigation
Plugin 'Xuyuanp/nerdtree-git-plugin'                                       " NerdTree git functionality
Plugin 'majutsushi/tagbar'                                                 " Class/module browser
Plugin 'vim-ctrlspace/vim-ctrlspace'                                       " Tabs/Buffers/Fuzzy/Workspaces/Bookmarks
Plugin 'mileszs/ack.vim'                                                   " Ag/Grep
Plugin 'vim-airline/vim-airline'                                           " Lean & mean status/tabline for vim
Plugin 'vim-airline/vim-airline-themes'                                    " Themes for airline
Plugin 'fisadev/FixedTaskList.vim'                                         " Pending tasks list
Plugin 'yuttie/comfortable-motion.vim'                                     " Smooth scrolling
Plugin 'MattesGroeger/vim-bookmarks'                                       " Bookmarks
Plugin 'thaerkh/vim-indentguides'                                          " Visual representation of indents
Plugin 'neomake/neomake'                                                   " Asynchronous Linting and Make Framework
Plugin 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }            " Asynchronous Completion
Plugin 'roxma/nvim-yarp'                                                   " Deoplete Dependency #1
Plugin 'roxma/vim-hug-neovim-rpc'                                          " Deoplete Dependency #2
" Plugin 'scrooloose/syntastic'                                              " Syntax checking hacks for vim
Plugin 'altercation/vim-colors-solarized'                                  " Solarized color scheme
Plugin 'christoomey/vim-tmux-navigator'                                    " Seamless navigation between tmux panes and vim splits
Plugin 'trevordmiller/nova-vim'                                            " Nova color scheme plugin for Vim
Plugin 'airblade/vim-gitgutter'                                              " Shows git changes in file (A Vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.)
Plugin 'pearofducks/ansible-vim'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'avakhov/vim-yaml'
Plugin 'StanAngeloff/php.vim'
Plugin 'ctrlpvim/ctrlp.vim'                                                     " Active fork of kien/ctrlp.vim—Fuzzy file, buffer, mru, tag, etc finder.
Plugin 'corntrace/bufexplorer'
Plugin 'chr4/nginx.vim'
Plugin 'amix/open_file_under_cursor.vim'                                    " Open file under cursor when pressing gf (if the text under the cursor is a path)
Plugin 'vim-scripts/tlib'                                                   " Some utility functions
Plugin 'tpope/vim-markdown'                                                 " Vim Markdown runtime files
Plugin 'vim-scripts/kwbdi.vim'                                              " Add a buffer close to vim that doesnt close the window
Plugin 'jtratner/vim-flavored-markdown'
" " Plugin outside ~/.vim/plugged with post-update hook
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" FIXME: Alternative
" SOURCE: https://github.com/junegunn/vim-plug#usage
" let g:fzf_install = 'yes | ./install'
" Plug 'junegunn/fzf', { 'do': g:fzf_install }

"-------------------=== Other ===-------------------------------
Plugin 'tpope/vim-surround'                 " Parentheses, brackets, quotes, XML tags, and more
Plugin 'flazz/vim-colorschemes'             " Dracula colortheme + airline theme, https://github.com/cohlin/vim-colorschemes
Plugin 'vimwiki/vimwiki'                    " Personal Wiki
Plugin 'jreybert/vimagit'                   " Git Operations
Plugin 'kien/rainbow_parentheses.vim'       " Rainbow Parentheses
Plugin 'chriskempson/base16-vim'            " Base 16 colors
Plugin 'ryanoasis/vim-devicons'             " Dev Icons

"-------------------=== Snippets support ===--------------------
Plugin 'garbas/vim-snipmate'                " Snippets manager
Plugin 'MarcWeber/vim-addon-mw-utils'       " dependencies #1
Plugin 'tomtom/tlib_vim'                    " dependencies #2
Plugin 'honza/vim-snippets'                 " snippets repo

"-------------------=== Languages support ===-------------------
Plugin 'scrooloose/nerdcommenter'           " Easy code documentation
Plugin 'mitsuhiko/vim-sparkup'              " Sparkup(XML/jinja/htlm-django/etc.) support
Plugin 'w0rp/ale'                           " Asynchronous Lint Engine

"-------------------=== Python  ===-----------------------------
Plugin 'klen/python-mode'                   " Python mode (docs, refactor, lints...)
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'mitsuhiko/vim-python-combined'
Plugin 'mitsuhiko/vim-jinja'
Plugin 'jmcantrell/vim-virtualenv'
Plugin 'zchee/deoplete-jedi'
Plugin 'nvie/vim-flake8'                                                    " Flake8

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype on
filetype plugin on
filetype plugin indent on

"=====================================================
"" General settings
"=====================================================
if filereadable(expand("~/.vimrc_background"))
  source ~/.vimrc_background
endif
set encoding=utf-8
let base16colorspace=256
set t_Co=256                                " 256 colors
" set guifont=mononoki\ Nerd\ Font\ 18
let g:airline_theme='base16_spacemacs'             " set airline theme
syntax enable                               " enable syntax highlighting

" SOURCE: https://github.com/benawad/dotfiles/blob/master/init.vim
" Theme
" "let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors
set background=dark
" SOURCE: https://github.com/chriskempson/base16-vim"
colorscheme base16-default-dark                              " set vim colorscheme

let mapleader = ','
set synmaxcol=400
let g:loaded_python_provider = 1
set shell=/bin/bash
set number                                  " show line numbers
set ruler
set ttyfast                                 " terminal acceleration

set tabstop=4                               " 4 whitespaces for tabs visual presentation
set shiftwidth=4                            " shift lines by 4 spaces
set smarttab                                " set tabs for a shifttabs logic
set expandtab                               " expand tabs into spaces
set autoindent                              " indent when moving to the next line while writing code

set cursorline                              " shows line under the cursor's line
set showmatch                               " shows matching part of bracket pairs (), [], {}

set enc=utf-8	                              " utf-8 by default

set nobackup 	                              " no backup files
set nowritebackup                           " only in case you don't want a backup file while editing
set noswapfile 	                            " no swap files

set backspace=indent,eol,start              " backspace removes all (indents, EOLs, start) What is start?

set scrolloff=20                            " let 10 lines before/after cursor during scroll

set clipboard=unnamed                       " use system clipboard
" SOURCE: https://neovim.io/doc/user/provider.html
" The presence of a working clipboard tool implicitly enables the '+' and '*'
" registers. Nvim looks for these clipboard tools, in order of priority:

"   - |g:clipboard|
"   - pbcopy/pbpaste (macOS)
"   - xsel (if $DISPLAY is set)
"   - xclip (if $DISPLAY is set)
"   - lemonade (for SSH) https://github.com/pocke/lemonade
"  - doitclient for SSH	http://www.chiark.greenend.org.uk/~sgtatham/doit/
"   - win32yank (Windows)
"   - tmux (if $TMUX is set)

set exrc                                    " enable usage of additional .vimrc files from working directory
set secure                                  " prohibit .vimrc files to execute shell, create files, etc...

"=====================================================
"" Manny remaps
"=====================================================
" SOURCE: https://github.com/mannytoledo/dotfiles/blob/master/vim/vimrc.symlink
noremap <leader>l :Align
" nnoremap <leader>a :Ack
" nnoremap <leader>b :CtrlPBuffer<CR>
" nnoremap <leader>d :NERDTreeToggle<CR>
" nnoremap <leader>f :NERDTreeFind<CR>
" nnoremap <leader>t :CtrlP<CR>
" nnoremap <leader>T :CtrlPClearCache<CR>:CtrlP<CR>
" nnoremap <leader>] :TagbarToggle<CR>
" nnoremap <leader><space> :call whitespace#strip_trailing()<CR>
" nnoremap <leader>g :GitGutterToggle<CR>
" nnoremap <leader>c <Plug>Kwbd
" nnoremap <silent> <leader>z :Goyo<cr>
" noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
set wildmenu
set wildmode=longest,list,full

" mouse=a will prevent you from copying using the mouse in iterm
" You can still copy if you hold option while selecting
set mouse=a
if exists('$TMUX') "Support resizing in TMUX
  set ttymouse=xterm2
endif
"=======================================================

"=====================================================
"" Tabs / Buffers settings
"=====================================================
tab sball
set switchbuf=useopen
set laststatus=2
nmap <F9> :bprev<CR>
nmap <F10> :bnext<CR>
nmap <silent> <leader>q :SyntasticCheck # <CR> :bp <BAR> bd #<CR>

"=====================================================
"" Neomake Settings
"=====================================================
call neomake#configure#automake('w')
let g:neomake_open_list = 2

"=====================================================
"" Deoplete  Settings
"=====================================================
" Use deoplete.
let g:deoplete#enable_at_startup = 1
" SOURCE: https://github.com/benawad/dotfiles/blob/master/init.vim
" use tab to forward cycle
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" use tab to backward cycle
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
" Close the documentation window when completion is done
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif


"=====================================================
"" Relative Numbering
"=====================================================
nnoremap <F4> :set relativenumber!<CR>

"=====================================================
"" Search settings
"=====================================================
set incsearch	                            " incremental search
set hlsearch	                            " highlight search results

"=====================================================
"" Comfortable Motion Settings
"=====================================================
let g:comfortable_motion_scroll_down_key = "j"
let g:comfortable_motion_scroll_up_key = "k"
let g:comfortable_motion_no_default_key_mappings = 1
let g:comfortable_motion_impulse_multiplier = 25  " Feel free to increase/decrease this value.
nnoremap <silent> <C-d> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 2)<CR>
nnoremap <silent> <C-u> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -2)<CR>
nnoremap <silent> <C-f> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 4)<CR>
nnoremap <silent> <C-b> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -4)<CR>

"=====================================================
"" AirLine settings
"=====================================================
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='unique_tail'
" let g:airline_powerline_fonts=1

"=====================================================
"" TagBar settings
"=====================================================
let g:tagbar_autofocus=0
let g:tagbar_width=42
autocmd BufEnter *.py :call tagbar#autoopen(0)
autocmd BufWinLeave *.py :TagbarClose

"=====================================================
"" NERDTree settings
"=====================================================
" SOURCE: https://github.com/benawad/dotfiles/blob/master/init.vim
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__', 'node_modules']   " Ignore files in NERDTree
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
" DISABLED: let NERDTreeIgnore=['\.pyc$', '\.pyo$', '__pycache__$']     " Ignore files in NERDTree
let NERDTreeWinSize=40
autocmd VimEnter * if !argc() | NERDTree | endif  " Load NERDTree only if vim is run without arguments
nmap " :NERDTreeToggle<CR>

"=====================================================
"" NERDComment Settings
"=====================================================
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1


"=====================================================
"" DevIcon Settings
"=====================================================
" loading the plugin
let g:webdevicons_enable = 1

" adding the flags to NERDTree
let g:webdevicons_enable_nerdtree = 1

" adding to vim-airline's tabline
let g:webdevicons_enable_airline_tabline = 1

" adding to vim-airline's statusline
let g:webdevicons_enable_airline_statusline = 1

" turn on/off file node glyph decorations (not particularly useful)
let g:WebDevIconsUnicodeDecorateFileNodes = 1

" use double-width(1) or single-width(0) glyphs
" only manipulates padding, has no effect on terminal or set(guifont) font
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1

" whether or not to show the nerdtree brackets around flags
let g:webdevicons_conceal_nerdtree_brackets = 0

" the amount of space to use after the glyph character (default ' ')
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '

" Force extra padding in NERDTree so that the filetype icons line up vertically
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1

" change the default character when no match found
let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol = 'ƛ'

" set a byte character marker (BOM) utf-8 symbol when retrieving file encoding
" disabled by default with no value
let g:WebDevIconsUnicodeByteOrderMarkerDefaultSymbol = ''

" enable folder/directory glyph flag (disabled by default with 0)
let g:WebDevIconsUnicodeDecorateFolderNodes = 1

" enable open and close folder/directory glyph flags (disabled by default with 0)
let g:DevIconsEnableFoldersOpenClose = 1

" enable pattern matching glyphs on folder/directory (enabled by default with 1)
let g:DevIconsEnableFolderPatternMatching = 1

" enable file extension pattern matching glyphs on folder/directory (disabled by default with 0)
let g:DevIconsEnableFolderExtensionPatternMatching = 0


"=====================================================
"" SnipMate settings
"=====================================================
let g:snippets_dir='~/.vim/vim-snippets/snippets'

"=====================================================
"" Rainbow Parentheses Autoload
"=====================================================
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

"=====================================================
"" Indent Guides Settings
"=====================================================
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.

"=====================================================
"" Ack.vim settings
"=====================================================
" if executable('ag')
"   let g:ackprg = 'ag --vimgrep'
" endif
" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  let g:ackprg = 'ag --nogroup --column'

  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

"=====================================================
"" vim-flavored-markdown config
"=====================================================
augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

"=====================================================
"" Python settings
"=====================================================

" python executables for different plugins
let g:pymode_python='python3'

" rope
let g:pymode_rope=0
let g:pymode_rope_completion=0
let g:pymode_rope_complete_on_dot=0
let g:pymode_rope_auto_project=0
let g:pymode_rope_enable_autoimport=0
let g:pymode_rope_autoimport_generate=0
let g:pymode_rope_guess_project=0

" documentation
let g:pymode_doc=0
let g:pymode_doc_bind='K'

" lints
let g:pymode_lint=0

" virtualenv
let g:pymode_virtualenv=1

" breakpoints
let g:pymode_breakpoint=1
let g:pymode_breakpoint_key='<leader>b'

" syntax highlight
let g:pymode_syntax=1
let g:pymode_syntax_slow_sync=1
let g:pymode_syntax_all=1
let g:pymode_syntax_print_as_function=g:pymode_syntax_all
let g:pymode_syntax_highlight_async_await=g:pymode_syntax_all
let g:pymode_syntax_highlight_equal_operator=g:pymode_syntax_all
let g:pymode_syntax_highlight_stars_operator=g:pymode_syntax_all
let g:pymode_syntax_highlight_self=g:pymode_syntax_all
let g:pymode_syntax_indent_errors=g:pymode_syntax_all
let g:pymode_syntax_string_formatting=g:pymode_syntax_all
let g:pymode_syntax_space_errors=g:pymode_syntax_all
let g:pymode_syntax_string_format=g:pymode_syntax_all
let g:pymode_syntax_string_templates=g:pymode_syntax_all
let g:pymode_syntax_doctests=g:pymode_syntax_all
let g:pymode_syntax_builtin_objs=g:pymode_syntax_all
let g:pymode_syntax_builtin_types=g:pymode_syntax_all
let g:pymode_syntax_highlight_exceptions=g:pymode_syntax_all
let g:pymode_syntax_docstrings=g:pymode_syntax_all

" highlight 'long' lines (>= 200 symbols) in python files
augroup vimrc_autocmds
    autocmd!
    autocmd FileType python,rst,c,cpp highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python,rst,c,cpp match Excess /\%81v.*/
    autocmd FileType python,rst,c,cpp set nowrap
    autocmd FileType python,rst,c,cpp set colorcolumn=200
augroup END

" code folding
let g:pymode_folding=0

" pep8 indents
let g:pymode_indent=1

" code running
let g:pymode_run=1
let g:pymode_run_bind='<F5>'

let g:ale_sign_column_always = 0
let g:ale_emit_conflict_warnings = 0
let g:airline#extensions#ale#enabled = 1
let g:pymode_rope_lookup_project = 0
let g:airline#extensions#tabline#enabled = 1

imap <F5> <Esc>:w<CR>:!clear;python %<CR>

" Debug logging if needed
" let $NVIM_PYTHON_LOG_FILE='/tmp/nvim_log'
" let $NVIM_PYTHON_LOG_LEVEL="DEBUG"

python3 << EOF
import vim
import git
def is_git_repo():
	try:
		_ = git.Repo('.', search_parent_directories=True).git_dir
		return "1"
	except:
		return "0"
vim.command("let g:pymode_rope = " + is_git_repo())
EOF
