# AstroPi Installation instructions

1. Follow installation instructions here: https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4
    1. Format SD card `fdisk /dev/sdX`
        1. Type `o`. This will clear out any partitions on the drive.
        1. Type `p` to list partitions. There should be no partitions left.
        1. Type `n`, then `p` for primary, `1` for the first partition on the drive, press ENTER to accept the default first sector, then type `+200M` for the last sector.
        1. Type `t`, then `c` to set the first partition to type `W95 FAT32 (LBA)`.
        1. Type `n`, then `p` for primary, `2` for the second partition on the drive, and then press ENTER twice to accept the default first and last sector.
        1. Write the partition table and exit by typing `w`.
    1. Create and mount FAT filesystem
        ```
        mkfs.vfat /dev/sdX1
        mkdir boot
        mount /dev/sdX1 boot
        ```
	1. Create and mount the ext4 filesystem:
		```
		mkfs.ext4 /dev/sdX2
		mkdir root
		mount /dev/sdX2 root
		```
	1. Download and extract the root filesystem (as root, not via sudo): 
		```
		wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz
		bsdtar -xpf ArchLinuxARM-rpi-armv7-latest.tar.gz -C root
		sync
		```
	1. Move boot files to the first partition: 
		```
		mv root/boot/* boot
		```
	1. Unmount the two partitions: 
		```
		umount boot root
		```
1. Unplug the SD card and plug it into your raspberry pi and boot it up.
1. You can now connect through `ssh` using user `alarm` and password `alarm`. Root password is `root`
1. Initialize the pacman keyring and populate the Arch Linux ARM package signing keys: 
	```
	pacman-key --init
	pacman-key --populate archlinuxarm
	```
1. Follow chapter 3 "Configure the system" here: [Arch Linux Instructions](https://wiki.archlinux.org/title/Installation_guide#Time_zone) starting from "Time zone"
1. Repeat steps above for the attached USB SSD directly from the Raspberry PI
1. Replace boot device in fstab: `sed -i 's/mmcblk0p/sda/g' root/etc/fstab`
1. ```
umount /mnt/boot
mount /dev/sda1 /mnt/root/boot
arch-chroot /mnt/root
pacman -Syu
vi /etc/mkinitcpio.conf
# modify mkinitcpio.conf so MODULES=(pcie_brcmstb) to enbale boot from USB device
mkinitcpio -P
exit
poweroff

```
1. remove micro sd card and reboot (should now boot from USB SSD)
1. Install necessary software: `pacman -Sy vim git sudo`
1. Setup your personal user with password `useradd -m <username>`, change the root password to something more secure and delete the existing
   user `userdel alarm -f`
1. Adjust `/etc/sudoers` to whitelist your personal user
1. Close ssh session and login with your new personal user
1. Clone and install the dotfiles:
	1. `mkdir packages`
	1. `cd packages`
	1. `git clone https://github.com/RononDex/dotfiles`
	1. `cd dotfiles`
	1. `bash ./profile-enabler.sh`
	1. Select the AstroPi profile

