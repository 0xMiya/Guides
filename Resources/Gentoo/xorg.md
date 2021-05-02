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

First install the rust binary (you really don't want to have to compile that,
except you really hate your cpu).

	$ emerge --ask dev-lang/rust-bin

After thats done, install xorg-server.

If you get a message "unmet requirements" you might need to add "elogind" to the
USE flags.

	$ emerge --ask x11-base/xorg-server	# install x11-base/xorg-x11 for a few extra packages

	# Update environment variables
	$ env-update
	$ source /etc/profile

## Xorg as non-root user (OpenRC specific)

Enable the 'elogind' USE flag if you haven't done it already, then update the
system with 'emerge -ND @world'. After that, re-login.

elogind needs to be started at the boot runlevel:

	$ rc-update add elogind boot

After a graphical login, X Server should not be running under a root user:

	$ ps -fC X

## Configuration

X-Server is designed to work out-of-the-box, usually you shouldn't have to do any
manual configuration.

Most configuration files are stored in the ***/etc/X11/xorg.conf.d/*** directory.  
Each file in given a unique name and ends with *.conf*. The file names will be
read in alphanumeric order.

Example configurations can be found in ***/usr/share/doc/xorg-server-<version>/xorg.conf.example.bz2***.
More information can be found in 'man xorg.conf'.

## startx

'startx' (x11-apps/xinit) can be used to start the x-server.

* If a file named ***.xinitrc*** exists in the home directory, it will execute
the commands listed there.

* Otherwise it will read the value of the 'XSESSION' variable from ***/etc/env.d/90xsession***
file. To set a system wide default session run:

		$ echo XSESSION="Xfce4" > /etc/env.d/90xsession		# this will set the default X session to Xfce
		$ env-update	# Always update the environment after making changes

The session can also be given as an argument to startx:
	
	$ startx <full-path-to-binary>
	$ startx /usr/local/bin/dwm		# You need to provide the full path, even if its on your $PATH variable

For dwm, you also need to install 'x11-libs/libXinerama'.

X11 server options can be passed after a '--':

	$ startx -- <options>

### .xinitrc

	$ vim ~/.xinitrc
	----------------
	
		# Add additional configuration *above* this line
		exec dwm	# or any other wm

## Keymap

Set the keymap temporarily using 'setxkbmap':

	$ setxkbmap dvorak

To make it permanent, add this to your .xinitrc.

Set it system wide and permanent:

	$ vim /etc/X11/xorg.conf.d/10-keyboard.conf
	-------------------------------------------
		Section "InputClass"
		    Identifier "keyboard-all"
		    Driver "evdev"
		    Option "XkbLayout" "us,br"
		    Option "XkbVariant" ",abnt2"
		    Option "XkbOptions" "grp:shift_toggle,grp_led:scroll"
		    MatchIsKeyboard "on"
		EndSection

## Screen resolution

Get the screen info using 'xrandr' (install with 'emerge xrandr')

Create the config file:

	$ vim /etc/X11/xorg.conf.d/40-monitor.conf
	------------------------------------------
		Section "Device"
		  Identifier "RadeonHD 4550"
		  Option     "Monitor-DVI-0" "DVI screen"
		  Option     "Monitor-VGA-0" "VGA screen"
		EndSection
		Section "Monitor"
		  Identifier "DVI screen"
		EndSection
		Section "Monitor"
		  Identifier "VGA screen"
		  Option     "RightOf" "DVI screen"
		EndSection

When using multiple monitors use "RightOf", "Above", etc to configure the
position of the monitor.
