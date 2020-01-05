# mkdiary

Provides a very simple functionality for creating diary entries, inspired by
[vimwiki](https://github.com/vimwiki/vimwiki).

Written in pure vimscript, python3 is only used by the [Denite](https://github.com/Shougo/denite.nvim) source.

## Usage

### Commands

```viml
MkDiary[!] [(+|-)days]
```

Opens for editing a file with path `DIARY_DIR/Year/Month/Day.Ext`,
where:

- `DIARY_DIR` is the directory configured by `mkdiary_root_dir`.
- `Year` is the current year expressed with 4 digits (`2018`, `2019`, etc.).
- `Month` is the current month of the year expressed with 2 digits, zero-padded
  (`01` for January, etc.).
- `Day` is the current day of the month expressed with 2 digits, zero-padded.
- `Ext` is the file extension configured by `mkdiary_entry_file_extension`.

Before the file is opened, its whole directory path is create if it doesn't
exist.

The value of `Day` can be modified by the value of the `days` argument, forward
or backward in time depending on the sign. For example, `:MkDiary -1` opens the
diary entry for yesterday.

The command opens the buffer in the current window like `:edit[!]` does.

```viml
MkDiarySplit [(+|-)days]
```

Same as `MkDiary`, but opens the buffer like `:split`.

### Denite source

```viml
Denite mkdiary[:Year[:Month]]
```

Lists all the files under `mkdiary_root_dir` that match the standard diary
pattern. Arguments can be provided that will limit the search to
sub-directories for the given year and month.


## Configuration

```viml
let mkdiary_root_dir = $HOME . '/vim-diary'
```

The root directory where all diary entries will be created. Must be set and
non-empty.

```viml
let mkdiary_entry_file_extension = 'txt'
```

Extension that diary entry files will have.
