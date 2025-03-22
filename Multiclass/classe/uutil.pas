unit uutil;

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
  Vcl.Buttons;

type
  Tfrmutil = class(TForm)
    fundo: TShape;
    Shape2: TShape;
    Label20: TLabel;
    btadmelgin: TSpeedButton;
    btvoltar: TBitBtn;
    btlistatef: TSpeedButton;
    btVBIPendencias: TSpeedButton;
    btVBIExtrato: TSpeedButton;
    btEnviarXML: TSpeedButton;
    btmovifluxo: TSpeedButton;
    procedure btvoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btadmelginClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btvoltarKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btvoltarKeyPress(Sender: TObject; var Key: Char);
    procedure btlistatefClick(Sender: TObject);
    procedure btVBIPendenciasClick(Sender: TObject);
    procedure btVBIExtratoClick(Sender: TObject);
    procedure btEnviarXMLClick(Sender: TObject);
    procedure btmovifluxoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmutil: Tfrmutil;

implementation

{$R *.dfm}

uses urelatorio, uenviarXML, uconciliacao;

procedure Tfrmutil.btEnviarXMLClick(Sender: TObject);
begin
   Application.CreateForm(TfrmenviarXML, frmenviarXML);
   frmenviarXML.ShowModal;
end;

procedure Tfrmutil.btlistatefClick(Sender: TObject);
begin
   Application.CreateForm(Tfrmrelatorio, frmrelatorio);
   frmrelatorio.ShowModal;
end;

procedure Tfrmutil.btmovifluxoClick(Sender: TObject);
begin
  Application.CreateForm(Tfrmconciliacao, frmconciliacao);
  frmconciliacao.ShowModal;
end;

procedure Tfrmutil.btVBIExtratoClick(Sender: TObject);
var
   Multiclass : TMulticlass;     // Para aprocessar o pagamento
begin
   //---------------------------------------------------------------------------
   Multiclass := TMulticlass.create;
   Multiclass.VSPagueExtrato;
   Multiclass.Destroy;
   //---------------------------------------------------------------------------
end;

procedure Tfrmutil.btVBIPendenciasClick(Sender: TObject);
var
   Multiclass : TMulticlass;     // Para aprocessar o pagamento
begin
   //---------------------------------------------------------------------------
   Multiclass := TMulticlass.create;
   Multiclass.VSPaguePendencias;
   Multiclass.Destroy;
   //---------------------------------------------------------------------------
end;

procedure Tfrmutil.btvoltarClick(Sender: TObject);
begin
   frmutil.Close;
end;

procedure Tfrmutil.btvoltarKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   case key of
      vk_escape:btvoltar.Click;
   end;
end;

procedure Tfrmutil.btvoltarKeyPress(Sender: TObject; var Key: Char);
begin
   if charinset(key,['A','a']) then
      btadmelgin.Click;
   if charinset(key,['B','b']) then
      btVBIPendencias.Click;
   if charinset(key,['C','c']) then
      btVBIExtrato.Click;
   if charinset(key,['Z','z']) then
      btlistatef.Click;
end;

procedure Tfrmutil.FormActivate(Sender: TObject);
begin
   fundo.Align := alClient;
end;

procedure Tfrmutil.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   frmutil.Release;
end;

procedure Tfrmutil.btadmelginClick(Sender: TObject);
var
   Multiclass : TMulticlass;     // Para aprocessar o pagamento
begin
   //---------------------------------------------------------------------------
   Multiclass := TMulticlass.create;
   Multiclass.ELGINAdm;
   Multiclass.Destroy;
   //---------------------------------------------------------------------------
end;

end.
