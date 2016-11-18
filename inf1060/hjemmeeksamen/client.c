#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <string.h>
#include <sys/wait.h>
#include <sys/prctl.h>
#include <netdb.h>
#include <ctype.h>
#include <signal.h>
#include <errno.h>


/*siden 256 er maks lengde representert ved 1 char, altså 1 byte
 * og også derfor maks lengde som job teksten kan være
 * +2 siden vi skal ha plass til både job_type og lengde også
 */
#define MAX_BUF 257

int sock;
int pipefd[2][2];
pid_t pid[2] = { -1, -1 };
int status_child_1 ;
int status_child_2 ;




/* This function creates the client socket
 * and tries to connect that socket to the designated ip and port specified in input.
 *
 * Input:
 *     ip  : the char string of the ip adress of which to connect to
 *     port: the 4 byte char of the desired port of which to connect to
 *
 * Return:
 *       the int value of the client socket.
 */


void clean(){
    if(close(sock) == -1){
        perror("close(");
        exit(EXIT_FAILURE);
    }
}

void closeChildren(){

    unsigned char length = 0;
    int status;
    /* checking the return value to see if write gets an error,
     * and i get the edgecase where the user manages to click ctrl-c
     * when already inside the closeChildren function,
     * which would sometimes crash my program if the read end of the pipe was already closed
     */
    if((write(pipefd[0][1],(char *)&length, 1)) == -1){
        if(errno != EPIPE){
            perror("write()");
            clean();
            exit(EXIT_FAILURE);
        }
    }
    if((write(pipefd[1][1],(char *)&length, 1)) == -1){
        if(errno != EPIPE){
            perror("write()");
            clean();
            exit(EXIT_FAILURE);
        }
    }

    if(waitpid(pid[0],&status,0) != pid[0]){
        /* if the wait failes i cant do anything other then just clean up as much as possible and exit */
        clean();
        exit(EXIT_FAILURE);
    }
    if(waitpid(pid[1],&status,0) != pid[1]){
        clean();
        exit(EXIT_FAILURE);
    }

    close(pipefd[0][1]);
    close(pipefd[1][1]);
}

void terminate_normal(){
    closeChildren();
    ssize_t ret1 = send(sock,"T", 1, 0);
    if(ret1 == -1){
        perror("send()");
        closeChildren();
        clean();
        exit(EXIT_FAILURE);
    }

}

int cre_sock(char *ip, char *port){
    int sock;
    sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if(sock == -1){
        perror("socket()");
        closeChildren();
        exit(EXIT_FAILURE);
    }

    int port_num = atoi(port);
    struct sockaddr_in server_addr;
    memset(&server_addr,0,sizeof(struct sockaddr_in));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port_num);
    int ip_ret = inet_pton(AF_INET,ip, &server_addr.sin_addr.s_addr);
    if(ip_ret != 1){
        if(ip_ret == 0){
            fprintf(stderr, "Invalid IP adress: %s\n",ip);
        } else{
            perror("inet_pton()");
        }
        closeChildren();
        clean();
        exit(EXIT_FAILURE);
    }

    printf("Connecting to %s:%d\n",ip,port_num);
    if(connect(sock, (struct sockaddr *)&server_addr,sizeof(server_addr))){
        perror("connect()");
        closeChildren();
        clean();
        exit(EXIT_FAILURE);
    }
    printf("Connected!\n");
    return sock;
}


/* This method contains everything the child processes does,
 * its in a seperate function for easy reading and manageability
 *
 * It's on a for(::) loop and read's from the pipe,
 * when it gets output from the pipe it prints the output to stdout or stderr,
 * and starts over until it reads the length 0 from pipe, then it breaks and terminates.
 *
 *
 * Input:
 *     pipefd: The desired pipe of which to read from
 *     stream: the file stream which it outputs to,
 *             child 1 have stdout as input here, child 2 have stderr
 *
 * Return:
 *       void function
 */


