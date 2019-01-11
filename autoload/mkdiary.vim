" Copyright 2019 Michał Kaliński

let s:ENTRY_PAT = '/%Y/%m/%d'


function mkdiary#prepare_today_entry_file() abort
    let entry_filename = s:make_entry_filename()
    let entry_dirname = fnamemodify(entry_filename, ':p:h')

    call mkdir(entry_dirname, 'p')

    return entry_filename
endfunction

function mkdiary#open_today_entry_file(mods, count, edit_command) abort
    execute (empty(a:mods) ? '' : a:mods . ' ') .
    \   (a:count ? a:count : '') . a:edit_command
    \   mkdiary#prepare_today_entry_file()
endfunction

function s:make_entry_filename() abort
    return g:mkdiary_root_dir .
    \   strftime(s:ENTRY_PAT) .
    \   '.' . g:mkdiary_entry_file_extension
endfunction
