# Network Time Protocol

Use ntp to autmatically set the correct time.

```ntp-client``` is used for one-time sync, usually during bootup, to help with
the ```ntpd``` startup, as ```ntpd``` initially waits before attempting to
correct the clock skew, and may even refuse to do so if the skew is too large.

## Install

```console
emerge --ask net-misc/ntp
```

## ntp-client

### Config

The config is in ***/etc/conf.d/ntp-client***. Select ntp servers that are nearby.

NTP Servers can be found on [ntp.org](ntp.org)

### Usage

Run the ntp-client:

```console
rc-service ntp-client start
```

Enable ntp-client to run at boot:

```console
rc-update add ntp-client default
```

Run it manually:

```console
ntpdate -b -u <ntp-server>

# For example:
ntpdate -b -u 0.gentoo.pool.ntp.org
```

## Ntpd

### Config

The ntp servers are configured in ***/etc/ntp.conf***. Choose servers that are
nearby.

NTP Servers can be found on [ntp.org](ntp.org)

On a system where network connection is not always available at boot, add the
following lines to the server configuration:

```file
server 127.127.1.0
fudge  127.127.1.0 stratum 10
```

#### Permissions

Prevent other machines from reconfiguring your server: nomodify
Prevent DOS: noquery

```file
restrict default nomodify nopeer noquery limited kod
restrict 127.0.0.1
```

### Usage

Start the ntpd service:

```console
rc-service ntpd start
```

Enable ntpd to autostart at boot:

```console
rc-update add ntpd default
```

Monitor status:

```console
rc-service ntpd status
```
