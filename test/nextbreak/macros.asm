; macros.asm

PRINT                   MACRO Addr?, Len?
                            ld de, Addr?
                            ld bc, Len?
                            call ROM3_PRINT
                        ENDM

CSBREAK                 MACRO
                            DB $fd, $00
                        ENDM