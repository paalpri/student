#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <string.h>
#include <sys/ipc.h>
#include <sys/shm.h>

int main(int argc, char *argv[]){


    if(argc != 3){
        fprintf(stderr, "usage: %s <filename>, <Message> \n", argv[0]);
        return 0;
    }


    int fileFlags = O_WRONLY | O_CREAT | O_TRUNC;
    int mmapFlags = MAP_SHARED | MAP_ANONYMOUS;
    mode_t mode = S_IRUSR | S_IWUSR | S_IRWXU;
    int fd = open(argv[1],fileFlags,mode);

    // ------>>>>  shmget stuff  <<<<<------
    key_t key = 42;
    long page_size = sysconf(_SC_PAGESIZE);
    printf("Page size: %ld\n",page_size);
    /*
     * 444 = read only
     * 666 = read/write
     */
    int id = shmget(key,512,IPC_CREAT  | 0666);
    //sjekker om shmget failet og returnerte -1
    if(id == -1 ){
        perror("shmget()");
        exit(EXIT_FAILURE);
    }

    char *mem3 = shmat(id,NULL,0);
    if(mem3 == (void *)-1){
        perror("shmat()");
        exit(EXIT_FAILURE);
    }
    printf("SUCCESS!!:: %p\n", mem3);
    /*
     *send messages, protocol:
     *M = message
     * E = end ( no more messages)
     */

    char buf1[256];
    //samme som en while(true) løkke domme evig lække..
    printf("Message please: ");
    fgets(buf1,sizeof(buf1),stdin);
    strcpy(mem3,"M");
    strcat(mem3,buf1);
    printf("Mem3: %s\n",mem3);


    strcpy(mem3,"E");

    shmdt(mem3);
//gjør en control operasjon med id, IPC_RMID forteller at det er en remove operasjon
    shmctl(id, IPC_RMID, NULL);

//     Ferdig med shmget stuff, starter annet



// ------>>>>>   mmap stuff  <<<<<<--------------
    char *mem2 = malloc(512);
//lager et delt minneområde med mmap
    char *mem = mmap(NULL,512, PROT_READ | PROT_WRITE, mmapFlags, -1,0);
//sjekker om mmap failed,
    if (mem == MAP_FAILED){
        perror("mmap()");
        exit(EXIT_FAILURE);
    }
    printf("WoopWoop mmag addresse: %p\n",mem);
//sjekker om opning av filen failet
    if(fd == -1){
        perror("open()");
        exit(EXIT_FAILURE);
    }


    printf("Yoopss: %p\n",mem);
//lager en fork() og sjekker om det funket, failet det så returnerer den -1 til pid
    pid_t pid = fork();
    if(pid == -1){
        perror("fork()");
        exit(EXIT_FAILURE);
    }


    char *buf;
//dette skal barnet gjøre, pid == 0, ikke free() stuff i child processen
    if(pid == 0){
        printf("Message: %s\n", mem);
        sleep(2);
        buf = "im a child yoo!";
        printf("Message: %s\n",mem);
        mem2 = "well that dident work....";
        return 42;
    }else{//dette skal foreldreprosessen gjøre
        sleep(1);
        strcpy(mem,argv[2]);
        //sprintf(mem2 + strlen(argv[2]),"test");
        //mem[strlen(argv[2])+ strlen("test")] = 'a';
        int status;
        wait(&status);
        printf("Child terminated with status %d \n",WEXITSTATUS(status));
        printf("Parent message: %s\n",mem2);
    }



/*
 * skrive til fil stuff
 * får seg fault atm, usikker hvorfor
 *
 *
 ssize_t ret;
 size_t sum = 0;
 do{
 ret = write(fd,buf, strlen(buf));
 sum += ret;

 if(ret == -1){
 perror("write()");
 close(fd);
 exit(EXIT_FAILURE);
 }
 }while ( sum != strlen(buf));
 *
 *
 *
 */


// printf("wrote %zd bytes !\n", sum);
    close(fd);

    munmap(mem,512);
    free(mem2);

    return 0;



}
