:set mouse=a
:set number
:set shiftwidth=2
:set tabstop=2
:set autoindent
:set relativenumber
:set smarttab
:set softtabstop=2

:set modeline
set notermguicolors
colorscheme lunaperche
syntax on

" Define highlight overrides
augroup MyColors
  autocmd!
  autocmd ColorScheme lunaperche highlight Identifier guifg=#00FFFF ctermfg=Cyan
  autocmd ColorScheme lunaperche highlight Comment    guifg=#FF0000 ctermfg=Red ctermbg=NONE
  autocmd ColorScheme lunaperche highlight String     guifg=#ff5fd7 ctermfg=206
  autocmd ColorScheme lunaperche highlight Normal     guifg=#0000FF ctermfg=Blue
  autocmd ColorScheme lunaperche highlight Number     guifg=#FFFFFF ctermfg=White
  autocmd ColorScheme lunaperche highlight Statement  guifg=#FFFF00 ctermfg=Yellow
augroup END
