# VDR*ELEC
This is a build system for CoreELEC and LibreELEC which includes VDR together with many VDR plugins.
The CoreELEC and LibreELEC repositories are included as git submodules.

It is possible to configure the application to start with: KODI or VDR. There exists also an easy solution to switch between KODI and VDR. 

The result of the build process are images for CoreELEC/LibreELEC which contains VDR and all plugins.

This is still work in progress...

## *Warning*
The LibreELEC images are not well tested and there is no guarantee at all, that these images are installable/working/or whatever.
It is also possible, that some VDR output devices (plugins) are missing.

Tests and/or pull requests are highly appreciated.

## Current status:

**Following plugins are successfully build and part of the vdr tar**
```
CoreELEC:/usr/local/bin # ./easyvdrctl.sh --all-status
 Plugin             | install | ini     | AutoRun | Stop | Arguments
--------------------------------------------------------------------------------
 ac3mode            | yes     | valid   | no      | yes  | 
 cdplayer           | yes     | valid   | no      | yes  | 
 cecremote          | yes     | valid   | no      | yes  | 
 chanman            | yes     | valid   | no      | yes  | 
 channellists       | yes     | valid   | no      | yes  | 
 conflictcheckonly  | yes     | valid   | no      | yes  | 
 control            | yes     | valid   | yes     | yes  |
 dbus2vdr           | yes     | valid   | no      | yes  | 
 ddci2              | yes     | valid   | no      | yes  | 
 devstatus          | yes     | valid   | no      | yes  | 
 dummydevice        | yes     | valid   | no      | yes  | 
 dvbapi             | yes     | valid   | no      | yes  | 
 dvd                | yes     | valid   | no      | yes  | 
 dynamite           | no      | valid   | no      | yes  | 
 eepg               | yes     | valid   | no      | yes  | 
 epg2vdr            | yes     | valid   | no      | yes  | 
 epgfixer           | yes     | valid   | no      | yes  | 
 epgsearch          | yes     | valid   | no      | yes  | 
 epgsearchonly      | yes     | valid   | no      | yes  | 
 epgtableid0        | yes     | valid   | no      | yes  | 
 externalplayer     | yes     | valid   | no      | yes  | 
 femon              | yes     | valid   | no      | yes  | 
 filebrowser        | yes     | valid   | no      | yes  | 
 fritzbox           | yes     | valid   | no      | yes  | -c /storage/.config/vdropt/plugins/fritz/on-call.sh
 hello              | yes     | valid   | no      | yes  | 
 iptv               | yes     | valid   | no      | yes  | 
 live               | yes     | valid   | no      | yes  | 
 markad             | yes     | valid   | no      | yes  | 
 menuorg            | yes     | valid   | no      | yes  | 
 mp3                | yes     | valid   | no      | yes  | 
 osd2web            | yes     | valid   | no      | yes  | 
 osddemo            | yes     | valid   | no      | yes  | 
 osdteletext        | yes     | valid   | no      | yes  | 
 pictures           | yes     | valid   | no      | yes  | 
 quickepgsearch     | yes     | valid   | no      | yes  | 
 radio              | yes     | valid   | no      | yes  | -f /storage/.config/vdropt/plugins/radio
 remote             | yes     | valid   | no      | yes  | 
 remoteosd          | yes     | valid   | no      | yes  | 
 restfulapi         | yes     | valid   | no      | yes  | 
 robotv             | yes     | valid   | no      | yes  | 
 satip              | yes     | valid   | yes     | yes  | 
 scraper2vdr        | yes     | valid   | no      | yes  | 
 skindesigner       | yes     | valid   | no      | yes  | 
 skinelchihd        | yes     | valid   | no      | yes  | 
 skinflat           | yes     | valid   | no      | yes  | 
 skinflatplus       | yes     | valid   | no      | yes  | 
 skinlcarsng        | yes     | valid   | no      | yes  | 
 skinnopacity       | yes     | valid   | no      | yes  | 
 skinsoppalusikka   | yes     | valid   | no      | yes  | 
 softhdodroid       | yes     | valid   | yes     | no   | -a hw:CARD=AMLAUGESOUND,DEV=0
 status             | yes     | valid   | no      | yes  | 
 streamdev-client   | yes     | valid   | no      | yes  | 
 streamdev-client2  | yes     | valid   | no      | yes  | 
 streamdev-client3  | yes     | valid   | no      | yes  | 
 streamdev-client4  | yes     | valid   | no      | yes  | 
 streamdev-server   | yes     | valid   | no      | yes  | 
 svccli             | yes     | valid   | no      | yes  | 
 svcsvr             | yes     | valid   | no      | yes  | 
 svdrpdemo          | yes     | valid   | no      | yes  | 
 svdrpservice       | yes     | valid   | no      | yes  | 
 systeminfo         | yes     | valid   | no      | yes  | --script=/storage/.config/vdropt/plugins/systeminfo/systeminfo.sh
 targavfd           | yes     | valid   | no      | yes  | 
 tvguideng          | yes     | valid   | no      | yes  | 
 tvscraper          | yes     | valid   | no      | yes  | 
 vnsiserver         | yes     | valid   | no      | yes  | 
 weatherforecast    | yes     | valid   | no      | yes  | 
 wirbelscan         | yes     | valid   | no      | yes  | 
 wirbelscancontrol  | yes     | valid   | no      | yes  | 
 zaphistory         | yes     | valid   | no      | yes  | 
 zappilot           | yes     | valid   | no      | yes  | 
```