void child(int pipefd[2],FILE *stream){
    /* closing write end */
    close(pipefd[1]);
    ssize_t ret;

    unsigned char length = 1;
    for(;;){

        if((ret = read(pipefd[0], &length,sizeof(unsigned char)) == -1)  || (length == 0)){
            break;
        }/*
           else if(length == 0){
           break;
           }*/
        char *buf = calloc(1,length+1);
        if((ret = read(pipefd[0],buf,length)) == -1){
            printf("denne ret: %zu\n",ret);
            close(pipefd[0]);
            exit(EXIT_FAILURE);
        }
        fprintf(stream, "job: %s\n", buf);
        free(buf);
    }

    printf("Child exiting\n");

    close(pipefd[0]);
    exit(0);
}




/* Function for creating the two child processes and theyr associated pipes
 * children made with fork() and calling the child1() and child2() functions inside each pid == 0 statements
 * Using prctl() inside each child process to set up that if the parent dies the child terminates aswell
 *
 * Input:
 *     Nothing
 *
 * Return:
 *       void function
 */

void makeChildren(){
    //lager pipe til barn 1
    if(pipe(pipefd[0]) == -1){
        perror("pipe()");
        exit(EXIT_FAILURE);
    }


    //lager barn 1
    pid[0] = fork();
    if(pid[0] == -1){
        perror("fork()");
        exit(EXIT_FAILURE);
    }

    //da er vi i barneprosses 1
    if(pid[0] == 0){
        /*brukes sånn at barneprosessen avslutter visst det skjer noe og parent processen avslutter
         * instead of killing my child processes manualy before each exit(EXIT_FAILURE)
         */
        prctl(PR_SET_PDEATHSIG, SIGHUP);
        signal(SIGINT,SIG_IGN);
        //husk å bruke wait() for å ikke lage zombie process kan også bruke waitpid()
        child(pipefd[0],stdout);
    }else{
        /* making sure to close child 1, if i get an error in the making of child 2 */
        if(pipe(pipefd[1]) == -1){
            perror("pipe()");
            unsigned char length = 0;
            int status;
            write(pipefd[0][1],(char *)&length, 1);
            wait(&status);
            close(pipefd[0][1]);
            exit(EXIT_FAILURE);
        }
        pid[1] = fork();
        if(pid[1] == -1){
            perror("fork()");
            unsigned char length = 0;
            int status;
            write(pipefd[0][1],(char *)&length, 1);
            wait(&status);
            close(pipefd[0][1]);
            exit(EXIT_FAILURE);
        }
        if(pid[1] == 0){ // barneprossess 2
            prctl(PR_SET_PDEATHSIG, SIGHUP);
            signal(SIGINT,SIG_IGN);
            //husk å bruk wait() for å ikke lage zombie process, eller waitpid()
            child(pipefd[1],stderr);
        }
    }

    close(pipefd[0][0]);
    close(pipefd[1][0]);
    /* ignores the SIGPIPE signal */
    if (signal(SIGPIPE, SIG_IGN) == SIG_ERR)
        perror("signal");
}


/* Function that ask the server for a job.
 * send the 'G' (get job char) and the number of jobs we want to the server.
 * waits for a reply with recv, and loops through until we have got the x number of jobs
 * or until we get the exit job,
 * The jobs are being printed in random order, can use nanosleep to make them come in the right order,
 * but this would take longer time, i assume the order of the jobs is not important
 *
 *
 *
 * Input:
 *     antall: the number of jobs i wish to get from the server
 *
 * Return:
 *     going: the int that says if we are to continue the program,
 *            1 if everything goes ok, 0 if we receives the 'Q' job from server
 */

