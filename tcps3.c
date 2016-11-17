
//  author RAGHAVENDRA M          tcps3.c tcp ip server program


#include<stdio.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<unistd.h>
#include <termios.h>

void error(char *msg)
{
	perror(msg);
	exit(1);
}



int main(int argc,char *argv[])
{
	int sockfd,newsockfd,portno,clilen,n,slen,pid;
	char buffer[256],c[200];
	char fname[20];
	
	struct sockaddr_in serv_addr,cli_addr;
	FILE *fptr;
	printf("\n*******This is server ,for ipaddress open another terminal (press + ) and type : \n");
	printf(" ifconfig \n to remove bind error :\n fuser -k 5000/tcp \n where 5000 is port number where server is waiting ");
	printf("\nto run client (press + ) :\n ./c "); 
	printf("\nEnter server port number  : ");
	scanf("%d",&portno);
        
    //    portno=5000;
	
	sockfd=socket(AF_INET,SOCK_STREAM,0);

	if(sockfd<0)
		error("\nERROR opening socket");
	bzero((char *)&serv_addr,sizeof(serv_addr));
	serv_addr.sin_family=AF_INET;
	serv_addr.sin_addr.s_addr=INADDR_ANY;
	serv_addr.sin_port=htons(portno);

	if(bind(sockfd,(struct sockaddr *)&serv_addr,sizeof(serv_addr))<0)
		perror("\nERROR in binding");
	printf("\nNow server is up wating for client");
	
	listen(sockfd,5);
 	clilen=sizeof(cli_addr);
	
	while(1)
	{

		newsockfd=accept(sockfd,(struct sockaddr *)&cli_addr,&clilen);

		printf("\n New client requested it sockfd  =  %d",newsockfd);
		bzero(fname,20);
		close(sockfd);
     		n=read(newsockfd,fname,20);
    		printf("\nn Requesting file content  %s  ",fname);
		slen=strlen(fname);
	        if(n<0)
       			error("\nERROR reading from socket");
       		fptr=fopen(fname,"r");
		if(fptr==NULL)
        	{		  
         	printf("\nSERVER:file not found");
         	bzero(buffer,20);
		strcpy(buffer,"file not found....");
		   if(send(newsockfd, buffer, strlen(buffer), 0) == -1)
                perror("send");

		close(newsockfd);
	 	fclose(fptr);
         	_exit(0);   
               }
	
   	printf("\nserver : Following information is send back to client :- \n\n\n");

       while(!feof(fptr))
        {
	fgets(buffer,79,fptr);
        if(send(newsockfd, buffer, strlen(buffer), 0) == -1)
                perror("send");
	puts(buffer);
	}
	
        printf("\nserver :file contents are transfered"); 
        fclose(fptr);
        close(newsockfd);
        printf("\nserver :Process is going to terminate\n"); 
       exit(0);
    } //while(1)  
     
}
 
 
 
