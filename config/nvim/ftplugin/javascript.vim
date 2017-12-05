let g:neomake_javascript_enabled_makers = []

" enable the following as linters only if they're in PATH
if executable('eslint')
    call add(g:neomake_javascript_enabled_makers, 'eslint')
endif

if executable('flow')
    call add(g:neomake_javascript_enabled_makers, 'flow')
endif

