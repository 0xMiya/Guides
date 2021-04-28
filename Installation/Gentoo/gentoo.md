# Gentoo Installation Guide

## Setup

### Download

[Download](https://www.gentoo.org/downloads/) the amd64 iso.

Note: If downloading from a mirror: 

	.iso				-> the iso file
	.iso.CONTENTS		-> lists the content of the iso file
	.iso.DIGESTS		-> contains the various hashes of the iso file
	.iso.DIGESTS.asc	-> contains various hashes and a cryptographic signature

### Verify the downloaded file

// TODO
	
### Create a bootable usb stick, in this example using "dd":
	
Prepare	 a usb:

	$ sudo fdisk -l		# find the correct device (/dev/sdx)
	$ mkfs.vfat /dev/<device> -I

Flash usb:

	$ sudo dd if=/<iso-file> of=/dev/<device> status=progress

Warning, there's a reason why dd is also called "Disk Destroyer"!

## Booting

### In a vm with qemu

	$ paru -S qemu edk2-ovmf			# ovmf is needed for uefi
	$ qemu-img create image.img 16G
	$ qemu-system-x86_64 -bios /usr/share/ovmf/x64/OVMF.fd -hda image.img -cdrom <iso> -m 4G -boot order=dc 

### On real hardware

* Insert the usb stick and reboot. In the motherboards firmware, select the usb to
boot from.

* You can tell Linux to boot directly into the UEFI/BIOS:

		sudo systemctl reboot --firmware-setup

* Select the kernel and options
	
	You need to be fast, because after a set timeout it will automatically continue using the default.
	
	To use the default just press \<Enter\> to select a kernel and boot options
	write "\<kernel\> \<options\>".

	Check the [gentoo installation guide](https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation#Booting) for 		a detailed list of options.

* Select keyboard layout

	For example 14 for dvorak

* Now you should have a root shell

### View the gentoo handbook during installation

* First create another user account

		useradd -mG users wiki	# create a user named wiki
		passwd wiki				# set a password for the user
	
	Change tty by pressing \<Alt+F2\>. (Press \<Alt+F1\> to go back)

* Alternatively use screen (already preinstalled) instead

* Open the wiki:

		links https://wiki.gentoo.org/wiki/Handbook:AMD64
	
## Network Configuration

### Automatic configuration

If you're connected via Ethernet to a LAN which has a DHCP Server (most modern router
already have one), it is most likely that networking has already been configured
manually. 

Check if the output lists an interface that has a local IP address associated to
it:

	ifconfig

Alternatively use the ip command:

	ip addr

### [Optional] Proxy configuration

If the internet is accessed through a proxy, export the needed variable:

	export http_proxy="http://<link>:<port>"	# For http
	export ftp_proxy="ftp://<link>:<port>"		# For ftp

If the proxy requires a username and password:

	export http_proxy="http://username:password@<link>:<port>"
	
### Configure an interface

If the interface wasn't setup automatically use:

	net-setup <interface>

### Manual configuration

If the above didn't work, you need to [manually configure the network](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Networking#Manual_network_configuration).

#### Very short and incomplete (really, just click the link above instead)

Network Item | Example        | Description
------------ | -------------- | -----------
System IP    | 192.168.1.2    | The computers local IP address
Netmask      | 255.255.255.0  | Divides the network into the network-part (255) and host-part (0)
Broadcast    | 192.168.1.255  | Highest host value in the network, send a message to every device in the LAN
Gateway      | 192.168.1.1    | Normally second lowest host value, the router itself (the lowest, 192.168.1.0 is the network itself)
Nameserver   | 9.9.9.9        | DNS, 9.9.9.9 belongs to Quad9

	IP address:    192      168      0         2
	            11000000 10101000 00000000 00000010
	Netmask:    11111111 11111111 11111111 00000000
	               255      255     255        0
	           +--------------------------+--------+
	                    Network              Host

* Assign an ip address

		ifconfig <interface> <ip-address> broadcast <broadcast-address> netmask <netmask> up

* Get an ip address from the dhcp server instead

		dhcpcd <interface>

		# if this doesn't work try:
		dhcpcd -HD <interface>

* Configure routing

		route add default gw <gateway>

* Configure nameserver

		vim /etc/resolv.conf
		--------------------
			nameserver 9.9.9.9
			nameserver 1.1.1.1
	
	You can configure multiple dns.

### Connect to wireless lan

	iw dev <wireless-interface> info

* Check for a current connection

		iw dev <interface> link

* Ensure the interface is active

		ip link set <interface> up

#### Connect to a network with a WEP key

Using a hex WEP key:

	iw dev <interface> connect -w <ESSID> key 0:d:<hex-WEP-key>

Using an ascii WEP key:

	iw dev <interface> connect -w <ESSID> key 0:<ascii-password>

#### Connect to a network with WPA or WPA2

wpa_supplicant has to be used instead

##### Using wpa_cli

	$ vim /etc/wpa_supplicant/wpa_supplicant.conf
	-------------------------------------------
		ctrl_interface=/run/wpa_supplicant
		update_config=1

	$ wpa_supplicant -B -i <interface> -c /etc/wpa_supplicant/wpa_supplicant.conf
	$ wpa_cli		# this opens an interactive prompt

	> scan			# scan for wlans
	> scan_results	# print found wlans
	> add_network	# Adds a network, will return a number
	> set_network <number> ssid <ssid>
	> set_network <number> psk <password>
	> enable_network <number>
	> save_config
	> quit
	$ dhcpcd wlan0

##### Using wpa_passphrase

	$ sudo -i	# this needs to run in a root shell (bc of process substitution)
	$ wpa_supplicant -B -i <interface> -c <(wpa_passphrase <ssid> <passwd>)

## Partitioning

### Block devices

Block devices represent an abstract interface to the disk. User programs can use
block devices to interact with the disk without worrying what type the disk is.
The program can simply address the storage on the disk as a bunch of contagious,
randomly-accessible 4096-byte (4KiB) blocks.

Device Type | Default device handle | Default partiton handle
----------- | --------------------- | -----------------------
SATA, SAS, SCSI, USB | /dev/sda     | /dev/sda1
NVMe        | /dev/nvme0n1          | /dev/nvme0n1p1
MMC, eMMC, SD | /dev/mmcblk0        | ?

### Partition tables

MBR (DOS disklabel) -> legacy BIOS boot  
GPT -> UEFI  

#### GUID Partition Table (GPT)

- uses 64bit identifiers for the partitions
- practically no limit for the amount of partitions
- size of a partition max. 8ZiB (Zebibytes)
- needed to use UEFI, MBR has compatibility issues
- checksumming and redundancy: uses CRC32 checksums to detect errors in the header
and partition tables and has a backup GPT at the end of the disk

It is possible to use GPT on a BIOS-based computer, but dual-booting Windows
won't be possible then. (Windows will boot in UEFI mode if it detects a GPT partition
label)

