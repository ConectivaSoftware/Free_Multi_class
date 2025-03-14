unit uprinc;

interface

uses
  variants,
  midaslib,
  uMulticlassFuncoes,
  uMulticlass,
  uKSTypes,
  uBuscaProd,
  acbrutil.Math,
  Winapi.Windows,
  System.SysUtils,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Mask,
  Vcl.Buttons,
  Vcl.Grids,
  Vcl.DBGrids,
  Datasnap.DBClient,
  System.Classes,
  System.UITypes,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Data.DB;

type
  Tfrmprinc = class(TForm)
    pntitulo: TPanel;
    pnrodape: TPanel;
    btreiniciarvenda: TSpeedButton;
    btpagar: TSpeedButton;
    edttotal: TMaskEdit;
    Label1: TLabel;
    dtsvenda: TDataSource;
    DBGridprod: TDBGrid;
    edtdigitar: TMaskEdit;
    Label2: TLabel;
    edtqtde: TMaskEdit;
    Label3: TLabel;
    edtpreco: TMaskEdit;
    Label4: TLabel;
    Label5: TLabel;
    btconfig: TSpeedButton;
    btutil: TSpeedButton;
    Shape1: TShape;
    Label6: TLabel;
    btbuscaprod: TSpeedButton;
    fundo: TShape;
    tblvenda: TClientDataSet;
    tblvendaBarra: TStringField;
    tblvendadescricao: TStringField;
    tblvendaqtde: TFloatField;
    tblvendapreco: TFloatField;
    tblvendatotal: TFloatField;
    tbltef: TClientDataSet;
    dtstef: TDataSource;
    tbltefNSU: TStringField;
    tbltefcAut: TStringField;
    tbltefrede: TStringField;
    tbltefBandeira: TStringField;
    tbltefCNPJAdquirente: TStringField;
    tbltefDataHora: TDateTimeField;
    tbltefValor: TFloatField;
    tbltefForma: TStringField;
    tbltefOperadoraTEF: TIntegerField;
    tbltefNumero: TAutoIncField;
    tbltefStatus: TBooleanField;
    tbltefE2E: TStringField;
    tbltefTxID: TStringField;
    tbltefDescEvento: TStringField;
    tbltefCancelado: TBooleanField;
    tblprod: TClientDataSet;
    dtsprod: TDataSource;
    tblprodbarra: TStringField;
    tblprodref: TStringField;
    tblproddescricao: TStringField;
    tblprodun: TStringField;
    tblprodmarca: TStringField;
    tblprodncm: TStringField;
    tblprodcest: TStringField;
    tblprodpreco: TFloatField;
    tblvendaun: TStringField;
    tblvendaref: TStringField;
    tblvendamarca: TStringField;
    tblvendancm: TStringField;
    tblvendacest: TStringField;
    tbltefformatef: TIntegerField;
    procedure FormActivate(Sender: TObject);
    procedure edtdigitarKeyPress(Sender: TObject; var Key: Char);
    procedure btreiniciarvendaClick(Sender: TObject);
    procedure edtdigitarKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btpagarClick(Sender: TObject);
    procedure btconfigClick(Sender: TObject);
    procedure btbuscaprodClick(Sender: TObject);
    procedure btutilClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tblvendaqtdeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure tbltefDescEventoGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    //--------------------------------------------------------------------------
    entrou        : boolean;
    //--------------------------------------------------------------------------
  end;

var
  frmprinc: Tfrmprinc;

  function SA_DigitarPrecoProd(Produto:TKSRespostaConsultaProd):real;

implementation

{$R *.dfm}

uses uprecoprod, uutil;

//------------------------------------------------------------------------------
//   Função para procurar o produto na tabela local
//------------------------------------------------------------------------------
function SA_BuscaProd(busca:string;preco:real = 0):TKSRespostaConsultaProd;
var
   Cadastrar  : boolean;   // Para sinalizar que a busca foi encontrada no servidor, e cadastrar o produto localmente
   achou      : boolean;           // Flag para sinalizar se o produto foi encontrado na base local ou não
   Multiclass : TMulticlass;       // Classe para operar a consulta
