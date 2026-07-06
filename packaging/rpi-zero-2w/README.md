# Raspberry Pi Zero 2W portable bundle

This builds a portable ARM64 bundle for Raspberry Pi Zero 2W. Docker is only used on the development machine as an ARM64 build environment; Docker is not required on the Pi.

The bundle includes:

- Python 3.13 for ARM64
- `linux-voice-assistant` installed into that Python runtime
- prebuilt ARM64 Python wheels for the project dependencies
- `sounds/` and `wakewords/`
- `install.sh` for Debian runtime packages
- `run.sh` to start the assistant

This avoids compiling Python packages on the Pi. Runtime libraries such as `libmpv2` and `libportaudio2` are still installed through `apt`.
The Pi still needs a working PulseAudio-compatible audio server; `install.sh` installs and tries to start PipeWire/Pulse services for the current user.

## Build on a development machine

```sh
docker buildx build --platform linux/arm64 -f packaging/rpi-zero-2w/Dockerfile.bundle --output type=local,dest=dist/rpi-zero-2w .
```

On Windows PowerShell:

```powershell
.\packaging\rpi-zero-2w\build-portable-bundle.ps1
```

The generated file is:

```text
dist/rpi-zero-2w/linux-voice-assistant-sendspin-arm64-portable.tar.gz
```

## Install on the Pi

Copy the `.tar.gz` to the Pi, then run:

```sh
tar -xzf linux-voice-assistant-sendspin-arm64-portable.tar.gz
cd linux-voice-assistant
./install.sh
```

Start it with:

```sh
./run.sh
```

## Assumptions

- Raspberry Pi OS 64-bit / `aarch64`
- Debian Bookworm-compatible runtime libraries
- A working microphone/speaker setup exposed through PipeWire/PulseAudio

For Raspberry Pi OS 32-bit (`armv7l`), build a separate bundle. Do not use this `aarch64` bundle there.
