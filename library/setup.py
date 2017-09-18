from cx_Freeze import setup, Executable
from dbf import VfpTable, RecordVaporWare, Date, DateTime, IndexFile

base = None


executables = [Executable("reminder.py", base=base)]

packages = []
options = {
    'build_exe': {
        'packages':packages,
    },

}

setup(
    name = "reminder",
    options = options,
    version = "1",
    description = 'reminder',
    executables = executables
)