int askForJob(int antall){
    int going = 1;
    unsigned char get_job[2] = { 'G', (unsigned char) antall};
    ssize_t ret = send(sock,get_job, sizeof(get_job), 0);
    if(antall == 0){
        antall = -1;
    }
    if(ret == -1){
        perror("send()");
        closeChildren();
        clean();
        exit(EXIT_FAILURE);
    }
    char buff[MAX_BUF ] = { 0 };
    size_t recv_length = 0;
    while (antall != 0){
        /* reads as much as we have room for in the buffer.
         * Which is 2 times the size of the maximum a job can be,
         * because we might read more the 1 job at a time
         */
        ret = recv(sock, buff + recv_length, sizeof(buff) - recv_length, 0);
        if(ret == 0){
            printf("Server disconnected! \n");
            closeChildren();
            return 0;
        }else if ( ret == -1){
            perror("recv()");
            closeChildren();
            clean();
            exit(EXIT_FAILURE);
        }else{
            recv_length += ret;
            /* Considered running this stuff in a separete method,
             * but personally found it easier to understand and write when i had it all together
             */
            while(recv_length >= 2){
                /* atleast 2 byte must have arrived, this way i get the length byte */
                char jobtype = buff[0];
                unsigned char length = buff[1];
                if(recv_length < (unsigned) (2 + length)){
                    /* if we dont have the whole job yet, we break and goes to the top to read the rest */
                    break;
                }
                char *jobString = buff;
                jobString += 2;

                int i;
                if(jobtype == 'O'){
                    i = 0;
                } else if(jobtype == 'E'){
                    i = 1;
                }else if (jobtype == 'Q'){
                    // terminates the children by sending the length which is 0 */
                    printf("No more jobs \n ");
                    terminate_normal();
                    return 0;

                }else if(jobtype == 'C'){
                    printf("Server jobfile is corrupt, quitting\n");
                    return 0;
                }
                else{
                    printf("Invalid jobtype, something weird happend. quitting :) \n");
                    closeChildren();
                    clean();
                    exit(EXIT_FAILURE);
                }
                /* writes the length and the job to the desired(i) child */
                if((write(pipefd[i][1],&length, sizeof(unsigned char))) != 1){
                    closeChildren();
                    clean();
                    exit(EXIT_FAILURE);
                }
                if((write(pipefd[i][1],jobString, length)) != length){
                    closeChildren();
                    clean();
                    exit(EXIT_FAILURE);
                }



                recv_length -= 2 + length;
                if(recv_length > 0){
                    /* inspirerd by another code i found,
                     * to solve the problem where if i wrote 50 byte the first time,
                     * and 25 the next. the second print would contain half of the first read
                     * figured it was a neat peace of code and used it :)
                     */
                    memmove(buff,buff + 2 + length,recv_length);
                }
                antall --;
            }
        }
    }
    /* sleeps for half a second, to give the children time to print it's stuff,
       only to make the print look pretty */
    return going;
}


/*
 * Prints the possible command
 *
 * Input:
 *     None
 *
 * Return:
 *       void function
 */

void printHelp(){
    printf("ret   -> Retrieve 1 jobb from server\n");
    printf("retx  -> Retrive X jobs from server\n");
    printf("retall-> retrive all jobs from server\n");
    printf("quit  -> quit program\n");
    printf("help  -> Show all commands\n");
}

/*
 * Command function.
 * On a loop for as long as the program runs, works like a super basic command shell
 *
 *
 * Input:
 *     None
 *
 * Return:
 *       void function
 */

