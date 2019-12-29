if exists('g:loaded_ftplugin_vim')
  finish
endif
let g:loaded_ftplugin_vim = 1

augroup vim_cmds
  autocmd FileType vim set foldmarker={{,}} foldlevel=0 foldmethod=marker
augroup END

