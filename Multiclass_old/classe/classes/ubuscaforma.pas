unit ubuscaforma;

interface

uses
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
  Data.DB;

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
    procedure btokClick(Sender: TObject);
    procedure btcancelaClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgridformaDblClick(Sender: TObject);
    procedure dbgridformaKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
    procedure dbgridformaKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
     PagamentoForma : TPagamentoFoma;
  end;

var
  frmbuscaforma: Tfrmbuscaforma;

implementation

uses udmMulticlass;

{$R *.dfm}

procedure Tfrmbuscaforma.btokClick(Sender: TObject);
begin
   //---------------------------------------------------------------------------
   PagamentoForma.Achou  := true;
   PagamentoForma.Codigo := dmMulticlass.tblformas.FieldByName('codigo').AsInteger;
   PagamentoForma.Forma  := dmMulticlass.tblformasforma.Text;
   PagamentoForma.Evento := TKSEventoFormaPgto(dmMulticlass.tblformas.FieldByName('evento').AsInteger);
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
   dmMulticlass.tblformas.First;
end;

procedure Tfrmbuscaforma.FormClose(Sender: TObject;var Action: TCloseAction);
begin
   SA_Limpar_Memoria;  // Limpando a memória
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
         registro:=dmMulticlass.tblformas.RecNo;
         if dmMulticlass.tblformas.Locate('atalho',UpperCase(key),[]) then
            btok.Click
         else
            begin
               dmMulticlass.tblformas.RecNo := registro;   // Posicionando o ponteiro da tabela sobre o registro original
               beep;
               showmessage('Sem associação para este atalho !');
            end;
      end;
end;

end.