## Build (tested with Ubuntu Focal and Debian 11)
### Install all dependencies
```
apt-get install build-essential coreutils squashfuse git curl xfonts-utils xsltproc default-jre \
                libxml-parser-perl libjson-perl libncurses5-dev bc gawk wget zip zstd libparse-yapp-perl \
                gperf lzop unzip patchutils cpio                
```

### Checkout VDRSternELEC
```
git clone https://github.com/Zabrimus/VDRSternELEC
```

### Configure the build process
#### config/distro
Several configurations are already provided in directory ```config/distro```. If you don't want to use an existing 
configuration, you can create a new one within this directory.

A sample configuration looks like this
```
# one of BRANCH, TAG or REVISION is mandatory
DISTRO=CoreELEC
BRANCH=coreelec-20
TAG=
REVISION=

# Build settings
PROJECT=Amlogic-ce
DEVICE=Amlogic-ng
ARCH=arm
```

- DISTRO: can be either ```CoreELEC``` or ```LibreELEC```
- BRANCH: The existing branch to use, or
- TAG: use a git tag to build, or
- REVISION: you can build with a specific revision.
- PROJECT: 
  - CoreELEC: ```Amlogic-ce```
  - LibreELEC: ```Amlogic``` or another supported project for LibreELEC
- DEVICE: 
  - CoreELEC: ```Amlogic-ng```
  - LibreELEC: ```AMLGX``` or another supported DEVICE for LibreELEC.
- ARCH: 
  - CoreELEC: ```arm```
  - LibreELEC: ```arm```, ```aarch64``` or another supported arch for LibreELEC

#### config/extras
A sample configuration looks like this
```
# Plugins/Patches

# vdr-plugin-easyvdr (y/n)
EASYVDR=y

# vdr-plugin-dynamite (y/n)
DYNAMITE=n

# zapcockpit patch (y/n)
ZAPCOCKPIT=y
```
- EASYVDR=y: Build also the plugin vdr-plugin-easyvdr
- DYNAMITE=y: Build also the plugin vdr-plugin-dynamite
- ZAPCOCKPIT=y: Apply the VDR zapcockpit patch

