.MODEL  TINY
.STACK  100H
ASSUME  CS:COD,DS:COD,ES:COD,SS:STACK
COD     SEGMENT
START:
        MOV     AX,CS
        MOV     ES,AX
        SUB     AX,10H
        MOV     SS,AX
        MOV     AH,'/'
        MOV     SI,80H
        CALL    RFS
        JC      RFS_ERR
        OR      CX,CX
        JZ      RFS_ERR
        PUSH    CX
        INC     SI
        PUSH    SI
        PUSH    DS
        PUSH    ES
        POP     DS
        POP     ES
        LEA     DX,BUF
        XOR     AX,AX
        DEC     AX
        MOV     CX,AX
        MOV     BX,AX
        CALL    LOAD_FILE
        PUSH    ES
        PUSH    DS
        POP     ES
        LEA     SI,BUF
        LEA     DI,BUF+8000H
        LEA     BX,TABL
        CALL    CONVERT_TXT
        POP     DS
        PUSH    DS
        POP     ES
        POP     SI
        POP     CX
        CALL    SEEK_NEXT_FILE
        PUSH    CS
        POP     DS
        MOV     CX,DX
        XOR     BX,BX
        LEA     DX,BUF+8000H
        CALL    SAVE_FILE
        MOV     AX,4C00H
        INT     21H
RFS_ERR:
        MOV     AX,4CFFH
        INT     21H
SEEK_NEXT_FILE  PROC
        PUSH    CX
        PUSH    SI
        PUSH    DI
        PUSH    DS
        PUSH    ES
SEEK_NEXT_FILE_2:
        LODSB
        MOV     DI,SI
        CMP     AL,'.'
        JZ      SEEK_NEXT_FILE_1
        CMP     AL,' '
        JA      SEEK_NEXT_FILE_2
        MOV     AL,'.'
        STOSB
SEEK_NEXT_FILE_1:
        PUSH    CS
        POP     DS
        LEA     SI,EXT
        MOV     CX,4
        REP     MOVSB
        POP     ES
        POP     DS
        POP     DI
        POP     SI
        POP     CX
        RET
ENDP
INCLUDE ..\..\LIBRARY\FILE\IO.LIB
INCLUDE ..\..\LIBRARY\TEXT\TXT2SPR.LIB
INCLUDE ..\..\LIBRARY\FILE\READFSTR.LIB
EXT     DB      'WIN',0
TABL    DB      32,78H,33,0,0AFH,78H,0B0H,0,0DFH,70H,0E0H,0,0FEH,78H,0FFH,0FFH
BUF:
ENDS
END START