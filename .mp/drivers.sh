#!/bin/bash

# Drivers needed for flashing, over USB/IP
#
# tbd.

sudo -- sh -c echo "vhci_hcd" >> /etc/modules-load.d/modules.conf
sudo echo "usbip_core" >> /etc/modules-load.d/modules.conf
