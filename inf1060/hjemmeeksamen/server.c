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


/* siden 256 er maks lengde representert ved 1 char, altså 1 byte
 * og også derfor maks lengde som job teksten kan være
 * +3 siden vi skal ha plass til både job_type,lengde og \0 som strcat legger til
 */
#define MAX_BUF 258




int running = 1;
int sock = 0;
int client_sock = 0;
FILE *file = NULL;
char *port;


/*
 * Function for creating a socket for which the server binds itself to,
 * making it possible for clients to connect to this socket.
 *
 * Input:
 *      port: the 4 bit char value of the port, which the server connects to
 *
 * Return:
 *       The int value of the server socket,
 *       or -1 if an error happens
 */



void clean(){
    if(close(sock) == -1){
        perror("close(");
        exit(EXIT_FAILURE);
    }
}
void cleanClient(){
    if(close(client_sock) == -1){
        perror("close(");
        exit(EXIT_FAILURE);
    }
}
int cre_sock(){

    sock = socket(AF_INET,SOCK_STREAM, IPPROTO_TCP);
    if(sock == -1){
        perror("socket()");
        return -1;
    }
    int port_num = atoi(port);

    struct sockaddr_in server_addr;
    memset(&server_addr,0,sizeof(struct sockaddr_in));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(port_num);// htons gjør om til nettverk byte order ( big endian)
    int yes = 1;
    if(setsockopt(sock, SOL_SOCKET,SO_REUSEADDR, &yes, sizeof(int))){
        perror("setsockopt()");
        clean();
        return -1;
    }
    //Assigning a name to a socket, or assigning a adress to the socket
    if(bind(sock, (struct sockaddr *)&server_addr,sizeof(server_addr))){
        perror("bind()");
        clean();
        return -1;
    }
    printf("Socket bound to: %d\n",port_num);
    if(listen(sock, SOMAXCONN)){
        perror("listen()");
        clean();
        return -1;
    }

    return sock;
}

/* This function listens for clients and accepts theyr connection,
 * and prints the client ip and port on success
 *
 *
 * Input:
 *      sock: the int value of the socket that the server is bound to.
 *
 * Return:
 *       The int value of the client socket,
 *       or -1/0 if an error happens
 */

int accept_conn(int sock){
    struct sockaddr_in client_addr;
    memset(&client_addr,0,sizeof(client_addr)); //nullstiller minneadressen til client_addr
    socklen_t addr_len = sizeof(client_addr); // socklen_t er en variabel ish som ligger i header, passer bra

    client_sock = accept(sock, (struct sockaddr *)&client_addr,&addr_len);
    if(client_sock == -1){
        if(errno ==  EINTR){ return 0;  }
        perror("accept()");
        close(sock);
        return -1;
    }
    printf("Made connection\n");
    // skriver bare ut ipen og bin tilclienten vår
    char *client_ip = inet_ntoa(client_addr.sin_addr); //gjør om internett adressen til noe local host forstår
    uint32_t client_ip_bin = ntohl(client_addr.sin_addr.s_addr);// gjør om fra network byte order til host order
    printf("Client IP/port: %s/0x%x\n",client_ip,client_ip_bin);

    // returnerer
    /* closing the listening socket, this way no other sockets can connect */
    clean();
    return client_sock;
}




/* ane ikke kos denne funke egentlig O.o
 *
 *
 *
 * Input:
 *     signum:
 *
 * Return:
 *       void function
 */


void handler(int signum){
    if(sock){
        clean();
    }
    fclose(file);
    if(client_sock){
        cleanClient();
    }
    exit(EXIT_SUCCESS);
}

void corrupt(){
    printf("Jobfile was corrupt, letting client know the quitting\n");

    char *buf = "C" + 0;
    ssize_t ret = send(client_sock,buf, 2, 0);
    if(ret == -1){
        if(errno == EINTR){ corrupt(); }
        perror("send()");
        close(client_sock);
        fclose(file);
        exit(EXIT_FAILURE);
    }

}



/*
 * This function is the main function of the server, its on a loop from the main program,
 * and listens for jobs from the client.
 * When it receives a x number of jobs from the client, it reads the next x jobs from the jobFile
 * and sends those back to the client.
 * When it reads EOF from file, it sends the 'Q' (exit job) to the client then breaks out of the loop.
 *
 * Input:
 *     no input
 *
 * Return:
 *       returns 1 on success and 0 on EINTR error, which means interrupted by signal somewhere
 *       returns -1 on other errors
 */

