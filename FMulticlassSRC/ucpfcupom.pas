unit ucpfcupom;

interface

uses
  uMulticlassFuncoes,
  uPinpad,
  uKSTypes,
  pngimage,
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  Mask,
  Buttons,
  ACBrBase,
  Keyboard;

type
  Tfrmcpfcupom = class(TForm)
    Imagem: TImage;
    edtcpf: TMaskEdit;
    lbdigitar: TLabel;
    Shape1: TShape;
    btok: TSpeedButton;
    teclado: TTouchKeyboard;
    fundo: TShape;
    Label2: TLabel;
    Label3: TLabel;
    Shape2: TShape;
    btpinpad: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure btokClick(Sender: TObject);
    procedure edtcpfKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure btpinpadClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    CNPJ_CPF      : string;
    LConfigPinPad : TKSConfigPinPad;  // Configurações do PINPAD
    UF            : string;
  end;

var
  frmcpfcupom: Tfrmcpfcupom;

implementation


{$R *.dfm}

//------------------------------------------------------------------------------
//   Capturar CPF do PINPAD
//------------------------------------------------------------------------------
procedure SA_PinPadCapturarCPF;
var
   CPF    : string;
   Pinpad : TKSPinpad;
begin
   //---------------------------------------------------------------------------
   TThread.CreateAnonymousThread(procedure
      begin
         Pinpad := TKSPinpad.create(frmcpfcupom.LConfigPinPad);
         CPF := Pinpad.CapturarCPF;
         Pinpad.MostrarImagem(frmcpfcupom.LConfigPinPad.PINPAD_Imagem);
         Pinpad.free;
         frmcpfcupom.CNPJ_CPF := CPF;
         frmcpfcupom.Close;
      end).Start;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
procedure Tfrmcpfcupom.FormActivate(Sender: TObject);
begin
   //---------------------------------------------------------------------------
   fundo.Align             := alClient;
   frmcpfcupom.WindowState := wsMaximized;
   //---------------------------------------------------------------------------
   if uf<>'' then
      begin
         try
            frmcpfcupom.Imagem.Picture.LoadFromFile(GetCurrentDir+'\icones\NF'+uf+'.bmp');
         except

         end;
      end;
   frmcpfcupom.Imagem.Stretch := true;
   //---------------------------------------------------------------------------
   edtcpf.SelectAll;
   //---------------------------------------------------------------------------
end;

procedure Tfrmcpfcupom.btokClick(Sender: TObject);
var
   validado:boolean;
begin
   if not btok.Enabled then
      exit;
   //---------------------------------------------------------------------------
   validado := true;
   if edtcpf.Text<>'' then
      validado := SA_ValidarCPFouCNPJ(edtcpf.Text);
   if not validado then
      begin
         beep;
         ShowMessage('CPF ou CNPJ inválido !!!');
         //---------------------------------------------------------------------
         edtcpf.SelectAll;
         edtcpf.SetFocus;
         //---------------------------------------------------------------------
      end
   else
      begin
         frmcpfcupom.CNPJ_CPF := SA_Limpacampo(edtcpf.Text);
         frmcpfcupom.Close;
      end;
end;

procedure Tfrmcpfcupom.FormKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
   case key of
      vk_return:key := 0;
      vk_escape:key := 0;
   end;
   if key=vk_return then
      key := 0;
end;

procedure Tfrmcpfcupom.btpinpadClick(Sender: TObject);
begin
   if LConfigPinPad.PINPAD_Porta<>'' then
      begin
         btok.Enabled      := false;
         btpinpad.Enabled  := false;
         edtcpf.ReadOnly   := true;
         lbdigitar.Caption := 'Digite no PINPAD';
         Application.ProcessMessages;
         SA_PinPadCapturarCPF;
         edtcpf.Text       := frmcpfcupom.CNPJ_CPF;
         lbdigitar.Caption := 'CPF ou CNPJ';
         Application.ProcessMessages;
         btok.Enabled      := true;
         btpinpad.Enabled  := true;
         edtcpf.ReadOnly   := false;
         edtcpf.SetFocus;
         if edtcpf.Text<>'' then
            btok.Click;
      end;
end;

procedure Tfrmcpfcupom.edtcpfKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
   if edtcpf.ReadOnly then
      exit;
   case key of
      vk_f2:btpinpad.Click;
      vk_return:btok.Click;
      vk_escape:begin
                   edtcpf.Text := '';
                   btok.Click;      
                end;
   end;
end;

end.


















