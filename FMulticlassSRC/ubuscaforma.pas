unit ubuscaforma;

interface

uses
  midaslib,
  uMulticlassFuncoes,
  uKSTypes,
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Buttons,
  ExtCtrls,
  Grids,
  DBGrids,
  Data.DB,
  Datasnap.DBClient;

type
  Tfrmbuscaforma = class(TForm)
    btok: TBitBtn;
    btcancela: TBitBtn;
    Label9: TLabel;
    Shape2: TShape;
    dbgridforma: TDBGrid;
    fundo: TShape;
    Shape1: TShape;
    Shape3: TShape;
    dtsformas: TDataSource;
    tblformas: TClientDataSet;
    tblformascodigo: TAutoIncField;
    tblformasforma: TStringField;
    tblformasatalho: TStringField;
    tblformasordem: TIntegerField;
    tblformasevento: TIntegerField;
    tblformasDescEvento: TStringField;
    tblformasTipoPgto: TIntegerField;
    tblformasQtdeParcelas: TIntegerField;
    tblformasAruivoImagem: TStringField;
    procedure btokClick(Sender: TObject);
    procedure btcancelaClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgridformaDblClick(Sender: TObject);
    procedure dbgridformaKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
    procedure dbgridformaKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure tblformasDescEventoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
  public
     PagamentoForma : TPagamentoFoma;
  end;

var
  frmbuscaforma: Tfrmbuscaforma;

implementation

{$R *.dfm}

procedure Tfrmbuscaforma.btokClick(Sender: TObject);
begin
   //---------------------------------------------------------------------------
   PagamentoForma.Achou  := true;
   PagamentoForma.Codigo := tblformas.FieldByName('codigo').AsInteger;
   PagamentoForma.Forma  := tblformasforma.Text;
   PagamentoForma.Evento := TKSEventoFormaPgto(tblformas.FieldByName('evento').AsInteger);
   //---------------------------------------------------------------------------
   frmbuscaforma.Close;
   //---------------------------------------------------------------------------
end;

procedure Tfrmbuscaforma.btcancelaClick(Sender: TObject);
begin
   //---------------------------------------------------------------------------
   PagamentoForma.Achou  := false;
   //---------------------------------------------------------------------------
   frmbuscaforma.Close;
   //---------------------------------------------------------------------------
end;

procedure Tfrmbuscaforma.FormActivate(Sender: TObject);
begin
   fundo.Align := alClient;
   tblformas.First;
end;

procedure Tfrmbuscaforma.FormClose(Sender: TObject;var Action: TCloseAction);
begin
   SA_Limpar_Memoria;  // Limpando a memória
end;

procedure Tfrmbuscaforma.FormCreate(Sender: TObject);
begin
   //---------------------------------------------------------------------------
   tblformas.CreateDataSet;
   //---------------------------------------------------------------------------
   if fileexists(GetCurrentDir+'\formas.xml') then
      begin
         tblformas.Close;
         tblformas.Open;
         tblformas.EmptyDataSet;
         tblformas.LoadFromFile(GetCurrentDir+'\formas.xml');
      end;
   //---------------------------------------------------------------------------
end;

procedure Tfrmbuscaforma.tblformasDescEventoGetText(Sender: TField;  var Text: string; DisplayText: Boolean);
begin
   text := '';
   case tblformas.FieldByName('evento').AsInteger of
      0:text := 'Solvência - Dinheiro';
      1:text := 'Nenhum';
      2:text := 'TEF VSPague';
      3:text := 'TEF Multiplus';
      4:text := 'TEF ELGIN';
      5:text := 'MKM Pix';
      6:text := 'SMART TEF Vero';
      7:text := 'Embed-IT TEF';
      8:text := 'Embed-IT Smart Pos';
      9:text := 'Embed-IT PIX';
   end;
end;

procedure Tfrmbuscaforma.dbgridformaDblClick(Sender: TObject);
begin
   btokclick(sender);
end;

procedure Tfrmbuscaforma.dbgridformaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   case key of
      vk_return:btokclick(sender);
      vk_escape:btcancelaclick(sender);
   end;
end;

procedure Tfrmbuscaforma.dbgridformaKeyPress(Sender: TObject; var Key: Char);
var
   registro:integer;
begin
   if charinset(key, [#32..#255]) then
      begin
         registro:=tblformas.RecNo;
         if tblformas.Locate('atalho',UpperCase(key),[]) then
            btok.Click
         else
            begin
               tblformas.RecNo := registro;   // Posicionando o ponteiro da tabela sobre o registro original
               beep;
               showmessage('Sem associação para este atalho !');
            end;
      end;
end;

end.
