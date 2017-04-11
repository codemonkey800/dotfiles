" nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
" nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
" nnoremap <silent> <M-r> :call LanguageClient_textDocument_rename()<CR>

" autocmd FileType * LanguageClientStart

let g:neomake_javascript_enabled_makers = []

" enable the following as linters only if they're in PATH
if executable('eslint')
    call add(g:neomake_javascript_enabled_makers, 'eslint')
endif

if executable('flow')
    call add(g:neomake_javascript_enabled_makers, 'flow')
endif

