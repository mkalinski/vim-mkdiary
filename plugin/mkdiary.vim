" Copyright 2019,2020 Michał Kaliński

if get(g:, 'loaded_mkdiary', 0)
    finish
endif
let loaded_mkdiary = 1

command! -bang -nargs=? MkDiary
\   call mkdiary#edit(<q-mods>, <q-bang>, <q-args>)

command! -bang -nargs=? MkDiarySplit
\   call mkdiary#split(<q-mods>, <q-bang>, <q-args>)
