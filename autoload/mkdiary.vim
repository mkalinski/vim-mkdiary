" Copyright 2019,2020 Michał Kaliński

let s:ENTRY_PAT = '/%Y/%m/%d'
let s:DAY_LEN_IN_SECONDS = 24 * 60 * 60

function mkdiary#edit(bang, mods, ...) abort
    call s:open(
    \   s:join_mods_and_command(a:mods, 'edit') . a:bang,
    \   s:parse_options(a:000),
    \)
endfunction

function mkdiary#split(mods, ...) abort
    call s:open(
    \   s:join_mods_and_command(a:mods, 'split'),
    \   s:parse_options(a:000),
    \)
endfunction

function s:join_mods_and_command(mods, command) abort
    return (!empty(a:mods) ? a:mods . ' ' : '') . a:command
endfunction

function s:parse_options(args) abort
    if empty(a:args) || empty(a:args[0])
        return {}
    endif

    if a:args[0] =~# '^[+-]\d\+'
        return {'days_from_today': str2nr(a:args[0])}
    endif

    throw printf('MkDiaryError: Unknown arguments: %s', a:args)
endfunction

function s:open(command, options) abort
    let root = s:get_root_dir()
    let entry = s:get_entry(root, a:options)
    call s:prepare_entry_dir(entry)
    execute a:command entry
    execute 'lcd' root
endfunction

function s:get_root_dir() abort
    let root = get(g:, 'mkdiary_root_dir', '')

    if empty(root)
        throw 'MkDiaryError: `g:mkdiary_root_dir` is empty'
    endif

    return root
endfunction

function s:get_entry(root_dir, options) abort
    if has_key(a:options, 'days_from_today')
        return s:get_entry_for_days_from_today(
        \   a:root_dir,
        \   a:options.days_from_today,
        \)
    endif

    return s:get_entry_for_today(a:root_dir)
endfunction

function s:get_entry_for_today(root_dir) abort
    return s:get_entry_for_time(a:root_dir, localtime())
endfunction

function s:get_entry_for_days_from_today(root_dir, days_diff) abort
    return s:get_entry_for_time(
    \   a:root_dir,
    \   localtime() + a:days_diff * s:DAY_LEN_IN_SECONDS,
    \)
endfunction

function s:get_entry_for_time(root_dir, entry_time) abort
    return a:root_dir
    \   . strftime(s:ENTRY_PAT, a:entry_time)
    \   . s:get_file_exension()
endfunction

function s:get_file_exension() abort
    let ext = get(g:, 'mkdiary_entry_file_extension', '')
    return !empty(ext) ? '.' . ext : ''
endfunction

function s:prepare_entry_dir(entry_filename) abort
    call mkdir(fnamemodify(a:entry_filename, ':p:h'), 'p')
endfunction
