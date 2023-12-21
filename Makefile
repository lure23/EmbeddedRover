#
# Makefile
#
# Requires:
#	- multipass
#

# TODO:
#	- Why doesn't '.cargo/env' get automatically run, by -say- 'make test' (any 'multipass exec')?
#	  It does get run in 'multipass shell'.
#
#	  A: This may be due to use of 'sh -c' (instead of bash?). Likely Ubuntu doesn't make such read the setup files,
#		 so we need to do it manually.
#

_MP_INSTANCE:=b8de3a
	# nothing magic about that name - just use anything that's unique (and starts with a letter)

_MP_SUBFOLDER:=work
	# where current folder is mapped within MP (actual name doesn't matter)

_MP_PARAMS:=--memory 4G --disk 8G --cpus 2
	# Use 'multipass info <instance>' to fine tune these
	#
	# Memory: Rust Rover Remote Debugging requires 4GB; otherwise gives a warning dialog.
	#		Rust itself would be fine with, say, 2GB.
	#
	# Disk:	3.5GB seems to be needed for Rust installation.
	#		Rust Rover Remote Debugging demands "4GB free".
	#		Must be in increments of 512M

_BEAN:=./.rust-is-up.$(_MP_INSTANCE)
	# Marker (in the host file system) that running 'rustup' succeeded in the VM

# Comments used by 'make help':
#HELP
# make prep		Prepares the build VM and prints its IP address.
# make shell	Dive to the build image command prompt.
#
# All targets prepare a Multipass image, if not available. You can remove such instance by 'multipass delete {name} &&
# multipass purge', in case you wish to start again. Otherwise, it's stateful but your project files are kept in the
# 'work' folder, available for both you and the image.
#/HELP

help:
	@echo ""
	@cat $(MAKEFILE_LIST) | sed -n '/^.HELP/,/^.\/HELP/p' | tail -n '+2' | tail -r | tail -n '+2' | tail -r | sed 's/^#//'
	@echo ""

prep: _mp-rustup
	@echo ""
	@echo "Multipass IP ($(_MP_INSTANCE)): $(shell multipass info $(_MP_INSTANCE) | grep IPv4 | cut -w -f 2 )"
	@echo ""
	@multipass exec -n $(_MP_INSTANCE) -- sh -c '. .cargo/env && rustc --version && cargo --version'
	@echo ""

#test: _mp-rustup
#	multipass exec -n $(_MP_INSTANCE) -- sh -c 'whoami && . .cargo/env && rustc --version && cargo --version'

a: $(_BEAN)

# Install toolchain
#
# Note: Keeping this separate from the image (OS level) installation allows for easier update of the Rust toolchain
#		(just remove the '.rust-is-up' marker); also less downloads when developing the Makefile.
#
_mp-rustup: $(_BEAN)

# Note: If '$(_BEAN)' exists, we can trust Multipass image also to be up, so will run the creation only if needing to
#		create the "bean".
#
$(_BEAN): #_mp-image
	@$(MAKE) _mp-image
	@multipass exec --no-map-working-directory $(_MP_INSTANCE) -- sh -c "\
	  (export _A=tmp/_.sh; install -d ./tmp && \
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o \$$_A && \
		chmod +x \$$_A && \
		\$$_A -y \
	  )"
	@touch $@

# Checks that a) 'multipass' exists as a command, b) downloads the Ubuntu image we use.
#
# 	Downloading would happen also automatically, but wanted to make it explicit.
#
_mp-image: _mp-exists
	@(multipass list | grep $(_MP_INSTANCE) > /dev/null) || ( \
      multipass launch lts --name $(_MP_INSTANCE) --mount $(shell pwd):/home/ubuntu/$(_MP_SUBFOLDER) $(_MP_PARAMS) && \
      multipass exec $(_MP_INSTANCE) -- sudo apt-get update \
	)

	@# Note: You may add 'sudo apt-get upgrade' if you wish. Without it, we simply use the latest LTS as-is.
    # multipass exec $(_MP_INSTANCE) -- sudo apt-get upgrade && \
    # multipass exec $(_MP_INSTANCE) -- sudo apt-get install unzip && \

_mp-exists:
	@multipass --version >/dev/null

# Note: 'multipass shell' will always go to the "ubuntu" user (not "build" that we use for SSH)
shell: _mp-image
	multipass shell $(_MP_INSTANCE)

purge:
	@-rm $(_BEAN)
	multipass delete --purge $(_MP_INSTANCE)

#---
echo:
	@echo A

	@# Note: You may add 'sudo apt-get upgrade' if you wish. Without it, we simply use the latest LTS, without updates.
    #  multipass exec $(_MP_INSTANCE) -- sudo apt-get upgrade && \
    # multipass exec $(_MP_INSTANCE) -- sudo apt-get install unzip && \

.PHONY: help prep test _mp-rustup _mp-image _mp-exists shell purge echo
