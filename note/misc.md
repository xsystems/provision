# Miscellaneous Setup

## Add an user

    useradd --create-home --gid users USERNAME
    passwd USERNAME

### Allow users in the group *wheel* to gain root privileges

Install the *sudo* utility:

    pacman -S sudo

Then edit the file */etc/sudoers* by uncommenting the line: ``%wheel ALL=(ALL) ALL``. Do this by means of *visudo*.

Finally, add users to the group *wheel*, like so:

    usermod --append --group wheel USERNAME


## Time

Set the hardware clock to being in UTC:
    
    timedatectl set-local-rtc false 
    
### Synchronize the software clock with internet time servers.    

Install the *ntp* utility:

    pacman -S ntp

Enable the *ntp daemon*, now and on subsequent boots:
    
    systemctl enable ntpd
    systemctl start ntpd


## Firewall

Install and enable the *ufw* utility:

    pacman -S ufw
    ufw enable


## Bluetooth:

### Installation

    pacman -S bluez bluez-libs bluez-utils

### Setup

Enable bluetooth on subsequent boots:    

    systemctl enable bluetooth
    systemctl start bluetooth

Next, create the file */etc/udev/rules.d/10-local.rules* with the following content:

    # Set bluetooth power up
    ACTION=="add", KERNEL=="hci0", RUN+="/usr/bin/hciconfig hci0 up"


## Sound

### Advanced Linux Sound Architecture (ALSA)
Install the following utilities:

    pacman -S alsa-utils 

Enable, the following kernel module to emulate the OSS mixer device */dev/mixer*, under ALSA.

    modprobe snd-mixer-oss

Then, execute ``alsamixer`` and unmute the sound and if neccesairy encrease the volume.

### Pulse Audio

    pacman -S pulseaudio pulseaudio-alsa pavucontrol

### Music On Console (MOC)

    pacman -S moc faad2 wavpack libmpcdec taglib


## Graphics

### Video Drivers and Window Manager (Awesome)

Install Xorg, video drivers, and a window manager:

    pacman -S xorg-server xorg-xinit xorg-xrdb xorg-xset xorg-xprop xterm xbindkeys xf86-video-intel libva-intel-driver mesa-vdpau  
    pacman -S awesome conky  xcompmgr xscreensaver     
    pacman -S gtk3 gnome-themes-standard gtk-aurora-engine lxappearance ttf-ubuntu-font-family

### MPV

    pacman -s mpv


## Webbrowser

    pacman -S firefox gstreamer0.10-ffmpeg flashplugin


## Devices and Files

    usermod -aG disk kboes
    pacman -S udiskie ecryptfs-utils autofs

    mount -o umask=227,gid=6,ro,loop,offset=$((512*85594446)) /media/data/backup/kboes/laptop/ssd/sdd_120GB.img /media/mnt0/
    mount -o ro,loop,offset=$((512*156315648)) /media/data/backup/kboes/laptop/ssd/sdd_120GB.img /media/mnt1/
    ecryptfs-recover-private .Private/


## Utilities

### General

    pacman -S htop feh rsync markdown source-highlight git unzip unrar lsb-release screen pkgtools mlocate mtr curl dnsutils

### Sensors

Install:

    pacman -S hddtemp lm_sensors 

Enable, access to HDD temperatures via an TCP/IP requests, now and on subsequent boots:

    systemctl start hddtemp
    systemctl enable hddtemp

Detect hardware sensors, load their kernel modules and enable a daemon providing sensor data:

    sensors-detect

Control the speed and sound of CPU/case fans: 

    systemctl start fancontrol
    systemctl enable fancontrol

