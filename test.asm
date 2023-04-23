.global _start
.data
arr: .short 6, 0xEA, 0x22, 0x4B1D, 0b1010


.text
_start:
    xor %rcx, %rcx
	ret
