CC = gcc
DEPS = matrices.h nav_func.h
OBJ = matrices.o nav_func.o
CFLAGS = -I. 
LIBS=-lm -lpthread

all: fgfs_uav main processor

%.o: %.c $(DEPS)
	$(CC) $(CFLAGS) -c -o $@ $< $(LIBS)
	
fgfs_uav: fgfs_uav.o $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)
	
main: main.o $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

processor: processor.o $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

.PHONY: clean 

clean:
	rm -f *.o fgfs_uav  main processor *~
	
	
	
#lsof -i UDP:5500
#kill -9 12796
