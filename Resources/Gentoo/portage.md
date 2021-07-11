# Portage

Gentoos package manager.

Completely written in Python and Bash.

Most of the time 'emerge' is used to interact with Portage. See 'man emerge'.

## Gentoo repository

A collection of ebuilds.

### Ebuilds

Files that contain all information Portage needs to maintain software (install,
search, query, etc.)

Stored in ***/var/db/repos/gentoo***.

It is important to regularly update the ebuilds on the system so Portage knows
about new software, security updates, etc.

### Updating the Gentoo repository

Usually rsync, a fast incremental file transfer utility, is used to update the
repository.

	$ emerge --sync

***Don't sync more than once every 24h, or you might get banned!***

If firewall restriction prevent rsync from contacting the mirrors, use webrsync
instead

	$ emerge-webrsync

An additional advantage of using webrsync is, that it allows to only pull snapshots
that are signed by the Gentoo release engineering GPG key.

## Maintaining software

### Searching for software

Search for a package that contains "lolcat" in its name

	$ emerge --search lolcat	# or '-s'

Also search through the package description

	$ emerge --searchdesc lolcat	# or '-S'

### Installing software

Install using emerge:

	$ emerge --ask <title>

	# For example:
	$ emerge --ask games-misc/lolcat

To find out what dependenies Portage would install, use '--pretend'. This will not
actually install anything, just pretend it does:

	$ emerge --pretend games-misc/lolcat

During the installation, Portage will download the necessary source code and store
it in ***/var/cache/distfiles/***. After this it will unpack, compile and install
the package.

To tell Portage to only download the sources without installing them, use the
'--fetchonly' option:

	$ emerge --fetchonly games-misc/lolcat

### Finding installed package documentation

Many package have their own documentation. Sometimes the 'doc' USE flag determines whether
the package documentation should be installed or not.

Check if the 'doc' USE flag is used by a package:
	
	$ emerge -vp media-libs/alsa-lib

If you want the documentation to be installed, add it to the USE flag, either in
***/etc/portage/make.conf*** or on a per-package basis in ***/etc/portage/package.use***.
(So that only documentation for wanted packages is installed).

Once a package is installed, its documentation is usually found in a subdirectory
named after the package in ***/usr/share/doc***.

To easily list installed documentation use 'equery's '--filter' option:

	$ equery files --filter=doc alsa-lib	# man 1 equery

'equery' is part of 'app-portage/gentoolkit'

### Removing software

To safely remove software, tell portage that a package is no longer required:

	$ emerge --deselect <title>

To remove all packages that are not needed anymore:

	$ emerge --depclean

### Updating the system

First sync the repository (--sync), then update the system:

	$ emerge --sync
	$ emerge --update --ask @world

Portage will then search for newer version of the applications that are installed,
but it will only do this for explicitly installed packages (the ones listed in
***/var/lib/portage/world***) - it does **not** check their dependencies.

To update the dependencies as well, use the '--deep' option:

	$ emerge --update --deep --ask @world

This still doesn't include build dependencies (packages that are only needed during
compile time and build process of packages). To also update those, add '--with-bdeps=y':

	$ emerge --update --deep --with-bdeps=y --ask @world

If the USE settings of the system have been altered, also add '--newuse'. Portage
will then verify if the changes require the installation of new packages or
recompilation of existing ones:

	$ emerge --update --deep --with-bdeps=y --newuse --ask @world
	$ emerge -uvDNa --with-bdeps=y @world # same but shorter version

If you get a message saying that config files need to be updated use 'etc-update'
and select the option '1' (replace the old file).

### Metapackages

Packages that contain a collection of packages. For example 'kde-plasma/plasma-meta'
will install various Plasma-related packages as dependencies.

To remove such a packages, running 'emerge --deselect' won't have an effect, the
dependencies remain on the system.

First update the entire system fully, then run '--depclean':

	$ emerge --update --deep --with-bdeps=y --newuse @world
	$ emerge --depclean

## Licenses

It is possible to accept or reject software installation based on its license.
'emerge -s \<category/package\>' will show the license of a package.

What licenses to permit is configured in make.conf by the 'ACCEPT_LICENSES' variable:

	$ vim /etc/portage/make.conf
	----------------------------
		ACCEPT_LICENSE="-* @FREE"

Take a look at the licens-table in the installation guide (gentoo.md).

To specify the license on a per-package basis use the ***/etc/portage/package.license***
file.

	# To accept the google-chrome license:
	$ vim /etc/portage/package.license
	----------------------------------
		www-client/google-chrome google-chrome

