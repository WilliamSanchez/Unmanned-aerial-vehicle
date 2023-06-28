CC = gcc
CFLAGS= -I. -lpthread
OBJ = comunication_system.o

#	$@	--> Name of the current target
#	$< 	--> Name of the current prerequisite
#	$* 	--> Name of the current prerequisite without any sufex 

%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

# pthread.o: pthread.c
#	gcc -c -o pthread.o pthread.c

all: comunication_system
	
comunication_system: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)

#pthread: pthread.o 
#     gcc -o pthread pthread.o

.PHONY: clean

clean:
	rm -f *.o comunication_system *~
	
	
	
