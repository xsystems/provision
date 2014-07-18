# Install and Setup a Minimal Ubuntu 

System: [Thinkpad T500][1]

---
## Install
1. Get the Ubuntu ISO from [this][2] page.
2. Burn it onto a disk.
3. Follow the "normal" installation procedure.
4. At the end choose "manual package selection".

---
## Setup

### Window Manager (without Display Manager) and Extensions
We will install "[awesome][3]" as our window manager and will use bash to start "awesome" and also add some extensions.		

    apt-get install awesome
    apt-get install awesome-extra
    apt-get install xinit
    apt-get install vlock
    apt-get install xterm
    apt-get install policykit-desktop-privileges
    apt-get install gnome-keyring
    apt-get install xscreensaver
    
    update-alternatives --config x-terminal-emulator
    
Choose the *uxterm* terminal emulator.

Add the following at the bottom of the *~/.profile* file:

    eval $(killall ssh-agent & ssh-agent)

    if [[ -z $DISPLAY ]] && ! [[ -e /tmp/.X11-unix/X0 ]] && (( EUID )); then
        while true; do
            read -p 'Do you want to start X? (y/n): '
            case $REPLY in
                [Yy]) exec nohup startx > .xlog & vlock ;;
                [Nn]) break ;;
                *) printf '%s\n' 'Please answer y or n.' ;;
            esac
        done
    fi

Add the following at the bottom of the *~/.xinitrc* file (if it doesn't exist create it and also add `#!/bin/sh` to the top of the file):

    # Start a Console Kit session and  DBUS session
    eval $(ck-launch-session dbus-launch --auto-syntax --exit-with-session)

    # Start GNOME Keyring
    eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets)
    export GPG_AGENT_INFO
    export GNOME_KEYRING_CONTROL
    export GNOME_KEYRING_PID

    # Start Awesome WM
    exec awesome

If you get the following error when trying to start X:

    X: user not authorized to run the X server, aborting.

Then, either put the following in (or alter) the */etc/X11/Xwrapper.config* file:
    
    allowed_users=anybody

Or (preferably) run:

    dpkg-reconfigure x11-common

And select *Anybody* in the menu.

#### Look & Feel

##### Colered Xterm
Put the following line near the top of your *.bashrc*:

    # Enable xterm-colors
    export TERM="xterm-color"

##### Awesome Config and Theme

First put the folder *install* in your *~/* folder. Then, create the following link in the *~/.config/* folder:

    ln -s ~/install/awesome awesome
    

Next, check if any (absolute) paths need to be updated in *~/install/awesome/rc.lua* and  *~/install/awesome/themes/information/theme.lua*.

Then install the following:

    apt-get install feh
    apt-get install xcompmgr
    apt-get install conky-std/precise-backports
    apt-get install curl

To setup "Conky" first create the following links in the *~/.fonts* folder (if the folder  doesn't exist create it):

    ln -s ~/install/conky/fonts/openlogos.ttf
    ln -s ~/install/conky/fonts/ConkyWeather.ttf

To setup weather information, go to the folder *~/install/conky/accuweather/* and replace in the file *accuw_int_cwfont* my location's 
address at the address variable with yours. You can find your location as follows: Go to [AccuWeather](http://www.accuweather.com) type in your location 
and press enter. Then make the script executable. Either by right clicking it or by:

    chmod +x ~/accuweather/accuw_int_cwfont
    

NOTE: It is necessary to install "conky-std/precise-backports" due to bug: <https://bugs.launchpad.net/ubuntu/+source/conky/+bug/1003727> .     
NOTE: The compositing manager "xcompmgr" is chosen over "[Unagi][4]" due to error output when using "Unagi" and also because that Conky's
transparency only seemed to work with "xcompmgr".

##### GTK Theme
    apt-get install lxappearance
    apt-get install human-theme
    apt-get install gnome-themes-standard

This should also install *dmz-cursor-theme*, otherwise:

    apt-get install dmz-cursor-theme

Run *lxappearance* to change the theme, icon themen and cursor theme amongst other options.

NOTE: The default theme settings might lack some e.g. icons, which cause some program (e.g. "PCmanfm") to also lack some icons. The above steps solve this.

##### Key Bindings
    apt-get install xvkbd

Use the *xev* tool. Obtain XF86-key and make a rule in awesome's rc.lua.

!!!! NOT FINISHED


### Automounting
See, the Utilities/Applications/Filemanager for an (easy) method to set this up.

### Bluetooth
    apt-get install bluez
    apt-get install blueman

### Wireless Networking
    apt-get install network-manager-gnome
    adduser username netdev

To allow normal users to use (all functios of) nm-applet there needs to be a PolicyKit policy. This policy  must be placed in the folder: */etc/polkit-1/localauthority/50-local.d/*. 
In this folder create a file named *org.freedesktop.NetworkManager.pkla* or any other name ending with *.pkla*. Place in this file the following content:

    [nm-applet]
    Identity=unix-group:netdev
    Action=org.freedesktop.NetworkManager.*
    ResultAny=yes
    ResultInactive=yes
    ResultActive=yes

NOTE: Make sure the user in question is added to the *netdev* group.    
NOTE: When starting up takes about 2 minutes and you see a message similar as: "Waiting For Network Configuration ... Waiting up to 60 more seconds for the network configuration". 
Then comment out in the file */etc/network/interfaces* all interfaces except the *loopback* interface, so:

    # The primary network interface
    auto eth0
    iface eth0 inet dhcp

