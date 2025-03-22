unit uMulticlassFuncoes;

interface

uses
   synacode,
   IdHTTP,
   ACBrPosPrinter,
   ACBrAbecsPinPad,
   pngimage,
   psapi,
   uKSTypes,
   winapi.windows,
   forms,
   acbrutil.Math,
   acbrvalidador,
   System.Classes,
   system.sysutils;
//------------------------------------------------------------------------------
procedure SA_Limpar_Memoria;
function transform(valor:real):string;
function untransform(palavra:string):real;
function SA_Codigo_de_barras_valido(codigo:string):boolean;
function SA_ValidarCPF(cpf:string):boolean;
function SA_ValidarCNPJ(cnpj:string):boolean;
function SA_ValidarCPFouCNPJ(documento:string):boolean;
function se(expressao:boolean;ret1,ret2:Variant):Variant;
function DataValida(data:string):boolean;
function SA_Limpacampo(campo:string):string;
procedure SA_Salva_Arquivo_Incremental(linha,nome_arquivo:string);
procedure SA_ConfigMultiPlus(MensagemPadrao:string ; porta:string = '');
function strzero(valor,qtd:integer):string;
procedure SA_ImprimirTexto(texto:string;impressora:TKSConfigImpressora);
//------------------------------------------------------------------------------
//  PINPAD
function SA_PINPAD_CapturarCPF(ConfigPinPad:TKSConfigPinPad):string;
function SA_ConfigurarPinPad(ConfigPinPad:TKSConfigPinPad):TACBrAbecsPinPad;
function SA_PINPAD_MostrarLogo(ConfigPinpad : TKSConfigPinPad):boolean;
//------------------------------------------------------------------------------
function SA_Enviar_Arquivo(host_api,chave,arquivo:string):boolean;
procedure SA_SalvarLog(titulo, dado,arquivo: string;LSalvarLog : boolean = true);
//------------------------------------------------------------------------------
implementation

//------------------------------------------------------------------------------
//   Salvar LOG
//------------------------------------------------------------------------------
procedure SA_SalvarLog(titulo, dado,arquivo: string;LSalvarLog : boolean = true);
begin
   if LSalvarLog then
      SA_Salva_Arquivo_Incremental(titulo + ' ' +
                                   formatdatetime('dd/mm/yyyy hh:mm:ss',now)+#13+dado,
                                   arquivo);
end;
//------------------------------------------------------------------------------
//   Configurar o PINPAD
//------------------------------------------------------------------------------
function SA_ConfigurarPinPad(ConfigPinPad:TKSConfigPinPad):TACBrAbecsPinPad;
begin
   Result := TACBrAbecsPinPad.Create(nil);
   //---------------------------------------------------------------------------
   Result.IsEnabled   := false;
   //---------------------------------------------------------------------------
   Result.LogFile          := getcurrentdir+'\TEF_Log\pinpadlog.txt';
   Result.LogLevel         := 2;
   Result.Port             := ConfigPinPad.PINPAD_Porta;
   Result.MsgAlign         := alCenter;
   Result.MsgWordWrap      := true;
   Result.Device.Baud      := ConfigPinPad.PINPAD_Baud;
   Result.Device.Data      := ConfigPinPad.PINPAD_DataBits;
   Result.Device.Stop      := ConfigPinPad.PINPAD_StopBit;
   Result.Device.HandShake := ConfigPinPad.PINPAD_HandShaking;
   Result.Device.Parity    := ConfigPinPad.PINPAD_Parity;
   Result.Device.SoftFlow  := ConfigPinPad.PINPAD_SoftFlow;
   Result.Device.HardFlow  := ConfigPinPad.PINPAD_HardFlow;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
// Mostrar imagem na tela do PINPAD
//------------------------------------------------------------------------------
function SA_PINPAD_MostrarLogo(ConfigPinpad : TKSConfigPinPad):boolean;
var
   ms      : TMemoryStream;
   LPinPad : TACBrAbecsPinPad;
   imagem  : TPngImage;
