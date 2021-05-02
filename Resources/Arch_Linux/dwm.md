# DWM

This guide is for dwm on xorg. If you want to use wayland, there's dwl, which is basically just dwm for wayland.

# Installation

* Install xorg

		pacman -Suy xorg xorg-server xorg-xinit xorg-xrandr xorg-xsetroot
		
	If you want to set a background image, you should also install nitrogen
	
* Download dwm

	There are different ways to get dwm. To get it from the official download-link:
	
		pacman -Suy wget tar # If you haven't installed those yet
		wget https://dl.suckless.org/dwm/dwm-6.2.tar.gz
		
	Should this link stop working, go to [suckless dwm](https://dwm.suckless.org/) and search for the correct link.
	
		tar -xvzf dwm-6.2.tar.gz # Unzip the tar archive
		cd dwm-6.2
		sudo make clean install
	
* [Optional] Create a desktop file

	If you use a graphical login manager you will probably need this file. If you use startx to start dwm you can skip this step.
	
		vim /usr/share/xsessions/dwm.desktop
		------------------------------------
			[Desktop Entry]
			Encoding=UTF-8
			Name=Dwm
			Comment=Dynamic window manager
			Exec=dwm
			Icon=dwm
			Type=XSession
		------------------------------------
		
	Not everything is needed, this is just an example.

* [Optional] Create a .xinitrc file

	If you want to start your window manager using startx, first install xorg-xinit.
	
		pacman -Suy xorg-xinit
		
		vim ~/.xinitrc
		--------------
			exec dwm
		--------------
		
	Make sure to always keep "exec dwm" at the very last line of the file!

	You can find an example xinitrc file under *Configs/.config/example_xinitrc*

* Start dwm

		startx
		
	This should start dwm now. There is still a lot of configuration to do, so lets exit again.
	
		Press: left-alt + left-shift + q
		
* Let's first configure our keymap for X11

		localectl set-x11-keymap <keymap>
		
	For example:
	
		localectl set-x11-keymap dvorak # This will set your layout permanently, setxkbmap <layout> will set it only for the current session
		
		# Use 
		#	localectl list-x11-keymap-models
		#	localectl list-x11-keymap-layouts
		#	localectl list-x11-keymap-variants
		# To get a list of available models, layouts and variants (see "man localectl")

* Install dmenu

	If you use dwm, you probably also want to use dmenu as your application launcher
	
		wget https://dl.suckless.org/tools/dmenu-5.0.tar.gz
		tar -xvzf dmenu-5.0.tar.gz
		cd dmenu-5.0
		sudo make clean install

* Also install a terminal you like, for example kitty

		pacman -Suy kitty
		
* Make sure to install a suitable font. I really like ttf-dejavu:

		pacman -Suy ttf-dejavu
		fc-cache
		fc-match monospace # Make sure that it is set as monospace
		
## Configuration

* Inside of the dwm-directory, open the config.def.h

		vim config.def.h
		
	Per default, the left-alt key is used as the modifier. If you prefer to use the super (windows) -key, search for the line:
	
			#define MODKEY Mod1Mask
			
	and change it to "Mod4Mask"
	
	For your terminal, edit this line and replace st with the name of your terminal
	
		static const char *termcmd[]  = { "st", NULL };
		
	Inside of "static Key keys[] { ..." all the keybindings are defined.  
	I recommend you reading through this to find out what dwm lets you do and change this keybindings until you are happy with it.
	
* After configuring

	Once you finished your configuration, save the file and copy it to config.h. Then rebuild and test it out.
	
		cp config.def.h config.h
		sudo make clean install
		startx

* My configs

	I've uploaded my config files under *Configs/*
	
### Tip

Per default, if you hover with your mouse over a window, it immediately gets the focus. If you don't wont the focus to change on mouse-hover, there is a patch called "focusonclick".

This patch however breaks a lot more then just mouse-hovering. Instead I recommend you just commenting out this line in dwm.c:

	vim dwm.c
	---------
	Comment out the entire line:
		[EnterNotify] = enternotify,
	---------

Since my version of dwm is heavily patched, I cannot give you the exact line number. In vim, just press "/" and then enter the text you want to search for. Press "n" to jump to the next search-result.

Now the focus only changes if you click into a window.