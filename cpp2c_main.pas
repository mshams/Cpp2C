unit cpp2c_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, System.ComponentModel, Borland.Vcl.Grids, Borland.Vcl.StdCtrls,
  Borland.Vcl.AppEvnts,strutils, Borland.Vcl.ComCtrls, Borland.Vcl.ExtCtrls,
  about;
  

type
  intArry=array of integer;
  strArry=array of string;

  TMain = class(TForm)
    gridVars: TStringGrid;
    txtSrc: TMemo;
    txtPre: TMemo;              
    gridTypes: TStringGrid;
    btnGo: TButton;
    ev: TApplicationEvents;
    gridPre: TStringGrid;
    btnPre: TButton;
    prg: TProgressBar;
    grp1: TGroupBox;
    grp2: TGroupBox;
    grp3: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    btnCnv: TButton;
    txtDst: TMemo;
    grp4: TGroupBox;
    grp5: TGroupBox;
    Panel1: TPanel;
    Splitter3: TSplitter;
    grp6: TGroupBox;
    grp7: TGroupBox;
    Panel2: TPanel;
    btnHlp: TButton;
    btnLoad: TButton;
    btnsave: TButton;
    dlgopen: TOpenDialog;
    dlgsave: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure evException(Sender: TObject; E: Exception);
    procedure parse(s:string);
    procedure btnPreClick(Sender: TObject);
    procedure btnCnvClick(Sender: TObject);
    procedure translate(s:string);
    function Query(search:array of string):intArry;
    function ParamMake(search:array of string):string;
    function VarExtract(st:string):strArry;
    procedure btnHlpClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnsaveClick(Sender: TObject);
    procedure gridVarsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    procedure Resets;
    { Private declarations }
  public
    { Public declarations }
  end;

const
 c=['a'..'z','A'..'Z'];
 n=[0..9];
 e=['{',';','(',',',')','=']; //Variable enders
 sym=['{',';','(',',',')','=','}','[',']','+','-','?','!',' ',':','.','/','%','>','<'];
// reserv=['[',']',':','::','{','}',';','.','>>','<<','>','<','!','||','&&','?',
//    '!=','=','==','%','*','/','--','++','-','+','(',')','if','else','return','new'];

var
  Main: TMain;
  cf,cc:string; //cc=current class   cf=current function
implementation

{$R *.nfm}
function Mid(const s:string; a,z:integer):string;
begin result:=MidStr(s,a,z-a+1); end;

function iif(f:boolean; Atrue,Bfalse:variant):variant;
begin if f=true then result:=Atrue  else result:=Bfalse; end;

procedure add(grid:TStringGrid; value:array of string);
var   i,j: Integer;
  dup: Boolean;
begin
//dup:=true;
//add(vars,['str1','str2']);
{if (value[6]='1') and (value[0].IndexOfAny('::')=0) then
  begin     
  value[0]:=cc+'::'+value[0];
  end; }
if value[0][1]='*' then //correct pointer types
  begin
  value[0]:=mid(value[0],2,value[0].length);
  value[1]:=value[1]+' *';
  end;
for I := 1 to grid.RowCount  - 2 do
  begin
  dup:=true;
  for j := 0 to length(value) - 1 do
    if grid.Cells[j,i]<>value[j] then dup:=false;
  if dup then break;
  end;
if not dup then
  begin
  grid.Rows[grid.RowCount-1].Clear;
  for i:= 0 to length(value)-1 do
    grid.Cells[i,grid.RowCount-1]:=value[i];
  grid.RowCount:=1+grid.RowCount;
  grid.Rows[grid.RowCount-1].Clear;
  end;
end;

function infunc(const s:string; n:integer):char;
var  x,i: Integer;
begin
x := 0;
for I := n-1 downto 1 do
  if s[i]='(' then x:=x+1;
result:=iif(odd(x), '2', '1');
end;

function inString(const s:string; n:integer):boolean;
var  x,i: Integer;
begin
x := 0;
for I := n-1 downto 1 do
  if s[i]='"' then x:=x+1;
