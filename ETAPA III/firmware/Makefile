INCLUDE_DIRS = 
LIB_DIRS = 
CC=gcc

CDEFS=
CFLAGS= -O0 -g $(INCLUDE_DIRS) $(CDEFS)
LIBS= 

HFILES= 
CFILES= main.c processor.c

SRCS= ${HFILES} ${CFILES}
OBJS= ${CFILES:.c=.o}

all:	main processor

clean:
	-rm -f *.o *.d
	-rm -f main processor

main: main.o
	$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $@.o -lpthread
	
main: processor.o
	$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $@.o -lpthread

depend:

.c.o:
	$(CC) $(CFLAGS) -c $<
	
	
	
