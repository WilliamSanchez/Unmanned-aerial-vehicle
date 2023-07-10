#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <netdb.h>

#define BUF_SIZE 10
#define PORT_NUM 4500

 char buf[BUF_SIZE] = "Hola\n";
 
int main()
{
   struct sockaddr_in svaddr, claddr;
   int sfd, j;
   int numBytes;
   socklen_t len;
   
   sfd = socket(AF_INET, SOCK_DGRAM, 0);
   if(sfd == -1)
   {
   	perror("socket");
   }
   
   memset(&svaddr, 0, sizeof(struct sockaddr_in));
   svaddr.sin_family = AF_INET;
   svaddr.sin_addr.s_addr = INADDR_ANY;
   svaddr.sin_port = htons(PORT_NUM);

   
   if(bind(sfd,(struct sockaddr *)&svaddr,sizeof(struct sockaddr)) == -1)
   {
      perror("Bind");
   }

   numBytes = strlen(buf);
   
   while(1)
   {
    
      if(sendto(sfd,buf,numBytes,0,(struct sockaddr *) &svaddr,sizeof(struct sockaddr_in)) != numBytes)
      {
         perror("sendto");
         
      }else{
            printf("Send data Success\n");
      } 
      usleep(300000);
   
   }

   return 0;
}

