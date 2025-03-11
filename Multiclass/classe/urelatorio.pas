unit urelatorio;

interface

uses
  uMulticlass,
//  acbrposprinter,
  uKSTypes,
  Winapi.shellAPI,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Data.DB,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  Vcl.Grids,
  Vcl.DBGrids;

type
  Tfrmrelatorio = class(TForm)
    DBGridtef: TDBGrid;
    pntitulo: TPanel;
    pnrodape: TPanel;
    btcancelartef: TSpeedButton;
    btcancelar: TSpeedButton;
    btcomprovante: TSpeedButton;
    btreimprimir: TSpeedButton;
    procedure btcancelarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btcomprovanteClick(Sender: TObject);
    procedure DBGridtefKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btreimprimirClick(Sender: TObject);
    procedure btcancelartefClick(Sender: TObject);
    procedure DBGridtefDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmrelatorio: Tfrmrelatorio;

implementation

{$R *.dfm}

uses uprinc;

procedure Tfrmrelatorio.btcancelarClick(Sender: TObject);
begin
   frmrelatorio.Close;
end;

procedure Tfrmrelatorio.btcancelartefClick(Sender: TObject);
var
   Cancelamento : TDadosCancelamento;
   Multiclass   : TMulticlass;
   cancelou     : boolean;
begin
   //---------------------------------------------------------------------------
   if not frmprinc.tbltef.FieldByName('status').AsBoolean then
      begin
         beep;
         showmessage('A operação TEF não foi aprovada. Não é possível cancelar !');
         exit;
      end;
   //---------------------------------------------------------------------------
   if frmprinc.tbltef.FieldByName('cancelado').AsBoolean then
      begin
         beep;
         showmessage('A operação TEF já foi cancelada !');
         exit;
      end;
   //---------------------------------------------------------------------------
   Cancelamento.NSU       := frmprinc.tbltefNSU.Text;
   Cancelamento.Data      := frmprinc.tbltef.FieldByName('DataHora').AsDateTime;
   Cancelamento.Valor     := frmprinc.tbltef.FieldByName('valor').AsFloat;
   Cancelamento.Documento := '';
   Cancelamento.Evento    := TKSEventoFormaPgto(frmprinc.tbltef.FieldByName('OperadoraTEF').AsInteger);
   if Cancelamento.Evento=tpKSEventoVSSPague then
      begin
//         if frmprinc.tbltef.FieldByName('OperadoraTEF').AsInteger then

      end;

   //---------------------------------------------------------------------------
   Multiclass := TMulticlass.create;
   cancelou   := Multiclass.CancelarTransacao(Cancelamento);
   Multiclass.Free;
   //---------------------------------------------------------------------------
   if cancelou then
      begin
         frmprinc.tbltef.Edit;
         frmprinc.tbltef.FieldByName('cancelado').AsBoolean := true;
         frmprinc.tbltef.Post;
         frmprinc.tbltef.SaveToFile(GetCurrentDir+'\dados\tef.xml');  // Salvando a tabela TEF
      end;
   //---------------------------------------------------------------------------


end;

procedure Tfrmrelatorio.btcomprovanteClick(Sender: TObject);
begin
   if frmprinc.tbltef.RecordCount>0 then   // Verificando se o dataset possui algum registro para processar
      begin
         //---------------------------------------------------------------------
         if fileexists(GetCurrentDir+'\dados\documentos\tefCLI_'+frmprinc.tbltefNumero.Text+'.txt') then
            ShellExecute(GetDesktopWindow,'open',pchar(GetCurrentDir+'\dados\documentos\tefCLI_'+frmprinc.tbltefNumero.Text+'.txt'),nil,nil,sw_ShowNormal)
         else
            begin
               beep;
               ShowMessage('O arquivo do comprovante não foi encontrado na pasta !');
            end;
         //---------------------------------------------------------------------
      end
   else
      begin
         // O dataset está vazio, não foi realizada nenhuma operação de TEF ainda
         beep;
         ShowMessage('Não existe nenhuma transação para processar !');
      end;
end;

procedure Tfrmrelatorio.btreimprimirClick(Sender: TObject);
var
   Multiclass : TMulticlass;
begin
   Multiclass := TMulticlass.create;
   Multiclass.ImprimirArquivo(GetCurrentDir+'\dados\documentos\tefCLI_'+frmprinc.tbltefNumero.Text+'.txt');
   Multiclass.Free;
end;

procedure Tfrmrelatorio.DBGridtefDrawColumnCell(Sender: TObject;  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
   with (Sender as TDBGrid) do
      begin
        if frmprinc.tbltef.FieldByName('status').AsBoolean then  // O TEF foi transmitido e aprovado
           begin
              if frmprinc.tbltef.FieldByName('cancelado').AsBoolean then   // A transação foi cancelada - Cor vermelha e amarela
                 begin
                    Canvas.Brush.Color := clRed;
                    Canvas.Font.Color  := clYellow;
                 end;
           end
        else // A transação não foi aprovada - Cor de inativa
           begin
              Canvas.Brush.Color := clInactiveCaption;
              Canvas.Font.Color  := clGray;
           end;
        if gdSelected in State then
           begin
              Canvas.Brush.Color := clActiveCaption;
              Canvas.Font.Color  := clWhite;
           end;
         DefaultDrawColumnCell(Rect, DataCol, Column, State);
      end;

end;

procedure Tfrmrelatorio.DBGridtefKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   case key of
      vk_escape:btcancelar.Click;
      vk_f2:btcomprovante.Click;
      vk_f5:btreimprimir.Click;
      vk_f6:btcancelartef.Click;
   end;
end;

procedure Tfrmrelatorio.FormActivate(Sender: TObject);
begin
   //---------------------------------------------------------------------------
   pntitulo.Align := alTop;
   pnrodape.Align := alBottom;
   //---------------------------------------------------------------------------
   DBGridtef.Align := alClient;
   //---------------------------------------------------------------------------
   frmrelatorio.WindowState := wsMaximized;

end;

end.
