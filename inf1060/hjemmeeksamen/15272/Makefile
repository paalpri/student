CC=gcc
CFLAGS=-Wall -Wextra -std=gnu99 -g

all: client server

client: client.c
	$(CC) $(CFLAGS) $^ -o $@

server: server.c
	$(CC) $(CFLAGS) $^ -o $@

checkclient: client
	valgrind --leak-check=full --track-origins=yes --show-leak-kinds=all ./client localhost 4444

checkserver: server
	valgrind --leak-check=full --track-origins=yes --show-leak-kinds=all ./server nolength.job 4444

run: client	
	./client localhost 4444

clean:
	rm -f server client
