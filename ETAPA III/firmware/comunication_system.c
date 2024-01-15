#define _GNU_SOURCE_

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <time.h>

#include <pthread.h>
#include <sched.h>
#include <time.h>
#include <semaphore.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>
#include <string.h>

#include "dqData.h"


#define sensor_data

#define NUM_THREADS (3)
#define USER_PER_MSEC (1000)

#define LATITUDE		0
#define LONGITUDE		1
#define ALTITUDE		2
#define AIRSPEED		3
#define HEADING			4
#define X_ACCEL			6
#define Y_ACCEL			7
#define Z_ACCEL			8
#define PITCH_RATE		9
#define ROLL_RATE		10
#define YAW_RATE		11

#define BUF_SIZE 10
#define PORT_NUM 4500

struct dqData _getData;

double getTimeMsec();
char rcv_data[1024];
char txr_data[1024];
int sock_in, sock_out;
float fdmData[100];
int addr_len, bytes_read;
int send_len;
   
struct sockaddr_in server_addr_in, client_addr_in;
struct sockaddr_in server_addr_out, client_addr_out;
struct hostent *host_out;

int abortProgram = 0;

void endProgram(int sig)
{
   abortProgram = 1;
}

void init_getData()
{
   if((sock_in = socket(AF_INET,SOCK_DGRAM,0)) < 0)
   {
       perror("socket");
       exit(1);
   }
   
   server_addr_in.sin_family = AF_INET;
   server_addr_in.sin_port = htons(5500);
   server_addr_in.sin_addr.s_addr = INADDR_ANY;
   bzero(&(server_addr_in.sin_zero),8);
   
   if(bind(sock_in,(struct sockaddr *)&server_addr_in, sizeof(struct sockaddr)) == -1)
   {
   	perror("Bind");
   	exit(1);
   }
   
   addr_len = sizeof(struct sockaddr);
   printf("\nUDPserver waiting for clietn to port 5500");
   
   fflush(stdout);
   
   bytes_read = recvfrom(sock_in,rcv_data,1024,0,(struct sockaddr*)&client_addr_in,&addr_len);
   rcv_data[bytes_read] = '\0';
   
       // print where it got the UDP data from and the raw data
    printf("\n(%s,%d)said:",inet_ntoa(client_addr_in.sin_addr),ntohs(client_addr_in.sin_port));
    printf("DATA: \n\r%s\n\r",rcv_data);
    
        sscanf(rcv_data,"%f%f%f%f%f%f%f%f%f%f%f",
	&_getData.latitude,&fdmData[LONGITUDE],&fdmData[ALTITUDE],
	&fdmData[AIRSPEED],&fdmData[HEADING],
	&fdmData[X_ACCEL],&fdmData[Y_ACCEL],&fdmData[Z_ACCEL],
	&fdmData[ROLL_RATE],&fdmData[PITCH_RATE],&fdmData[YAW_RATE]);

    //print data to screen for monitoring purpose
    sprintf(txr_data,"\nSensor Data\nLAT %f\nLON %f\nALT %f\nAIRSPEED %f\nHEAD %f\nX_accl%f\nY_accel%f\nZ_accel%f\nP_rate%f\nR_rate%f\nY_rate%f\n",
	_getData.latitude,fdmData[LONGITUDE],fdmData[ALTITUDE],
	fdmData[AIRSPEED],fdmData[HEADING],
	fdmData[X_ACCEL],fdmData[Y_ACCEL],fdmData[Z_ACCEL],
	fdmData[ROLL_RATE],fdmData[PITCH_RATE],fdmData[YAW_RATE]);
}

int main(int argc, char **argv)
{

  system("clear");
  int opt;
  
  while((opt = getopt(argc,argv,":d")) != -1)
  {
    switch(opt)
    {
       case 'd':           
             printf("option: %d\n", opt); 
       	     break;
       case '?':
       default:
    }
  }
  
   
  printf("\n\n\n\t\t\tSTART PROGRAM\n");
  
  signal(SIGINT, endProgram);
  init_getData();    
        
  while(abortProgram != 1)
  {
  
  	system("clear");
  
        bytes_read = recvfrom(sock_in,rcv_data,1024,0,(struct sockaddr*)&client_addr_in,&addr_len);
        rcv_data[bytes_read] = '\0';
   
        // print where it got the UDP data from and the raw data
        printf("\n(%s,%d)said:",inet_ntoa(client_addr_in.sin_addr),ntohs(client_addr_in.sin_port));
//        printf("DATA: %s\n\r",rcv_data);

    //parse UDP data and store into float array
    sscanf(rcv_data,"%f%f%f%f%f%f%f%f%f%f%f",
	&_getData.latitude,&_getData.longitude,&_getData.altitude,
	&_getData.airspeed,&_getData.heading,
	&_getData.x_accel,&_getData.y_accel,&_getData.z_accel,
	&_getData.roll_rate,&_getData.pitch_rate,&_getData.yag_rate);
	
    //print data to screen for monitoring purpose

    printf("\nSensor Data\nLAT %f\nLON %f\nALT %f\nAIRSPEED %f\nHEAD %f\nX_accl%f\nY_accel%f\nZ_accel%f\nP_rate%f\nR_rate%f\nY_rate%f\n",
	_getData.latitude,_getData.longitude,_getData.altitude,
	_getData.airspeed,_getData.heading,
	_getData.x_accel,_getData.y_accel,_getData.z_accel,
	_getData.roll_rate,_getData.pitch_rate,_getData.yag_rate);
  
  
      usleep(100000);
  }
        
  
  close(sock_in);
  printf("\nEND .... \n\n");

  return 0;
}


