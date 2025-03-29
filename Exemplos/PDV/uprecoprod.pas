unit uprecoprod;

interface

uses
  uMulticlassFuncoes,
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Buttons,
  StdCtrls,
  Mask,
  ExtCtrls;

type
  Tfrmprecoprod = class(TForm)
    btsalvar: TSpeedButton;
    btvolta: TSpeedButton;
    Label3: TLabel;
    edtdescricao: TMaskEdit;
    Label9: TLabel;
    edtun: TMaskEdit;
    Label6: TLabel;
    edtbarra: TMaskEdit;
    Shape4: TShape;
    titulo: TLabel;
    Label15: TLabel;
    edtvenda: TMaskEdit;
    Bevel1: TBevel;
    fundo: TShape;
    procedure btvoltaClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btsalvarClick(Sender: TObject);
    procedure edtvendaKeyPress(Sender: TObject; var Key: Char);
    procedure edtvendaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmprecoprod: Tfrmprecoprod;

implementation

{$R *.dfm}

procedure Tfrmprecoprod.btsalvarClick(Sender: TObject);
begin
   edtvenda.Text := transform(untransform(edtvenda.Text));
   frmprecoprod.Close;
end;

procedure Tfrmprecoprod.btvoltaClick(Sender: TObject);
begin
   frmprecoprod.Close;
end;

procedure Tfrmprecoprod.edtvendaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   case key of
      vk_escape:btvolta.Click;
      vk_return:btsalvar.Click;
   end;
end;

procedure Tfrmprecoprod.edtvendaKeyPress(Sender: TObject; var Key: Char);
begin
   if key='.' then
      key := ',';
   if not charinset(key, ['0'..'9',',',#8]) then
      key := #0;
end;

procedure Tfrmprecoprod.FormActivate(Sender: TObject);
begin
   fundo.Align    := alClient;
   edtvenda.SelectAll;
   edtvenda.SetFocus;
end;

procedure Tfrmprecoprod.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   frmprecoprod.Release;
end;

end.
