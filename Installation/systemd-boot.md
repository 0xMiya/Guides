# Systemd-boot

## Installation

* Mount the ESP to /mnt/boot  

		mkdir /mnt/boot
		mount /<esp> /mnt/boot
	
* chroot into the new system
	
		arch-chroot /mnt
		
* Configure systemd-boot

		bootctl --path=/boot install
		vim /boot/loader/loader.conf
		----------------------------
			timeout 30
			console-mode max
			default arch.conf
		----------------------------
		
		vim /boot/loader/entries/arch.conf
		----------------------------------
			title	Arch Linux
			linux	/vmlinuz-linux
			initrd	/initramfs-linux.img
			options	root=/dev/sda2 rw
		----------------------------------
		
Note: If you installed another kernel, your files may have other names. To get the correct name, run 'ls /boot'.  
For example if you installed the lts kernel, the names will be "vmlinuz-linux-lts" and "initramfs-linux-lts.img"

In the example above I specified the root partition using the name (/dev/sda2). You can use the UUID or PARTUUID instead:

* Get the UUID/PARTUUID
	
		blkid /dev/<root-partition> # Or use:
		lsblk -af
		
* Using the UUID

		options root=UUID=<uuid> rw
		
* Using the PARTUUID

		options root=PARTUUID=<partuuid> rw

### Enable microcode updates

If you have an amd or intel cpu, it is recommended to enable microcode updates

	pacman -Suy amd-ucode # or intel-ucode

Add the initrd ***above*** the second intird:

	vim /boot/loader/entries/arch.conf
	----------------------------------
		title	Arch Linux
		linux	/vmlinuz-linux
		initrd	/amd-ucode.img # Place it above the other intird! (intel: intel-ucode.img)
		initrd	/initramfs-linux.img
		options	root=/dev/sda2 rw
	----------------------------------

## Usage

### Keys

* Up/Down - select entry
* Enter - boot selected entry
* d - select the default entry to boot
* -/T - decrease the timeout
* +/t - increase the timeout
* e - edit the kernel command line. Has no options if the *editor* config option is set to *0*
* v - show systemd-boot and uefi version
* Q - quit
* P - print current configuration
* h/? - help

Hotkeys:

* l - boot linux
* w - boot windows
* a - boot os x
* s - efi shell
* 1-9 - boot number of entry

### Tips & Tricks

* Choose where to boot directly after a reboot

		systemctl reboot --boot-loader-entry=<entry>
		systemctl reboot --boot-loader-entry=help
		
* Boot into the firmware of your motherboard

		systemctl reboot --firmware-setup
		