CC=gcc

CFLAGS=-g3

OFLAGS=-march=native -O1

DEFINE=BASELINE

all: sobel

sobel: sobel.c
	$(CC) -D$(DEFINE)=1 $(CFLAGS) $(OFLAGS) $< common.c -o $@ -lm

clean:
	rm -Rf *~ sobel
