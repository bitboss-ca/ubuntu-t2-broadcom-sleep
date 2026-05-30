#!/usr/bin/env bash
if [ "${1}" = "pre" ]; then

    # 0. Gracefully disconnect devices so they clear their session keys
    PAIRED_DEVICES=$(bluetoothctl devices Paired | awk '{print $2}')
    for dev in $PAIRED_DEVICES; do
        bluetoothctl disconnect "$dev" > /dev/null 2>&1
    done

    # Give the radio 1 second to actually transmit those "Goodbye" packets
    sleep 1

    # 1. Sever the active radio connections
    bluetoothctl power off

    # 2. Stop the background services
    systemctl stop NetworkManager
    systemctl stop bluetooth

    # 3. Give the hardware 2 seconds to completely settle
    sleep 2

    # 4. Safely pull the kernel modules
    modprobe -r hci_bcm4377
    modprobe -r brcmfmac_wcc
    modprobe -r brcmfmac

elif [ "${1}" = "post" ]; then
    # 5. Wait 3 seconds for the PCIe bus to fully wake up from S3 power-loss
    sleep 3

    # 6. Inject the kernel modules
    modprobe brcmfmac
    modprobe hci_bcm4377

    # 7. S3 DYNAMIC WAIT: Actively watch for the radio (timeout after 20 seconds)
    for i in {1..20}; do
        if [ -d "/sys/class/bluetooth/hci0" ]; then
            break
        fi
        sleep 1
    done

    # 8. Ensure the hardware isn't soft-blocked by the kernel
    rfkill unblock all

    # 9. Start the background services
    systemctl restart NetworkManager
    systemctl restart bluetooth
    systemctl restart upower

    # 10. Give the daemon 3 seconds to fully initialize the now-awake controller
    sleep 3

    # 11. Force the radio on so it broadcasts to your mouse
    bluetoothctl power on

    sleep 2

    # 12. Wake up the LE cache and force connections
    timeout 10 bluetoothctl scan on > /dev/null 2>&1

fi
