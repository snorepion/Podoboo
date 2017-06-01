;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; smb3 hand
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org $04FAF1
;; main sprite routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Main:
			LDA $0EC5,x
			BNE NotCheck
			INC $0EC5,x
			JSR LevelClearCheck
			TYA
			BEQ Return00
NotCheck:
			JSR ChangePlayerCheck
			JSR NearMarioCheck
			JSR Graphic
Return00:
			RTS
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Graphic
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Horz1:		db $F8,$00,$08,$10
Tilemap1:	db $63,$45,$45,$63
Properties:	db $34,$34,$74,$74
Horz2:		db $00,$08,$00,$08
Vert2:		db $08,$08,$10,$10
Tilemap2:	db $80,$81,$90,$91

Return01:
			RTS
Graphic:
			LDA $0E05,x
			BEQ Return01
			CMP #$40
			BCS Return01
			JSR SetDrawPosition
			LDA $01
			ORA $03
			BNE Return01		;If off screen, don't draw
			LDY #$34			;OAM index is fixed value, 34
			LDX #$03
Loop01:
			LDA Horz1,x
			CLC
			ADC $00
			STA $0240,y			;drawing x position
			LDA #$08
			CLC
			ADC $02
			STA $0241,y			;drawing x position
			LDA Tilemap1,x		;Graphic tile
			STA $0242,y
			LDA Properties,x
			STA $0243,y			;Tile format
			PHY
			TYA
			LSR A
			LSR A
			TAY
			LDA #$00
			STA $0430,y			;00:8x8 size 02:16x16 size
			PLY
			INY
			INY
			INY
			INY
			DEX
			BPL Loop01
			LDX $0DDE
			LDA $0E55,x
			STA $01
			LDA $0E05,x
			LDX #$01
			CMP #$31
			BCS Loop02
			CMP #$13
			BCC Loop02
			LDX #$03
Loop02:
			LDA Horz2,x
			CLC
			ADC $00
			STA $0240,y			;drawing x position
			LDA Vert2,x
			CLC
			ADC $02
			SEC
			SBC $01
			STA $0241,y			;drawing x position
			LDA Tilemap2,x		;Graphic tile
			STA $0242,y
			LDA #$34
			STA $0243,y			;Tile format
			PHY
			TYA
			LSR A
			LSR A
			TAY
			LDA #$00
			STA $0430,y			;00:8x8 size 02:16x16 size
			PLY
			INY
			INY
			INY
			INY
			DEX
			BPL Loop02
			LDX $0DDE
			RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org $04FE62
;; Set drawing position to $00-$03
;;
;; $0E35,x   sprite x position low byte
;; $0E45,x   sprite y position low byte
;; $0E65,x   sprite x position high byte
;; $0E75,x   sprite y position high byte
;; $00-$01   sprite x position relative to screen boarder
;; $02-$03   sprite y position relative to screen boarder
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SetDrawPosition:
			TXA
			CLC
			ADC #$10
			TAX					;x = index + 10
			LDY #$02
			JSR SetDrawingPosition
			LDX $0DDE			;x = sprite index
			;LDA $02
			;SEC
			;SBC $0E55,x			;height from ground
			;STA $02
			;BCS NotCarryDown01
			;DEC $03
NotCarryDown01:
			LDY #$00

SetDrawingPosition:
			LDA $0E65,x			;sprite position high byte
			XBA
			LDA $0E35,x			;sprite position low byte
			REP #$20
			SEC
			SBC $001A,y			;Screen Boundry
			STA $0000,y			;sprite position relative to screen boarder
			SEP #$20
			RTS
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; If sprite is near mario/luigi, enter level at the probability of 50%.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NearMarioCheck:
			JSR GetBetweenLength
			LDA $06
			CMP #$0008
			BCS NotNear
			LDA $08
			CMP #$0008
			BCS NotNear
			SEP #$20
			LDA $0DD6
			LSR A
			LSR A
			TAY
			LDA $0DB4,y
			BMI NotNear			;if death
			;STX $0EF7			;delete this index number sprite when a level beaten
			LDA $13D9			;pad input mode
			CMP #$04
			BEQ NotNear			;when mario is moving, skip
			LDA $0E05,x			;timer
			BEQ TimerZero
			CMP #$80
			BCS Return02
			JMP TimerCount
NotNear:
			SEP #$20
			STZ $0E05,x
			STZ $0E55,x
			RTS
TimerZero:
			LDA $13
			STA $148B
			LDA $14
			STA $148C
			JSL $01ACF9			;get random value
			AND #$01
			BNE NotHappen
			LDA #$50
			STA $0E05,x			;timer
			LDA #$01
			STA $13D9			;pad input mode
Return02:
			RTS

NotHappen:	LDA #$80
			STA $0E05,x
			RTS

TimerCount:
			LDA #$01
			STA $13D9			;pad input mode
			LDA $0E05,x
			DEC A
			STA $0E05,x
			CMP #$40
			BCS FlashEffect
			BIT #$01
			BNE Return03
			CMP #$40
			BCS Return03
			CMP #$22
			BCS MoveUp
			CMP #$04
			BCS MoveDown
			CMP #$02
			BEQ EnterLevel
Return03:
			RTS
MoveUp:
			INC $0E55,x
			RTS
MoveDown:
			DEC $0E55,x
			LDA #$01
			STA $7FFF80
			RTS
FlashEffect:
			BIT #$01
			BEQ Return03
			BIT #$02
			BEQ FlashDelete
Flash:
			STZ $2121			;Palete
			LDA #$18
			STA $2122			;SNES Color
			LDA #$63
			STA $2122			;SNES Color
			RTS
