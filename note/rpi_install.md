1. Follow these instructions: http://archlinuxarm.org/platforms/armv6/raspberry-pi
2. pacman -S sudo git
3. visudo # uncomment `%wheel ALL=(ALL) ALL`
4. useradd -G wheel -m pi
5. passwd pi
6. 