result:=odd(x);
end;

procedure TMain.parse(s:string);
var
  x,i,p1,p2,j,k,l: Integer;
  v: string;
begin
i:=0;p1:=0;p2:=0;j:=0;k:=0;l:=0;
v:='';
x:=1;
for l := 3 to s.Length do
  if not s.Contains('"')or not inString(s,l) then
    for I := 0 to gridTypes.RowCount - 2 do
      begin
      v := gridTypes.Cells[0,i];
      p1:= PosEx(v,mid(s,1,l),x);
      p2:= p1 + v.Length;
      if (not inString(s,p1)) and (p1>0) and ((s[p2]=' ')or (cc=mid(s,p1,p2-1))) then  //start found
        for j := p2+1 to s.Length do   //search end
          if s[j] in e then
            begin
            if cc=mid(s,p1,p2-1) then  //constructor
              begin
              cf:= cc+'::'+cc;
              add(gridVars, [cf, '', mid(s,p2,s.Length-1),'','',cc,'1' ]);
              x:= p2+1;
              break;
              end
            else if (v='class')or(v='struct') then  //class
              begin
              cf:= '';
              cc:= mid(s,p2+1,j-1);
              add(gridTypes,[cc]);
              add(gridVars,[cc,v]);
              Exit;
              end
            else if (s[j]=('('))and(cf<>'main') then   //function
              begin
              cf:= mid(s,p2+1,j-1);
              if cf='main' then
                cc:=''
              else if not cf.contains('::') then
                cf:=cc+'::'+cf
              else  cc:=mid(cf,1,cf.IndexOfAny([':',':']));
              add(gridVars, [cf, mid(s,p1,p2), mid(s,j,s.Length-1),'','',cc,'1' ]);
              x:= j+1;
              break;
              end
            else
              begin
              for k := j to s.Length  do
                if (s[k] in e)and(s[k]<>'=')and(s[k]<>'(') then
                  begin
                  add(gridVars, [mid(s,p2+1,j-1), mid(s,p1,p2), mid(s,j,k-1),cf, iif(cf<>'',infunc(s,j+1),''),cc]);
                  x:= j+1;
                  break;
                  end;
              break;
              end;
            break;
            end;
      end;
end;

function TMain.Query(search:array of string):intArry;
var  k,j: Integer;
     match:boolean;
begin
//finds matching Rows of 'Vars' to search template
//and returns row numbers in array
//'-' in 'Search' is meaning that this cell isnt required!
setlength(result,0);
for k := 1 to gridVars.RowCount  - 2 do
  begin
  match:=true;
  for j := 0 to length(search) - 1 do
    if (trim(gridVars.Cells[j,k])<>trim(search[j]))and(search[j]<>'-') then match:=false;
  if match then
    begin
    SetLength(result,length(result)+1);
    result[length(result)-1]:=k;
    end;
  end;
end;

function TMain.ParamMake(search:array of string):string;
var  i: Integer; fnd:intArry;
begin
//uses 'Query' to make functions parameters lists
fnd:=Query(search);
for i := 0 to length(fnd) - 1 do
  result:=result + ','+gridVars.Cells[1,fnd[i]] + ' ' + gridVars.Cells[0,fnd[i]];
end;

function TMain.VarExtract(st:string):strArry;  //found all variables in line
var  i,p: Integer; tmp:string;
begin
//result:=[''];
setlength(result,0);
p:=1;
for i := 1 to st.Length do
  if st[i] in sym then
    begin
    tmp:=trim(mid(st,p,i-1));
//    if (tmp<>'')and(tmp<>'if')and(tmp<>'return')and(tmp<>'else')and(tmp<>'new')and
//            (not StrToIntDef(tmp[1],-1) in [0..9]) then   
    if tmp<>'' then
      begin
      setlength(result ,length(result)+1);
      result[length(result)-1]:=tmp;
      end;
    setlength(result ,length(result)+1);
    result[length(result)-1]:=st[i];               
    p:=i+1;
    end;
