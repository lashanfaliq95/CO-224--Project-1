.text

.global main

rightRotate:
	@ r0,r1 has the 2 input registers

	sub sp,sp,#12
	str lr,[sp,#0]
	str r4,[sp,#4]
	str r5,[sp,#8]

	mov r2,r0,lsr#8
	mov r3,r1,lsr#8

	mov r4,r0,lsl#24
	mov r5,r1,lsl#24

	orr r0,r2,r5
	orr r1,r3,r4

	ldr lr,[sp,#0]
	ldr r4,[sp,#4]
	ldr r5,[sp,#8]

	add sp,sp,#12
	mov pc,lr

	
main:
	@ preserving return address
	sub sp, sp, #4
	str lr, [sp]
	
	@to read 2 64-bit numbers to stack
	sub sp, sp, #16

	@prompt user to enter the key
	ldr r0, =format1
	bl printf

	@reading the key
	ldr r0, =format2
	add r1, sp, #8		@a = key[1]
	add r2, sp, #0		@b = key[0]
	bl scanf

	
	@------------------------------------
	ldr r0, [sp,#12]
	ldr r1, [sp,#8]
	bl rightRotate

	mov r2, r1
	mov r1, r0
	ldr r0, =format4
	bl printf
	@--------------------------------------


	@releasing stack used for 2 64-bit numbers
	add sp, sp, #16

	@popping return address and return
	ldr lr, [sp]
	add sp, sp, #4
	mov pc, lr

.data
	format1: .asciz "Enter the key:\n"
	format2: .asciz "%llx %llx"
	format4: .asciz "Rotated text is:\n%x%x \n"

