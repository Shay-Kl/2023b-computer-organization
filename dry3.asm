.text
.global _start
.global .L1

_start:

  xor %rax, %rax
  mov $1, %bx
  mov $55, %cx

.L1:
  mov %bx, %r9w
  imul %bx, %r9w
  imul %bx, %r9w
  add %r9d, %eax
  inc %bx
  dec %cx
  test %cx, %cx
  jne .L1
END:
