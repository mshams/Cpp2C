unit About;

interface

uses Forms, StdCtrls, ExtCtrls, Graphics, Classes, Controls,
  System.ComponentModel;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    OKButton: TButton;
    Label1: TLabel;
    Image1: TImage;
    Image2: TImage;
    Comments: TLabel;
    Memo1: TMemo;
    procedure OKButtonClick(Sender: TObject);
    procedure Image2DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.dfm}

procedure TAboutBox.Image2DblClick(Sender: TObject);
begin
image1.Visible:=not image1.Visible;
image2.Visible:=not image1.Visible;
end;

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
AboutBox.Close;
end;

end.

