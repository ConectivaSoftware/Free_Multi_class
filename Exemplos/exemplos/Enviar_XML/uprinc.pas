unit uprinc;

interface

uses
  uMulticlass,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Vcl.StdCtrls,
  Vcl.Mask;

type
  Tfrmprinc = class(TForm)
    OpenDialog: TOpenDialog;
    Label5: TLabel;
    edtxml: TMaskEdit;
    btbuscaxml: TSpeedButton;
    btcancelar: TSpeedButton;
    btenviarXML: TSpeedButton;
    Shape1: TShape;
    Label1: TLabel;
    Label2: TLabel;
    edttoken: TMaskEdit;
    Label3: TLabel;
    procedure btbuscaxmlClick(Sender: TObject);
    procedure btenviarXMLClick(Sender: TObject);
    procedure btcancelarClick(Sender: TObject);
    procedure edtxmlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmprinc: Tfrmprinc;

implementation

{$R *.dfm}

procedure Tfrmprinc.btbuscaxmlClick(Sender: TObject);
begin
   OpenDialog.Execute;
   if OpenDialog.FileName<>'' then
      edtxml.Text := OpenDialog.FileName;

end;

procedure Tfrmprinc.btcancelarClick(Sender: TObject);
begin
   Application.Terminate;
end;

procedure Tfrmprinc.btenviarXMLClick(Sender: TObject);
var
   Multiclass : TMulticlass;       // Classe para enviar arquivo
   Enviou     : boolean;
begin
   if edttoken.Text='' then
      begin
         beep;
         showmessage('Informe o TOKEN.');
         exit;
      end;
   if edtxml.Text='' then
      begin
         beep;
         showmessage('Informe o arquivo XML a ser enviado.');
         exit;
      end;
   if not FileExists(edtxml.Text) then
      begin
         beep;
         showmessage('Arquivo não encontrado.');
         exit;
      end;

   //---------------------------------------------------------------------------
   Multiclass                   := TMulticlass.create;
   Multiclass.TokenConsultaProd := edttoken.Text;
   Enviou     := Multiclass.EnviarArquivo(edtxml.Text);
   Multiclass.Free;
   //---------------------------------------------------------------------------
   if enviou then
      ShowMessage('Arquivo enviado com sucesso.')
   else
      begin
         beep;
         ShowMessage('Falha no envio do arquivo !');
      end;
   //---------------------------------------------------------------------------
end;

procedure Tfrmprinc.edtxmlKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   case key of
      vk_escape:btcancelar.Click;
   end;
end;

end.
