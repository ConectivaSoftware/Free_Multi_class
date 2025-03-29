unit uconciliacao;

interface

uses
  uKSTypes,
  uMulticlass,
  uMulticlassFuncoes,
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
  Vcl.ExtCtrls,
  Vcl.Mask,
  Vcl.ComCtrls,
  Data.DB,
  Vcl.Grids,
  Vcl.DBGrids;

type
  Tfrmconciliacao = class(TForm)
    Shape2: TShape;
    Label9: TLabel;
    Shape1: TShape;
    btok: TBitBtn;
    btcancela: TBitBtn;
    fundo: TShape;
    Shape3: TShape;
    edtdti: TMaskEdit;
    Label1: TLabel;
    edtdtf: TMaskEdit;
    Label2: TLabel;
    pgc: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBGridprevisoes: TDBGrid;
    DBGridliquidacoes: TDBGrid;
    TabSheet3: TTabSheet;
    Shape4: TShape;
    Label5: TLabel;
    edtrecebiveis: TMaskEdit;
    Label6: TLabel;
    edttaxasrecebiveis: TMaskEdit;
    edtliquidorecebiveis: TMaskEdit;
    Label7: TLabel;
    Label3: TLabel;
    edtliquidado: TMaskEdit;
    Label4: TLabel;
    edttaxasliquidado: TMaskEdit;
    Label8: TLabel;
    edtliquidoliquidado: TMaskEdit;
    Shape5: TShape;
    edttextoMOVIFLUXO: TMemo;
    procedure FormActivate(Sender: TObject);
    procedure btcancelaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btokClick(Sender: TObject);
    procedure edtdtiExit(Sender: TObject);
    procedure edtdtiEnter(Sender: TObject);
    procedure edtdtfKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridliquidacoesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmconciliacao: Tfrmconciliacao;

implementation

{$R *.dfm}

uses uprinc;

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
procedure Tfrmconciliacao.btcancelaClick(Sender: TObject);
begin
   frmconciliacao.Close;
end;

