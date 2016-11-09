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

let g:lexical#spell_key = '<leader>t'
let g:lexical#thesaurus_key = '<leader>T'
let g:lexical#dictionary_key = '<leader>k'

" vim-pencil settings
augroup pencil
    autocmd!
    autocmd FileType markdown,mkd call pencil#init()
    autocmd FileType text call pencil#init()
augroup END

" vim-jsx settings
let g:jsx_ext_required = 0

" vim-editorconfig settings
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" deoplete settings
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources = {}
let g:deoplete#keyword_patterns = {}

" clang_complete settings
let g:clang_library_path = '/usr/lib/libclang.so'

" tmux-complete settings
let g:tmuxcomplete#trigger = ''

" deoplete-flow settings
let g:deoplete#sources#flow#flow_bin = 'flow'

" deoplete-github settings
let g:deoplete#sources.gitcommit = ['github']
let g:deoplete#keyword_patterns.gitcommit = '.+'
let g:deoplete#omni#input_patterns = {}
call deoplete#util#set_pattern(
    \ g:deoplete#omni#input_patterns,
    \ 'gitcommit',
    \ [g:deoplete#keyword_patterns.gitcommit])

