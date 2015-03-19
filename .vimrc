noremap ,q :q!<CR>
noremap ,s :w!<CR>
noremap ,w :wq!<CR>
noremap ,e :sp ~/.vimrc<CR>
noremap ,z J
noremap ,bd :bd<CR>
noremap <tab> :bn<CR>
noremap ,<tab> :bp<CR>
noremap ,a :ls<CR>
noremap <F10> <esc>:w!<CR>:!python %<CR>
"win中启动python3.4.3的GUI交互式命令行IDLE(对应python3.4.3的安装目录)
"noremap <F9> <esc>:w!<CR>:!chcp 65001 & start "IDLE" "D:\Program Files\python3.4.3\pythonw.exe" "D:\Program Files\python3.4.3\Lib\idlelib\idle.pyw"<CR>
inoremap jj <esc>

inoremap <c-h> <esc>I
inoremap <c-l> <esc>A
inoremap <c-j> <esc><down>I
inoremap <c-k> <esc><up>I
inoremap h <esc><right>bi
inoremap l <esc><right>ei
inoremap j <esc><down>A
inoremap k <esc><up>A
noremap <left> <c-w><c-h>
noremap <down> <c-w><c-j>
noremap <up> <c-w><c-k>
noremap <right> <c-w><c-l>
noremap <c-h> 0
noremap <c-l> $
noremap <c-j> <c-d>
noremap <c-k> <c-u>
noremap h b
noremap l e
noremap j <c-e>
noremap k <c-y>
noremap <s-k> <c-b>
noremap <s-j> <c-f>

syntax on
colorscheme elflord
set winaltkeys=no
set number
set nocompatible
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,cp936,big5
set fileencoding=utf-8
set termencoding=utf-8
set ffs=unix
set incsearch
set whichwrap+=<,>,h,l
set ignorecase
set autoindent
set smartindent
set ruler
set nobackup
"不要生成swap文件,当buffer被丢弃的时候隐藏它
setlocal noswapfile
set bufhidden=hide
"set noerrorbells

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set backspace=2
