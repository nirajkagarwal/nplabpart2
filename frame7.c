//author RAGHAVENDRA M                FRAME SORT

#include<string.h>
#include<stdlib.h>
#include<stdio.h>
struct frame
{
	int fno;
	int random;
	int len;
	char text[4];
}frame[20],temp;

char mes[30];
main()
{
	int i,k,j,ml,fi,fcount,found,r,over,framel;
	int max_len;
	int len;
	printf("\nEnter message =");
	gets(mes);
	printf("\n Enter max frame size in characters : ");
	scanf("%d", &max_len); 
	ml=strlen(mes);
	i=0;
	fi=0;
	over=0;
	while(1)
	{
		j=0;
		len=random()%max_len;
		while(j<len)
		{ 
			frame[fi].text[j]=mes[i];
			i=i+1;
			j=j+1;
			if(mes[i]=='\0')
			{
				frame[fi].fno=fi;
				frame[fi].len=j;
				over=1;
				break;
			}  //if
		} //while j<len
		if(over == 0)
		{
			frame[fi].fno=fi;
			frame[fi].len=len;
		}
		frame[fi].random=random()%100;
		if(over==1)break;
			fi=fi+1;
	}  //while outer
 	fcount=fi+1;
 	printf("\nThe frames created are :\n");
	printf("\nSequence_No  Random_num  Length            Content");
	for(i=0;i<fcount;i++)
	{
		printf("\n%d                %d          %d            ", frame[i].fno,frame[i].random,frame[i].len);  
		for(j=0;j<frame[i].len;j++)
		{
			printf("%c",frame[i].text[j]);
		}
	}
  //SORT wrt random --  simulate network delays
	for(i=0;i<fcount;i++)
	{
		for(j=0;j<fcount;j++)
		{
			if(frame[i].random<frame[j].random)
			{
				temp=frame[i];
				frame[i]=frame[j];
				frame[j]=temp;
			}    
		}
	}
//print recieved message
	printf("\n---------------------------------------------------------------------------");
	printf("\nFrames after simulting delay at router =");
	printf("\nSequence_No  Random_num  Length            Content");
	for(i=0;i<fcount;i++)
	{
		printf("\n%d                %d          %d            ", frame[i].fno,frame[i].random,frame[i].len);  
		for(j=0;j<frame[i].len;j++)
		{
			printf("%c",frame[i].text[j]);
		}
	}
	printf("\nMessage received at receiver = ");
	for(i=0;i<fcount;i++)
	{
		for(j=0;j<4;j++)
		{
			printf("%c",frame[i].text[j]);
		}
	}  
//sort wrt serial number
	for(i=0;i<fcount;i++)
	{
		for(j=0;j<fcount;j++)
		{
			if(frame[i].fno<frame[j].fno)
			{
				temp=frame[i];
				frame[i]=frame[j];
				frame[j]=temp;
			}  
		}
	}
//print reordered message
	printf("\n---------------------------------------------------------------------------");
	printf("\nFrames re constructed =");
	printf("\nSequence_No  Random_num  Length            Content");
	for(i=0;i<fcount;i++)
	{
		printf("\n%d                %d          %d            ", frame[i].fno,frame[i].random,frame[i].len);  
		for(j=0;j<frame[i].len;j++)
		{
			printf("%c",frame[i].text[j]);
		}
	}
	printf("\n\nMessage  at receiver = ");
	for(i=0;i<fcount;i++)
	{
		for(j=0;j<frame[i].len;j++)
		{
			printf("%c",frame[i].text[j]);
		}
	}
	printf("\n");
} //main  
