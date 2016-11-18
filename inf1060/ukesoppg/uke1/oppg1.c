#include <stdio.h>

int main(int antall, char *msg[]){
    printf("program name is %s\n",msg[0]);
    printf("number of arguments are %d \n", antall-1);
    if(antall >= 2){
        printf("argument  er: %s \n",msg[1]);
    }else{
        printf("Du maa nesten sende meg et argument as!\n");
    }
}
