# mkdiary

Provides a very simple functionality for creating diary entries, inspired by
[vimwiki](https://github.com/vimwiki/vimwiki).

## Usage

### Commands

`MkDiary` opens for editing a file with path `DIARY_DIR/Year/Month/Day.Ext`,
where:

- `DIARY_DIR` is the directory configured by `mkdiary#root_dir`.
- `Year` is the current year expressed with 4 digits (`2018`, `2019`, etc.).
- `Month` is the current month of the year expressed with 2 digits, zero-padded
  (`01` for January, etc.).
- `Day` is the current day of the month expressed with 2 digits, zero-padded.
- `Ext` is the file extension configured by `mkdiary#entry_file_extension`.

Before the file is opened, the whole directory path is create if it doesn't
exist.

`MkDiarySplit` works the same but opens the file in a new split buffer.

Both commands react to bang and command modifiers in the same way as `edit` and
`split`, respectively.

## Configuration

- `mkdiary#root_dir`

The root directory where all diary entries will be created.

Default: `$HOME/vim-diary`

- `mkdiary#entry_file_extension`

Extension that diary entry files will have.

Default: `txt`
