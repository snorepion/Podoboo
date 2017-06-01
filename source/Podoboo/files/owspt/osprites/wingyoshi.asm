;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Flying Yoshi
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Only after this event number is activated, this sprite is available. If FF, available form the first.
			!EventNumber = $FF

;Change music of this number while flying.
			!FlyingMusic = $01
			
;00: Airship can't land only on unrevealed Warp Star tile.
;01: Adding to 1, can't land on unrevealed tile.
;02: Adding to 2, can't land on pipe tile, castile tile, Bowser's castle tile, 
;    and no event tile (a tile only Mario stop).
			!TileLimit = $00		

;00: All Yoshi can fly.
;01: Only blue Yoshi can fly.
			!OnlyBuleYoshi = $00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org $04FAF1
;; main sprite routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Main:
			JSR EventCheck
			TYA
			BEQ Return02
			LDA $0DD6
			LSR A
			LSR A
			TAY
			LDA $0DBA,y			;yoshi color
			BEQ Return02		;if not on yoshi
			LDA #!OnlyBuleYoshi
			BEQ NotCheckBlue
			LDA $0DBA,y			;yoshi color
			CMP #$06
			BNE Return02		;if not blue yoshi
NotCheckBlue:
			LDA $0EE5,x
			BNE Fly
			STZ $0E55,x			;z position
			STZ $0EB5,x			;mode
			STZ $0E95,x			;x speed
			STZ $0EA5,x			;y speed
			JSR PoseCheck2
			JSR RButtonCheck
Return02:
			RTS
Fly:
			JSR Graphic
			LDA #$01
			STA $13D9
			LDA $0EB5,x			;flying mode
			CMP #$01
			BEQ TakeOff
			CMP #$02
			BEQ MovinMode
			CMP #$03
			BEQ LandOn
			RTS
MovinMode:
			JSR GetLevelName
			JSR Speed
			JSR RButtonCheck2
			JSR Move
			JSR ScreenBoundery
			RTS
TakeOff:
			LDA $0E55,x
			CMP #$30
			BEQ EnoughHight
			INC $0E55,x
			RTS
EnoughHight:
			INC $0EB5,x
			RTS
LandOn:
			LDA #$02
			STA $0E05,x
			LDA $0E55,x
			BEQ OnGround
			DEC $0E55,x
			RTS
OnGround:
			JSR PoseCheck
			LDA #$00
			STA $7FFF80
			STZ $13D9
			STZ $0EE5,x
			LDY $0DD6
			LDA $0E65,x			;sprite x position high byte
			XBA
			LDA $0E35,x			;sprite x position low byte
			REP #$20
			CLC
			ADC #$0008
			STA $1F17,y
			LSR A
			LSR A
			LSR A
			LSR A
			STA $1F1F,y
			SEP #$20
			LDA $0E75,x			;sprite y position high byte
			XBA
			LDA $0E45,x			;sprite y position low byte
			REP #$20
			CLC
			ADC #$0008
			STA $1F19,y
			LSR A
			LSR A
			LSR A
			LSR A
			STA $1F21,y
			SEP #$20
			STZ $13CE			;midway flag
			STZ $13CA			;save flag
			JSR SetBackMusic
			RTS
			
SetBackMusic:
			LDX $0DB3
			LDA $1F11,x
			TAX
			LDA $048D8A,x		;OW music same to $04DBC8
			STA $1DFB
			LDX $0DDE
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
;; Graphic
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Tile:		db $42,$64,$4E,$4E		;left
			db $42,$64,$4F,$4F
			db $42,$64,$5E,$5E
			db $42,$64,$4F,$4F
			db $42,$64,$4E,$4E		;right
			db $42,$64,$4F,$4F
			db $42,$64,$5E,$5E
			db $42,$64,$4F,$4F
			db $0A,$4E,$4E,$2E		;down
			db $0A,$4F,$4F,$2E
			db $0A,$5E,$5E,$2E
			db $0A,$4F,$4F,$2E
			db $2E,$4E,$4E,$66		;up
			db $2E,$4F,$4F,$66
			db $2E,$5E,$5E,$66
			db $2E,$4F,$4F,$66
			
Horz:		db $00,$07,$08,$08		;left
			db $00,$07,$08,$08
			db $00,$07,$05,$05
			db $00,$07,$08,$08
			db $00,$F9,$00,$00		;right
			db $00,$F9,$00,$00
			db $00,$F9,$03,$03
			db $00,$F9,$00,$00
			db $00,$0C,$FC,$00		;down
			db $00,$0C,$FC,$00
			db $00,$09,$FF,$00
			db $00,$0C,$FC,$00
			db $00,$0C,$FC,$00		;up
			db $00,$0C,$FC,$00
			db $00,$09,$FF,$00
			db $00,$0C,$FC,$00
			
