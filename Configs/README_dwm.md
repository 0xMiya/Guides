# My dwm build

My patched dwm build can be found in my-dwm-build/

Make sure to install "aur/nerd-fonts-complete" for the statusbar to work.

## Patches

I have installed several patches:

* dwm-status2d
* dwm-push\_no\_master
* dwm-attachside
* dwm-centeredmaster
* dwm-deck
* dwm-deck-double
* dwm-pertag
* dwm-fullgaps
* dwm-alternativetags
* dwm-6.2-urg-border

All these patches can be found on the official suckless [website](https://dwm.suckless.org/patches/).

You can install a patch using:

	patch -p1 < <patch.diff>

Note: If you install a lot of patches, some might fail and you have to patch them manually. I recommend you installing the largest patches first. If a small patch fails, you can just copy those few lines by hand.

## Keybindings

Since I use dvorak, I've changed my keybindings up a bit.

	super + e               -> open dmenu
	super + enter           -> open kitty
	super + shift + n       -> lock screen (using i3lock)
	super + F11             -> increase volume (I couldn't find another way to get those keys working)
	super + F12             -> decrease volume
	super + F1              -> create a screenshot (using scrot)
	super + F2              -> change keyboard-layout to ch (Swiss German)
	super + F3              -> change keyboard-layout to dvorak
	super + F4              -> change keyboard-layout to programmer dvorak
	super + l               -> show/hide status-bar
	super + h               -> focus next window
	super + t               -> focus previous window
	super + ctrl + h        -> push window down in the stack (push_no_master patch)
	super + ctrl + t        -> push window up in the stack
	super + c               -> increment number of masters
	super + g               -> decrement number of masters
	super + d               -> increment master area size
	super + n               -> decrement master area size
	super + shift + enter   -> make focused window master
	super + tab             -> switch between last two visited tags
	super + shift + j       -> kill focused window
	super + y               -> change layout to tiling
	super + u               -> change layout to floating
	super + m               -> change layout to monocle
	super + r               -> change layout to centered master
	super + shift + r       -> change layout to centered floating master
	super + p               -> change layout to deck
	super + shift + p       -> change layout to double-deck
	super + space           -> switch between last two chosen layouts
	super + shift + space   -> toggle focused window floating
	super + 0               -> activate all tags
	super + shift + 0       -> make focused window visible on all tags
	super + comma           -> focus previous monitor
	super + period          -> focus next monitor
	super + shift + comma   -> ?
	super + shift + period  -> ?
	super + x               -> increase gap size
	super + shift + x       -> decrease gap size
	super + b               -> toggle alternative tags
	super + <n>             -> show nth tag
	super + shift + escape  -> quit the wm
	super + shift + <n>     -> move focused window to nth tag

## slstatus

Slstatus takes up a lot of cpu, on a weaker computer you may want to search for a resource friendlier alternative.
