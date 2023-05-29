.section .data
A: .long 3
   .quad B
   .quad C
B: .long 4
   .quad D
   .quad 0
C: .int 5
   .quad E
   .quad F
D: .int 7
   .quad 0
   .quad 0
E: .int 8
   .quad 0
   .quad 0
F: .int 9
   .quad G
   .quad H
G: .int 10
   .quad 0
   .quad 0
H: .int 11
   .quad 0
   .quad 0
   
.section .text
.global main
main:
    mov $8, %esi
    mov $A, %rdi
    call func
    movq $60, %rax
    movq $0, %rdi
    syscall
    
func:
    pushq %rbp
    movq %rsp, %rbp
    cmp (%rdi), %esi
    jne continue
    mov $1, %eax
    jmp finish
    
continue:
    push %rdi
    cmpq $0, 4(%rdi)
    je next
    pushq %rdi
    mov 4(%rdi), %rdi
    call func
    mov (%rsp), %rdi
    cmp $1, %eax
    je finish
next:
    cmpq $0, 12(%rdi)
    je fail
    mov 12(%rdi), %rdi
    call func
    cmp $1, %eax
    je finish
    
fail:
    mov $0, %eax
finish:
    leave
    ret