#### Master boot record (MBR) or DOS boot sector

- uses 32bit identifiers for the start sector and length of the partitions
- 3 partition types: primary, extended and logical
	- primary: information stored in the master boot record (due to its small size,
	only 4 primary partitions are supported)
	- To get more partitions, a primary partition can be marked as extended. This
	partition can then contain additional logical partitions (partitions within
	a partition)
- cannot address storage space that is larger than 2TiB
- does **not** provide a backup boot sector

***MBR is mostly considered "legacy" (supported, but not ideal). If possible, use
GPT.***

This guide will only use GPT. For MBR search another guide or read the official
gentoo installation wiki.

### Advanced Storage (LVM)

// TODO

### Partition Scheme

An example partition scheme:

Partition | Filesystem | Size | Description
--------- | ---------- | ---- | -----------
/dev/sda1 | Fat32 (UEFI) or ext2 (BIOS) | 256MiB - 512MiB | Boot/EFI system partition (ESP)
/dev/sda2 | (swap)     | RAM size*2 (Except you already have much ram) | Swap partition
/dev/sda3 | ext4       | Rest of the disk | Root partition

#### Designing a partition scheme

How to partition is highly dependent on the demands of the system.

For security, backups and maintenance reasons:  
Lots of users? -> seperate /home  
Mail server? -> seperate /var  
Game server? -> seperate /opt  

/usr and /var should be kept relatively large in size.  
/usr -> the majority of applications  
/usr/src -> Linux kernel sources  
/var -> Gentoo ebuild repository (/var/db/repos/gentoo)  
/var/cache/distfiles and /var/cache/binpkgs -> source files and binary packages  

Security can be enhanced by mounting some partitions read-only:

	nosuid # setuid bits are ignored
	noexec # executable bits are ignored

etc.

### Swap Space