void command(){
    printHelp();


    char buf[MAX_BUF];
    char* username = getenv("USER");
    int going = 1;


    while (going){
        printf("%s@shell > ", username);
        if(!fgets((buf),MAX_BUF, stdin)) break;
        if(strcmp(buf,"ret\n") == 0){
            going = askForJob(1);
            usleep(5000);
        }
        else if(strcmp(buf,"retx\n") == 0){
            printf("How many jobs would you like to get (between 1 - 255): ");

            int antall;
            char c;
            /* Makes sure the user only inputs numbers,
               continues with the loop if the user enters something else */
            if((scanf("%d%c", &antall, &c) !=2 || c!='\n')){
                //cleaning up the stdin stream for garbage
                printf("Only numbers \n");
                while (getchar() != '\n'); // Read until a newline is found
                continue;
            }
            if(antall > 255 || antall < 1){
                printf("Input between 1 - 255, if you want all jobs type retall\n");
                continue;
            }
            going = askForJob(antall);
            /* sleeps for some amount of time to make the command shell print come after the child prints
             * this dont work perfect when running with valgrind,
             * because valgrind uses some amount of extra time
             */
            usleep(100 * antall);
        }
        else if(strcmp(buf,"retall\n") == 0){
            /* send with 0 as number of jobs, means all jobs */
            going = askForJob(0);
        }
        else if(strcmp(buf,"quit\n") == 0){
            terminate_normal();
            break;
        }
        else if(strcmp(buf,"help\n") == 0){
            printHelp();
        }else{
            buf[strlen(buf)-1] = '\0';
            printf("%s: command not found\nuse \"help\" for all commands\n",buf);
        }
    }

}




/*
 * Finds the ip of the server we are supposed to connect to. Check if the users first char is a number,
 * in which case we just puts the hostname array into the ip pointer, or i use getaddrinfo to find the ip
 *
 * Input:
 *     hostname: The char array the user inputs when he starts the program, might we ip adress or hostname
 *           ip: The pointer to the ip where i saves the ip when im done
 *
 * Return:
 *       void function
 */

/* used some of the code example found on man 3 getaddrinfo */
void host_to_ip(char* hostname, char  *ip, char *port){
    /* checks if the hostname already is in ip form */
    if(isdigit(hostname[0])){
        strcpy(ip,hostname);
        return;
    }
    int s;
    struct addrinfo hints;
    struct addrinfo *result, *rp;
    struct sockaddr_in *h;
    memset(&hints, 0, sizeof (struct addrinfo));
    hints.ai_family = AF_INET; // allows for ipv4
    hints.ai_socktype = SOCK_STREAM; /* STREAM because we wants tpc */
    hints.ai_protocol = 0; /* for any protocol*/
    hints.ai_flags = 0;
    if( (s = getaddrinfo(hostname, port, &hints,&result))){
        fprintf(stderr, "getaddrinfo: %s\n",gai_strerror(s));
        exit(EXIT_FAILURE);
    }
    /* getaddrinfo returns a linked list of address structures.
     *  looping through all the adress structurees that the call return,
     * does this until i find the right one
     */
    for(rp = result; rp != NULL; rp = rp -> ai_next){

        h = (struct sockaddr_in *) rp->ai_addr;
        strcpy(ip,inet_ntoa( h->sin_addr));
    }
    freeaddrinfo(result);
}

/* signal handling function
 *
 * Input:
 *       signal number as its only input, as specified in man sigaction
 *
 * Return:
 *        void function
 */


void handler(int signum){
    ssize_t ret = send(sock,"E", 1, 0);
    if(ret == -1){
        perror("send()");
    }
    closeChildren();
    clean();
    exit(EXIT_SUCCESS);
}

/* LOOK, a wild main appears */
int main(int argc, char *argv[]){
    if(argc != 3){
        fprintf(stderr, "Usage: %s <IP> <port> \n",argv[0]);
        return 0;
    }
    struct sigaction sa;
    memset(&sa,0,sizeof(sa));
    sa.sa_handler = handler;
    if(sigaction(SIGINT,&sa,NULL)){
        perror("sigaction()");
        exit(EXIT_FAILURE);
    }
    char ip[100];
    host_to_ip(argv[1],ip,argv[2]);

    makeChildren();



    sock = cre_sock(ip,argv[2]);
    if(sock == -1){
        printf("Error in cre_sock()");
        closeChildren();
        clean();
        exit(EXIT_FAILURE);
    }

    command();
    clean();
    return 0;
}
