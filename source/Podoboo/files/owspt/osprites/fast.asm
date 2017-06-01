;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mario OW speed up
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Mario speed without Yoshi 00:normal speed 01:double speed 02:triple speed 03:fourfold speed ... FF:256fold
			!MarioSpeed = $01

;Mario speed riding Yoshi
			!YoshiSpeed = $03

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Main:
			LDA $0DD6			;mario or luigi
			LSR A
			LSR A
			TAX
			LDY #!MarioSpeed
			LDA $0DBA,x			;yoshi color
			BEQ NoYoshi
			LDY #!YoshiSpeed
NoYoshi:
			CPY #$00
			BEQ Finish
			PHY
			JSR SubCode
			PLY
			DEY
			BRA NoYoshi
Finish:
			LDX $0DDE
			RTS



SubCode:
			LDA $13D9			;mario mode
			CMP #$04
			BNE NotMove
			LDA $13D4			;watch OW mode
			BNE NotMove
			LDA $1BA0			;shake ground
			BNE NotMove
			JSR SetSpeed
NotMove:
			RTS
			
			

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;$04945D speed set
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;$04941E
DirectionTable:	db $08,$00,$04,$00,$02,$00,$01,$00
;$049416
LeftUpEdge:		db $EF,$FF,$D7,$FF
;$04941A
RightDownEdge:	db $11,$01,$31,$01
;$049058
NextTable:		db $FF,$FF,$01,$00,$FF,$FF,$01,$00

SetSpeed:	
			LDA $0DD8
			BEQ NotChangeScene
			LDA #$08
			STA $13D9
			RTS
NotChangeScene:
			REP #$30
			LDA $0DD6
			CLC
			ADC #$0002
			TAY
			LDX #$0002
Loop1:
			LDA $0DC7,y				;last position
			SEC
			SBC $1F17,y				;current position
			STA $00,x
			BPL Plus1
			EOR #$FFFF			;reverse bit
			INC A
Plus1:
			STA $04,x
			DEY
			DEY
			DEX
			DEX
			BPL Loop1
			LDY #$FFFF
			LDA $04
			STA $0A
			LDA $06
			STA $0C
			CMP $04
			BCC Lbl0494A4
			STA $0A
			LDA $04
			STA $0C
			LDY #$0001
Lbl0494A4:
			STY $08
			SEP #$20
			LDX $1B80
			LDA $049414,x
			ASL A
			ASL A
			ASL A
			ASL A
			STA $4202
			LDA $0C
			BEQ NotCaulc
			STA $4203
			NOP
			NOP
			NOP
			NOP
			REP #$20
			LDA $4216
			STA $4204
			SEP #$20
			LDA $0A
			STA $4206
			NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			REP #$20
			LDA $4214
NotCaulc:
			REP #$20
			STA $0E
			LDX $1B80
			LDA $049414,x
			AND #$00FF
			ASL A
			ASL A
			ASL A
			ASL A
			STA $0A
			LDX #$0002
Loop3:
			LDA $08
			BMI Minus
			LDA $0A
			BRA NotMinus
Minus:
			LDA $0E
NotMinus:
			BIT $00,x
			BPL Plus3
			EOR #$FFFF
			INC A
Plus3:
			STA $0DCF,x
			LDA $08
			EOR #$FFFF
			INC A
			STA $08
			DEX
			DEX
			BPL Loop3
			LDX #$0000
			LDA $08
			BMI Minus2
			LDX #$0002
Minus2:
			LDA $00,x
			BEQ CheckTile
			JMP MoveMario
CheckTile:
			LDA $1444
			BEQ NotStop
			STZ $1B78
			LDX $0DD6
			LDA $1F1F,x
			STA $00			;x/10
			LDA $1F21,x
			STA $02			;y/10
			TXA
			LSR A
			LSR A
			TAX
			JSR OW_TilePos_Calc
			STZ $00
			LDX $04			;position data
			LDA $7ED000,x	;level number
			AND #$00FF
			JSL $03BB20		;get level name custom routine inserted by Lunar Magic
			INC $13D9
			JSR DoSave
			JMP MarioStop
NotStop:
			LDA $13C1
			STA $1B7E
			LDA #$0008
			STA $08
			LDY $0DD3
			TYA
			AND #$00FF
			EOR #$0002
			STA $0A
			BRA Lbl049582
			
Loop5:
			LDA $08
			SEC
			SBC #$0002
			STA $08
			CMP $0A
			BEQ Loop5
			TAY
Lbl049582:
			LDX $0DD6
			LDA $1F1F,x
			STA $00
			LDA $1F21,x
			STA $02
			LDX #$0000
			CPY #$0004
			BCS X_pos
			LDX #$0002
X_pos:
			LDA $00,x
			CLC
			ADC NextTable,y
			STA $00,x
			LDA $0DD6
			LSR A
			LSR A
			TAX
			JSR OW_TilePos_Calc
			LDA $1B78
			BEQ NotCheck
			STY $06
			LDX $1B7A
			INX
			LDA $0490CA,x
			AND #$00FF
			CMP $06
			BNE Loop5
			STX $1B7A
			LDA $049086,x
			AND #$00FF
			CMP #$0058
			BNE NotFort
NotCheck:
			LDX $04
			BMI Loop5			;outside of map
			CMP #$0800
			BCS Loop5			;outside of map
			LDA $7EC800,x		;tile number
			AND #$00FF
NotFort:
			STA $13C1
			BEQ Loop5			;no tile
			CMP #$0087
			BCS Loop5			;no tile
			PHA
			PHY
			TAX
			DEX
			LDY #$0000
			LDA $049FEB,x
			STA $0E
			AND #$00FF
			CMP #$0014
			BNE Lbl0495FF
			LDY #$0001
Lbl0495FF:
			STY $1B80
			LDX $0DD6
			LDA $00
			STA $1F1F,x
			LDA $02
			STA $1F21,x
			PLY
			PLA				;A tile number
			PHA
			SEP #$30
			LDX #$09
Loop6:
			CMP $049426,x
			BNE NotWarp
			PHY				;if tile is Warp tile
			JSR DoWarp
			PLY
			LDA #$01
			STA $1B9E
			JSR ClearRAM
			STZ $1B8C
			REP #$20
			STZ $0701
			LDA #$7000
			STA $1B8D
			LDA #$5400
			STA $1B8F
			SEP #$20
			LDA #$0A
			STA $13D9			;warp mode
			BRA OutLoop
NotWarp:
			DEX
			BPL Loop6
OutLoop:
			REP #$30
			PLA					;tile number
			PHA
			CMP #$0056
			BCS NotLoadTile
			JMP LoadTile
NotLoadTile:
			CMP #$0080
			BEQ WaterTile
			CMP #$006A
			BCC GroundTile
			CMP #$006E
			BCS GroundTile
WaterTile:
			LDA $0DD6			;mario or luigi
			LSR A
			AND #$0002
			TAX
			LDA $1F13,x			;mario graphic
			ORA #$0008
			STA $1F13,x			;set in water graphic
			BRA PrepareStop
GroundTile:
			LDA $0DD6
			LSR A
			AND #$0002
			TAX
			LDA $1F13,x			;mario graphic
			AND #$00F7
			STA $1F13,x			;set on ground graphic
PrepareStop:
			LDA #$0001
			STA $1444			;stop mario flag
			LDA $13C1			;tile number
			CMP #$005F		;Warp star
			BEQ NoSound
			CMP #$005B		;pipe1
			BEQ NoSound
			CMP #$0082		;pipe2
			BEQ NoSound
			LDA #$0023
			STA $1DFC
NoSound:
			NOP
			NOP
			NOP
			LDA $13C1
			AND #$00FF
			CMP #$0082
			BEQ OnPipe2
			PHY
			TYA
			AND #$00FF
			EOR #$0002
			TAY					;mario direction
			STZ $06
			LDX $04
			LDA $7ED000,x		;level number
			AND #$00FF
			TAX
			LDA DirectionTable,y
			ORA $1EA2,x			;level data
			STA $1EA2,x			;add can move direction
			PLY
