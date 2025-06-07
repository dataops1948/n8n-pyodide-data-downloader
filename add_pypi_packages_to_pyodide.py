import os
from pathlib import Path
from pyodide_lock import PyodideLockSpec
from pyodide_lock.utils import add_wheels_to_spec


PYPI_PACKAGES_DIR_PATH = '/pyodide-pypi-packages'
N8N_PYODIDE_DIR_PATH = '/usr/local/lib/node_modules/n8n/node_modules/pyodide'


def find_none_any_whl_files(directory: str) -> list[Path]:
    return [
        Path(os.path.join(directory, filename))
        for filename in os.listdir(directory)
        if filename.endswith('-none-any.whl') and os.path.isfile(os.path.join(directory, filename))
    ]


lock_spec = PyodideLockSpec.from_json(Path(f'{N8N_PYODIDE_DIR_PATH}/pyodide-lock.json'))
wheel_files = find_none_any_whl_files(PYPI_PACKAGES_DIR_PATH)
lock_spec = add_wheels_to_spec(lock_spec=lock_spec, wheel_files=wheel_files)
lock_spec.to_json(Path(f'{N8N_PYODIDE_DIR_PATH}/pyodide-lock.json'))
