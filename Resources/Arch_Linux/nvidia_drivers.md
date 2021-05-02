# Nvidia drivers

A guide on how to install the proprietary nvidia driver.

## Installation

If you use the normal "linux" or "linux-lts" kernel, just installing the "nvidia" package and rebooting should be enough.

For a custom kernel (like "linux-zen") install the "linux-dkms" package instead and create a pacman hook.

Really old gpu's aren't supported by the newest driver, but you can still find older driver versions in the aur.

* Install the driver

		pacman -Syu nvidia # for linux and linux-lts
		pacman -Syu nvidia-dkms # for linux-zen and other custom kernel

* Create a pacman hook (for custom kernel)

		sudo mkdir /etc/pacman.d/hooks # Create dir if it doesn't exist yet
		vim /etc/pacman.d/hooks/nvidia.hook
		-----------------------------------
			[Trigger]
			Operation=Install
			Operation=Upgrade
			Operation=Remove
			Type=Package
			Target=nvidia-dkms # Replace with the correct driver name
			Target=linux-zen # Replace with you kernel name
			
			[Action]
			Description=Update Nvidia module in initcpio
			Depends=mkinitcpio
			When=PostTransaction
			NeedsTargets
			Exec=/bin/sh -c 'while read -r trg; do case $trg in linux-zen) exit 0; esac; done; /usr/bin/mkinitcpio -P' # Also replace "linux-zen" with your kernels name
		-----------------------------------

* Generate configs

		pacman -Syu nvidia-xconfig
		sudo nvidia-xconfig
		
* Reboot

		reboot
		
* Check the current running kernel

		lspci -k | grep -A 2 -E "(VGA|3D)"