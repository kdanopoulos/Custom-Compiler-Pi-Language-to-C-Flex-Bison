#include "pilib.h"


#include "stdbool.h"

/* program in c */ 

int A[5], B[5];
int printTriangle( ){

int sthles, i, n, sum;
sum = 0;
writeString("Enter the number of rows of Floyd's triangle to print:\n");
sthles = readInt();
if(sthles > 0){

i = 1;
while(i <= sthles){

n = 1;
while(n <= i){

writeInt(n);
writeString(" ");
sum = sum + 1;
n = n + 1;
}
writeString("\n");
i = i + 1;
}
return sum;
}
writeString("Invalid Answer");
return sum;
}

int main() {

int i, sum, n;
int choice = 0, v, p;
while(choice != 3){

writeString(" Menu \n \n");
writeString("===========================================\n");
writeString("1. Print triangle......................................\n");
writeString("2. Even or Odd.........................................\n");
writeString("3. Exit................................................\n");
writeString("Please enter your choice (1-4):\n ");
choice = readInt();
if(choice == 1){

sum = printTriangle( );
writeString("The returned number is ");
writeInt(sum);
writeString("\n");
}else if(choice == 2){

writeString("Give the value:\n");
v = readInt();
if(v != 0){

while(v > 1){

v = v - 2;
}
if(v == 0)
p = 1;
else{

p = 0;
}

}else{

p = 3;
}

if(p == 1)
writeString("The number you gave is even\n");
else if(p == 0)
writeString("The number you gave is odd\n");
else{

writeString("The number you gave is zero\n");
}
}else if(choice == 3){

writeString("Exit....");
}else{

writeString("Uknown entry. Please try again");
}
}
} 
