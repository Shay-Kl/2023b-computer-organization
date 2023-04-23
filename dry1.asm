

.data
arr: .short 6, 0xEA, 0x22, 0x4B1D, 0b1010
buff: .fill 10, 2, 0x42
id: .long 0x19283746
key: .quad 0x0406282309052021

.bss
.lcomm a, 8
.lcomm b, 4
.lcomm c, 10


.text
.global _start
_start:
    movq %rsp, %rbp #for correct debugging
    xor %rcx, %rcx
    movl $0x5432, %ebx
    movb $4, %bl
#rbx
    xor %rax, %rax
    xor %rsi, %rsi
    #add b, %rax, %rbx
#rbx - too many operands for add
    #lea 4(arr), %rbx
#rbx - displacement(label) is invalid
    lea (buff), %rbx
    movb 4(%rbx), %al
#rax
    movb 7(%rbx), %al
#rax
    #lea (arr), %rbx DEADBEEF
    #mov $0xDEADBEEF, %rbx
    mov %bh, %al
    xor %al, %sil
    shr $5, %rsi
#rsi
    movw -4(%rbx, %rsi, 2), %dx
#dx
    shl $1, %rsi
    movb $0x68, b
    #addb (%rbx, %rsi, 2), b
#b - can't add from memory to memory
    mov $0xFFFF00, %rax 
    shr $8, %rax
    inc %ax
#rax
    movw arr+3, %ax
    ror $2, %ax
#rax
    xor %ax, %ax
    #incb %ax
#rax - ax isn't one byte long
    mov $a, %rcx
    lea key, %rbx
    movq (%rbx), %rbx
    mov $0x40, %si
    dec %rcx 
    movl %ebx, 2(%rcx)

#a+4
    movb $78, b
#b
    movq $arr, b
#b
    movswq (b), %rdx
#rdx
    mov $0xAAAA, %ax
    cwd
#rdx
    movw $-0x9F, a
    idivw a
#eax
#edx
    movq $0x123, (b)
    imul $3, b, %rdx
#rax

#rdx
    xor %rax, %rax
    mov $0xfc, %ax
    mov $4, %bl
    mov $015, %rdx
    imulb %bl
#al

#dl
    #leaq $0x40FE67, %rdx 
#rdx - instants don't have an effective adress

#quit
	mov $60, %rax
	xor %rdi, %rdi
	syscall