begin
   //---------------------------------------------------------------------------
   if not fileexists(ConfigPinpad.PINPAD_Imagem) then
      exit;
   //---------------------------------------------------------------------------
   LPinPad := SA_ConfigurarPinPad(ConfigPinpad);
   ms      := TMemoryStream.Create;
   imagem  := TPngImage.Create;
   imagem.LoadFromFile(ConfigPinpad.PINPAD_Imagem);
   //---------------------------------------------------------------------------
   try
      //------------------------------------------------------------------------
      LPinPad.IsEnabled   := true;
      imagem.SaveToStream(ms);
      //------------------------------------------------------------------------
      LPinPad.OPN;
      LPinPad.LoadMedia( 'LOGO', ms, mtPNG);
      LPinPad.DSI('LOGO');
      LPinPad.CLO;
      //------------------------------------------------------------------------
      LPinPad.IsEnabled   := false;
      Result := true;
   except
      Result := false;
   end;
   //---------------------------------------------------------------------------
   ms.Free;
   LPinPad.Free;
   imagem.Free;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
// Mostrar imagem na tela do PINPAD
//------------------------------------------------------------------------------
function SA_PINPAD_CapturarCPF(ConfigPinPad:TKSConfigPinPad):string;
var
   LPinPad : TACBrAbecsPinPad;
begin
   LPinPad := SA_ConfigurarPinPad(ConfigPinpad);
   try
      LPinPad.IsEnabled   := true;
      LPinPad.OPN;
      result := LPinPad.GCD(msgDigiteCPF, 180);
      LPinPad.CLO;
      LPinPad.IsEnabled   := false;
   except
      result := '';
   end;
   LPinPad.Free;
end;
//------------------------------------------------------------------------------
//   Imprimir um texto na impressora ESC POS
//------------------------------------------------------------------------------
procedure SA_ImprimirTexto(texto:string;impressora:TKSConfigImpressora);
var
   d           : integer;
   ImpressoraL : TACBrPosPrinter;
   linhas      : TStringList;
begin
   //---------------------------------------------------------------------------
   for d := 1 to Impressora.Avanco do
      texto := texto + '</lf>';
   texto := texto + '</corte_total>';
   linhas      := TStringList.Create;
   linhas.Text := texto;
   //---------------------------------------------------------------------------
   ImpressoraL                    := TACBrPosPrinter.Create(nil);
   ImpressoraL.Modelo             := impressora.Modelo;
   ImpressoraL.Porta              := impressora.Nome;
   ImpressoraL.ColunasFonteNormal := 48;
   ImpressoraL.Buffer.Clear;
   ImpressoraL.Buffer.AddStrings(linhas);
   try
      ImpressoraL.Ativar;
      ImpressoraL.Imprimir;
      ImpressoraL.Desativar;
   except

   end;
   ImpressoraL.Buffer.Clear;
   ImpressoraL.Free;
   linhas.Free;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
function strzero(valor,qtd:integer):string;
begin
  Result := StringOfChar('0',qtd)+inttostr(valor);
  Result := copy(Result,length(Result)-(qtd-1),qtd);
end;
//------------------------------------------------------------------------------
//   Configurar a porta do PINPAD para a MULTIPLUS
//------------------------------------------------------------------------------
procedure SA_ConfigMultiPlus(MensagemPadrao:string ; porta:string = '');
var
   linhas       : TStringList;
   porta_pinpad : string;
   d            : integer;
   achou        : boolean;
