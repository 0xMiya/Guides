# Resize a partition

* Install parted

		$ emerge --ask sys-block/parted

* Resize the partition

		$ parted /dev/sda
		(parted) p
		(parted) Fix
		(parted) resizepart 2 -1	# 2 -> the partition to resize, -1 -> take all free space
		(parted) Yes
		(parted) p					# check that it worked
		(parted) q

* Resize the filesystem

		$ resize2fs /dev/sda2	# resize the filesystem
		$ dmesg | grep EXT4		# check the operation
		$ df -h					# check that it worked

* Reboot 

		$ touch /forcefsck	# force a filesystem check
		$ reboot
