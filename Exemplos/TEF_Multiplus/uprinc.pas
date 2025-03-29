unit uprinc;

interface

uses
  uMulticlass,
  uKSTypes,
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
  Vcl.Mask,
  Vcl.Buttons;

type
  Tfrmprinc = class(TForm)
    Shape1: TShape;
    Label1: TLabel;
    Label5: TLabel;
    edtvalor: TMaskEdit;
    btenviarXML: TSpeedButton;
    btcancelar: TSpeedButton;
    Label10: TLabel;
    cbformapgto: TComboBox;
    Label9: TLabel;
    edtqtdeparcelas: TMaskEdit;
    Shape2: TShape;
    Label2: TLabel;
    Label307: TLabel;
    edtcnpjMultiPlus: TMaskEdit;
    Label308: TLabel;
    edtLojaMultiPlus: TMaskEdit;
    Label340: TLabel;
    edtPDVMultiPlus: TMaskEdit;
    procedure btcancelarClick(Sender: TObject);
    procedure edtvalorKeyPress(Sender: TObject; var Key: Char);
    procedure btenviarXMLClick(Sender: TObject);
    procedure edtqtdeparcelasKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmprinc: Tfrmprinc;

implementation

{$R *.dfm}

procedure Tfrmprinc.btcancelarClick(Sender: TObject);
begin
   Application.Terminate;
end;

procedure Tfrmprinc.btenviarXMLClick(Sender: TObject);
var
   valor            : real;
   Qtde             : integer;
   Multiclass       : TMulticlass;   // Classe para transacionar - Uses -> uMulticlass
   RetornoPagamento : TRetornoPagamentoTEF; // Para pegar o retorno do pagamento TEF - Uses ->uKSTypes
begin
   Qtde  := strtointdef(edtqtdeparcelas.Text,0);
   valor := strtofloatdef(edtvalor.Text,0);
   if valor<=0 then
      exit;
   if cbformapgto.ItemIndex=0 then
      begin
         beep;
         showmessage('Essa forma de pagamento ainda não está ativa na Multiplus.'+#13+
                     'Em breve estaremos implementando. Selecione outra.');
         exit;
      end;
   //---------------------------------------------------------------------------
   Multiclass       := TMulticlass.create;
   RetornoPagamento := Multiclass.TransacionarMultiplus(valor,cbformapgto.Text,Qtde,edtcnpjMultiPlus.Text,edtLojaMultiPlus.Text,edtPDVMultiPlus.Text);
   Multiclass.Free;
   //---------------------------------------------------------------------------
   if RetornoPagamento.Status then  // Transação ocorreu com sucesso
      ShowMessage('NSU :'+RetornoPagamento.NSU +#13+
                  'Baneira :'+RetornoPagamento.Bandeira+#13+
                  'Rede :'+RetornoPagamento.rede+#13+
                  RetornoPagamento.ComprovanteCli
                  )
   else
      ShowMessage('A transação falhou !');
end;

procedure Tfrmprinc.edtqtdeparcelasKeyPress(Sender: TObject; var Key: Char);
begin
   if not charinset(key,['0'..'9',#8]) then
      key := #0;
end;

procedure Tfrmprinc.edtvalorKeyPress(Sender: TObject; var Key: Char);
begin
   if key = '.' then
      key := ',';
   if not charinset(key,['0'..'9',',',#8]) then
      key := #0;
end;

procedure Tfrmprinc.FormActivate(Sender: TObject);
begin
   edtvalor.Text := '1';
   cbformapgto.ItemIndex := 1;
end;

end.