begin
   //---------------------------------------------------------------------------
   Result.Status   := stKSFalha;
   Result.Mensagem := 'Produto não encontrado.';  // Definindo mensagem padrão
   if busca.IsEmpty then   // Se a busca é vazia = if busca='' then
      exit;
   //---------------------------------------------------------------------------
   Cadastrar := false;
   achou     := false;
   if SA_Codigo_de_barras_valido(busca) then   // Se a digitação foi um código de barras EAN, procurar na base local por código de barras
      achou := frmprinc.tblprod.Locate('barra',busca,[]);
   if not achou then   // Se não encontrou no código de barras, procurar pela referência
      achou := frmprinc.tblprod.Locate('ref',busca,[]);
   if achou then  // Se encontrou na tabela local - Cadastro
      begin
         //---------------------------------------------------------------------
         Result.Status            := stKSOk;
         Result.Mensagem          := 'Produto encontrado na base local.';
         Result.Produto.barra     := frmprinc.tblprodbarra.Text;
         Result.Produto.ref       := frmprinc.tblprodref.Text;
         Result.Produto.descricao := frmprinc.tblproddescricao.Text;
         Result.Produto.un        := frmprinc.tblprodun.Text;
         Result.Produto.marca     := frmprinc.tblprodmarca.Text;
         Result.Produto.ncm       := frmprinc.tblprodncm.Text;
         Result.Produto.cest      := frmprinc.tblprodcest.Text;
         Result.Produto.preco     := frmprinc.tblprod.FieldByName('preco').AsFloat;
         //---------------------------------------------------------------------
      end
   else // Produto não foi encontrado na base local, procurar no servidor
      begin
         //---------------------------------------------------------------------
         if not SA_Codigo_de_barras_valido(busca) then   // Se a digitação não é  um código de barras EAN, abortara busca no servidor
            exit;
         //---------------------------------------------------------------------
         Multiclass := TMulticlass.create;
         Result     := Multiclass.ConsultarProduto(busca);
         Multiclass.Free;
         //---------------------------------------------------------------------
         if Result.Status=stKSOk then  // A consulta ocorreu como sucesso
            begin
               //---------------------------------------------------------------
               Result.Mensagem      := 'Produto encontrado no servidor remoto.';
               Result.Produto.preco := preco;   // Atribuir o preço recebido no parâmetro de entrada na função, pois o servidor não informa preço
               Cadastrar            := true;
               //---------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
      end;
   //---------------------------------------------------------------------------
   if Result.Status=stKSOk then  // A consulta ocorreu com sucesso, examinar preço
      begin
         //---------------------------------------------------------------------
         if Result.Produto.preco=0 then
            Result.Produto.preco := SA_DigitarPrecoProd(Result);
         if (cadastrar) and (Result.Produto.preco>0) then // Salvar o produto no banco local se foi digitado preço
            begin
               //---------------------------------------------------------------
               frmprinc.tblprod.Append;
               frmprinc.tblprod.FieldByName('barra').AsString     := Result.Produto.barra;
               frmprinc.tblprod.FieldByName('ref').AsString       := Result.Produto.ref;
               frmprinc.tblprod.FieldByName('descricao').AsString := Result.Produto.descricao;
               frmprinc.tblprod.FieldByName('un').AsString        := Result.Produto.un;
               frmprinc.tblprod.FieldByName('marca').AsString     := Result.Produto.marca;
               frmprinc.tblprod.FieldByName('ncm').AsString       := Result.Produto.ncm;
               frmprinc.tblprod.FieldByName('cest').AsString      := Result.Produto.cest;
               frmprinc.tblprod.FieldByName('preco').AsFloat      := Result.Produto.preco;
               frmprinc.tblprod.Post;
               //---------------------------------------------------------------
               frmprinc.tblprod.SaveToFile(GetCurrentDir+'\dados\prod.xml');   // Salvando em disco o cadastro de produtos
               //---------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
      end;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
