
	PalGenerator
	2016, by WhiteYoshiEgg


This tool creates .pal files from screenshots of Lunar Magic's palette editor.
May or may not be useful when you edit palettes in an external tool and don't
want to copy each color back over manually.


Usage: palGenerator.exe [image]

You can also open the program and enter the file path, or just drag an image
on top of the program icon.
Accepted image formats are PNG, BMP and JPG, though I don't recommend the latter.

The image doesn't have to be perfectly cut out! The tool will recognize
which part of the image looks like a palette. It also accounts for the
back area color if it can.


The output is a .pal file (in the same directory as the image), ready to be
imported back into LM (among others, such as YY-CHR).