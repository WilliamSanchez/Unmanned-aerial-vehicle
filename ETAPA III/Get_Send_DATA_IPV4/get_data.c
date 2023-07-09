#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <ctype.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>


#define BUF_SIZE 10
#define PORT_NUM 5002

char send_Data[32] = "Hola\n";

int main(int argc, char *argv[])
{
   struct sockaddr_in svaddr;
   int sfd, j;
   ssize_t numBytes;
   ssize_t msgLen;
   char resp[BUF_SIZE];

   
   sfd = socket(AF_INET, SOCK_DGRAM, 0);
   if(sfd == -1)
   {
   	perror("socket");
   }
   
   memset(&svaddr, 0, sizeof(struct sockaddr_in));
   svaddr.sin_family = AF_INET;
   svaddr.sin_addr.s_addr = INADDR_ANY;
   svaddr.sin_port = htons(PORT_NUM);
   
   for(;;)
   {
       msgLen = strlen(send_Data);
       if(sendto(sfd,send_Data, msgLen, 0, (struct sockaddr*)&svaddr, sizeof(struct sockaddr_in)) != msgLen)
       {
         perror("sendto");
       }
       
       numBytes = recvfrom(sfd,resp,BUF_SIZE,0,NULL,NULL);
       if(numBytes == -1)
       {
          perror("recvfrom");
       }
       
       printf("Response: %.*s\n", (int)numBytes, resp);
       
       usleep(300000);
   }
   exit(EXIT_SUCCESS);
}

