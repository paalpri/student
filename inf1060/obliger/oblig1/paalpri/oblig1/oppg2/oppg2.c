#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

int stringsum(char* s);
int distance_between(char* s, char c);
char* string_between(char* s,char c);


int stringsum(char* s){

    int totsum = 0;
    for(int i = 0;s[i];i++){
        char tegn = toupper(s[i]);
        if(tegn < 65 || tegn > 90){
            return -1;
        }
        totsum += tegn - 'A' +1;
    }
    return totsum;
}
int first = 0;
int last = 0;
int distance_between(char* s, char c){


    int sjekk = 0;
    int teller = 0;
    for(int i = 0; s[i];i++){
        if(sjekk == 1){
            teller ++;
        }
        if(s[i] == c){
            if(teller > 0){
                last = i;
                return teller;
            }
            first = i;
            sjekk = 1;
        }
    }

    return -1;

}


char* string_between(char* s,char c){

    if(distance_between(s,c) == -1){
        return NULL;
    }

    char *nyTekst = (char*) malloc (distance_between(s,c));
    for(int i = first+1; i < last ;i++){
        char tegn[2];
        tegn[1] = '\0';
        tegn[0] = s[i];
        strcat(nyTekst,tegn);
    }
    return nyTekst;
}

char** split(char* s){
    char* t =(char*) malloc(strlen(s) +1);
    strcpy(t,s);
    int teller = 0;
    for(int i = 0; t[i]; i++){
        if(t[i] == ' '){
            teller ++;
        }
    }
    char** setning = (char**)(malloc(teller + 2));
    char *token;
    token = strtok(t," ");
    int i = 0;
    while(token){
        setning[i] = token;
        token = strtok(NULL," ");
        i++;
    }
    setning[i] = NULL;
    return setning;
}

void stringsum2(char* s,int* res){
    *res = stringsum(s);
}
