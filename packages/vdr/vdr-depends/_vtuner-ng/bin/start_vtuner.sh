#/bin/bash

############################################################
# Warning:
#    This is only a sample file.
#    Change this script to match your environment and wishes
############################################################

# create 4 devices
DEVICES=4
SATIP_HOST_1=192.168.178.3
SATIP_HOST_2=192.168.178.3
SATIP_HOST_3=192.168.178.236
SATIP_HOST_4=192.168.178.236

/usr/sbin/modprobe vtunerc devices=${DEVICES}

# create 4 satip processes
/usr/local/bin/satip -s ${SATIP_HOST_1} -d /dev/vtunerc0 -m 2 -l 4 2> /tmp/satip0.log &
/usr/local/bin/satip -s ${SATIP_HOST_2} -d /dev/vtunerc1 -m 2 -l 4 2> /tmp/satip1.log &
/usr/local/bin/satip -s ${SATIP_HOST_3} -d /dev/vtunerc2 -m 2 -l 4 2> /tmp/satip2.log &
/usr/local/bin/satip -s ${SATIP_HOST_4} -d /dev/vtunerc3 -m 2 -l 4 2> /tmp/satip3.log &