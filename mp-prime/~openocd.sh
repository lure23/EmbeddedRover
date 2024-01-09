#!/bin/bash
set -e

error() {
  echo "$@" 1>&2
}
fail() {
  error "$@"
  exit 1
}

# OpenOCD
#
# Note: It's still unsure, whether Rust Rover will support this in the end. If it does, these commands can be moved
#     to the 'extras.sh' (or whichever is the one place having all preparations).
#
# ESP-IDF Programming Guide:
#   "If you have already set up ESP-IDF with CMake build system according to the Getting Started Guide, then OpenOCD is already installed."
#
# i.e. we must install ESP-IDF (C/C++ framework), first. There are ESP32 specific forks of:
#   - http://github.com/espressif/binutils-gdb
#   - http://github.com/espressif/openocd-esp32
#
#   ..presumably these are baked into the ESP-IDF installation (otherwise, you get releases with .tar.gz of the bin,
#   libs, shared etc.). Installing them to '/usr/local' would be the other option, but ... there's no documentation
#   in that trail.
#
# References:
#   - ESP-IDF Programming Guide > JTAG Debugging > Setup of OpenOCD
#     -> https://docs.espressif.com/projects/esp-idf/en/latest/esp32c3/api-guides/jtag-debugging/index.html#setup-of-openocd
#

ARCH=$(~/.cargo/bin/rustup show | grep "Default host" | sed -e 's/.* //')
[ -n $ARCH ] || fail "INTERNAL: didn't figure out 'ARCH'"

# ARCH: x86_64-unknown-linux-gnu


#--- ESP-IDF
#
# https://docs.espressif.com/projects/esp-idf/en/latest/esp32c3/get-started/linux-macos-setup.html
#
sudo apt-get install \
  git wget flex bison gperf python3 python3-pip python3-venv cmake ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0

install -d ~/esp
(cd ~/esp && \
  git clone --depth 1 --recursive --shallow-submodules https://github.com/espressif/esp-idf.git && \
  rm -rf esp-idf/.git \
)
  # '--depth 1', '--shallow-submodules' and removing '.git' added by the author
  # Note: '~/esp/.git' is 110MB (when cloned as shallow; otherwise >600MB)

# Installing tools for SOME ESP32 chips.
#
# NOTE!!! You must do this manually for the actual chip you use!!
#
(cd ~/esp/esp-idf && \
  ./install.sh esp32c3 \
)




curl -Ls "https://github.com/espressif/binutils-gdb/releases/download/esp-gdb-v12.1_20231023/riscv32-esp-elf-gdb-12.1_20231023-${ARCH/-unknown/}.tar.gz" | \
  tar xzf - -C ~/Temp/
  # Note: 'rustup show' 'ARCH' would be: 'x86_64-unknown-linux-gnu'; ..but 'binutils-gdb' releases don't have such. Thus, gutting out '-unknown'.

exit 1
# The output is - how to "install" this?
#
#   └── riscv32-esp-elf-gdb
#       ├── bin
#          ├── riscv32-esp-elf-gdb
#          ├── riscv32-esp-elf-gdb-3.10
#          ├── riscv32-esp-elf-gdb-3.11
#          ├── riscv32-esp-elf-gdb-3.12
#          ├── riscv32-esp-elf-gdb-3.6
#          ├── riscv32-esp-elf-gdb-3.7
#          ├── riscv32-esp-elf-gdb-3.8
#          ├── riscv32-esp-elf-gdb-3.9
#          ├── riscv32-esp-elf-gdb-add-index
#          ├── riscv32-esp-elf-gdb-no-python
#          └── riscv32-esp-elf-gprof
#       ├── include
#       │  └── gdb
#       │       └── jit-reader.h
#       └── share
#           ├── gdb
#           ...

#--- OpenOCD
#
# Q: does it need specific 'binutils-gdb', too?
#
# Release URL be like:
#     https://github.com/espressif/openocd-esp32/releases/download/v0.12.0-esp32-20230921/openocd-esp32-linux-amd64-0.12.0-esp32-20230921.tar.gz

# tbd. "linux-amd64" fixed. There's also "linux-arm64" available.
#
curl -Ls "https://github.com/espressif/openocd-esp32/releases/download/v0.12.0-esp32-20230921/openocd-esp32-linux-amd64-0.12.0-esp32-20230921.tar.gz" | \
  tar xzf - -C ~/Temp/

# {target}/openocd-esp32/
# ├── bin
# │   └── openocd
# └── share
#     ├── info
#     │   ├── openocd.info
#     │   ├── openocd.info-1
#     │   └── openocd.info-2
#     ├── man
#     │   └── man1
#     │       └── openocd.1
#     └── openocd
#         ├── OpenULINK
#         ⋮
