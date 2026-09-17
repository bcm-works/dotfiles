set nocompatible

colorscheme Tomorrow-Night-Bright

" General

set paste
set ruler
set nostartofline
set number
set undolevels=1000
set history=200
set noerrorbells
set visualbell

" Text formatting

set autoindent
set smartindent
set nowrap
set softtabstop=4
set shiftwidth=4
set tabstop=4
set expandtab
set nosmarttab
set formatoptions+=n
set textwidth=80
set virtualedit=block
set ignorecase
set smartcase

" Syntax highlighting

filetype plugin on
syntax on
set termguicolors

highlight LineNr        guifg=#222222
highlight vimComment    guifg=#666666
highlight vimTodo       guibg=#4d0045 guifg=#dbccda cterm=NONE ctermfg=NONE ctermbg=NONE

" Keybindings

" Ctrl+Shift+up to swap current line with the line above
nmap <C-S-Up> :m -2<CR>

"Ctrl+Shift+down to swap current line with the line below
nmap <C-S-Down> :m +1<CR>
