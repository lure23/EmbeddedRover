# OpenOCD (notes)


You probably should read:

- ESP-IDF Programming Guide > [JTAG](https://docs.espressif.com/projects/esp-idf/en/latest/esp32c3/api-guides/jtag-debugging/index.html)

   It gives a nice overview of debugging on ESP32. Keep in mind that this book has nothing about Rust - it's meant for the usual C/C++ toolchain's users. 

- The Rust on ESP Book > [5.3.2 OpenOCD](https://esp-rs.github.io/book/tooling/debugging/openocd.html)

---

The "ESP-IDF" book mentions OpenOCD [Debug Adapter Hardware](https://openocd.org/doc/html/Debug-Adapter-Hardware.html) list:

>![](.images/openocd-esp32-adapters.png)

..but should we install it as stock `sudo apt install`? It does install.

---

The "Rust on ESP" book mentions an ESP specific fork](https://github.com/espressif/openocd-esp32) that has [releases](https://github.com/espressif/openocd-esp32/releases). 

- [ ] How do I install `openocd` from the `.tar.gz` package?

---

## Stock version doesn't work:

Installed via `sudo apt install`:

```
$ openocd --version
Open On-Chip Debugger 0.11.0
Licensed under GNU GPL v2
For bug reports, read
	http://openocd.org/doc/doxygen/bugs.html
```
	
```
$ sudo ls /usr/share/openocd/scripts/board/es*
ls: cannot access '/usr/share/openocd/scripts/board/es*': No such file or directory
```

= no ESP32 boards are available.


## Forked version:

[`espressif/openocd-esp32`](https://github.com/espressif/openocd-esp32)

This is where I got:

```
$ ~/Temp/openocd-esp32/bin/openocd -f ~/Temp/openocd-esp32/share/openocd/scripts/board/esp32c3-builtin.cfg 
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
/home/ubuntu/Temp/openocd-esp32/bin/../share/openocd/scripts/target/esp_common.cfg:9: Error: 
at file "/home/ubuntu/Temp/openocd-esp32/bin/../share/openocd/scripts/target/esp_common.cfg", line 9
```