end;

procedure TMain.translate(s:string);
var
  x,i,p1,p2,j,k,l,idx: Integer;
  v,param,a,b: string;
  ia: intArry;
  sa: strArry;
begin
x:=1;
if s.contains('public:')or s.contains('private:')or s.contains('protected:')or
   s.contains('#include') then
   begin
   txtdst.lines.Add('/*'+s+'*/');
   exit;
   end
else if s.contains('typedef') then s:=ReplaceText(s,'typedef','');
//if s.Contains('struct ') then s:=ReplaceText(s,'struct ','typedef struct ');
//if s.Contains('class ') then s:=ReplaceText(s,'class ','typedef class ');
if  (s.Length<4)or(s.contains('printf'))or(s.contains('scanf'))or
    (s.contains('else')) then
  begin
  txtdst.Lines.Add(s);
  exit;
  end;

for l := 1 to s.Length do
  //if not s.Contains('"'){or not inString(s,l) }then
    begin
          
    for I := 0 to gridTypes.RowCount - 2 do
      begin
      
      v := gridTypes.Cells[0,i];
      p1:= PosEx(v,mid(s,1,l),x);
      p2:= p1 + v.Length;
      if (not inString(s,p1)) and (p1>0) and ((s[p2]=' ')or(cc=mid(s,p1,p2-1))) then  //start found
        begin
        for j := p2+1 to s.Length do   //search end

          if s[j] in e then
            begin
            
            if cc=mid(s,p1,p2-1) then  //class constructor
              begin
              cf:= cc+cc;
              param:=ParamMake(['-','-','-',cc+'::'+cc,'2']);
              txtdst.Lines.Add('void '+cf+'('+cc+' *this'+param+'){');
              //x:= p2+1;
              //break;
              exit;
              end
            else if (v='class')or(v='struct') then  //class
              begin
              cf:= '';
              cc:= mid(s,p2+1,j-1);
              add(gridTypes,[cc]);
              //add(vars,[cc,v]);
              txtdst.Lines.Add('typedef struct '+cc+'{');
              Exit;
              end
            else if (s[j]=('('))and(cf<>'main') then   //function
              begin
              cf:= mid(s,p2+1,j-1);
              
              if not s.Contains('{') then
                exit
              else if cf='main' then
                cc:=''
              else if not cf.contains('::') then
                cf:=cc+cf
              else
                begin
                cc:=mid(cf,1,pos('::',cf)-1);
                cf:=replacetext(cf,'::','');
                end;
                
              if s.Contains('main(') then
                begin
                txtdst.Lines.Add(s);
                exit;
                end;
                
              idx:=query([cc+'::'+mid(cf,cc.Length+1,cf.Length)])[0];
              //param:=trim(mid(gridVars.cells[2,idx],2,50));
              param:=ParamMake(['-','-','-',cc+'::'+mid(cf,cc.Length+1,cf.Length),'2']);
              txtdst.Lines.Add(gridVars.cells[1,idx]+' '+cf+'('+cc+' *this'+ param +'){');
              //x:= j+1;
              //break;
              exit;
              end
              
            else
              begin  
                                   //vaiable/function proto/object
              for k := j to s.Length  do
                if (s[k] in e)and(s[k]<>'=')and(s[k]<>'(') then
                  begin
                  a:=mid(s,p2+1,j-1);
                  b:=mid(s,p1,p2-1);
                  //add(vars, [mid(s,p2+1,j-1), mid(s,p1,p2), mid(s,j,k-1),cf, iif(cf<>'',infunc(s,j+1),''),cc]);
                  //if gridVars.cells[4,query([a,b ,'-',cf])[0]]='2' then
                  if gridVars.Cols[0].IndexOf(b)>0 then
                    begin                               //object variable
                    txtdst.Lines.Add(b+' '+a+';');
                    idx:=query([a,b ,'-',cf])[0];
                    param:=mid(gridVars.cells[2,idx],2,20);  //has param
                    if param='' then
                      begin
                      if length(query(['-','-','-',b+'::'+b,'2']))=0 then
                        exit;  //is struct or hasnt constructor parameter

                      idx:=query(['-','-','-',b+'::'+b,'2'])[0];
                      param:=mid(gridVars.cells[2,idx],2,20);   //default constructor param
                      end;
                    txtdst.Lines.Add(b+b+' (&'+a+','+param +');');
                    end
                  else                     
                    begin   //all other variable declaretions
                    //param:=
                    txtdst.Lines.Add(s);
                    end;
                  //x:= j+1;
                  //break;              
                  exit;
                  end;
              break;
              end;
              
            break;
            end
        end;
      end; {of grid row}
      
    end;
  //else  {of contain '"'}
    //begin
    //txtdst.Lines.Add(s);
    //exit;
    //end;

