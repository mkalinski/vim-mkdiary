# mkdiary

Provides a very simple functionality for creating diary entries, inspired by
[vimwiki](https://github.com/vimwiki/vimwiki).

Written in pure vimscript, python3 is only used for
[Denite](https://github.com/Shougo/denite.nvim) source.

## Usage

### Commands

This plugin defines two commands:

```viml
:MkDiary[!] [(+|-){days} | [{year} [{month} [{day}]]]]
```

Without arguments, opens (with `:edit[!]`) for editing a file with path
`DIARY_DIR/Year/Month/Day.Ext`, where:

- `DIARY_DIR` is the directory configured by `mkdiary_root_dir`.
- `Year` is the current year expressed with 4 digits (`2018`, `2019`, etc.).
- `Month` is the current month of the year expressed with 2 digits, zero-padded
  (`01` for January, etc.).
- `Day` is the current day of the month expressed with 2 digits, zero-padded.
- `Ext` is the file extension configured by `mkdiary_entry_file_extension`.

Before the file is opened, its whole directory path is create if it doesn't
exist.

If `(+|-){days}` argument is passed, where `days` is an integer, an entry for
`{current day} (+|-) {days}` is opened instead.

If `{year} {month} {day}` arguments are passed, where all values are integers,
the entry for that day is opened instead.

If `{year}` or `{year} {month}` arguments are passed, where both values are
integers, the directory `DIARY_DIR/Year` or `DIARY_DIR/Year/Month` are opened.
If they don't exist, they're created. They're opened using `:edit[!]`, which
normally invokes netrw, but this can be customized using
`mkdiary_dir_explore_command`.

The `!` is passed to the opening command.

```viml
:MkDiarySplit[!] [(+|-){days} | [{year} [{month} [{day}]]]]
```

Same as `MkDiary`, but opens the buffer like `:split`. When opening
a directory, `mkdiary_dir_explore_command` is used.

The `!` is passed to the opening command, and modifiers can be used to change
where the new window is opened (like with `:split`).

### Denite source

```viml
Denite mkdiary[:Year[:Month]]
```

Lists all the files under `mkdiary_root_dir` that match the standard diary
pattern. Arguments can be provided that will limit the search to
sub-directories for the given year and month.


## Configuration

```viml
let g:MkDiary_root_dir = $HOME . '/vim-diary'
```

The root directory where all diary entries will be created.

```viml
let g:MkDiary_entry_file_extension = 'txt'
```

Extension that diary entry files will have.

```viml
let g:MkDiary_dir_explore_command = 'edit'
let g:MkDiary_dir_explore_split_command = 'split'
```

The commands to use to open directories. Their values can be either strings or
funcrefs.

If they're strings, they're taken to be the name of the command that's invoked
like this:

```viml
{modifiers} {command}[!] {absolute directory path}
```

If they're funcrefs, they're called like this:

```viml
func({modifiers}, {bang}, {absolute directory path})
```

The commands / funcrefs should open the entry in the same / new window, and
keep the cursor there by they time they exit.
