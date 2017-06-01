;require 8bit

org $00E832
IPointX:

org $00E89E
IPointY:

org $03B65C
SpriteY:

org $03B660
SpriteH:

org $03B665
autoclean JML Hitbox

freecode
SpriteX:
SpriteW:

Hitbox:
	LDX #$00
	LDA $73 
	BNE .ducking
	LDA $19
	BNE .big
.ducking
	INX
.big
	LDA $187A
	BEQ .noYoshi
	INX #2
.noYoshi
	LDA $94
	CLC : ADC.l SpriteX,x
	STA $00
	LDA $95
	ADC #$00
	STA $08
	LDA.l SpriteW,x
	STA $02
	JML $03B688