//v :=
ia:=query(['-','-','-','-','-',iif(cc<>'',cc,'-'),'1']); //find function protos
for I := 0 to length(ia) - 1 do     
  begin
  a:=gridVars.cells[0,ia[i]];     //className::funcName   
  b:=gridVars.cells[5,ia[i]];     //className
  v:=mid(a,b.Length+3,a.Length);  //funcName
  if (b<>'')and(s.contains(v+'(')) then    //if has function call
    begin
    s:=ReplaceText(s,v+'(', ReplaceText(a,'::','')+'('); //replace class function calls
    break;
    end;
  end;

p1:=0; p2:=0; param:=''; v:=''; a:=''; b:='';

sa:=VarExtract(s);                 //Add 'this->' to class variable 
for i := 0 to length(sa)-1 do
  begin
  a:=sa[i];
  if (not (a[1] in sym))and(gridTypes.cols[0].indexOf(a)=-1) then  //if a is not symbol 
    begin
    b:=cc+'::'+mid(cf,cc.Length+1,cf.Length);  
    ia:=query(a);
    p1:=0;
    if (cc<>'')and(length(ia)>0)then
      begin
      for j in ia do
        if (gridVars.cells[5,j]=cc)and(gridVars.cells[3,j]=b)then p1:=1;
      if p1<>1 then
        begin
        sa[i]:='this->'+sa[i];
        end;
      end;
    end;
  end;

s:='';
for I := 0 to length(sa)-1 do s:=s+sa[i];  //merge splited variables
              
if sa[2]='new' then  //convert 'new' to 'malloc' in correct declaretion
  begin             //Convert to default scheme of malloc
  s:=sa[0]+'=('+sa[4]+' *)malloc(sizeof('+sa[4]+')*'+sa[6]+');';
  end;
txtdst.Lines.Add(s);    
end;

procedure TMain.btnCnvClick(Sender: TObject);
var   I: Integer;
begin
try
  txtDst.Clear;
  prg.Position:=0;
  prg.Max:=txtPre.Lines.Count;
  for I := 0 to txtPre.Lines.Count - 1 do
    begin
    translate(txtPre.Lines.Strings[i]);
    prg.StepIt; //Position:=i;
    end;
except
  on E: Exception do raise Exception.Create(sender.ToString.Split([' '])[0]+' : '+E.Message+#13#10+
        'Line['+i.ToString+']: '+txtPre.Lines.Strings[i]  );
end;
end;

procedure TMain.btnGoClick(Sender: TObject);
var   I: Integer;
begin
try
  Resets;
  prg.Position:=0;
  prg.Max:=txtPre.Lines.Count;
  for I := 0 to txtPre.Lines.Count - 1 do
    begin
    parse(txtPre.Lines.Strings[i]);
    prg.StepIt; //Position:=i;
    end;
  btnCnv.Enabled:=true;
except
  on E: Exception do raise Exception.Create(sender.ToString.Split([' '])[0]+' : '+E.Message+#13#10+
        'Line['+i.ToString+']: '+txtPre.Lines.Strings[i]  );  
end;
end;

