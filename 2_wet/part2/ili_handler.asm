.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
  pushq %rax
  pushq %rdi
  movq 16(%rsp), %rdi
  pushq %rbx
  pushq %rcx
  pushq %rdx	
  pushq %r8
  pushq %r9
  pushq %r10
  pushq %r11
  pushq %r12
  pushq %r13
  pushq %r14
  pushq %r15
  pushq %rsi
  pushq %rbp
  pushq %rsp
  mov (%rdi), %rcx
  cmpb $0x0f, %cl
  je two_bytes
  mov %rcx, %rdi
  call what_to_do
  jmp check_return
  
  
two_bytes:
  mov 1(%rdi), %rdi
  call what_to_do
  
check_return:
  cmp $0, %rax
  jne unique_handler
  
normal_handler:
  popq %rsp
  popq %rbp
  popq %rsi
  popq %r15
  popq %r14
  popq %r13
  popq %r12
  popq %r11
  popq %r10
  popq %r9
  popq %r8
  popq %rdx
  popq %rcx
  popq %rbx
  popq %rdi
  popq %rax
  jmp * old_ili_handler





unique_handler:
  popq %rsp
  popq %rbp
  popq %rsi
  popq %r15
  popq %r14
  popq %r13
  popq %r12
  popq %r11
  popq %r10
  popq %r9
  popq %r8
  popq %rdx
  popq %rcx
  popq %rbx
  popq %rdi
  movq %rax, %rdi
  popq %rax
  
  addq $2, (%rsp)

  
  iretq