### Build
After choosing an existing configuration or creating a new one, the build script can be called:
```
$ ./build.sh 
Usage:  -config <name> -extras <name>
-config  : Build the distribution defined in directory config/distro/<name>.
-extras  : Build additional plugins / Use optional VDR patches. Use extra config/extras/<name>

Available configs:
CoreELEC-19  CoreELEC-19.4-Matrix  CoreELEC-20  LibreELEC-10.0.2-aarch64  LibreELEC-10.0.2-arm  LibreELEC-master-aarch64  LibreELEC-master-arm

Available extras:
dynamite  dynamite-zapcockpit  easyvdr  easyvdr-zapcockpit  zapcockpit
```

Sample call:  ```./build.sh -config CoreELEC-19 -extras easyvdr```

### Build images
After the call of build.sh, the desired images can be found in either
<details>
    <summary>directoy CoreELEC/target</summary>

```
280569134 17. Aug 12:41 CoreELEC-Amlogic-ng.arm-20.0-Nexus_devel_20220817124047-Generic.img.gz
280932778 17. Aug 12:41 CoreELEC-Amlogic-ng.arm-20.0-Nexus_devel_20220817124047-LaFrite.img.gz
281594040 17. Aug 12:41 CoreELEC-Amlogic-ng.arm-20.0-Nexus_devel_20220817124047-LePotato.img.gz
281171760 17. Aug 12:41 CoreELEC-Amlogic-ng.arm-20.0-Nexus_devel_20220817124047-Odroid_C4.img.gz
281172125 17. Aug 12:41 CoreELEC-Amlogic-ng.arm-20.0-Nexus_devel_20220817124047-Odroid_HC4.img.gz
281199018 17. Aug 12:41 CoreELEC-Amlogic-ng.arm-20.0-Nexus_devel_20220817124047-Odroid_N2.img.gz
281239656 17. Aug 12:41 CoreELEC-Amlogic-ng.arm-20.0-Nexus_devel_20220817124047-Radxa_Zero2.img.gz
281225969 17. Aug 12:41 CoreELEC-Amlogic-ng.arm-20.0-Nexus_devel_20220817124047-Radxa_Zero.img.gz
320788480 17. Aug 12:41 CoreELEC-Amlogic-ng.arm-20.0-Nexus_devel_20220817124047.tar
```
</details>

<details>
    <summary>directoy LibreELEC/target</summary> 

```
180836837 18. Aug 08:58 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca-bananapi-m5.img.gz
180972740 18. Aug 08:58 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca-box.img.gz
181191802 18. Aug 08:59 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca-khadas-vim2.img.gz
180867746 18. Aug 08:59 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca-khadas-vim3.img.gz
180871534 18. Aug 08:59 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca-khadas-vim3l.img.gz
181176449 18. Aug 08:59 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca-khadas-vim.img.gz
181231958 18. Aug 08:59 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca-lafrite.img.gz
181225990 18. Aug 08:59 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca-lepotato.img.gz
180530980 18. Aug 09:00 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca-nanopi-k2.img.gz
180574850 18. Aug 09:00 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca-odroid-c2.img.gz
180849702 18. Aug 09:00 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca-odroid-c4.img.gz
180860975 18. Aug 09:00 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca-odroid-hc4.img.gz
180833609 18. Aug 09:00 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca-odroid-n2.img.gz
180779771 18. Aug 09:01 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca-radxa-zero2.img.gz
180803039 18. Aug 09:01 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca-radxa-zero.img.gz
185528320 18. Aug 08:58 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca.tar
181224517 18. Aug 09:01 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca-wetek-core2.img.gz
180584449 18. Aug 09:01 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca-wetek-hub.img.gz
180584962 18. Aug 09:01 LibreELEC-AMLGX.arm-11.0-devel-20220818085603-8f586ca-wetek-play2.img.gz
```
</details>

## Images with integrated VDR and plugins
### Installation 
```
     scp target/CoreELEC-Amlogic-ng.arm-*.tar root@<ip der box>:/storage/.update
     reboot
     
     or
     
     Install the desired image in a micro SD as described in the CoreELEC part of this Readme. 
```

