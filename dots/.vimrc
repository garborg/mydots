" TO INSTALL PLUG:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" make sure .vimrc is in place
" then reload .vimrc and call ``:PlugInstall`

" really need to remap ~ someday

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
" many options for file/directory/buffer/etc nav
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" ctrlpvim/ctrlp.vim, wincent/command-t,
" https://news.ycombinator.com/item?id=4218575
" https://github.com/Shougo/denite.nvim
" https://github.com/junegunn/fzf.vim
Plug 'tpope/vim-fugitive' " vim-gitgutter
Plug 'scrooloose/syntastic' " alt: https://github.com/neomake/neomake
Plug 'surround.vim'
Plug 'editorconfig/editorconfig-vim'

" vim8: http://www.vim.org/download.php
" http://ellengummesson.com/blog/2015/08/01/dropping-ctrlp-and-other-vim-plugins/
" https://github.com/tpope/vim-dispatch
" http://vimawesome.com/

"Language-specific:
Plug 'JuliaEditorSupport/julia-vim'
call plug#end()

" ensure that editorconfig works well with fugituve
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" syntastic recommended beginner settings
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
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

" call out tabs and trailing space
set list
set listchars=tab:!·,trail:·

"case insensitive search by default
set ignorecase
set smartcase

" enable open/close movement beyond parens. e.g. html, if/else, do/end
runtime macros/matchit.vim

" Kinda language-specific again:

" let g:julia_blocks=0 " maybe turn of julia-vim's matchit mappings
" let g:default_julia_version = "devel"

set wildignore+=*/node_modules/*,*/vendor/*

