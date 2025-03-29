unit uenviarXML;

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
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Vcl.Mask;

type
  TfrmenviarXML = class(TForm)
    fundo: TShape;
    Shape2: TShape;
    Label20: TLabel;
    Label5: TLabel;
    edtxml: TMaskEdit;
    btbuscaxml: TSpeedButton;
    btenviarXML: TSpeedButton;
    OpenDialog: TOpenDialog;
    btcancelar: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure btbuscaxmlClick(Sender: TObject);
    procedure btenviarXMLClick(Sender: TObject);
    procedure btcancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtxmlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmenviarXML: TfrmenviarXML;

implementation

{$R *.dfm}

procedure TfrmenviarXML.btbuscaxmlClick(Sender: TObject);
begin
   OpenDialog.Execute;
   if OpenDialog.FileName<>'' then
      edtxml.Text := OpenDialog.FileName;
end;

procedure TfrmenviarXML.btcancelarClick(Sender: TObject);
begin
   frmenviarXML.Close;
end;

procedure TfrmenviarXML.btenviarXMLClick(Sender: TObject);
var
   Multiclass : TMulticlass;       // Classe para enviar arquivo
   Enviou     : boolean;
begin
   //---------------------------------------------------------------------------
   Multiclass := TMulticlass.create;
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

procedure TfrmenviarXML.edtxmlKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   case key of
      vk_escape:btcancelar.Click;
   end;
end;

procedure TfrmenviarXML.FormActivate(Sender: TObject);
begin
   fundo.Align := alClient;
end;

procedure TfrmenviarXML.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   frmenviarXML.Release;
end;

end.