Licenses are stored in ***/var/db/repos/gentoo/licenses/*** and license groups
in ***/var/db/repos/gentoo/profiles/license_groups***.

The first entry of each line in CAPTIAL letters is the name of the license group,
and every entry after that is an individual license.

License groups in the ACCEPT_LICENSE variable need to be prefixed with an '@'.

To accept all licenses except EULAs:

	$ vim /etc/portage/make.conf
	----------------------------
		ACCEPT_LICENSE="* -@EULA"	# This setting will also accept non-free software and documenation

## Portage complaints

### Different versions of the same package

Different versions of a single package can coexist on a system. Most distribution
accomplish this by using different packages for different versions (eg. freetype and
freetype2). Portage instead uses a technology called SLOTs.

An ebuild declares a certain SLOT for its version. Ebuilds with different SLOTs
can coexits.

Eg. freetype has ebuilds with SLOT="1" and SLOT="2".

### Virtual packages

There are packages that provide the same functionality, but are implemented
differently.

For example, metalogd, sysklogd and syslog-ng are all system loggers.

Applications that rely on a system logger, cannot depend on a specific logger,
as the other loggers are as good a choice as any.

Because of that Portage has "virtuals". Each system logger is listed as an
exclusive dependency of the virtual system logger package (virtual/logger). That
way, applications can depend on the virtual logger package. When installed, the
package will pull in the first logging package listed in the virtual package,
unless a logging package is already installed.

### Branches

Packages in the Gentoo repository can reside in different branches. By default
only packages from the stable branch are accepted. Gentoo will not update a
package, until the ebuild is placed in the stable branch.

There are also branches per architecture (Some software is only available for
specific architectures).

### Blocked packages

Ebuilds contain specific fields to inform Portage about dependencies.

Variable | Description
-------- | -----------
DEPEND   | build dependencies
RDEPEND	 | runtime dependencies

When one of these dependencies explicitly marks a package or virtual as being
not compatible, it triggers a blockage.

To fix a blockage, either chose not to install the package (if possible) or
unmerge the conflicting package first.

Sometimes there are also blocking packages with specific atoms (versions). In 
this case update to a more recent version, to resolve the blockage.

### Masked packages

When trying to install a package that isn't available for the system, a masking
error occurs.

Reason for mask | Description
--------------- | -----------
~arch keyword   | The application is not tested enough to be put in the stable branch. Wait a few days/weeks and try again.
-arch keyword or -* keyword | The application does not work on your architecture.
missing keyword | The application has not been tested on your architecture yet.
package.mask    | The package has been found corrupt, unstable or worse and has been deliberately marked as do-not-use.
profile         | The package is not suitable for the current profile and might brake the system if installed.
license         | The packages license is not compatible with the ACCEPT_LICENSE value. Permit the license and try again.

### Unmask a package

```console
echo "<package> <masking-keyword>" >> /etc/portage/package.keywords
```

### Necessary USE flag changes

This warning or error occures when a package not only depends on another package,
but also requires that that package is built with (a) particular USE flag(s).

Either set the requested USE flag(s) in ***/etc/portage/make.conf*** (globally)
or just set it for the specific package in ***/etc/portage/package.use***.

### Missing dependencies

The application to install depends on another package that is not available for
the system.

**Unless the system is configured to mix branches, this should not occur and is
therefore a bug.** Please report it.

### Ambiguous ebuild name

The application to install has a name that corresponds with more than one package.
Supply the category as well to resolve this.

	# listen corresponds with:

	dev-tinyos/listen

	media-sound/listen

### Circular dependencies

Two or more packages to install depend on each other and can therefore not be
installed.

**This is possibly a bug, resync and try again, else report it.**

### Fetch failed

Portage was unable to download the sources and will try to continue installing
the other applications (if possible).

This failure can be due to a mirror that has not synchronized correctly or because
the ebuild points to an incorrect location. Or the server can also be down for
some reason.

Retry after an hour.

### System profile protection

The user tried to remove a package that is part of the system's core packages.
It is listed in the profile as required and should therefore not be removed from
the system.

### Digest verification failure

Probably somethings wrong with the Gentoo repository - often because of a mistake
made when committing an ebuild to the repo.

It is likely that the error was noticed rigt away, but can take a little time for
the fix to "trickle down" the rsync mirrors. Check the Bugzilla if the problem
was already reported, else report it yourself.

Once the bug has been fixed, resync and try again.

## Tricks

Instead of having to unmask dozens of packages manually, unmask them all at once:

	ACCEPT_KEYWORDS="~amd64" emerge -a <package>
