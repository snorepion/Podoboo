  _____                    _____ ________   __
 / ____|                  / ____|  ____\ \ / /
| (___  _ __   ___  ___  | |  __| |__   \ V / 
 \___ \| '_ \ / _ \/ __| | | |_ |  __|   > <  
 ____) | | | |  __/\__ \ | |__| | |     / . \ 
|_____/|_| |_|\___||___/  \_____|_|    /_/ \_\
      Version 2.62        by Vitor Vilela


SnesGFX is a utility to convert images to SNES and RAW format without difficult.

This tool supports most known basic image formats, like PNG, BMP, JPEG and GIF.

SnesGFX can output to all known SNES bitmap format, which is: 2BPP GB, 3BPP SNES,
4BPP SNES, 8BPP SNES, 2BPP Linear, 4BPP Linear, 8BPP Linear, 2BPP Packed, 4BPP Packed and Mode 7.

Also SnesGFX can decrease the number of colors with pnquant to fit format limitations or
the amount you would like to the image use.

Since version 2.60, you can generate SNES tilemap or a sample level (.mwl) with the background ready
to be inserted on Super Mario World or other game.

Features:
	- Supports most known image formats like PNG, BMP, JPEG and GIF.
	- Supports all known SNES planar format which is, 2BPP GB, 3BPP SNES, 4BPP SNES and 8BPP SNES.
	- 2BPP, 4BPP and 8BPP Linear support.
	- 2BPP and 4BPP Planar support.
	- Mode 7 format support.
*NEW*	- Mode 7 tilemap support.
*NEW*	- Mode 7 interleaved support.
	- Can resize image before conversion.
	- The user can specify the number of colors the output image will have.
	- Can split output image into blocks of 512 bytes or 1, 2, 4 or 8 KiB.
	- Has a remove duplicate tiles option.
	- Can generate a raw Map16 file
	- Can generate a raw tilemap file to be inserted on VRAM.
	- Can generate a sample level with the compiled background
	- Exports palette into YY-CHR format (.pal)
	- Can export palette to LM/RAW format (.mw3)
	- Can export palette to Tile Layer Pro format (.tpl)
	- Can count number of colors.
	- Can export into SnesGFX's folder or image's folder.
	- Arrange Colors function by hue, saturation, brightness or manually.
	- Can specify transparent color.
*NEW*	- Can output color math friendly images with CGADSUB Mode.
*NEW*	- Flip X/Y support on/off

----------------------------------------------------------------------------
How to use:

1. Pick a (decent) image of what you want to convert. Can be a spritesheet or even a background.

2. Click on "Browse" button and select your image.

3. Choose the output format (normally SNES 4BPP), colors (16 at default), palette (normally YY-CHR)
and tilemap (I'd select Map16 for FG, Map16+MWL or SNES tilemap if BG or No tilemap output if you're
working with sprite sheets).

4. Check and uncheck the options you want. I recommend checking "Accurate Conversion",
"Optimize Image", "Arrange Colors", "Remove Duplicated (or Flipped Tiles)" and
"Split" with 4KiB selected.

If you're ripping a sprite sheet, select handle transparency and click on button "..." to select the
best configuration for detecting the transparent color. Note that if you select a wrong option, the
result may be odd.

5. Click in preview to see how the image converted will look. Note that if you have picked
"Remove Duplicated (or Flipped Tiles)", all tiles will be misplaced since the Preview window
doesn't process tilemap. If everything is ok in preview, clique in Save and all files
required will be generated on Image or Tool folder.

6. Import all files into Lunar Magic or other program you would like. Note that the files generated
is not really ready to be inserted, you may have to do some remapping to show correctly.

SnesGFX may generate the following files:

example.bin --> output image file on format requested.
example.pal/.mw3/.tpl --> output palette file on YY-CHR/MW3/Tile Layer Pro format.

***If output map16 or SNES tilemap option was selected on tilemap***
example_map16.bin --> The map16 file. It's in same format as Map16Page.bin,
so you have to import on Lunar Magic as "Raw Map16Page". If you selected SNES
tilemap, that's the tilemap file. You may need some remapping if the image size
is not 256x256 or 512x512.

***If output map16+mwl was selected***
example.mwl --> a sample level to be used with Lunar Magic. it includes the compiled background
and the palette. Note you will need to remap the tiles to another map16 range and edit the palette
to you get able to use on your SMW hack.

***IF SPLIT WAS ENABLED ON CONVERSION***
example_part00.bin --> output image in format request part 00
example_part01.bin --> ''''''''''''''''''''''''''''''''''' 01
example_partXX.bin --> ''''''''''''''''''''''''''''''''''' XX
And so. The number is hexadecimal.

Important: SnesGFX only does the 'hard' job for you. Only this.
It won't create a perfect compiled background, nor merge the
output palette with SMW and much less will remap the output
to use BG1-3. You can easily do this job by using Lunar Magic's
remap and palette editor.

----------------------------------------------------------------------------
Mode 7

Since version 2.62, SnesGFX can output mode 7 tilemap files. It means you
can now rip any image up to 1024x1024 into a mode 7 background.

Note that, unlike other tilemap formats, this one has some limitations:
 - You can't flip tiles. So you should disable "Remove flipped tiles" option,
or SnesGFX will throw a error.
 - You're limited to 128x128 character map. Even though you can insert
1024x1024 images, all of them should fit on a 128x128 image after removing all
duplicated 8x8 tiles. If SnesGFX throw a error that the image has more than
0x100 tiles, you will need to resize the image and compensate in game with zoom.
 - The mode 7 tilemap format obviously only works with mode 7 GFX format.

You can also use "Output Interleaved Mode 7 Tilemap". This one will interleave
the tilemap and the gfx into a single file, so you can insert directly to the
VRAM using a single and simple DMA.

And of course, with Mode 7 you can scale, rotate and do anything the 2x2 matrix
and HDMA, but SnesGFX won't set up anything for you, just the GFX and tilemap.

Those functions are only recommended to who know how to use Mode 7.

----------------------------------------------------------------------------
CGADSUB Mode

This mode is pretty useful for 32-bit images with variable transparency.
It decreases the brightness of each pixel based on transparency (0 = black,
127 = 50% darker, 255 = normal), making the image have almost the same effect
using Color Math (Addition). You can set maximum transparency (if the trans-
parency level is greater than the value, then the pixel won't get darker)
and make it even more darker with "tolerance", which actually just divides
the pixel brightness by 1 to 8, useful if the layer(s) which the image will
get added is too bright.

On SMW, consider level mode 0x1E or 0x1F as example.

Again, this option should only be used to who are really good with graphics.

----------------------------------------------------------------------------
Known issues/questions:

Question: Help! SnesGFX answered with following error: "pngquant has quit
with exit code <some number>". What should I do?

Answer: This may happen because of various reasons. Make sure that the
SnesGFX and pngquant can write on local folder which the tools are in and you did not
replace pngquant.exe with other version.

----------------------------------------------------------------------------
Thanks to all pngquant devlopers for the awesome tool. Without pngquant, it would
be almost impossible to convert any image to SNES format because of color limitations.

Improved PNGQuant is
- Copyright (C) 1989, 1991 by Jef Poskanzer
- Copyright (C) 1997, 2000, 2002 by Greg Roelofs; based on an idea by Stefan Schneider.
- Copyright (C) 2009-2012 by Kornel Lesinski.

----------------------------------------------------------------------------
If you want to contact me for anything, feel free to drop me a PM at SMW Central.
My profile is Vitor Vilela, with userid 8251. http://smwc.me/u/8251.