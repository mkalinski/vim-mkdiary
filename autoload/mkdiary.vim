" Copyright 2019 Michał Kaliński

let s:ENTRY_PAT = '/%Y/%m/%d'


function mkdiary#prepare_today_entry_file() abort
    let entry_filename = s:make_entry_filename()
    let entry_dirname = fnamemodify(entry_filename, ':p:h')

    call mkdir(entry_dirname, 'p')

    return entry_filename
endfunction

function mkdiary#open_today_entry_file(mods, count, edit_command) abort
    let entry_filename = mkdiary#prepare_today_entry_file()

    execute (empty(a:mods) ? '' : a:mods . ' ') .
    \   (a:count ? a:count : '') . a:edit_command
    \   entry_filename
endfunction

function s:make_entry_filename() abort
    if s:is_g_var_without_value('mkdiary_root_dir')
        throw 'MkDiaryError: mkdiary_root_dir must exist and be non-empty'
    endif

    return g:mkdiary_root_dir .
    \   strftime(s:ENTRY_PAT) .
    \   (
    \       s:is_g_var_without_value('mkdiary_entry_file_extension') ?
    \           '' :
    \           '.' . g:mkdiary_entry_file_extension
    \   )
endfunction

function s:is_g_var_without_value(varname) abort
    return strlen(get(g:, a:varname, '')) == 0
endfunction