procedure TMain.btnHlpClick(Sender: TObject);
begin
about.AboutBox.Showmodal;
end;

procedure TMain.btnLoadClick(Sender: TObject);
begin             
DlgOpen.InitialDir:=ExtractFileDir(application.ExeName);
if DlgOpen.Execute(application.Handle) then
  txtSrc.Lines.LoadFromFile(DlgOpen.FileName);
end;

procedure TMain.btnPreClick(Sender: TObject);
var   I: Integer;
begin
txtPre.text:=txtSrc.text;
while Containstext(txtPre.text,'  ') do txtPre.text:=ReplaceText(txtPre.text,'  ',' ');
prg.Position:=0;
prg.Max:=gridPre.RowCount-1;
for I := 0 to gridPre.RowCount-2 do
  begin
  txtPre.text:=ReplaceText(txtPre.text,gridPre.cells[0,i],gridPre.cells[1,i]);
  prg.StepIt; //Position:=i;
  end;
btngo.Enabled:=true;
end;

procedure TMain.btnsaveClick(Sender: TObject);
begin
DlgSave.InitialDir:=ExtractFileDir(application.ExeName);
if DlgSave.Execute then
  txtSrc.Lines.SaveToFile(DlgSave.FileName); 
end;                   

procedure TMain.Resets;
var i:integer;
begin
gridVars.RowCount:=2;
gridTypes.RowCount:=1;
for I := 0 to gridVars.RowCount - 1 do  gridVars.rows[i].clear;
for I := 0 to gridTypes.RowCount - 1 do  gridTypes.rows[i].clear;
               
with gridVars do
  begin
  Cells[0, 0] := 'Name';
  Cells[1, 0] := 'Type';
  Cells[2, 0] := 'Param';
  Cells[3, 0] := 'Func owner';
  Cells[4, 0] := '1code/2Proto';
  Cells[5, 0] := 'Class owner';
  Cells[6, 0] := 'Is func';
end;
cc:=''; cf:='';     

add(gridTypes,['class']);
add(gridTypes,['struct']);
//add(types,['int *']);
add(gridTypes,['int']);
add(gridTypes,['void']);
//add(types,['float *']);
add(gridTypes,['float']);               
end;

procedure TMain.evException(Sender: TObject; E: Exception);
begin
MessageBox(application.Handle,e.Message,'Error',MB_ICONERROR);
end;

procedure TMain.FormCreate(Sender: TObject);
begin
Resets;
//add(pre,['  ',' ']);
add(gridPre,[#9,'']);
add(gridPre,[' ;',';']);
add(gridPre,['; ',';']);
add(gridPre,[';'#13#10,';']);
add(gridPre,[';',';'#13#10]);
add(gridPre,[' ]',']']);
add(gridPre,['] ',']']);
add(gridPre,[' [','[']);
add(gridPre,['[ ','[']);
add(gridPre,[' }','}']);
add(gridPre,['} ','}']);
add(gridPre,[' {','{']);
add(gridPre,['{ ','{']);
add(gridPre,['}'#13#10,'}']);
add(gridPre,['}','}'#13#10]);
add(gridPre,['{'#13#10,'{']);
add(gridPre,['{','{'#13#10]);
add(gridPre,[#13#10'}','}']);
add(gridPre,['}',#13#10'}']);
add(gridPre,[#13#10'{','{']);
//add(pre,['{',#13#10'{']);
add(gridPre,[' )',')']);
add(gridPre,[') ',')']);
add(gridPre,[' (','(']);
add(gridPre,['( ','(']);
add(gridPre,[', ',',']);
add(gridPre,[' ,',',']);
end;

procedure TMain.gridVarsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var i,sum,dif:integer;
begin
sum:=0; dif:=0;
for i:=0 to 6 do sum:=sum+gridvars.ColWidths[i];
dif:=gridvars.Width-sum-30;
for i:=0 to 6 do gridvars.ColWidths[i]:=gridvars.ColWidths[i]+(gridvars.ColWidths[i]*dif div sum);
end;

end.
