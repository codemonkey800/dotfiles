" A bunch of custom ncu sources that can be done through vim directly

if exists('g:loaded_ncu_sources')
  finish
endif
let g:loaded_ncu_sources = 1

autocmd! User CmSetup call cm#register_source({
  \ 'name': 'cm-css',
  \ 'priority': 9,
  \ 'scoping': 1,
  \ 'scopes': ['css', 'scss'],
  \ 'abbreviation': 'css',
  \ 'cm_refresh_patterns': [':\s+\w*$'],
  \ 'cm_refresh': { 'omnifunc': 'csscomplete#CompleteCSS' },
\ })