int listenForJob(){
    //client sender alltid 2 tegen bare, e som type jobb og en for antall jobber
    unsigned char buf[2] = { 0 };
    int antall;

    ssize_t ret = recv(client_sock, buf , sizeof(buf), 0);
    antall = (int) buf[1];
    if(antall == 0){
        antall = -1;
    }
    if(ret == 0){ // her skal det sjekke om klient disconnecter
        printf("Client disconnected :( \n");
        return -1;
    }else if( ret == -1){
        // eintr betyr at et signal avbrøy leveringen av melding, altså ctrl_c elns
        if(errno == EINTR){ return 0; }
        perror("recv()");
        return -1;
    }
    // her får vi gyldig melding fra klient og skriver det ut;
    char job = buf[0];
    if(job == 'T' ){
        // client have terminated normally, shutting down server
        printf("Client terminated normaly, shutting down server\n");
        return -1;
    }else if(job == 'E' ){
        // client terminated because of an error, connecting to new socket and listening for new connection
        sock = cre_sock();
        if(sock == -1){
            printf("Noe gikk galt i cre_sock");
            fclose(file);
            exit(EXIT_FAILURE);
        }

        /* accept connection, handels error with exit, see accept_conn() func */
        if(accept_conn(sock) == -1){
            printf("Noe gikk galt i accept_conn\n");
            fclose(file);
            exit(EXIT_FAILURE);
        }
        printf("Client terminated unexpected, waiting for new client\n");
        /* this is where we get a legit job request and start reading the jobfile to send back */
    }else if(job == 'G' ){
        while (antall != 0){
            char job_type;
            unsigned char length = 0;
            char jobString[256] = { 0 };
            char sendJob[MAX_BUF] = { 0 };
            if((job_type = fgetc(file)) != EOF){
                if((job_type != 'O' ) && (job_type != 'E' )){
                    printf("Jobfile is corrupt by wrong jobtype \n");
                    corrupt();
                    return -1;
                }
                if(fread(&length,sizeof(unsigned char),1,file) != 1){
                    corrupt();
                    return -1;
                }
                if(length < 1){
                    printf("Jobfile is corrupt by wrong length \n");
                    corrupt();
                    return -1;
                }
                sendJob[0] = job_type;
                sendJob[1] = length;
                if(fread(jobString,sizeof(char),length,file) != length){
                    perror("fread()");
                    corrupt();
                    return -1;
                }
                if(strlen(jobString) != length){
                    perror("fread()");
                    corrupt();
                    return -1;
                }
                strcat(sendJob,jobString);
            }else{
                printf("No more jobs \n");
                sendJob[0] = 'Q';
                sendJob[1] = 0;
                antall = 1;
            }


            /* making sure we send the whole message */
            ret = 0;
            while(ret != (unsigned)(2 + length)){
                ret += send(client_sock,sendJob + ret, (2 + length) - ret, 0);


                if(ret == -1){
                    if(errno == EINTR){ return 0; }
                    perror("send()");
                    return -1;
                }
            }
            antall --;
        }
    }
    return 1;
}



/*
 * Main, stuff happens. comments inside main
 */


int main(int argc, char* argv[]){

    if(argc != 3){
        fprintf(stderr, "Usage: %s <file> <port> \n",argv[0]);
        return 0;
    }
    port = argv[2];
    struct sigaction sa;
    memset(&sa,0,sizeof(sa));
    sa.sa_handler = handler;
    if(sigaction(SIGINT,&sa,NULL)){
        perror("sigaction()");
        close(sock);
        exit(EXIT_FAILURE);

    }


    /* Opens the file, saves it global for access later */
    file = fopen(argv[1],"r");
    if(file == NULL){
        perror("fopen()");
        exit(EXIT_FAILURE);
    }

    /* creating socket, see cre_sock() func */
    sock = cre_sock();
    if(sock == -1){
        printf("Noe gikk galt i cre_sock");
        fclose(file);
        exit(EXIT_FAILURE);
    }

    /* accept connection, handels error with exit, see accept_conn() func */
    if(accept_conn(sock) == -1){
        printf("Noe gikk galt i accept_conn\n");
        fclose(file);
        exit(EXIT_FAILURE);
    }

    /* Listens for jobs as long as we have a client connected*/
    while (running){
        if(listenForJob() == -1){
            break;
        }
    }

    fclose(file);
    cleanClient();
    return 0;
}
