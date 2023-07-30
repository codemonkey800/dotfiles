if exists('g:loaded_ftplugin_javascript')
  finish
endif
let g:loaded_ftplugin_javascript = 1

let s:eslint = FindEslint()
if s:eslint ==? ''
  finish
endif

