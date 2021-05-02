# cpuid2cpuflags

A program to automatically find matching USE flags

## Installation

	$ emerge --ask app-portage/cpuid2cpuflags

## Configuration

	$ mkdir /etc/portage/package.use	# If it doesn't exist yet
	$ echo "*/* $(cpuid2cpuflags) > /etc/portage/package.use/00cpuflags
