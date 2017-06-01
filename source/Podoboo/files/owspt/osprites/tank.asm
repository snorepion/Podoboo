;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; smb3 tank
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;00: When Mario misses, force Mario to play same course again.
;01: Go away Mario to the direction set as "Direction to enable when secret exit is used" in tile setting.
			!GoBackFlag = $01


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Main:	
			LDA $0EC5,x
			BNE NotCheck
			INC $0EC5,x
			JSR LevelClearCheck
			TYA
			BEQ Return00
NotCheck:
			JSR Graphic
			JSR NearMarioCheck
Return00:
			RTS
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; graphic routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Graphic:	
			JSR SetDrawPosition
			LDA $01
			ORA $03
			BNE Return03
			JSR SetOAMIndex
			LDA $00
			STA $0300,y
			JSR GetFrameNumber
			LSR A
			LSR A
			LSR A
			AND #$01
			CLC
			ADC $02
			STA $0301,y
			LDA #$A8
			STA $0302,y
			LDA #$30
			STA $0303,y
			TYA
			LSR A
			LSR A
			TAY
			LDA #$02
			STA $0460,y
Return03:
			RTS
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Search free OAM slot
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SetOAMIndex:
			LDY #$DC
OAMLoop:
			LDA $02FD,y
			CMP #$F0
			BNE GetOAM
			CPY #$40
			BEQ GetOAM
			DEY
			DEY
			DEY
			DEY
			BRA OAMLoop
GetOAM:
			RTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; change from org $04FED7
;; If sprite is near mario/luigi, set sprite index to $0EF7
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NearMarioCheck:
			JSR GetBetweenLength
			LDA $06
			CMP #$0008
			BCS Far
			LDA $08
			CMP #$0008
			BCS Far
			SEP #$20
			LDA $0DD6
			LSR A
			LSR A
			TAY
			LDA $0DB4,y
			BMI Far			;if death
			LDA $0EE5,x
			BNE GoBack
			LDA $13D9
			CMP #$03
			BNE Return02
			LDA #!GoBackFlag
			BEQ NotGoBack
			INC $0EE5,x
NotGoBack:
			JSR EnterLevel
			;STX $0EF7			;delete this index number sprite when a level beaten
			STZ $0EC5,x
Return02:
			RTS
Far:
			SEP #$20
			STZ $0EE5,x
			RTS
GoBack:
			LDA #$02
			STA $0DD5
			RTS

EnterLevel:
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
;; org $04FE5B
;; Set Accumulator frame number plus rondom digit decided by sprite index
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;$04F833
RondomTable:		db $00,$52,$31,$19,$45,$2A,$03,$8B,$94,$3C,$78,$0D,$36,$5E,$87,$1F

GetFrameNumber:
			LDA $13
			CLC
			ADC RondomTable,x
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
			BEQ Return01
			LDA $04
			CLC
			ADC #$0400
			STA $04
Return01:
			RTS
