
augroup Racer
    autocmd!
    autocmd FileType rust nmap <buffer> <leader>gd         <Plug>(rust-def)
    autocmd FileType rust nmap <buffer> <leader>gs         <Plug>(rust-def-split)
    autocmd FileType rust nmap <buffer> <leader>gx         <Plug>(rust-def-vertical)
    autocmd FileType rust nmap <buffer> <leader>gt         <Plug>(rust-def-tab)
    autocmd FileType rust nmap <buffer> <leader>ct <Plug>(rust-doc)
augroup END

let g:racer_insert_paren = 1
let g:racer_experimental_completer = 1
