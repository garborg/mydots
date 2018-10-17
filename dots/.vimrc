" n.b. 'alt: ' denotes viable alternatives
" (at the time the chosen plugin was added or re-evaluated)

" Plugin manager: plug.vim " alt: dein.vim

" TO INSTALL PLUGIN MANAGER:
"
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" make sure .vimrc is in place
" then reload .vimrc and call ``:PlugInstall`

" BEFORE LOADING PLUGINS:

let mapleader = " "
let maplocalleader = " "

" LOAD PLUGINS:

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'NLKNguyen/papercolor-theme'

" navigation outside of active file
Plug '~/.fzf' " I have fzf installed with my dotfiles
Plug 'junegunn/fzf.vim' " alt: 'Shougo/denite.nvim' 'lotabout/skim.vim'

" language server protocol
" (support for renames, go to definition, etc.)
" language server: https://pinboard.in/u:garborg/tabs/283303/
if has("job")
  Plug 'autozimu/LanguageClient-neovim', {
  \ 'branch': 'next',
  \ 'do': 'bash install.sh',
  \ }
endif

" automatic tag generation/update
" (useful for languages/environments missing language servers)
if has("job")
  Plug 'ludovicchabant/vim-gutentags' " alt: 'craigemery/vim-autotag' 'LucHermitte/lh-tags' 'xolox/vim-easytags'
endif

" completion
" https://pinboard.in/u:garborg/tabs/283297/
" YouCompleteMe, deoplete.nvim, nvim-completion-manager, completor.vim
" Plug 'roxma/nvim-completion-manager'
" nvim-completion-manager, deoplete require python3
" YouCompleteMe, completor require python2 or python3

" More terminal:
" https://medium.com/@SpaceVim/tips-about-the-terminal-of-vim-and-neovim-6a2dfa67ce5e
" if has("nvim")
"   Plug 'BurningEther/iron.nvim', {'do': ':UpdateRemotePlugins'}
" endif

" linter
if v:version < 800
  Plug 'scrooloose/syntastic'
else
  " ale is async and has capabilities beyond linting
  Plug 'w0rp/ale' " alt: https://github.com/neomake/neomake
endif

" code formatter
" https://prettier.io/docs/en/vim.html
Plug 'sbdchd/neoformat' "alt: worp/ale, LanguageClient-neovim, Chiel92/vim-autoformat, vim-codefmt

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" tmux nav
" C-{h,j,k,l} for split nav & tmux pane nav
" Plug 'christoomey/vim-tmux-navigator'

" Standardized indentation, etc., by filetype/name
Plug 'editorconfig/editorconfig-vim' " requires +python

" Movement, etc.
Plug 'haya14busa/incsearch.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'chrisbra/Recover.vim'

" Language-specific:
Plug 'JuliaEditorSupport/julia-vim'
Plug 'fatih/vim-go'
" Plug 'pangloss/vim-javascript'

call plug#end()

" OTHER PLUGINS FOR CONSIDERATION:

" https://github.com/machakann/vim-highlightedyank
" OR
" https://github.com/haya14busa/vim-operator-flashy

" https://github.com/easymotion/vim-easymotion
" https://github.com/tpope/vim-dispatch
" https://github.com/zenbro/mirror.vim
" https://github.com/tpope/vim-db

" CONFIGURATION NOTES TO REVISIT:

" https://github.com/languitar/config-vim/blob/master/home/.config/nvim/init.vim
" http://liuchengxu.org/posts/use-vim-as-a-python-ide/
" http://ellengummesson.com/blog/2015/08/01/dropping-ctrlp-and-other-vim-plugins/
" http://vim.spf13.com/
" https://github.com/liuchengxu/vim-better-default
" https://github.com/JAremko/alpine-vim

" CONFIGURE EDITOR:

" support unicode in more environments
set encoding=utf-8

" manipulate splits without closing random graphical windows
noremap <leader>w <C-w>

" easy movement between splits
" TODO: get rid of <leader>h delay or change mappings
noremap <leader>h <C-w>h
noremap <leader>j <C-w>j
noremap <leader>k <C-w>k
noremap <leader>l <C-w>l

noremap <leader>g :Rg<space>
noremap <leader>b :Buffers<CR>
noremap <leader>f :Files<CR>
noremap <leader>n :Neoformat<CR>

