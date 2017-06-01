Sprite Graphics Routine Creating Tool.
Created by JackTheSpades
Version 1.1


If you find any Bugs or Spellings... please report them to me.
I'll try to fix things with the next update.


==============================================================================================
Short Creator Note:
----------------------------------------------------------------------------------------------
Hey there, Jack here.
This tool is my first step towards a future where people no longer need to know ASM to create
blocks and sprites. For this tool though, you still need it. It's just the Graphics routine
after all. The rest of the sprite still need to be handcoded (for now)

Anyway, for those of you who are already quite skilled with ASM, you may use this tool to save
some time.

I've also heared, that some find the generated code, ugly or unsighty, with lots of unneccesary
labels and loops which aren't loops...
Well duh?
If you are on of those, I'd like to remind you, that the code is generated from an algorith.
This algorithm has to addapt itself to whatever crazy shenanigan the user of the tool might create
in the treeview. I can't use tables if I don't know for sure, that every frame of an animation has
the same amount of tiles.

Anyway, thanks for downloading
===============================================================================================


###############################################################################################
#	LOGS
###############################################################################################
# Version: 1.0
#---------------------------------------------------------------------------------------------
# Short Tutorial: http://www.smwcentral.net/?p=viewthread&t=67594&page=1&pid=1055255#p1055255
#
###############################################################################################
###############################################################################################
# Version 1.1
#---------------------------------------------------------------------------------------------
# * Added xkas compiler. Go to Settings to choose whether your sprite is coded for xkas or TRASM
#
# * Bug fixes:
#	-old tiles not being able to be moved after loading .grc file
#	-tiles loosing their X and Y-Flip apperance after changing palette and/or GFX
#	 (only if set in the settings to update)
#	-context menu not showing X/Y Flip, Properties or other things correctly after loading
#	 .grc files
#	-Tiles which were selected (inverted colors) while saving are no longer permanently
#	 inverted after loading
#
# * Update Button now only neccessary to refresh the grid. Palettes and GFX will stay permanently
# * Palettes and GFX also displayed faster
#
###############################################################################################