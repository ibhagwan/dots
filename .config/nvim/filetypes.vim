" Vimscript
augroup initvim-vim
  au! BufNewFile,BufFilePre,BufRead *.vim set filetype=vim
    \ expandtab shiftwidth=2 tabstop=2 softtabstop=2
    \ colorcolumn=81 foldmethod=marker
augroup END

" bash
augroup initvim-bash
  au! BufNewFile,BufFilePre,BufRead *.sh,*.zsh set filetype=sh
    \ expandtab shiftwidth=2 tabstop=2 softtabstop=2
    \ colorcolumn=81
augroup END

" C/C++
augroup initvim-cpp
  au! BufNewFile,BufFilePre,BufRead *.c,*.cpp set filetype=cpp
    \ expandtab shiftwidth=4 tabstop=4 softtabstop=4
    \ colorcolumn=81 formatoptions+=croq
    \ path+=/usr/include,/usr/local/include
    \ signcolumn=yes cmdheight=2 " < for coc.vim
augroup END

" Lua
augroup initvim-lua
  au! BufNewFile,BufFilePre,BufRead *.lua set filetype=lua
    \ expandtab shiftwidth=4 tabstop=4 softtabstop=4
    \ colorcolumn=81 formatoptions+=croq
    \ signcolumn=yes cmdheight=2 " < for coc.vim
augroup END

" markdown
augroup initvim-md
  au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
    \ expandtab shiftwidth=4 tabstop=4 softtabstop=4
    \ colorcolumn=81 formatoptions+=croq
    \ spell spelllang=en_us
augroup END

" Python
augroup initvim-python
  au! BufNewFile,BufFilePre,BufRead *.py set filetype=python
    \ expandtab shiftwidth=4 tabstop=4 softtabstop=4
    \ colorcolumn=81 formatoptions+=croq
    \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END
