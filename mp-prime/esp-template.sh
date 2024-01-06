#!/bin/bash
set -e

# Preparations for a 'non-std' Rust setup.
#
# Based on:
#   - https://github.com/esp-rs/esp-template/blob/main/.devcontainer/Dockerfile

#--- Root ---

# dependencies
sudo -- sh -c "apt-get install -y git curl llvm-dev libclang-dev clang unzip libusb-1.0-0 libssl-dev libudev-dev pkg-config \
    build-essential \
  "
  # Modified: "apt-get update" done above
  #   Cleaning the cache removed - we actually _want_ (= need!!) e.g. 'linux-modules-extra-*' to remain available!
  # Added: 'build-essential'

#
#--- Normal user ('ubuntu') ---

# Install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- \
  --default-toolchain none -y --profile minimal

. "$HOME/.cargo/env"
rustup --version

# Install extra crates
#
# Note: added '-o' to unzips (overwrite; don't ask)
#
# tbd. If moving elsewhere, use a pipe instead of temporary files.
#
ARCH=$($HOME/.cargo/bin/rustup show | grep "Default host" | sed -e 's/.* //') && \
    curl -L "https://github.com/esp-rs/espup/releases/latest/download/espup-${ARCH}" -o "${HOME}/.cargo/bin/espup" && \
    chmod u+x "${HOME}/.cargo/bin/espup" && \
    \
    curl -L "https://github.com/esp-rs/espflash/releases/latest/download/cargo-espflash-${ARCH}.zip" -o "${HOME}/.cargo/bin/cargo-espflash.zip" && \
    unzip -o "${HOME}/.cargo/bin/cargo-espflash.zip" -d "${HOME}/.cargo/bin/" && \
    rm "${HOME}/.cargo/bin/cargo-espflash.zip" && \
    chmod u+x "${HOME}/.cargo/bin/cargo-espflash" && \
    \
    curl -L "https://github.com/esp-rs/espflash/releases/latest/download/espflash-${ARCH}.zip" -o "${HOME}/.cargo/bin/espflash.zip" && \
    unzip -o "${HOME}/.cargo/bin/espflash.zip" -d "${HOME}/.cargo/bin/" && \
    rm "${HOME}/.cargo/bin/espflash.zip" && \
    chmod u+x "${HOME}/.cargo/bin/espflash"

# Don't need web-flash
#    \
#    curl -L "https://github.com/esp-rs/esp-web-flash-server/releases/latest/download/web-flash-${ARCH}.zip" -o "${HOME}/.cargo/bin/web-flash.zip" && \
#    unzip -o "${HOME}/.cargo/bin/web-flash.zip" -d "${HOME}/.cargo/bin/" && \
#    rm "${HOME}/.cargo/bin/web-flash.zip" && \
#    chmod u+x "${HOME}/.cargo/bin/web-flash"

# Install Xtensa Rust
# (skipped; add here)

# tbd. see what that does.
# tbd. Make it idempotent: add only once
#
#!echo "source /home/${CONTAINER_USER}/export-esp.sh" >> ~/.bashrc


