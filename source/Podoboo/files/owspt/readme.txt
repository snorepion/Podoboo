	   OW Spritetool
	     by Alcaro
		&
	    wiiqwertyuiop

--------------------------------

    User manual:
1. Put xkas and owsp.asm in the same folder as the tool.
2. Do not add a file called tmpasm.asm in the folder of the tool.
3. Add the sprites you want to osprites.txt. The sprites from carol's OW Sprite Editor are already included, but you probably want to edit some stuff.
4. Note that you'll need to edit the binary numbers to make your sprites not appear on all submaps. From left, each digit corresponds to Main map, Yoshiís island, Vanilla dome, Forest, Bowserís valley, Special zone, Star road. 0 is not available and 1 is available.
5. If you want a sprite to appear on two different submaps, you can enter DUPE:(id) as filename and it'll reuse the code from another inserted OW sprite.
6. Doubleclick on the tool and it'll prompt you for the filenames; or you can give the names on the command line (rom name first, then the name of the sprite list). The extensions are obligatory.
7. Instructions for using ExGFX (taken from the read me in carol's sprite OW tool with grammar changes): 

	Open your ROM in a hex editor, and jump to PC address 0x2B07; Åg10 0F 1C 1DÅh can be found.
	This corresponds to the SP1-SP4 GFX file numbers for OW sprites.
	By changing these numbers to something from 80 to FF, ExGFX files can be used, however, you canÅft use ExGFX past 100.
	The original OW sprites use most of SP1 and the switch block in SP2.
	To use the included ExGFX file, rename SP2.bin to ExGFXzz.bin and insert intto the ROM with Lunar Magic, and change PC address 0x2B08, from 0F to zz.

--------------------------------

    Spriting instructions:
1. Your sprite must not use namespaces.
2. Your sprite must not contain "header", "lorom", "org".
3. Your sprite must contain a "Main:" label (case sensitive). The code will start running here.
4. All OW sprite codes runs in the same rom bank, so please don't put any giant tables there.
5. Labels ("Graphics:"), sublabels (".loop"), and +/-labels ("++") are allowed.
6. Do not use the print command, the tool will think it's an error.
7. Your sprite code must end with RTS. PHB PHK PLB is already used, so don't bother with that.
8. Be careful with defines and macros, they aren't affected by namespaces. Please don't use anything with generic names, like !XSpeed. !FlyingYoshiXSpeed is far less likely to mess up anything else.
9. Also something worth noting maybe: $7FFF80 will make mario invisible on the OW.