# Swap

## Create a swap partition

* Create partition

		fdisk <disk>
		n # Add a new partition
		<Enter> # Use default partition number
		<Enter> # Use default first sector
		+2G		# Make partition 2GiB large
		t 		# Change partition type
		<Enter> # Select partition to change
		L 		# List all partition types
		<number># Select number for swap
		p		# Print the partition table
		w 		# Write and exit

* Format and activate swap

		mkswap <swap-partition>
		swapon <swap-partition>

## Create a swap file

* Create the file

		fallocate -l 2GB /swapfile # The arch wiki recommends using dd instead
		chmod 600 /swapfile
		mkswap /swapfile
		vim /etc/fstab
		--------------
			/swapfile none swap defaults 0 0
		--------------
		
## Delete a swap partition

* Disable swap

		swapoff <swap-partition>

## Delete a swap file

* Disable swap

		swapoff <swap-file>
		rm -rf <swap-file>
		
## Systemd-swap

I haven't made a guide yet, but will definitely do one in the future.

## Configurations

### Swap encryption

Need to first figure out how this works myself.

### Swappiness

Determines how likely the system is to use swap

Lower value = unlikely  
Higher value = likely

On systems with much ram, a lower value may increase performance

* Get the current swappiness

		sysctl vm.swappiness
		
		Alternatively read the value from:
		cat /sys/fs/cgroup/memory/memory.swappiness
		or:
		cat /proc/sys/vm/swappiness
		
* Set the swappiness

		Set it temporarily:
		sysctl -w vm.swappiness=10

		To set it permanently create a configuration file:
		vim /etc/sysctl.d/99-swappiness.conf
		------------------------------------
			vm.swappiness=10
		------------------------------------
		
* **This guide isn't complete yet, but if your interested in how to increase performance, read this [article](https://rudd-o.com/linux-and-free-software/tales-from-responsivenessland-why-linux-feels-slow-and-how-to-fix-that).**

### Priority on multiple swap files/partitions

I will add this later...