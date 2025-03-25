unit uprinc;

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
  Vcl.Buttons,
  Vcl.StdCtrls,
  Vcl.Mask, Vcl.ExtCtrls;

type
  Tfrmprinc = class(TForm)
    edtdescricao: TMaskEdit;
    edtun: TMaskEdit;
    edtmarca: TMaskEdit;
    edtncm: TMaskEdit;
    edtcest: TMaskEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edtbarra: TMaskEdit;
    edtref: TMaskEdit;
    SpeedButton1: TSpeedButton;
    edttoken: TMaskEdit;
    Label5: TLabel;
    Label9: TLabel;
    Shape1: TShape;
    Label10: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmprinc: Tfrmprinc;

implementation

{$R *.dfm}

procedure Tfrmprinc.SpeedButton1Click(Sender: TObject);
var
   Multiclass : TMulticlass;
begin
   if edttoken.Text<>'' then   // Verificar se o Token está vazio
      begin
         if edtbarra.Text<>'' then
            begin
               Multiclass                   := TMulticlass.create;
               Multiclass.TokenConsultaProd := edttoken.Text;
               Multiclass.ConsultarProduto(edtbarra.Text);
               if Multiclass.Produto.Consultou then
                  begin
                     edtbarra.Text     := Multiclass.Produto.Produto.barra;
                     edtref.Text       := Multiclass.Produto.Produto.ref;
                     edtdescricao.Text := Multiclass.Produto.Produto.descricao;
                     edtun.Text        := Multiclass.Produto.Produto.un;
                     edtmarca.Text     := Multiclass.Produto.Produto.marca;
                     edtncm.Text       := Multiclass.Produto.Produto.ncm;
                     edtcest.Text      := Multiclass.Produto.Produto.cest;
                  end;
               Multiclass.Free;
            end;
      end
   else
      begin
         beep;
         ShowMessage('Falta o TOKEN.');
      end;

end;

end.
