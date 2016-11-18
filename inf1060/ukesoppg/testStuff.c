#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <string.h>
#include <errno.h>
#include <signal.h>

int main(){
    int antall = 127;
    char tegn[2] ={ 'G', (unsigned char) antall};
    printf("tekst: %i\n",tegn[1]);

    char tegn1[256] = { 0 };
    tegn1[0] = 'g';
    tegn1[1] = 'g';
    printf("%zu\n",strlen(tegn1));

    
}


/*

void askForJob(int antall){

    char get_job[2] = { 'G', (unsigned char) antall};
    ssize_t ret = send(sock,get_job, strlen(get_job), 0);
    if(ret == -1){
        perror("send()");
        close(sock);
        exit(EXIT_FAILURE);
    }

    while (antall > 0){
        char job_info[6] = { 0 };

        ret = recv(sock, job_info, 2, 0);
        char job[256] = { 0 };
        ret = recv(sock,job,sizeof(job),0);
        printf("jobinfo: %s\n",job_info);
        if(ret == 0){
            printf("Server disconnected! \n");
            break;
        }else if ( ret == -1){
            perror("recv()");
            close(sock);
            exit(EXIT_FAILURE);
        }else{
            char jobtype = job_info[0];
            unsigned char length = job_info[1];
            char *jobString = job;
            jobString += 2;

            int i;
            if(jobtype == 'O'){
                i = 0;
            } else if(jobtype == 'E'){
                i = 1;
            }else if (jobtype == 'Q'){
                //terminer barna mine :/
                int status;
                write(pipefd[0][1],(char *)&length, 1);
                write(pipefd[1][1],(char *)&length, 1);
                wait(&status);
                wait(&status);
                return;
            }
            write(pipefd[i][1],(char *)&length, 1);
            write(pipefd[i][1],jobString,strlen(jobString) +1);
            //må sove litt så jeg får tid til å få jobben og sende de til barna og litt sånt,
            // kanskje en bedre måte å gjøre dette på
            sleep(1);

        }
        antall --;
    }

    


}
*/


/*
void child2(int pipefd[2]){
    close(pipefd[1]);

    unsigned char length = 0x01;

    for(;;){
        char buf[256] = { 0 };
        read(pipefd[0],(unsigned char *)&length,sizeof(unsigned char));
        if(length == 0x00 ) break;
        read(pipefd[0],buf,length);
        fprintf(stderr, "barn 2: %s\n", buf);
    }
    printf("Nå avslutter barn 2\n");
    close(pipefd[0]);
    exit(0);
}
*/

