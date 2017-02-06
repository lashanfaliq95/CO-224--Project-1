#include <stdio.h>
typedef unsigned long long int ulli;

/*#define ROR(x, r) ((x >> r) | (x << (64 - r)))
#define ROL(x, r) ((x << r) | (x >> (64 - r)))
#define R(x, y, k) (x = ROR(x, 8), x += y, x ^= k, y = ROL(y, 3), y ^= x)
#define ROUNDS 32*/
#define R 32


void leftShift(ulli *x,int r){
  *x=((*x << r) | (*x >> (64 - r)));
  }
  
void rightShift(ulli *x,int r){
  *x=((*x >> r) | (*x << (64 - r)));
  
  }

void Round(ulli* x,ulli* y,ulli* k){
  rightShift(x, 8);
  *x+= *y;
  *x ^= *k; 
  leftShift(y, 3);
  *y ^= *x;
  } 
  
void encrypt(ulli* x, ulli* y, ulli* a, ulli* b)
{

   Round(x, y, b);

   ulli i=0;

   for ( i = 0; i <32 - 1; i++) {
      Round(a, b, &i);
      Round(x, y, b);
   }

}
  

int main(){

ulli b,a,y,x;

 
      scanf("%llx %llx",&b,&a);
      scanf("%llx %llx",&y,&x);
    
      
      encrypt(&y,&x,&b,&a);

    ulli ct1 = y;
    ulli ct2 = x;
    
    printf("%llx %llx\n",ct1,ct2);
  
  return 0;}