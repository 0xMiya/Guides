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
	
### Create a bootable usb stick, in this example using 'dd':
	
Prepare	 a usb:

	sudo fdisk -l		# find the correct disk (/dev/sdx)
	mkfs.vfat /dev/<disk> -I

Flash usb:

	sudo dd if=/<iso-file> of=/dev/<disk> status=progress

	# Alternatively use cat instead:
	sudo -i
	cat <iso-file> > /dev/<disk>

Warning, there's a reason why dd is also called "Disk Destroyer"!

## Booting

### In a vm with qemu

	paru -S qemu edk2-ovmf			# ovmf is needed for uefi
	qemu-img create image.img 16G
	qemu-system-x86_64 -bios /usr/share/ovmf/x64/OVMF.fd -hda image.img -cdrom <iso> -m 4G -boot order=dc -enable-kvm

#### Qemu tricks

Type <kbd>Ctrl-Alt-2</kbd> to switch to qemu console.
Use `sendkey ctrl-alt-f#` where `#` is the number of the function-key.
Change back by pressing <kbd>Ctrl-Alt-1</kbd>.

### On real hardware

* Insert the usb stick and reboot. In the motherboards firmware, select the usb to
boot from.

* You can tell Linux to boot directly into the UEFI/BIOS:

		sudo systemctl reboot --firmware-setup

