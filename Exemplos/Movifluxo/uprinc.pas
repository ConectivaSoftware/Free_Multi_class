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
  Vcl.Buttons,
  Vcl.Mask,
  Vcl.ExtCtrls;

type
  Tfrmprinc = class(TForm)
    Shape1: TShape;
    Label10: TLabel;
    Label1: TLabel;
    edtdti: TMaskEdit;
    Label2: TLabel;
    edtdtf: TMaskEdit;
    btok: TBitBtn;
    Label42: TLabel;
    edtMOVIFLUXOToken: TMaskEdit;
    Label43: TLabel;
    edtMOVIFLUXOIDCliente: TMaskEdit;
    Label45: TLabel;
    edttextoMOVIFLUXO: TMemo;
    procedure btokClick(Sender: TObject);
    procedure edtdtiExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmprinc: Tfrmprinc;

implementation

{$R *.dfm}


//------------------------------------------------------------------------------
//   Monetário 14 dígitos
//------------------------------------------------------------------------------
function transform(valor:real):string;
begin
   Result := '          '+formatfloat('###,###,##0.00',valor);
   Result := copy(Result,length(Result)-13,14);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function SA_DataValida(data:string):boolean;
begin
   try
      strtodate(data);
      Result := true;
   except
      Result := false;
   end;

end;
//------------------------------------------------------------------------------

procedure Tfrmprinc.btokClick(Sender: TObject);
var
   Multiclass  : TMulticlass;       // Classe para operar a consulta
   Conciliacao : TMoviFluxoExtrato;
   d           : integer;
   //---------------------------------------------------------------------------
   recebiveis      : real;
   taxasrecebiveis : real;
   liquidado       : real;
   taxasliquidado  : real;
   //---------------------------------------------------------------------------
begin
   if (edtMOVIFLUXOToken.Text='')  or (edtMOVIFLUXOIDCliente.Text='') then
      begin
         beep;
         ShowMessage('Falta as credeciais para consulta !');
         exit;
      end;

   //---------------------------------------------------------------------------
   if not SA_DataValida(edtdti.Text) then
      edtdti.Text := '01/01/2000';
   if not SA_DataValida(edtdtf.Text) then
      edtdtf.Text := '31/01/2099';
   //---------------------------------------------------------------------------
   Multiclass                      := TMulticlass.create;       // Classe para operar a consulta
   Multiclass.MovifluxoToken       := edtMOVIFLUXOToken.Text;
   Multiclass.MovifluxoIDCliente   := edtMOVIFLUXOIDCliente.Text;
   Multiclass.MovifluxoHomologacao := true;
   Conciliacao                     := Multiclass.MOVIFLUXOConsultar(strtodatedef(edtdti.Text,date-30),StrToDateDef(edtdtf.Text,date));
   Multiclass.Free;

   //---------------------------------------------------------------------------
   for d := 1 to length(Conciliacao.Previsao) do
      begin
         //---------------------------------------------------------------------
         edttextoMOVIFLUXO.Lines.Add(Conciliacao.Previsao[d-1].adquirente+' '+
                                     Conciliacao.Previsao[d-1].codigo_pedido+' '+
                                     Conciliacao.Previsao[d-1].nsu+' '+
                                     Conciliacao.Previsao[d-1].meio_pagamento+' '+
                                     Conciliacao.Previsao[d-1].produto+' '+
                                     Conciliacao.Previsao[d-1].estabelecimento+' '+
                                     formatdatetime('dd/mm/yyyy',Conciliacao.Previsao[d-1].data_venda)+' '+
                                     formatdatetime('dd/mm/yyyy',Conciliacao.Previsao[d-1].data_prevista_pagamento)+' '+
                                     transform(Conciliacao.Previsao[d-1].valor_bruto_transacao)+' '+
                                     transform(Conciliacao.Previsao[d-1].valor_bruto_parcela)+' '+
                                     transform(Conciliacao.Previsao[d-1].valor_liquido_parcela)+' '+
                                     transform(Conciliacao.Previsao[d-1].taxa_adquirencia)+' '+
                                     Conciliacao.Previsao[d-1].bandeira+' '+
                                     Conciliacao.Previsao[d-1].parcela.ToString+' '+
                                     Conciliacao.Previsao[d-1].plano.ToString
                                     );
         //---------------------------------------------------------------------
         recebiveis      := recebiveis      + Conciliacao.Previsao[d-1].valor_bruto_parcela;
         taxasrecebiveis := taxasrecebiveis + (Conciliacao.Previsao[d-1].valor_bruto_parcela - Conciliacao.Previsao[d-1].valor_liquido_parcela);
         //---------------------------------------------------------------------
      end;

   for d := 1 to length(Conciliacao.Liquidacoes) do
      begin
         //---------------------------------------------------------------------
         edttextoMOVIFLUXO.Lines.Add(Conciliacao.Liquidacoes[d-1].adquirente+' '+
                                     Conciliacao.Liquidacoes[d-1].codigo_pedido+' '+
                                     Conciliacao.Liquidacoes[d-1].nsu+' '+
                                     Conciliacao.Liquidacoes[d-1].meio_pagamento+' '+
                                     Conciliacao.Liquidacoes[d-1].bandeira+' '+
                                     Conciliacao.Liquidacoes[d-1].produto+' '+
                                     Conciliacao.Liquidacoes[d-1].estabelecimento+' '+
                                     formatdatetime('dd/mm/yyyy',Conciliacao.Liquidacoes[d-1].data_pagamento)+' '+
                                     transform(Conciliacao.Liquidacoes[d-1].valor_bruto_transacao)+' '+
                                     transform(Conciliacao.Liquidacoes[d-1].valor_bruto_parcela)+' '+
                                     transform(Conciliacao.Liquidacoes[d-1].valor_liquido_parcela)+' '+
                                     transform(Conciliacao.Liquidacoes[d-1].taxa_administrativa)+' '+
                                     Conciliacao.Liquidacoes[d-1].parcela.ToString+' '+
                                     Conciliacao.Liquidacoes[d-1].plano.ToString+' '+
                                     Conciliacao.Liquidacoes[d-1].codigo_banco+' '+
                                     Conciliacao.Liquidacoes[d-1].nome_banco+' '+
                                     Conciliacao.Liquidacoes[d-1].agencia+' '+
                                     Conciliacao.Liquidacoes[d-1].conta_corrente_poupanca
                                     );
         //---------------------------------------------------------------------
         liquidado      := recebiveis      + Conciliacao.Liquidacoes[d-1].valor_bruto_parcela;
         taxasliquidado := taxasliquidado  + (Conciliacao.Liquidacoes[d-1].valor_bruto_parcela - Conciliacao.Liquidacoes[d-1].valor_liquido_parcela);
         //---------------------------------------------------------------------
      end;
   //---------------------------------------------------------------------------
end;

procedure Tfrmprinc.edtdtiExit(Sender: TObject);
begin
   (sender as TMaskEdit).Color := clInactiveBorder;
   if not SA_DataValida(edtdti.Text) then
      edtdti.Text := '01/01/2000';
   if not SA_DataValida(edtdtf.Text) then
      edtdtf.Text := '31/01/2099';
end;

end.
