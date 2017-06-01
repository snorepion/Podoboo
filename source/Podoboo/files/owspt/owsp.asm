;WARNING: Don't edit the "tool line"s unless you want a crash or two. They must be EXACTLY as now to work. It is case sensitive.
;It is allowed to change the codes around them.
namespace off;why is this needed?
header
lorom

org $04F853	; NOTE TO ME: OPTIMIZE
JML Main
db $01
Back:
LDA $0DE5,x
JSL $0086DF

org $04862E
JML Stop

;-----------;
; Custom Rt ;
;-----------;

;TOOL LINE: freespace
db "STAR"
dw $8000-8-1
dw $8000-8-1^$FFFF;we want to reserve an entire bank so we know we can use that area later

Stop:
LDA $7FFF80
BNE +
REP #$30
LDX $0DD6
JML $048633

+
JML $04862D

Main:
LDA $0DE5,x
CMP #$0B              ; \ Check if >=0B.
BCS Custom            ; / If so, run custom OW sprite

PHK
PEA.w .jslrtsreturn-1
PEA.w $048414-1;I don't think PEA.l exists
JML $04F87C

.jslrtsreturn
BNE Normal
JML Back           ;

Custom:
PHB                   ; \ Wrapper.
PHK                   ;  |
PLB                   ; /
SEC                   ; \ Subtract B. (Also allows you to use slots up to $8A instead of $7F in this version.)
SBC #$0B              ; / (Not that you'll ever use all of them though)
PHX                   ; \ Preserve X and Y.
;PHY                   ; /
PHA
LDX $13D9
CPX #$0A
BNE +
LDX $1DE8
CPX #$01
BNE Return
+
LDX $0DB3
LDY $1F11,x
TAX
LDA Flags,y
AND ActivatePtr,x
BEQ Return
PLA                   ; 
ASL A		      ; Jump jump jump.
TAX                   ;
LDA CodePtr,x
STA $00
LDA CodePtr+1,x
STA $01
PLX
PEA.w End-1
JMP ($0000)           ;
BRA $02;too lazy to come up with a label name
Return:
PLA;pull garbage value
PLX
End:

;PLY                   ; Pull everything back and return.
;PLX
PLB
;PLA
;PLA;kill return jump
;PLA
Normal:
JML $04F828

Flags:
db $40,$20,$10,$08,$04,$02,$01;the lack of $80 is intentional, there's only seven submaps

CodePtr:
;TOOL LINE: pointers

ActivatePtr:
;TOOL LINE: activation

;TOOL LINE: codes

;TOOL LINE: warnpc