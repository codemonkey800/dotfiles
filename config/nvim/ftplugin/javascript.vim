if exists('g:loaded_ftplugin_javascript')
  finish
endif
let g:loaded_ftplugin_javascript = 1

let s:eslint = FindEslint()
if s:eslint ==? ''
  finish
endif

let s:maker = neomake#makers#ft#javascript#eslint()
let s:maker['exe'] = s:eslint

let g:neomake_javascript_eslint_maker = s:maker
let g:neomake_javascript_enabled_makers = ['eslint']

