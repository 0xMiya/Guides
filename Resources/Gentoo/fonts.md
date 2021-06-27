# Linux Font Config

## Install fonts

### Per-user

To make a font available for one user only, create the `~/.fonts` directory.

	mkdir ~/.fonts

Now move your TTF (True Type Fonts) and OTF (Open Type Fonts) to that directory.

### Systemwide

Use the `/usr/share/fonts/truetype` (for TTF) and `/usr/share/fonts/opentype` (
for OTF) directories instead.

Next type a user logs in, those fonts should be available to them.
To find the fonts without re-logging, run `fc-cache`.

## Font Tweaking

* Font Hinting: The use of mathematical instructions to adjust the display of a font outline so that it lines up with a rasterized grid.
* Anti-aliasing: The technique used to add greater realism to a digital image by smoothing jagged edges on curved lines and diagonals.
* Scaling factor: A scalable unit that allows you to multiple the point size of a font. So if you’re font is 12pt and you have an scaling factor of 1, the font size will be 12pt. If your scaling factor is 2, the font size will be 24pt.

TODO: Write this section

## Font Configuration

TODO: See `man 5 fonts-conf`, `/etc/fonts`.
https://wiki.archlinux.org/title/Font_configuration
https://wiki.archlinux.org/title/Font_configuration/Examples
https://jichu4n.com/posts/how-to-set-default-fonts-and-font-aliases-on-linux/

Find default fonts:

	for family in serif sans-serif monospace Arial Helvetica Verdana "Times New Roman" "Courier New"; do
	  echo -n "$family: "
	  fc-match "$family"
	done

List all installed fonts

	fc-list

Systemwide font config resides in `/etc/fonts/`, per-user configs in `~/.config
fontconfig/fonts.conf` (previously in `~/.fonts.conf`).

NOTE: Put custom systemwide config in `/etc/fonts/local.conf`.

Create a font config:

	vim ~/.config/fontconfig/fonts.conf
	---
	<?xml version='1.0'?>
	<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
	<fontconfig>
	</fontconfig>

Put all custom configuration between `<fontconfig>` and `</fontconfig>`.
