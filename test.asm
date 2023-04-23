; Define constants
.data
arr: .short 6, 0xEA, 0x22, 0x4B1D, 0b1010

; Define the program entry point and text segment
.text
.global _start

_start:

; Exit system call number for x86-64
mov %rax, $60 ; sys_exit
xor %rdi, %rdi ; exit status 0 (rdi = 0)

; Perform the system call
syscall
