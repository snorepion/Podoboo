;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SMB3 whistle tornado
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;number of "exit index to use" of pipe/star setting.
;If you want to warp mario to A point, one of pipe/star setting must be from B to A.
;This is not index number of A, but of B.
			!WarpIndex = $01
			
;Only after this event number is activated, this sprite is available. If FF, available form the first.
			!EventNumber = $FF
			
;Sound number when use whistle
			!Sound = $1C

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; main sprite routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Main:
			JSR EventCheck
			TYA
			BEQ Return04
			LDA $0EE5,x
			BEQ BefereWarp
			JSR AfterWarp
			RTS
BefereWarp:
			LDA $0EB5,x
			BNE WarpMode
			LDY $0DD6
			LDA $1F19,y
			SEC
			SBC #$0C
			STA $0E45,x
			LDA $1F1A,y
			SBC #$00
			STA $0E75,x			;same positon of mario
			JSR LBottunCheck
			RTS
WarpMode:
			DEC A
			STA $0EB5,x
			LDA #$01
			STA $13D9
			JSR Graphic
			LDA $0EB5,x
			CMP #$E1
			BCS Flash
			CMP #$60
			BCC Warp
			LDY $0DD6
			REP #$20
			LDA $1F17,y
			AND #$FFFE
			STA $04
			SEP #$20
			LDA $0E35,x
			SEC
			SBC #$02
			STA $0E35,x
			STA $02
			LDA $0E65,x
			SBC #$00
			STA $0E65,x
			STA $03
			REP #$20
			LDA $02
			CLC
			ADC #$0008
			AND #$FFFE
			CMP $04
			SEP #$20
			BNE Return04
			LDA #$01
			STA $7FFF80
Return04:
			RTS
Warp:
			CMP #$5F
			BEQ DoWarp
			RTS
DoWarp:
			STZ $1B9E				;push XYAB
			STZ $0EB5,x
			LDA #$FF
			STA $0EE5,x
			LDA #!WarpIndex
			ASL A
			STA $1DF6				;warp address index
			INC $1B9C
			LDA #$0B
			STA $0100				;warp mode
			RTS
			
Flash:
			AND #$07
			BEQ White
			CMP #$04
			BNE Return03
			STZ $2121
			STZ $2122
			STZ $2122
Return03:
			RTS
White:
			STZ $2121			;Palete
			LDA #$18
			STA $2122			;SNES Color
			LDA #$63
			STA $2122			;SNES Color
			RTS
			
AfterWarp:
			LDA #$01
			STA $13D9
			LDA $0EE5,x
			CMP #$FF
			BCC AfterWarp2
			LDY $0DD6
			LDA $1F19,y
			SEC
			SBC #$0C
			STA $0E45,x
			LDA $1F1A,y
			SBC #$00
			STA $0E75,x			;same positon of mario
			JSR SetDrawPosition
			LDA $0E35,x
			STA $03
			LDA $0E65,x
			STA $04
			REP #$20
			LDA #$0100
			SEC
			SBC $00
			CLC
			ADC $03
			STA $03
			SEP #$20
			LDA $03
			STA $0E35,x
			LDA $04
			STA $0E65,x
			DEC $0EE5,x
			RTS
AfterWarp2:
			DEC $0EE5,x
			JSR Graphic
			LDA $0EE5,x
			CMP #$80
			BCC Finish
			LDY $0DD6
			REP #$20
			LDA $1F17,y
			AND #$FFFE
			STA $04
			SEP #$20
			LDA $0E35,x
			SEC
			SBC #$02
			STA $0E35,x
			STA $02
			LDA $0E65,x
			SBC #$00
			STA $0E65,x
			STA $03
			REP #$20
			LDA $02
			CLC
			ADC #$0008
			AND #$FFFE
			CMP $04
			SEP #$20
			BNE Return05
			LDA #$00
			STA $7FFF80
Return05:
			RTS
Finish:
			STZ $0EE5,x
			STZ $13D9
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bottun Check
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LBottunCheck:
			LDA $13D4		;if OW view mode
			BNE Return01
			LDA $13D9
			CMP #$03		;if mario does not stand on a tile
			BNE Return01
			LDA $18
			CMP #$20
			BNE Return01
			LDA $17
			CMP #$20
			BNE Return01
			LDA $15
			BNE Return01
			LDA #!Sound
			STA $1DFC
			LDA #$01
			STA $13D9
			LDA #$FF
			STA $0EB5,x
			JSR SetDrawPosition
			LDA $0E35,x
			STA $03
			LDA $0E65,x
			STA $04
			REP #$20
			LDA #$0100
			SEC
			SBC $00
			CLC
			ADC $03
			STA $03
			SEP #$20
			LDA $03
			STA $0E35,x
			LDA $04
			STA $0E65,x
Return01:
			RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Graphic
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Graphic:
			JSR SetDrawPosition
			LDA $01
			ORA $03
			BNE Return02
			LDY #$84
			JSR GetFrameNumber
			AND #$08
			BNE Graphic2
			LDY #$86
Graphic2:
			TYA
			LDY #$34			;OAM index is fixed value, 34
			STA $0242,y			;Graphic tile
			LDA #$34
			STA $0243,y			;Tile format
			LDA $00
			STA $0240,y
			LDA $02
			STA $0241,y
			TYA
			LSR A
			LSR A
			TAY
			LDA #$02
			STA $0430,y			;00:8x8 size 02:16x16 size
Return02:
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
