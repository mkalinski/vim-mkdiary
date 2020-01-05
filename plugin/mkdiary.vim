" Copyright 2019,2020 Michał Kaliński

if get(g:, 'loaded_mkdiary', 0)
    finish
endif
let loaded_mkdiary = 1

if !exists('g:mkdiary_root_dir')
    let mkdiary_root_dir = $HOME . '/vim-diary'
endif

if !exists('g:mkdiary_entry_file_extension')
    let mkdiary_entry_file_extension = 'txt'
endif

command! -bang -nargs=? MkDiary call mkdiary#edit(<q-bang>, <q-mods>, <q-args>)
command! -nargs=? MkDiarySplit call mkdiary#split(<q-mods>, <q-args>)
