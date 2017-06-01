Interaction Editor
 by TheBiob

This tool allows you to set the players interaction points as well as change the sprite hitbox of the player.

Included files:
  InteractionEditor.exe - Executable, this is the tool.
  
  hitboxinfo.iedt - Interaction file, this contains the default values loaded by the tool.
  miniM.iedt - Interaction file, this contains mostly the default values but with small mario having a 8x8 hitbox.
  bigsmall_swap.iedt - Interaction file, this is a file where the big and small interaction points/sprite hitboxes are swapped. I used it for testing but someone find it useful so I left it included.
  
  template.asm - Template file, this is the default template file used for creating the patch. It simply edits the default values as well as installing a small hijack that makes the X and Width values of the sprite hitbox status dependend rather than hardcoded like in the original game.
  flagtemplate.asm - Template file, this is a file that will use the values inserted by the tool only when a certain flag is set.
  
  readme.txt - Readme, you're reading this. I don't think I need to say much more.


Template files:
  The template files can be edited. Here are a few things the template file should have:
    Line 0: This can specify what sprite hitbox mode the patch expects. See "Sprite Hitbox mode" for more information. It must be the first line in the file and must not contain anything else.
      While this isn't required it's useful for preventing unexpected results when used with the wrong sprite hitbox mode.
    Rest of the file: Patch. List of placenholders (case sensitive) below:
      IPointX: This will be replaced with the interaction point X positions in 16-bit
      IPointY: This will be replaced with the interaction point Y positions in 16-bit
      SpriteX: This will be replaced with the sprite hitbox X offsets. Length depending on sprite hitbox mode
      SpriteY: This will be replaced with the sprite hitbox Y offsets. Length depending on sprite hitbox mode
      SpriteW: This will be replaced with the sprite hitbox Width. Length depending on sprite hitbox mode.
      SpriteH: This will be replaced with the sprite hitbox Height. Length depending on sprite hitbox mode.

      SpriteXh: This will be replace with the sprite hitbox X offsets' highbyte. Only used in 8-bit sprite hitbox mode
      SpriteYh: This will be replace with the sprite hitbox Y offsets' highbyte. Only used in 8-bit sprite hitbox mode

Sprite hitbox mode:
  The sprite hitbox mode can be used to change the length of the sprite offsets. It can be change under "Settings > 16-bit Sprite hitbox"
  If the option is set the length of the tables will be 16-bit rather than the default 8-bits.
  The template file can specify what sprite hitbox mode it expects using:
;require 8bit
  for 8-bit mode
;require 16bit
  for 16-bit mode. This must be the first line of the template file. It is also case sensitive. The ; is required as well.

  Example:
    Without 16-bit sprite hitbox mode:
      SpriteX:
      db $02,$02,$02,$02
      SpriteY:
      db $1A,$0C,$20,$18
      SpriteXh:
      db $00,$00,$00,$00
      SpriteYh:
      db $06,$14,$10,$18
      SpriteW:
      db $0C,$0C,$0C,$0C
      SpriteH:
      db $1A,$0C,$20,$18
    With 16-bit sprite hitbox mode:
      SpriteX:
      dw $0002,$0002,$0002,$0002
      SpriteY:
      dw $001A,$000C,$0020,$0018
      SpriteW: ; Note: Even though this now is 16-bit the highbyte is never used and is therefore always 00
      dw $000C,$000C,$000C,$000C
      SpriteH: ; Note: Even though this now is 16-bit the highbyte is never used and is therefore always 00
      dw $001A,$000C,$0020,$0018