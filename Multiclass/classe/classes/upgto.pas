unit upgto;

interface

uses
  uKSTypes,
  tbotao,
  uMulticlassFuncoes,
  udmMulticlass,
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  ACBrUtil.Math,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  Mask,
  Grids,
  DBGrids,
  Buttons,
  Keyboard,
  DateUtils,
  Data.DB;

type
  //----------------------------------------------------------------------------
  Tfrmpgto = class(TForm)
    edtbruto: TMaskEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtdesconto: TMaskEdit;
    edtliquido: TMaskEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtpgto: TMaskEdit;
    edtpagamentos: TMaskEdit;
    Label5: TLabel;
    Label6: TLabel;
    edtsaldo: TMaskEdit;
    edttroco: TMaskEdit;
    Label7: TLabel;
    dbgridpgto: TDBGrid;
    Label8: TLabel;
    edtencargos: TMaskEdit;
    teclado: TTouchKeyboard;
    pnformas: TPanel;
    Label9: TLabel;
    fundo: TShape;
    placa_util: TShape;
    btforma1: TSpeedButton;
    btforma2: TSpeedButton;
    btforma4: TSpeedButton;
    btforma3: TSpeedButton;
    btforma5: TSpeedButton;
    Shape1: TShape;
    btbuscaforma: TSpeedButton;
    Shape2: TShape;
    Label10: TLabel;
    procedure btcancelaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure btokClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtpgtoEnter(Sender: TObject);
    procedure edtpgtoExit(Sender: TObject);
    procedure edtpgtoKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
    procedure edtpgtoKeyPress(Sender: TObject; var Key: Char);
    procedure btforma1Click(Sender: TObject);
    procedure btbuscaformaClick(Sender: TObject);
    procedure edtbrutoEnter(Sender: TObject);
  private
    procedure btdescontoClick(Sender: TObject);
    { Private declarations }
  public
    //--------------------------------------------------------------------------
    PagamentoVenda      : TPagamentoVenda;  // Registro para trabalhar com os pagamentos
    //--------------------------------------------------------------------------
    TotalPagar          : real; // Valor total a ser pago
    DescontoValor       : real;
    DescontoPercentual  : real;
    AcrescimoValor      : real;
    AcrescimoPercentual : real;
    //--------------------------------------------------------------------------
    BTOK_ativo           : boolean;
    //--------------------------------------------------------------------------
  end;

var
  frmpgto: Tfrmpgto;

implementation


{$R *.dfm}

uses ubuscaforma;


//------------------------------------------------------------------------------
//   Selecionar a forma de pagamento
//------------------------------------------------------------------------------
function SA_BuscaForma(valor:real):TPagamentoFoma;
begin
   application.CreateForm(tfrmbuscaforma,frmbuscaforma);
   frmbuscaforma.ShowModal;
   Result       := frmbuscaforma.PagamentoForma;
   Result.Valor := valor;
   frmbuscaforma.Release;
end;
//------------------------------------------------------------------------------
//  Realizar pagamento
//------------------------------------------------------------------------------
Procedure SA_EfetuarPagamento(PagamentoFoma : TPagamentoFoma);
begin
   dmMulticlass.tblpgto.Append;
   dmMulticlass.tblpgto.FieldByName('codigo').AsInteger       := PagamentoFoma.Codigo;
   dmMulticlass.tblpgto.FieldByName('forma').AsString         := PagamentoFoma.Forma;
   dmMulticlass.tblpgto.FieldByName('evento').AsInteger       := ord(PagamentoFoma.Evento);
   dmMulticlass.tblpgto.FieldByName('valor').AsFloat          := PagamentoFoma.Valor;
   dmMulticlass.tblpgto.FieldByName('formaTef').AsInteger     := PagamentoFoma.formaTEF;
   dmMulticlass.tblpgto.FieldByName('QtdeParcelas').AsInteger := PagamentoFoma.Parcelas;
   dmMulticlass.tblpgto.Post;
