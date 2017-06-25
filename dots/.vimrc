" TO INSTALL PLUG:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" make sure .vimrc is in place
" then reload .vimrc and call ``:PlugInstall`

" really need to remap ~ someday

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
" http://vim.spf13.com/
" many options for file/directory/buffer/etc nav:
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim' " alt: 'scrooloose/nerdtree', 'wincent/command-t', 'ctrlpvim/ctrlp.vim', 'Shougo/denite.nvim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/syntastic' " alt: 'w0rp/ale', https://github.com/neomake/neomake
" YouCompleteMe, deoplete.nvim, neocomplete.nvim, completor.vim, validator.vim
Plug 'sbdchd/neoformat' "alt: Chiel92/vim-autoformat, vim-codefmt
Plug 'tpope/vim-surround'
Plug 'editorconfig/editorconfig-vim'

" vim8: http://www.vim.org/download.php
" http://ellengummesson.com/blog/2015/08/01/dropping-ctrlp-and-other-vim-plugins/
" https://github.com/tpope/vim-dispatch
" http://vimawesome.com/

"Language-specific:
Plug 'JuliaEditorSupport/julia-vim'
Plug 'fatih/vim-go'
call plug#end()

" ensure that editorconfig works well with fugituve
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" syntastic recommended beginner settings
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

" 'you may not need nerdtree':
"  https://shapeshed.com/vim-netrw/#netrw-the-unloved-directory-browser
" and what are wildignores?:
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

" add ripgrep search for fzf.vim
" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" carry ubuntu default everywhere
colorscheme ron

"hook up copy/paste to system clipboard
set clipboard^=unnamed,unnamedplus

" call out whitespace
set list
set showbreak=↪\
" sensible sets alright listchars if you need ascii
set listchars=tab:→\ ,nbsp:␣,trail:·,extends:⟩,precedes:⟨
" turn off tab highlighting where tab is expected
autocmd FileType go setlocal listchars=tab:\ \ ,nbsp:␣,trail:·,extends:⟩,precedes:⟨
"but make it easy to toggle off/on
nnoremap <leader>l :set list!<cr>:set list?<cr>

" display tabs 4 wide
set tabstop=4

"set hlsearch

" enable open/close movement beyond parens. e.g. html, if/else, do/end
runtime macros/matchit.vim
" TODO: looks like sensible does this (but w/ 'runtime!')

" toggle paste mode (including w/in insert mode)
set pastetoggle=<F10>

" used by gitgutter
set updatetime=400

" Language-specific again:

"let g:neoformat_enabled_javascript = ['prettier']

" let g:julia_blocks=0 " maybe turn of julia-vim's matchit mappings
" let g:default_julia_version = "devel"

" Use goimports on save (.go files)
let g:go_fmt_command = "goimports"

" Syntax highlighting
" let g:go_highlight_operators = 1

" Sometimes when using both vim-go and syntastic Vim will start lagging while saving and opening files. The following fixes this:
" let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
" let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

" Another issue with vim-go and syntastic is that the location list window that contains the output of commands such as :GoBuild and :GoTest might not appear. To resolve this:
" let g:go_list_type = "quickfix"

" Why wasn't :GoDoc working for me, how to get back after :GoDef?
" Real-time autocomplete: https://github.com/Shougo/neocomplete.vim
" Tag browsing: https://github.com/majutsushi/tagbar

set wildignore+=*/node_modules/*,*/vendor/*

