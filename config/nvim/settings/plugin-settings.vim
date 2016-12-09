"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocomplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Deoplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#sources = {}
let g:deoplete#keyword_patterns = {}

" clang_complete
let g:clang_library_path = '/usr/lib/libclang.so'
let g:clang_snippets = 1
let g:clang_snippets_engine = 'clang_complete'

" tmux-complete
let g:tmuxcomplete#trigger = ''

" deoplete-github
let g:deoplete#sources.gitcommit = ['github']
let g:deoplete#keyword_patterns.gitcommit = '.+'
let g:deoplete#omni#input_patterns = {}
call deoplete#util#set_pattern(
    \ g:deoplete#omni#input_patterns,
    \ 'gitcommit',
    \ [g:deoplete#keyword_patterns.gitcommit])

" deoplete-flow
" let g:deoplete#sources#flow#flow_bin = $PWD . '/node_modules/.bin/flow'

" ternjs
let g:tern_request_timeout = 1
let g:tern#command = [resolve(system('npm bin') . '/tern')]
let g:tern#arguments = ['--persistent']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Linting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Movement/Text Manipulation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Prose
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-lexical
augroup lexical
    autocmd!
    autocmd FileType markdown,mkd call lexical#init()
    autocmd FileType textile call lexical#init()
    autocmd FileType text call lexical#init({ 'spell': 0 })
augroup END

let g:lexical#thesaurus = ['~/.config/nvim/mthesaur.txt']
let g:lexical#dictionary = ['/usr/share/dict/american-english']

let g:lexical#spell_key = '<leader>t'
let g:lexical#thesaurus_key = '<leader>T'
let g:lexical#dictionary_key = '<leader>k'

" vim-pencil
augroup pencil
    autocmd!
    autocmd FileType markdown,mkd call pencil#init()
    autocmd FileType text call pencil#init()
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Snippets
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntaxes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-json
let g:vim_json_syntax_conceal = 0

" vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_json_frontmatter = 1
let g:vim_markdown_math = 1
let g:vim_markdown_new_list_item_indent = 2

" vim-jsx
let g:jsx_ext_required = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Airline
let g:airline_powerline_fonts = 1
" let g:airline_theme = 'onedark'
let g:airline_theme = 'molokai'
let g:airline#extensions#tabline#enabled = 1

" onedark.vim
let g:onedark_terminal_italics = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Utilitiy
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" echodoc
set noshowmode
let g:echodoc_enable_at_startup = 1

" fakeclip
let g:vim_fakeclip_tmux_plus = 1

" fzf.vim
let g:fzf_action = {
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit'}
let g:fzf_layout = { 'down': '~30%' }

" Neoterm
let g:neoterm_shell = "fish"

" Neomake
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_highlight_lines = 1

autocmd! BufWritePost * Neomake

" tmux-navigator
let g:tmux_navigator_no_mappings = 1

" vim-editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" undotree
let g:undotree_WindowLayout = 1
let g:undotree_SplitWidth = 50
let g:undotree_DiffpanelHeight = 20

