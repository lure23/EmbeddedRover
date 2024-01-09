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
# Usage:
#   $ openocd.sh all|chip|chip1,chip2,...
#
# Note: Most of this install is 'esp-idf', Espressif's C/C++ toolchain. The ESP32 specific OpenOCD is installed
#   as part of it. This is slightly long, and consumes considerably more (1..2GB?) disk space than just installing
#   OpenOCD, but it makes sense to do the install the official way.
#
#   Once/if ESP32 chips are part of the "stock" OpenOCD, it can be installed using 'sudo apt install'. :)
#
TARGET=$1

if [ -z "$TARGET" ]; then
  cat >&2 <<EOF1

Usage:

$0 "all"|"esp32c3"|"esp32c2,esp32h"|...

  The target can be "all", an ESP32 chip id (e.g. "esp32c3"), or multiple ids, separated by commas (e.g. "esp32c2,esp32h2").

EOF1
  false
fi

echo -e "\nInstalling ESP-IDF (and OpenOCD) for: $TARGET\n"

#---
# ESP-IDF
#
# The installation is in three pieces:
#   - clone the 'latest' repo
#   - execute 'install.sh' within it
#   - source '~/esp/esp-idf/export.sh' to set your command line environment
#

if [ -d ~/esp/esp-idf ]; then
  read -p "Folder '~/esp/esp-idf' already exists. Overwrite? [Yn]" -n 1 key
  echo ""

  case $key in
    n|N) false ;;
    *) ;;
  esac
  rm -rf ~/esp/esp-idf
fi

#---
# Actual install
#
# See -> https://docs.espressif.com/projects/esp-idf/en/latest/esp32c3/get-started/linux-macos-setup.html
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
(cd ~/esp/esp-idf && \
  ./install.sh $TARGET \
)

#---
# udev rules file:
#   60-openocd.rules to /etc/udev/rules.d
#
# https://docs.espressif.com/projects/esp-idf/en/latest/esp32c3/api-guides/jtag-debugging/configure-builtin-jtag.html#configure-usb-drivers
#
[ -f /etc/udev/rules.d/60-openocd.rules ] || (
  curl -Ls https://github.com/espressif/openocd-esp32/blob/master/contrib/60-openocd.rules | \
    (sudo -- sh -c "cat >/etc/udev/rules.d/60-openocd.rules")
)

#
cat <<EOF
NEXT, DO THIS to see 'openocd' is properly installed:

  . ~/esp/esp-idf/export.sh
  openocd --version

EOF
