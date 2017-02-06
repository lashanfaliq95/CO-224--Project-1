.text

rightRotate:
@r0,r1 has the 2 input registers

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



.global main
   main: 
    sub sp,sp,#4
    str lr,[sp,#0]

    sub sp,sp,#8
    
    ldr r0,=formatk
    bl  printf
     
    ldr r0, =formatd
    mov r1,sp
    bl  scanf         @getting a

    ldr r4,[sp,#0]
    ldr r5,[sp,#4]

    ldr r0, =formatd
    mov r1,sp
    bl  scanf       @getting b
   
    ldr r6,[sp,#0]
    ldr r7,[sp,#4]
  
    ldr r0,=formatp
    bl  printf

    ldr r0, =formatd
    mov r1,sp
    bl  scanf        @getting x


    ldr r8,[sp,#0]       
    ldr r9,[sp,#4]
  

    ldr r0, =formatd
    mov r1,sp
    bl  scanf        @getting y

    ldr r10,[sp,#0]
    ldr r11,[sp,#4]

    add sp,sp,#8
    
    @key 1 r5 r4 a
    @key 2 r7 r6 b
    @pt 1 r9 r8 x
    @pt 2 r11 r10 y


    @doing the round function ones
    @for x,y and b

    mov r0,r9
    mov r1,r8     @x 
    
    
    bl rightRotate
    
    mov r9,r0    @rightRotate x
    mov r8,r1

    
   
    adds  r8,r8,r10
    adc  r9,r9,r11      @x+=y;


    eor r9,r7,r9
    eor r8,r6,r8 @x^=k;

    mov r0,r11
    mov r1,r10   @y
    
   
    bl leftRotate

    mov r11,r0   @leftRotate y
    mov r10,r1    
    
    eor r11,r11,r9
    eor r10,r10,r8  @y^=x;

    @end of first round call

    mov r12,#0 @i=o

loop:            @while i<31
    cmp r12,#31 
    bge exit

   @round for a,b and i

    mov r0,r5
    mov r1,r4    @a
  
    bl rightRotate
    
    mov r5,r0    @rightRotate a
    mov r4,r1

    adds  r4,r6,r4
    adc   r5,r7,r5        @a+=b;
    
  
    eor r4,r4,r12 @a^=i;

    mov r0,r7
    mov r1,r6   @b
   
    bl leftRotate

    mov r7,r0   @leftRotate b
    mov r6,r1    

    eor r7,r5,r7
    eor r6,r4,r6  @b^=a;
    @ end of round for a,b and i
    @for x,y and b

    mov r0,r9
    mov r1,r8     @x 
    
    
    bl rightRotate
    
    mov r9,r0    @rightRotate x
    mov r8,r1

    
   
    adds  r8,r8,r10
    adc  r9,r9,r11      @x+=y;


    eor r9,r7,r9
    eor r8,r6,r8 @x^=k;

    mov r0,r11
    mov r1,r10   @y
    
   
    bl leftRotate

    mov r11,r0   @leftRotate y
    mov r10,r1    
    
    eor r11,r11,r9
    eor r10,r10,r8  @y^=x;

    @end of round call
    add r12,r12,#1   @i++
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

    
    ldr lr,[sp,#0]

add sp,sp,#4
mov pc,lr

.data 
formatk: .asciz "Enter the key: \n"
formatd: .asciz"%llx"
formatp: .asciz"Enter the plain text: \n"
formatc: .asciz "Cipher text is: \n%08x%08x "
formatx: .asciz "%08x%08x\n"

