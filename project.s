.text

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


leftRotate:
@ r0,r1 has the 2 input registers

sub sp,sp,#12
str lr,[sp,#0]
str r4,[sp,#4]
str r5,[sp,#8]

mov r2,r0,lsl#3
mov r3,r1,lsl#3

mov r4,r0,lsr#29
mov r5,r1,lsr#29

orr r0,r2,r5
orr r1,r3,r4

ldr lr,[sp,#0]
ldr r4,[sp,#4]
ldr r5,[sp,#8]

add sp,sp,#12
mov pc,lr

addr:
@r0 r1
@r2 r3 as inputs
sub sp,sp,#12
str lr,[sp,#0]
str r4,[sp,#4]
str r5,[sp,#8]

adds r4,r1,r3

adc r0,r0,r2
mov r1,r4
ldr lr,[sp,#0]
ldr r4,[sp,#4]
ldr r5,[sp,#8]
add sp,sp,#12
mov pc,lr


.global main
   main: 
    sub sp,sp,#48
    str lr,[sp,#44]
    str r12,[sp,#40]
    str r11,[sp,#36]
    str r10,[sp,#32]
    str r9,[sp,#28]
    str r8,[sp,#24]
    str r7,[sp,#20]
    str r4,[sp,#16]
    str r5,[sp,#12]
    str r6,[sp,#8]
    
    ldr r0,=formatk
    bl  printf
     
    ldr	r0, =formatd
    mov r1,sp
	bl	scanf	@scanf("%llx",sp)

    ldr r4,[sp,#0]
    ldr r5,[sp,#4]

    ldr	r0, =formatd
    mov r1,sp
	bl	scanf	@scanf("%llx",sp)
   
    ldr r6,[sp,#0]
    ldr r7,[sp,#4]
  
    ldr r0,=formatp
    bl  printf

    ldr	r0, =formatd
    mov r1,sp
	bl	scanf	@scanf("%llx",sp)


    ldr r8,[sp,#0]
    ldr r9,[sp,#4]
  

	ldr	r0, =formatd
    mov r1,sp
	bl	scanf	@scanf("%llx",sp)

	ldr r10,[sp,#0]
	ldr r11,[sp,#4]
    
    @key 1 r5 r4 b
    @key 2 r7 r6 a
    @key 3 r9 r8 y
    @key 4 r11 r10 x


    @doing the round function ones
    @for x,y and b

    mov r0,r11
    mov r1,r10
    
    bl rightRotate
    
    mov r11,r0  @x
    mov r10,r1

    mov r2,r9    @y
    mov r3,r8
   
    bl addr      
    
    mov r11,r0    @x+=y;
    mov r10,r1

    eor r11,r5,r11
    eor r10,r4,r10 @x^=k;

    mov r0,r9
    mov r1,r8   @y

    bl leftRotate

    mov r9,r0
    mov r8,r1    
    
    eor r9,r11,r9
    eor r8,r10,r8  @y^=x;

    @end of first round call

    mov r12,#0 @i=o

loop:            @while i<31
    cmp r12,#31 
    bge exit

    add r12,r12,#1
    
    
    @round for a,b and i

    mov r0,r7
    mov r1,r6
    
    bl rightRotate
    
    mov r7,r0
    mov r6,r1

    mov r0,r7  @a
    mov r1,r6
    
    mov r2,r5    @b
    mov r3,r4
   
    bl addr      
    
    mov r7,r0    @a+=b;
    mov r6,r1

    eor r7,r7,#0
    eor r6,r6,r2 @a^=i;

    mov r0,r5
    mov r1,r4   @b

    bl leftRotate

    mov r5,r0
    mov r4,r1    

    eor r5,r5,r7
    eor r4,r4,r6  @b^=a;

    @end of first round call

    @round for x,y and b

    mov r0,r11
    mov r1,r10
    
    bl rightRotate
    
    mov r11,r0
    mov r10,r1

    mov r0,r11   @x
    mov r1,r10
    
    mov r2,r9    @y
    mov r3,r8
   
    bl addr      
    
    mov r11,r0    @x+=y;
    mov r10,r1

    eor r11,r11,r5
    eor r10,r10,r4 @x^=k;

    mov r0,r9
    mov r1,r8   @y

    bl leftRotate

    mov r9,r0
    mov r8,r1    
    
    eor r9,r9,r11
    eor r8,r8,r10  @y^=x;

    @end of second round call
    
    b loop
 exit:
    
    ldr r0,=formatc
    mov r1,r9
    mov r2,r8
    bl  printf
    
    ldr r0,=formatx
    mov r1,r11
    mov r2,r10
    bl  printf

    ldr r10,[sp,#0]
    ldr r11,[sp,#4]
  
    ldr r4,[sp,#16]
    ldr r5,[sp,#12]
    ldr r6,[sp,#8]
    ldr lr,[sp,#44]
    ldr r12,[sp,#40]
    ldr r11,[sp,#36]
    ldr r10,[sp,#32]
    ldr r9,[sp,#28]
    ldr r8,[sp,#24]
    ldr r7,[sp,#20]

add sp,sp,#48
mov pc,lr

.data 
formatk: .asciz "Enter the key: \n"
formatd: .asciz"%llx"
formatp: .asciz"Enter the plain text: \n"
formatc: .asciz "Cipher text is: \n%08x%08x "
formatx: .asciz "%08x%08x\n"

