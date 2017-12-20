" --------------------------------------------
" Vundle settings
" --------------------------------------------
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'morhetz/gruvbox'
Plugin 'CSApprox'
Plugin 'ScrollColors'
Plugin 'scrooloose/syntastic'
Plugin 'jiangmiao/auto-pairs'
Plugin 'haya14busa/incsearch.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'majutsushi/tagbar'
Plugin 'Yggdroot/LeaderF', { 'do': './install.sh'  }
"Plugin 'Lokaltog/vim-powerline'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"Plugin 'Valloric/YouCompleteMe'

call vundle#end()            " required
filetype plugin indent on    " required


" --------------------------------------------
" Common settings
" --------------------------------------------
set nocompatible

syntax enable
syntax on

" Show mode (insert/replace/visual)
set showmode 

" Show command
set showcmd 

" Show matched bracket
set showmatch 

" Show line number
set number

" Show the cursor position
set ruler

" Wrap the text
set wrap

" Auto indent
set autoindent

" File format 
set ffs=unix,dos ff=unix

" No bell in case of errors
set noerrorbells

" Ingore the case
set ignorecase

" Highlight the search
set hlsearch

" Incrementally  search
set incsearch

" Tab behavior
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
" show tab as ">-"
"set list listchars=tab:>-

" Backspace key, allow to delete auto-indent, lines
set backspace=indent,eol,start

" No generate backup file
set nobackup
set noswapfile

" Encoding
set fileencodings=utf-8,gb18030,gbk,gb2312
set fileencoding=utf-8
set termencoding=utf-8
set encoding=utf-8

" Color settings
set t_Co=256
"set background=dark

colorscheme desert
"colorscheme gruvbox
"colorscheme solarized

" map leader key
let mapleader=","

" tags, search tag file, if not found then find parent
set tags=tags; 

" --------------------------------------------
" Auto take effect
" --------------------------------------------
if has("autocmd")
    " auto take effect when saving
    autocmd! BufWritePost .vimrc source %

    " auto jump to the last position when reopening a file
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

    " tagbar: auto open tagbar, in some file types
    autocmd BufReadPost *.cpp,*.c,*.h,*.hpp,*.cc,*.cxx call tagbar#autoopen()

    " vim-commentary: set comment formats
    " to check which type a file is ":set filetype?"
    autocmd FileType python,sh,cmake,conf,text setlocal commentstring=#\ %s
    autocmd FileType c,cpp setlocal commentstring=//\ %s
    autocmd FileType vim setlocal commentstring="/\ %s
endif


" --------------------------------------------
" Hot keys
" --------------------------------------------
nmap <Leader>c :noh<CR>


" --------------------------------------------
" Buffers hot key
" --------------------------------------------
nnoremap <C-N> :bn!<CR>
nnoremap <C-P> :bp!<CR>
nnoremap <C-D> :bd!<CR>


" --------------------------------------------
" ScrollColors
" --------------------------------------------
map <silent><F9> :NEXTCOLOR<cr> 
map <silent><F10> :PREVCOLOR<cr> 


" --------------------------------------------
" incsearch
" --------------------------------------------
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)


" --------------------------------------------
" Tagbar
" --------------------------------------------
let g:tagbar_ctags_bin = '/usr/bin/ctags'
let g:tagbar_width = 30

noremap <F4> :TagbarToggle<CR>
" "!" indicates both insert and command mode
noremap! <F4> <ESC> :TagbarToggle<CR> 


" --------------------------------------------
" NETDTree
" --------------------------------------------
noremap <F3> :NERDTreeToggle<CR>
noremap! <F3> <ESC> :NERDTreeToggle<CR>


" --------------------------------------------
" NETDTree
" --------------------------------------------
let g:airline_theme="luna"
let g:airline_powerline_fonts = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
"unicode symbols
let g:airline_left_sep = '▶'
let g:airline_left_alt_sep = '❯'
let g:airline_right_sep = '◀'
let g:airline_right_alt_sep = '❮'
"let g:airline_symbols.linenr = '¶'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.branch = '⎇'


" --------------------------------------------
" Syntastic
" --------------------------------------------
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_enable_signs = 1

" error/warning symbols
"let g:syntastic_error_symbol='✗'
"let g:syntastic_warning_symbol = '►'

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_loc_list_height = 5

" check file once open, uncoment it to enable checking
"let g:syntastic_check_on_open = 1
" check before save&quit
"let g:syntastic_check_on_wq = 0
" auto jump to first error/warning
"let g:syntastic_auto_jump = 1

" highlight the error
"let g:syntastic_enable_highlighting=1

" support C++11
"let g:syntastic_cpp_compiler = 'clang++'
"let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
"let g:syntastic_cpp_compiler_options = ' -std=c++11'

"function! ToggleErrors()
"    let old_last_winnr = winnr('$')
"    lclose
"    if old_last_winnr == winnr('$')
        " Nothing was closed, open syntastic error location panel
"        Errors
"    endif
"endfunction
"nnoremap <Leader>s :call ToggleErrors()<CR>

" --------------------------------------------
" LeaderF
" --------------------------------------------
let g:Lf_CommandMap = {'<C-C>': ['<Esc>', '<C-C>']}
"let g:Lf_ShortcutF = '<Leader>f'
"let g:Lf_ShortcutB = '<Leader>b'

let g:Lf_ShortcutF = '<F5>' 
let g:Lf_ShortcutB = '<F6>' 

nnoremap <Leader>a :LeaderfFunction<CR>
nnoremap <Leader>t :LeaderfTag<CR>
nnoremap <Leader>m :LeaderfMru<CR>


" --------------------------------------------
" Ctags
" --------------------------------------------
"map <F11> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
"im <F11> <Esc>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>


" --------------------------------------------
" Cscope
" --------------------------------------------
if has("cscope")
    set csprg=/usr/bin/cscope
    " lookup cscope db first, then tag file
    set csto=0
    set cst
    " show result at quickfix window
    "set cscopequickfix=s-,c-,d-,i-,t-,e- 

    set nocsverb
    if filereadable("cscope.out") " check current dir
        cs add cscope.out
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb
endif

" map find command
" 0 or s: this C symbol
" 1 or g: this definition
" 2 or d: functions that called by this function
" 3 or c: functions that calling this function
" 4 or t: this test string
" 5 or e: this egrep pattern
" 7 or f: this file
" 8 or i: files #including this file
" 9 or a: places where this symbol is assigned a value
nnoremap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nnoremap <C-_>a :cs find a ^<C-R>=expand("<cfile>")<CR>$<CR>

" --------------------------------------------
" YouCompleteMe
" --------------------------------------------
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
"let g:ycm_confirm_extra_conf=0

"set completeopt=longest,menu  
"let g:ycm_key_list_previous_completion=['<Down>']  
"let g:ycm_key_list_previous_completion=['<Up>']

let g:ycm_collect_identifiers_from_tags_files=1
"let g:ycm_min_num_of_chars_for_completion=2
"let g:ycm_seed_identifiers_with_syntax=1

" behavior for comments and strings
"let g:ycm_complete_in_comments=1
"let g:ycm_complete_in_strings=1 
"let g:ycm_collect_identifiers_from_comments_and_strings=0

" hot keys
"nnoremap <F12> :YcmForceCompileAndDiagnostics<CR>

