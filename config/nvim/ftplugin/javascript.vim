let g:neomake_javascript_enabled_makers = []

" enable the following as linters only if they're in PATH
if executable('eslint')
  call add(g:neomake_javascript_enabled_makers, 'eslint')
  let g:neomake_javascript_eslint_exe = $PWD . '/node_modules/.bin/eslint'
endif

if executable('flow')
  call add(g:neomake_javascript_enabled_makers, 'flow')
endif

