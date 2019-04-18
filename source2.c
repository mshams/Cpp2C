typedef struct pixel{
int R;
int G;
int B;
}
;

typedef struct image{
/*private:*/
int *s;
int picsize;
/*public:*/
void imageimage(image *this,int  count){
this->s=(pixel *)malloc(sizeof(pixel)*count);
this->picsize=count;
}

}
;

void  imageSet(image *this,pixel  p,int  i){
if(!isFull()&& i<this->picsize)
this->s[i]=p;
}

pixel  imageGet(image *this,int  i){
if(i<this->picsize)
return this->s[i];
}


void main(){
int n=0;
int i=0;
pixel p;

printf("Enter image size:");
scanf("%d",n);

image img1;
imageimage (&img1,n);
image img2;
imageimage (&img2,1024);

printf("How many pixels:");
scanf("%d",n);

while(i<n){
 printf("Enter Red number:");
 scanf("%d",p.R);

 printf("Enter Green number:");
 scanf("%d",p.G);

 printf("Enter Blue number:");
 scanf("%d",p.B);

 img1.imageSet(p,i);
 img2.imageSet(p,i++);
}

printf("Enter pixel number:");
scanf("%d",i);

p=img1.imageGet(i);

if(p.R==255 && p.G==255 && p.B==255)
printf("This pixel is black!");
}