Will become:

    # The primary network interface
    #auto eth0
    #iface eth0 inet dhcp

NOTE: We use "network-manager-gnome" instead of "wicd" (beside it being more versatile) because of the problem/bug described in the section *Utilities/System/Powersaving*.

### Video
The "xserver-xorg-video-radeon" driver is installed by default. This driver supports RandR, a frontend for this is "arandr", to install run:

    apt-get install arandr

#### Powersaving & Overheating Fix

To control [graphics card powersaving][7] / [fix an overheating bug][8], add the following two lines to the */etc/rc.local* file:

    echo profile > /sys/class/drm/card0/device/power_method
    echo mid > /sys/class/drm/card0/device/power_profile

### Audio
    apt-get install pulseaudio
    apt-get install "pulseaudio-*"
    adduser username audio
    adduser username pulse-access
    apt-get install pavucontrol
    apt-get install alsa-utils

### Printing & Scanning

To set up printing, run:

    apt-get install cups
    apt-get install system-config-printer-gnome

Then (if needed) install the driver from *~/install/drivers* or from the printers website.


### Smart Card
    apt-get install libpcsclite1 pcscd pcsc-tools

#### Gemplus GemPC Card (PCMCIA)

Insert the reader in the PCMCIA slot and run:

    dmesg

You should get output similar to the following, note the tty:

    [ 1285.020110] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted into slot 0
    [ 1285.020492] pcmcia 0.0: pcmcia: registering new device pcmcia0.0 (IRQ: 3)
    [ 1285.021795] serial_cs 0.0: trying to set up [0x0157:0x0100] (pfc: 0, multi: 0, quirk:   (null))
    [ 1285.021863] serial_cs 0.0: speaker requested, but PRESENT_STATUS not set!
    [ 1285.063765] 0.0: ttyS2 at I/O 0x3e8 (irq = 3) is a 16450

If you do not get a line similar to the last line in the previous output, then edit the file */etc/pcmcia/config.opts*.
Try commenting out the lines similar to:

    include port 0x100-0x3af

If this solves the problem, then try uncommenting as many of those lines as possible, since something else may depend on them.

Next, edit */etc/reader.conf.d/libccidtwin* to add the following lines: 

    FRIENDLYNAME      "GemPCTwin serial"
    DEVICENAME        /dev/ttyS2
    LIBPATH           /usr/lib/pcsc/drivers/serial/libccidtwin.so
    CHANNELID         2

Followed by:

    service pcscd restart

Now run:

    pcsc_scan

If the reader is recognised and the events of inserting and removing a card are fired, then it works, else edit */lib/udev/rules.d/92-libccid.rules* to add the following lines:

    SUBSYSTEMS=="pcmcia", DRIVERS=="serial_cs", ACTION=="add", ATTRS{prod_id1}=="Gemplus", ATTRS{prod_id2}=="SerialPort", ATTRS{prod_id3}=="GemPC Card", GROUP="pcscd", RUN+="/usr/sbin/pcscd --hotplug" 

### Fingerprint

#### Ubuntu 12.04

Follow the instructions on these pages:

-   <https://launchpad.net/~fingerprint/+archive/fprint>
-   <http://www.thinkwiki.org/wiki/How_to_enable_integrated_fingerprint_reader_with_fprint>

In short, run these commands:

    add-apt-repository ppa:fingerprint/fprint
    apt-get update
    apt-get upgrade
    apt-get install libfprint0 fprint-demo libpam-fprintd gksu-polkit

### Mobile broadband $ GPS

