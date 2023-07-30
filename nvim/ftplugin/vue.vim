if exists('g:loaded_ftplugin_vue')
  finish
endif
let g:loaded_ftplugin_vue = 1

let s:maker = neomake#makers#ft#javascript#eslint()
let g:neomake_vue_eslint_maker = extend(s:maker, {
  \ 'exe': $PWD . '/node_modules/.bin/eslint',
\ })

let g:neomake_vue_enabled_makers = ['eslint']