end;
//------------------------------------------------------------------------------
//   Encontrar forma de pagamento por atalho
//------------------------------------------------------------------------------
function SA_EncontrarFormaPorAtalho(atalho:string;valor:real):TPagamentoFoma;
begin
   Result.Achou := false;
   if dmMulticlass.tblformas.Locate('atalho',atalho,[]) then
      begin
         Result.Achou    := true;
         Result.Codigo   := dmMulticlass.tblformas.FieldByName('codigo').AsInteger;
         Result.Forma    := dmMulticlass.tblformasforma.Text;
         Result.Evento   := TKSEventoFormaPgto(dmMulticlass.tblformas.FieldByName('evento').AsInteger);
         Result.FormaTEF := dmMulticlass.tblformas.FieldByName('TipoPgto').AsInteger;
         Result.Parcelas := dmMulticlass.tblformas.FieldByName('QtdeParcelas').AsInteger;
         Result.Valor    := valor;
      end;
end;
//------------------------------------------------------------------------------
//   Encontrar forma de pagamento por código
//------------------------------------------------------------------------------
function SA_EncontrarFormaPorCodigo(codigo:integer;valor:real):TPagamentoFoma;
begin
   Result.Achou := false;
   if dmMulticlass.tblformas.Locate('codigo',codigo.ToString,[]) then
      begin
         Result.Achou    := true;
         Result.Codigo   := dmMulticlass.tblformas.FieldByName('codigo').AsInteger;
         Result.Forma    := dmMulticlass.tblformasforma.Text;
         Result.Evento   := TKSEventoFormaPgto(dmMulticlass.tblformas.FieldByName('evento').AsInteger);
         Result.FormaTEF := dmMulticlass.tblformas.FieldByName('TipoPgto').AsInteger;
         Result.Parcelas := dmMulticlass.tblformas.FieldByName('QtdeParcelas').AsInteger;
         Result.Valor    := valor;
      end;
end;

//------------------------------------------------------------------------------
// Somar os pagamentos
//------------------------------------------------------------------------------
function SA_SomarPagamentos:real;
begin
   Result := 0;
   dmMulticlass.tblpgto.First;
   while not dmMulticlass.tblpgto.Eof do
      begin
         Result := Result + untransform(dmMulticlass.tblpgtoValor.Text);
         dmMulticlass.tblpgto.Next;
      end;

end;
//------------------------------------------------------------------------------
//  Atualizar a tela de pagamentos
//------------------------------------------------------------------------------
procedure SA_AtualizarPagamentos;
var
   totalPago    : real;
   TotalLiquido : real;
begin
   //---------------------------------------------------------------------------
   totalPago                  := SA_SomarPagamentos;
   TotalLiquido               := frmpgto.TotalPagar+frmpgto.AcrescimoValor-frmpgto.DescontoValor;
   //---------------------------------------------------------------------------
   frmpgto.edtbruto.Text      := transform(frmpgto.TotalPagar);
   frmpgto.edtdesconto.Text   := transform(frmpgto.DescontoValor);
   frmpgto.edtencargos.Text   := transform(frmpgto.AcrescimoValor);
   frmpgto.edtliquido.Text    := transform(TotalLiquido);
   frmpgto.edtpagamentos.Text := transform(totalPago);
   frmpgto.edtsaldo.Text      := transform(0);
   frmpgto.edttroco.Text      := transform(0);
   if totalPago>TotalLiquido then
      begin
         frmpgto.edttroco.Text   := transform(totalPago-TotalLiquido);
         frmpgto.edtpgto.Text    := transform(0);
      end
   else
      begin
         frmpgto.edtsaldo.Text := transform(TotalLiquido-totalPago);
         frmpgto.edtpgto.Text  := frmpgto.edtsaldo.Text;
      end;
   //---------------------------------------------------------------------------
   if untransform(frmpgto.edtpgto.Text)<=0 then  // Se os pagamentos foram completados, então encerrar o processo
      frmpgto.btokClick(nil)
   else
      begin
         frmpgto.edtpgto.SelectAll;
         frmpgto.edtpgto.SetFocus;
      end;