#### Mobile broadband
    adduser username dialout
    adduser username dip
    
#### GPS
    TODO!!!

---
## Scripts
The following utilities might be needed by a script:

    apt-get install nmap

To make scripts globally executable make the following link:

    ln -s ~/install/bin ~/bin

Also when adding additional scripts, put them in the folder called *~/install/scripts* and make a symbolic link to them in the *~/install/bin* folder.

---
## Utilities
This sections covers most basic utilities you need.

### Security
This section covers anti-virus and firewall software.

#### Firewall
The "ufw" firewall is installed by default.

#### Anti-virus
To install a (free and opensource) anti-virus program run:

    apt-get install clam-av

#### Login
    apt-get install openssh-server
    apt-get install ssh-askpass-gnome

### System
This section covers application closely related to the system.

#### System Monitor
    apt-get install htop

#### Sensors
    apt-get install lm-sensors

#### Powersaving
    apt-get install acpi-support
    apt-get install pm-utils
    apt-get install laptop-mode-tools
    apt-get install cpufrequtils
    apt-get install powertop
    
    adduser username power

If you encounter one of the following errors when rebooting or shutting down after installing these packages:

-   irq 16 : nobody cared (try booting with the "irqpoll" option)
-   Disabling IRQ 16

Then this is probably caused by a combination of "laptop-mode-tool", wake-on-lan, and "Wicd" as is discussed [here][9]. 
This can be solved by either disabling wake-on-lan in the BIOS, not using "Wicd" or not using "laptop-mode-tools".


#### Miscellaneous
    apt-get install sshfs
    apt-get install autossh
    apt-get install davfs2
    apt-get install synaptic
    apt-get install gparted
    apt-get install dconf-tools
    
    adduser username davfs2


### Back Up
    apt-get install seahorse
    apt-get install deja-dup
    
Setup "Deja-Dup":

At the "Storage" tab select *SSH* as the backup location and fill in the appropriate details.    
At the "Schedule" tab select *Daily* and *At least two months*.
At the "Folders" tab select as folders to backup:

-   /
-   /home/kboes
-   /media/data

And as folders to exclude from the backed up folders:

-   /dev
-   /home
-   /lost+found
-   /media
-   /mnt
-   /proc
-   /run
-   /sys
-   /tmp
-   /home/kboes/downloads
-   /media/data/projects/wh_data

At the "Overview" tab turn *Automatic backups* on.

### Applications
This section covers common applications.

#### Webbrowser
    apt-get install firefox
    apt-get install flashplugin-installer

#### Filemanager
    apt-get install pcmanfm
    apt-get install xarchiver
    apt-get install rar unrar-free
    apt-get install gnome-menus
    
    adduser username plugdev

Go to the folowing PCmanfm menu: *Edit/Preferences/Advanced*. Set *Terminal Emulator* to *uxterm -e %s* and 
select *xarchiver* under the *Archiver integration* option.

To enable automounting in combination with this filemanager there needs to be a PolicyKit policy. This policy 
 must be placed in the folder: */etc/polkit-1/localauthority/50-local.d/*. In this folder create a file named
*plugdevconf.pkla* or any other name ending with *.pkla*. Place in this file the following content:

    [Storage Permissions]
    Identity=unix-group:plugdev
    Action=org.freedesktop.udisks.filesystem-mount;org.freedesktop.udisks.drive-eject;org.freedesktop.udisks.drive-detach;org.freedesktop.udisks.luks-unlock;org.freedesktop.udisks.inhibit-polling;org.freedesktop.udisks.drive-set-spindown
    ResultAny=yes
    ResultActive=yes
    ResultInactive=no

NOTE: Make sure the user in question is added to the *plugdev* group.   
NOTE: If the *Applications* menu shows nothing then try deleting the one or both of the following folders:

-   *~/.local/share/applications/*
-   *~/.cache/menus/*
		
#### Editing & Viewing
    apt-get install markdown
    apt-get install xclip
    apt-get install evince-gtk
    apt-get install leafpad
    apt-get install libreoffice

##### Nano
To enable syntax highlighting in the editor "nano" first create a directory called */.syntax_highlighting* 
in your *home* directory. Next, download the files "[markdown.nanorc][5]" and ["lua.nanorc"][6] to this
folder. After this, create a file called *.nanorc* in your *home* directory and put the following in it:

    set tabsize 4
    set tabstospaces

    include "/usr/share/nano/c.nanorc"
    include "/usr/share/nano/java.nanorc"
    include "/usr/share/nano/awk.nanorc"
    include "/usr/share/nano/css.nanorc"
    include "/usr/share/nano/html.nanorc"
    include "/usr/share/nano/makefile.nanorc"
    include "/usr/share/nano/man.nanorc"
    include "/usr/share/nano/php.nanorc"
    include "/usr/share/nano/python.nanorc"
    include "/usr/share/nano/sh.nanorc"
    include "/usr/share/nano/tex.nanorc"
    include "/usr/share/nano/xml.nanorc"
    include "~/.syntax_highlighting/lua.nanorc"
    include "~/.syntax_highlighting/markdown.nanorc"

