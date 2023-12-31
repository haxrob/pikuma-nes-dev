.macro INIT_NES

   ;;; housekeeping
   sei ; set interupt disable
   cld ; clear decimal mode as not supported by NES
   ldx #$FF
   txs ; init stack pointer at $01FF (bottom of stack)

   inx ; x = 0
   stx PPU_MASK ; disable rendering
   stx PPU_CTRL
   stx $4010

   lda #$40
   sta $4017

   txa ; a = 0

; wait for PPU to warm up 
vblankwait:
   bit PPU_STATUS
   bpl vblankwait ; signed bit 7 is zero (branch if plus)

; clear RAM $0000 to $07FF
ClearRAM:
   inx
   sta $0000,x
   sta $0100,x
   sta $0200,x
   sta $0300,x
   sta $0400,x
   sta $0500,x
   sta $0600,x
   sta $0700,x
   bne ClearRAM

; wait for PPU to finish warming up

vblankwait2:
   bit PPU_STATUS
   bpl vblankwait2 ; signed bit 7 is zero (branch plus)

.endmacro