//   Definir valor
//------------------------------------------------------------------------------
function SA_DigitarPrecoProd(Produto:TKSRespostaConsultaProd):real;
begin
    Application.CreateForm(Tfrmprecoprod, frmprecoprod);
    frmprecoprod.edtdescricao.Text := Produto.Produto.descricao;
    frmprecoprod.edtun.Text        := Produto.Produto.un;
    frmprecoprod.edtbarra.Text     := Produto.Produto.barra;
    frmprecoprod.edtvenda.Text     := transform(1);
    frmprecoprod.ShowModal;
    Result := untransform(frmprecoprod.edtvenda.Text);
    frmprecoprod.Release;

end;
//------------------------------------------------------------------------------

procedure SomarVenda;
var
   total : real;
begin
   total := 0;
   frmprinc.tblvenda.First;
   while not frmprinc.tblvenda.Eof do
      begin
         total := total + frmprinc.tblvenda.FieldByName('total').AsFloat;
         frmprinc.tblvenda.Next;
      end;
   frmprinc.edttotal.Text := formatfloat('###,##0.00',total);
end;

procedure Tfrmprinc.btbuscaprodClick(Sender: TObject);
var
   Produto : TKSRespostaConsultaProd;  // Record para carregar produtos do cadastro local ou da consulta
begin
   //---------------------------------------------------------------------------
   Produto := SA_BuscaProd(edtdigitar.Text,untransform(edtpreco.Text));   // Função para carregar o produto
   //---------------------------------------------------------------------------
   if Produto.Status=stKSOk then  // A consulta ocorreu como sucesso
      begin
         //---------------------------------------------------------------------
         if Produto.Produto.preco=0 then
            exit;
         //---------------------------------------------------------------------
         if untransform(edtqtde.Text)<=0 then   // Se a quantidade não foi digitada assumir "1"
            edtqtde.Text := transform(1);
         //---------------------------------------------------------------------
         tblvenda.Append;  // Incluir o valor na tabela de memória
         tblvenda.FieldByName('barra').AsString     := Produto.Produto.barra;
         tblvenda.FieldByName('ref').AsString       := Produto.Produto.ref;
         tblvenda.FieldByName('descricao').AsString := Produto.Produto.descricao;
         tblvenda.FieldByName('un').AsString        := Produto.Produto.un;
         tblvenda.FieldByName('marca').AsString     := Produto.Produto.marca;
         tblvenda.FieldByName('ncm').AsString       := Produto.Produto.ncm;
         tblvenda.FieldByName('cest').AsString      := Produto.Produto.cest;
         tblvenda.FieldByName('qtde').AsFloat       := untransform(edtqtde.Text);
         tblvenda.FieldByName('preco').AsFloat      := Produto.Produto.preco;
         tblvenda.FieldByName('total').AsFloat      := untransform(edtqtde.Text)*Produto.Produto.preco;
         tblvenda.Post;
         //---------------------------------------------------------------------
         SomarVenda;   // Somar os produtos selecionados para a venda
         //---------------------------------------------------------------------
         edtdigitar.Text := '';   // Limpar os dados para vender o p´róximo item
         edtqtde.Text    := formatfloat('###,##0.000',1);
         edtpreco.Text   := formatfloat('###,##0.000',0);
         //---------------------------------------------------------------------
      end
   else
      begin
         ShowMessage(Produto.Mensagem);
      end;
   //---------------------------------------------------------------------------
end;

procedure Tfrmprinc.btconfigClick(Sender: TObject);
var
   Multiclass : TMulticlass;
begin
   Multiclass := TMulticlass.create;
   Multiclass.Configurar;
   Multiclass.Destroy;
end;

procedure Tfrmprinc.btpagarClick(Sender: TObject);
var
   //---------------------------------------------------------------------------
   Multiclass     : TMulticlass;     // Para aprocessar o pagamento
   PagamentoVenda : TPagamentoVenda; // Para armazenar o pagamento - Lista de pagamentos
   CPFCNPJ        : string;          // Capturar o CPF / CNPJ
   //---------------------------------------------------------------------------
   d              : integer;
   //---------------------------------------------------------------------------
begin
   if untransform(edttotal.Text)=0 then
      begin
         beep;
         ShowMessage('Venda sem valor. Operação impossível !');
         exit;
      end;
   //---------------------------------------------------------------------------
   Multiclass := TMulticlass.create;
   CPFCNPJ    := Multiclass.CapturarCPF;   // Capturar CPF/CNPJ - Exemplo
   Multiclass.EncerrarVendaCompleta(untransform(edttotal.Text));
   PagamentoVenda := Multiclass.Pagamento;
   Multiclass.Destroy;
   //---------------------------------------------------------------------------
   if length(PagamentoVenda.Pagamentos)=0 then   // Se não foi definido nenhum pagamento, não continuar;
      exit;
   //---------------------------------------------------------------------------
   for d := 1 to length(PagamentoVenda.Pagamentos) do
      begin
         if PagamentoVenda.Pagamentos[d-1].Evento in[tpKSEventoVSSPague,tpKSEventoMultiplus,tpKSEventoElgin,tpKSEventoMKMPix,tpKSEventoSmartTEFVero,tpKSEventoTEFEmbedIT,tpKSEventoSmartTEFEmbedIT] then
            begin
               //---------------------------------------------------------------
               //   Salvar a transação na tabela TEF
               //---------------------------------------------------------------
               frmprinc.tbltef.Append;
               frmprinc.tbltef.FieldByName('Status').AsBoolean        := PagamentoVenda.Pagamentos[d-1].RetornoTEF.Status;
               frmprinc.tbltef.FieldByName('Valor').AsFloat           := PagamentoVenda.Pagamentos[d-1].Valor;
               frmprinc.tbltef.FieldByName('FormaAdm').AsString       := PagamentoVenda.Pagamentos[d-1].Forma;
               frmprinc.tbltef.FieldByName('OperadoraTEF').AsInteger  := ord(PagamentoVenda.Pagamentos[d-1].Evento);
               frmprinc.tbltef.FieldByName('NSU').AsString            := PagamentoVenda.Pagamentos[d-1].RetornoTEF.NSU;
               frmprinc.tbltef.FieldByName('cAut').AsString           := PagamentoVenda.Pagamentos[d-1].RetornoTEF.cAut;
               frmprinc.tbltef.FieldByName('rede').AsString           := PagamentoVenda.Pagamentos[d-1].RetornoTEF.rede;
               frmprinc.tbltef.FieldByName('Bandeira').AsString       := PagamentoVenda.Pagamentos[d-1].RetornoTEF.Bandeira;
               frmprinc.tbltef.FieldByName('CNPJAdquirente').AsString := PagamentoVenda.Pagamentos[d-1].RetornoTEF.CNPJAdquirente;
               frmprinc.tbltef.FieldByName('E2E').AsString            := PagamentoVenda.Pagamentos[d-1].RetornoTEF.E2E;
               frmprinc.tbltef.FieldByName('TxID').AsString           := PagamentoVenda.Pagamentos[d-1].RetornoTEF.TxID;
               frmprinc.tbltef.FieldByName('formatef').AsInteger      := PagamentoVenda.Pagamentos[d-1].FormaTEF;
               frmprinc.tbltef.Post;
               frmprinc.tbltef.SaveToFile(GetCurrentDir+'\dados\tef.xml');  // Salvando a tabela TEF
               //---------------------------------------------------------------
               //  Salvar os comprovantes dentro da pasta "dados\documentos" com os nomes de arquivo contendo o número da transação - Campo AUTOINC da tabela TEF
               //---------------------------------------------------------------
               SA_Salva_Arquivo_Incremental(PagamentoVenda.Pagamentos[d-1].RetornoTEF.ComprovanteLoja,GetCurrentDir+'\dados\documentos\tefLJ_'+tbltefNumero.Text+'.txt');
               SA_Salva_Arquivo_Incremental(PagamentoVenda.Pagamentos[d-1].RetornoTEF.ComprovanteCli,GetCurrentDir+'\dados\documentos\tefCLI_'+tbltefNumero.Text+'.txt');
               SA_Salva_Arquivo_Incremental(PagamentoVenda.Pagamentos[d-1].RetornoTEF.ComprovanteRed,GetCurrentDir+'\dados\documentos\tefRED_'+tbltefNumero.Text+'.txt');
               //---------------------------------------------------------------
            end;
      end;
   //---------------------------------------------------------------------------
   if PagamentoVenda.Status then
      begin
         tblvenda.EmptyDataSet;
         SomarVenda;
      end;
   //---------------------------------------------------------------------------
end;

procedure Tfrmprinc.btreiniciarvendaClick(Sender: TObject);
begin
   if messagedlg('Deseja reiniciar a venda em andamento ?!',mtconfirmation,[mbyes,mbno],0)= mryes then
      begin
         tblvenda.EmptyDataSet;
         SomarVenda;
      end;

end;

procedure Tfrmprinc.btutilClick(Sender: TObject);
begin
   Application.CreateForm(Tfrmutil, frmutil);
   frmutil.ShowModal;
end;

procedure Tfrmprinc.edtdigitarKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   case key of
      vk_f2:btconfig.Click;
      vk_f5:btpagar.Click;
      vk_f7:btutil.Click;
      vk_f9:btreiniciarvenda.Click;
   end;
end;

procedure Tfrmprinc.edtdigitarKeyPress(Sender: TObject; var Key: Char);
begin
   if key='*' then
      begin
         key := #0;
         try
            edtqtde.Text    := formatfloat('###,##0.000',strtofloatdef(edtdigitar.Text,1));
            edtdigitar.Text := '';
         except
            edtqtde.Text    := formatfloat('###,##0.000',1);
         end;
      end;
   if key='=' then
      begin
         key := #0;
         try
            edtpreco.Text   := formatfloat('###,##0.000',strtofloatdef(edtdigitar.Text,1));
            edtdigitar.Text := '';
         except
            edtqtde.Text    := formatfloat('###,##0.000',1);
         end;
      end;
   //---------------------------------------------------------------------------
   if key=#13 then
      begin
         if SA_Codigo_de_barras_valido(edtdigitar.Text) then   // Foi digitado um código de barras padrão EAN
            btbuscaprod.Click   // Simular o Click no botão de venda
         else   // Verificar se o que foi digitado é um descritivo
            begin
               //---------------------------------------------------------------
               if edtdigitar.Text='' then
                  edtdigitar.Text := 'PAO COM BANHA';
               if strtofloatdef(edtqtde.Text,1)=0 then   // Se a quantidade não foi digitada assumir "1"
                  edtqtde.Text := '1';
               if strtofloatdef(edtpreco.Text,1)=0 then   // Se o valor não foi digitado, assumir "1.00" um real
                  edtpreco.Text := '1';
               //---------------------------------------------------------------
               tblvenda.Append;  // Incluir o valor na tabela de memória
               tblvenda.FieldByName('descricao').AsString := edtdigitar.Text;
               tblvenda.FieldByName('qtde').AsFloat       := strtofloatdef(edtqtde.Text,1);
               tblvenda.FieldByName('preco').AsFloat      := strtofloatdef(edtpreco.Text,1);
               tblvenda.FieldByName('total').AsFloat      := strtofloatdef(edtqtde.Text,1)*strtofloatdef(edtpreco.Text,1);
               tblvenda.Post;
               //---------------------------------------------------------------
               SomarVenda;   // Somar os produtos selecionados para a venda
               //---------------------------------------------------------------
               edtdigitar.Text := '';   // Limpar os dados para vender o p´róximo item
               edtqtde.Text    := formatfloat('###,##0.000',1);
               edtpreco.Text   := formatfloat('###,##0.000',0);
               //---------------------------------------------------------------
            end;

      end;

   //---------------------------------------------------------------------------
