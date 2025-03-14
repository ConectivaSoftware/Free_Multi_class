unit udmMulticlass;

interface

uses
  uMulticlassFuncoes,
  variants,
  Midaslib,
  System.SysUtils,
  System.Classes,
  Data.DB,
  Datasnap.DBClient;

type
  TdmMulticlass = class(TDataModule)
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
    dtsformas: TDataSource;
    tblpgto: TClientDataSet;
    StringField1: TStringField;
    IntegerField2: TIntegerField;
    StringField3: TStringField;
    dtspgto: TDataSource;
    tblpgtoValor: TFloatField;
    tblpgtocodigo: TIntegerField;
    tblpgtoFormaTEF: TIntegerField;
    tblpgtoQtdeParcelas: TIntegerField;
    procedure tblformasDescEventoGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure DataModuleCreate(Sender: TObject);
    procedure tblpgtoValorGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmMulticlass: TdmMulticlass;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmMulticlass.DataModuleCreate(Sender: TObject);
begin
   //---------------------------------------------------------------------------
   dmMulticlass.tblformas.CreateDataSet;
   dmMulticlass.tblpgto.CreateDataSet;
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

procedure TdmMulticlass.tblformasDescEventoGetText(Sender: TField;  var Text: string; DisplayText: Boolean);
begin
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
   end;
end;

procedure TdmMulticlass.tblpgtoValorGetText(Sender: TField; var Text: string;DisplayText: Boolean);
begin
   text := transform(se((Sender as TField).value<>null,(Sender as TField).value,0));
end;

end.
