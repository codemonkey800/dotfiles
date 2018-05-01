if exists('g:loaded_ftplugin_cpp')
  finish
endif
let g:loaded_ftplugin_cpp = 1

let g:neomake_cpp_enabled_makers = ['cppclang']
let g:neomake_cpp_cppclang_maker = neomake#makers#ft#cpp#clang()

