#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define BUF_SIZE 1024
#define PORT_NUM 5500
#define PORT_NUM_OUT 5501

/*	SERVER		*/

struct controlData
{
    double rudder;
    double elevator;
    double aileron;
    double throttle;
}__attribute__((packed));


union temp64{
  int64_t ll;
  int32_t l[2];
};

void swap64(void *p)
{
     union temp64 *f, t;
     f = (union temp64 *)p;
     t.l[0] = htonl(f->l[1]);
     t.l[1] = htonl(f->l[0]);
     
     f->ll = t.ll;
}

int main()
{
   struct sockaddr_in svaddr, claddr;
   struct sockaddr_in fgAddr;
   int sfd, j;
   ssize_t numBytes;
   socklen_t len;
   char buf[BUF_SIZE];
   char claddrStr[INET_ADDRSTRLEN];
   
   sfd = socket(AF_INET, SOCK_DGRAM, 0);
   if(sfd == -1)
   {
   	perror("socket");
   }
   
   memset(&svaddr, 0, sizeof(struct sockaddr_in));
   svaddr.sin_family = AF_INET;
   svaddr.sin_addr.s_addr = INADDR_ANY;
   //svaddr.sin_addr.s_addr = inet_addr("192.168.1.100");
   svaddr.sin_port = htons(PORT_NUM);
   
   fgAddr.sin_family = AF_INET;
   fgAddr.sin_addr.s_addr = INADDR_ANY;
   //fgAddr.sin_addr.s_addr = inet_addr("192.168.1.1");
   fgAddr.sin_port = htons(PORT_NUM_OUT);
   
   if(bind(sfd,(struct sockaddr *)&svaddr,sizeof(struct sockaddr_in)) == -1)
   {
      perror("Bind");
   }

   struct controlData cdata;
   double cont = 0.0;

   while(1)
   {
      len = sizeof(struct sockaddr_in);
      
      numBytes = recvfrom(sfd,buf,BUF_SIZE,0,(struct sockaddr*)&claddr,&len);
      if(numBytes == -1)
      {
      	 perror("recvfrom");
      }
      
      if(inet_ntop(AF_INET,&claddr.sin_addr,claddrStr,INET_ADDRSTRLEN) == NULL)
      {
        printf("Couldn't convert client address to string \n");
      }else{
        printf("Server received %ld bytes from (%s,%u)\n",(long)numBytes,claddrStr, ntohs(claddr.sin_port));
      }
      /*
      for(j=0; j < numBytes; j++)
      {
           buf[j] = toupper((unsigned char)buf[j]);
      }
      */
      printf("Data: \n\r%s\n\r",buf);
      //if(sendto(sfd,buf,numBytes,0,(struct sockaddr *)&claddr,len) != numBytes)
      //   perror("sendto");
      
      cdata.aileron = 2*cont/200 - 1;
      cdata.rudder = 2*cont/200 - 1;
      cdata.throttle = cont/200;
      cdata.elevator = 2*cont/200 - 1;
      
      swap64(&cdata.aileron);
      swap64(&cdata.rudder);
      swap64(&cdata.throttle);
      swap64(&cdata.elevator);
      
      if(sendto(sfd,&cdata,sizeof(cdata),0,(struct sockaddr *)&fgAddr,len) != numBytes)
      	 perror("sendto");
      
      if(cont >= 200)
           cont = 0;
       cont++;
   }

   return 0;
}