* Select the kernel and options
	
	You need to be fast, because after a set timeout it will automatically continue using the default.
	
	To use the default just press \<Enter\> to select a kernel and boot options
	write "\<kernel\> \<options\>".

	Check the [gentoo installation handbook](https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation#Booting) for 		a detailed list of options.

* Select keyboard layout

	For example 14 for dvorak

* Now you should have a root shell

### View the gentoo handbook during installation

[Option 1]

* First create another user account

		useradd -mG users wiki	# create a user named wiki
		passwd wiki				# set a password for the user
	
	Change tty by pressing \<Alt+F2\>. (Press \<Alt+F1\> to go back)

[Option 2]

* Alternatively use screen (already preinstalled) instead

[Option 1+2]

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

	vim /etc/wpa_supplicant/wpa_supplicant.conf
	-------------------------------------------
		ctrl_interface=/run/wpa_supplicant
		update_config=1

	wpa_supplicant -B -i <interface> -c /etc/wpa_supplicant/wpa_supplicant.conf
	wpa_cli		# this opens an interactive prompt

	> scan			# scan for wlans
	> scan_results	# print found wlans
	> add_network	# Adds a network, will return a number
	> set_network <number> ssid <ssid>
	> set_network <number> psk <password>
	> enable_network <number>
	> save_config
	> quit
	dhcpcd wlan0

##### Using wpa_passphrase

	sudo -i	# this needs to run in a root shell (bc of process substitution)
	wpa_supplicant -B -i <interface> -c <(wpa_passphrase <ssid> <passwd>)

## Partitioning

### Block devices

Block devices represent an abstract interface to the disk. User programs can use
block devices to interact with the disk without worrying what type the disk is.
The program can simply address the storage on the disk as a bunch of contagious,
randomly-accessible 4096-byte (4KiB) blocks.

Device Type | Default device handle | Default partiton handle
----------- | --------------------- | -----------------------
HDD         | /dev/hda              | /dev/hda1
SATA, SAS, SCSI, USB | /dev/sda     | /dev/sda1
NVMe        | /dev/nvme0n1          | /dev/nvme0n1p1
MMC, eMMC, SD | /dev/mmcblk0        | /dev/mmcblk0p1

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
https://wiki.gentoo.org/wiki/LVM

### RAID

// TODO  
https://raid.wiki.kernel.org/index.php/Linux_Raid  
https://raid.wiki.kernel.org/index.php/What_is_RAID_and_why_should_you_want_it%3F

### Btrfs

// TODO  
https://wiki.gentoo.org/wiki/Btrfs  
https://btrfs.wiki.kernel.org/index.php/Status

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

- For systems with multiple hard disk, it is recommended to create a swap partition foreach disk.  
- Swap on an SSD will have better performance than on a HDD.  
- Also swap files can be used instead of swap partitions.  
- When using systemd, you can also use systemd to automatically handle swap (guide will follow).

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

***ext4 is the recommended all-purpose all-platform filesystem.***

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

**For a swap file or systemd check the [Arch installation guide](Arch_Installation_Guide.md) and the [swap guide](Resources/Arch_Linux/swap.md).**

## Mounting

Foreach partition, create the necessary mount directory and mount the partition

	mkdir /mnt/<directory>
	mount /dev/<partition> /mnt/<directory>

For example:

	mount /dev/sda2 /mnt/gentoo	# mount the root partition to /mnt/gentoo

## Date and Time

* Verify the current date and time:

		date

* Synchronise via a ntp server:

		ntpd -q -g

* Alternatively set the time manually:

	date <MMDDhhmmYYYY>

		date 012306112004

## Stage 1

// TODO

## Stage 2

// TODO

## Stage 3

### Stage 3 tarball

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

		tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

		# x -> extract
		# p -> preserve permissions
		# f -> extract a file
		# --xattrs-include='*.*' -> include preservation of the extended attributes in all namespaces stored in the archive
		# --numeric-owner -> ensure the user and group IDs remain the same

## Compile Options

**Its important that you read the complete guides on the different FLAGS and
decide for yourself what you want to use.**

Portage (Gentoos package manager) reads configs from "/etc/portage/make.conf"

	nano -w /mnt/gentoo/etc/portage/make.conf

An example config with a bit of explanation can be found:

	nano /usr/share/portage/config/make.conf.example

### CFLAGS and CXXFLAGS

Define the optimization flags for GCC C and C++ compilers.

Read the [GNU Online Manual](https://gcc.gnu.org/onlinedocs/) or the gcc info
page:

	info gcc

Find more info:

https://wiki.gentoo.org/wiki/GCC_optimization

and:

https://wiki.gentoo.org/wiki/Safe_CFLAGS

#### Overview

Flag | Example Value | Description
---- | ------------- | -----------
-march | =native, =znver2 | The arch the code should be compiled for.
-O (uppercase o) | -O2 (recommended) | Overall level of optimization.
-pipe | -pipe        | Use pipes instead of temporary files for compilation. Increases compilation speed as well as memory usage. GCC might get killed on systems with low memory.
-msse, -msse2, -msse3 (pni), -mmmx, -m3dnow | \- | Enable SSE instruction sets, for faster multimedia and gaming performance. Check if your cpu supports these by running "cat /proc/cpuinfo". If the proper -march is set, most of these flags are already activated. Check https://gcc.gnu.org/onlinedocs/gcc/x86-Options.html to see what flags are already activated, and what flags need to be activated manually.

Don't use too many and too aggressive flags.

**I recommend you also using [cpuid2cpuflags](Resources/Gentoo/cpuid2cpuflags.md).**  
**Also setup a [ccache](Resources/Gentoo/ccache.md) to reduce compilation times.**

Basic LDFLAGS are already set by the Gentoo developers, no need to change them.

### MAKEOPTS

Defines how many parallel compilations should occur when installing a package.

A good choice is the number of CPUs in the system (and if you want to) plus one.  
This can use a lot of memory, you shoud have at least 2GiB of RAM for each job.

For example:
	
	MAKEOPTS="-j7"

NOTE: Get the number of cpu cores:

	nproc	# or:
	cat /proc/cpuinfo


### Example make.conf

	COMMON_FLAGS="-march=znver2 -O2 -pipe"
	CFLAGS="${COMMON_FLAGS}"
	CXXFLAGS="${COMMON_FLAGS}"
	MAKEOPTS="-j33"

## Chrooting

### Mirrors

Used by the package manager to download source code.

Select a physically nearby mirror:

	mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf

This will open a TUI, use the arrow keys to navigate up/down and press \<spacebar\>
to (de)select a mirror. Press \<Enter\> to exit.

### Ebuild Repository

Contains the sync information to update the package repository.

	mkdir -p /mnt/gentoo/etc/portage/repos.conf
	cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf

### DNS Information

To ensure the network still works after chrooting, copy /etc/resolv.conf.

	cp --dereference /etc/resolv.conf /mnt/gentoo/etc/	# --dereference makes sure to copy the target file and not just a symbolic link

### Mounting the filesystems

Some important filesystems need to be made available:

/proc/	-> a pseudo filesystem from which the Linux kernel exposes information to
the environment  
/sys/	-> was once meant to replace /proc/, is more structured than /proc/  
/dev/	-> regular file system, partially managed by the Linux device manager
(usually udev), which contains all device files  

/proc/ will be mounted to /mnt/gentoo/proc/, the other two need to be bind-mounted.
(/mnt/gentoo/sys/ will actually be /sys/, it is just a second entry point to the
same filesystem, whereas /mnt/gentoo/proc/ is a new mount/instance of the filesystem).

	mount --types proc /proc /mnt/gentoo/proc
	mount --rbind /sys /mnt/gentoo/sys
	mount --make-rslave /mnt/gentoo/sys		# needed for systemd
	mount --rbind /dev /mnt/gentoo/dev
	mount --make-rslave /mnt/gentoo/dev		# needed for systemd

When installing Gentoo from a non-gentoo installation media, some distros make
/dev/shm a symbolic link to /run/shm/ which, after the chroot becomes invalid.  
Properly mount tmpfs:

	test -L /dev/shm && rm /dev/shm && mkdir /dev/shm
	mount --types tmpfs --options nosuid,nodev,noexec shm /dev/shm
	chmod 1777 /dev/shm

### Change Root

This is done in three steps:

1. Changing the root location from / to /mnt/gentoo/
2. Reloading some settings (/etc/profile) using source
3. Changing the primary prompt (this is just as a reminder that we are now on the chrooted system)

		chroot /mnt/gentoo /bin/bash
		source /etc/profile
		export PS1="(chroot) ${PS1}"

If the installation is interrupted anywhere after this point, it *should* be
possible to resume the installation by just mounting the partitions again and
re-run the steps above starting with copying the dns info.

## Configuring Portage

* Install a snapshot of the Gentoo ebuild repo
	
	This snapshot contains a collection of files that inform Portage about
	available software titles

		(chroot) $ emerge-webrsync	# ignore complaints about a missing /var/db/repos/gentoo/ location

* [Optional] Update the ebuild repo

	The snapshots are usually not older than 24h, but you can still update the
	repo if you want to

		(chroot) $ emerge --sync	# on a slow computer additionally use --quiet to speed up the process

### Reading news items

	man news.eselect

Portage may output a message that "news items need reading..."

News items provide a communication medium to push critical messages to users.  
Use "eselect news" to manage them:

	eselect news list		# Print an overview of available news
	eselect news read		# Read the news items
	eselect news purge	# Remove news items

### Choosing a profile

A profile provides default values for USE and CFLAGS and locks the system to a
certain range of package versions.

* Check current profile (and list all available profiles)

		(chroot) $ eselect profile list	# The selected profile has a "*"

NOTE: If using systemd, make sure the chosen profile contains "systemd". If using
OpenRC, make sure the chosen profile does **not** contain "systemd".

* Select a profile

		(chroot) $ eselect profile set <profile-number>

	No-multilib -> does not contain any 32bit application  
	Developer	-> only for Gentoo developers  

### Update @world set

	(chroot) $ emerge --ask --verbose --update --deep --newuse @world

Depending on your chosen profile the time this will take can vary greatly.  
Rule of thumb: The shorter the profile name, the shorter the time it will take.

(If systemd was chosen, it will take a long time, since the init system has to be
replaced from OpenRC to Systemd. If you selected a profile with a de (eg. kde),
it needs to download and compile all this too.)

### USE variable

The [USE variable](https://www.gentoo.org/support/use-flags/) allows certain programs to be compiled with or without optional
support for centain items.

The default USE settings are in the make.defaults file.  
Check the current active USE flags:

	(chroot) $ emerge --info | grep ^USE

A full description of available USE flags can be found in /var/db/repos/gentoo/profiles/use.desc, or in the like above.

Example:

	# Enable support for a KDE/Plasma-based system with DVD, ALSA and CD recording

	(chroot )$ nano -w /etc/portage/make.conf
	-----------------------------------------
		USE="-gtk -gnome qt4 qt5 kde dvd alsa cdr"

	# The minus "-" removes support. In this example we only want support for KDE, so we can remove gnome "-gtk -gnome".
	# Wild cards are possible too "-*" <-- the example used here is *not* recommended!

### ACCEPT_LICENES variable

In order to install packages, you need to accept the licenses.

License | Description
------- | -----------
@GPL-COMPATIBLE | GPL compatible licenses approved by the Free Software Foundation [a_license 1]
@FSF-APPROVED | Free software licenses approved by the FSF (includes @GPL-COMPATIBLE)
@OSI-APPROVED | Licenses approved by the Open Source Initiative [a_license 2]
@MISC-FREE | Misc licenses that are probably free software, i.e. follow the Free Software Definition [a_license 3] but are not approved by either FSF or OSI
@FREE-SOFTWARE | Combines @FSF-APPROVED, @OSI-APPROVED and @MISC-FREE
@FSF-APPROVED-OTHER | FSF-approved licenses for "free documentation" and "works of practical use besides software and documentation" (including fonts)
@MISC-FREE-DOCS | Misc licenses for free documents and other works (including fonts) that follow the free definition [a_license 4] but are NOT listed in @FSF-APPROVED-OTHER
@FREE-DOCUMENTS | Combines @FSF-APPROVED-OTHER and @MISC-FREE-DOCS
@FREE | Metaset of all licenses with the freedom to use, share, modify and share modifications. Combines @FREE-SOFTWARE and @FREE-DOCUMENTS
@BINARY-REDISTRIBUTABLE | Licenses that at least permit free redistribution of the software in binary form. Includes @FREE
@EULA | License agreements that try to take away your rights. These are more restrictive than "all-rights-reserved" or require explicit approval 

	(chroot) $ nano -w /etc/portage/make.conf
	-----------------------------------------
	ACCEPT_LICENSE="@BINARY-REDISTRIBUTION"

## [Optional] Using Systemd as the init system

// TODO: Maybe in a seperate guide  
https://wiki.gentoo.org/wiki/Systemd

## Timezone

* Find available timezones

		(chroot) $ ls /usr/share/zoneinfo/*/*

* Select a timezone (OpenRC)

		(chroot) $ echo "<timezone>" > /etc/timezone

		# For example:
		echo "Europe/Zurich" > /etc/timezone

* Reconfigure the timezone-data package (OpenRC)

		(chroot) $ emerge --config sys-libs/timezone-data

* For systemd:

		(chroot) $ ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

	Later when systemd is running, the timezone and related settings can be
	configured using the "timedatectl" command

## Locales

Locals specify the language the user should use to interact with the system as
well as rules for sorting strings, displaying dates and times, etc.

Locals are case *sensitive*. A full listing of available locals can be found in
the /usr/share/i18n/SUPPORTED file.

* Specify locales

		(chroot) $ nano -w /etc/locale.gen
		----------------------------------
			# Some examples
			en_US.UTF-8 UTF-8
			de_CH.UTF-8 UTF-8

* Generate the locales

		(chroot) $ locale-gen
		(chroot) $ locale -a	# verify

* Locale selection

	Set the system-wide locale settings.

		(chroot) $ eselect locale list	# list available locales
		(chroot) $ eselect locale set <number>	# select a locale

	To set this manually:

		# OpenRC:
		nano -w /etc/env.d/02locale

		# Systemd:
		nano -w /etc/locale.conf

		# Example: Use english for the language, but use the swiss german date and time format
		LANG="en_US.UTF-8"
		LC_TIME="de_CH.UTF-8"

	Reload the environment:

		(chroot) $ env-update && source /etc/profile && export PS1="(chroot) ${PS1}"

## Installing sources

Gentoo provides several possible kernel sources. A full listing is available at
https://wiki.gentoo.org/wiki/Kernel/Overview

For amd64 systems the sys-kernel/gentoo-sources is recommended.

* Install a kernel source

		(chroot) $ emerge --ask sys-kernel/gentoo-sources	# Or any other source

	This will install all the Linux kernel sources in /usr/src in which a
	symbolic link called *linux* points to the installed kernel source

		(chroot) $ ls -l /usr/src/linux

## [Option 1] Manual Configuration

This is the recommended way. Alternatively skip to the next section.

It is important to know the system when configuring the kernel manually. To
gather information, install the sys-apps/pciutils package:

	(chroot) $ emerge --ask sys-apps/pciutils

This package contains "lspci" which can be used to gather information about the
system. In the chrooted environment, any errors lspci throws can be safely
ignored.

"lsmod" can also be used to guess what should be enabled.

**The following guide is specific to the gentoo-source.**

* Start the configuration

		(chroot) $ cd /usr/src/linux
		(chroot) $ make menuconfig

	The [Gentoo Kernel Configuration Guide](https://wiki.gentoo.org/wiki/Kernel/Gentoo_Kernel_Configuration_Guide) provides more info.

	On an entry press space once (an M for module should appear), press space again (a * should appear)

	Press Esc two times to go back


* It is recommended to enable all Gentoo specific options
* Choose either OpenRC or systemd
* Make sure that every driver that is vital for booting (such as SCSI controller) is compiled in the kernel and not as a module
* Select the exact processor type. Also enabel MCE features if available. (Needed to notify users of any hardware problems). In x86_64 these errors are not printed to dmesg, but to /dev/mcelog. In that case also install "app-admin/mcelog".
* Select "Maintain a devtmpfs file system to mount at /dev" so that critical device files are already available early in the boot process.
* Enable SCSI disk support
* Under File systems select support for the filesystems you use. Don't compile the filesystem that is used for the root partiton as modules, otherwise Gentoo will not be able to mount the partition. (Make sure there is a "*" and not a "M")
* Enable Network device support (Ethernet and Wireless Cards)
* Enable SMP support (For multicore processors)
* Enable USB support
* Enable GPT support
* Enable support for UEFI


* Now exit the configuration and start the compilation process

		(chroot) $ make && make modules_install

	Enable parallel builds using make -j<number> (similar to the MAKEOPTS variable)

* When the compilation finished, copy the kernel image to /boot/. This is handled by make install:

		(chroot) $ make install

### [Optional but recommended] Building an initramfs

When important file systems (like /usr or /var) are on seperate partition, an
initial ram-based file system (initramfs) is needed.

Without an initramfs, there is a huge risk that the system will not boot up properly
as the tools responsible for mounting the file systems need information that resides
on those file systems. Initramfs will pull the necessary files into an archive
which is used right after the kernel boots, but before the control is handed over
to the init tool. Scripts on the initramfs will then make sure that the partitions
are properly mounted before the system continues booting.

* Install sys-kernel/genkernel

		(chroot) $ emerge --ask sys-kernel/genkernel	# You need to have the correct license accepted

* Generate the initramfs

		(chroot) $ genkernel --install --kernel-config=<path to kernel config> initramfs

	The kernel config is the one you created before using "make menuconfig"

	To add support, such as LVM or RAID, add the appropriate options to genkernel.
	(genkernel --help, --lvm --mdadm)

	The initramfs will be stored in /boot/

		ls /boot/initramfs*


## [Option 2] Using genkernel instead

If you already followed the "Manual Configuration" skip this section.

Genkernel configures and builds the kernel automatically.

* Install 
	
		(chroot) $ emerge --ask sys-kernel/genkernel

* Edit /etc/fstab

		nano -w /etc/fstab
		------------------
			<boot partition (esp)>	/boot	vfat	defaults	0 2

	This file needs to be configured again later on.

* Compile

		(chroot) $ genkernel all	# also add optional arguments, for example for LVM support
		(chroot) $ genkernel --makeopts="-j24" all	# use 24 parallel jobs

	This will compile the kernel and create an initramfs.
	
	Note down the output, it's needed to configure a bootloader:

		(chroot) $ ls /boot/vmlinu* /boot/initramfs*

## [Optional] Kernel modules

udev will normally do this work for you.

List the modules that need to be loaded in /etc/modules-load.d/*.conf files, one
per line.

Extra options, if necessary, should be set in /etc/modprobe.d/*.conf files.

* View all available modules

		(chroot) $ find /lib/modules/<kernel-version>/ -type f -iname '*.o' -or -iname '*.ko' | less

* Configure

		(chroot) $ mkdir -p /etc/modules-load.d
		(chroot) $ nano -w /etc/modules-load.d/network.conf # specify network modules in here

## [Optional, but recommended] Install additional firmware

Some drivers require additional firmware.

	(chroot) $ emerge --ask sys-kernel/linux-firmware

## Filesystem Information

All partitions used by the system must be listed in /etc/fstab.

Every line consists of 6 fields, separated by whitespaces (tabs or spaces).

Field | Meaning | Possible Values
----- | ------- | ---------------
1     | Block special device or remote filesystem to be mounted | Paths to device files, filesystem labels and UUIDs, partition labels and PARTUUIDs.
2     | Mountpoint of the partition | Path
3     | Filesystem used by the partition | eg. ext4 or btrfs or vfat
4     | Mount options used by 'mount' | See 'man mount'
5     | Used by 'dump' | Normally a 0
6     | Used by 'fsck' to determine the order in which filesystems should be checked | 0 -> not checked at all, 1 -> checked first, The root should have a 1 and the rest a 2 or a 0.

	(chroot) $ nano -w /etc/fstab

	# Get the filesystem labels/UUIDs/PARTUUIDs
	(chroot) $ blkid

It is recommended to use the UUIDs.

## Networking Information (OpenRC specific)

* Hostname 

		(chroot) $ nano -w /etc/conf.d/hostname
		---------------------------------------
			hostname="<hostname>"

### Network configuration

* All networking configuration is gathered in /etc/conf.d/net

		(chroot) $ emerge --ask --noreplace net-misc/netifrc
		(chroot) $ nano -w /etc/conf.d/net
		----------------------------------
			config_eth0="dhcp"	# Replace eth0 with the correct interface name (see output of 'ifconfig' or 'ip link'. If the system has several network interfaces repeat this for config_eth1, ...

* Automatically start networking at boot

		(chroot) $ cd /etc/init.d
		(chroot) $ ln -s net.lo net.eth0
		(chroot) $ rc-update add net.eth0 default
		# Repeat those steps foreach network interface

* If you added the wrong interface name:

		# 1. Update the /etc/init.d with the correct name
		$ ln -s net.lo net.<correct-name>
		$ rm /etc/init.d/net.<wrong-name>
		$ rc-update add net.<correct-name> default
		$ rc-update del net.<wrong-name> default

* Hosts file

	Used to resolve host names to IP addresses that aren't resolved by a nameserver

		(chroot) $ nano -w /etc/hosts
		-----------------------------
			127.0.0.1	localhost
			::1			localhost

## System Information

* Set the root password

		(chroot) $ passwd

* Init and boot configuration

	OpenRC uses /etc/rc.conf to configure services, startup and shutdown of a system.

	Edit the file as you wish.

* Keyboard configuration

		(chroot) $ nano -w /etc/conf.d/keymaps	# Change KEYMAP

* Clock (date & time) configuration

		(chroot) $ nano -w /etc/conf.d/hwclock

## System logger (OpenRC specific)

Install a system logger.

	(chroot) $ emerge --ask app-admin/sysklogd	# There are other loggers too
	(chroot) $ rc-update add sysklogd default

## [Optional] Cron daemon

	(chroot) $ emerge --ask sys-process/cronie	# There are several different cron daemons
	(chroot) $ rc-update add cronie default

## [Optional] File indexing

Index the file system to provide faster file location capabilities.

	(chroot) $ emerge --ask sys-apps/mlocate
	(chroot) $ updatedb

## [Optional] Remote access

To be able to access the system remotely after installation.

	(chroot) $ rc-update add sshd default

If serial console access is needed:

	(chroot) $ nano -w /etc/inittab # Uncomment the SERIAL CONSOLES section

## Filesystem tools

Depending on your filesystems, install the needed tools.

https://wiki.gentoo.org/wiki/Filesystem

Filesystem | Package
---------- | -------
ext2,3,4   | sys-fs/e2fsprogs
VFAT (FAT32) | sys-fs/dosfstools
btrfs      | sys-fs/btrfs-progs

## Networking tools

* Install a DHCP client
	
	https://wiki.gentoo.org/wiki/Dhcpcd

		(chroot) $ emerge --ask net-misc/dhcpcd

* Wireless networking tools

		(chroot) $ emerge --ask net-wireless/iw net-wireless/wpa_supplicant

## Bootloader

### efibootmgr

Is not a (secondary) bootloader, but a tool to interact with the UEFI firmware
and boot directly, without the need of another bootloader like GRUB2.

First, the correct kernel configurations need to be made. (If you didn't made this
before, you will need to compile the kernel again :-) (What a stupid guide which
doesn't tell you this before (I'm looking at you gentoo handbook))

https://wiki.gentoo.org/wiki/EFI_Stub
https://wiki.gentoo.org/wiki/Efibootmgr

	# Modules to enable:
    - EFI runtime service support (CONFIG_EFI),
    - EFI stub support (CONFIG_EFI_STUB)
    - Built-in kernel command line (CONFIG_CMDLINE_BOOL)
    - and add the root partition path (example: /dev/sda2) or its PARTUUID (recommended) to (CONFIG_CMDLINE).

	(chroot) $ emerge --ask sys-boot/efibootmgr
	(chroot) $ mkdir -p /boot/efi/boot
	(chroot) $ cp /boot/vmlinuz-* /boot/efi/boot/bootx64.efi	# Copy the kernel

	# Without and initramfs:
	(chroot) $ efibootmgr --create --disk /dev/sda --part 2 --label "Gentoo" --loader "\efi\boot\bootx64.efi"

	# With an initramfs:
	(chroot) $ efibootmgr -c -d /dev/sda -p 2 -L "Gentoo" -l "\efi\boot\bootx64.efi" initrd='\initramfs-<version>'

	# Use "ls /boot" to see the correct file name
	# Example:
	efibootmgr -c -d /dev/sda -p 2 -L "Gentoo" -l "\efi\boot\bootx64.efi" initrd='\initramfs-genkernel-amd64-4.9.16-gentoo'

## Rebooting the system

	(chroot) $ exit
	cd
	umount -l /mnt/gentoo/dev{/shm,/pts,}
	umount -R /mnt/gentoo
	reboot

Since we haven't configured a domain name, when login in, we might get something
like "This is \<hostname\>.unknown_domain ...".

To prevent this remove the ".\0" from /etc/issue:

	nano -w /etc/issue

## User administration

Working as the root user is dangerous and should be avoided.

### Groups

The groups the user is member of define what activites the user can perform.

Group | Description
----- | -----------
audio | Be able to access audio devices.
cdrom | Be able to directly access optical devices.
portage | Be able to access portage restricted sources.
usb   | Be able to access USB devices.
video | Be able to access video capturing hardware and doing hardware acceleration.
wheel | Be able to use 'su'.

	useradd -mG users,wheel,audio,video,usb -s /bin/bash miya
	passwd miya

If a user ever needs to perform some task as root, they can use 'su -'. Another
way is to install sudo or [doas](Resources/Gentoo/doas.md).

## Disk cleanup

Remove the stage-tarball

	rm /stage3-*.tar.*

## What now?

Read: https://wiki.gentoo.org/wiki/Handbook:AMD64/Working/Portage

An overview over all topics: https://wiki.gentoo.org/wiki/Main_Page#Documentation_topics

Recommended: https://wiki.gentoo.org/wiki/Localization/Guide

## Important

Automatically generate cpu flags: [cpuid2cpuflags](Resources/Gentoo/cpuid2cpuflags.md)  
Install [doas](Resources/Gentoo/doas.md)  
Make compile time faster using [ccache](Resources/Gentoo/ccache.md)  
Setup [x-server](Resources/Gentoo/xorg.md)  