Allows the kernel to move pages that are not likely to be accessed soon to disk
(page-out). Of course if the pages are needed, they will need to be put back in
memory (page-in) which will take [considerably longer](https://computers-are-fast.github.io/)
than reading from RAM.

If a system has lots of RAM available, not much swap space is needed. However in
case of hibernation, the *entire* contents of memory are stored in swap. If the
system requires support for hibernation, at least as much swap space as memory
has to be available.

- For systems with multiple hard disk, it is recommended to create a swap partition
- foreach disk.  
- Swap on an SSD will have better performance than on a HDD.  
- Also swap files can be used instead of swap partitions.  
- When using systemd, you can also use systemd to automatically handle swap.

### EFI System Partition (ESP)

With UEFI a ESP is required. It has to be formatted as either FAT12, FAT16 or
FAT32 (recommended).

If the ESP is not formatted with a FAT variant, the UEFI firmware will not find
the bootloader (or Linux kernel) and will most likely be unable to boot the system!

	mkfs.fat -F32 /dev/<esp>

### Partitioning

Use fdisk to partition a disk

	$ fdisk /dev/<disk>

	Helpful commands:
	: p		# print current configuration
	: g		# create new gpt, will delete everything on the disk!
	: d		# remove a partition
	: n		# create new partition
	: t		# change partition type (1 is ESP, 23 is Linux root x86_64, 2 is Linux swap)
	: w		# write changes to disk and exit

## Formatting

Format a partition using the "mkfs.\<format\> \<partition\>" command:

For example:

	mkfs.ext4 /dev/nvme0n1p2

### File Systems

Linux supports dozens of filesystems, many of them are only wise to use for a
specific purpose.

*ext4 is the recommended all-purpose all-platform filesystem.*

Get a more detailed description [here](https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation#Filesystems).

Filesystem | Description | Command
---------- | ----------- | -------
btrfs      | Modern filesytem with many advanced features such as snapshotting, self-healing through checksums, tranparent compression, subvolumes and integrated RAID. Warning: There are a lot of errors with older kernels. | mkfs.btrfs
ext4       | A lot of new features and performance improvements over ext3, practically no size limits (volumes up to 1EB, file size up to 16TB). Ext4 also provides more sophisticated block allocation algorithms. | mkfs.ext4
f2fs       | For microSD cards and USB drives | mkfs.f2fs
VFAT (FAT32) | Not fully supported by Linux (No permission settings). Mostly used for interoperability with other oses. | mkfs.vfat or mkfs.fat -F32

### Activate swap

* Initialize a swap partition

		mkswap /dev/<swap-partition>

* Activate swap partition

		swapon /dev/<swap-partition>

Deactivate a swap partition using "swapoff \<partition\>"

## Mounting

Foreach partition, create the necessary mount directory and mount the partition

	mkdir /mnt/<directory>
	mount /dev/<partition> /mnt/<directory>

For example:

	mount /dev/sda2 /mnt/gentoo	# mount the root partition to /mnt/gentoo

## Installing the Gentoo installation files

### Date and Time

* Verify the current date and time:

		date

* Synchronise via a ntp server:

		ntpd -q -g

* Alternatively set the time manually:

	date <MMDDhhmmYYYY>

		date 012306112004

### Stage tarball

Multilbi -> 64 and 32 bit (recommended)  
No-multilib -> pure 64 bit

There are two multilib stage 3 tarballs available, one with OpenRC and one with
Systemd. Choose the one you prefer.

* Go to the root file system mount point

		cd /mnt/gentoo

* Download the tarball

	Variant 1:
	
		Go to: https://www.gentoo.org/downloads/
	
		Right click the correct tarball and click "copy link".
	
			wget <copied url>
	
		For example:
	
			wget https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20210425T214502Z/stage3-amd64-20210425T214502Z.tar.xz
	
	Variant 2 (definitely the better option):
	
		Use links:
	
		links https://www.gentoo.org/downloads/mirrors/
	
		Navigate to a mirror, select the link and press <Enter>  
		Then move to
			releases/amd64/autobuilds
		Select a stage, for example current-stage3-amd64, enter the directory and
		press "d" to download the file

* Use the same process as at the beginning to verify the file

* Unpack the file

		$ tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

		x -> extract
		p -> preserve permissions
		f -> extract a file
		--xattrs-include='*.*' -> include preservation of the extended attributes in all namespaces stored in the archive
		--numeric-owner -> ensure the user and group IDs remain the same

## Compile Options

**Its important that you read the complete guides on the different FLAGS and
decide for yourself what you want to use**

Portage (Gentoos package manager) reads settings from "/etc/portage/make.conf"

	nano -w /etc/portage/make.conf

An example config with a bit of explanation can be found:

	nano /etc/portage/make.conf.example

### CFLAGS and CXXFLAGS

Define the optimization flags for GCC C and C++ compilers.

Read the [GNU Online Manual](https://gcc.gnu.org/onlinedocs/) or the gcc info
page:

	info gcc

Find more info:

https://wiki.gentoo.org/wiki/GCC_optimization

and:

https://wiki.gentoo.org/wiki/Safe_CFLAGS

### MAKEOPTS

Defines how many parallel compilations should occur when installing a package.

A good choice is the number of CPUs in the system plus one.  
This can use a lot of memory, you shoud have at least 2GiB of RAM for each job.

For example:
	
	MAKEOPTS="-j6"

NOTE: Get the number of cpu cores:

	cat /proc/cpuinfo


// TODO: USE and other FLAGS

## Chrooting