end;
//------------------------------------------------------------------------------
// Carregar as formas de pagamento para os botões programados
//------------------------------------------------------------------------------
procedure SA_CarregarFormas;
begin
   //---------------------------------------------------------------------------
   //  Carregando as formas de pagamentos para os botões
   //---------------------------------------------------------------------------
   dmMulticlass.tblformas.First;
   while not dmMulticlass.tblformas.Eof do
      begin
         //---------------------------------------------------------------------
         if dmMulticlass.tblformasordem.Text='1' then // Carregando a imagem para o primeiro botão de pagamento
            begin
               //---------------------------------------------------------------
               frmpgto.btforma1.Caption := dmMulticlass.tblformasforma.Text;  // Definindo o descritivo
               frmpgto.btforma1.Tag     := dmMulticlass.tblformas.FieldByName('codigo').AsInteger;   // Guardando o código da forma de pagamento para o evento onckick
               //---------------------------------------------------------------
               if dmMulticlass.tblformasAruivoImagem.Text<>'' then   // Verificando se foi definido imagem
                  begin
                     //---------------------------------------------------------
                     if fileexists(GetCurrentDir+'\icones\'+dmMulticlass.tblformasAruivoImagem.Text) then   // Verificando se o arquivo existe
                        begin
                           try
                              frmpgto.btforma1.Glyph.LoadFromFile(GetCurrentDir+'\icones\'+dmMulticlass.tblformasAruivoImagem.Text);  // Carregando a imagem para o buton
                           except

                           end;
                        end;
                     //---------------------------------------------------------
                  end;
               //---------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
         if dmMulticlass.tblformasordem.Text='2' then // Carregando a imagem para o segundo botão de pagamento
            begin
               //---------------------------------------------------------------
               frmpgto.btforma2.Caption := dmMulticlass.tblformasforma.Text;  // Definindo o descritivo
               frmpgto.btforma2.Tag     := dmMulticlass.tblformas.FieldByName('codigo').AsInteger; // Guardando o código da forma de pagamento para o evento onckick
               //---------------------------------------------------------------
               if dmMulticlass.tblformasAruivoImagem.Text<>'' then   // Verificando se foi definido imagem
                  begin
                     //---------------------------------------------------------
                     if fileexists(GetCurrentDir+'\icones\'+dmMulticlass.tblformasAruivoImagem.Text) then   // Verificando se o arquivo existe
                        begin
                           try
                              frmpgto.btforma2.Glyph.LoadFromFile(GetCurrentDir+'\icones\'+dmMulticlass.tblformasAruivoImagem.Text);  // Carregando a imagem para o buton
                           except

                           end;
                        end;
                     //---------------------------------------------------------
                  end;
               //---------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
         if dmMulticlass.tblformasordem.Text='3' then // Carregando a imagem para o segundo botão de pagamento
            begin
               //---------------------------------------------------------------
               frmpgto.btforma3.Caption := dmMulticlass.tblformasforma.Text;  // Definindo o descritivo
               frmpgto.btforma3.Tag     := dmMulticlass.tblformas.FieldByName('codigo').AsInteger;// Guardando o código da forma de pagamento para o evento onckick
               //---------------------------------------------------------------
               if dmMulticlass.tblformasAruivoImagem.Text<>'' then   // Verificando se foi definido imagem
                  begin
                     //---------------------------------------------------------
                     if fileexists(GetCurrentDir+'\icones\'+dmMulticlass.tblformasAruivoImagem.Text) then   // Verificando se o arquivo existe
                        begin
                           try
                              frmpgto.btforma3.Glyph.LoadFromFile(GetCurrentDir+'\icones\'+dmMulticlass.tblformasAruivoImagem.Text);  // Carregando a imagem para o buton
                           except

                           end;
                        end;
                     //---------------------------------------------------------
                  end;
               //---------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
         if dmMulticlass.tblformasordem.Text='4' then // Carregando a imagem para o segundo botão de pagamento
            begin
               //---------------------------------------------------------------
               frmpgto.btforma4.Caption := dmMulticlass.tblformasforma.Text;  // Definindo o descritivo
               frmpgto.btforma4.Tag     := dmMulticlass.tblformas.FieldByName('codigo').AsInteger; // Guardando o código da forma de pagamento para o evento onckick
               //---------------------------------------------------------------
               if dmMulticlass.tblformasAruivoImagem.Text<>'' then   // Verificando se foi definido imagem
                  begin
                     //---------------------------------------------------------
                     if fileexists(GetCurrentDir+'\icones\'+dmMulticlass.tblformasAruivoImagem.Text) then   // Verificando se o arquivo existe
                        begin
                           try
                              frmpgto.btforma4.Glyph.LoadFromFile(GetCurrentDir+'\icones\'+dmMulticlass.tblformasAruivoImagem.Text);  // Carregando a imagem para o buton
                           except

                           end;
                        end;
                     //---------------------------------------------------------
                  end;
               //---------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
         if dmMulticlass.tblformasordem.Text='5' then // Carregando a imagem para o segundo botão de pagamento
            begin
               //---------------------------------------------------------------
               frmpgto.btforma5.Caption := dmMulticlass.tblformasforma.Text;  // Definindo o descritivo
               frmpgto.btforma5.Tag     := dmMulticlass.tblformas.FieldByName('codigo').AsInteger; // Guardando o código da forma de pagamento para o evento onckick
               //---------------------------------------------------------------
               if dmMulticlass.tblformasAruivoImagem.Text<>'' then   // Verificando se foi definido imagem
                  begin
                     //---------------------------------------------------------
                     if fileexists(GetCurrentDir+'\icones\'+dmMulticlass.tblformasAruivoImagem.Text) then   // Verificando se o arquivo existe
                        begin
                           try
                              frmpgto.btforma5.Glyph.LoadFromFile(GetCurrentDir+'\icones\'+dmMulticlass.tblformasAruivoImagem.Text);  // Carregando a imagem para o buton
                           except

                           end;
                        end;
                     //---------------------------------------------------------
                  end;
               //---------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
         dmMulticlass.tblformas.Next;
         //---------------------------------------------------------------------
      end;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
procedure Tfrmpgto.btcancelaClick(Sender: TObject);
begin
   frmpgto.Close;
end;

procedure Tfrmpgto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   dbgridpgto.Columns.SaveToFile('dbgridpgtovenda.cnf');
   SA_Limpar_Memoria;  // Limpando a memória
//   frmpgto.Release;

end;

procedure Tfrmpgto.FormActivate(Sender: TObject);
var
   botao     : TMKMBotao;
begin
   //---------------------------------------------------------------------------
   frmpgto.WindowState := wsMaximized;
   fundo.Align         := alClient;
   frmpgto.Repaint;
   //---------------------------------------------------------------------------
   botao              := TMKMBotao.Create;
   botao.TpBotao      := tpCancela;
   botao.Py           := placa_util.Top  + 10;
   botao.Px           := (placa_util.Left + placa_util.Width) - 260;
   botao.Altura       := placa_util.Height - 20;
   botao.Largura      := 250;
   botao.LarguraIcone := 42;
   botao.FontSize     := 12;
   botao.OnClick      := btcancelaClick;
   botao.Nome         := 'btcancela';
   botao.Pai          := frmpgto;
   botao.show;
   //---------------------------------------------------------------------------
   botao.TpBotao     := tpCustom;
   botao.Px          := (placa_util.Left + placa_util.Width) - 520;
   botao.Texto       := 'F12 - Ok';
   botao.Largura     := 250;
   botao.ArqIcone    := GetCurrentDir+'\icones\ok.bmp';
   botao.CorFundo    := $00029D25;
   botao.IconStretch := false;
   botao.FontSize    := 14;
   botao.CorLetra    := clWhite;
   botao.Pai         := frmpgto;
   botao.OnClick     := btokClick;
   botao.Nome        := 'btok';
   botao.show;
   //---------------------------------------------------------------------------
   //---------------------------------------------------------------------------
   botao.TpBotao     := tpCustom;
   botao.Px          := placa_util.Left + 10;
   botao.Texto       := 'F2 - Encerrar com desconto';
   botao.Largura     := 400;
   botao.ArqIcone    := GetCurrentDir+'\icones\ok.bmp';
   botao.CorFundo    := $00029D25;
   botao.IconStretch := false;
   botao.FontSize    := 14;
   botao.CorLetra    := clWhite;
   botao.Pai         := frmpgto;
   botao.OnClick     := btdescontoClick;
   botao.Nome        := 'btdesconto';
   botao.show;
   //---------------------------------------------------------------------------
   BTOK_ativo        := true;
   //---------------------------------------------------------------------------
   SA_CarregarFormas; //  Carregando as formas de pagamentos para os botões
   //---------------------------------------------------------------------------
   SA_AtualizarPagamentos;
   //---------------------------------------------------------------------------
   edtpgto.SetFocus;
end;

procedure Tfrmpgto.btforma1Click(Sender: TObject);
var
   PagamentoForma : TPagamentoFoma;
begin
   PagamentoForma := SA_EncontrarFormaPorCodigo((sender as TSpeedButton).Tag,untransform(edtpgto.Text));
   if PagamentoForma.Achou then
      begin
         SA_EfetuarPagamento(PagamentoForma);
         SA_AtualizarPagamentos;
      end;

end;


procedure Tfrmpgto.btdescontoClick(Sender: TObject);
begin
   if (untransform(edtpgto.Text)>0) and (untransform(edtpagamentos.Text)>0) then
      begin
         DescontoValor      := untransform(edtpgto.Text);
         DescontoPercentual := RoundABNT((DescontoValor/TotalPagar)*100,2);
         SA_AtualizarPagamentos;
      end
   else
      begin
         beep;
         showmessage('Desconto não permitido sem pagamento !');
      end;
end;

procedure Tfrmpgto.btokClick(Sender: TObject);
begin
   //---------------------------------------------------------------------------
   if BTOK_ativo then
      begin
         //---------------------------------------------------------------------
         BTOK_ativo  := false;
         //---------------------------------------------------------------------
         if untransform(edtsaldo.Text)>0 then
            begin
               beep;
               showmessage('Falta valor para concluir o pagamento !');
               exit;
            end;
         //---------------------------------------------------------------------
         PagamentoVenda.Bruto             := TotalPagar;
         PagamentoVenda.DescontoConcedido := DescontoValor;
         PagamentoVenda.Arredondamento    := 0;
         PagamentoVenda.Encargo           := AcrescimoValor;
         PagamentoVenda.Liquido           := TotalPagar-DescontoValor+AcrescimoValor;
         PagamentoVenda.TotalPagamentos   := 0;
         PagamentoVenda.Troco             := 0;
         //---------------------------------------------------------------------
         setlength(PagamentoVenda.Pagamentos,dmMulticlass.tblpgto.RecordCount);
         dmMulticlass.tblpgto.First;
         while not dmMulticlass.tblpgto.Eof do
            begin
               //---------------------------------------------------------------
               PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].Achou     := true;
               PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].Codigo    := dmMulticlass.tblpgto.FieldByName('codigo').AsInteger;
               PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].Forma     := dmMulticlass.tblpgto.FieldByName('forma').AsString;
               PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].Evento    := TKSEventoFormaPgto(dmMulticlass.tblpgto.FieldByName('evento').AsInteger);
               PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].Valor     := dmMulticlass.tblpgto.FieldByName('valor').AsFloat;
               PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].FormaTEF  := dmMulticlass.tblpgto.FieldByName('FormaTEF').AsInteger;
               if dmMulticlass.tblformas.Locate('codigo',inttostr(dmMulticlass.tblpgto.FieldByName('codigo').AsInteger),[]) then
                  begin
                     case PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].Evento of
                        tpKSEventoVSSPague          : PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].FormaVSPague     := TtpVSPagueFormaPgto(dmMulticlass.tblformas.FieldByName('TipoPgto').AsInteger);
                        tpKSEventoMultiplus         : PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].FormaMultiplus   := TtpMultiplusFormaPgto(dmMulticlass.tblformas.FieldByName('TipoPgto').AsInteger);
                        tpKSEventoElgin             : PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].FormaElgin       := TtpElginFormaPgto(dmMulticlass.tblformas.FieldByName('TipoPgto').AsInteger);
                        tpKSEventoSmartTEFVero      : PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].FormaVero        := TtpVEROFormaPgto(dmMulticlass.tblformas.FieldByName('TipoPgto').AsInteger);
                        tpKSEventoTEFEmbedIT        : PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].FormaEmbed       := TtpEmbedIFormaPgto(dmMulticlass.tblformas.FieldByName('TipoPgto').AsInteger);
                        tpKSEventoSmartTEFEmbedIT   : PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].FormaEmbed       := TtpEmbedIFormaPgto(dmMulticlass.tblformas.FieldByName('TipoPgto').AsInteger);
                     end;
                  end
               else
                  begin
                     PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].FormaVSPague     := VSPgtoPerguntar;
                     PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].FormaMultiplus   := tpMPlPerguntar;
                     PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].FormaElgin       := ElginPgtoPerguntar;
                     PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].FormaVero        := tpVeroPerguntar;
                     PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].FormaEmbed       := tpEmbedPgtoPerguntar;
                     PagamentoVenda.Pagamentos[dmMulticlass.tblpgto.RecNo-1].FormaEmbed       := tpEmbedPgtoPerguntar;
                  end;
               //---------------------------------------------------------------
               PagamentoVenda.TotalPagamentos   := PagamentoVenda.TotalPagamentos + dmMulticlass.tblpgto.FieldByName('valor').AsFloat;
               //---------------------------------------------------------------
               dmMulticlass.tblpgto.Next;
               //---------------------------------------------------------------
            end;
         if PagamentoVenda.TotalPagamentos<=PagamentoVenda.Liquido then
            PagamentoVenda.Arredondamento    := PagamentoVenda.Liquido-PagamentoVenda.TotalPagamentos
         else if PagamentoVenda.TotalPagamentos>PagamentoVenda.Liquido then
            PagamentoVenda.Troco := PagamentoVenda.TotalPagamentos-PagamentoVenda.Liquido;
         //---------------------------------------------------------------------
         frmpgto.Close;
         //---------------------------------------------------------------------
      end;
   //---------------------------------------------------------------------------
