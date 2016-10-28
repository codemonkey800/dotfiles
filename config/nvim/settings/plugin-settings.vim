"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Neoterm settings
let g:neoterm_shell = "fish"

" vim-json settings
let g:vim_json_syntax_conceal = 0

" Airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" Neomake settings
autocmd! BufWritePost * Neomake

" vim-markdown settings
let g:vim_markdown_math = 1
let g:vim_markdown_json_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2

" vim-lexical settings
augroup lexical
    autocmd!
    autocmd FileType markdown,mkd call lexical#init()
    autocmd FileType textile call lexical#init()
    autocmd FileType text call lexical#init({ 'spell': 0 })
augroup END

let g:lexical#thesaurus = ['~/.config/nvim/thesaurus.txt']
let g:lexical#dictionary = ['/usr/share/dict/american-english']

let g:lexical#spell_key = '<leader>s'
let g:lexical#thesaurus_key = '<leader>t'
let g:lexical#dictionary_key = '<leader>k'

" vim-pencil settings
augroup pencil
    autocmd!
    autocmd FileType markdown,mkd call pencil#init()
    autocmd FileType text call pencil#init()
augroup END

" Deoplete settings
let g:deoplete#enable_at_startup = 1

" vim-jsx settings
let g:jsx_ext_required = 0

" vim-editorconfig settings
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" clang_complete settings
let g:clang_library_path = '/usr/lib/libclang.so'

" vim-javacomplete2 settings
autocmd FileType java setlocal omnifunc=javacomplete#Complete

" NERDTree settings
function! CloseIfNERDTreeOpen()
    if winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()
        q
    endif
endfunction

function! OnVimEnter()
    if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") |
        exe 'NERDTree' argv()[0] |
        wincmd p |
        ene |
    endif
endfunction

autocmd StdinReadPre * let s:std_in = 1
autocmd bufenter * :call CloseIfNERDTreeOpen()
autocmd VimEnter * :call OnVimEnter()

