struct pixel{
	int R;
	int G;
	int B;
};

class image{
private:
	int *s;
	int picsize;
public:
	image(int count=1024)
		{
		s=new pixel[count];
		picsize=count;
		}

	void Set(pixel p,int i);
	pixel Get(int i);
	};

void image::Set(pixel p,int i)
	{
	if (!isFull() && i<picsize) 
		s[i]=p;
	}

pixel image::Get(int i)
	{
	if(i<picsize) 
		return s[i];
	}


void main()
	{
	int n=0;
	int i=0;
	pixel p;

	printf("Enter image size:");
	scanf("%d",n);

	image img1(n);
	image img2;

	printf("How many pixels:");
	scanf("%d",n);

	while (i<n)
	   {
	   printf("Enter Red number:");
	   scanf("%d",p.R);	

	   printf("Enter Green number:");
	   scanf("%d",p.G);

	   printf("Enter Blue number:");
	   scanf("%d",p.B);

	   img1.Set(p,i);
	   img2.Set(p,i++);
	   }

	printf("Enter pixel number:");
	scanf("%d",i);
	
	p=img1.Get(i);

	if (p.R==255 && p.G==255 && p.B==255)
		printf("This pixel is black!");
	}
