.include "consts.asm"
.include "ines_header.asm"
.include "reset.asm"

;;;;;;;;;;;;;;;;;;
;; PRG-ROM
;;;;;;;;;;;;;;;;;;
.segment "CODE"

.proc LoadPalette
   ldy #0
LoopNext:
   lda PaletteData,y ; a = PaletteData[y]
   sta PPU_DATA
   iny
   cpy #32 ; if y == 32 
   bne LoopNext 
   rts
.endproc

.proc LoadBackground
   ldy #0
LoopNext:
   lda BackgroundData,y
   sta PPU_DATA
   iny
   cpy #255
   bne LoopNext
   rts
.endproc

RESET:
   INIT_NES

Main:

   ; PPU_ADDR = $3F00 = first pos of bg color pallete 

   bit PPU_STATUS ; reset PPU addr latch (reading resets) 
   ldx #$3F
   stx PPU_ADDR ; high byte
   ldx #$00
   stx PPU_ADDR ; low byte

   jsr LoadPalette

   ;; load character palette 
   bit PPU_STATUS
   ldx #$20
   stx PPU_ADDR
   ldx #$00
   stx PPU_ADDR

   jsr LoadBackground

EnablePPURendering:
   lda #%10010000 ; enable NMI interupts and set background to use 2nd 
                  ; pattern table (at $1000)
   sta PPU_CTRL

   lda #%00011110 ; PPU_MASK = show bg, left
   sta PPU_MASK 

Loop:
   jmp Loop

NMI:
   rti ; return to interupt

IRQ:
   rti

PaletteData:
; first 16 bytes is background
.byte $0F,$2A,$0C,$3A, $0F,$2A,$0C,$3A, $0F,$2A,$0C,$3A, $0F,$2A,$0C,$3A
; next 16 is sprites. 
.byte $0F,$10,$00,$26, $0F,$10,$00,$26, $0F,$10,$00,$26, $0F,$10,$00,$26
;     ^-----------------^----- .. first byte of each group has to be same
BackgroundData:
.byte $24,$24,$24,$24,$24,$24,$24,$24,$24,$36,$37,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24
.byte $24,$24,$24,$24,$24,$24,$24,$24,$35,$25,$25,$38,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$60,$61,$62,$63,$24,$24,$24,$24
.byte $24,$36,$37,$24,$24,$24,$24,$24,$39,$3a,$3b,$3c,$24,$24,$24,$24,$53,$54,$24,$24,$24,$24,$24,$24,$64,$65,$66,$67,$24,$24,$24,$24
.byte $35,$25,$25,$38,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$24,$55,$56,$24,$24,$24,$24,$24,$24,$68,$69,$26,$6a,$24,$24,$24,$24
.byte $45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45
.byte $47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47
.byte $47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.segment "CHARS"
.incbin "mario.chr"


.segment "VECTORS"
.word NMI
.word RESET
.word IRQ
;;; $FFFF


