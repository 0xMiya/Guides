# Setup Printers on Linux

## Kernel configuration

For locally attached printers (LPT):  
```
Device Drivers -->
	<*> Parallel port support
	<*> PC-style hardware
	[*] IEEE 1284 transfer modes
	Character Devices -->
		<*> Parallel printer support
```

For remotely attached printers (IPP and LPD):  
Enable networking support.

For remotely attached printers (CIFS):  
```
File systems -->
	Network File Systems -->
		<*> SMB3 and CIFS support (advanced network filesystem)
```

Rebuild the kernel.

## Cups

Check use flags

	emerge -pv net-print/cups

Add use flags

	sudoedit /etc/portage/package.use/<use-file>
	---
	# cups
	net-print/cups zeroconf <other use flags>

Install cups

	emerge -a --changed-use net-print/cups

## Additional software

### SAMBA

For SAMBA support, install net-fs/samba

	sudoedit /etc/portage/package.use/<use-file>
	---
	net-fs/samba cups
	---

	emerge -a --changed-use net-fs/samba

### Avahi

When build with the `zeroconf` USE flag, cups uses Avahi to scan for printers
on the local network.

Configure the kernel:
```
Networking support -->
	Networking options -->
		[*] IP: multicasting
```

Install the Avahi Server

	emerge -a net-dns/avahi

Enable the service:

	# OpenRC:
	rc-update add avahi-daemon default
	rc-service avahi-daemon start

	# SystemD:
	systemctl enable avahi-daemon.service
	systemctl start avahi-daemon.service

Restart the cups service and then list available printers:

	driverless list

## Configuration

In order to be allowed to print, a user needs to be part of the `lp` group.

	gpasswd -a <username> lp

In order to add printers and edit them:

	gpasswd -a <username> lpadmin

After adding a user to a group, logout and -in again, or temporarily authenticate
using `newgrp`:

	newgrp <groupname>

## Service

Enable and start the cups daemon:

	# OpenRC
	rc-update add cupsd default
	rc-service cupsd start

	# SystemD
	systemctl enable cups.service
	systemctl start cups.service

## HTTP Interface

Opening `http://localhost:631/` in a webbrowser allows root and users of the
lpadmin group to configure cups.

## Configuring a printer

List all connected priters:

	lpinfo -v

List all available drivers

	lpinfo -m

### Adding a printer using the webinterface

* Open `http://localhost:631/` in a browser. 
* In the Navbar, navigate to `Administration`.
* Click on `Add printer`.
* If you're asked to login, enter your username and password. The user has to be root or member of the `lpadmin` group.

From there it should be pretty straight forward.

### Adding a printer using the commandline

If you know the IP address:

	lpadmin -p <any-name-you-want> -E -v ipp://<priner-ip-address>/ipp -m everywhere

This will add the priner configuration and adds the files to `/etc/cups/ppd/`.

View the setup:

	lpstat -le

Set the default printer:

	lpstat -a
	lpoptions -d <printer-name>
	lpstat -t

## And now print :-)

	echo 'Hello Printer' | lp
