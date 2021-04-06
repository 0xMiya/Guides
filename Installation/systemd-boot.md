# Systemd-boot

## Installation

* Mount the ESP

    Mount the esp to either "/mnt/efi" or "/mnt/boot". For more information see: [systemd bootloader specification](https://systemd.io/BOOT_LOADER_SPECIFICATION/).

    You can also create a seperate boot partition and mount it to "/mnt/boot" and then the esp to "/mnt/efi". In that case install with "bootctl --esp-path=/mnt/efi --boot-path=/mnt/boot install"

    <span style="color:crimson">The partition where the bootloader is installed (esp) should always be shared across all installed OS.</span>

    I will from now on refer to the mountpoint of the esp as ***\<esp\>***.

    <span style="color:orange">Note:</span> I recommend you mounting the esp to /mnt/boot. It works best and I couldn't manage to get it working when installing it to any other mount point. :(

        mkdir /mnt/<esp>
        mount <esp-partition> /mnt/<esp>

* chroot into the new system

        arch-chroot /mnt

* Configure systemd-boot

    For all configuration options see: "man 5 loader.conf"

        bootctl --path=<esp> install
        vim <esp>/loader/loader.conf
        ----------------------------
            timeout 30        # time until it boots the default entry
            console-mode max  # Sets the resolution of the console to the highest availabel mode
            default arch.conf # default entry to boot
        ----------------------------
        
        vim <esp>/loader/entries/arch.conf
        ----------------------------------
            title Arch Linux
            linux /vmlinuz-linux
            initrd /initramfs-linux.img
            options root=/dev/sda2 rw
        ----------------------------------

    <span style="color:orange">Note:</span> If you installed another kernel, your files may have other names. To get the correct name, run 'ls /boot'.  
    For example if you installed the lts kernel, the names will be "vmlinuz-linux-lts" and "initramfs-linux-lts.img"

    <span style="color:crimson">Also if you have *not* mounted the esp to /mnt/boot, you may need to copy (cp -a, or maybe somehow tell mkinitcpio where to put the files) the images from /boot to /efi/EFI/arch/. (Like I already said, I haven't quite figured this out yet. Just mount it to /mnt/boot and your good).</span>

	<span style="color:cyan">Info:</span> Ryzen cpus are known for their issues with cstates. To prevent crashes, I recommend you adding 'processor.max_cstate=5' to the end of the last line.
	
		options root=/dev/sda2 rw processor.max_cstate=5
		
	A few helpful links:  
	https://bbs.archlinux.org/viewtopic.php?id=245608  
	https://gist.github.com/wmealing/2dd2b543c4d3cff6cab7  
	https://wiki.gentoo.org/wiki/Ryzen#Random_reboots_with_mce_events  
	https://community.amd.com/t5/general-discussions/ryzen-instability-mce-bea0000000000108-what-do-do-next/td-p/73269?start=75&tstart=0

* In the example above I specified the root partition using the name (/dev/sda2). You can use the UUID or PARTUUID instead:

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

    vim <esp>/loader/entries/arch.conf
    ----------------------------------
        title Arch Linux
        linux /vmlinuz-linux
        initrd /amd-ucode.img # Place it above the other intird! (intel: intel-ucode.img)
        initrd /initramfs-linux.img
        options root=/dev/sda2 rw
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

