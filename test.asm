.data
arr: .short 6, 0xEA, 0x22, 0x4B1D, 0b1010


.text
.global main
.global _start
main:
_start:
    xor %rcx, %rcx
	ret
