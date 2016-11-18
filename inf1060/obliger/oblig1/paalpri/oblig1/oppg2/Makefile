CFLAGS = -Wall -Wextra -std=c99

oppg2: oppg2.c oblig1_tests.c
	gcc -c oppg2.c oblig1_tests.c
	gcc oppg2.o oblig1_tests.o -o oppg2 $(CFLAGS)

run: oppg2
	./oppg2

clean:
	rm -f oppg2
