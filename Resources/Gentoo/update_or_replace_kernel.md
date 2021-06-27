# Update or Replace a Kernel

## Installing Kernel Sources

Choose a kernel source you like: https://wiki.gentoo.org/wiki/Kernel/Overview

Install a source:

	emerge -uvDNa --with-bdeps=y sys-kernel/zen-sources # or any other source

The kernel source should be installed to `/usr/src/<kernel-source>`.

The `/usr/src/linux` symlink should always point to the kernel which is currently
in use. There are three ways to update the symlink.

## Updating symlink

### Using USE flags

While installing the kernel sources, use the `USE="symlink"` flag.

	USE="symlink" emerge -uvDNa --with-bdeps=y sys-kernel/zen-sources

### Using eselect

List available targets:

	eselect kernel list

Select a target:

	eselect kernel set <number>

### Manually updating the symlink

Update the symlink manually:

	ln -sf /usr/src/<kernel-source> /usr/src/linux

For example:

	ln -sf /usr/src/linux-5.12.9-zen /usr/src/linux

Running `ls -l /usr/src/linux` should produce the following output:

	lrwxrwxrwx root root  16 B  Fri Jun  4 23:09:13 2021   linux@ ⇒ linux-5.12.9-zen

Now `cd` into `/usr/src/linux`.

## Configuring the kernel

Copy the old config to the new kernel.

The old config can be found in several places:

* In the old kernel source `/usr/src/<old-kernel>/.config`
* In `/etc/kernels/`, if `SAVE_CONFIG=yes` is set in `/etc/genkernel.conf` and genkernel was previously used (this should be the default option)

		cp /etc/kernels/kernel-config-5.12.9-zen1-x86_64 /usr/src/linux/.config

Update the .config file.

Genkernel can be configured to automatically invoke `make oldconfig` and
`make menuconfig`:

	vim /etc/genkernel.conf
	---
	OLDCONFIG="yes"
	MENUCONFIG="yes"

`make oldconfig` will ask you for each new or changed config option:

	Anticipatory I/O scheduler (IOSCHED_AS) [Y/n/m/?] (NEW) # select yes, no, module

### Manually configure the kernel

Convert the old config to be used for the new kernel

	make oldconfig

Use menuconfig for additional configuration

	make menuconfig

Compile the kernel

	make -j32 && make -j32 modules_install

Build packages containing external kernel modules

	emerge -a @module-rebuild

Copy the kernel to the boot directory

	make install

Create an initramfs

	genkernel --install --kernel-config=/usr/src/linux/.config initramfs

### Use genkernel to configure and compile the kernel

You can use genkernel to configure and compile the kernel intead.

	genkernel --makeopts="-j32" all

## Update the bootloader

This differs from your bootloader.

For systemd-boot (gummiboot):

Edit the config file in `/boot/loader/entries/<file>` to use the new kernel image
and initramfs.

## Remove old kernel

Remove the old kernel sources

	emerge --deselect sys-kernel/zen-sources:unwanted.version.here
	emerge -c # short version for --depclean

Another way is to run:

	emerge -ac zen-sources # this will remove older versions

Protect a kernel source:

After installing a new source, depclean will remove all except the selected
(symlinked) sources. To prevent deplean from removing a specific source, install
the source with `--noreplace`.

	emerge --ask --noreplace zen-sources:version.here

Clean leftover files:

	rm -r /usr/src/<old-kernel>
	rm /boot/vmlinuz-<old>
	rm /boot/System.map-<old>
	rm /boot/initramfs-<old>

