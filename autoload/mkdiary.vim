" Copyright 2019,2020 Michał Kaliński

let s:ENTRY_PAT = '/%Y/%m/%d'
let s:DAY_LEN_IN_SECONDS = 24 * 60 * 60

function mkdiary#edit(mods, bang, args) abort
    call s:open_entry(
    \   'edit',
    \   function('mkdiary#get_explore_command'),
    \   a:mods,
    \   a:bang,
    \   s:parse_command_options(a:args),
    \)
endfunction

function mkdiary#split(mods, bang, args) abort
    call s:open_entry(
    \   'split',
    \   function('mkdiary#get_explore_split_command'),
    \   a:mods,
    \   a:bang,
    \   s:parse_command_options(a:args),
    \)
endfunction

function mkdiary#get_root_dir() abort
    return get(g:, 'mkdiary_root_dir', $HOME . '/vim-diary')
endfunction

function mkdiary#get_file_extension() abort
    return get(g:, 'mkdiary_entry_file_extension', 'txt')
endfunction

function mkdiary#get_explore_command() abort
    return get(g:, 'mkdiary_dir_explore_command', 'edit')
endfunction

function mkdiary#get_explore_split_command() abort
    return get(g:, 'mkdiary_dir_explore_split_command', 'split')
endfunction

function mkdiary#lcd_root() abort
    execute 'lcd' mkdiary#get_root_dir()
endfunction

function s:parse_command_options(options_string) abort
    if empty(a:options_string)
        return s:time2entry(localtime())
    endif

    if s:is_relative_day_arg(a:options_string)
        return s:time2entry(
        \   localtime() + str2nr(a:options_string) * s:DAY_LEN_IN_SECONDS
        \)
    endif

    return s:parse_entry_options(a:options_string)
endfunction

function s:time2entry(timestamp) abort
    return strftime(s:ENTRY_PAT, a:timestamp)
endfunction

function s:is_relative_day_arg(string) abort
    return a:string =~# '^[-+]\d\+'
endfunction

function s:parse_entry_options(options_string) abort
    let l:options = split(a:options_string)
    let l:entry = s:parse_date_part_arg(l:options[0], a:options_string)

    for l:i in range(1, 3)
        if len(l:options) > l:i
            let l:entry .= s:parse_date_part_arg(
            \   l:options[l:i],
            \   a:options_string,
            \)
        else
            break
        endif
    endfor

    return l:entry
endfunction

function s:parse_date_part_arg(date_part, args_string) abort
    let l:date_num = str2nr(a:date_part)

    if l:date_num > 0
        return '/' . l:date_num
    endif

    throw s:error_command_args(a:args_string)
endfunction

function s:error_command_args(args_string) abort
    return 'mkdiaryError: Invalid command arguments: ' . a:args_string
endfunction

function s:open_entry(file_command, dir_command_get, mods, bang, entry) abort
    let l:full_entry = s:get_full_entry(a:entry)

    if s:is_dir_entry(a:entry)
        call mkdir(l:full_entry, 'p')
        call s:open_dir(a:dir_command_get, a:mods, a:bang, l:full_entry)
    else
        call mkdir(fnamemodify(l:full_entry, ':h'), 'p')
        call s:open_file(a:file_command, a:mods, a:bang, l:full_entry)
    endif

    call mkdiary#lcd_root()
endfunction

function s:open_dir(dir_command_get, mods, bang, full_entry) abort
    let l:explore = a:dir_command_get()

    if type(l:explore) == type('')
        execute s:format_command(a:mods, l:explore, a:bang, a:full_entry)
    else
        call l:explore(a:mods, a:bang, a:full_entry)
    endif
endfunction

function s:open_file(file_command, mods, bang, full_entry) abort
    execute s:format_command(
    \   a:mods,
    \   a:file_command,
    \   a:bang,
    \   printf('%s.%s', a:full_entry, mkdiary#get_file_extension()),
    \)
endfunction

function s:is_dir_entry(entry) abort
    return count(a:entry, '/') < 3
endfunction

function s:get_full_entry(entry) abort
    return fnamemodify(mkdiary#get_root_dir() . '/' . a:entry, ':p')
endfunction

function s:format_command(mods, command, bang, path) abort
    let l:formatted = a:command . a:bang . ' ' . a:path

    if !empty(a:mods)
        let l:formatted = a:mods . ' ' . l:formatted
    endif

    return l:formatted
endfunction
