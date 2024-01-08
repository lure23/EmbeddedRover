#!/bin/bash
set -e

# Preparations for a 'std' Rust setup.
#
# Ideally, we'd have both 'non-std' and 'std' orthogonal, but.. for the sake of brevity, this file OMITS PARTS ALREADY
# COVERED BY NON-STD and thus extends to it.
#
# Based on:
#   - https://github.com/esp-rs/esp-idf-template/blob/master/cargo/.devcontainer/Dockerfile

#--- Root ---

# dependencies
sudo -- sh -c "apt-get install -y \
  gcc xz-utils \
  wget flex bison gperf python3 python3-pip python3-venv cmake ninja-build ccache libffi-dev dfu-util \
  "
  # non-std gives: git curl llvm-dev libclang-dev clang unzip libusb-1.0.0 libssl-dev libudev-dev pkg-config

#--- Normal user ('ubuntu') ---

# Install rustup (same as for 'non-std')
#curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- \
#  --default-toolchain none -y --profile minimal

#. "$HOME/.cargo/env"

# Install extra crates
#
# Note: added '-o' to unzips (overwrite; don't ask)
#
# tbd. If moving elsewhere, use a pipe instead of temporary files.
#
# Note: Crates already covered by 'non-std' are omitted.
#
ARCH=$($HOME/.cargo/bin/rustup show | grep "Default host" | sed -e 's/.* //') && \
  curl -L "https://github.com/esp-rs/embuild/releases/latest/download/ldproxy-${ARCH}.zip" -o "${HOME}/.cargo/bin/ldproxy.zip" && \
  unzip -o "${HOME}/.cargo/bin/ldproxy.zip" -d "${HOME}/.cargo/bin/" && \
  rm "${HOME}/.cargo/bin/ldproxy.zip" && \
  chmod u+x "${HOME}/.cargo/bin/ldproxy"

# Don't need web-flash
#    \
#    curl -L "https://github.com/esp-rs/esp-web-flash-server/releases/latest/download/web-flash-${ARCH}.zip" -o "${HOME}/.cargo/bin/web-flash.zip" && \
#    unzip -o "${HOME}/.cargo/bin/web-flash.zip" -d "${HOME}/.cargo/bin/" && \
#    rm "${HOME}/.cargo/bin/web-flash.zip" && \
#    chmod u+x "${HOME}/.cargo/bin/web-flash"

# Install Xtensa Rust
# (skipped; add here)

# 'rustup default {nightly|esp}' omitted; project specific based on the architecture (we should probably have separate
# VM's for Extensa, if the need ever arises)
#rustup default nightly

# No need for this?  (didn't find one on the disk)
#!echo "source /home/${CONTAINER_USER}/export-esp.sh" >> ~/.bashrc
