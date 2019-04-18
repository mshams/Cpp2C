
class Time{
private:
	int h; 	int m; 	int s;
public:
	Time(int r=0)
	   {
	   h=r;  m=r;  s=r;
  	   }

	void AddH(int n)
	   {
	   h= h + n;
	   h= h % 24;
	   }
	   
	void AddM(int n)
	   {
	   m= m + n;
	   h= h + m /60;
	   m= m % 60;
	   }

	void AddS(int n)
	   {
	   s= s + n;
	   m= m + s / 60;
	   s= s % 60;
	   }	   

	void Set(int n1, int n2, int n3);
	void Show();
	};

void Time::Set(int n1, int n2, int n3)
	{
	h=n1;  m=n2;  s=n3;
	}

void Time::ShowSeconds()
	{
	int sum=0;
	sum= h * 3600 + m * 60 + s;
	printf("Total seconds= %d\n", sum );
	}

void main()
	{
	int a=0;
	Time t(2);

	printf("Enter number:");
	scanf("%d",a);
	
	t.Set(a,30,12);

	t.AddH(3);
	t.AddM(a);
	t.AddS(55);
	
	t.ShowSeconds();

	}