OnPipe2:
			LDA $0DD6			;mario or luigi
			LSR A
			AND #$0002
			TAX
			LDA $1F13,x			;mario graphic
			AND #$000C
			STA $0E
			LDA #$0001
			STA $04
			LDA $1B7E
			AND #$00FF
			STA $00
			LDX #$0017
Loop7:
			LDA $04A03C,x
			AND #$00FF
			CMP $00
			BNE DoLoop7
			TXA
			ASL A
			TAX
			LDA $04A054,x
			BRA OutLoop7
DoLoop7:
			DEX
			BPL Loop7
			LDA #$0000
			ORA #$0800
			CPY #$0004
			BCC OutLoop7
			LDA #$0000
			ORA #$0008
OutLoop7:
			LDX #$0000
			BRA Lbl049728
			
LoadTile:
			DEC A
			ASL A
			TAX
			LDA $049F49,x
			STA $04
			LDA $049EA7,x
Lbl049728:
			STA $00
			TXA
			SEP #$20
			LDX #$001C
Loop8:
			CMP $049430,x
			BEQ OutLoop8
			DEX
			DEX
			BPL Loop8
			BRA Lbl04974A
OutLoop8:
			TYA
			CMP $049431,x
			BEQ Lbl04974A
			TXA
			LSR A
			TAX
			LDA $04944E,x
			TAX
			BRA Lbl049755
Lbl04974A:
			LDX #$0000
			TYA
			AND #$02
			BEQ Lbl049755
			LDX #$0001
Lbl049755:
			LDA $04,x
			BEQ NotReverse
			LDA $00
			EOR #$FF
			INC A
			STA $00				;reverse bit
			LDA $01
			EOR #$FF
			INC A
			STA $01				;reverse bit
NotReverse:
			REP #$20
			PLA
			LDX #$0000
			LDA $0E				;mario graphic
			AND #$0007
			BNE Lbl049777
			LDX #$0001
Lbl049777:
			LDA $0E				;mario graphic
			AND #$00FF
			STA $04
			LDA $00,x
			AND #$00FF
			CMP #$0080
			BCS Lbl049790
			LDA $04
			CLC
			ADC #$0002
			STA $04
Lbl049790:
			LDA $0DD6			;mario or luigi
			LSR A
			AND #$0002
			TAX
			LDA $04
			STA $1F13,x			;mario graphic
			LDX $0DD6			;mario or luigi
			LDA $00
			AND #$00FF
			CMP #$0080
			BCC Lbl0497AD
			ORA #$FF00
Lbl0497AD:
			CLC
			ADC $1F17,x			;x position
			AND #$FFFC
			STA $0DC7,x			;x goal
			LDA $01
			AND #$00FF
			CMP #$0080
			BCC Lbl0497C4
			ORA #$FF00
Lbl0497C4:
			CLC
			ADC $1F19,x			;y position
			AND #$FFFC
			STA $0DC9,x			;y goal
			SEP #$20
			LDA $0DC7,x
			AND #$0F
			BNE Lbl0497E3
			LDY #$0004		;left
			LDA $00
			BMI Lbl0497E1
			LDY #$0006		;right
Lbl0497E1:
			BRA SetDirection
Lbl0497E3:
			LDA $0DC9,x
			AND #$0F
			BNE SetDirection
			LDY #$0000		;up
			LDA $01
			BMI SetDirection
			LDY #$0002		;down
SetDirection:
			STY $0DD3			;mario direction
			LDA $13D9			;mario mode
			CMP #$0A			;warp mode
			BEQ MarioStop
			JMP SetSpeed
			
MoveMario:
			REP #$20
			LDA $0DD6
			CLC
			ADC #$0002
			TAX
			LDY #$0002
