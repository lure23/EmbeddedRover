#!/bin/bash

# Preparations for a 'non-std' Rust setup.
#
# Based on:
#   - https://github.com/esp-rs/esp-template/blob/main/.devcontainer/Dockerfile

#--- Root ---

# dependencies
sudo -- sh -c "apt-get update \
  && apt-get install -y git curl llvm-dev libclang-dev clang unzip \
  libusb-1.0-0 libssl-dev libudev-dev pkg-config \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts \
  "

#--- Normal user ('ubuntu') ---

# Install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- \
  --default-toolchain none -y --profile minimal

# Install extra crates
#
# Note: added '-o' to unzips
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
    chmod u+x "${HOME}/.cargo/bin/espflash" && \
    \
    curl -L "https://github.com/esp-rs/esp-web-flash-server/releases/latest/download/web-flash-${ARCH}.zip" -o "${HOME}/.cargo/bin/web-flash.zip" && \
    unzip -o "${HOME}/.cargo/bin/web-flash.zip" -d "${HOME}/.cargo/bin/" && \
    rm "${HOME}/.cargo/bin/web-flash.zip" && \
    chmod u+x "${HOME}/.cargo/bin/web-flash"

# Install Xtensa Rust
# (skipped; add here)

# Default toolchain:
# - RISC V -> nightly // see -> https://github.com/esp-rs/esp-template/blob/5e2163f97e78acf74e246edd47a2752343f40cad/pre-script.rhai#L70
# - Extensa -> ???
#
rustup default nightly

# tbd. see what that does.
# tbd. Make it idempotent: add only once
#
#!echo "source /home/${CONTAINER_USER}/export-esp.sh" >> ~/.bashrc


