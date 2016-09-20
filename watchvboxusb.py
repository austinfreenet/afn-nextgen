#!/usr/bin/env python
import sys
import logging
import re
import subprocess
import time

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


def get_usb_devices():
    out = subprocess.check_output(['VBoxManage', 'list', 'usbhost'])
    lines = out.splitlines()
    assert lines[0] == "Host USB Devices:"
    devices = {}
    device = {}
    for line in lines[2:]:
        match = re.match(r"^([^:]+):\s*(.*)$", line)
        if match is None:
            devices[device['UUID']] = device
            device = {}
        else:
            key = match.group(1)
            value = match.group(2)
            device[key] = value
    return devices


def exclude_devices(devices, exclude_regexes):
    devices_to_keep = []
    for uuid, device in devices.items():
        logger.debug("checking %r for exclusion", device)
        match = False
        for regex in exclude_regexes:
            if re.search(regex, device['Product'], re.IGNORECASE):
                logger.debug("%r matches %r so it's excluded", device, regex)
                match = True
                break
        if not match:
            devices_to_keep.append((uuid, device)) 
    return dict(devices_to_keep) 


def attach_device_to_guest(device):
    """Device can either be a UUID or a devict dict"""
    try:
        uuid = device['UUID']
    except TypeError:
        uuid = device
    try:
        subprocess.check_output(['VBoxManage', 'controlvm', 'Windows 7', 'usbattach', uuid], stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError, e:
        if e.returncode == 1 and "already captured by the virtual machine" in e.output:
            logger.warn("%s was already captured", device)
        

def main(argv=None):
    if argv is None:
        argv = sys.argv
    logging.basicConfig()
    exclude = ['keyboard', 'mouse']
    logger.debug("exclude: %r", exclude)
    previous_uuids_to_watch = set()
    logger.info("watching for new USB devices")
    while True:
        devices = get_usb_devices()
        logger.debug("devices: %r", devices)
        devices_to_watch = exclude_devices(devices, exclude)
        logger.debug("devices_to_watch: %r", devices_to_watch)
        uuids_to_watch = set(devices_to_watch.keys())
        logger.debug("uuids_to_watch: %r", uuids_to_watch)
        new_uuids = uuids_to_watch - previous_uuids_to_watch
        logger.debug("new_uuids: %r", new_uuids)
        for uuid in new_uuids:
            logger.info("attaching %s to guest", uuid)
            attach_device_to_guest(uuid)
        old_uuids = previous_uuids_to_watch - uuids_to_watch
        for uuid in old_uuids:
            logger.info("uuid %s went away", uuid)
        logger.debug("old_uuids: %r", old_uuids)
        previous_uuids_to_watch = uuids_to_watch
        time.sleep(3)

if __name__ == '__main__':
    sys.exit(main())