Vert:		db $01,$FC,$02,$02		;left
			db $00,$FB,$08,$08
			db $01,$FC,$09,$09
			db $00,$FB,$08,$08
			db $01,$FC,$02,$02		;left
			db $00,$FB,$08,$08
			db $01,$FC,$09,$09
			db $00,$FB,$08,$08
			db $F9,$FF,$FF,$00		;down
			db $F8,$05,$05,$FF
			db $F9,$06,$06,$00
			db $F8,$05,$05,$FF
			db $00,$FF,$FF,$FB		;up
			db $FF,$05,$05,$FA
			db $00,$06,$06,$FB
			db $FF,$05,$05,$FA

Prop:		db $30,$30,$30,$30		;left
			db $70,$70,$70,$70		;right
			db $30,$30,$70,$30		;down
			db $30,$30,$70,$30		;up

Size:		db $02,$02,$00,$00		;left
			db $02,$02,$00,$00		;right
			db $02,$00,$00,$02		;down
			db $02,$00,$00,$02		;up

Yoshi:		db $01,$00,$00,$00		;left
			db $01,$00,$00,$00		;right
			db $00,$00,$00,$01		;down
			db $01,$00,$00,$00		;up



ShadowHorz:	db $00,$08
ShadowProp:	db $30,$70


Graphic:
			JSR SetDrawPosition
			JSR SetOAMIndex
			LDA $01
			ORA $03
			BEQ DrawYoshi
			JMP DrawShadow		;if shadow is offscreen
DrawYoshi:
			LDA $0DD6
			LSR A
			CLC
			ADC #$04
			STA $0E				;mario/luigi color
			LDA $0DD6
			LSR A
			LSR A
			TAX
			LDA $0DBA,x
			SEC
			SBC #$04
			STA $0F				;yoshi color

			LDX $0DDE
			LDA $0E05,x			;direction
			ASL A
			ASL A
			STA $04
			ASL A
			ASL A
			STA $05
			LDA $14
			LSR A
			AND #$0C
			ORA $05
			STA $05
			LDX #$03
GfxLoop1:
			PHX
			TXA
			CLC
			ADC $05
			TAX
			LDA Horz,x
			CLC
			ADC $00
			STA $0300,y
			LDA Vert,x
			CLC
			ADC $02
			SEC
			SBC #$06
			STA $0301,y
			LDA Tile,x
			STA $0302,y
			PLX
			
			PHX
			TXA
			CLC
			ADC $04
			TAX
			LDA Prop,x
			STA $0303,y
			LDA Yoshi,x
			BNE YoshiTile
			LDA $0303,y
			ORA $0E				;mario/luigi color
			STA $0303,y
			BRA NotYoshiTile
YoshiTile:
			LDA $0303,y
			ORA $0F				;yoshi color
			STA $0303,y
NotYoshiTile:
			PHY
			TYA
			LSR A
			LSR A
			TAY
			LDA Size,x
			STA $0460,y			;00:8x8 size 02:16x16 size
			PLY
			PLX
			INY
			INY
			INY
			INY
			DEX
			BPL GfxLoop1

DrawShadow:
			PHY
			LDX $0DDE
			JSR SetDrawPosition
			JSR SetShadowPosition
			PLY
			LDA $01
			ORA $03
			BNE GfxReturn		;if shadow is offscreen
			LDX #$01
GfxLoop2:
			LDA $00
			CLC
			ADC ShadowHorz,x
			STA $0300,y
			LDA $02
			CLC
			ADC #$04
			STA $0301,y
			LDA #$29
			STA $0302,y
			LDA ShadowProp,x
			STA $0303,y
			PHY
			TYA
			LSR A
			LSR A
			TAY
			LDA #$00
			STA $0460,y			;00:8x8 size 02:16x16 size
			PLY
			INY
			INY
			INY
			INY
			DEX
			BPL GfxLoop2
			LDX $0DDE
