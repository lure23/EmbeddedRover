#!/bin/bash
set -e

#
# Usage:
#   $ [MP_NAME=xxx] [MP_PARAMS=...] ./prep.sh
#
# Requires:
#   - multipass
#
# Creates a Multipass VM, to be used for embedded Rust development.
#
# Note: Rust Rover remote development parts are not installed here (they could, but it's a changing target since in
#     preview). AK/5-Jan-24
#

# Provide defaults
#
MP_NAME=${MP_NAME:-embedded-rover}
MP_PARAMS=${MP_PARAMS:---memory 6G --disk 14G --cpus 2}
  #
  # Note: Embedded Rust remote development claims to need 8 GB of RAM, 4 cores.[1] We don't quite match those.
  #     [1]:  RustRover docs > Remote Development > System Requirements > Minimal Requirements
  #           https://www.jetbrains.com/help/rust/prerequisites.html#min_requirements
  #
	# Memory: Rust Rover Remote Debugging requires 4GB; otherwise gives a warning dialog.
	#
	# Disk:	3.5GB seems to be needed for Rust installation.
	#   ESP32 toolchain needs quite a lot.
	#   PLENTY for RustRover remote development
	#		Must be in increments of 512M
	#
	# Hint: Use 'multipass info' on the host to observe actual usage.
	#     RustRover also has a stats display in its remote development UI.

# If the VM is already running, decline to create. Helps us keep things simple: all initialization ever runs just once
# (automatically).
#
(multipass info $MP_NAME 2>/dev/null) && {
  echo "";
  echo "The VM '${MP_NAME}' is already running. This script only creates a new instance.";
  echo "Please change the 'MP_NAME' or 'multipass delete --purge' the earlier instance.";
  echo "";
  exit 2
} >&2

# Launch and prime
#
multipass launch lts --name $MP_NAME $MP_PARAMS --mount ./mp-prime:/home/ubuntu/.mp-prime

multipass exec $MP_NAME -- sudo sh -c "apt update && apt -y upgrade"
multipass exec $MP_NAME -- sh -c ". ~/.mp-prime/esp-template.sh"
multipass exec $MP_NAME -- sh -c ". ~/.mp-prime/drivers.sh"
multipass exec $MP_NAME -- sh -c ". ~/.mp-prime/extras.sh"

echo ""
echo "Multipass IP ($MP_NAME): $(multipass info $MP_NAME | grep IPv4 | cut -w -f 2 )"
echo ""
multipass exec -n $MP_NAME -- sh -c '. .cargo/env && rustc --version && cargo --version'
echo ""
