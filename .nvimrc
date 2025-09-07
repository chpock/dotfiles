command! DotfilesUpdate !./src/bashrc/rebuild.sh
autocmd BufWritePost * silent! execute 'DotfilesUpdate'
