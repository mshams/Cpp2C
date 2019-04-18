/*#include <iostream.h>*/
/*#include <graph.h>*/

typedef struct point{
int x;
int y;
}
;


typedef struct stack{
/*private:*/
int *v;
int top;
int size;
/*public:*/
void stackstack(stack *this,int  n){
this->v=(int *)malloc(sizeof(int)*n);
this->top=-1;
this->size=n;
}
int  stackisEmpty(stack *this){
return(this->top==-1)?1:0;
}
int  stackisFull(stack *this){
return(this->top==this->size)?1:0;
}
}
;


typedef struct queue{
/*private:*/
int *v;
int front;
int rear;
int size;
int c;
/*public:*/
void queuequeue(queue *this,int  n){
this->v=(int *)malloc(sizeof(int)*n);
this->size=n;
this->c=0;
this->rear=0;
this->front=0;
}
int  queueisEmpty(queue *this){
return !this->c;
}
int  queueisFull(queue *this){
return(this->c==this->size)?1:0;
}
}
;


void  stackPush(stack *this,int  n){
if(!stackisFull()&& n>0)
this->v[++this->top]=n;
}

void  stackPop(stack *this){
if(!stackisEmpty())
--this->top;
}

int  stackTop(stack *this){
if(!stackisEmpty())
return this->v[this->top]
else
return -666;
}

void  queuePut(queue *this,int  a){
if(!queueisFull()&& a>0){
this->v[this->rear++]=a;
this->c++;
this->rear=(this->rear>this->n)?0:this->rear;
}
}

int  queueGet(queue *this){
if(!queueisEmpty()){
this->c--;
int temp;
temp=this->v[this->front++];
if(this->front>this->n)
this->front=0;
return temp;
}
else
return -666;
}


void main(){
stack s;
stackstack (&s,200);
int num1=-1;
int num2=0;

printf("Enter stack size:");
scanf("%d",num2);
stack t;
stackstack (&t,num2);

s.stackPush(5);
s.stackPush(6);
s.queueGet();

num2=s.top();

if(num2==6)
printf("Its true!");

t.stackPush(10);
t.stackPop();

queue q;
queuequeue (&q,10);

printf("Enter int number:");
scanf("%d",num1);
q.queuePut(num1);

q.queuePut(12);
num1=q.get();
}
