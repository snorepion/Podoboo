;require 8bit
; If the flag is non-0 it will use custom hitbox info. Otherwise it'll use the default hitboxes

!RAM_flag = $5C

org $03B688
autoclean JML HitboxCheck

org $00F44F
autoclean JML CollisionCheck

org $00EBA5
autoclean JML MoreCollisionCheck

freecode
IPointX:
IPointY:

SpriteX:
SpriteY:
SpriteW:
SpriteH:


HitboxCheck:
	LDA !RAM_flag
	BNE .newHitbox
	LDA.l $03B660,x
	JML $03B68C
.newHitbox
	LDA $94
	CLC : ADC.l SpriteX,x
	STA $00
	LDA $95
	ADC #$00
	STA $08
	LDA.l SpriteW,x
	STA $02
	LDA.l SpriteH,x
	STA $03
	LDA $96
	CLC : ADC.l SpriteY,x
	STA $01
	LDA $97
	ADC #$00
	STA $09
	JML $03B69D

CollisionCheck:
	LDA !RAM_flag
	BNE .newHitbox
	REP #$20
	LDA $94
	JML $00F453
.newHitbox
	REP #$20
		LDA $94
		CLC : ADC.l IPointX-2,x
		STA $9A
		LDA $96
		CLC : ADC.l IPointY-2,X
		STA $98
		JML $00F461

MoreCollisionCheck:
	LDA !RAM_flag
	BNE .newHitbox
	LDA $90
	CLC : ADC.l $00E8A4,x
	JML $00EBAB
.newHitbox
	LDA $90
	CLC : ADC.l IPointY+6,x
	JML $00EBAB