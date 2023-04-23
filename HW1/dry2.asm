.text
.global _start

_start:
  mov $0xFFFEFFFF, %eax
  mov $0x1, %ebx
  shl $16, %ebx
  not %ebx
END:
