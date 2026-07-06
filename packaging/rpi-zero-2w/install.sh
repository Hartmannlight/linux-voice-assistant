#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

python3 - <<'PY'
import platform

machine = platform.machine()
if machine not in {"aarch64", "arm64"}:
    raise SystemExit(f"This bundle targets Raspberry Pi OS 64-bit/aarch64, not {machine!r}")
PY

if command -v sudo >/dev/null 2>&1; then
    SUDO=sudo
else
    SUDO=
fi

$SUDO apt-get update
$SUDO apt-get install --yes --no-install-recommends \
    avahi-utils \
    alsa-utils \
    pipewire-bin \
    pipewire-alsa \
    pipewire-pulse \
    pulseaudio-utils \
    wireplumber \
    libmpv2 \
    libportaudio2 \
    libasound2-plugins \
    ca-certificates \
    iproute2 \
    procps

chmod +x run.sh

PY_SITE="$(pwd)/python/lib/python3.13/site-packages"
ln -sfn "$(pwd)/app/wakewords" "$PY_SITE/wakewords"
ln -sfn "$(pwd)/app/sounds" "$PY_SITE/sounds"
mkdir -p "$PY_SITE/local"

if command -v systemctl >/dev/null 2>&1; then
    systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service >/dev/null 2>&1 || true
fi

echo
echo "Runtime dependencies installed."
if command -v pactl >/dev/null 2>&1 && ! pactl info >/dev/null 2>&1; then
    echo "Warning: PulseAudio/PipeWire is not responding yet."
    echo "If run.sh fails to start audio, reboot the Pi or start the user audio services:"
    echo "  systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service"
fi
echo "Run with:"
echo "  $(pwd)/run.sh"
