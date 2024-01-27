#/bin/bash

killall -q -HUP satip
sleep 1
/usr/sbin/modprobe -r vtunerc