end;

procedure Tfrmpgto.FormCreate(Sender: TObject);
begin
   if fileexists('dbgridpgtovenda.cnf') then
      dbgridpgto.Columns.LoadFromFile('dbgridpgtovenda.cnf');
   //---------------------------------------------------------------------------
   dmMulticlass.tblpgto.Close;
   dmMulticlass.tblpgto.Open;
   dmMulticlass.tblpgto.EmptyDataSet;
   //---------------------------------------------------------------------------
end;

procedure Tfrmpgto.btbuscaformaClick(Sender: TObject);
var
   PagamentoForma : TPagamentoFoma;
begin
   PagamentoForma := SA_BuscaForma(untransform(edtpgto.Text));
   if PagamentoForma.Achou then
      begin
         SA_EfetuarPagamento(PagamentoForma);
         SA_AtualizarPagamentos;
      end;

end;

procedure Tfrmpgto.edtbrutoEnter(Sender: TObject);
begin
   edtpgto.SetFocus;
end;

procedure Tfrmpgto.edtpgtoEnter(Sender: TObject);
begin
   (sender as tmaskedit).Color := clWindow;
end;

procedure Tfrmpgto.edtpgtoExit(Sender: TObject);
begin
   (sender as tmaskedit).Color := clInactiveBorder;
