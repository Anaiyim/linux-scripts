#!/bin/sh

# Systemd script that unmounts all ntfs file systems before hibernating.
# Should be added to the following path:  /usr/lib/systemd/system-sleep/

if [ "${1}" == "pre" ] && [ "${2}" == "hibernate" ]; then
  logger "Unmounting all ntfs file systems"
  lsblk -flp | grep "ntfs-3g" | awk '{if ($5) print $1}' | while read filesystem ; do
    lsof -t $filesystem | while read process; do
      logger "Killing `ps -p $process -o comm=`"
      kill $process
    done
    umount $filesystem
  done
elif [ "${1}" == "post" ]; then
  logger "Resuming from hibernation"
fi
