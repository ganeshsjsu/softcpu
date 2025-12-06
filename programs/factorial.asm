
.org 0x0000

main:
    LDI R0, #5          ; Initialize R0 with 5 (the number to calculate factorial of)
    CALL factorial      ; Call the recursive function
    CALL print_dec      ; Print R0 as decimal "120"
    HALT                ; Stop when returned. Result is in R0.

factorial:
    ; Check base case: is R0 <= 1?
    CMP R0, #1
    JZ base_case       ; If R0 == 1 (or 0, conceptually), jump to base case
    
    ; Recursive step:
    PUSH R0            ; [Stack] SAVE n. SP decrements by 2.
    SUBI R0, #1        ; Decrement n for the next call.
    CALL factorial     ; [Stack] Push Return Addr & Jump. New stack frame created.
    
    ; After return, R0 contains factorial(n-1)
    POP R1             ; [Stack] RESTORE n into R1. SP increments by 2.
    MUL R0, R1         ; Calculate: factorial(n-1) * n
    RET                ; [Stack] Pop Return Addr & Return.

base_case:
    LDI R0, #1         ; Base case returns 1
    RET                ; [Stack] Pop Return Addr & Return.



; Prints the value in R0 to console as decimal

print_dec:
    PUSH R1            ; Save registers we will use
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R0            ; Save original value
    
    LDI R5, #0          ; Digit counter
    
    CMP R0, #0          ; Special case for 0
    JNZ extract_loop
    LDI R0, #48         ; '0'
    STORE R0, [0xFF00]
    JMP print_exit

extract_loop:
    MOV R1, R0          ; Copy num to R1
    LDI R2, #10
    DIV R1, R2          ; R1 = num / 10 (quotient)
    
    MOV R3, R1
    MUL R3, R2          ; R3 = quotient * 10
    
    MOV R4, R0
    SUB R4, R3          ; R4 = num - (q*10) = remainder
    ADDI R4, #48        ; Convert to ASCII
    PUSH R4             ; Push digit char to stack
    ADDI R5, #1         ; Increment count
    
    MOV R0, R1          ; num = quotient
    CMP R0, #0
    JNZ extract_loop    ; Continue if num > 0
    
print_loop:
    CMP R5, #0          ; Any digits left?
    JZ print_exit
    POP R0              ; Pop digit char
    STORE R0, [0xFF00]  ; Print to console
    SUBI R5, #1
    JMP print_loop
    
print_exit:
    LDI R0, #10         ; Print Newline (\n)
    STORE R0, [0xFF00]
    
    POP R0             ; Restore original value
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET
