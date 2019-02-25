CC=nvcc
CFLAGS=

all: main

main:
	$(CC) $(CFLAGS) -O3 -Xcompiler -fopenmp seq.cu -o $@

.PHONY:	clean

clean:
	rm -f *.o seq_practice