# Linux (Arch) installation on a BIOS system using GPT, GRUB, LVM, and LUKS

## Preparations

### Prepare Installation medium and backup data
- Download an Arch Linux image and transfer it to your installation medium (CD, USB, etc.).
- Backup all data (worth backing up).

### Prepare Keyfile USB-stick
**An empty USB-stick is assumed, i.e. the operations below DO NOT preserve the data on the USB-stick.**

First, create the partition, labeled *key*, that will hold the key(s) on the USB-stick (say, ``/dev/sdb``), type:

    gdisk /dev/sdb

Now, press ``o``.  
Next, press ``n`` and answer:

> ``ENTER``  
> ``ENTER``  
> ``+100M ENTER``  
> ``ENTER``  

Finally, press ``w``.

Subsequently, execute:

    mkfs -t ext4 /dev/sdb1
    e2label /dev/sdb1 key

Second, mount and change to that partion, and generate the key file e.g., like this:

    mkdir luks
    head -c 1024 /dev/random > luks/root


## Installation
Start the installation by booting from the installation medium. When a menu appears select something simalir to "Boot Arch Linux".
Once booted in the installation environt, it is assumed that a network connection is automatically established via DHCP, if not see [this][arch_install_internet].

### Partitioning
**An empty harddisk is assumed, i.e. the operations below DO NOT preserve the data on the harddisk.**

Start partitioning harddisk (say, ``/dev/sda``), like so:

    gdisk /dev/sda

Delete any existing partition table by pressing ``o`` and answering ``Y``.

#### Create the BIOS Boot Partition (BBP) on the harddisk. 

Adjust the alignment value in the experts menu. Enter this menu by pressing ``x``. Then, press ``l`` and answer ``1``. Exit the experts menu again by pressing ``m``.

Now, to create the BBP, press ``n`` and answer:

> ``ENTER``  
> ``ENTER``  
> ``+1007K ENTER``  
> ``ef02 ENTER``  

Finally, revert the alignment value. Press subsequently: ``x``, ``l``, ``ENTER``, and ``m``.

#### Create the LVM Partition

To create the LVM partition, press ``n`` and answer:

> ``ENTER``  
> ``ENTER``  
> ``ENTER``  
> ``8e00 ENTER``  

Finally, press ``w``.

### Setting up LVM

    pvcreate --dataalignment 1m /dev/sda2
    vgcreate vg00 /dev/sda2
    lvcreate -L 1G  vg00 -n boot
    lvcreate -L 20G vg00 -n root

### Setting up the LUKS Root Partition

Insert the USB-stick and mount the *key* partition to ``/key``, then execute:  

    cryptsetup -v --key-size 512 --hash sha512 --use-random luksFormat /dev/mapper/vg00-root /key/luks/root
    cryptsetup --key-file /key/luks/root open /dev/mapper/vg00-root root

### Create the Filesystems on Root and Boot then Mount the Partitions

Execute:

    mkfs -t ext4 /dev/mapper/root
    mkfs -t ext4 /dev/mapper/vg00-boot
    mount /dev/mapper/root /mnt
    mkdir /mnt/boot
    mount /dev/mapper/vg00-boot /mnt/boot

### Base Installation & Configuration

#### Base Installation

Move your prefered mirrors (e.g., the local mirrors) in ``/etc/pacman.d/mirrorlist`` to the top in order of their score (lower is better).

    pacstrap -i /mnt base
    genfstab -p /mnt >> /mnt/etc/fstab
    arch-chroot /mnt /bin/bash

#### Configuration

##### Locale

In ``/etc/locale.gen`` uncomment ``en_US.UTF-8 UTF-8`` and then execute:

    locale > /etc/locale.conf
    locale-gen

##### Time

Set the timezone:

    cd /etc
    ln -s ../usr/share/zoneinfo/Europe/Amsterdam localtime

Set the hostname:

    echo xsystems-laptop00 > /etc/hostname

##### Networking

    systemctl enable dhcpcd
    pacman -S iw wpa_supplicant

Create ``/etc/wpa_supplicant.conf`` and add:

    ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel
    update_config=1

Change the permissions of ``/etc/wpa_supplicant.conf``:

    chmod 640 /etc/wpa_supplicant.conf

Now run ``wpa_passphrase YOUR_SSID YOUR_PASSPHRASE`` and append its output to ``/etc/wpa_supplicant.conf``, the output should look like:

    network={
        ssid="YOUR_SSID"
        psk="YOUR_PSK"
    }

##### Initial Ramdisk Environment

Modify the initial ramdisk environment by editing ``/etc/mkinitcpio.conf`` so that on the HOOKS-line ``lvm2`` and ``encrypt`` appear after ``block`` and before ``filesystems``, like so:

    HOOKS="base udev autodetect modconf block lvm2 encrypt filesystems keyboard fsck"

Now, recreate the initial ramdisk environment by executing:

    mkinitcpio -p linux

##### Bootloader

Install: 

    pacman -S gptfdisk grub

Then run:

    grub-install --target=i386-pc --recheck --debug /dev/sda

Configure the bootloader by adding to the GRUB\_CMDLINE\_LINUX-line in ``/etc/default/grub`` the following:

    cryptdevice=/dev/mapper/vg00-root:root cryptkey=/dev/disk/by-label/key:ext4:/luks/root

If the quotes were empty it would look like this:

    GRUB_CMDLINE_LINUX="cryptdevice=/dev/mapper/vg00-root:root cryptkey=/dev/disk/by-label/key:ext4:/luks/root"

Also, uncomment the following line:

    GRUB_DISABLE_LINUX_UUID=true

Then, execute (ingnore LVM errors):

    grub-mkconfig -o /boot/grub/grub.cfg

##### Root Password

Set the root password by executing:

    passwd

#### Wrap Up

Exit the chroot-environment and unmount the partitions then reboot, like so:

    exit
    umount -R /mnt /key
    reboot

### Setting up the Home Partition

    mkdir -p /etc/key/luks
    head -c 1024 /dev/random > /etc/key/luks/home
    lvcreate -L 60G vg00 -n home
    cryptsetup -v --key-size 512 --hash sha512 --use-random luksFormat /dev/mapper/vg00-home /etc/key/luks/home
    cryptsetup --key-file /etc/key/luks/home open /dev/mapper/vg00-home home
    mkfs -t ext4 /dev/mapper/home
    mount /dev/mapper/home /home

Edit ``/etc/crypttab`` by adding the following line:

    home    /dev/mapper/vg00-home    /etc/key/luks/home

Edit ``/etc/fstab`` by adding the following line:

    /dev/mapper/home    /home    ext4    defaults    0 2

### Setting up swap

Execute:

    fallocate -l 512M /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile

Edit ``/etc/fstab`` by adding the following line:

    /swapfile none swap defaults 0 0


[arch_install_internet]: https://wiki.archlinux.org/index.php/Beginners%27_Guide#Establish_an_internet_connection (Arch Installation - Establish an Internet Connection)

