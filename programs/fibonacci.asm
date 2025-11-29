; Fibonacci sequence demo
.const IO_CONSOLE_DATA 0xFF00

.const FIB_COUNT 12

        .org 0x0000
start:
        LDI r0, #0          ; a
        LDI r1, #1          ; b
        LDI r2, #FIB_COUNT
loop:
        MOV r3, r0          ; value to print
        CALL print_decimal
        LDI r4, #10
        STORE r4, [IO_CONSOLE_DATA]

        MOV r4, r1
        ADD r1, r0          ; b = a + b
        MOV r0, r4          ; a = old b

        SUBI r2, #1
        JNZ loop

        HALT

; Prints R3 in hexadecimal (0x0000 format) and preserves caller registers
; Prints R3 in decimal and preserves caller registers
print_decimal:
        PUSH r0
        PUSH r4
        PUSH r5
        PUSH r6

        ; Handle 0 special case
        CMP r3, #0
        JNZ init_extract
        LDI r4, #'0'
        STORE r4, [IO_CONSOLE_DATA]
        JMP done_decimal

init_extract:
        LDI r6, #0          ; Digit count
        LDI r4, #10         ; Divisor

extract_loop:
        MOV r5, r3          ; r5 = dividend
        DIV r3, r4          ; r3 = quotient
        MOV r0, r3          ; r0 = quotient
        MUL r0, r4          ; r0 = quotient * 10
        SUB r5, r0          ; r5 = dividend - (quotient * 10) = remainder
        PUSH r5             ; Save digit
        ADDI r6, #1         ; Increment count
        CMP r3, #0
        JNZ extract_loop

print_loop:
        CMP r6, #0
        JZ done_decimal
        POP r5
        ADDI r5, #'0'       ; Convert to ASCII
        STORE r5, [IO_CONSOLE_DATA]
        SUBI r6, #1
        JMP print_loop

done_decimal:
        POP r6
        POP r5
        POP r4
        POP r0
        RET
