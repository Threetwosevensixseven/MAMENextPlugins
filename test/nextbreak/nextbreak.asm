; nextbreak.asm
                        OPT RESET --syntax=abfw \
                            --zxnext=cspect             ; Tighten up syntax and warnings
                        DEVICE ZXSPECTRUMNEXT           ; Use ZX Spectrum Next memory model
 
                        ORG $C000
Start:                        
                        di
                        ld bc, $2f3b
                        ld a, 2
                        out (c), a
                        db $fd, $00
                        xor a
.loop:
                        out (254), a
                        inc a
                        jr .loop
                
                        SAVENEX OPEN "nextbreak.nex", Start, $0000
                        SAVENEX CORE 3, 01, 05          ; Next core 3.01.05 required as minimum
                        SAVENEX BANK 0
                        SAVENEX CLOSE