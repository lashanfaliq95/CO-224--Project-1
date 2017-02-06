.text
		
@...............rigthShiftRound function...............

rightShiftRound : 
		
		sub sp,sp,#24						@allocate memory for satck
		str lr,[sp,#20]
		str r8,[sp,#16]						@push lr to the stack
		str r7,[sp,#12]						@store register to the stack
		str r6,[sp,#8]
		str r5,[sp,#4]
		str r4,[sp,#0]
		
		lsr r4,r0,r2						@right shift first 32bit from r
		lsr r6,r1,r2						@right shift second 32bit from r
		
		mov r8,#32
		sub r2,r8,r2						@ r = 32-r
		
		lsl r7,r0,r2						@left shift first 32bit from 32-r
		lsl r5,r1,r2						@left shift second 32bit from 32-r
		
		orr r0,r4,r5						@get OR r4 and r5  r0 = r4|r5
		orr r1,r6,r7						@get OR r6 and r7  r1 = r6|r7
		
		ldr r4,[sp,#0]						@pop values from stack
		ldr r5,[sp,#4]
		ldr r6,[sp,#8]
		ldr r7,[sp,#12]
		ldr r8,[sp,#16]
		ldr lr,[sp,#20]
		add sp,sp,#24						@release stack and return
		mov pc,lr
		
@......................................................


@................leftShiftRound function................

leftShiftRound : 
		
		sub sp,sp,#24						@allocate memory for satck
		str lr,[sp,#20]
		str r8,[sp,#16]						@push lr to the stack
		str r7,[sp,#12]						@store register to the stack
		str r6,[sp,#8]
		str r5,[sp,#4]
		str r4,[sp,#0]
		
		lsl r4,r0,r2						@right shift first 32bit from r
		lsl r5,r1,r2						@right shift second 32bit from r
		
		mov r8,#32
		sub r2,r8,r2						@ r = 32-r
		
		lsr r6,r0,r2						@left shift first 32bit from 32-r
		lsr r7,r1,r2						@left shift second 32bit from 32-r
		
		orr r2,r4,r7						@get OR r4 and r5  r0 = r4|r5
		orr r3,r5,r6						@get OR r6 and r7  r1 = r6|r7
		
		ldr r4,[sp,#0]						@pop values from stack
		ldr r5,[sp,#4]
		ldr r6,[sp,#8]
		ldr r7,[sp,#12]
		ldr r8,[sp,#16]
		ldr lr,[sp,#20]
		add sp,sp,#24						@release stack
		mov pc,lr

@......................................................
		
@...................proccess function..................

process:
	sub sp,sp,#8								@allocate memory for stack
	str lr,[sp,#4]								@push lr to the stack
	str r6,[sp,#0]
		
	mov r6,r2									@copy value of r2(y1) to r6 register
										
	mov r2,#8									@put value of 8 to the register r2 
	bl rightShiftRound							@call rightShiftRound function
	
	
	
	mov r2,r6									@ again copy y value to the r2 (y1=r2)
	
	adds r1,r1,r3								@add x1 and y1 & if there is carry bit ,flag register update as 1(x2 = y2+x2)
	adc  r0,r0,r2								@add x2 and y2 with carry bit(if there is) x1 = y1+x1
	
	eor r0,r0,r4								@x1 = x1 XOR k1
	eor r1,r1,r5								@x2 = x2 XOR k2
	
	@mov r6,r2									@again copy y value to the r2 (y1=r2)
	sub sp,sp,#8
	str r0,[sp,#4]
	str r1,[sp,#0]
	
	
	mov r0,r2									@copy value in register r6 to the r0 register
	mov r1,r3									@copy value in register r3 to the r1 register
	mov r2,#3									@copy value #3 to register r2
	bl leftShiftRound							@call leftShiftRound function

	ldr r1,[sp,#0]
	ldr r0,[sp,#4]
	add sp,sp,#8

	eor r2,r0,r2								@y1 = x1 XOR y1
	eor r3,r1,r3								@y2 = x2 XOR y2
	
	ldr r6,[sp,#0]								@pop values from stack
	ldr lr,[sp,#4]
	add sp,sp,#8								@release stack
	mov pc,lr									@then return
@......................................................

@...............encrypt function.......................

encrypt : 

	sub sp,sp,#4					@allocate memory for stack
	str lr,[sp,#0]					@push lr to the stack
	
	sub sp,sp,#8					@allcate memory for stack
	str r5,[sp,#4]					@store values in registers to the stack
	str r4,[sp,#0]
	
	mov r4,r6						@copy key2 part1 to r4 
	mov r5,r7						@copy key2 part2 to r5
	bl process						@call process function
	
	ldr r4,[sp,#0]					@load values in stack to the registers
	ldr r5,[sp,#4]
	add sp,sp,#8					@release stack
	
	mov r8,#0						@i(1)=0   in r8
	mov r9,#0						@i(2)=0   in r9
	
loop:

	cmp r9,#31						@compare i(2) with #31
	bge exit						@if i(2)>=31 then exit
	
	sub sp,sp,#16
	str r3,[sp,#12]					@y2
	str r2,[sp,#8]					@y1
	str r1,[sp,#4]					@x2
	str r0,[sp,#0]					@x1
	
	mov r0,r4						@move a1  ->r0
	mov r1,r5						@move a2  ->r1
	mov r2,r6						@move b1  ->r2
	mov r3,r7						@move b2  ->r3
	mov r4,r8						@move i(1)->r4
	mov r5,r9						@move i(2)->r5
	bl process						@move call process function
	
	mov r4,r0						@restore above values
	mov r5,r1
	mov r6,r2
	mov r7,r3
	
	ldr r0,[sp,#0]					@again load x1,x2,y1,y2 to the registers
	ldr r1,[sp,#4]
	ldr r2,[sp,#8]
	ldr r3,[sp,#12]
	add sp,sp,#16					@release stack
	
	sub sp,sp,#8					@allocate memory for stack (r4 and r5)
	str r5,[sp,#4]					@store value of r5 to stack [sp,#4]
	str r4,[sp,#0]					@store value of r4 to  stack [sp,#0]
	
	mov r4,r6						@move b1->r4
	mov r5,r7						@move b2->r5
	bl process 						@call process function
	
	ldr r4,[sp,#0]					@load values to the registers
	ldr r5,[sp,#4]
	add sp,sp,#8					@release stack
	
	add r9,r9,#1					@i=i+1
	b loop							@then go to loop again

exit:
	
	
	ldr lr,[sp,#0]					@pop values from stack
	add sp,sp,#4					@release stack and return
	mov pc,lr
@.......................................................


@......................main function....................
.global main

	main:
	
		@ push (store) lr to the stack, allocate space for 4 chars (scanf)

		sub sp,sp,#4							@allcate memory for stack
		str lr,[sp,#0]							@push lr to the stack
		
		
		sub sp,sp,#8							@allocate stack for input key
		
		ldr r0 ,= format1						@printf for input key
		bl printf								
		
		ldr r0 ,= format2						@scanf for input key1
		mov r1,sp
		bl scanf								@(%llx)
		ldr r4,[sp,#4]							@copy input key1 32bit from [sp,#4] to r4
		ldr r5,[sp,#0]							@copy another half input key1 32bit from [sp,#0] to r5
		
		ldr r0 ,= format2						@scanf for input key2  
		mov r1,sp
		bl scanf								@(%llx)
		ldr r6,[sp,#4]							@copy input key2 32bit from [sp,#4] to r6
		ldr r7,[sp,#0]							@copy another half input key2 32bit from [sp,#4] to r7
		
		
		ldr r0 ,= format3						@printf for plain text
		bl printf
		
		ldr r0 ,= format2						@scanf for plain text1
		mov r1,sp
		bl scanf 								@(%llx)
		ldr r8,[sp,#4]							@copy input plain text1 32bit from [sp,#4] to r8
		ldr r9,[sp,#0]						 	@copy another half input plain text1 32bit from [sp,#4] to r9
		
		ldr r0 ,= format2						@scanf for input plain tetx2 
		mov r1,sp
		bl scanf								@(%llx)
		ldr r10,[sp,#4]							@copy input plain text2 32bit from [sp,#4] to r10
		ldr r11,[sp,#0]							@copy another half input plain text 32bit from [sp,#4] to r11
		
		add sp,sp,#8							@release stack
		
		mov r0,r8								@move y1 y2 x1 x2 to the registers for encrypt function
		mov r1,r9
		mov r2,r10
		mov r3,r11
		bl encrypt								@call encrypt function
		
		
		mov r4,r0								@ move output of the encrypt function to the new registers
		mov r5,r1
		mov r6,r2
		mov r7,r3
	
		mov r1,r4								@move values in r4 r5 to r1 r2 registers for print
		mov r2,r5
		ldr r0 ,= format4						@printf for output cipher key
		bl printf								@(%08x%08x)
		
		mov r1,r6								@printf for output cipher key
		mov r2,r7
		ldr r0 ,= format5				
		bl printf								@(%08x%08x)
		
		mov r0,#0								@return 0
		ldr lr,[sp,#0]							@stack handling (pop lr from the stack) and return
		add sp,sp,#4
		mov pc,lr
@...........................................................
.data

	format1 : .asciz "Enter the key: \n"		
	format2 : .asciz "%llx"
	format3 : .asciz "Enter the plain text: \n"
	format4 : .asciz "Cipher text is: \n%08x%08x "
	format5 : .asciz "%08x%08x\n"
	 
