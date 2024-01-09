# OpenOCD (notes)

## Pre-read

You probably should read:

- ESP-IDF Programming Guide > [JTAG Debugging](https://docs.espressif.com/projects/esp-idf/en/latest/esp32c3/api-guides/jtag-debugging/index.html)

   >Note: Before you read, PICK THE RIGHT CHIP TYPE from below the Espressif logo (top left).

   Keep in mind that this book has nothing about Rust - it's meant for the usual C/C++ toolchain's users.
   
- The Rust on ESP Book > [5.3.2 OpenOCD](https://esp-rs.github.io/book/tooling/debugging/openocd.html)


## Installing

OpenOCD is installed as part of the ESP-IDF (C/C++ toolchain) installation. We don't do this automatically, for two reasons:

1. Installation requires to know which chip(s) you are intending to target.
2. Rust Rover is not capable of using OpenOCD for debugging, at least not yet (Jan'24).

   >JetBrains CLion uses OpenOCD for embedded debugging, so there's reason to hope Rust Rover will do the same, by the time it is officially released (not preview).


>Note: Before you do this, check that you have at least 2GB free disk space on Multipass VM:
>
>```
>~$ df -h .
>Filesystem      Size  Used Avail Use% Mounted on
>/dev/sda1        12G  9.6G  1.9G  80% /
>```

---


In the below command, replace the chip id with the one(s) you need. See samples [here](https://docs.espressif.com/projects/esp-idf/en/latest/esp32c3/get-started/linux-macos-setup.html#step-3-set-up-the-tools).

```
$ ~/.mp-prime/manual/openocd.sh esp32c3
[...]
```

- installs ESP-IDF
- runs `./install.sh {target(s)}`

```
~$ . ~/esp/esp-idf/export.sh 
Setting IDF_PATH to '/home/ubuntu/esp/esp-idf'
Detecting the Python interpreter
Checking "python3" ...
Python 3.10.12
[...]
Done! You can now compile ESP-IDF projects.
Go to the project directory and run:

  idf.py build
 
```

```
~$ openocd --version
Open On-Chip Debugger v0.12.0-esp32-20230921 (2023-09-21-13:41)
Licensed under GNU GPL v2
For bug reports, read
	http://openocd.org/doc/doxygen/bugs.html
```

YAY!!! OpenOCD is properly installed!

>Note that we even added `/etc/udev/rules.d/60-openocd.rules` file, as [mentioned here](https://docs.espressif.com/projects/esp-idf/en/latest/esp32c3/api-guides/jtag-debugging/configure-builtin-jtag.html#configure-usb-drivers).
>
>This may have asked you for `sudo` rights.

<!-- #whisper
Weird that that's not automatically done by `install.sh`.
-->

<!-- #wsl
>Note: If you are trying any of this on WSL, be aware that:
>
> `udev` needs to be restarted after rule changes (notify doesn't work there). See https://unix.stackexchange.com/questions/39370/how-to-reload-udev-rules-without-reboot
> 
>```
>$ (sudo -- sh -c "udevadm control --reload-rules && udevadm trigger")
>```
>
> You may also need in `/etc/wsl.conf`:
>```
>[boot]
>command="service udev start"
>```
-->

## Trying out!!!

```
~$ openocd -f board/esp32c3-builtin.cfg
Open On-Chip Debugger v0.12.0-esp32-20230921 (2023-09-21-13:41)
Licensed under GNU GPL v2
For bug reports, read
	http://openocd.org/doc/doxygen/bugs.html
Info : only one transport option; autoselecting 'jtag'
Info : esp_usb_jtag: VID set to 0x303a and PID to 0x1001
Info : esp_usb_jtag: capabilities descriptor set to 0x2000
Info : Listening on port 6666 for tcl connections
Info : Listening on port 4444 for telnet connections
Error: esp_usb_jtag: could not find or open device!
/home/ubuntu/.espressif/tools/openocd-esp32/v0.12.0-esp32-20230921/openocd-esp32/share/openocd/scripts/target/esp_common.cfg:9: Error: 
at file "/home/ubuntu/.espressif/tools/openocd-esp32/v0.12.0-esp32-20230921/openocd-esp32/share/openocd/scripts/target/esp_common.cfg", line 9
```

⛔️ That's obviously not the way it was supposed to go.


- [ ] Let's see if Windows (where our device is) needs some driver
- [ ] Report to us, and Espressif OpenOCD Issues.

`flat-tire-emoji..`