procedure Tfrmconciliacao.btokClick(Sender: TObject);
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
   //---------------------------------------------------------------------------
   if not SA_DataValida(edtdti.Text) then
      edtdti.Text := '01/01/2000';
   if not SA_DataValida(edtdtf.Text) then
      edtdtf.Text := '31/01/2099';
   //---------------------------------------------------------------------------
   Multiclass  := TMulticlass.create;       // Classe para operar a consulta
   Conciliacao := Multiclass.MOVIFLUXOConsultar(strtodatedef(edtdti.Text,date-30),StrToDateDef(edtdtf.Text,date));
   Multiclass.Free;
   //---------------------------------------------------------------------------
   //  Previsões
   //---------------------------------------------------------------------------
   recebiveis      := 0;
   taxasrecebiveis := 0;
   frmprinc.tblprevisao.Open;
   frmprinc.tblprevisao.EmptyDataSet;
   //---------------------------------------------------------------------------
   edttextoMOVIFLUXO.Lines.Clear;
   edttextoMOVIFLUXO.Lines.Add('PREVISÕES');
   edttextoMOVIFLUXO.Lines.Add('');
   //---------------------------------------------------------------------------
   for d := 1 to length(Conciliacao.Previsao) do
      begin
         frmprinc.tblprevisao.Append;
         frmprinc.tblprevisao.FieldByName('adquirente').AsString                := Conciliacao.Previsao[d-1].adquirente;
         frmprinc.tblprevisao.FieldByName('codigo_pedido').AsString             := Conciliacao.Previsao[d-1].codigo_pedido;
         frmprinc.tblprevisao.FieldByName('nsu').AsString                       := Conciliacao.Previsao[d-1].nsu;
         frmprinc.tblprevisao.FieldByName('meio_pagamento').AsString            := Conciliacao.Previsao[d-1].meio_pagamento;
         frmprinc.tblprevisao.FieldByName('produto').AsString                   := Conciliacao.Previsao[d-1].produto;
         frmprinc.tblprevisao.FieldByName('estabelecimento').AsString           := Conciliacao.Previsao[d-1].estabelecimento;
         frmprinc.tblprevisao.FieldByName('data_venda').AsDateTime              := Conciliacao.Previsao[d-1].data_venda;
         frmprinc.tblprevisao.FieldByName('data_prevista_pagamento').AsDateTime := Conciliacao.Previsao[d-1].data_prevista_pagamento;
         frmprinc.tblprevisao.FieldByName('valor_bruto_transacao').AsFloat      := Conciliacao.Previsao[d-1].valor_bruto_transacao;
         frmprinc.tblprevisao.FieldByName('valor_bruto_parcela').AsFloat        := Conciliacao.Previsao[d-1].valor_bruto_parcela;
         frmprinc.tblprevisao.FieldByName('valor_liquido_parcela').AsFloat      := Conciliacao.Previsao[d-1].valor_liquido_parcela;
         frmprinc.tblprevisao.FieldByName('taxa_adquirencia').AsFloat           := Conciliacao.Previsao[d-1].taxa_adquirencia;
         frmprinc.tblprevisao.FieldByName('bandeira').AsString                  := Conciliacao.Previsao[d-1].bandeira;
         frmprinc.tblprevisao.FieldByName('parcela').AsInteger                  := Conciliacao.Previsao[d-1].parcela;
         frmprinc.tblprevisao.FieldByName('plano').AsInteger                    := Conciliacao.Previsao[d-1].plano;
         frmprinc.tblprevisao.Post;
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
   //---------------------------------------------------------------------------
   edtrecebiveis.Text        := transform(recebiveis);
   edttaxasrecebiveis.Text   := transform(taxasrecebiveis);
   edtliquidorecebiveis.Text := transform(recebiveis-taxasrecebiveis);
   //---------------------------------------------------------------------------
   // Liquidações
   //---------------------------------------------------------------------------
   liquidado       := 0;
   taxasliquidado  := 0;
   frmprinc.tblliquidacao.Open;
   frmprinc.tblliquidacao.EmptyDataSet;
   //---------------------------------------------------------------------------
   edttextoMOVIFLUXO.Lines.Add('');
   edttextoMOVIFLUXO.Lines.Add('');
   edttextoMOVIFLUXO.Lines.Add('LIQUIDACOES');
   edttextoMOVIFLUXO.Lines.Add('');
   //---------------------------------------------------------------------------
   for d := 1 to length(Conciliacao.Liquidacoes) do
      begin
         frmprinc.tblliquidacao.Append;
         frmprinc.tblliquidacao.FieldByName('adquirente').AsString              := Conciliacao.Liquidacoes[d-1].adquirente;
         frmprinc.tblliquidacao.FieldByName('codigo_pedido').AsString           := Conciliacao.Liquidacoes[d-1].codigo_pedido;
         frmprinc.tblliquidacao.FieldByName('nsu').AsString                     := Conciliacao.Liquidacoes[d-1].nsu;
         frmprinc.tblliquidacao.FieldByName('meio_pagamento').AsString          := Conciliacao.Liquidacoes[d-1].meio_pagamento;
         frmprinc.tblliquidacao.FieldByName('bandeira').AsString                := Conciliacao.Liquidacoes[d-1].bandeira;
         frmprinc.tblliquidacao.FieldByName('produto').AsString                 := Conciliacao.Liquidacoes[d-1].produto;
         frmprinc.tblliquidacao.FieldByName('estabelecimento').AsString         := Conciliacao.Liquidacoes[d-1].estabelecimento;
         frmprinc.tblliquidacao.FieldByName('data_pagamento').AsDateTime        := Conciliacao.Liquidacoes[d-1].data_pagamento;
         frmprinc.tblliquidacao.FieldByName('valor_bruto_transacao').AsFloat    := Conciliacao.Liquidacoes[d-1].valor_bruto_transacao;
         frmprinc.tblliquidacao.FieldByName('valor_bruto_parcela').AsFloat      := Conciliacao.Liquidacoes[d-1].valor_bruto_parcela;
         frmprinc.tblliquidacao.FieldByName('valor_liquido_parcela').AsFloat    := Conciliacao.Liquidacoes[d-1].valor_liquido_parcela;
         frmprinc.tblliquidacao.FieldByName('taxa_administrativa').AsFloat      := Conciliacao.Liquidacoes[d-1].taxa_administrativa;
         frmprinc.tblliquidacao.FieldByName('parcela').AsInteger                := Conciliacao.Liquidacoes[d-1].parcela;
         frmprinc.tblliquidacao.FieldByName('plano').AsInteger                  := Conciliacao.Liquidacoes[d-1].plano;
         frmprinc.tblliquidacao.FieldByName('codigo_banco').AsString            := Conciliacao.Liquidacoes[d-1].codigo_banco;
         frmprinc.tblliquidacao.FieldByName('nome_banco').AsString              := Conciliacao.Liquidacoes[d-1].nome_banco;
         frmprinc.tblliquidacao.FieldByName('agencia').AsString                 := Conciliacao.Liquidacoes[d-1].agencia;
         frmprinc.tblliquidacao.FieldByName('conta_corrente_poupanca').AsString := Conciliacao.Liquidacoes[d-1].conta_corrente_poupanca;
         frmprinc.tblliquidacao.Post;
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
   edtliquidado.Text        := transform(liquidado);
   edttaxasliquidado.Text   := transform(taxasliquidado);
   edtliquidoliquidado.Text := transform(liquidado-taxasliquidado);
   //---------------------------------------------------------------------------

end;

procedure Tfrmconciliacao.DBGridliquidacoesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case key of
      vk_escape:btcancela.Click;
   end;
end;

procedure Tfrmconciliacao.edtdtfKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   case key of
      vk_up:perform(40,1,0);
      vk_down:perform(40,0,0);
      vk_return:perform(40,0,0);
      vk_escape:btcancela.Click;
      vk_f5:btok.Click;
   end;
end;

procedure Tfrmconciliacao.edtdtiEnter(Sender: TObject);
begin
   (sender as TMaskEdit).Color := clWindow;
end;

procedure Tfrmconciliacao.edtdtiExit(Sender: TObject);
begin
   (sender as TMaskEdit).Color := clInactiveBorder;
   if not SA_DataValida(edtdti.Text) then
      edtdti.Text := '01/01/2000';
   if not SA_DataValida(edtdtf.Text) then
      edtdtf.Text := '31/01/2099';
end;

procedure Tfrmconciliacao.FormActivate(Sender: TObject);
begin
   //---------------------------------------------------------------------------
   fundo.Align := alClient;
   edtdti.Text := '01/01/2000';
   edtdtf.Text := '31/12/2099';
   //---------------------------------------------------------------------------
   frmprinc.tblprevisao.Close;
   frmprinc.tblprevisao.Open;
   frmprinc.tblprevisao.EmptyDataSet;
   frmprinc.tblliquidacao.Close;
   frmprinc.tblliquidacao.Open;
   frmprinc.tblliquidacao.EmptyDataSet;
   //---------------------------------------------------------------------------
end;

procedure Tfrmconciliacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   frmconciliacao.Release;
end;

procedure Tfrmconciliacao.FormCreate(Sender: TObject);
begin
   pgc.ActivePageIndex := 0;
end;

end.
