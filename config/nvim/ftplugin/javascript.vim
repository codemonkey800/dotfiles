let s:maker = neomake#makers#ft#javascript#eslint()
let g:neomake_javascript_eslint_maker = extend(s:maker, {
  \ 'exe': $PWD . '/node_modules/.bin/eslint',
\ })

let g:neomake_javascript_enabled_makers = ['eslint']