" netrw
let g:netrw_dirhistmax=0 " don't need the clutter in .vim
" https://shapeshed.com/vim-netrw/#netrw-the-unloved-directory-browser
" http://ellengummesson.com/blog/2014/02/22/make-vim-really-behave-like-netrw/
" Make netrw 'nerdtree-like'
" let g:netrw_liststyle = 3
let g:netrw_banner = 0
" let g:netrw_browse_split = 4
" let g:netrw_altv = 1
" let g:netrw_winsize = 25
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END

set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" Nice colorscheme
set t_Co=256   " in case not recognized
set background=dark
colorscheme PaperColor
" make current search result differentiable from rest
" (when using incsearch + hlsearch)
hi Cursor ctermfg=15 ctermbg=9 guifg=White guibg=Red

"hook up copy/paste to system clipboard
" TODO: avoid clipboard clear when vim is stopped
set clipboard^=unnamed,unnamedplus

" call out whitespace
set list
set showbreak=↪\
" sensible sets alright listchars if you need ascii
set listchars=tab:→\ ,nbsp:␣,trail:·,extends:⟩,precedes:⟨
" turn off tab highlighting where tab is expected
autocmd FileType go setlocal listchars=tab:\ \ ,nbsp:␣,trail:·,extends:⟩,precedes:⟨
"but make it easy to toggle off/on
"nnoremap <leader>l :set list!<cr>:set list?<cr>

" display tabs 4 wide
set tabstop=4

" toggle paste mode (including w/in insert mode)
set pastetoggle=<F10>

" CONFIGURE PLUGINS:

" ensure that editorconfig works well with fugituve
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

if has("job")
  " LanguageClient
  let g:LanguageClient_autoStart = 1
  let g:LanguageClient_serverCommands = {
  \   'python': ['pyls'],
  \   'go': ['go-langserver'],
  \   'javascript': ['javascript-typescript-stdio'],
  \   'javascript.jsx': ['javascript-typescript-stdio'],
  \ }
  " skip julia until LanguageServer.jl supports 0.7
  " \   'julia': ['julia', '--startup-file=no', '--history-file=no', '-e', '
  " \       using LanguageServer;
  " \       server = LanguageServer.LanguageServerInstance(STDIN, STDOUT, false);
  " \       server.runlinter = true;
  " \       run(server);
  " \   '],

  nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
  nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
  nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
endif

if v:version < 800
  " syntastic
  " syntastic recommended beginner settings
  "set statusline+=%#warningmsg#
  "set statusline+=%{SyntasticStatuslineFlag()}
  "set statusline+=%*
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  "let g:syntastic_check_on_open = 1
  "let g:syntastic_check_on_wq = 0
endif

" integrate rg and ag search.
" rg for general use, speed, unicode, etc.
" ag for multiline, backrefs, lookaround.

" Augmenting Ag command using fzf#vim#with_preview function
"   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
"     * For syntax-highlighting, Ruby and any of the following tools are required:
"       - Highlight: http://www.andre-simon.de/doku/highlight/en/highlight.php
"       - CodeRay: http://coderay.rubychan.de/
"       - Rouge: https://github.com/jneen/rouge
"
"   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" To include ignored and hidden files:
command! -bang -nargs=* Rgu
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always -uu '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" incsearch.vim basic settings
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" incsearch smart auto hl-toggle
" :h g:incsearch#auto_nohlsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" many more incsearch.vim options
"https://github.com/haya14busa/incsearch.vim


" used by gitgutter
set updatetime=400

" Language-specific again:

let g:neoformat_run_all_formatters = 1
"let g:neoformat_enabled_javascript = ['prettier'] "prettier-eslint?
let g:neoformat_enabled_python = ['black', 'isort']

" let g:julia_blocks=0 " maybe turn of julia-vim's matchit mappings
let g:default_julia_version = "0.6"

" Use goimports on save (.go files)
let g:go_fmt_command = "goimports"

" Syntax highlighting
" let g:go_highlight_operators = 1

" Sometimes when using both vim-go and syntastic Vim will start lagging while saving and opening files. The following fixes this:
" let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
" let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

" Another issue with vim-go and syntastic is that the location list window that contains the output of commands such as :GoBuild and :GoTest might not appear. To resolve this:
" let g:go_list_type = "quickfix"

set wildignore+=*/node_modules/*,*/vendor/*
