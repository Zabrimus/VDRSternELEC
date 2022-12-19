# What is VDR*ELEC?
VDR*ELEC is a collection of scripts and patches, which add a VDR client and many VDR plugins to [CoreELEC (CE)](https://github.com/CoreELEC/CoreELEC) and [LibreELEC (LE)](https://github.com/LibreELEC/LibreELEC.tv) images. 
The images include a full-featured CoreELEC or LibreELEC distribution, where it's possible to comfortably switch between KODI and VDR.

> **Disclaimer:** Not all images are tested and there is no guarantee at all, that the VDR client on these images is working as expected. Possible reasons are missing or misconfigured VDR output devices and plugins.  
> Therefore tests and/or pull requests are highly appreciated.

## Directory structure of this repository

:file_folder: **CoreELEC** - CoreELEC's build directory included as git submodule  
:file_folder: **LibreELEC** - LibreELEC's build directory included as git submodule  
:file_folder: **config**  
    + :file_folder: **distro** - includes predefined build configurations  
    + **addons.list** - lists all available pre-buildable KODI addons  
    + **extras.list** - lists all available extras (patches, plugins)  
:file_folder: **package_patches** - these patches are copied to LE/CE packages folders before build  
:file_folder: **packages** - packages, that will be added to upstream CE/LE  
:file_folder: **patches** - these patches are applied to CE/LE directory itself before build  

## Current status of VDR and plugins:
The following patches are already applied to VDR
```
svdrp_lstc_lcn.patch
vdr-2.3.9-hide-first-recording-level-v2.patch
vdr-2.4.0_zapcockpit-v2.patch
vdr-2.6.1-undelete.patch
vdr-menuorg-2.3.x.patch
vdr-2.6.1-fix-check-still-recording-02.patch
vdr-2.6.1-fix-svdrp-poll-timers-timeout.patch
```

[These plugins](packages/vdr) are successfully built and part of the VDR tar.

# Get an image file
You can choose between downloading a prebuilt image like the official CE/LE ones or building a customized image on your own.

## Prebuilt images
The eaysiest way is to use a prebuilt image. These images are periodically available in the [releases](https://github.com/Zabrimus/VDRSternELEC/releases) section of this repository. Choose the image matching your hardware and write it to SD-Card or USB. You can also use these images as an update image for your existing CE/LE installation.

## Manual build
*Refer to [LibreELEC](https://wiki.libreelec.tv/development-1/build-basics) or [CoreELEC](https://wiki.coreelec.org/coreelec:build_ce) building dependencies.  
The following description is based on Debian or Ubuntu as the host system.*
### Install all dependencies
```
apt-get install gcc make git unzip wget xz-utils bc gperf zip g++ xfonts-utils xsltproc openjdk-11-jre-headless
```
### Checkout VDR*ELEC
```
git clone https://github.com/Zabrimus/VDRSternELEC
```
### Configure the build process
#### Config file/ Environment variables
The configuration is mainly done via environment variables.  
Several configurations are already provided in [config/distro](config/distro). If you don't want to use an existing configuration, you can create a new one within this directory.

A sample configuration file looks like this:
```
# one of BRANCH, TAG or REVISION is mandatory
DISTRO=CoreELEC
BRANCH=coreelec-20
TAG=
REVISION=

# Use project variant
VARIANT=

# Build settings
PROJECT=Amlogic-ce
DEVICE=Amlogic-ng
ARCH=arm

# VDR settings
VDR_OUTPUTDEVICE=softhdodroid
VDR_INPUTDEVICE=satip
```
**Environment variables:**
- DISTRO: can be either ```CoreELEC``` or ```LibreELEC```
- BRANCH: The existing branch to use  
or  
- TAG: use a git tag to build  
or  
- REVISION: you can build with a specific revision.
- VARIANT: specify some variant of the project, e.g. for choosing different patches
- PROJECT: 
  - CoreELEC: ```Amlogic-ce```
  - LibreELEC: ```Allwinner``` or another supported PROJECT for LibreELEC
- DEVICE: 
  - CoreELEC: ```Amlogic-ng```
  - LibreELEC: ```H6``` or another supported DEVICE for LibreELEC.
- ARCH: 
  - CoreELEC: ```arm```
  - LibreELEC: ```arm``` or another supported ARCH for LibreELEC
- VDR_OUTPUTDEVICE: VDR output device, which is enabled by default, e.g. ```softhdodroid```, ```softhddevice-drm```, ```softhddevice-drm-gles``` or another one from the [available packages](packages/vdr)
- VDR_INPUTDEVICE: VDR input device, which is enabled by default, e.g. ```satip``` or ```streamdev-client```

#### Addons
It's possible to build some KODI addons and pre-install them to the image. All available addons are listed in [addons.list](config/addons.list).  
Building the addons with ```build.sh``` can be triggered by adding them with the ```-addon``` option and a comma separated list.

*Probably not all addons can be compiled for LibreELEC/master. Mainly dvb-latest and crazycat are candidates to fail, because of the frequently updated linux kernel.*

#### Extras
It's also possible to build some additional plugins or apply some patches on VDR during build process. All available extras are listed in [extras.list](config/extras.list).  
Building the extras with ```build.sh``` can be triggered by adding them with the ```-extra``` option and a comma separated list.

### Building the image
After choosing an existing configuration or creating a new one, the build script can be called:
```
$ ./build.sh
Usage: ./build.sh -config <name> [-extras <name,name> -addon <name,name>]
-config : Build the distribution defined in directory config/distro/<name>
-extra  : Build additional plugins / Use optional VDR patches / Use extra from config/extras.list
          (option is followed by a comma-separated list of the available extras below)
-addon  : Build additional addons which will be pre-installed / Use addon from config/addons.list
          (option is followed by a comma-separated list of the available addons below)
-help   : Show this help

Available configs:
CoreELEC-19                   LibreELEC-master-aarch64                LibreELEC-master-arm-Allwinner-R40
CoreELEC-19.4-Matrix          LibreELEC-master-arm-Allwinner-A64      LibreELEC-master-arm-AMLGX
CoreELEC-20                   LibreELEC-master-arm-Allwinner-H2-plus  LibreELEC-master-arm-Rockchip-RK3399
LibreELEC-10.0-aarch64-AMLGX  LibreELEC-master-arm-Allwinner-H3       LibreELEC-master-x86_64-x11
LibreELEC-10.0-arm-AMLGX      LibreELEC-master-arm-Allwinner-H5       LibreELEC-master-x86_64-x11-qemu
LibreELEC-10.0-x86_64         LibreELEC-master-arm-Allwinner-H6

Available extras:
directfb
directfbsamples
dynamite
easyvdr
permashift

Available addons:
crazycat
digital-devices
dvb-latest
dvb-tools
ffmpeg-tools
network-tools
sundtek-mediatv
system-tools
```
Example call:  ```./build.sh -config CoreELEC-19 -extra easyvdr```  

If everything worked fine, the desired images can be found in either  ```CoreELEC/target``` or ```LibreELEC/target```.

# Creating bootable media
Write your image file to an SD-Card like you are used to do it with [LibreELEC](https://wiki.libreelec.tv/installation/create-media) or [CoreELEC](https://wiki.coreelec.org/coreelec:bootmedia#step_2) and boot your device.

# Post-installation work
## First boot
The first boot will come up with KODI gui. Follow the dialog and choose your language and network settings. It's very helpful to enable ssh service, to be able to access the device from outside. You also want to set your time/timezone in the KODI settings now. This would also be the time, which is used in VDR afterwards.

## Install KODI addons
This would be a good time to install the KODI addons of your choice. E.g. ```system-tools addon``` (if not pre-installed) can be very helpful, because it makes mc available on the device. In order to be able to get the right language within VDR you should also install the ```locale addon``` (if not pre-installed) and configure the addon with your desired language (e.g. de_DE).

## Directory structure
- ```/usr/local/lib```  
  contains libraries which are usually not part of CoreELEC/ LibreELEC
- ```/usr/local/vdr```  
  contains VDR and all plugins
- ```/storage/.config/vdropt/```  
  contains the default configuration files  
- ```/storage/.config/vdropt-sample```  
  contains sample configuration files
- ```/storage/videos```  
  is the default video directory

## Install script
Now it's time to run the install script ```/usr/local/bin/install.sh``` from within the console (e.g. via ssh):
```
# /usr/local/bin/install.sh
Usage: /usr/local/bin/install.sh [-install-config] [-boot kodi|vdr]

-i      : Extracts the default configuration into directory /storage/.config/vdropt-sample and copy the sample folder to /storage/.config/vdropt if it does not exists.
-C      : Use with care! All configuration entries of vdropt will be copied to vdropt-sample. And then all entries of vdropt-sample will be copied to vdropt.
-b kodi : Kodi will be started after booting
-b vdr  : VDR will be started after booting
-T      : install all necessary files and samples for triggerhappy (A lightweight hotkey daemon)
```
If you are at the first boot, the minimum you have to do is running the script with the ```-i``` option, which will copy the default configuration to the right place. If you also want, that VDR will start as default, these are the commands of your choice:
```
/usr/local/bin/install.sh -i
/usr/local/bin/install.sh -b vdr
```

## Configuration
### Language settings
To be able to use the configured language within VDR you have to create/modify file /storage/.profile with (e.g. for german UTF-8):  
```
export LANG="de_DE.UTF-8"
export LC_ALL="de_DE.UTF-8“
```
Choose the values depending on your choice in KODI's locale addon (*de_DE is de_DE.UTF-8*).  
:exclamation: **You need to create ```/storage/.profile```, otherwise VDR won't start!**

### Fast switch between Kodi and VDR
You can add the following into ```/storage/.profile```   
```
SWITCH_VDR_SCRIPT=<script to attach/detach the VDR frontend>
```
A sample script for CoreELEC and softhodroid exists in ```/usr/local/bin/switch_vdr_softhdodroid.sh``` which can be used like
```
SWITCH_VDR_SCRIPT=/usr/local/bin/switch_vdr_softhdodroid.sh
```
The script takes one parameter 'attach' or 'detach' which can be used to distinguish between the desired actions.
A attach/detach of the VDR frontend is much faster than starting/stopping VDR. VDR itself will run still in the background.

:exclamation: If you update from a previous version of VDR*ELEC you have to modify a systemd script:
```
sed -i "/Conflicts/d" /storage/.config/system.d/vdropt.service
systemctl daemon-reload
```

### Remote control
LibreELEC and CoreELEC use kernel built-in remote support as default. See [LibreELEC - Infra-Red Remotes](https://wiki.libreelec.tv/configuration/ir-remotes). If your remote control does not work out of the box in KODI, you can follow the instructions there.

### Enabled plugins
```/storage/.config/vdropt/enabled_plugins``` contains a list of the plugins to autostart with VDR. Simply edit the file and add other plugins of your choice to the already pre-activated ones. 

### VDR specific configuration
After basic configuration is done you probably need to adapt VDR's conf files.  
VDR configuration is located in ```/storage/.config/vdropt```. The ```channels.conf``` and the other files need to be edited according to your needs.

# Reboot
Once configuration is completed, your device should start into VDR after a reboot.

# Updating
Do an update with the image file like you are used to do it with [LibreELEC](https://wiki.libreelec.tv/support/update) or [CoreELEC](https://discourse.coreelec.org/t/how-to-update-coreelec/1037).  

Example for getting your image onto the device with scp:
```
scp target/CoreELEC-Amlogic-ng.arm-*.tar root@<ip address>:/storage/.update
reboot
```

# Several notes and additional hints
## Skindesigner repository
Skindesigner uses a git repository to install custom skins. To be able to use this feature installing git is necessary.
- Install entware (see https://wiki.coreelec.org/coreelec:entware)
- Install git and git-http
  ```opgk install git git-http```

## Use FLIRC
Configuration of FLIRC, VDR remote.conf and KODI keymapping is up to the user. 
I only describe my configuration.

Create the following ```/storage/.config/udev.rules.d/flirc-receiver.rules``` with following content
```
# FLIRC receiver
ENV{ID_VENDOR_ID}=="20a0", ENV{ID_MODEL_ID}=="0006", \
  ENV{eventlircd_enable}="true", \
  ENV{eventlircd_evmap}="default.evmap"
```
After a reboot the flirc receiver is recognized by eventlircd and usable. 
You can choose another evmap instead of ```default.evmap```, but the map must exists in directory ```/etc/eventlircd.d/```.
I haven't found a solution to easily add a new configurable evmap.

## triggerhappy
triggerhappy is a lightweight hotkey daemon similar to Autohotkey (Windows) or hotkey (Linux with X), but which
works without X or any other desktop environment.
I personally use this daemon to shutdown my box by pressing a specific key on the keyboard (or a configured key in FLIRC).

To enable triggerhappy use the install script
```
/usr/local/bin/install.sh -T
```

## VFD
The repository contains a slighty patched openvfd driver with additional commands to set the shown value in the VFD.
So instead showing only the current clock, it is possible to show something else.
For example the following command shows TEST in the VFD
```
echo -e -n '\x03TEST' > /tmp/openvfd_service
```
You can switch back to the clock via
```
echo -e -n '\x00' > /tmp/openvfd_service
```

## Starting VDR
### \<bindir\>/start_vdr.sh 
Reads the file ```/storage/.config/vdropt/enabled-plugins``` which contains a plugin name on each line and starts VDR 
with all enabled plugins. The plugin configuration are read from ```/storage/.config/vdropt/*.conf```.
### \<bindir\>/start_vdr_easy.sh
Uses the plugin vdr-plugin-easyvdr (see https://www.gen2vdr.de/wirbel/easyvdr/index2.html) to start VDR. 
The configuration entries can be found in the ```/storage/.config/vdropt/*_settings.ini```.
Plugins can be started/stopped at runtime via the OSD.
Additionally the command line tool easyvdrctl.sh (which uses easyvdrctl) can be found in the &lt;bindir&gt;.
### /storage/.kodi/addons/skin.estuary/xml/DialogButtonMenu.xml
In Kodis default theme estuary, one additional entry will be added to the power menu to switch to VDR. 
If another skin is used, the entry needs to be done manually.
```
<item>
    <label>VDR</label>
    <onclick>System.Exec("/usr/local/bin/switch_to_vdr.sh")</onclick>
</item>
```
A whole sample can be found in ```<vdrdir>/config/DialogButtonMenu.xml```
### /storage/.config/vdropt/commands.conf
A new entry is needed, like e.g.
```
Start Kodi       : echo "START_PRG=kodi" > /storage/.cache/switch_kodi_vdr
```

## LD_PRELOAD
It is possible to add libraries to be preloaded if needed by setting a variable in ```/storage/.profile```
```
VDR_LD_PRELOAD=/path/to/lib1.so:/path/to/lib2.so
```

## Delete
If you don't want to use these images anymore, you can simply install a new core CoreELEC/LibreELEC image and
delete the directories
```
/storage/.conf/vdropt
/storage/.conf/vdropt-sample
/storage/.fonts
```
to get rid of all VDR configurations.
