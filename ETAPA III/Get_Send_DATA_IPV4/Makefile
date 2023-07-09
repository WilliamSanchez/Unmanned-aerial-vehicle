INCLUDE_DIRS = 
LIB_DIRS = 
CC=gcc

CDEFS=
CFLAGS= -O0 -g $(INCLUDE_DIRS) $(CDEFS)
LIBS= 

HFILES= 
CFILES= send_data.c get_data.c

SRCS= ${HFILES} ${CFILES}
OBJS= ${CFILES:.c=.o}

all:	send_data 


clean:
	-rm -f *.o *.d
	-rm -f send_data get_data

send_data: send_data.o
	$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $@.o -lpthread

get_data: get_data.o
	$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $@.o -lpthread

depend:

.c.o:
	$(CC) $(CFLAGS) -c $<
	
	
	