Loop2:
			LDA $13D5,y			;move amount
			AND #$00FF
			CLC
			ADC $0DCF,y			;speed
			STA $13D5,y
			AND #$FF00
			BPL Plus2
			ORA #$00FF
Plus2:
			XBA
			CLC
			ADC $1F17,x			;position
			STA $1F17,x
			DEX
			DEX
			DEY
			DEY
			BPL Loop2
MarioStop:
			SEP #$20
			LDA $13D9
			CMP #$0A
			BEQ NotMoveScreen	;if warp mode
			LDA $1BA0
			BNE NotMoveScreen	;if shake ground
ScreenBoundery:
			REP #$30
			LDX $0DD6			;mario or luigi
			LDA $1F17,x
			STA $00
			LDA $1F19,x
			STA $02
			TXA
			LSR A
			LSR A
			TAX
			LDA $1F11,x			;main mapor submap
			AND #$00FF
			BNE NotMoveScreen	;if on submap
			LDX #$0002
			TXY
Loop4:
			LDA $00,x
			SEC
			SBC #$0080
			BPL OnRightDownOfWorld
			CMP LeftUpEdge,y
			BCS MoveScreen
			LDA LeftUpEdge,y
			BRA MoveScreen
OnRightDownOfWorld:
			CMP RightDownEdge,y
			BCC MoveScreen
			LDA RightDownEdge,y
MoveScreen:
			STA $1A,x
			STA $1E,x
			DEY
			DEY
			DEX
			DEX
			BPL Loop4
NotMoveScreen:
			SEP #$30
			RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org $049885
;; Position data to $04-$05
;; x pos bit4-7 + y pos bit4-7 * 0x10 + x pos bit8 * 0x100 + y pos bit8 * 0x200 + submap flag * 0x400
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
OW_TilePos_Calc:
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
			BEQ Return07
			LDA $04
			CLC
			ADC #$0400
			STA $04
Return07:
			RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; $049037
;; Save
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DoSave:
			PHX
			PHY
			PHP
			SEP #$30
			LDA $13CA		;save flag
			BEQ NotSave
			LDX #$5F
Loop10:
			LDA $1EA2,x
			STA $1F49,x
			DEX
			BPL Loop10
			STZ $13CA		;save flag
			LDA #$05
			STA $1B87		;show save window
NotSave:
			PLP
			PLY
			PLX
			RTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; $049A24
;;  Warp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DoWarp:
			LDA #$77
			STA $C2
			PHX
			PHY
			REP #$20
			LDA $0DD6		;mario or luigi
			LSR A
			LSR A
			TAY
			LDA $1F11,y		;submap or mainmap
			AND #$00FF
			STA $13C3
			LDA #$001A
			STA $02
			LDX #$41
			LDY $0DD6
WarpLoop:
			LDA $1F19,y		;y position
			CMP $049964,x	;y position of warp from
			BNE NotMatch
			LDA $1F17,y		;x position
			CMP $049966,x	;x position of warp from
			BNE NotMatch
			LDA $049968,x	;map data of warp from
			AND #$00FF
			CMP $13C3		;map
			BNE NotMatch
			LDA $0499AA,x	;y position of warp to
			STA $1F19,y
			LDA $0499AC,x	;x position of warp to
			STA $1F17,y
			LDA $0499AE,x	;map data of warp to
			AND #$00FF
			STA $13C3		;map
			LDX $02
			LDA $0499F0,x	;y position/10 of warp to
			AND #$00FF
			STA $1F21,y
			LDA $0499F1,x	;x position/10 of warp to
			AND #$00FF
			STA $1F1F,y
			BRA OutWarpLoop
NotMatch:
			DEC $02
			DEC $02
			DEX
			DEX
			DEX
			DEX
			DEX
			BPL WarpLoop
OutWarpLoop:
			SEP #$20
			PLY
			PLX
			RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; $04F407
;;  Set zero $41-$43, $0D9F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ClearRAM:
			STZ $41
			STZ $42
			STZ $43
			STZ $0D9F
			RTS
