.data
arr: .short 6, 0xEA, 0x22, 0x4B1D, 0b1010

.text
.global _start

_start:

mov %rax, $60 
xor %rdi, %rdi 

syscall
