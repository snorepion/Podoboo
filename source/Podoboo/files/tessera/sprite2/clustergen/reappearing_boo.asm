;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; SMW Reappearing Boo Generator (sprite E5), by imamelia
;;
;; This is a disassembly of sprite E5 in SMW, the reappearing Boo generator.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

incsrc subroutinedefs.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; defines and tables
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ReappearBooPos1:
db $04,$44,$64,$84,$94,$B4,$D4,$15
db $85,$26,$46,$66,$B6,$C6,$17,$57
db $87,$97,$B7,$D7

ReappearBooPos2:
db $24,$44,$74,$84,$B4,$E4,$15,$35
db $95,$E5,$26,$66,$96,$B6,$E6,$27
db $77,$87,$C7,$D7



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; main routine wrapper
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Main:
JSR ReappearingBooMain
RTL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; main routine
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ReappearingBooMain:

STZ $190A				; reset the reappearing timer
LDX #$13					;
.ReappearingBooLoop		;
LDA #$07				; cluster sprite number = 07
STA $1892,x				;
LDA ReappearBooPos1,x		;
PHA						;
AND #$F0				;
STA $1E66,x				; X position on frame 1
PLA						;
ASL #4					;
STA $1E52,x				; Y position on frame 1
LDA ReappearBooPos2,x		;
PHA						;
AND #$F0				;
STA $1E8E,x				; X position on frame 2
PLA						;
ASL #4					;
STA $1E7A,x				; Y position on frame 2
DEX						;
BPL .ReappearingBooLoop	;
RTS						;


dl $FFFFFF,Main