##### Less
To enable syntax highlighting in the paging program "less" first install the package *source-highlight*:

    apt-get install source-highlight

Next, add the following lines to the top of your *.bashrc*:

    # Less source-highlight
    export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
    export LESS=' -R '

And (if present) comment the following line (otherwise it interferes with the syntax highlighting):

    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

Like so:

    #[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

To enable colored man pages (man uses less) also add the following to the top of your *.bashrc*:

    # Less Colors for Man Pages
    export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
    export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
    export LESS_TERMCAP_me=$'\E[0m'           # end mode
    export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
    export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
    export LESS_TERMCAP_ue=$'\E[0m'           # end underline
    export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline


#### Programming

##### Programming Languages

To set up "Java" run this:

    apt-get install openjdk-6-jdk

and put the following in the *~/.bashrc* file:

    export JAVA_HOME=/usr/lib/jvm/default-java
    export JDK_HOME=/usr/lib/jvm/default-java
    export PATH=$PATH:$JAVA_HOME/bin

To install "Lua" run:

    apt-get install lua5.2

Also, to use the SDK's in the folder *~/install/sdk* follow the explanation in the *Scripts* section and substitute the folder *~/install/scripts* with *~/install/sdk* 
and add the following to the *~/.bashrc* file:

    export HADOOP_HOME=$HOME/sdk/hadoop
    export PATH=$PATH:$HADOOP_HOME/bin

    export PIG_HOME=$HOME/sdk/pig
    export PATH=$PATH:$PIG_HOME/bin
    export PIG_CLASSPATH=$HADOOP_HOME/conf

To install "Python" run:

    apt-get install python3

##### Programming environment
    apt-get install sqlite3
    apt-get install mysql-server

    apt-get install php5 
    apt-get install php5-sqlite    
    apt-get install php5-mysql
    apt-get install php5-gd

    apt-get install apache2
    apt-get install libapache2-mod-php5
    
##### Version Control
    apt-get install git-all
    apt-get install subversion
    apt-get install mercurial
    apt-get install mercurial-git
    
To setup git, see the "[Pro Git][10]" book

#### Miscellaneous    
    apt-get install x11-apps


#### Disk Authoring & Reading
    
    apt-get install lame
    apt-get install cdda2wav
    apt-get install cdrecord
    apt-get install mkisofs

    apt-get install fuseiso
    adduser username fuse

#### Music
    apt-get install flac
    apt-get install moc
    apt-get install moc-ffmpeg-plugin

#### Video
    apt-get install ubuntu-restricted-extras
    apt-get install mplayer2

Add the following to the *~/.mplayer/config* file:

    stop-xscreensaver=1
    monitoraspect=16:9
    cache=8192

To play DVDs just run "mplayer" on all the (.vob) files at ones or see <https://wiki.archlinux.org/index.php/DVD_Playing> for more information.


[1]:    http://www.thinkwiki.org/wiki/Category:T500                                 "Thinkpad T500"
[2]:    https://help.ubuntu.com/community/Installation/MinimalCD/                   "Minimal Ubuntu"
[3]:    http://awesome.naquadah.org/                                                "Awesome"
[4]:    http://unagi.mini-dweeb.org/                                                "Unagi"
[5]:    https://raw.github.com/serialhex/nano-highlight/master/markdown.nanorc      "markdown.nanorc"
[6]:    http://lua-users.org/files/wiki_insecure/editors/lua.nanorc                 "lua.nanorc"
[7]:    http://www.x.org/wiki/RadeonFeature#KMS_Power_Management_Options            "KMS_Power_Management_Options"
[8]:    https://wiki.archlinux.org/index.php/ATI#Powersaving                        "ATI#Powersaving"
[9]:    https://bbs.archlinux.org/viewtopic.php?pid=1052099                         "laptop-mode/wake-on-lan/wicd can't shutdown"
[10]:   http://git-scm.com/book                                                     "Pro Git book"
