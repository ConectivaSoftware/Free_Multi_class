unit uPinpad;

interface

uses
   ACBrAbecsPinPad,
   uMulticlassFuncoes,
   ACBrDeviceSerial,
   System.Classes,
   System.SysUtils,
   System.Math,
   Vcl.Imaging.pngimage,
   Vcl.ExtCtrls,
   uKSTypes;

type
   TKSPinpad = class
      private
         //---------------------------------------------------------------------
         LConfigPinPad : TKSConfigPinPad;
         //---------------------------------------------------------------------
         Pinpad        : TACBrAbecsPinPad;     // PINPAD
         //---------------------------------------------------------------------
         procedure SA_DetectarPinpad;
         //---------------------------------------------------------------------
      public
         constructor create(ConfPinpad : TKSConfigPinPad); overload;
         constructor create; overload;
         //---------------------------------------------------------------------
         property ConfigPinPad : TKSConfigPinPad read LConfigPinPad write LConfigPinPad;
         //---------------------------------------------------------------------
         function DetectarPinpad:TKSConfigPinPad;
         function TamanhoTela:integer;
         procedure MostrarImagem(arquivo:string);overload;
         procedure MostrarImagem(imagem : TPngImage);overload;
         function CapturarCPF:string;
         //---------------------------------------------------------------------
   end;

implementation

{ TKSPinpad }


function TKSPinpad.CapturarCPF: string;
begin
   try
      PinPad.IsEnabled   := true;
      PinPad.OPN;
      result := PinPad.GCD(msgDigiteCPF, 180);
      PinPad.CLO;
      PinPad.IsEnabled   := false;
   except
      result := '';
   end;
end;

constructor TKSPinpad.create;
begin
   PinPad := TACBrAbecsPinPad.Create(nil);
   SA_DetectarPinpad;
end;

constructor TKSPinpad.create(ConfPinpad: TKSConfigPinPad);
begin
   PinPad        := TACBrAbecsPinPad.Create(nil);
   LConfigPinPad := ConfPinpad;
   //---------------------------------------------------------------------------
   PinPad.IsEnabled        := false;
   PinPad.LogFile          := getcurrentdir+'\TEF_Log\pinpadlog.txt';
   PinPad.LogLevel         := 2;
   PinPad.Port             := LConfigPinPad.PINPAD_Porta;
   PinPad.MsgAlign         := alCenter;
   PinPad.MsgWordWrap      := true;
   PinPad.Device.Baud      := LConfigPinPad.PINPAD_Baud;
   PinPad.Device.Data      := LConfigPinPad.PINPAD_DataBits;
   PinPad.Device.Stop      := LConfigPinPad.PINPAD_StopBit;
   PinPad.Device.HandShake := LConfigPinPad.PINPAD_HandShaking;
   PinPad.Device.Parity    := LConfigPinPad.PINPAD_Parity;
   PinPad.Device.SoftFlow  := LConfigPinPad.PINPAD_SoftFlow;
   PinPad.Device.HardFlow  := LConfigPinPad.PINPAD_HardFlow;
   //---------------------------------------------------------------------------
end;

function TKSPinpad.DetectarPinpad: TKSConfigPinPad;
begin
   try
      SA_DetectarPinpad;
   except

   end;
   Result := LConfigPinPad;
end;

procedure TKSPinpad.MostrarImagem(imagem: TPngImage);
var
   ms      : TMemoryStream;
