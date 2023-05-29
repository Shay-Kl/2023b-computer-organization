.global	keyMixing, byteSubstitution, shiftRows, cipher

.section	.data
sbox:	.byte	99,124,119,123,-14,107,111,-59,48,1,103,43,-2,-41,-85,118
		.byte	-54,-126,-55,125,-6,89,71,-16,-83,-44,-94,-81,-100,-92,114,-64
		.byte	-73,-3,-109,38,54,63,-9,-52,52,-91,-27,-15,113,-40,49,21
		.byte	4,-57,35,-61,24,-106,5,-102,7,18,-128,-30,-21,39,-78,117
		.byte	9,-125,44,26,27,110,90,-96,82,59,-42,-77,41,-29,47,-124
		.byte	83,-47,0,-19,32,-4,-79,91,106,-53,-66,57,74,76,88,-49
		.byte	-48,-17,-86,-5,67,77,51,-123,69,-7,2,127,80,60,-97,-88
		.byte	81,-93,64,-113,-110,-99,56,-11,-68,-74,-38,33,16,-1,-13,-46
		.byte	-51,12,19,-20,95,-105,68,23,-60,-89,126,61,100,93,25,115
		.byte	96,-127,79,-36,34,42,-112,-120,70,-18,-72,20,-34,94,11,-37
		.byte	-32,50,58,10,73,6,36,92,-62,-45,-84,98,-111,-107,-28,121
		.byte	-25,-56,55,109,-115,-43,78,-87,108,86,-12,-22,101,122,-82,8
		.byte	-70,120,37,46,28,-90,-76,-58,-24,-35,116,31,75,-67,-117,-118
		.byte	112,62,-75,102,72,3,-10,14,97,53,87,-71,-122,-63,29,-98
		.byte	-31,-8,-104,17,105,-39,-114,-108,-101,30,-121,-23,-50,85,40,-33
		.byte	-116,-95,-119,13,-65,-26,66,104,65,-103,45,15,-80,84,-69,22

.section	.text
keyMixing:
    movq (%rdi), %r8
    movq (%rsi), %r9
    xorq %r8, %r9
    movq %r9, (%rdi)
    movq 8(%rdi), %r8
    movq 8(%rsi), %r9
    xorq %r8, %r9
    movq %r9, 8(%rdi)
	ret


byteSubstitution:
    xor %r9, %r9 #index
    xor %r8, %r8 #temp
    lea sbox(%rip), %r10 # r10 = position independent pointer to sbox
HW2_LOOP:
    movb (%rdi, %r9), %r8b #temp = input[index]
    movb (%r10, %r8), %r8b #temp = sbox[input[index]]
    movb %r8b, (%rdi, %r9) #input[index] = temp = sbox[input[index]]
    inc %r9
    cmpb $128, %r9b
    jne HW2_LOOP
	ret


shiftRows:
#shift second row by 1
    movb 4(%rdi), %r8b
    movb 5(%rdi), %r9b
    movb 6(%rdi), %r10b
    movb 7(%rdi), %r11b
    
    movb %r8b, 7(%rdi)
    movb %r9b, 4(%rdi)
    movb %r10b, 5(%rdi)
    movb %r11b, 6(%rdi)
    
#shift third row by 2
    movb 8(%rdi), %r8b
    movb 9(%rdi), %r9b
    movb 10(%rdi), %r10b
    movb 11(%rdi), %r11b
    
    movb %r8b, 10(%rdi)
    movb %r9b, 11(%rdi)
    movb %r10b, 8(%rdi)
    movb %r11b, 9(%rdi)
    
#shift fourth row by 3
    movb 12(%rdi), %r8b
    movb 13(%rdi), %r9b
    movb 14(%rdi), %r10b
    movb 15(%rdi), %r11b
    
    movb %r8b, 13(%rdi)
    movb %r9b, 14(%rdi)
    movb %r10b, 15(%rdi)
    movb %r11b, 12(%rdi)
	ret


cipher:
    mov %rdi, %r15 #input
    mov %rsi, %r12 #key
    mov %rdx, %r13 #length
HW2_MultiLoop:
    mov %r15, %rdi
    mov %r12, %rsi
    mov $9, %r14
    call keyMixing
    
HW2_CipherLoop:
    mov %r15, %rdi
    call byteSubstitution
    mov %r15, %rdi
    call shiftRows
    mov %r15, %rdi
    call mixColumns
    mov %r12, %rsi
    mov %r15, %rdi
    call keyMixing
    dec %r14
    test %r14, %r14
    jne HW2_CipherLoop
    
    mov %r15, %rdi
    call byteSubstitution
    mov %r15, %rdi
    call shiftRows
    mov %r12, %rsi
    mov %r15, %rdi
    call keyMixing
    
    dec %r13
    lea 16(%r15), %r15
    test %r13, %r13
    jnz HW2_MultiLoop
    
	ret
