# X Window Server

## USE Flag

Make sure to include the "X" USE flag:

	$ vim /etc/portage/make.conf
	----------------------------
		USE="X ...."

## Input driver support

Needs to be activated in the kernel configuration.

	$ cd /usr/src/linux
	$ make menuconfig

	Device Drivers --->
		Input device support --->
			<*> Event interface

## Kernel mode setting (KMS)

* Disable legacy framebuffer support
		
		Device Drivers --->
			Graphics support --->
				Frame Buffer Devies --->
					<*> Support for frame buffer devies --->
						## Disable all drivers, including VGA, Intel, NVIDIA, and ATI, except EIF-based Framebuffer Support, only if you are using UEFI)

* Enable basic console support (KMS uses this)

		## Further down
		Console display driver support --->
			<*> Framebuffer Console Support

### Enable correct KMS driver

#### Virtual

	Device Drivers --->
		Graphics support --->
			<*> Virtual KMS support (EXPERIMENTAL)

#### For nvidia

	Device Drivers --->
		Graphics support --->	
			<M/*> Nouveau (NVIDIA) cards # For open source nvidia, optionally chose the closed sourced version

#### For AMD/ATI

Older cards:

	Device Drivers --->
		Generic Driver Options --->
			[*] Inlude in-kernel firmware blobs in kernel binary
			(radeon/<card-model>.bin ...)
			(/lib/firmware) External firmware blobs to build into the kernel

		Graphics support --->
			<M/*> Direct Rendering Manager (...) --->
			<M/*> ATI Radeon
			[*] Enable modesetting on radeon by default
			[ ] Enable userspace modesetting on radeon (DEPRECATED)

Newer cards:

	## (Setup the kernel to use the amdgpu firmware, optional if "AMD GPU" below is M)
	Device Drivers --->
		Generic Driver Options --->
			[*]  Include in-kernel firmware blobs in kernel binary
			(amdgpu/<CARD-MODEL>.bin ...)
			(/lib/firmware/) External firmware blobs to build into the kernel binary
 
	## (Enable Radeon KMS support)
	Device Drivers --->
		Graphics support --->
			<M/*> Direct Rendering Manager (XFree86 4.1.0 and higher DRI support) --->
			<M/*> AMD GPU
			[ /*] Enable amdgpu support for SI parts
			[ /*] Enable amdgpu support for CIK parts 
			[*]   Enable AMD powerplay component  
			ACP (Audio CoProcessor) Configuration  ---> 
				[*] Enable AMD Audio CoProcessor IP support (CONFIG_DRM_AMD_ACP)
			Display Engine Configuration  --->
				[*] AMD DC - Enable new display engine
				[ /*] DC support for Polaris and older ASICs
				[ /*] AMD FBC - Enable Frame Buffer Compression
				[ /*] DCN 1.0 Raven family
			<M/*> HSA kernel driver for AMD GPU devices

### Rebuild the kernel

	$ make && make modules_install	# use -j<number> to specify the number of parallel jobs
	$ make install	# copies the newly compiled kernel to /boot

#### Update tho boot loader
	
When using efibootmgr:

	$ cp /boot/vmlinuz-* /boot/efi/boot/bootx64.efi	# copy the kernel
	$ efibootmgr -c -d /dev/sda -p 2 -L "Gentoo" -l "\efi\boot\bootx64.efi" initrd='\initramfs-genkernel-amd64-<version>'

## make.conf

VIDEO_CARDS -> used to set the video drivers
INPUT_DEVICES -> drivers to be build for input devices

	# Check what is currently used
	$ portageq envvar INPUT_DEVICES	# or just edit the /etc/portage/make.conf file

The default input device (libinput) should be ok.  
Also set the correct driver in make.conf  

	VIDEO_CARDS="nouveau"	# open source nvidia
	VIDEO_CARDS="radeon"	# open source amd

If the suggested settings does not work emerge "x11-base/xorg-drivers"

	$ emerge --pretend --verbose x11-base/xorg-drivers
	# check the output for "x11-base/xorg-drivers....::gentoo INPUT_DEVICES=.. and take these settings

## Install Xorg

If you get a message "unmet requirements" you might need to add "elogind" to the
USE flags.

	$ emerge --ask x11-base/xorg-server	# install x11-base/xorg-x11 for a few extra packages

	# Update environment variables
	$ env-update
	$ soure /etc/profile

## Configuration


