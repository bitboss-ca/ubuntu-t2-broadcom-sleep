# Ubuntu T2 Broadcom Sleep

This is a script for Ubuntu on T2 Macs to correctly handle T2 hardware when entering and leaving sleep states.  This script is a work in progress, but so far it handles wifi and bluetooth pretty well, which prevents constant reboots to revive those key system components.  This has only been tested on a MacbookAir9,1 so far.

## Installation

Download `ubuntu-t2-broadcom-sleep.sh` and copy it to the sleep script location, and mark it as executable.

```bash
sudo cp ubuntu-t2-broadcom-sleep.sh /usr/lib/systemd/system-sleep/ubuntu-t2-broadcom-sleep.sh
sudo chmod +x /usr/lib/systemd/system-sleep/ubuntu-t2-broadcom-sleep.sh
```

## Support My Work

Did this work for you? [Buy me a coffee](https://buymeacoffee.com/bitboss.ca)!
