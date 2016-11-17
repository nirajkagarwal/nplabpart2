  #include <arpa/inet.h>
       #include <netinet/in.h>
       #include <stdio.h>
       #include <sys/types.h>
       #include <sys/socket.h>
       #include <unistd.h>
     
       #define BUFLEN 512
       #define NPACK 10
      #define PORT 9930

   #define SRV_IP "127.0.0.1"
      /* diep(), #includes and #defines like in the server */
  void diep(char *s)
      {
        perror(s);
        exit(1);
      }
  int main(void)
  {
         struct sockaddr_in si_other;
         int s, i, slen=sizeof(si_other);
         char buf[BUFLEN];
         char host[20];
         int ch=0;
          int port;
        if ((s=socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP))==-1)
          diep("socket");
        printf("\n************This is client :");
        bzero(host,20);
         printf("\nEnter \n0 for  local host ( your computer as both client and server ) \n otherwise type ip address of server :\n "); 
        scanf("%s",host);              //   "ifconfig"  at root
        if(strcmp(host,"0") == 0 )
              strcpy(host,"127.0.0.1");
 	printf("Client : Enter port : ");
        scanf("%d",&port);
        memset((char *) &si_other, 0, sizeof(si_other));
        si_other.sin_family = AF_INET;
        si_other.sin_port = htons(port);
     //   if (inet_aton(SRV_IP, &si_other.sin_addr)==0) {
        if (inet_aton(host, &si_other.sin_addr)==0) {
          fprintf(stderr, "inet_aton() failed\n");
          exit(1);
        }

     printf("\nClient   host port number = %d\n" ,  ntohs(si_other.sin_port) );
   
        for (i=0; i<NPACK; i++) {
          printf(" client: Sending packet %d\n", i);
          sprintf(buf, "This is packet %d\n", i);
          if (sendto(s, buf, BUFLEN, 0, &si_other, slen)==-1)
            diep("sendto()");
        }
    
        close(s);
        return 0;
      }