# Arch installation guide

## Download the iso

Download the iso and check the md5sum  
Use Balena Etcher to create a bootable usb from the iso  
Select in the uefi/bios the usb to boot from  
You may have to disable Secure Boot

## Preparation

* Make font double the size (if you use a monitor with a high dpi)

        setfont -d

* List available fonts

        ls /usr/share/kbd/consolefonts

* Choose font

        setfont /usr/share/kbd/consolefonts/<font>

* List aviable keyboard-layouts
	
        ls /usr/share/kbd/keymaps/**/*.map.gz

* Change keyboard layout

	    loadkeys <layout>
	    
	For example Dvorak:
	    
	    loadkeys dvorak

* Verify boot mode: if the files exists, your in UEFI mode :)

    	ls /sys/firmware/efi/efivars

* Check internet connecion

	List available interfaces:	
	
    	ip link
    
    All interfaces should already be active. If an interface is down activate it:
    
    	ip link set <interface> up
    	
    Test your connection:
    	
    	ping archlinux.org -c 3

Note: On the installation image, systemd-networkd, systemd-resolved and iwd
are preconfigured and enabled by default. This will ***not*** be the case for
the installed system.

* Update system clock

    	timedatectl set-ntp true
    	timedatectl list-timezones
    	timedatectl set-timezone <Continent/City> # For example: Europe/Zurich
    	timedatectl status # Check if it worked

## Partition disk

* List disks and partitions

	    fdisk -l  # or use lsblk -af

### EFI System Partition (ESP) ***Already exists***

