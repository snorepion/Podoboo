!version = #$01

incsrc defines.asm		; global defines

if read1($06F690) == $8B
	autoclean read3(read3($06F690+8)+21)
endif

macro offset(id, addr)          ; > Hijack LM map16 code to run custom blocks. 
	org <addr>
		PHB : PHX
		REP #$30
		LDA.w <id>*3+1
		autoclean JSL block_execute
		PLX : PLB
		JMP $F602
endmacro

%offset(#$00, $06F690) : %offset(#$01, $06F6A0) : %offset(#$02, $06F6B0) : %offset(#$07, $06F6C0)	; > Below, Above, Side, Topcorner
%offset(#$08, $06F6D0) : %offset(#$09, $06F6E0) : %offset(#$03, $06F720) : %offset(#$04, $06F730)	; > Body, Head, SpriteV, SpriteH
%offset(#$05, $06F780) : %offset(#$06, $06F7C0) : %offset(#$0A, $06F7D0) : %offset(#$0B, $06F7E0)	; > Cape, Fireball, WallFeet, WallBody

org read3($06F624)		; > Table containing all the acts like of the blocks.
	incbin __acts_likes.bin

org $06F67B			; > Add another offset check for wallrun in the CMP-BEQ list
	autoclean JML WallRun

org $06F717			; > Fix spriteH bug that there is another value being used in the stack.
	autoclean JML FixSpriteH

freecode
WallRun:
	CMP #$39		; > JSR [($00EB3A-1)&$0000FF]
	BEQ .RunBlockCode
	CMP #$EA
	BEQ .RunBlockCode2 ; Wall feet
	JML $06F602		; > Ignore custom block code.
.RunBlockCode
	JML $06F7D0
.RunBlockCode2
	JML $06F7E0

FixSpriteH:
	CMP #$82		; > This was also used for spriteH.
	BEQ .RunBlockCode
	JML $06F602		; > Ignore custom block code.
.RunBlockCode
	JML $06F730

block_execute:
	STA $05
	LDX $03
	LDA.l block_bank_byte,x
	AND #$00FF
	BEQ .return
	XBA
	STA $01
	PHA
	TXA
	ASL
	TAX
	LDA.l block_pointers,x
	STA $00
	LDA $05
	CMP #$001E
	BCC .RunBlockCodeNormal
	LDA [$00]
	CMP #$4C37
	BEQ .RunBlockCodeNormal2
	PLA
.return
	SEP #$30
	RTL
.RunBlockCodeNormal2
	CLC
.RunBlockCodeNormal
	LDA $00	
	ADC $05
	STA $00
	SEP #$30
	PLX			; destroy extra bank byte
	PLB			; bank byte of block
	LDX $15E9|!addr
	JML [$0000|!dp]

block_bank_byte:		; bank byte of each block 00 means "not inserted"
	incbin __banks.bin	; 16KB -- can be made into a incsrc for manual use
block_bank_byte_end:
	db "GPS_VeRsIoN"
	db !version
	dl block_bank_byte
	dl block_pointers
	dw block_bank_byte_end-block_bank_byte
	dw block_pointers_end-block_pointers
	
freedata cleaned
block_pointers:				; two byte pointer per block -- little endian as expected.
	incbin __pointers.bin	; 32KB -- can also be made to be incsrced
block_pointers_end:
