#include <iostream.h>
#include <graph.h>

struct point{int x; int y;};


class stack{
private:
	int *v;
	int top;
	int size;
public:
	stack(int n=200)
		{
		v=new int[n];
		top=-1;
		size=n;
		}
	int isEmpty()
		{return(top==-1)?1:0;
		}
	int isFull()
		{return(top==size)?1:0;
		}
	void Push(int n);
	void Pop();
	int Top();
	};


class queue{
private:
	int *v;
	int front;
	int rear;
	int size;
	int c;
public:
	queue(int n=150)
		{
		v=new int[n];
		size=n;
		c=0;
		rear=0;
		front=0;
		}
	int isEmpty()
		{return !c;
		}
	int isFull()
		{return(c==size)?1:0;
		}
	void Put(int a);
	int Get();
	};


void stack::Push(int n)
	{
	if (!isFull() && n>0) 
		v[++top]=n;
	}

void stack::Pop()
	{
	if(!isEmpty()) 
		--top;
	}

int stack::Top()
	{
	if (!isEmpty())
		return v[top]
	else
		return -666;
	}

void queue::Put(int a)
	{
	if(!isFull() && a>0)
		{
		v[rear++]=a;
		c++;
		rear=(rear>n)?0:rear;
		}
	}

int queue::Get()
	{
	if (!isEmpty())
		{
		c--;
		int temp;
		temp=v[front++];
		if (front>n) 
			front=0;
		return temp;
		}
	else
		return -666;
	}


void main()
	{
	stack s;
	int num1=-1;
	int num2=0;	

	printf("Enter stack size:");
	scanf("%d",num2);
	stack t(num2);

	s.Push(5);
	s.Push(6);
	s.Get();

	num2=s.top();

	if (num2==6)
		printf("Its true!");

	t.Push(10);
	t.Pop();

	queue q(10);

	printf("Enter int number:");
	scanf("%d",num1);
	q.Put(num1);

	q.Put(12);
	num1=q.get();
	}
