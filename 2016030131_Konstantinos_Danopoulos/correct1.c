#include "pilib.h"


#include "stdbool.h"

/* program in c */ 

#define temp 14
#define temp_3 324
#define M 13.743000
#define P -3.642000
int limit, num, counter;
float numberr, test, counter_5 = 13.400000;
bool prime(int n){

int i;
bool result, isPrime;
if(n < 0)
result = prime(-n);
else if(n < 2)
result = false;
else if(n == 2)
result = true;
else if(n % 2 == 0)
result = false;
else{

i = 3;
isPrime = true;
while(isPrime && (i < n / 2)){

isPrime = n % i != 0;
i = i + 2;
}
result = isPrime;
}
return result;
}

int main() {

limit = readInt();
counter = 0;
num = 2;
while(num <= limit){

if(prime(num)){

counter = counter + 1;
writeInt(num);
writeString(" ");
}
num = num + 1;
}
writeString("\n");
writeInt(counter);
} 
