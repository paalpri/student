CFLAGS = -Wall -Wextra -std=c99

oppg1: oblig2.c
	gcc -c oblig2.c
	gcc oblig2.o -o oblig2 $(CFLAGS)

run: oblig2
	./oblig2 100router.dat

clean:
	rm -f oblig2
