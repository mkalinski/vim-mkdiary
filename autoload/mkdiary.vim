" Copyright 2019 Michał Kaliński

let s:ENTRY_PAT = '/%Y/%m/%d'
let s:DAY_LEN_IN_SECONDS = 24 * 60 * 60


function mkdiary#open_today_entry_file(mods, count, edit_command) abort
    let entry_filename = s:make_entry_filename()
    call s:open_entry_file(a:mods, a:count, a:edit_command, entry_filename)
endfunction

function mkdiary#open_yesterday_entry_file(mods, count, edit_command) abort
    let entry_filename = s:make_entry_filename({
    \   'timestamp': localtime() - s:DAY_LEN_IN_SECONDS,
    \})
    call s:open_entry_file(a:mods, a:count, a:edit_command, entry_filename)
endfunction

function s:make_entry_filename(...) abort
    call s:ensure_root_set()

    let opts = a:0 > 0 ? a:1 : {}

    return g:mkdiary_root_dir . s:format_time(opts) . s:get_file_exension()
endfunction

function s:is_g_var_without_value(varname) abort
    return strlen(get(g:, a:varname, '')) == 0
endfunction

function s:get_file_exension() abort
    return s:is_g_var_without_value('mkdiary_entry_file_extension') ?
    \   '' :
    \   '.' . g:mkdiary_entry_file_extension
endfunction

function s:format_time(opts) abort
    if has_key(a:opts, 'timestamp')
        let timestamp = a:opts['timestamp']
        return strftime(s:ENTRY_PAT, timestamp)
    endif

    return strftime(s:ENTRY_PAT)
endfunction

function s:prepare_entry_file(entry_filename) abort
    let entry_dirname = fnamemodify(a:entry_filename, ':p:h')
    call mkdir(entry_dirname, 'p')
endfunction

function s:open_entry_file(mods, count, edit_command, entry_filename) abort
    call s:prepare_entry_file(a:entry_filename)
    execute
    \   (empty(a:mods) ? '' : a:mods . ' ') .
    \   (a:count ? a:count : '') .
    \   a:edit_command
    \   a:entry_filename
    call s:lcd_to_root()
endfunction

function s:ensure_root_set() abort
    if s:is_g_var_without_value('mkdiary_root_dir')
        throw 'MkDiaryError: mkdiary_root_dir must exist and be non-empty'
    endif
endfunction

function s:lcd_to_root() abort
    call s:ensure_root_set()
    execute 'lcd' g:mkdiary_root_dir
endfunction
