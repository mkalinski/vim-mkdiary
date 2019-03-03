# Copyright 2019 Michał Kaliński

from glob import iglob

from .base import Base


class Source(Base):
    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'mkdiary'
        self.kind = 'file'
        self.sorters = ['sorter/word', 'sorter/rank']

    def gather_candidates(self, context):
        root = self.vim.vars['mkdiary_root_dir']

        if not root:
            self.error_message(
                context,
                'mkdiary_root_dir must exist and be non-empty'
            )
            return []

        ext = self.vim.vars['mkdiary_entry_file_extension']
        year, month = self.__get_year_and_month_from_args(context)

        return [
            {
                'word': self.__strip_root(path, root),
                'action__path': path,
            }
            for path in self.__iter_diary_entries(year, month, root, ext)
        ]

    @staticmethod
    def __get_year_and_month_from_args(context):
        args = context['args'][:2]
        return args + ['*'] * (2 - len(args))

    @staticmethod
    def __iter_diary_entries(year, month, root_dir, extension):
        return iglob('{root}/{year}/{month}/*{ext}'.format(
            root=root_dir,
            year=year,
            month=month,
            ext='.' + extension if extension else '',
        ))

    @staticmethod
    def __strip_root(path, root):
        stripped = root + '/'
        return path[len(stripped):] if path.startswith(stripped) else path