GfxReturn:
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
;; When only R button pressed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RButtonCheck:
			LDA $13D4		;if OW view mode
			BNE Return05
			LDA $18
			CMP #$10
			BNE Return05
			LDA $17
			CMP #$10
			BNE Return05
			LDA $15
			BNE Return05
			LDA $13D9
			CMP #$03		;if mario does not stand on a tile
			BNE Return05
			LDA #$01
			STA $13D9
			LDA #!FlyingMusic
			STA $1DFB
			INC $0EB5,x		;take off mode
			LDA #$01
			STA $0EE5,x
			STA $7FFF80
			LDY $0DD6
			LDA $1F17,y
			SEC
			SBC #$08
			STA $0E35,x
			LDA $1F18,y
			SBC #$00
			STA $0E65,x
			LDA $1F19,y
			SEC
			SBC #$08
			STA $0E45,x
			LDA $1F1A,y
			SBC #$00
			STA $0E75,x
Return05:
			RTS

RButtonCheck2:
			LDA $18
			AND #$10
			BEQ Return09
			LDA #$01
			STA $0EC5,x		;R buttun flag
Return09:
			RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; move mario
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Speed:
			LDA $0E35,x		;x position
			ORA $0E45,x		;y position
			AND #$0F
			BNE Return06
			STZ $0E95,x		;x speed
			STZ $0EA5,x		;y speed
			LDA $15
			BIT #$01
			BNE MoveRight
			BIT #$02
			BNE MoveLeft
			BIT #$04
			BNE MoveDown
			BIT #$08
			BNE MoveUp
Return06:
			RTS
MoveRight:
			LDA #$02
			STA $0E95,x		;x speed
			LDA #$01
			STA $0E05,x		;direction
			RTS
MoveLeft:
			LDA #$FE
			STA $0E95,x		;x speed
			STZ $0E05,x		;direction
			RTS
MoveDown:
			LDA #$02
			STA $0EA5,x		;y speed
			LDA #$02
			STA $0E05,x		;direction
			RTS
MoveUp:
			LDA #$FE
			STA $0EA5,x		;y speed
			LDA #$03
			STA $0E05,x		;direction
			RTS
			
Move:
			LDA $0E35,x		;x position
			ORA $0E45,x		;y position
			AND #$0F
			BNE NotLandOn
			LDA $0EC5,x		;R bottun flag
			BEQ NotLandOn
			JSR CanLandOnCheck
			LDA $0EC5,x		;R bottun flag
			BEQ NotLandOn
			STZ $0EC5,x
			INC $0EB5,x		;land on mode
			RTS
NotLandOn:
			LDA $0E35,x
			CLC
			ADC $0E95,x
			STA $0E35,x
			LDA $0E65,x
			ADC #$00
			STA $0E65,x
			LDA $0E95,x
			BPL MoveY
			DEC $0E65,x
MoveY:
			LDA $0E45,x
			CLC
			ADC $0EA5,x
			STA $0E45,x
			LDA $0E75,x
			ADC #$00
			STA $0E75,x
			LDA $0EA5,x
			BPL Return07
			DEC $0E75,x
Return07:
			JSR FixPosition
			RTS
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;fix position
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
XFixTable1:		db $00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$01,$00,$01
XFixTable2:		db $F0,$01,$D0,$00,$D0,$00,$D0,$00,$D0,$01,$D0,$01,$D0,$01
YFixTable1:		db $00,$00,$00,$00,$B0,$00,$50,$01,$00,$00,$B0,$00,$50,$01
YFixTable2:		db $F0,$01,$90,$00,$40,$01,$E0,$01,$90,$00,$40,$01,$E0,$01


FixPosition:
			LDA $0DD6		;mario or luigi
			LSR A
			LSR A
			TAY
			LDA $1F11,y		;map
			ASL A
			TAY
			REP #$20
			LDA XFixTable1,y
			STA $08
			LDA XFixTable2,y
			STA $0A
			LDA YFixTable1,y
			STA $0C
			LDA YFixTable2,y
			STA $0E
			
			SEP #$20
			LDA $0E65,x
			XBA
			LDA $0E35,x
			REP #$20
			CMP #$8000
			BCS FixLeft
			CMP $08
			BCC FixLeft
			CMP $0A
			BCS FixRight
			SEP #$20
			BRA YFixPosition
FixLeft:
			SEP #$20
			LDA $08
			STA $0E35,x
			LDA $09
			STA $0E65,x
			BRA YFixPosition
FixRight:
			SEP #$20
			LDA $0A
			STA $0E35,x
			LDA $0B
			STA $0E65,x
YFixPosition:
			LDA $0E75,x
			XBA
			LDA $0E45,x
			REP #$20
			CMP #$8000
			BCS FixUp
			CMP $0C
			BCC FixUp
			CMP $0E
			BCS FixDown
			SEP #$20
			BRA Return08