begin
   //---------------------------------------------------------------------------
   //   Porta=3
   //   MensagemPadrao=MULTIPLUS CARD
   //   TransacoesAdicionaisHabilitadas=29
   //   ConfirmacaoAutomatica=SIM
   //   ExibirQrCode=1
   //   TimeoutPinPad=5
   //---------------------------------------------------------------------------
   if DirectoryExists('C:\ClientD') then
      begin
         //---------------------------------------------------------------------
         linhas := TStringList.Create;
         //---------------------------------------------------------------------
         if MensagemPadrao='' then
            MensagemPadrao := 'Free Multiclass';
         //---------------------------------------------------------------------
         if not fileexists(getcurrentdir+'\ConfigMC.ini') then   //   Salvando as configurações do caminho do executável TEF MULTIPLUS
            begin
               linhas.Clear;
               linhas.Add('CAMINHO=C:\ClientD');
               linhas.SaveToFile(GetCurrentDir+'\ConfigMC.ini');
            end;
         //---------------------------------------------------------------------
         linhas.Clear;
         if FileExists('C:\ClientD\CliMC.ini') then
            linhas.LoadFromFile('C:\ClientD\CliMC.ini');
         if linhas.Count>0 then
            begin
               //---------------------------------------------------------------
               if (pos('COM',uppercase(porta))>0) and (length(porta)>3) then
                  begin
                     porta_pinpad := copy(porta,4,length(porta)-3);
                     if strtointdef(porta_pinpad,0)=0 then
                        porta_pinpad := 'AUTO_USB';
                  end
               else
                  porta_pinpad := 'AUTO_USB';
               //---------------------------------------------------------------
               achou := false;
               for d := 1 to linhas.Count do
                  begin
                     if pos('TransacoesAdicionaisHabilitadas=',linhas[d-1])>0 then
                        linhas[d-1] := 'TransacoesAdicionaisHabilitadas=';
                     if pos('Porta=',linhas[d-1])>0 then
                        begin
                           linhas[d-1] := 'Porta='+porta_pinpad;
                           achou       := true;
                        end;
                  end;
               if not achou then
                  linhas.Add('Porta='+porta_pinpad);
               //---------------------------------------------------------------
               //  Configuração da apresentação do QRCODE
               //---------------------------------------------------------------
               achou := false;
               for d := 1 to linhas.Count do
                  begin
                     if pos('ExibirQrCode=',linhas[d-1])>0 then
                        begin
                           linhas[d-1] := 'ExibirQrCode=0';
                           achou       := true;
                        end;
                  end;
               if not achou then
                  linhas.Add('ExibirQrCode=0');
               //---------------------------------------------------------------
               //   Configuração da mensagem padrão no PINPAD
               //---------------------------------------------------------------
               achou := false;
               for d := 1 to linhas.Count do
                  begin
                     if pos('MensagemPadrao=',linhas[d-1])>0 then
                        begin
                           linhas[d-1] := 'MensagemPadrao='+MensagemPadrao;
                           achou       := true;
                        end;
                  end;
               if not achou then
                  linhas.Add('MensagemPadrao='+MensagemPadrao);
               //---------------------------------------------------------------
               linhas.SaveToFile('C:\ClientD\CliMC.ini');
               //---------------------------------------------------------------
            end
         else   // O arquivo tá vazio
            begin
               //---------------------------------------------------------------
               //   Criar o arquivo de configurações
               //---------------------------------------------------------------
               linhas.Add('Porta=AUTO_USB');
               linhas.Add('MensagemPadrao=MKM Automacao');
               linhas.Add('TransacoesAdicionaisHabilitadas=');
               linhas.Add('ConfirmacaoAutomatica=SIM');
               linhas.Add('ExibirQrCode=0');
               linhas.Add('TimeoutPinPad=5');
               linhas.SaveToFile('C:\ClientD\CliMC.ini');
               //---------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
         linhas.Free;
      end;
end;
//------------------------------------------------------------------------------
//  Salvar arquivo de forma INCREMENTAL
//------------------------------------------------------------------------------
procedure SA_Salva_Arquivo_Incremental(linha,nome_arquivo:string);
var
   arquivo      : TextFile;
begin
   AssignFile(arquivo,Nome_arquivo);
   if not FileExists(Nome_arquivo) then
      Rewrite(arquivo)
   else
      Append(arquivo);
   Writeln(arquivo,linha);
   CloseFile(arquivo);
end;
//------------------------------------------------------------------------------
//   Funções de uso geral
//------------------------------------------------------------------------------
//******************************************************************************
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//   Retira qualquer caracter alfanumérico
//------------------------------------------------------------------------------
function SA_Limpacampo(campo:string):string;
var
   d     : integer;
begin
   Result := '';
   for d:=1 to length(campo) do
      begin
         if CharInSet(campo[d],['0'..'9']) then
            Result := Result + campo[d];
      end;
end;
//------------------------------------------------------------------------------
//   Verificar se a data em modo string é válida
//------------------------------------------------------------------------------
function DataValida(data:string):boolean;
begin
   try
      strtodate(data);
      Result := true;
   except
      Result := false;
   end;
end;
//------------------------------------------------------------------------------
//   Procedure para liberar a memória não usada, limpar o lixo da memória, o DELPHI tem essa característica.
//   informação de http://www.agnaldocarmo.com.br/home/comando-milagroso-para-reducao-de-memoria-delphi/
//   Colocar em USES "psapi"
//------------------------------------------------------------------------------
procedure SA_Limpar_Memoria;
var
   MainHandle : THandle;
begin
   try
      MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID) ;
      SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF) ;
      CloseHandle(MainHandle) ;
   except
   end;
   Application.ProcessMessages;
 end;
//------------------------------------------------------------------------------
function se(expressao:boolean;ret1,ret2:Variant):Variant;
begin
   Result := ret2;
   if expressao then
      Result := ret1;
end;
//------------------------------------------------------------------------------
//   Converter uma string monetária para real
//------------------------------------------------------------------------------
function untransform(palavra:string):real;
var
   txt   : string;
   d     : integer;
