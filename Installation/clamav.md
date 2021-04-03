# ClamAV

## Installation

* Install clamav

		paru clamav

* [Important!] Update the virus signature database  
You need to do this before you activate the service, else you might run into trouble.

		freshclam # Might needs sudo

* Enable and start the auto-updating service

		systemctl enable clamav-freshclam.service
		systemctl start clamav-freshclam.service

* Enable and start the clamav-daemon

		systemctl enable clamav-daemon.service
		systemctl start clamav-daemon.service
		
* Test if its working

		curl https://secure.eicar.org/eicar.com.txt | clamscan -
		
		Output should contain:
		stdin: Win.Test.EICAR-HDB-1 FOUND

* Install unofficial signatures

		paru python-fangfrisch
		sudo -u clamav /usr/bin/fangfrisch --conf /etc/fangfrisch/fangfrisch.conf initdb
		systemctl enable fangfrisch
		
### On-access-scan

Scans a file while reading, writing or executing

* Only works if the FANOTIFY module is enabled, check it:

		zgrep FANOTIFY /proc/config.gz
		
* Configure

		vim /etc/clamav/clamd.conf
		--------------------------
			ScanOnAccess true
			OnAccessMountPath /
			OnAccessMountPath /home
			OnAccessPrevention false
			OnAccessExtraScanning true
			VirusEvent /etc/clamav/detected.sh
			User root
		--------------------------
		
		sudoedit /etc/clamav/detected.sh
		--------------------------------
			#!/bin/bash
			PATH=/usr/bin
			alert="Signature detected: $CLAM_VIRUSEVENT_VIRUSNAME in $CLAM_VIRUSEVENT_FILENAME"
	
			# Send the alert to systemd logger if exist, othewise to /var/log
			if [[ -z $(command -v systemd-cat) ]]; then
			        echo "$(date) - $alert" >> /var/log/clamav/detections.log
			else
			        # This could cause your DE to show a visual alert. Happens in Plasma, but the next visual alert is much nicer.
	    		    echo "$alert" | /usr/bin/systemd-cat -t clamav -p emerg
			fi
	
			# Send an alert to all graphical users.
			XUSERS=($(who|awk '{print $1$NF}'|sort -u))
	
			for XUSER in $XUSERS; do
			    NAME=(${XUSER/(/ })
			    DISPLAY=${NAME[1]/)/}
			    DBUS_ADDRESS=unix:path=/run/user/$(id -u ${NAME[0]})/bus
			    echo "run $NAME - $DISPLAY - $DBUS_ADDRESS -" >> /tmp/testlog 
			    /usr/bin/sudo -u ${NAME[0]} DISPLAY=${DISPLAY} \
			                       DBUS_SESSION_BUS_ADDRESS=${DBUS_ADDRESS} \
			                       PATH=${PATH} \
			                       /usr/bin/notify-send -i dialog-warning "clamAV" "$alert"
			done
		--------------------------------
		
		systemctl restart clamav-daemon.service
		
### To fix some problems with freshclam

		touch /run/clamav/clamd.ctl
		chown clamav:clamav /run/clamav/clamd.ctl
		sudoedit /etc/clamav/clamd.conf
		-------------------------------
		Uncomment:
			LocalSocket /run/clamav/clamd.ctl
		-------------------------------
		
		systemctl restart clamav-daemon.service

## Usage

### Manually scanning

If you use the clamav-daemon, use clamdscan instead (see below)

* Scan a file

		clamscan <file>

* Scan a directory

		clamscan -r -i <dir>
		
* Also scan larger files (max possible value is 4000M)

		clamscan -r -i <dir> --max-filesize=4000M --max-scansize=4000M
		
* Print the output to a file

		clamscan <other parameters> -l <output-file.txt>
		
### Multithreaded filescanning with the daemon

* Configure number of threads used

		sudoedit /etc/clamav/clamd.conf
		-------------------------------
			MaxThreads 20
		-------------------------------
	
* Scan a file or directory

		clamdscan --multiscan --fdpass <dir>