begin
   try
      PinPad.IsEnabled   := true;
      ms := TMemoryStream.Create;
      imagem.SaveToStream(ms);
      PinPad.OPN;
      PinPad.LoadMedia( 'LOGO', ms, mtPNG);
      PinPad.DSI('LOGO');
      PinPad.CLO;
      PinPad.IsEnabled   := false;
   except on e:exception do
      begin
         SA_SalvarLog('ERRO PINTAR LOGO NO PINPAD',e.Message,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',true);
      end;

   end;
end;

procedure TKSPinpad.MostrarImagem(arquivo: string);
var
   ms      : TMemoryStream;
   png     : TPngImage;
begin
   if not fileexists(arquivo) then
      exit;
   //---------------------------------------------------------------------------
   PinPad.Port             := LConfigPinPad.PINPAD_Porta;
   PinPad.Device.Baud      := LConfigPinPad.PINPAD_Baud;
   PinPad.Device.Data      := LConfigPinPad.PINPAD_DataBits;
   PinPad.Device.Stop      := LConfigPinPad.PINPAD_StopBit;
   PinPad.Device.Parity    := LConfigPinPad.PINPAD_Parity;
   PinPad.Device.HandShake := LConfigPinPad.PINPAD_HandShaking;
   PinPad.Device.SoftFlow  := LConfigPinPad.PINPAD_SoftFlow;
   PinPad.Device.HardFlow  := LConfigPinPad.PINPAD_HardFlow;
   //---------------------------------------------------------------------------
   png := TPngImage.Create;
   try
      png.LoadFromFile(arquivo);
   except

   end;
   ms := TMemoryStream.Create;
   //---------------------------------------------------------------------------
   try
      //------------------------------------------------------------------------
      Pinpad.IsEnabled   := true;
      png.SaveToStream(ms);
      //------------------------------------------------------------------------
      Pinpad.OPN;
      Pinpad.LoadMedia( 'LOGO', ms, mtPNG);
      Pinpad.DSI('LOGO');
      Pinpad.CLO;
      //------------------------------------------------------------------------
      Pinpad.IsEnabled   := false;
   except
   end;
   //---------------------------------------------------------------------------
   ms.Free;
   png.Free;
   //---------------------------------------------------------------------------
end;

procedure TKSPinpad.SA_DetectarPinpad;
var
   //---------------------------------------------------------------------------
   sl      : TStringList;
   i       : Integer;
   //---------------------------------------------------------------------------
   Config  : TKSConfigPinPad;
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   //   PinPad := TACBrAbecsPinPad.Create(nil);
   //---------------------------------------------------------------------------
   sl := TStringList.Create;
   try
      PinPad.Device.AcharPortasSeriais( sl );
      i := 0;
      Config.PINPAD_Porta := '';
      while (i < sl.Count) and (Config.PINPAD_Porta = '') do
         begin
            try
               PinPad.Disable;
               PinPad.Port := sl[i];
               PinPad.Enable;
               try
                  //------------------------------------------------------------
                  PinPad.OPN;
                  PinPad.CLO;
                  //------------------------------------------------------------
                  LConfigPinPad.PINPAD_Porta       := PinPad.Port;
                  LConfigPinPad.PINPAD_Baud        := PinPad.Device.Baud;
                  LConfigPinPad.PINPAD_DataBits    := PinPad.Device.Data;
                  LConfigPinPad.PINPAD_StopBit     := PinPad.Device.Stop;
                  LConfigPinPad.PINPAD_Parity      := PinPad.Device.Parity;
                  LConfigPinPad.PINPAD_HandShaking := PinPad.Device.HandShake;
                  LConfigPinPad.PINPAD_SoftFlow    := PinPad.Device.SoftFlow;
                  LConfigPinPad.PINPAD_HardFlow    := PinPad.Device.HardFlow;
                  //------------------------------------------------------------
               finally
                   PinPad.Disable;
               end;
            except
            end;
            Inc(i);
         end;
      //------------------------------------------------------------------------
   finally
     sl.Free;
   end;
   //---------------------------------------------------------------------------
end;

function TKSPinpad.TamanhoTela: integer;  // Obter o menor tamanho da tela
begin
   PinPad.IsEnabled   := true;
   Result := min( PinPad.PinPadCapabilities.DisplayGraphicPixels.Cols,
                     PinPad.PinPadCapabilities.DisplayGraphicPixels.Rows) - 20;
   PinPad.IsEnabled   := false;;
end;

end.
