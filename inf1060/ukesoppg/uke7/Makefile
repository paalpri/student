CC = gcc
CFLAGS = -Wall -Wextra -std=gnu99

openWrite: openWrite.c
	$(CC) $(CFLAGS) $^ -o $@	

run: openWrite
	./openWrite testFile.txt "hallaaa balla !!! dette e testen min ;) ";

clean:
	rm -f openWrite
