#!/usr/bin/env bash

# ==========================
# Smart Python Env Loader
# ==========================

MAX_PARENT_DEPTH=5
START_PATH="."

# ---- helpers ----

resolve_path() {
    (cd "$1" 2>/dev/null && pwd)
}

is_venv() {
    [ -f "$1/bin/activate" ] && [ -f "$1/pyvenv.cfg" ]
}

activate_env() {
    if [ "$VIRTUAL_ENV" = "$1" ]; then
        return 0
    fi

    if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
        echo "❌ Please source this script: use 'source script.sh'"
        exit 1
    fi

    echo "Activating: $1"
    source "$1/bin/activate"
}



# ---- main search ----

search_dir="$(resolve_path "$START_PATH")"

if [ -z "$search_dir" ]; then
    echo "Invalid start path."
    return 1 2>/dev/null || exit 1
fi

for (( i=0; i<=MAX_PARENT_DEPTH; i++ )); do

    # 1️⃣ Standard names (priority order)
    for name in ".venv" "venv" "env"; do
        candidate="$search_dir/$name"
        if is_venv "$candidate"; then
            activate_env "$candidate"
            return 0 2>/dev/null || exit 0
        fi
    done

    # 2️⃣ Any directory containing pyvenv.cfg
    for dir in "$search_dir"/*; do
        [ -d "$dir" ] || continue
        if is_venv "$dir"; then
            activate_env "$dir"
            return 0 2>/dev/null || exit 0
        fi
    done

    # 3️⃣ Poetry
    if command -v poetry >/dev/null 2>&1; then
        if [ -f "$search_dir/pyproject.toml" ]; then
            env_path=$(poetry env info -p 2>/dev/null)
            if [ -n "$env_path" ] && [ -f "$env_path/bin/activate" ]; then
                activate_env "$env_path"
                return 0 2>/dev/null || exit 0
            fi
        fi
    fi

    # 4️⃣ Pipenv
    if command -v pipenv >/dev/null 2>&1; then
        if [ -f "$search_dir/Pipfile" ]; then
            env_path=$(pipenv --venv 2>/dev/null)
            if [ -n "$env_path" ] && [ -f "$env_path/bin/activate" ]; then
                activate_env "$env_path"
                return 0 2>/dev/null || exit 0
            fi
        fi
    fi

    parent=$(dirname "$search_dir")
    [ "$parent" = "$search_dir" ] && break
    search_dir="$parent"
done

echo "No Python environment found."
return 1 2>/dev/null || exit 1
