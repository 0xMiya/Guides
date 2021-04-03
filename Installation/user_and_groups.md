# User and Groups

More information can be found on the [Arch Wiki](https://wiki.archlinux.org/index.php/Users_and_groups).

## Add a new user

* Add a new user

		useradd -mG wheel -s /bin/zsh miya
		
		m -> create a home directory for the user
		G -> add the user to the following sublementary groups (wheel)
		s -> specify the users login shell (/bin/zsh)
		miya -> the name of the user

* List all available login shell paths
	
		chsh -l

* Change a users login shell path

		chsh -s <login-shell-path>

* In order to be able to login as the new user, you need to set a password

		passwd miya
		
		passwd -> change a users password
		miya -> the user whose password you want to change (If no user is specified, the password of the current logged in user is changed)

## Change a username

You can't do that while your logged in as the user. First logout and login as root or any other user with sudo rights.

* Create a new login group

		groupadd miya
		
* Change the username

		usermod -d /home/miya -m -g miya -l miya shota
		
		d -> specifies the new home directory (/home/miya)
		m -> moves all files from the old home to the new home dir
		g -> specifies the users login group (miya)
		l miya shota -> change the name of the user "shota" to "miya"


* Tip: create a symlink to avoid problems with hardcoded paths

		ln -s <new-home> <old-home>
		
		Example:
		ln -s /home/miya/ /home/shota
		                ^            ^
		Important: make sure there is on trailing "/" after <old-home>
		
* Grant user sudo permissions

		usermod -aG wheel miya
		
		a -> append (instead of overwrite)		
		G -> specifies the sublementary groups (wheel)
		
Make sure to search for any paths still containing the old username and change them! If you followed the tip with creating symlinks, you should have avoided most problems.

	cd /
	sudo grep -r <old name> *

## Change the hostname

* Change the hosname

		hostnamectl set-hostname <hostname>
		
* Check the current hostname

		hostnamectl