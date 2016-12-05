"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocomplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Deoplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! GetNodePackageManager()
    if executable('npm')
        return 'npm'
    elseif executable('yarn')
        return 'yarn'
    else
        return ''
    endif
endfunction

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#sources = {}
let g:deoplete#keyword_patterns = {}

" clang_complete
let g:clang_library_path = '/usr/lib/libclang.so'

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

" The following deoplete configurations are only set if there is a node
" package manager available
let s:node_package_manager = GetNodePackageManager()
if s:node_package_manager != ''
    " deoplete-flow
    let g:flow_path = system('setenv PATH $PATH (' . s:node_package_manager . ' bin);and which flow ^ /dev/null; or echo "flow not found"')
    if g:flow_path != 'flow not found'
      let g:deoplete#sources#flow#flow_bin = g:flow_path
    endif


    " deoplete-ternjs
    let s:tern_path = system('setenv PATH $PATH (' . s:node_package_manager . ' bin); and which tern ^ /dev/null; or echo "tern not found"')
    if s:tern_path != 'tern not found'
        let g:tern_request_timeout = 1
        let g:tern#command = [s:tern_path]
        let g:tern#arguments = ['--persistent']
    endif
end

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
let g:vim_markdown_math = 1
let g:vim_markdown_json_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2

" vim-jsx
let g:jsx_ext_required = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Airline
let g:airline#extensions#tmuxline#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'onedark'

" neotags
let g:neotags_enabled = 1
let g:neotags_file = '/tmp/tags'

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
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit'}
let g:fzf_layout = { 'down': '~30%' }

" vim-editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Neoterm
let g:neoterm_shell = "fish"

" Neomake
autocmd! BufWritePost,BufEnter * Neomake

