unit teste;

interface

uses

  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  umulticlass;

procedure TForm1.Button1Click(Sender: TObject);
var
   Multiclass : TMulticlass;
begin

  // Multiclass := TMulticlass.create;
  {
   try
    Multiclass.TokenConsultaProd :=  '00000;';
    Multiclass.ConsultarProduto('1111111111111');
   finally
    Multiclass.Free;
   end;
}

end;

end.
