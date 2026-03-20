# Smart Python Environment Loader

A bash script that automatically finds and activates Python virtual environments in your project directory.

## Overview

The `activate.txt` script is a smart Python environment loader that searches for and activates virtual environments in multiple ways, supporting various Python package managers and virtual environment setups.

## Features

- **Automatic Detection**: Searches for virtual environments in current directory and parent directories
- **Multiple Environment Types**: Supports:
  - Standard virtual environments (`.venv`, `venv`, `env`)
  - Any directory containing `pyvenv.cfg`
  - Poetry environments
  - Pipenv environments
- **Intelligent Search**: Searches up to 5 parent directories from the starting location
- **Safe Activation**: Prevents re-activating already active environments
- **Error Handling**: Provides clear feedback when no environment is found

## Usage

### Basic Usage

```bash
# Source the script to activate the nearest Python environment
source activate.txt
```

### Requirements

The script must be sourced (not executed directly):

```bash
# ✅ Correct
source activate.txt

# ❌ Incorrect
./activate.txt
```

## How It Works

The script follows this search order in each directory:

1. **Standard Names** (priority order):
   - `.venv`
   - `venv`
   - `env`

2. **Any Directory with pyvenv.cfg**:
   - Scans all subdirectories for `pyvenv.cfg`

3. **Poetry Environment**:
   - Checks for `pyproject.toml`
   - Uses `poetry env info -p` to get environment path

4. **Pipenv Environment**:
   - Checks for `Pipfile`
   - Uses `pipenv --venv` to get environment path

The search starts from the current directory and moves up through parent directories (up to 5 levels deep).

## Configuration

You can modify these variables at the top of the script:

- `MAX_PARENT_DEPTH=5`: Maximum number of parent directories to search
- `START_PATH="."`: Starting directory for the search

## Examples

### Standard Virtual Environment

```bash
$ source activate.txt
Activating: /home/user/project/.venv
(.venv) $
```

### Poetry Project

```bash
$ source activate.txt
Activating: /home/user/project/.cache/pypoetry/virtualenvs/project-abc123
(project-abc123) $
```

### No Environment Found

```bash
$ source activate.txt
No Python environment found.
```

## Requirements

- Bash shell
- Python virtual environment (any of the supported types)
- Optional: Poetry or Pipenv for respective environment types

## File Structure

```
project/
├── activate.txt          # This script
├── .venv/               # Standard virtual environment
│   ├── bin/
│   │   └── activate
│   └── pyvenv.cfg
├── pyproject.toml       # For Poetry projects
└── Pipfile             # For Pipenv projects
```

## Error Messages

- **"Please source this script: use 'source script.sh'"**: Script was executed instead of sourced
- **"Invalid start path."**: Starting directory doesn't exist
- **"No Python environment found."**: No compatible environment was found

## Compatibility

- **Shells**: Bash
- **Operating Systems**: Linux, macOS, Windows (WSL)
- **Python Versions**: Any Python version with virtual environment support
- **Package Managers**: Poetry, Pipenv, standard venv

## License

This script is provided as-is for educational and development purposes.
