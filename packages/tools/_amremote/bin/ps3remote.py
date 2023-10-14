#!/usr/bin/env /usr/bin/python3
#
# vim: set fileencoding=utf-8
# Copyright (C) 2018 Alexander Grothe
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

import asyncio
import grp
import os
import pwd
import sys
from argparse import ArgumentParser

sys.path.append(r'/usr/lib/python')

from evdev import UInput, InputDevice, ecodes, categorize

def drop_privileges(uid_name, gid_name):
    """drop provileges, run as given user and group if program is running as root"""
    # https://stackoverflow.com/questions/2699907/dropping-root-permissions-in-python

    if os.getuid() != 0:
        return

    running_uid = pwd.getpwnam(uid_name).pw_uid
    running_gid = grp.getgrnam(gid_name).gr_gid

    os.setgroups([])
    os.setgid(running_gid)
    os.setuid(running_uid)
    os.umask(0o77)

class EventTranslator():
    """read events from an input device and process them for the output device"""
    # pylint: disable=too-many-instance-attributes
    ts = 0
    active_key = None

    def __init__(self, eventloop, options):
        self.lock = asyncio.Lock()
        self.loop = eventloop
        self.options = options
        self.repeat = options.repeat / 1000
        self.inputdevice = InputDevice(options.inputdevice)
        self.outputdevice = UInput.from_device(self.inputdevice, name=options.name)
        try:
            self.inputdevice.grab()
        except IOError:
            print("could not grab input device", file=sys.stderr)

    async def read_input(self):
        """read input events in an endless loop and write to output device"""
        try:
            async for raw_event in self.inputdevice.async_read_loop():
                if raw_event.type == ecodes.EV_KEY:
                    event = categorize(raw_event)
                    async with self.lock:
                        if event.keystate == event.key_down:
                            self.active_key = event.scancode
                        elif event.keystate == event.key_up:
                            self.active_key = None

                        self.outputdevice.write(ecodes.EV_KEY, event.scancode, event.keystate)
                        self.outputdevice.syn()
                        self.ts = self.loop.time()
        except (KeyboardInterrupt, asyncio.CancelledError, OSError):
            if self.active_key:
                self.active_key = None
                self.outputdevice.write(ecodes.EV_KEY, self.active_key, 0)
                self.outputdevice.syn()
            sys.exit()

    async def key_repeat(self):
        """send periodic key repeat events"""
        try:
            while True:
                async with self.lock:
                    if self.active_key is not None:
                        delta = self.loop.time() - self.ts
                        if delta > self.repeat: # skip repeat if last keypress was too recent
                            self.outputdevice.write(ecodes.EV_KEY, self.active_key, 2)
                            self.outputdevice.syn()
                            self.ts = self.loop.time()
                await asyncio.sleep(self.repeat)
        except (KeyboardInterrupt, asyncio.CancelledError):
            if self.active_key:
                self.outputdevice.write(ecodes.EV_KEY, self.active_key, 0)
                self.outputdevice.syn()
            sys.exit() 
def parse_args():
    """parse command line arguments"""
    parser = ArgumentParser()
    parser.add_argument(
        "-s", "--socket", dest="inputdevice", default=None,
        help="choose devinput socket to listen on", metavar="SOCKET")
    parser.add_argument(
        "-r", "--repeat", dest="repeat", default=150, type=int,
        help="wait -r <milliseconds> before sending repeated keystrokes",
        metavar="REPEAT")
    parser.add_argument(
        "-n", "--name", dest="name", default="PS3 Remote",
        help="name of uinput device", metavar="NAME")
    parser.add_argument(
        "-u", "--user", dest="user", default="nobody",
        help="drop to USER")
    parser.add_argument(
        "-g", "--group", dest="group", default="nogroup",
        help="drop to GROUP")
    return parser.parse_args()

def main():
    options = parse_args()
    loop = asyncio.get_event_loop()
    event_translator = EventTranslator(loop, options)
    drop_privileges(options.user, options.group)
    try:
        loop.create_task(event_translator.read_input())
        loop.create_task(event_translator.key_repeat())
        loop.run_forever()
    except (asyncio.CancelledError, KeyboardInterrupt):
        sys.exit()

if __name__ == '__main__':
    main()
