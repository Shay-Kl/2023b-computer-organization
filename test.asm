; Define constants
section .data
arr: .short 6, 0xEA, 0x22, 0x4B1D, 0b1010

; Define the program entry point and text segment
section .text
global _start

_start:

; Exit system call number for x86-64
mov rax, 60 ; sys_exit
xor rdi, rdi ; exit status 0 (rdi = 0)

; Perform the system call
syscall

; This part is not necessary, but you can keep it if you want
xor rcx, rcx
ret
