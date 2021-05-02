# ccache

ccache increases compile time by storing once compiled c/c++ object files in a
cache directory.

## Installation

	$ emerge --ask dev-util/ccache

## Configuration

(If it doesn't exist yet...)  
Create the cache directory:

	$ mkdir -p /var/cache/ccache
	$ chown root:portage /var/cache/ccache
	$ chmod 2775 /var/cache/ccache

Create the configuration file:

	$ vim /var/cache/ccache/ccache.conf
	-----------------------------------
		max_size = 100.0G
		umask = 002
		compiler_check = %compiler% -v
		cache_dir_levels = 3
		log_file = syslog

(...else continue here)  
Enable ccache support in make.conf:

	$ vim /etc/portage/make.conf
	----------------------------
		FEATURES="ccache"
		CCACHE_DIR="/var/cache/ccache"

## [Optional] Compression

Enable compression:

	$ vim /var/cache/ccache.conf
	----------------------------
		compression = true
		compression_level = 1

## More info

Visit 'man ccache' to get more info on how to make ccache more robust and agressive.

### Overview


