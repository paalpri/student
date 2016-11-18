#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
//Make run bruker 100router.dat filen. maa kjore programmet manuelt for aa bruke andre filer.

#define AKTIV 1;
#define TRODLOS 2;
#define GHZ5 4;
#define IBRUK 8;
char *filNavn = "ingen fil enda";
struct ruter* routerMap[256] = { NULL };
int max = 256;
int antall = 0;



struct ruter{
    unsigned char ruter_ID;
    unsigned char flagg;
    unsigned char leng_prod;
    char prod[253];
};



void init_ruter(struct ruter *denne,unsigned char id, unsigned char f,unsigned char lengde, char navn[253]){
    denne = malloc(sizeof (struct ruter));
    denne->ruter_ID = id;
    denne->flagg = f;
    denne->leng_prod = lengde;
    strcpy(denne->prod,navn);
    routerMap[id] = denne;
}


void print_binary(int num)
{
    int pos = (sizeof(char) * 8) - 1;
    printf("%10d : ", num);

    for (int i = 0; i < (char)(sizeof(char) * 8); i++) {
        char c = num & (1 << pos) ? '1' : '0';
        putchar(c);
        if (!((i + 1) % 8))
            putchar(' ');
        pos--;
    }
    putchar('\n');
}

void printMap(){
    for(int i = 0; i < max; i++){
        if(routerMap[i] != NULL){
            printf("ID: %i\n",routerMap[i]->ruter_ID);
            printf("flagg:");
            print_binary(routerMap[i]->flagg);
            printf("lengde: %i\n", routerMap[i]->leng_prod);
            printf("navn: %s\n", routerMap[i]->prod);
            printf("\n");
        }
    }
}


void lesFil(FILE *file){
    fread(&antall,sizeof(int), 1,file);
    if(antall == 0){
        printf("ingen rutere i filen\n");
        return;
    }
    unsigned char skip;
    fread(&skip,sizeof(unsigned char),1,file);
    for(int i = 0; i < antall;i ++){
        struct ruter *denne = malloc(sizeof (struct ruter));
        fread(&denne->ruter_ID,sizeof(unsigned char),1,file);
        fread(&denne->flagg,sizeof(unsigned char),1,file);
        fread(&denne->leng_prod,sizeof(unsigned char),1,file);
        fgets(denne->prod,253,file);
        routerMap[denne->ruter_ID] = denne;
    }
    fclose(file);
}

void skrivFil(){
    char linjeSkift = '\n';
    FILE *file = fopen(filNavn,"wb");  // w for write, b for binary
    // linje som  brukes til testing--    FILE *file = fopen("test.dat","wb");  // w for write, b for binary
    fwrite(&antall,sizeof(int),1,file);
    fwrite(&linjeSkift,sizeof(char),1,file);
    for(int i = 0; i < 256; i ++){
        if(routerMap[i] != NULL){
            struct ruter *denne = routerMap[i];
            fwrite(&denne->ruter_ID,sizeof(unsigned char),1,file);
            fwrite(&denne->flagg,sizeof(unsigned char),1,file);
            fwrite(&denne->leng_prod,sizeof(unsigned char),1,file);
            fwrite(denne->prod,denne->leng_prod,1,file);
            routerMap[denne->ruter_ID] = denne;
        }
    }
    fclose(file);
}


void printinfo(int nr){
    struct ruter *denne = routerMap[nr];
    printf("ID: %i\n",denne->ruter_ID);
    printf("flagg:");
    print_binary(denne->flagg);
    printf("lengde: %i\n", denne->leng_prod);
    printf("navn: %s\n", denne->prod);
    printf("\n");
}

