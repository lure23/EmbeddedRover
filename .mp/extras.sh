#!/bin/bash

# Extra installs
#
# These are not in the 'esp-template' Dockerfile, but are needed for development.

# tbd. Need this?
#!sudo apt-get -y install build-essential

ARCH=$($HOME/.cargo/bin/rustup show | grep "Default host" | sed -e 's/.* //') \
  curl -Ls "https://github.com/cargo-generate/cargo-generate/releases/download/v0.19.0/cargo-generate-v0.19.0-${ARCH}.tar.gz" | \
    tar xzf - -C "${HOME}/.cargo/bin/"

# $ ls -al ~/.cargo/bin/cargo-generate
# -rwxr-xr-x 1 ubuntu ubuntu 19244256 Dec 14 20:48 /home/ubuntu/.cargo/bin/cargo-generate
#    ^         ^^^^^^

