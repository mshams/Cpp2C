
typedef struct Time{
/*private:*/
int h;
int m;
int s;
/*public:*/
void TimeTime(Time *this,int  r){
 this->h=r;
this->m=r;
this->s=r;
 
}

void  TimeAddH(Time *this,int  n){
 this->h= this->h + n;
 this->h= this->h % 24;
}
 
void  TimeAddM(Time *this,int  n){
 this->m= this->m + n;
 this->h= this->h + this->m /60;
 this->m= this->m % 60;
}

void  TimeAddS(Time *this,int  n){
 this->s= this->s + n;
 this->m= this->m + this->s / 60;
 this->s= this->s % 60;
}

}
;

void  TimeSet(Time *this,int  n1,int  n2,int  n3){
this->h=n1;
this->m=n2;
this->s=n3;
}

void  TimeShowSeconds(Time *this){
int sum=0;
sum= this->h * 3600 + this->m * 60 + this->s;
printf("Total seconds= %d\n",sum);
}

void main(){
int a=0;
Time t;
TimeTime (&t,2);

printf("Enter number:");
scanf("%d",a);

t.TimeSet(a,30,12);

t.TimeAddH(3);
t.TimeAddM(a);
t.TimeAddS(55);

t.TimeShowSeconds();

}
