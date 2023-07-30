if exists('g:loaded_ftplugin_vim')
  finish
endif
let g:loaded_ftplugin_vim = 1

let g:neomake_tex_chktex_maker = {
  \ 'args': ['-n36', '-n1'],
\ }

