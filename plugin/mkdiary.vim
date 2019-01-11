" Copyright 2019 Michał Kaliński

if get(g:, 'loaded_mkdiary', 0)
    finish
endif

let loaded_mkdiary = 1


command -bang MkDiary
\   call mkdiary#open_today_entry_file('<mods>', 0, 'edit<bang>')

command -bang -count MkDiarySplit
\   call mkdiary#open_today_entry_file('<mods>', <count>, 'split<bang>')
