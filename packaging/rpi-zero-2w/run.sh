#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

export PATH="$ROOT/python/bin:$PATH"
export LD_LIBRARY_PATH="$ROOT/python/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

if [ -z "${XDG_RUNTIME_DIR:-}" ] && [ -d "/run/user/$(id -u)" ]; then
    export XDG_RUNTIME_DIR="/run/user/$(id -u)"
fi

if command -v systemctl >/dev/null 2>&1 && command -v pactl >/dev/null 2>&1; then
    if ! pactl info >/dev/null 2>&1; then
        systemctl --user start pipewire.service pipewire-pulse.service wireplumber.service >/dev/null 2>&1 || true
    fi
fi

cd "$ROOT/app"
exec "$ROOT/python/bin/python3" -m linux_voice_assistant "$@"
