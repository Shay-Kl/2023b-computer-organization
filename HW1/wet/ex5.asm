.global _start
.section .data
root:
.quad A
A:
.quad 5
.quad B
.quad C
B:
.quad 1
.quad 0
.quad D
C:
.quad 10
.quad 0
.quad 0
D:
.quad 3
.quad 0
.quad 0

new_node: .quad 9, 0, 0
.section .text
_start:
	movq new_node, %r8 #r8 = new_node.val
	leaq root, %rax #rax = &root, 
	#rax will be used as pointer to the parent node's pointer to the current node
loop_HW1:
	movq (%rax), %rcx #rcx = pointer to current node's value
	testq %rcx, %rcx #if(!curnode)
	jz insert_HW1 #then insert new node into its place
	movq (%rcx), %r9 # r9 = cur.val
	cmp %r8, %r9 #compare cur.val with new_node.val
	je end_HW1 #if the new node already exists do nothing
	ja goLeft_HW1 #if cur.val is greater than new_node.node go left
goRight_HW1: #cur.val is lesser than new_node.val so we go right
	lea 16(%rcx), %rax #rax is the pointer to the right node
	jmp loop_HW1
goLeft_HW1: 
	lea 8(%rcx), %rax #rax is the pointer to the left node
	jmp loop_HW1
insert_HW1:
	lea new_node(%rip), %rcx #rcx = &new_node
	movq %rcx, (%rax) #sets the parent's pointer to the next node to new node
end_HW1:
