# Linux (Arch) installation on a Raspberry Pi

1. Follow these instructions: http://archlinuxarm.org/platforms/armv6/raspberry-pi
2. `pacman -S base-devel ntp git sshfs keychain kodi-rbp lsb-release bluez bluez-firmware bluez-utils ufw`
3. Install `afuse` from AUR.
4. Allow users in the group `wheel` to use `sudo`:
    - `visudo` 
    - Uncomment: `%wheel ALL=(ALL) ALL`
5. `useradd -G wheel users -m pi`
6. `passwd pi`
7. Create SSH keys for user `pi`:
    - `ssh-keygen -t rsa -b 8192`
    - Distribute the public key.
8. Enable bluetooth:
    - `systemctl start bluetooth`
    - `systemctl enable bluetooth`
    - Use `bluetoothctl` to add bluetooth devices e.g., a keyboard.
9. Setup locale:
    - `nano /etc/locale.gen`
    - Uncomment: `en_US.UTF-8 UTF-8`
    - `locale-gen`
10. Setup the timezone and NTP: 
    - `timedatectl set-timezone Europe/Amsterdam`
    - `systemctl enable ntpd`
    - `systemctl start ntpd`
11. Setup a firewall:
    - `sudo systemctl enable ufw`
    - `sudo systemctl start ufw`
    - `sudo ufw enable`
    - `sudo ufw allow SSH`
    - `sudo ufw allow 8080`
12. Enable automatic login:
    - `systemctl edit getty@tty1`
    - Add:  
        `[Service]`  
        `ExecStart=`  
        `ExecStart=-/sbin/agetty --autologin pi --noclear %I 38400 linux`
