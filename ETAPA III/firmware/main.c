#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <pthread.h>
#include <sched.h>
#include <time.h>
#include <semaphore.h>

#define NUM_THREADS (3)
#define USER_PER_MSEC (1000)

int abortTest = 0;
double start_time;

sem_t semCTL, semNAV;

typedef struct{
    int threadidx;
    int majorPeriods;
}threadParams_t; 


double getTimeMsec();


/*
void *funcNAV(void *threadp)
{
    double event_time, run_time=0.0;
    int limit=0, release=0, cpucore, i;
    threadparams_t *threadParams=(threadParams_t*)threadp;
    unsigned int requred_test_cycles;
    
    while(!abortTest)
    {
       sem_wait(&semNAV);
       
       if(abortTest)
         break;
       else
       	release++;
       	
       	do
       	{
       	    for(int x=0; i)
       	}
     
    
    }
}
*/

/*********************************************
*********************************************/

//		Sequencer

void *sequencer(void *threadp)
{

  int i;
  int MajorPeriodCnt = 0;
  double event_time;
  
  threadParams_t *threadParams = (threadParams_t *)threadp;
  
  printf("Starting sequencer:[S1, T1=20, C1=10],[S2, T2=50, C2=20],u=0.9,LCM=100\n");
  start_time = getTimeMsec();
  
  do
  {
      printf("\n****CI t=%lf\n",event_time=getTimeMsec()-start_time);
      sem_post(&semNAV);sem_post(&semCTL);
      
      usleep(20*USER_PER_MSEC);sem_post(&semCTL);
      printf("t=%lf\n",event_time=getTimeMsec()-start_time);
      
      usleep(20*USER_PER_MSEC);sem_post(&semCTL);
      printf("t=%lf\n",event_time=getTimeMsec()-start_time);
      
      usleep(20*USER_PER_MSEC);sem_post(&semNAV);
      printf("t=%lf\n",event_time=getTimeMsec()-start_time);
      
      usleep(20*USER_PER_MSEC);sem_post(&semCTL);
      printf("t=%lf\n",event_time=getTimeMsec()-start_time);
      
      usleep(20*USER_PER_MSEC);
      MajorPeriodCnt ++;
      
  }while(MajorPeriodCnt < threadParams->majorPeriods);
  
  abortTest = 1;
  sem_post(&semNAV);sem_post(&semCTL);
}

/*********************************************
*********************************************/

//	get time 
double getTimeMsec()
{
  struct timespec event_ts = {0,0};
  
  clock_gettime(CLOCK_MONOTONIC, &event_ts);
  return ((event_ts.tv_sec)*1000.0)+((event_ts.tv_nsec)/10000000.0);

}

//	print scheduler
void print_scheduler()
{
   int schedType;
   
   schedType = sched_getscheduler(getpid());
   
   switch(schedType)
   {
       case SCHED_FIFO:
       	    printf("pthread policy is SCHED_FIFO\n");
       	    break;
       case SCHED_OTHER:
       	    printf("pthread policy is SCHED_OTHER\n");
       	    break;
       case SCHED_RR:
       	    printf("pthread policy is SCHED_RR\n");
       	    break;
       default:
            printf("Pthread policy UNKNOWN\n");
   }
}

int main()
{

  system("clear");  
  
  printf("\n\n\n");
  
  int i, rc, scope;
  cpu_set_t threadcpu;
  pthread_t threads[NUM_THREADS];
  threadParams_t threadParams[NUM_THREADS]; 
  pthread_attr_t rt_sched_attr[NUM_THREADS];
  pthread_attr_t main_attr;
  int rt_max_prio, rt_min_prio;
  pid_t mainpid;
  cpu_set_t allcpuset;
  
  abortTest = 0; 
  
  struct sched_param rt_param[NUM_THREADS];
  struct sched_param main_param; 
  
  printf("system has %d processors configured and %d available.\n", get_nprocs_conf(),get_nprocs());
  
  CPU_ZERO(&allcpuset);
  for(i=0;i<NUM_THREADS;i++)
  	CPU_SET(i,&allcpuset);
  
  if(&semCTL,0,0){printf("Failed o initializate semCTL semaphore\n");exit(-1);}
  if(&semNAV,0,0){printf("Failed o initializate semNAV semaphore\n");exit(-1);}
  
  mainpid = getpid();
  rt_max_prio = sched_get_priority_max(SCHED_FIFO);
  rt_min_prio = sched_get_priority_min(SCHED_FIFO);
  
  rc=sched_getparam(mainpid,&main_param);
  main_param.sched_priority = rt_max_prio;
  rc = sched_setscheduler(getpid(),SCHED_FIFO,&main_param);
  if(rc<0)perror("main_param");
  
  print_scheduler();
  
  pthread_attr_getscope(&main_attr,&scope);
  
  if(scope == PTHREAD_SCOPE_SYSTEM)
  	printf("PTHREAD_SCOPE_SYSTEM\n");
  else if(scope == PTHREAD_SCOPE_PROCESS)
  	printf("PTHREAD_SCOPE_PROCESS");
  else
	printf("PTHREAD_SCOPE_UNKNOWN");

  printf("rt_max_prio: %d\n",rt_max_prio);
  printf("rt_min_prio: %d\n",rt_min_prio);
  
  for(i=0; i<NUM_THREADS; i++)
  {
  	CPU_ZERO(&threadcpu);
  	CPU_SET(1,&threadcpu);
  	
  	rc = pthread_attr_init(&rt_sched_attr[i]);
  	rc = pthread_attr_setinheritsched(&rt_sched_attr[i],PTHREAD_EXPLICIT_SCHED);
  	rc = pthread_attr_setschedpolicy(&rt_sched_attr[i],SCHED_FIFO); 
  	rc = pthread_attr_setaffinity_np(&rt_sched_attr[i],sizeof(cpu_set_t),&threadcpu);
  	
  	rt_param[i].sched_priority=rt_max_prio-i;
  	pthread_attr_setschedparam(&rt_sched_attr[i],&rt_param[i]);
  	
  	threadParams[i].threadidx=i;
  }
  
  printf("Service threads will run on %d CPU cores\n",CPU_COUNT(&threadcpu));

  printf("\n\n---------------------------------\n");
  printf("\t\t\t\t\nINIT CONTOL SYSTEm uav\n");
  printf("\n---------------------------------\n\n");
  
  usleep(300000);
  printf("INIT .... \n\n");
  
  threadParams[0].majorPeriods=300;
  
  rc = pthread_create(&threads[0],&rt_sched_attr[0]/*(void*)0*/,sequencer,(void*)&(threadParams[0]));


 pthread_join(threads[0],NULL);
/*
  for(i=0; i<NUM_THREADS;i++)
  {
     pthread_join(threads[i],NULL);
  }
*/  
  printf("\nEND .... \n\n");
  return 0;
}