end;

procedure Tfrmpgto.edtpgtoKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
   case key of
      vk_return : btbuscaforma.Click;
      vk_escape : btcancelaClick(sender);
      vk_f2     : btdescontoClick(sender);
      vk_f12    : btokClick(sender);
   end;
end;

procedure Tfrmpgto.edtpgtoKeyPress(Sender: TObject; var Key: Char);
var
   PagamentoForma : TPagamentoFoma;
begin
   //---------------------------------------------------------------------------
   if key='-' then   // Processar desconto
      begin
         //---------------------------------------------------------------------
         if untransform(edtpgto.Text)>0 then  // Verificar se o valor digitado é numérico
            begin
               //---------------------------------------------------------------
               //   Verificar se o desconto solicitado tem coerência
               //---------------------------------------------------------------
               if untransform(edtpgto.Text)<100 then
                  begin
                     DescontoPercentual := untransform(edtpgto.Text);
                     DescontoValor      := (TotalPagar*(DescontoPercentual/100));
                     SA_AtualizarPagamentos;
                  end;

               //---------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
      end;
   //---------------------------------------------------------------------------
   if key='+' then   // Processar acréscimo
      begin
         //---------------------------------------------------------------------
         if untransform(edtpgto.Text)>0 then  // Verificar se o valor digitado é numérico
            begin
               //---------------------------------------------------------------
               //   Verificar se o desconto solicitado tem coerência
               //---------------------------------------------------------------
               if untransform(edtpgto.Text)<100 then
                  begin
                     AcrescimoPercentual := untransform(edtpgto.Text);
                     AcrescimoValor      := (TotalPagar*(AcrescimoPercentual/100));
                     SA_AtualizarPagamentos;
                  end;

               //---------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
      end;

   //---------------------------------------------------------------------------
   if charinset(key,['A'..'Z','a'..'z']) then
      begin
         PagamentoForma := SA_EncontrarFormaPorAtalho(uppercase(key),untransform(edtpgto.Text));
         if PagamentoForma.Achou then
            begin
               SA_EfetuarPagamento(PagamentoForma);
               SA_AtualizarPagamentos;
            end
         else
            key := #0;
      end;
   //---------------------------------------------------------------------------
   if key='.' then
      key:=',';
   if not charinset(key, ['0'..'9',#8,',']) then
      key:=#0;
   //---------------------------------------------------------------------------
end;

end.















