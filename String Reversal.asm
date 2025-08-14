DATA SEGMENT
    ST1 DB 100 DUP(?)                 ; Buffer for user input (max 100 chars)
    MSG1 DB "ENTER THE STRING $"     ; Prompt message
    MSG2 DB "REVERSED STRING $"      ; Reverse output message
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA

START:
    ; Initialize DS
    MOV AX, DATA
    MOV DS, AX

    ; Display input prompt
    LEA DX, MSG1
    MOV AH, 09H
    INT 21H

    ; Read characters into ST1
    LEA SI, ST1           ; SI points to start of input buffer
    MOV CL, 01H           ; CL counts characters (starts from 1 to avoid CL=0 bug)

L1:
    MOV AH, 01H           ; Function 01H: Read char with echo
    INT 21H
    CMP AL, 0DH           ; Check for Enter key (carriage return)
    JZ L2                 ; If Enter is pressed, go to print reverse

    INC CL                ; Increment character count
    INC SI                ; Move SI to next memory position
    MOV [SI], AL          ; Store input character at current SI
    JMP L1                ; Repeat input loop

L2:
    ; Display reverse message
    LEA DX, MSG2
    MOV AH, 09H
    INT 21H

L3:
    MOV DL, [SI]          ; Load character from buffer
    MOV AH, 02H           ; Function 02H: Print character
    INT 21H

    DEC SI                ; Move backward in buffer
    DEC CL                ; Decrease character counter
    CMP CL, 00H           ; Check if all characters printed
    JNZ L3                ; If not, continue loop

    ; Terminate program
    MOV AH, 4CH
    INT 21H

CODE ENDS
END START
