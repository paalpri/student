#include <stdio.h>

int main(int ant,char* args[]){
    if(ant < 2){
        printf("Du maa nesten gi meg et argument\n");
    }
    else if(ant >2){
        printf("Bare 1 argument din stol\n");
    }
    else{
        printf("Argumentet ditt er: %s\n", args[1]);
    }
    
}
