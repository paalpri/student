#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

struct datetime{
    int dato[3];
    int tid[3];
};


void init_datetime(struct datetime* dt, int inDato[3], int inTid[3]){
    size_t s_int = sizeof(int);
    memcpy(dt->dato, inDato,s_int*3);
    memcpy(dt->tid, inTid,sizeof(int)*3);
}


void datetime_set_date(struct datetime* dt, int inDato[3]){
    for(int i = 0; i < 3 ; i ++){
        dt-> dato[i] = inDato[i];
    }
}

void datetime_set_time(struct datetime* dt, int inTime[3]){
    for(int i = 0; i < 3 ; i ++){
        dt-> tid[i] = inTime[i];
    }
}

void datetime_diff(struct datetime* dt_from,struct datetime* dt_til,struct datetime* dt_diff){
    for(int i = 0; i < 3 ; i ++){
        dt_diff->dato[0] = dt_til->dato[0] - dt_from->dato[0];
        dt_diff->dato[1] = dt_til->dato[1] - dt_from->dato[1];
        dt_diff->dato[2] = dt_til->dato[2] - dt_from->dato[2];
        dt_diff->tid[0] = dt_til->tid[0] - dt_from->tid[0];
        dt_diff->tid[1] = dt_til->tid[1] - dt_from->tid[1];
        dt_diff->tid[2] = dt_til->tid[2] - dt_from->tid[2];
    }
}

int main(void){
    printf("%lu\n",sizeof(size_t));

    struct datetime * test = malloc(sizeof(struct datetime));
    struct datetime * from = malloc(sizeof(struct datetime));
    struct datetime * til = malloc(sizeof(struct datetime));
    struct datetime * diff = malloc(sizeof(struct datetime));

    int dato[] = {05,03,2011};
    int tid[] = {11,37,37};
    init_datetime(test,dato,tid);
    printf("Datoen er: %d, %d, %d\n", dato[0],dato[1],dato[2]);
    printf("Datoen i structen er: %d, %d, %d\n", test->dato[0],test->dato[1],test->dato[2]);
    printf("tiden er: (sekund,minutt,timer) %d, %d, %d\n", tid[0],tid[1],tid[2]);
    printf("tiden i structen er: (dager,maaned,aar) %d, %d, %d\n\n", test->tid[0],test->tid[1],test->tid[2]);
    int forskjell = test->dato[0] - test->dato[1];
    printf("Forskjellen er: %i\n",forskjell);
    int fromdato[] = {1,1,2015};
    int fromtid[] = {00,45,13};
    int tilDato[] = {5,5,2010};
    int tiltid[] = {10,55,23};
    init_datetime(from,fromdato,fromtid);
    init_datetime(til,tilDato,tiltid);
    datetime_diff(from,til,diff);

    printf("tiden i diff structen er: (sekund,minutt,timer) %d, %d, %d\n", diff->tid[0],diff->tid[1],diff->tid[2]);
    printf("Datoen i diff structen er: %d, %d, %d\n", diff->dato[0],diff->dato[1],diff->dato[2]);

    datetime_set_time(test,fromtid);
    datetime_set_date(test,fromdato);
    printf("Datoen i structen er naa: %d, %d, %d\n", test->dato[0],test->dato[1],test->dato[2]);
    printf("tiden i structen er naa: (sekund,minutt,timer) %d, %d, %d\n\n", test->tid[0],test->tid[1],test->tid[2]);

    free(test);
    free(diff);
    free(from);
    free(til);
    return 0;
}
