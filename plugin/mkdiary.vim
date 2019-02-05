" Copyright 2019 Michał Kaliński

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


command -bang MkDiary
\   call mkdiary#open_today_entry_file('<mods>', 0, 'edit<bang>')

command -bang MkDiaryYesterday
\   call mkdiary#open_yesterday_entry_file('<mods>', 0, 'edit<bang>')

command -bang -count MkDiarySplit
\   call mkdiary#open_today_entry_file('<mods>', <count>, 'split<bang>')

command -bang -count MkDiaryYesterdaySplit
\   call mkdiary#open_yesterday_entry_file('<mods>', <count>, 'split<bang>')