If you already have an esp (for example if you're dual-booting) just mount it. If you need to create one, skip this step. (And also skip the formating!)

Note: when dualbooting, check for an existing EFI-Partition

    fdisk -l /dev/<disk>

The EFI-Partition is usually at least 100MiB and has the type "EFI System" or
"EFI (Fat-<12/16/32>)"
To confirm it is the ESP mount it and check if it contains a directory named "EFI".
If it does, it is definitely the ESP.

    mount /dev/<partition> /mnt # Mount the esp
    ls # Check if it contains a directory called "EFI"

* Unmount all mounted partitions

	    findmnt # List all mounted partitions
	    umount /dev/<partition>

* Mount ESP for use together with a boot loader:

	    mount <esp> /mnt/efi

* Or mount ESP to be directly booted:
	
	    mount <esp> /mnt/boot
	    
	Note: If you use a bootloader, in most cases you should mount the esp to /mnt/efi.  
	However, if you want to use systemd-boot, you need to mount it to /mnt/boot.  
	If you want to boot directly without having to use a bootloader, mount it to /mnt/boot.

### Or ***Create*** the ESP

If you don't have an esp, you need to create it first. In this example using fdisk:

    fdisk /dev/<disk>
    g # Create a new GPT partition table (For UEFI, else use MBR), this will erase all data stored on this disk!
    n # Add a new partition
    <Enter> # Use default partition number (1)
    <Enter> # Use default first sector
    +500M # Size of 500MiB, you should use at least 260MiB
    t # Change partition type
    L # To list all partition types
    q # To exit list
    1 # For EFI System
    p # Print the partition tabel
    w # To write and exit, q exits without writing

### Create other partitions

* Use fdisk to create the other partitions:

	    Mount Point | Partition   | Partition Type     | Suggested Size
		---------------------------------------------------------------------
	    /mnt/efi    | /dev/<esp>  | EFI System         | min. 260MiB
	    [SWAP]      | /dev/<swap> | Linux Swap         | more than 512MiB
	    /mnt        | /dev/<root> | Linux root (/)     | around 50GiB
	    /mnt/home   | /dev/<home> | Linux home (/home) | Remainder of the disk  
	    
You definitely need a root and an efi partition. Optional you can create a seperate home partititon and a swap partition.  
You can also create a swap file later, instead of a swap partition.	 
**Also read my guide "swap.md" (Although the guide isn't complete yet :( )**

### Format partitions

* Format ESP as Fat-32:

	    mkfs.fat -F32 /dev/<esp>

* Format /, /home, etc as ext4:

	    mkfs.ext4 /dev/<partition>

* Format swap as:

	    mkswap /dev/<swap-partition>

### Mount partitions

* Mount /, /home, etc (See table above):

	    mount /dev/(root) /mnt

* Create any remaining mount points (such as /mnt/efi) using mkdir
and mount their corresponding volumes.

* Enable swap:

	    swapon /dev/<swap-partition>

## Installation

* Edit /etc/pacman.d/mirrorlist  
Note: The higher a mirror is placed in the list, the higher its priority.

* Install essential packages

		    pacstrap /mnt base base-devel linux linux-firmware linux-headers man-db man-pages vim git dhcpcd zsh
		    
Instead of the linux kernel you can also install linux-lts, linux-zen, ... there are a lot more (Check the [archwiki](https://wiki.archlinux.org/index.php/Kernel))

## Configure the system

* Generate an fstab file

	    genfstab -U /mnt >> /mnt/etc/fstab
	    
	The "U" option will use the UUID's instead of the disk-labels (This is highly recommended)

* Check the resulting fstab for errors

		cat /mnt/etc/fstab

* Change root into the new system

	    arch-chroot /mnt
	    
* [Optional] Create a swapfile (instead of a swap partition)
		
		fallocate -l 2GB /swapfile # You can also use dd (recommended by the wiki) instead
		chmod 600 /swapfile
		mkswap /swapfile
		swapon /swapfile
		vim /etc/fstab
		--------------
		Add the line:
			/swapfile none swap defaults 0 0
		--------------

* Set the timezone

	    ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime # Replace "Europe/Zurich" with your own timezone
	    hwclock --systohc # Sync the systemclock with the hardwareclock

* Localization

	    vim /etc/locale.gen
	    -> Uncomment en_US.UTF-8 UTF8 and other needed locales
	    
	    For example:
	    	de_CH.UTF-8 UTF-8
	    	en_US.UTF-8 UTF-8
	    	ja_JP.UTF-8 UTF-8
	    	lo_LA UTF-8
	    	th_TH.UTF-8 UTF-8
	    	ko_KR.UTF-8 UTF-8  
	    	zh_CN.UTF-8 UTF-8  
	    	zh_TW.UTF-8 UTF-8  


* Generate locales

	    locale-gen

* Create the locale.conf file

	    vim /etc/locale.conf
	    --------------------
		    LANG=en_US.UTF-8
		    LC_MESSAGES=en_US.UTF-8
		    LC_TIME=de_CH.UTF-8
	    --------------------
	    
	Note: check the manual on locale(7) to see what options you have:
			
			man 7 locale

* Keyboard layout

	    vim /etc/vconsole.conf
	    ----------------------
	    	KEYMAP=dvorak # Replace dvorak with whatever fits your needs
	    ----------------------

* Network configuration

	    vim /etc/hostname
	    -----------------
	    	<your-prefered-hostnome>
	    -----------------

* Add matching entries to hosts (see hosts(5))
	
	    vim /etc/hosts
	    --------------
		    127.0.0.1       localhost
		    ::1             localhost
		    127.0.1.1       <hostname>.localdomain <hostname>
	    --------------

* Usually not needed:

	    mkinitcpio -P

* Change password:

	    passwd

* Change login shell

		chsh -l # list available login shell-paths
		chsh -s /bin/zsh

* Add a user

		passwd -Sa # List all user and their properties
		chsh -l
		useradd -m -G <Groups> -s <login-shell> <username>
		
	For example:
	
			useradd -m -G wheel -s /bin/zsh test
			passwd test # set password (this is safer than -p, since it wont be stored in the history)

* Add user to sudoers

		EDITOR=vim visudo /etc/sudoers
		
	To make only a specific user sudoer add the line:
	
			<username> ALL=(ALL) ALL
			
	To make all user of group wheel sudoer uncomment the line:
	
			%wheel ALL=(ALL) ALL

### Install a bootloader

* systemd-boot  
	***See the file "sytemd-boot.md"*** (It should be somewhere in this repo)
	
* Grub  
	I haven't made a guide yet, but may create one soon.

### Finish

* Activate services needed for internet

		ip link # List interfaces
		ip link set <interface> up # Activate an interface
		systemctl enable systemd-resolved
		systemctl enable systemd-networkd
		systemctl enable dhcpcd

* Exit and reboot

		exit
		umount -a # Ignore errors like "device busy"
		reboot

## After the installation

If everything worked, you may now want to setup a wm/de.  
For setting up xorg and dwm, see my other guide "dwm.md".

* You may also want to install paru, a pacman-wrapper that is also aur-aware

		mkdir code && cd code # Or any other directory
		git clone https://aur.archlinux.org/paru.git
		cd paru
		makepkg -si
