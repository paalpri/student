CC=gcc
CFLAGS=-Wall -Wextra -std=c99

test: oppg1.c
	$(CC) $(CFLAGS) $^ -o $@
	gcc oppg1.c -o oppg1
run: test
	./oppg1

clean:
	rm -f test