begin
   txt:='';
   if palavra='' then
      palavra:='0,00';
   for d:=1 to length(palavra) do
      begin
         if CharInSet(palavra[d],['0'..'9',',','-']) then
            txt:=txt+palavra[d];
      end;
   //---------------------------------------------------------------------------
   try
      Result  := strtofloat(txt);
   except
      Result  := 0;
   end;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
//   Monetário 14 dígitos
//------------------------------------------------------------------------------
function transform(valor:real):string;
begin
   Result := '          '+formatfloat('###,###,##0.00',RoundABNT(valor,2));
   Result := copy(Result,length(Result)-13,14);
end;
//------------------------------------------------------------------------------
//   Verifica se um código de barras valido
//------------------------------------------------------------------------------
function SA_Codigo_de_barras_valido(codigo:string):boolean;
var
   validador : TACBrValidador;
begin
   validador := TACBrValidador.Create(nil);
   validador.TipoDocto := docGTIN;
   validador.Documento := codigo;
   result              := validador.Validar;
   validador.Free;
end;
//------------------------------------------------------------------------------
//   Validar CPF
//------------------------------------------------------------------------------
function SA_ValidarCPF(cpf:string):boolean;
var
   validador : TACBrValidador;
begin
   validador := TACBrValidador.Create(nil);
   validador.TipoDocto := docCPF;
   validador.Documento := cpf;
   result              := validador.Validar;
   validador.Free;
end;
//------------------------------------------------------------------------------
//   Validar CNPJ
//------------------------------------------------------------------------------
function SA_ValidarCNPJ(cnpj:string):boolean;
var
   validador : TACBrValidador;
begin
   validador := TACBrValidador.Create(nil);
   validador.TipoDocto := docCNPJ;
   validador.Documento := cnpj;
   result              := validador.Validar;
   validador.Free;
end;
//------------------------------------------------------------------------------
//  Validar CPF ou CNPJ
//------------------------------------------------------------------------------
function SA_ValidarCPFouCNPJ(documento:string):boolean;
begin
   documento := SA_Limpacampo(trim(documento));
   if length(documento)=14 then
      Result := SA_ValidarCNPJ(documento)
   else if length(documento)=11 then
      Result := SA_ValidarCPF(documento)
   else
      Result := false;
end;
//------------------------------------------------------------------------------
//  Criar um componente HTTP indy
//------------------------------------------------------------------------------
function SA_Criar_Componente_HTTP:TIdHTTP;
begin
   //---------------------------------------------------------------------------
   Result                     := TIdHTTP.Create(nil);
   Result.ConnectTimeout      := 1000;
   Result.ReadTimeout         := 1000;
   Result.Request.Accept      := 'text/html, */*';
   Result.Request.UserAgent   := 'Mozilla/3.0 (compatible; IndyLibrary)';
   Result.Request.ContentType := 'application/x-www-form-urlencoded';
   Result.Request.UserAgent   := 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0';
   Result.HandleRedirects     := True;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
//   Carregar um arquivo para uma widestring
//------------------------------------------------------------------------------
function SA_Carregar_Arquivo(arquivo_nome:string):string;
var
   linhas   : TStringList;
begin
   linhas := TStringList.Create;
   linhas.LoadFromFile(arquivo_nome);
   Result := linhas.Text;
   linhas.Free;
end;
//------------------------------------------------------------------------------
//   Enviar pacote para servidor
//------------------------------------------------------------------------------
function SA_Enviar_Arquivo(host_api,chave,arquivo:string):boolean;
var
   http     : TIdHTTP;
   dadosSTR : TStringStream;
begin
   Result := false;
   //---------------------------------------------------------------------------
   if (host_api='') or (arquivo='') or (chave='') then
      exit;
   if not fileexists(arquivo) then
      exit;
   //---------------------------------------------------------------------------
   dadosSTR := TStringStream.Create('{"chave":"'+string(EncodeBase64(ansistring(chave)))+'","dados":"'+string(EncodeBase64(ansistring(SA_Carregar_Arquivo(arquivo))))+'"}');
   http     := SA_Criar_Componente_HTTP;
   http.Request.ContentType :='application/octet-stream';
   try
      http.Post(host_api+':19016/upload',dadosSTR); // Chamando o método POST
      Result := http.ResponseCode=200;
   except
      Result := http.ResponseCode=200;
   end;
   http.Free;
   dadosSTR.Free;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
end.
