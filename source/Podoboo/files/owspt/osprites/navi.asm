;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DKC2 navigate arrow
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org $04FAF1
;; main sprite routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Main:
			LDY $0DD6			;mario or luigi
			LDA $1F17,y
			STA $0E35,x
			LDA $1F18,y
			STA $0E65,x
			LDA $1F19,y
			STA $0E45,x
			LDA $1F1A,y
			STA $0E75,x			;same positon of mario
			LDA $13D9
			CMP #$03
			BNE Return02		;if mario does not stop
			JSR GetFrameNumber
			AND #$08			;draw graohic per 8 frame
			BEQ Return02
			JSR CanMoveCheck
			JSR SetDrawPosition
			LDA $01
			ORA $03
			BNE Return02		;if sprite is offscreen
			LDA $7FFF80
			BNE Return02
			JSR Graphic
Return02:
			RTS
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Graphic
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Horz:	db $0A,$EE,$FC,$FC
Vert:	db $F6,$F6,$04,$E8
Tile:	db $92,$92,$82,$82
Prop:	db $34,$74,$34,$B4

Graphic:
			LDA #$08
			STA $07
			JSR SetOAMIndex
			PHX
			LDX #$03
Loop1:
			LDA $06				;can move flag
			AND $07
			BEQ NotDraw
			LDA Horz,x
			CLC
			ADC $00
			STA $0300,y			;drawing x position
			LDA Vert,x
			CLC
			ADC $02
			STA $0301,y			;drawing y position
			LDA Tile,x
			STA $0302,y			;Graphic tile
			LDA Prop,x
			STA $0303,y			;Tile format
			TYA
			LSR A
			LSR A
			PHY
			TAY
			LDA #$00
			STA $0460,y			;00:8x8 size 02:16x16 size
								;if Carry flag set -> 16x16 size, not set -> 8x8 size
			PLY
			INY
			INY
			INY
			INY
NotDraw:
			LSR $07
			DEX
			BPL Loop1
			PLX
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
;; Path Check
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CanMoveCheck:
			PHX
			JSR GetLevelSetting
			LDA $0DD6
			LSR A
			LSR A
			TAX
			STZ $07		;path check flag
			REP #$20
			LDA $04
			STA $08		;current position
			SEP #$20
			LDA $06
			AND #$01
			BEQ NotRightCheck
			REP #$20
			INC $00
			JSR OW_TilePos_calc
			DEC $00
			JSR TileCheck
			BCS NotRightCheck
			LDA $07
			ORA #$01
			STA $07
NotRightCheck:
			LDA $06
			AND #$02
			BEQ NotLeftCheck
			REP #$20
			DEC $00
			JSR OW_TilePos_calc
			INC $00
			JSR TileCheck
			BCS NotLeftCheck
			LDA $07
			ORA #$02
			STA $07
NotLeftCheck:
			LDA $06
			AND #$04
			BEQ NotDownCheck
			REP #$20
			INC $02
			JSR OW_TilePos_calc
			DEC $02
			JSR TileCheck
			BCS NotDownCheck
			LDA $07
			ORA #$04
			STA $07
NotDownCheck:
			LDA $06
			AND #$08
			BEQ NotUpCheck
			REP #$20
			DEC $02
			JSR OW_TilePos_calc
			INC $02
			JSR TileCheck
			BCS NotUpCheck
			LDA $07
			ORA #$08
			STA $07
NotUpCheck:
			JSR InvisiblePathCheck
			LDA $06
			AND $07
			STA $06
			PLX
			RTS
TileCheck:	
			LDA $04
			CMP #$0800
			BCS Return03
			REP #$30
			PHX
			LDX $04
			LDA $7EC800,x		;next tile map
			PLX
			AND #$00FF
			BEQ Return03
			CMP #$0087
			BCS Return03
			SEP #$30
			CLC
			RTS
Return03:
			SEP #$30
			SEC
			RTS
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; InvisiblePathCheck
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DirSetting:		db $04,$02,$02,$01,$01,$02,$04,$01,$01,$02

InvisiblePathCheck:
			REP #$30
			LDX $08				;current position
			LDA $7ED000,x		;level num
			AND #$00FF
			SEP #$30
			STA $08
			LDX #$09
Loop2:
			LDA $049078,x
			CMP #$FF
			BEQ SpecialLevel
			CMP $08
			BEQ WrittenLevel
			PHX
NotSpecialLevel:
			PLX
			SEP #$20
			DEX
			BPL Loop2
			RTS
SpecialLevel:
			REP #$20
			PHX
			LDA $0DB3
			AND #$00FF
			TAX
			LDA $1F11,x
			AND #$00FF
			BNE NotSpecialLevel
			LDX $0DD6
			LDA $1F19,x
			CMP $049082
			BNE NotSpecialLevel
			LDA $1F17,x
			CMP $049084
			BNE NotSpecialLevel
			PLX
			SEP #$20
WrittenLevel:
			LDA DirSetting,x
			ORA $07
			STA $07
			RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; a few change from org $0491E9
;; Get Level Setting to $06
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GetLevelSetting:
			REP #$20
			LDX $0DD6		;0 mario 4 luigi
			LDA $1F1F,x
			STA $00			;player x position / 0x10
			LDA $1F21,x
			STA $02			;player y position / 0x10
			TXA
			LSR A
			LSR A
			TAX				;0 mario 1 luigi
			JSR OW_TilePos_calc
			REP #$30
			LDX $04			;position data
			LDA $7ED000,x	;level number of current tile
			AND #$00FF
			SEP #$30
			TAX
			LDA $1EA2,x
			STA $06
			RTS
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org $049885
;; Position data to $04-$05
;; x pos bit4-7 + y pos bit4-7 * 0x10 + x pos bit8 * 0x100 + y pos bit8 * 0x200 + submap flag * 0x400
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
OW_TilePos_calc:
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
