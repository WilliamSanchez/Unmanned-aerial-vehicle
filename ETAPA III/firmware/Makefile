CC  = gcc
DEPS = 
OBJ =  comunication_system.o
CFLAGS = -I.

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

all: comunication_system

comunication_system: comunication_system.o
	$(CC) -o $@ $^ $(CFLAGS)


.PHONY: clean

clean:
	rm -f *.o shm2 shm1 mmap *~