end;

procedure Tfrmprinc.FormActivate(Sender: TObject);
begin
   fundo.Align := alClient;
   if not entrou then
      begin
         entrou := true;
         frmprinc.WindowState := wsMaximized;
         tblvenda.Open;
         tblvenda.EmptyDataSet;
         edtdigitar.SetFocus;
      end;
end;

procedure Tfrmprinc.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   DBGridprod.Columns.SaveToFile(GetCurrentDir+'\gridvenda.cnf');
end;

procedure Tfrmprinc.FormCreate(Sender: TObject);
begin
   //---------------------------------------------------------------------------
   tblvenda.CreateDataSet;   // Inicializando a tabela de vendas - Produtos da tela
   tbltef.CreateDataSet;     // Inicializando a tabela para armazenar as transações TEF
   tblprod.CreateDataSet;    // Inicializando a tabela para armazenar as prodtos da consulta
   //---------------------------------------------------------------------------
   if not DirectoryExists(GetCurrentDir+'\dados') then   // Verificando a existência da pasta dados
      CreateDir(GetCurrentDir+'\dados');   // Criando se não existir
   if not DirectoryExists(GetCurrentDir+'\dados\documentos') then // Verificando a existência da pasta dados\documentos - Para gurdar os comprovantes do TEF e outros diversos
      CreateDir(GetCurrentDir+'\dados\documentos');  // Criando se não existir
   //---------------------------------------------------------------------------
   tbltef.Open;
   tbltef.EmptyDataSet;
   if fileexists(GetCurrentDir+'\dados\tef.xml') then   // Verificando a existência do arquivo tef.xml
      tbltef.LoadFromFile(GetCurrentDir+'\dados\tef.xml');   // Carregando em caso de existir
   //---------------------------------------------------------------------------
   tblprod.Open;
   tblprod.EmptyDataSet;
   if fileexists(GetCurrentDir+'\dados\prod.xml') then   // Verificando a existência do arquivo tef.xml
      tblprod.LoadFromFile(GetCurrentDir+'\dados\prod.xml');   // Carregando em caso de existir
   //---------------------------------------------------------------------------
   if fileexists(GetCurrentDir+'\gridvenda.cnf') then   // Carregando o formato das colunas da GRID
      DBGridprod.Columns.LoadFromFile(GetCurrentDir+'\gridvenda.cnf');
   //---------------------------------------------------------------------------
end;

procedure Tfrmprinc.tbltefDescEventoGetText(Sender: TField; var Text: string;  DisplayText: Boolean);
begin
   case tbltef.FieldByName('OperadoraTEF').AsInteger of
      0:text := 'Solvência - Dinheiro';
      1:text := 'Nenhum';
      2:text := 'TEF VSPague';
      3:text := 'TEF Multiplus';
      4:text := 'TEF ELGIN';
      5:text := 'MKM Pix';
      6:text := 'SMART TEF Vero';
      7:text := 'WEB TEF Mercado Pago';
      8:text := 'Embed-IT TEF';
      9:text := 'Embed-IT Smart Pos';
   end;
end;

procedure Tfrmprinc.tblvendaqtdeGetText(Sender: TField; var Text: string;  DisplayText: Boolean);
begin
   text := transform(se((sender as tfield).Value<>null,(sender as tfield).Value,0))
end;

end.