FixUp:
			SEP #$20
			LDA $0C
			STA $0E45,x
			LDA $0D
			STA $0E75,x
			BRA Return08
FixDown:
			SEP #$20
			LDA $0E
			STA $0E45,x
			LDA $0F
			STA $0E75,x
Return08:
			RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;$049522
;;Get level name
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GetLevelName:
			JSR OW_TilePos_calc
			REP #$30
			LDX $04			;position data
			LDA $7EC800,x	;map tile
			AND #$00FF
			SEP #$30
			STA $13C1
			JSR CheckIgnoreTile
			TYA
			BNE LoadName
			REP #$30
			LDA #$0000
			BRA NoName
LoadName:
			REP #$30
			STZ $00
			LDX $04			;position data
			LDA $7ED000,x			;level number
			AND #$00FF
NoName:
			JSL $03BB20		;get level name custom routine inserted by Lunar Magic
			SEP #$30
			LDX $0DDE
			RTS

			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;check tile and can land on
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CanLandOnCheck:
			JSR CheckIgnoreTile
			TYA
			BEQ CanNotLandOn
			RTS
CanNotLandOn:
			STZ $0EC5,x
			RTS
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;check specific tile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IgnoreTileTable:		db $57,$59,$6E,$6F,$70,$71,$72,$73,$74,$75,$76,$78,$7A,$7B,$7D,$7F
					db $5B,$5D,$60,$61,$65,$82,$84

CheckIgnoreTile:
			LDY #$00
			LDA $13C1
			CMP #$83		;move tile
			BEQ Ignore
			CMP #$5A		;not appeared warp star
			BEQ Ignore
			CMP #$56
			BCC Ignore
			CMP #$87
			BCS Ignore
			LDA #!TileLimit
			BEQ Recognize
			LDX #$0F
			LDA #!TileLimit
			CMP #$01
			BEQ Loop2
			LDX #$16
Loop2:
			LDA IgnoreTileTable,x
			CMP $13C1
			BEQ Ignore
			DEX
			BPL Loop2
			LDX $0DDE
Recognize:
			LDY #$01
			RTS
Ignore:
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
			LDA $02
			SEC
			SBC $0E55,x			;height from ground
			STA $02
			BCS NotCarryDown01
			DEC $03
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
;; org $04FE4E
;; After SetDrawPosition routine, $02-$03 is y position of body.
;; This routine sets shadow position to $02-$03. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SetShadowPosition:
			LDA $02
			CLC
			ADC $0E55,x
			STA $02
			BCC Return04
			INC $03
Return04:
			RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; a few changed from $04983F
;; Decide Screen Boundery
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;$049416
LeftUpEdge:		db $EF,$FF,$D7,$FF
;$04941A
RightDownEdge:	db $11,$01,$31,$01

ScreenBoundery:
			LDA $0DD6
			LSR A
			LSR A
			TAY
			LDA $1F11,y
			BNE NotMoveScreen	;if not main map
			LDA $0E65,x			;sprite x position high byte
			XBA
			LDA $0E35,x			;sprite x position low byte
			REP #$20
			CLC
			ADC #$0008
			STA $00
			SEP #$20
			LDA $0E75,x			;sprite y position high byte
			XBA
			LDA $0E45,x			;sprite y position low byte
			REP #$20
			CLC
			ADC #$0008
			STA $02
			REP #$30
			LDX #$0002
			TXY
Loop1:
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
			BPL Loop1
NotMoveScreen:
			SEP #$30
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
			

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; adjust mario's pose
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PoseTable:		db $03,$02,$00,$01

PoseCheck:
			LDA $0DD6		;mario or luigi
			LSR A
			TAY
			LDA $1F13,y		;mario/luigi graphic
			AND #$F8
			ORA #$02		;face foward
			STA $1F13,y
			JSR WaterCheck
			RTS
			
PoseCheck2:
			LDA $0DD6
			LSR A
			TAY
			LDA $1F13,y
			AND #$07
			LSR A
			TAY
			LDA PoseTable,y
			STA $0E05,x
			RTS
			
WaterCheck:
			LDA $13C1
			CMP #$80
			BEQ WaterTile
			CMP #$6A
			BCC GroundTile
			CMP #$6E
			BCS GroundTile
WaterTile:
			LDA $1F13,y
			ORA #$08
			STA $1F13,y
			RTS
GroundTile:
			LDA $1F13,y
			AND #$F7
			STA $1F13,y
			RTS
