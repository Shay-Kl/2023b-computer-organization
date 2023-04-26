#rax - pointer to pointer to current_node
#rcx - pointer to current_node
#r8 - new_node's value
#r9 - current_node's value

.global _start
.section .text
_start:
	movq new_node, %r8 #r8 = new_node.val
	movq $root, %rax #rax = &root, 
loop_HW1:
	movq (%rax), %rcx #rcx = *(rax)
	testq %rcx, %rcx
	jz insert_HW1 #if(current_node=null), insert new_node in its place
	movq (%rcx), %r9 # r9 = current_node.val
	cmpq %r8, %r9
	je end_HW1 #if(new_node.val==current_node.val), return
	ja goLeft_HW1 #else if(current.node.val>new_node.val), go left
goRight_HW1: #else, go right
	leaq 16(%rcx), %rax #rax=&(current_node.right)
	jmp loop_HW1
goLeft_HW1: 
	leaq 8(%rcx), %rax #rax=&(current_node.left)
	jmp loop_HW1
insert_HW1:
	movq $new_node, (%rax) #current_node=new_node
end_HW1:
