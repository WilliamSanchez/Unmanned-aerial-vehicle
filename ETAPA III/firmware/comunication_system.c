#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#include<stdio.h>
#include<unistd.h>
#include<errno.h>
#include<string.h>
#include<stdlib.h>
#include<math.h>

#define ROLL		0
#define PITCH		1
#define HEADING		2
#define ROLL_RATE	3
#define PITCH_RATE	4
#define YAW_RATE	5
#define X_ACCEL		6
#define Y_ACCEL		7
#define Z_ACCEL		8


int main(){
  
   int sock_in,sock_out;
   int addr_len, bytes_read;
   char recv_data[1024];
   char exitcode = 'N';
   float fdmData[100];
   float aileron_ctrl, pitch_ctrl;
   
   struct sockaddr_in server_addr_in, client_addr_in;
   struct sockaddr_in server_addr_out;
   struct hostent *host_out; 

   int msgL = 0;
   char send_data[1024];
   

   //host config
    
   if((sock_in = socket(AF_INET,SOCK_DGRAM,0)) == -1){
	perror("Socket");
	exit(1);	
    }
   
    server_addr_in.sin_family = AF_INET;
    server_addr_in.sin_port = htons(5500);
    server_addr_in.sin_addr.s_addr = INADDR_ANY;  
    bzero(&(server_addr_in.sin_zero),8);

    if(bind(sock_in,(struct sockaddr *)&server_addr_in,sizeof(struct sockaddr)) == -1){
 	perror("Bind");
	exit(1);
    }

    addr_len = sizeof(struct sockaddr);

    printf("\nUDPserver Waiting for client on port 5500");
    
    fflush(stdout);
    
    //client config
 /*  
    host_out = (struct hostent*)gethostbyname((char*)"127.0.0.1");
    if((sock_out = socket(AF_INET,SOCK_DGRAM,0))==-1){
    	perror("Socket");
	exit(1);
    }

    server_addr_out.sin_family=AF_INET;
    server_addr_out.sin_port = htons(5010);
    server_addr_out.sin_addr.s_addr = *((struct in_addr*)host_out->h_addr);
    bzero(&(server_addr_out.sin_zero),8);
*/

   while(1){
   
    //wait for new UDP packet, and read it on to recv_data
    bytes_read = recvfrom(sock_in,recv_data,1024,0,(struct sockaddr*)&client_addr_in,&addr_len);
    recv_data[bytes_read] = '\0';
    
    // print where it got the UDP data from and the raw data
    printf("\n(%s,%d)said:",inet_ntoa(client_addr_in.sin_addr),ntohs(client_addr_in.sin_port));
//    printf("%s",recv_data);

    //parse UDP data and store into float array
    sscanf(recv_data,"%f%f%f%f%f%f%f%f%f",
	&fdmData[ROLL],&fdmData[PITCH],&fdmData[HEADING],
	&fdmData[ROLL_RATE],&fdmData[PITCH_RATE],&fdmData[YAW_RATE],
	&fdmData[X_ACCEL],&fdmData[Y_ACCEL],&fdmData[Z_ACCEL]);

    //print data to screen for monitoring purpose
    printf(recv_data,"\nSensor Data \n%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n",
	fdmData[ROLL],fdmData[PITCH],fdmData[HEADING],
	fdmData[ROLL_RATE],fdmData[PITCH_RATE],fdmData[YAW_RATE],
	fdmData[X_ACCEL],fdmData[Y_ACCEL],fdmData[Z_ACCEL]);
 

   }
   return 0;
}