## Install script
In folder /opt/vdr/bin or /usr/local/bin contains an install script
```
  cd /opt/vdr/bin
  ./install.sh
  
  Usage: install.sh [-install-config] [-boot kodi|vdr]
          -i      : Extracts the default configuration into directory /storage/.config/vdropt-sample and copy the sample folder to /storage/.config/vdropt if it does not exists.
          -C      : Use with care! All configuration entries of vdropt will be copied to vdropt-sample. And then all entries of vdropt-sample will be copied to vdropt.
          -b kodi : Kodi will be started after booting
          -b vdr  : VDR will be started after booting
```

## Switch OSD language
To be able to switch the OSD languange you have to
- install Kodi addon: locale
- configure Kodi addon locale and choose your desired language
- create/modify file /storage/.profile with (in my case it's german):<br>
   export LANG="de_DE.UTF-8"<br>
   export LC_ALL="de_DE.UTF-8
- reboot

## Skindesigner repository
Skindesigner uses a git repository to install custom skins. To be able to use this feature installing git is necessary.
- Install entware (see https://wiki.coreelec.org/coreelec:entware)
- Install git and git-http
  ```opgk install git git-http```

## Switch Kodi <-> VDR
The install script (parameter -i) tries to modify/create as many default configuration as possible. 
If some configuration files already exists, they will not be overwritten, but the changes needs to be done manually.

### /storage/.config/autostart.sh
The default file will be copied from installation directory, but if the file already exists, a warning will be displayed.
One additional line is necessary
```/storage/.opt/vdr/bin/autostart.sh```
This script prepares some systemd units and paths.

### /storage/.kodi/addons/skin.estuary/xml/DialogButtonMenu.xml
In Kodis default theme estuary, one additional entry will be added to the power menu to switch to VDR. 
If another skin is used, the entry needs to be done manually.
```
<item>
    <label>VDR</label>
    <onclick>System.Exec("/opt/vdr/bin/switch_to_vdr.sh")</onclick>
</item>
```
A whole sample can be found in ```<vdrdir>/config/DialogButtonMenu.xml```

### /storage/.config/vdropt/commands.conf
A new entry is needed, like e.g.
```
Start Kodi       : echo "START_PRG=kodi" > /opt/tmp/switch_kodi_vdr
```

## Das Verzeichnis-Layout und Dateien

- ```/usr/local/lib``` or ```/opt/vdr/lib```<br>
  contains libraries which are usually not part of CoreELEC
- ```/usr/local/vdr``` or ```/opt/vdr/```<br>
  contains VDR and all plugins
- ```/usr/local/vdr-2.6.1/config``` or ```/storage/.config/vdropt/```<br>
  contains the default configuration files  
- ```storage/.config/vdropt```<br>
  contains the VDR and plugin configuration files. Will never be overwritten by the install process. 
- ```storage/.config/vdropt-sample```<br>
  contains sample configuration files

## Start VDR
### \<bindir\>/start_vdr.sh 
Reads the file ```/storage/.config/vdropt/enabled-plugins``` which contains a plugin name on each line and starts VDR 
with all enabled plugins. The plugin configuration are read from ```/storage/.config/vdropt/*.conf```.
### \<bindir\>/start_vdr_easy.sh
Uses the plugin vdr-plugin-easyvdr (see https://www.gen2vdr.de/wirbel/easyvdr/index2.html) to start VDR. 
The configuration entries can be found in the ```/storage/.config/vdropt/*_settings.ini```.
Plugins can be started/stopped at runtime via the OSD.
Additionally the command line tool easyvdrctl.sh (which uses easyvdrctl) can be found in the &lt;bindir&gt;.

## LD_PRELOAD
The VDR start scripts adds the mandatory library /usr/lib/libMali.so to LD_PRELOAD. It is possible to add other libraries if needed
by setting a variable in ```/storage/.profile```
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
