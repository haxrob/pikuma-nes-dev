.segment "HEADER" ; https://www.nesdev.org/wiki/INES
.org $7FF0 ; location of iNES hdr, this is 16 bytes before $8000, PRG-ROM
.byte $4E,$45,$53,$1A   ; 4 bytes with the characters NES\n
.byte $02 ; 2 * 16kb PROG
.byte $01 ; 1 * 8kb CHR 
.byte %00000000 ; no mapper, hoz scaling, no battery
.byte %00000000 ; mapper 0, player choice, NES 2.0 format
.byte $00      ; No PRG-RAM (cart ram)
.byte $00      ; NTSC TV Format
.byte $00   ; No PRG-RAM
.byte $00,$00,$00,$00,$00 ; Unused padding, total 16 bytes iNES header
