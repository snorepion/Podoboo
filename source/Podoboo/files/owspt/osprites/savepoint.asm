;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; save point from final fantasy VI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Only after this event number is activated, this sprite is available. If FF, available form the first.
			!EventNumber = $FF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Main:
			JSR EventCheck
			TYA
			BEQ Return01
			JSR Graphic
			JSR ChangePlayerCheck
			JSR NearMarioCheck
Return01:
			RTS
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; graphic routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Tile:			db $A0,$A2,$A4,$A6

Graphic:
			JSR SetDrawPosition
			LDA $01
			ORA $03
			BNE Return03
			JSR GetFrameNumber
			LSR A
			LSR A
			AND #$03
			TAY
			LDA Tile,y
			PHA
			JSR SetOAMIndex
			PLA
			STA $0302,y
			LDA #$30
			STA $0303,y
			LDA $00
			STA $0300,y
			LDA $02
			STA $0301,y
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
			LDA $0EE5,x
			BEQ Return02
			LDA $0EC5,x
			BNE Color
			LDA $13D9
			CMP #$03
			BNE Return02
			STZ $2121
			STZ $2122
			LDA #$78
			STA $2122
			STA $0EC5,x
			LDA #$01
			STA $1DFC
			LDA #$01
			STA $13D9
Return02:
			RTS
Color:
			LDA #$01
			STA $13D9
			LDA $0EC5,x
			SEC
			SBC #$08
			STA $0EC5,x
			STZ $2121
			STZ $2122
			LDA $0EC5,x
			STA $2122
			LDA $0EC5,x
			BNE Return02
			STZ $0EE5,x
			JSR CopySRAM
			JSR DoSave
			LDX $0DDE
			RTS
Far:
			SEP #$20
			LDA #$01
			STA $0EE5,x
			RTS
			
ChangePlayerCheck:
			LDA $0DD6
			INC A
			CMP $0ED5,x
			BEQ Return12
			STA $0ED5,x
			STZ $0EE5,x
Return12:
			RTS

;$048F7F
CopySRAM:
			LDX #$2C
Loop1:
			LDA $1F02,x		;event data, sub map, position, switch block flags, beat number, and so on
			STA $1FA9,x
			DEX
			BPL Loop1
			REP #$30
			LDX $0DD6
			TXA
			EOR #$0004
			TAY
			LDA $1FBE,x
			STA $1FBE,y
			LDA $1FC0,x
			STA $1FC0,y
			LDA $1FC6,x
			STA $1FC6,y
			LDA $1FC8,x
			STA $1FC8,y
			TXA
			LSR A
			TAX
			EOR #$0002
			TAY
			LDA $1FBA,x
			STA $1FBA,y
			TXA
			SEP #$30
			LSR A
			TAX
			EOR #$01
			TAY
			LDA $1FB8,x
			STA $1FB8,y
			RTS

;$049037
DoSave:
			LDX #$5F
Loop2:
			LDA $1EA2,x			;level data
			STA $1F49,x
			DEX
			BPL Loop2
			STZ $13CA			;save flag
			LDA #$05
			STA $1B87
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
;; Check Event Flag
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;$04E44B
Threshold:		db $80,$40,$20,$10,$08,$04,$02,$01

EventCheck:
			PHX
			LDA #!EventNumber
			CMP #$FF
			BEQ PassCheck
			AND #$07
			TAX
			LDA #!EventNumber
			LSR A
			LSR A
			LSR A
			TAY
			LDA $1F02,y
			AND Threshold,x
PassCheck:
			TAY
			PLX
			RTS

