#!/bin/bash
set -e

error() {
  echo "$@" 1>&2
}
fail() {
  error "$@"
  exit 1
}

# Extras
#
# Things not in the 'esp-template' Dockerfile, but are needed for development.

ARCH=$(~/.cargo/bin/rustup show | grep "Default host" | sed -e 's/.* //')
[ -n $ARCH ] || fail "INTERNAL: didn't figure out 'ARCH'"

curl -Ls "https://github.com/cargo-generate/cargo-generate/releases/download/v0.19.0/cargo-generate-v0.19.0-${ARCH}.tar.gz" | \
  tar xzf - -C ~/.cargo/bin/

# $ ls -al ~/.cargo/bin/cargo-generate
# -rwxr-xr-x 1 ubuntu ubuntu 19244256 Dec 14 20:48 /home/ubuntu/.cargo/bin/cargo-generate
#    ^         ^^^^^^

# With this, user sessions will have 'rustc', 'cargo'.
#
echo ". ~/.cargo/env" >> ~/.bashrc

# Projects can override this. If we don't give a default, 'rustc' and 'cargo' commands don't like to start.
~/.cargo/bin/rustup default nightly
