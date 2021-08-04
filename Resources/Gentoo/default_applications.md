# Default Applications

Let's say you have a file "hello.pdf" and you want to change the default
application that it opens with to Zathura.

1. Get the mime-type

		xdg-mime query filetype hello.pdf
	
	The output should be something like:
	
		application/pdf

2. Get the current default application

		xdg-mime query default application/pdf
	
	This may output something like:
	
		org.gnome.Evince.desktop

3. Create a .desktop file

	We need a desktop file for Zathura. Check if one already exists inside of
	`/usr/share/applications`.

	If not create it. The content should look similar to this:

		[Desktop Entry]
		Type=Application
		Name=Zathura
		Exec=zathura %U
		Terminal=false

4. Set the default application

		xdg-mime default zathura.desktop application/pdf


5. Try it out!

	If you now open the pdf

		xdg-open hello.pdf

	it should open in Zathura.