FlashDelete:
			STZ $2121			;Palete
			STZ $2122			;SNES Color
			STZ $2122			;SNES Color
			RTS
			
EnterLevel:
			STZ $0EC5,x
			STZ $0E05,x
			STZ $0E55,x
			LDA #$03
			STA $13D9			;pad input mode
			STZ $0DD8
			STZ $1B9E
			PHX
			;LDA $0DD6
			;LSR A
			;AND #$02
			;TAX
			;LDY #$02
			;LDA $1F13,x		;mario/luigi pose
			;AND #$08
			;BEQ NotSwiming
			;LDY #$0A
NotSwiming:
			;TYA
			;STA $1F13,x		;mario/luigi pose
			LDX $0DB3			;current character
			LDA $0DB6,x			;character's coin
			STA $0DBF			;coin in level
			LDA $0DB4,x			;character's lives
			STA $0DBE			;lives in level
			LDA $0DB8,x			;character's power
			STA $19				;status
			LDA $0DBA,x			;character's Yoshi color
			STA $0DC1			;ow yoshi
			STA $13C7			;yoshi color in level
			STA $187A			;on yoshi in level
			LDA $0DBC,x			;character's item
			STA $0DC2			;item in level
			LDA #$02
			STA $0DB1			;fade speed
			LDA #$80
			STA $1DFB			;music fade out
			INC $0100			;fade to level
			PLX
			RTS
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org $04FEEF
;; Set x length between mario/luigi and sprite to $06-$07. This is absolute value.
;; Set y length between mario/luigi and sprite to $08-$09. This is absolute value.
;; $06-$07 x distance between mario/luigi and sprite
;; $08-$09 y distance between mario/luigi and sprite
;;
;; Notice! 16bit Accumulator mode after this routine.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GetBetweenLength:
			LDA $0E65,x			;sprite x position high byte
			XBA
			LDA $0E35,x			;sprite x position low byte
			REP #$20
			CLC
			ADC #$0008
			LDY $0DD6			;Mario: 00  Luigi: 04
			SEC
			SBC $1F17,y			;Mario/Luigi x position
			STA $00
			BPL NotMinusValue01
			EOR #$FFFF		;if distance is minus, do bit reverse
			INC A
NotMinusValue01:
			STA $06				;x distance between mario/luigi and sprite
			SEP #$20
			LDA $0E75,x			;sprite y position high byte
			XBA
			LDA $0E45,x			;sprite y position low byte
			REP #$20
			CLC
			ADC #$0008
			LDY $0DD6			;Mario: 00  Luigi: 02
			SEC
			SBC $1F19,y			;Mario/Luigi x position
			STA $02
			BPL NotMinusValue02
			EOR #$FFFF		;if distance is minus, do bit reverse
			INC A
NotMinusValue02:
			STA $08				;y distance between mario/luigi and sprite
			RTS
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; level clear or not
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LevelClearCheck:
			JSR OW_TilePos_calc
			REP #$30
			LDX $04			;position data
			LDA $7ED000,x			;level number
			AND #$00FF
			SEP #$30
			TAX
			LDA $1EA2,x
			AND #$80
			BEQ NotClear
			LDX $0DDE
			STZ $0DE5,x		;delete sprite
NotClear:
			LDX $0DDE
			RTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; a few change from org $049885
;; Position data to $04-$05
;; x pos bit4-7 + y pos bit4-7 * 0x10 + x pos bit8 * 0x100 + y pos bit8 * 0x200 + submap flag * 0x400
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
OW_TilePos_calc:
			LDA $0E65,x			;sprite x position high byte
			XBA
			LDA $0E35,x			;sprite x position low byte
			REP #$20
			CLC
			ADC #$0008
			LSR A
			LSR A
			LSR A
			LSR A
			STA $00			;x position / 0x10
			SEP #$20
			LDA $0E75,x			;sprite y position high byte
			XBA
			LDA $0E45,x			;sprite y position low byte
			REP #$20
			CLC
			ADC #$0008
			LSR A
			LSR A
			LSR A
			LSR A
			STA $02			;y position / 0x10
			LDX $0DD6		;0 mario 4 luigi
			TXA
			LSR A
			LSR A
			TAX				;0 mario 1 luigi
			LDA $00			;player x position / 0x10
			AND #$000F
			STA $04			;player x position bit 4-7
			LDA $00
			AND #$0010	;player x pos bit 8 = player x pos high byte
			ASL A
			ASL A
			ASL A
			ASL A
			ADC $04
			STA $04			;x position bit8 * 0x100 + bit4-7
			LDA $02
			ASL A
			ASL A
			ASL A
			ASL A
			AND #$00FF
			ADC $04
			STA $04		;x pos bit4-7 + y pos bit4-7 * 0x10 + x pos bit8 * 0x100
			LDA $02
			AND #$0010	;player y pos bit 8 = player y pos high byte
			BEQ NorthWorld
			LDA $04
			CLC
			ADC #$0200
			STA $04		;x pos bit4-7 + y pos bit4-7 * 0x10 + x pos bit8 * 0x100 + y pos bit8 * 0x200
NorthWorld:
			LDA $1F11,x	;submap (0=Overworld, 1=Yoshi, 2=Vanilla, 3=Forest, 4=Bowser, 5=Special, 6=Star)
			AND #$00FF
			BEQ Return11
			LDA $04
			CLC
			ADC #$0400
			STA $04
Return11:
			RTS
			
ChangePlayerCheck:
			LDA $0DD6
			INC A
			CMP $0ED5,x
			BEQ Return12
			STA $0ED5,x
			LDA #$80
			STA $0EE5,x
Return12:
			RTS
