; nextbreak.asm
                        OPT RESET --syntax=abfw \
                            --zxnext=cspect             ; Tighten up syntax and warnings
                        DEVICE ZXSPECTRUMNEXT           ; Use ZX Spectrum Next memory model

                        INCLUDE constants.asm
                        INCLUDE macros.asm
 
                        ORG $C000
Start:                        
                        ei
                        ld bc, $2f3b                    ; Switch back to normal speed if nextfaststart plugin is enabled
                        xor a
                        out (c), a
                        ld a, 2
                        call ROM3_CHAN_OPEN             ; Setup ROM printing in upper screen
                        ld a, %01'000'111
                        ld (ROM3_ATTR_TL), a            ; Print BRIGHT 1; INK 7; PAPER 0
                        PRINT Msg, Msg.Len              ; Print a message with ROM printing
                        ld h, 0
                        ld bc, $00fe
.loop:
                        out (c), h                      ; Strobe the border
                        inc h                           ; with a new colour each frame
                        in a, (c)                       ; Read all keys
                        cpl
                        and %11111
                        jr z, .loop                     ; And loop if nothing was pressed
                        CSBREAK                         ; DB $fd, $00 break opcode
                        halt                            ; MAME needs two frames in order to clear
                        halt                            ; last read keys after exiting debugger
                        jr .loop                        ; Then go back to reading keys

Msg:                    DB AT, 09, 9, "Press any key"
                        DB AT, 10, 6, "to do a programmatic"
                        DB AT, 11, 6, "$FD $00 break opcode"
                        DB AT, 12, 1, "into the MAME/CSpect debugger."
Msg.Len                 EQU $-Msg
        
                        SAVENEX OPEN "nextbreak.nex", Start, $0000
                        SAVENEX CORE 3, 01, 05          ; Next core 3.01.05 required as minimum
                        SAVENEX BANK 0
                        SAVENEX CLOSE