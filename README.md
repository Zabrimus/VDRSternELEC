# What is VDR*ELEC?
VDR*ELEC is a collection of scripts and patches, which add a VDR client and many VDR plugins to [CoreELEC (CE)](https://github.com/CoreELEC/CoreELEC) and [LibreELEC (LE)](https://github.com/LibreELEC/LibreELEC.tv) images. 
The images include a full-featured CoreELEC or LibreELEC distribution, where it's possible to comfortably switch between KODI and VDR.

> **Disclaimer:** Not all images are tested and there is no guarantee at all, that the VDR client on these images is working as expected. Possible reasons are missing or misconfigured VDR output devices and plugins.  
> Therefore tests and/or pull requests are highly appreciated.

## Releases
Releases are created and made available on a regular basis.
An overview can be found at [here](https://zabrimus.github.io/VDRSternELEC/), for example.

## Directory structure of this repository

:file_folder: **CoreELEC** - CoreELEC's build directory included as git submodule  
:file_folder: **LibreELEC.tv** - LibreELEC's build directory included as git submodule  
:file_folder: **config**  
    + :file_folder: **distro** - includes predefined build configurations  
    + **addons.list** - lists all available pre-buildable KODI addons  
    + **extras.list** - lists all available extras (patches, plugins)  
    + **versions** - sets the commit/branch/tag to use for LibreELEC/CoreELEC  
:file_folder: **gh-pages** - scripts to create the release overview and the update channels  
:file_folder: **package_patches** - these patches are copied to LE/CE packages folders before build  
:file_folder: **packages** - packages, that will be added to upstream CE/LE  
:file_folder: **patches** - these patches are applied to CE/LE directory itself before build  
:file_folder: **release-scripts** - LibreELEC's release-scripts repo included as a git submodule  
+ **build.sh** - main build script  
+ **clean-package.sh** - helper script to clean single packages  
+ **convert_ova_to_qcow2.sh** - helper script to convert ova image to qcow2 format  
+ **create-ce22-systemd-patch.sh**, **create-le13-systemd-patch.sh** - helper scripts to create the systemd downgrade patches  
+ **prepare-autoremove** - keeps needed build directories, if build.sh runs with ```AUTOREMOVE=yes``` (GitHub workflows, saves disk space)  
+ **update.sh** - helper script to update packages  

## Current status of VDR and plugins
[These patches](packages/vdr/_vdr/patches) are already applied to VDR.
[These plugins](packages/vdr) are successfully built and part of the VDR tar.

# Get an image file
You can choose between downloading a prebuilt image like you do it with official CE/LE images or building a customized image on your own.

## Prebuilt images
The easiest way is to use a prebuilt image. These images are periodically available in the [releases](https://github.com/Zabrimus/VDRSternELEC/releases) section of this repository. Choose the image matching your hardware and write it to SD-Card or USB. You can also use these images as an update image for your existing CE/LE installation.

## Manual build
*Refer to [LibreELEC](https://wiki.libreelec.tv/development/build-basics) or [CoreELEC](https://wiki.coreelec.org/coreelec:build_ce) building dependencies.  
The following description is based on Debian or Ubuntu as the host system.*
### Install all dependencies
```
apt-get install gcc make git unzip wget xz-utils bc gperf zip g++ xfonts-utils xsltproc default-jre-headless curl cpio
```
Missing tools are reported by LibreELEC/CoreELEC at the first build (```scripts/checkdeps```), which offers to install them.
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
DISTRO=CoreELEC
SHA=${COREELEC22}
PATCHDIR=coreelec-22

# Use project variant
VARIANT=

# Build settings
PROJECT=Amlogic-ce
DEVICE=Amlogic-no
ARCH=aarch64

# VDR settings
VDR_OUTPUTDEVICE=softhdodroid
VDR_INPUTDEVICE=satip

# Updates
STERN_RELEASE=https://zabrimus.github.io/VDRSternELEC/updates/release.CoreELEC-22-no.json
STERN_ADDON=https://zabrimus.github.io/VDRSternELEC/updates/addons.CoreELEC-22-no.json
```

**Environment variables:**
- DISTRO: the build directory, either ```CoreELEC``` or ```LibreELEC.tv```
- SHA: The commit/branch/tag from CoreELEC/LibreELEC to use (see [config/versions](config/versions))
- PATCHDIR: This is used for additional patches (located in patches/$DISTRO.$PATCHDIR and package_patches/$DISTRO.$PATCHDIR)
- VARIANT: specify some variant of the project, e.g. for choosing different patches
- PROJECT: 
  - CoreELEC: ```Amlogic-ce``` or any of [CoreELEC/projects](https://github.com/CoreELEC/CoreELEC/tree/master/projects)
  - LibreELEC: ```Allwinner``` or any of [LibreELEC.tv/projects](https://github.com/LibreELEC/LibreELEC.tv/tree/master/projects)
- DEVICE: 
  - CoreELEC: ```Amlogic-ng``` or another supported DEVICE for CoreELEC
  - LibreELEC: ```H6``` or another supported DEVICE for LibreELEC
- ARCH: 
  - CoreELEC: ```arm``` or another supported ARCH for CoreELEC
  - LibreELEC: ```arm``` or another supported ARCH for LibreELEC
- VDR_OUTPUTDEVICE: VDR output device, which is enabled by default, e.g. ```softhdodroid```, ```softhddevice-drm```, ```softhddevice-drm-gles``` or another one from the [available packages](packages/vdr)
- VDR_INPUTDEVICE: VDR input device, which is enabled by default, e.g. ```satip``` or ```streamdev-client```
- STERN_RELEASE, STERN_ADDON: URLs of the update channels for the image and the addons (optional)

#### Addons
It's possible to build some KODI addons. All available addons are listed in [addons.list](config/addons.list).  
Building the addons with ```build.sh``` can be triggered by adding them with the ```-addon``` option and a comma separated list.
The built addons can be found in CoreELEC/target/addons or LibreELEC.tv/target/addons and can be installed in Kodi.

*Probably not all addons can be compiled for every LibreELEC/CoreELEC version. Mainly dvb-latest and crazycat are candidates to fail, because of the frequently updated linux kernel.*

#### Extras
It's also possible to build some additional plugins or apply some patches on VDR during build process. All available extras are listed in [extras.list](config/extras.list).  
Building the extras with ```build.sh``` can be triggered by adding them with the ```-extra``` option and a comma separated list.

#### Release/ Update
If you want to create a "real" release, which can be used to update from kodi GUI, use the ```-release <RELEASE_SERVER>``` option.  
Set up a webserver which is available at ```$RELEASE_SERVER``` and let it point to the directory ```releases``` (```RELEASEDIR``` in build.sh).  
Go to kodi settings and add the server as an update channel.

### Building the image
After choosing an existing configuration or creating a new one, the build script can be called:
```
$ ./build.sh
Usage: ./build.sh -config <name> [Options]
-config            : Build the distribution defined in directory config/distro/<name> (mandatory)

Options:
-extra <name,name> : Build additional plugins / Use optional VDR patches / Use extra from config/extras.list
                     (option is followed by a comma-separated list of the available extras below)
-addon <name,name> : Build additional addons which will be pre-installed / Use addon from config/addons.list
                     (option is followed by a comma-separated list of the available addons below)
-subdevice         : Build only images for the desired subdevice. This speeds up building images.
-addononly         : Build only the desired addons
-patchonly         : Only apply patches and build nothing
-package <name>    : Build <name> as a single package
-release <server>  : Create release for update, accessible at <server>
-releaseonly       : Build only the release tar and not all images
-cef               : Include cef binaries into release, otherwise deploy it as an external package
-cebootlabel       : Change CoreELEC bootlabel to value of "-config"
-verbose           : Enable verbose outputs while building LE/CE packages
-help              : Show this help

Available configs:
CoreELEC-20-ne
CoreELEC-20-ng
CoreELEC-21-ne
CoreELEC-21-ng
CoreELEC-22-no
CoreELEC-23-no
LibreELEC-12-aarch64-AMLGX
LibreELEC-{12,13}-aarch64-Allwinner-A64
LibreELEC-{12,13}-aarch64-Allwinner-H5
LibreELEC-{12,13}-aarch64-Allwinner-H6
LibreELEC-{12,13}-aarch64-RPi-RPi4
LibreELEC-{12,13}-aarch64-RPi-RPi5
LibreELEC-{12,13}-aarch64-Rockchip-RK3328
LibreELEC-{12,13}-aarch64-Rockchip-RK3399
LibreELEC-{12,13}-arm-Allwinner-H3
LibreELEC-{12,13}-arm-Allwinner-R40
LibreELEC-{12,13}-arm-RPi-RPi2-3
LibreELEC-{12,13}-arm-Rockchip-RK3288
LibreELEC-{12,13}-x86_64-Generic
LibreELEC-{12,13}-x86_64-Generic-qemu
LibreELEC-{12,13}-x86_64-GenericLegacy
LibreELEC-{12,13}-x86_64-GenericLegacy-qemu
LibreELEC-{12,13}-x86_64-x11
LibreELEC-{12,13}-x86_64-x11-qemu
LibreELEC-13-aarch64-Amlogic
LibreELEC-13-aarch64-Rockchip-RK356x
LibreELEC-13-aarch64-Rockchip-RK3576
LibreELEC-13-aarch64-Rockchip-RK3588

Available extras:
directfb
directfbsamples
dynamite
easyvdr
permashift
remotetranscode

Available addons:
cefbrowser
cefruntime
channellogos
crazycat
digital-devices
dvb-latest
dvb-tools
ffmpeg-tools
incus
locale
network-tools
sundtek-mediatv
system-tools
tsduck
yt-dlp
```
Example call:  ```./build.sh -config CoreELEC-22-no -extra easyvdr```  

If everything worked fine, the desired images can be found in either  ```CoreELEC/target```, ```LibreELEC.tv/target``` or ```releases```.

# Creating bootable media
Write your image file to an SD-Card like you are used to do it with [LibreELEC](https://wiki.libreelec.tv/installation/create-media) or [CoreELEC](https://wiki.coreelec.org/coreelec:bootmedia#step_2) and boot your device.

# Post-installation work
## First boot
The first boot will come up with KODI gui. Follow the dialog and choose your language and network settings. It's very helpful to enable ssh service, to be able to access the device from outside. You also want to set your time/timezone in the KODI settings now. This would also be the time, which is used in VDR afterwards.

## Install KODI addons
Now it would be a good time to install the KODI addons of your choice. E.g. ```system-tools addon``` can be very helpful, because it makes mc available on the device. In order to be able to get the right language within VDR you should also install the ```locale addon``` and configure the addon with your desired language (e.g. de_DE).

## Directory structure
- ```/usr/local/lib```  
  contains libraries which are usually not part of CoreELEC/ LibreELEC
- ```/usr/local/bin```, ```/usr/local/lib/vdr```  
  contain VDR and all plugins
- ```/storage/.config/vdropt/```  
  contains the default configuration files  
- ```/storage/.config/vdropt-sample```  
  contains sample configuration files
- ```/storage/videos```  
  is the default video directory

## Install script
Now it's time to run the install script ```install.sh``` from within the console (e.g. via ssh):
```
# install.sh
Usage: /usr/local/bin/install.sh [-i] [-C] [-b kodi|vdr] [-T] [-w] [-v] [-c (url)] [-R (url)] [-p (url)] [-l (url)]

-i       : Extracts the default configuration into directory /storage/.config/vdropt-sample and copy the sample folder to /storage/.config/vdropt if it does not exists.
-C       : Use with care! All configuration entries of vdropt will be copied to vdropt-sample. And then all entries of vdropt-sample will be copied to vdropt.
-b kodi  : Kodi will be started after booting
-b vdr   : VDR will be started after booting
-T       : install all necessary files and samples for triggerhappy (A lightweight hotkey daemon)
-w       : install/update web components (remotetranscode, cefbrowser)
-v       : install vtuner-ng (change /storage/.config/start_vtuner.sh accordingly, otherwise it will not start)
-c (url) : install/update cefbrowser binary (located at url or in /storage/.update/addon-cefbrowser.zip)
-R (url) : install/update CEF runtime for cefbrowser (located at url or in /storage/.update/addon-cefruntime.zip)
-p (url) : install/update private configs (located at url or in /storage/.update/ve-private-conf.zip)
-l (url) : install/update channel logos (located at url or in /storage/.update/channellogos.tar.gz)
```
If you are at the first boot, the minimum you have to do is running the script with the ```-i``` option, which will copy the default configuration to the right place. If you also want, that VDR will start as default, these are the commands of your choice:
```
install.sh -i
install.sh -b vdr
```

## Configuration
### Language settings
To be able to use the configured language within VDR you have to create/modify file /storage/.profile with (e.g. for german UTF-8):  
```
export LANG="de_DE.UTF-8"
export LC_ALL="de_DE.UTF-8"
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

:exclamation: Only if you update from a very old version of VDR*ELEC, which still has ```Conflicts``` in ```vdropt.service```, you have to modify the systemd script:
```
sed -i "/Conflicts/d" /storage/.config/system.d/vdropt.service
systemctl daemon-reload
```

### Remote control
LibreELEC and CoreELEC use kernel built-in remote support as default. See [LibreELEC - Infra-Red Remotes](https://wiki.libreelec.tv/configuration/ir-remotes). If your remote control does not work out of the box in KODI, you can follow the instructions there.

### Remote control (advanced, NEC)
A description of the configuration can be found in [vdr-portal.de](https://www.vdr-portal.de/forum/index.php?thread/135105-help-request-vdr-coreelec-chroot-oder-zabrimus-und-amremote-eventlird/&postID=1362231#post1362231).
All necessary driver and system.d units are already included in the distribution.
Thanks to Dr. Seltsam @ vdr-portal.de

### Enabled plugins
```/storage/.config/vdropt/enabled_plugins``` contains a list of the plugins to autostart with VDR. Simply edit the file and add other plugins of your choice to the already pre-activated ones. 

### Channel logos
```/storage/channellogos/logos(Light|Dark)``` contain the channel logos. The channellogos can be built with ```-addon channellogos``` and installed with ```install.sh -l```.

### VDR specific configuration
After basic configuration is done you probably need to adapt VDR's conf files.  
VDR configuration is located in ```/storage/.config/vdropt```. The ```channels.conf``` and the other files need to be edited according to your needs.

### CoreELEC 20 and above: Wakeup via remote
Since CoreELEC 20 it could be necessary to enable the systemd script ```/storage/.config/system.d/setup_bl301.service``` if the system boots directly VDR.
```install.sh -i``` copies it and ```install.sh -b vdr``` enables it. If you observe problems starting your system via remote and set up the boot otherwise, enable the systemd script via
```
cp /usr/local/system.d/setup_bl301.service /storage/.config/system.d
systemctl daemon-reload
systemctl enable setup_bl301.service
systemctl start setup_bl301.service 
```

## Reboot
Once configuration is completed, your device should start into VDR after a reboot.

# Updating
Do an update with the image file like you are used to do it with [LibreELEC](https://wiki.libreelec.tv/support/update) or [CoreELEC](https://discourse.coreelec.org/t/how-to-update-coreelec/1037).  

Example for getting your image onto the device with scp:
```
scp target/CoreELEC-Amlogic-ng.arm-*.tar root@<ip address>:/storage/.update
reboot
```

# Developer Section

## Adding patches and modifying sources

You can modify your build by adding patches which can modify the upstream LE/CE or
the VDRSternELEC packages.

> Remember to NOT modify the LibreELEC or CoreELEC subdirectory itself, because changes in there
> will be swept out during the next build. When starting the build process, these directories will be
> reset to the sha from [config/versions](config/versions).
> Whenever you want to modify some package, you need to do this in the following 3 directories.
> As long as you don't clear the build directory, only packages that have been modified will be built again.
> LE/CE should know, if something has been modified or if a new or modified patch was placed somewhere.

Besides [config/versions](config/versions), where you
can change the upstream sha of LE/CE for your needs, you can add patches or bash scripts, to be
applied or executed:
+ **somescript.sh** - scripts, which will be executed on the submodule directory (mainly simple sed-oneliners)  
+ **somepatch.patch** - patches, which will be applied on the submodule directory  

You have to place such scripts and patches at the right place in the directory structure, to let
the build logic decide, on which LE/CE-version and PROJECT/DEVICE they should be applied and executed.  
There are 3 directories, which are relevant and the logic is like this:

-> :file_folder: **patches**  
Scripts and patches in the **patches** directory are intended to modify the original upstream files of LE/CE.
They will be applied at first.

:file_folder: **patches** (will be executed/ applied to every build)  
|__ **somescript.sh**  
|__ **somepatch.patch**  
|__ :file_folder: **CoreELEC** (will be executed/ applied to every CoreELEC build)  
|&nbsp;&nbsp;&nbsp;&nbsp;|__ **somescript.sh**  
|&nbsp;&nbsp;&nbsp;&nbsp;|__ **somepatch.patch**  
|__ :file_folder: **CoreELEC.coreelec-(version)** (will be executed/ applied to the CoreELEC-version build)  
|&nbsp;&nbsp;&nbsp;&nbsp;|__ **somescript.sh**  
|&nbsp;&nbsp;&nbsp;&nbsp;|__ **somepatch.patch**  
|__ :file_folder: **LibreELEC.tv** (will be executed/ applied to every LibreELEC build)  
|&nbsp;&nbsp;&nbsp;&nbsp;|__ **somescript.sh**  
|&nbsp;&nbsp;&nbsp;&nbsp;|__ **somepatch.patch**  
|__ :file_folder: **LibreELEC.tv.libreelec-(version)** (will be executed/ applied to the LibreELEC-version build)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|__ **somescript.sh**  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|__ **somepatch.patch**  

You can add a subdirectory to the above directories in the following logic:  
:file_folder: **../projects/YOUR_PROJECT/** (will only be executed/ applied to all devices in YOUR_PROJECT)  
:file_folder: **../projects/YOUR_PROJECT/devices/YOUR_DEVICE/** (will be executed/ applied to YOUR_DEVICE in YOUR_PROJECT)  
:file_folder: **../projects/YOUR_PROJECT/devices/YOUR_DEVICE/variants/YOUR_VARIANT/** (will be executed/ applied to YOUR_VARIANT of YOUR_DEVICE in YOUR_PROJECT)  

---

-> :file_folder: **package_patches**  
Patches in the **package_patches** directory are intended to be copied to the upstream LE/CE version as is.
You can build a new patch from the package source (probably the already patched LE/CE source) and this patch will be applied
as if it would have been part of the original LE/CE.

:file_folder: **package_patches**  
|__ :file_folder: **CoreELEC** (will be applied to every CoreELEC build)  
|__ :file_folder: **CoreELEC.coreelec-version** (will be applied to the CoreELEC-version build)  
|__ :file_folder: **LibreELEC.tv** (will be applied to every LibreELEC build)  
|__ :file_folder: **LibreELEC.tv.libreelec-version** (will be applied to the LibreELEC-version build)  

The structure within the directories follows the LE/CE logic, e.g. a patch for the package ```kodi``` has to be placed in
```packages/mediacenter/kodi/patches``` like it's done in LE/CE. Platform-specific patches should be placed in the ```projects/PLATFORM/patches```
subdirectories. Device-specific patches should be placed in the ```projects/PLATFORM/devices/DEVICE/patches``` subdirectories.

It's a bit tricky to find the right place because at first you need to understand the LE/CE directory structure, but it's doable.

---

-> :file_folder: **packages**  
This is the heart of VDRSternELEC. The packages directory contains all packages that are added to upstream LE/CE. This directory is
handled during the build process as if it is part of the upstream ```packages``` directory.
For a new package you need at least a package.mk file. See VDRSternELEC and LE/CE sources to see how this works.
You also have the possibility to modify and add patches and files to the existing packages.

## VDR*ELEC as a developing platform

The VDR plugins of the image are located in the read-only directory ```/usr/local/lib/vdr```.
To test own builds of plugins, VDR can load its plugins via links in ```/storage``` instead (opt-in):
```
vdrlib.sh enable
systemctl restart vdropt
```
This sets ```VDR_DEVLIBS=yes``` in ```/storage/.profile```. On every start, ```start_vdr.sh``` creates a link for every
plugin of the image in ```/storage/.config/vdrlibs``` and starts VDR with ```-L /storage/.config/vdrlibs```.
By default all links point to the image. Let a link point to your own build:
```
vdrlib.sh set web /storage/build/libvdr-web.so.8
vdrlib.sh list                  # plugin, API version and target of every link
vdrlib.sh reset web             # use the plugin of the image again (or: reset all)
vdrlib.sh disable               # load the plugins from /usr/local/lib/vdr again
```
Changed links are kept on updates. The file names contain the API version of VDR, so a link to an own build
for an old API version isn't used anymore after an update of VDR (```vdrlib.sh list``` shows it), VDR loads
the plugin of the image instead.

VDR itself can be replaced the same way:
```
vdrlib.sh set vdr /storage/build/vdr
vdrlib.sh reset vdr
```
VDR loads plugins with its own API version only. If your build of VDR has another API version than the image
(```vdrlib.sh set``` warns), all enabled plugins have to be replaced by own builds for this version.

Other libraries in ```/storage/.config/vdrlibs/lib``` are preferred to the ones of the image (```LD_LIBRARY_PATH```),
e.g. an own build of FFmpeg. The links need the name of the soname (e.g. ```libavcodec.so.61```), and the
library has to be compatible with the one the plugins are built against. Replace all FFmpeg libraries together.
This affects VDR only, Kodi and the other services keep using the libraries of the image.

If you have a build host, you can mount its build directory, e.g. via a nfs systemd service, and let the links point
into it. Then you simply need to restart VDR to test a new build.

Don't set ```-L``` in ```/storage/.config/vdropt/conf.d/vdr.conf```, it overrides the directory of ```vdrlib.sh```.

## Github Build
In directory ```.github/workflows``` exists several workflows which can be used to build an own image with own configuration.
* **[precache sources](https://github.com/Zabrimus/VDRSternELEC/blob/master/.github/workflows/precache-sources.yml)** which downloads all necessary sources for a distribution and caches them in Github as artifact.
* **[Update CoreELEC/LibreELEC](https://github.com/Zabrimus/VDRSternELEC/blob/master/.github/workflows/update_ce_le.yml)** checks if an update of CoreELEC or LibreELEC exists and creates a pull request to update ```config/versions```.
* **[Update Packages](https://github.com/Zabrimus/VDRSternELEC/blob/master/.github/workflows/update_packages.yml)** checks if package updates exists and create a pull request to update the packages.
* **[Build VDRSternELEC](https://github.com/Zabrimus/VDRSternELEC/blob/master/.github/workflows/build.yml)** Main workflow to build releases, images and addons. After the build a new release will be created and all build artifacts are uploaded to the release.

If you clone the repository, you can start your own build and create own releases. The configuration of the build can be widely configured.
The configuration matches the commandline parameters of [build.sh](https://github.com/Zabrimus/VDRSternELEC#building-the-image).
If you often want to create an own release with specific parameters it is possibly easier to create a new workflow and configure the desired parameters.
A sample workflow [demo_build_template.yml](https://github.com/Zabrimus/VDRSternELEC/blob/master/.github/workflows/demo_build_template.yml) exists.

:exclamation: If you want to delete a parameter then use '-' as parameter. Otherwise the workflows falls back to the default parameter.

There exists several other cron workflows, which cannot be used outside the repository Zabrimus/VDRSternELEC. Except in a forked repository the condition is removed or changed.
* **[Cron Build VDRSternELEC](https://github.com/Zabrimus/VDRSternELEC/blob/master/.github/workflows/cron_build.yml)** calls periodically the workflow **Build VDRSternELEC**
* **[Cron Precache Sources](https://github.com/Zabrimus/VDRSternELEC/blob/master/.github/workflows/cron_precache_sources.yml)** calls periodically the workflow **precache sources**
* **[Cron Update CE/LE](https://github.com/Zabrimus/VDRSternELEC/blob/master/.github/workflows/cron_update_ce_le.yml)** calls periodically the workflow **Update CoreELEC/LibreELEC**
* **[Cron Update Packages](https://github.com/Zabrimus/VDRSternELEC/blob/master/.github/workflows/cron_update_packages.yml)** calls periodically the workflow **Update Packages**



# Several notes and additional hints (to be updated)
## vdr-plugin-web / HbbTV
The plugin vdr-plugin-web is already part of VDR*ELEC, remotetranscode is part of the image if it has been built with the extra ```remotetranscode```.
The browser consists of two addons, which are available in the [releases](https://github.com/Zabrimus/VDRSternELEC/releases) section:
- ```addon-cefbrowser.zip```: the browser cefbrowser and its data. It changes with every new version of cefbrowser.
- ```addon-cefruntime.zip```: the runtime of the Chromium Embedded Framework (CEF), which cefbrowser needs. It is large and changes only with a new CEF version.

cefbrowser runs only with the CEF runtime it has been built with. Its version is in ```/storage/browser/addon.cefbrowser/etc/cef-version```.
Each CEF runtime is installed in its own directory ```/storage/browser/addon.cefruntime/<version>```,
the link ```/storage/browser/addon.cefbrowser/cef``` points to the one used.

### New installation
Copy both zip files to ```/storage/.update``` (or give their URLs to the script) and run
```
install.sh -R
install.sh -c
install.sh -w
```
```-w``` installs and enables the services of cefbrowser and remotetranscode. Start them with
```
systemctl start remotetranscode cefbrowser
```
The order of ```-R``` and ```-c``` doesn't matter, ```-w``` checks that the CEF runtime of cefbrowser is installed.

Own changes of the services belong into a drop-in, e.g. ```/storage/.config/system.d/cefbrowser.service.d/override.conf```:
```
[Service]
RestartSec=10
Environment=BROWSER_DB_PATH="/storage/mydatabase"
```
Single values replace the ones of the service, lists like ```Environment``` or ```ExecStart``` are extended
(an empty ```ExecStart=``` clears it before). Run ```systemctl daemon-reload``` and restart the service afterwards,
```systemctl cat cefbrowser``` shows the result.
```install.sh``` updates ```cefbrowser.service``` and ```remotetranscode.service``` in ```/storage/.config/system.d```, a changed file is saved as ```.bak``` before. The drop-ins are kept.

### Update
- A new cefbrowser with the same CEF version needs only
  ```
  install.sh -c
  systemctl restart cefbrowser
  ```
  If ```cefbrowser.service``` is installed, ```-c``` updates it as well.
- If the new cefbrowser needs another CEF version, install the CEF runtime as well:
  ```
  install.sh -R
  install.sh -c
  systemctl restart cefbrowser
  ```
  ```install.sh -c``` tells if the CEF runtime is missing, the service doesn't start without it (```journalctl -u cefbrowser``` shows the version).
  The directory of the old CEF runtime in ```/storage/browser/addon.cefruntime``` can be deleted afterwards.
- Coming from an older cefbrowser with the CEF runtime included, run ```install.sh -w``` once after the update.
  It replaces ```/storage/.config/system.d/cefbrowser.service```, which still uses the old directories, and also ```remotetranscode.service```.
  The previous files are saved as ```.bak```, own changes should be moved into a drop-in (see above).

### remotetranscode
remotetranscode is used to stream transcoded videos to VDR. It can also run on another, faster system or a system with a hardware encoder,
the repository can be found at https://github.com/Zabrimus/remotetranscode.
Downloads of videos from the Mediathek are saved in ```/storage/downloads/mediathek```.

## Skindesigner repository
Skindesigner uses a git repository to install custom skins. To be able to use this feature installing git is necessary.
- Install entware (see https://wiki.coreelec.org/coreelec:entware)
- Install git and git-http
  ```opkg install git git-http```

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
install.sh -T
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
Reads the file ```/storage/.config/vdropt/enabled_plugins``` which contains a plugin name on each line and starts VDR 
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
```install.sh -i``` adds it, if the skin hasn't been copied to ```/storage/.kodi/addons``` before. A whole sample can be found in ```/usr/local/config/DialogButtonMenu.xml```
### /storage/.config/vdropt/commands.conf
The sample configuration already contains an entry to switch to Kodi:
```
Start Kodi       : echo "START_PRG=kodi" > /storage/.cache/switch_kodi_vdr
```

## LD_PRELOAD
It is possible to add libraries to be preloaded if needed by setting a variable in ```/storage/.profile```
```
VDR_LD_PRELOAD=/path/to/lib1.so:/path/to/lib2.so
```

Own builds of VDR plugins and libraries can be used with ```vdrlib.sh```, see [VDR*ELEC as a developing platform](#vdrelec-as-a-developing-platform).

## Start LibreELEC in incus (fork of lxd) (x86_64)
It is possible to start a local virtual machine in [incus](https://linuxcontainers.org/incus/) for LibreELEC/x86_64.
At first you need to build the image and `extras` Parameter if desired.
```
./build.sh -config LibreELEC-12-x86_64-x11-qemu
```
After the build an `ova` Image is available in folder LibreELEC.tv/target/. This image needs to be converted to a `qcow2` image.

The script `convert_ova_to_qcow2.sh` can be used, e.g.
```
./convert_ova_to_qcow2.sh LibreELEC.tv/target/LibreELEC-x11.x86_64-12.0-devel-20231221191352-db968f9.ova
```

Create a file `metadata.yaml` with content
```
architecture: x86_64
creation_date: 1701385200
properties:
  description: LibreELEC 12
  os: LE
  release: 12
```
and tar this file
```
tar cf metadata.tar metadata.yaml
```

Now you can add the `qcow2` image to `incus`
```
incus image import metadata.tar <filename>.qcow2 --alias LE12
```

Create a new container using the newly added image:
```
incus create LE12 libreelec --vm -c security.secureboot=false -c limits.cpu=2 -c limits.memory=4GiB
```

Start the virtual machine
```
incus start libreelec
```

Connect to the running virtual machine to get a graphical view: 
```
incus console libreelec --type vga
```
### Troubleshooting
#### Failed creating instance
It is possible that you get an error message while trying to create a virtual machine
```
incus create LE12 libreelec --vm -c security.secureboot=false -c limits.cpu=2 -c limits.memory=4GiB
Creating libreelec
Error: Failed creating instance record: Failed initialising instance: Invalid config: No uid/gid allocation configured. In this mode, only privileged containers are supported
```
To solve this add the line (as root) to both files
`/etc/subgid` and `/etc/subuid`
```
root:1000000:65536
```
Possibly a reboot is necessary.

#### High CPU usage after connecting to vga console
This is work in progress. Kodi is using the `mesa softpipe` driver, which is relatively slow.