//endrer flagg med tidligere defines, bruker skriver y, alt annet blir nei.
void changeFlagg(int id){
    unsigned char f = routerMap[id]->flagg & 0xf0;
    if((f & 0xf0) == 0xf0){
        printf("Kan ikke endre ruterens flagg, maks antall endringer naad\n");
        return;
    }
    print_binary(f);
    char svar;
    printinfo(id);
    printf("Legg inn ruterens flagg: ");
    printf("Er ruteren aktiv ? (y/n): ");
    scanf(" %c", &svar);
    if(svar == 'y'){
        f |= AKTIV;
    }
    printf("Er ruteren trodlos ? (y/n): ");
    scanf(" %c", &svar);
    if(svar == 'y'){
        f |= TRODLOS;
    }
    printf("Strotter ruteren 5GHz? (y/n): ");
    scanf(" %c", &svar);
    if(svar == 'y'){
        f |= GHZ5;
    }
    printf("Er ruteren i bruk?: (y/n): ");
    scanf(" %c", &svar);
    if(svar == 'y'){
        f |= IBRUK;
    }
    routerMap[id]-> flagg = f + 16;
}
//endrer ruterens navn, bruker strcpy for why not, lagrer den nye lengden med strlen +1 (you know why);
void changeProd(int id){
    printf("Hva er den nye produsenten? ");
    char nyttNavn[253];
    scanf("%s",nyttNavn);
    strcpy(routerMap[id]->prod,nyttNavn);
    routerMap[id]->leng_prod = (unsigned char) strlen(routerMap[id]->prod) +1;
}

//sletter med free, legger den ledige plassen til NULL siden jeg sjekker for dette i insert;
void delete(int id){
    struct ruter *deleteRouter = routerMap[id];
    routerMap[id] = NULL;
    free(deleteRouter);
    antall --;
}
//sett inn metode, bruker endre flagg metoden, strcpy til char*, finner id fra første ledige id i arrayen
void insert(){
    struct ruter *denne = malloc(sizeof (struct ruter));
    int id;
    printf("Skriv inn ruterens id: ");
    scanf("%d",&id);
    getchar();
    if(id < 0 || id >= max || routerMap[id] != NULL){
        printf("Det finnes allerede en router med denne id, eller iden er for liten/stor\n");
        return;
    }
    char produsent[253];
    printf("Produsent og modell?: \n");
    fgets(produsent,253,stdin);
    strcpy(denne->prod,produsent);
    denne->ruter_ID = (unsigned char)id;
    denne-> flagg = 0;
    //kefor funke dette ??
    denne->leng_prod = (unsigned char) strlen(produsent);
    routerMap[id] = denne;
    changeFlagg(id);
    routerMap[id]->flagg &= 239 ;
    antall ++;
}


void command(){
    int svar;
    int id;
    char linje[256];
    while(svar != 6){
        svar = 9;
        printf("1: print info om ruter\n");
        printf("2: endre flagg\n");
        printf("3: endre produsent\n");
        printf("4: legge inn ny ruter\n");
        printf("5: slette ruter\n");
        printf("6: avslutt\n");
        printf("Command: ");
        //leser inn hele linjen for å forsikre meg om at bare 1 karakteren i det bruker leses inn skriver
        //visst jeg ikke gjør dette og bruker skriver feil så skrives menyen ut flere ganger.
        scanf("%s",linje);
        svar =(int) linje[0] - '0';
        getchar();
        if(svar == 1 || svar == 2 || svar == 3 || svar == 5){
            printf("Hvilken id? ");
            scanf("%d",&id);
            getchar();
            if(id < 0 || id >= max || routerMap[id] == NULL){
                printf("Det finnes ingen rutere med denne id'en\n");
            }
            else if(svar == 1){
                printinfo(id);
            }
            else if(svar == 2){
                changeFlagg(id);

            }
            else if(svar == 3){
                changeProd(id);
            }
            else if(svar == 5){
                delete(id);
            }
        }
        else if(svar == 4){
            insert();
        }
        else if(svar == 6){
            printf("Skriver all data til filen: %s\n", filNavn);
            skrivFil();
        }
        else{
            printf("Skriv et tall mellom 1-6 plz\n");
        }
    }
}



int main(int argc, char* argv[]){
    if(argc != 2){
        fprintf(stderr, "usage: %s <filename> \n", argv[0]);
        return 0;
    }

    FILE *file = fopen(argv[1], "rb");
    filNavn = argv[1];
    if (file == NULL) {
        fprintf(stderr, "Couldn't open file: %s\n", argv[1]);
        return -1;
    }
    lesFil(file);
    command();
    for(int i = 0; i < max; i ++){
        free(routerMap[i]);
    }
    return 0;

}
