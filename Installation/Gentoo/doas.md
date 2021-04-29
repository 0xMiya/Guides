# Doas

Doas is an alternative do sudo, ported from BSD.

## Installation

	$ emerge --ask app-admin/doas

## Configuration

The configuration is stored in /etc/doas.conf

	$ vim /etc/doas.conf
	--------------------
	permit :wheel	# Allow all user of the wheel group to perform any action as root
	permit nopass :wheel # Same but without having to supply a password
	permit persist :wheel # Will remember a user and not ask for a password for 5 minutes

### Testing a configuration file

	$ doas -C <config-file>
	$ doas -C <config-file> <command>	# Test wether you have permission to execute <command>
	$ doas -C <config-file> <command> -u <user>	# Check permission of <user>

### Targets

Doas also allows to target certain user and groups

	permit nopass miya as shota	# Allows miya to perform actions as the shota user without providing a password
