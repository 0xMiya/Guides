# MCE (Hardware error logging)

Enable all MCE features in the kernel configuration.

Install rasdaemon or mcelog.

## Rasdaemon

The package is currently masked as unstable, so you need to unmask it first:

```console
echo "app-admin/rasdaemon ~amd64" >> /etc/portage/package.keywords
```

Then enable sqlite support, to write events to disk:

```console
echo "app-admin/rasdaemon sqlite" >> /etc/portage/package.use
```

Finally install rasdaemon itself:

```console
emerge app-admin/rasdaemon
```

Configure rasdaemon (OpenRC specific):

```console
vim /etc/conf.d/rasdaemon
-------------------------
	RASDAEMON_ARGS="--record"
```

Add rasdaemon to the default run-level and start it:

```console
rc-config add rasdaemon default
/etc/init.d/rasdaemon start
```

## Mcelog
