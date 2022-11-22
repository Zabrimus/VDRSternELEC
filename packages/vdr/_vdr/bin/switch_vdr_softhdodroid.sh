#!/bin/bash

# Use this script to either attach or detach the VDR frontend
# The script takes one parameter 'attach' or 'detach' which can be used to distinguish between the desired command.

# The following sample works only for softhdodroid
# For all other VDR frontend plugins, the script needs to be adapted

if [ "$1" = "attach" ]; then
    /usr/local/bin/svdrpsend REMO on
    /usr/local/bin/svdrpsend PLUG softhdodroid ATTA -a hw:CARD=AMLAUGESOUND,DEV=2
elif [ "$1" = "detach" ]; then
    /usr/local/bin/svdrpsend PLUG softhdodroid DETA
    /usr/local/bin/svdrpsend REMO off
fi
