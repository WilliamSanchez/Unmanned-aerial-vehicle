#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <ctype.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>


#define BUF_SIZE 100
#define PORT_NUM 5500

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
   svaddr.sin_addr.s_addr = INADDR_ANY; //inet_addr("127.0.0.1"); 
   svaddr.sin_port = htons(PORT_NUM);
      
   if(bind(sfd,(struct sockaddr *)&svaddr,sizeof(struct sockaddr)) == -1)
   {
      perror("Bind");
   }
   
   int sock_len = sizeof(struct sockaddr_in);
   numBytes = recvfrom(sfd,resp,sizeof(resp),0,(struct sockaddr*)&svaddr, &sock_len);
   if(numBytes == -1)
   {
        perror("recvfrom");
   }
       
       printf("Response: %.*s\n", (int)numBytes, resp);
   
   for(;;)
   {
       msgLen = strlen(send_Data);
       if(sendto(sfd,send_Data, msgLen, 0, (struct sockaddr*)&svaddr, sizeof(struct sockaddr_in)) != msgLen)
       {
         perror("sendto");
       }
       
       numBytes = recvfrom(sfd,resp,sizeof(resp),0,(struct sockaddr*)&svaddr, &sock_len);
       if(numBytes == -1)
       {
          perror("recvfrom");
       }
       
       printf("Response: %.*s\n", (int)numBytes, resp);
       
       usleep(300000);
   }
   exit(EXIT_SUCCESS);
}

