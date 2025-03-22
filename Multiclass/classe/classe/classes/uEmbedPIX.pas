unit uEmbedPIX;

interface

uses
   clipbrd,
   ACBrPosPrinter,
   ACBrImage,
   ACBrDelphiZXingQRCode,
   ACBrNFe.Classes,
   Vcl.Imaging.pngimage,
   vcl.forms,
   uKSTypes,
   uMultiClassfuncoes,
   uwebtefmp,
   ACBrAbecsPinPad,
   ACBrDeviceSerial,
   RESTRequest4d,
   System.Math,
   System.JSON,
   System.DateUtils,
   System.SysUtils,
   System.Classes,
   vcl.dialogs,
   udmMulticlass;
type
   //---------------------------------------------------------------------------
   TpRetornoPIX = record
      DH                  : TDateTime;
      ID                  : string;   // Identificador da transação
      QRCode              : string;   // Qrcode do PIX
      Status              : string;                    // Status string
      valor               : real;                      // Valor da operação
      E2E                 : string;                    // Documento de retorno
      txID                : string;                    // ID da transação
      ComprovanteCliente  : TStringList;               // Comprovante do cliente
      ComprovanteLoja     : TStringList;               // Comprovante da loja - Igual do cliente
   end;
   //---------------------------------------------------------------------------
   TEmbedPIX = class
      const
         HostHomologacao = 'https://sandbox.bcodex.io';
         HostProducao    = 'https://api.bcodex.io';
      private
        //----------------------------------------------------------------------
        LForma                 : string;
        LValor                 : real;
        LTempo                 : integer;
        //----------------------------------------------------------------------
        LConfigCNPJ            : string;
        LConfigUsername        : string;
        LConfigPassword        : string;
        LConfigAmbiente        : TEMBEDAmbiente;
        LConfigChave           : string;
        LConfigImpressaoViaCLI : TtpTEFImpressao;  // Impressão via cliente
        LConfigImpressaoViaLJ  : TtpTEFImpressao;  // Impressão via lojista
        //----------------------------------------------------------------------
        LConfigPinPad          : TKSConfigPinPad;      // Configuração do PINPAD
        LImpressora            : TKSConfigImpressora;  // Configuração da impressora
        LEmitente              : TEmit;                // Configurações do Emitente - Recebedor
        //----------------------------------------------------------------------
        LHost                  : string;
        //----------------------------------------------------------------------
        LSalvarLog             : boolean;  // Salvar ou não o LOG
        lExecutando            : boolean;  // Sinalizar que a thread está executando ainda
        //----------------------------------------------------------------------
        LToken                 : string;   // Para trabalhar internamente
        LTxID                  : string;
        LQRCode                : string;   // String da imagem QRCode
        LE2E                   : string;   // Utilizado para devolução de PIX
        LLiquidadoHML          : boolean;  // Simular liquidação em homologação
        //----------------------------------------------------------------------
        LRetornoPIX            : TpRetornoPIX;  // Identificador da transação
        //----------------------------------------------------------------------
        procedure MythreadEnd(sender: tobject);
        procedure SA_MostramensagemT;
        procedure SA_MostrarBtCancelarT;
        procedure SA_DesativarBtCancelarT;
        procedure SA_CriarMenuT;
        procedure SA_DesativarMenuT;
        procedure SA_RestaurarLogoT;
        procedure SA_PintarPIX;
        function SA_UsarPinpad:boolean;
        Procedure SA_ConfigurarPinPadPIX;
        function SA_PINPAD_MostrarImagem(imagem:TPngImage):boolean;
        function SA_CalcularTempo(tempo:integer):string;
        procedure SA_CriarComprovantes(Cancelamento:boolean = false);
        //----------------------------------------------------------------------
        procedure SA_EMBEDObterToken;
        procedure SA_EMBEDGerarCobrancaPIX;
        procedure SA_EMBEDConsultarCobranca;
        procedure SA_EMBEDRemoverCobranca;
        procedure SA_EMBEDCancelarCobranca;
        procedure SA_EMBEDLiquidarCobrancaHML;
        procedure SA_EMBEDConsultarDevolucaoCobranca;
        //----------------------------------------------------------------------
      public
        //----------------------------------------------------------------------
        PinPad               : TACBrAbecsPinPad;     // PINPAD
        //----------------------------------------------------------------------
        constructor create;
        //----------------------------------------------------------------------
        property Forma                 : string                 read LForma                  write LForma;
        property Valor                 : real                   read LValor                  write LValor;
        property Tempo                 : integer                read LTempo                  write LTempo;
        property E2E                   : string                 read LE2E                    write LE2E;   // Utilizado para devolução de PIX
        //----------------------------------------------------------------------
        property ConfigCNPJ            : string                 read LConfigCNPJ             write LConfigCNPJ;
        property ConfigUsername        : string                 read LConfigUsername         write LConfigUsername;
        property ConfigPassword        : string                 read LConfigPassword         write LConfigPassword;
        property ConfigAmbiente        : TEMBEDAmbiente         read LConfigAmbiente         write LConfigAmbiente;
        property ConfigChave           : string                 read LConfigChave            write LConfigChave;
        property ConfigImpressaoViaCLI : TtpTEFImpressao        read LConfigImpressaoViaCLI  write LConfigImpressaoViaCLI;  // Impressão via cliente
        property ConfigImpressaoViaLJ  : TtpTEFImpressao        read LConfigImpressaoViaLJ   write LConfigImpressaoViaLJ;  // Impressão via lojista
        //----------------------------------------------------------------------
        property ConfigPinPad          : TKSConfigPinPad        read LConfigPinPad           write LConfigPinPad;  // Configuração do PINPAD
        property Impressora            : TKSConfigImpressora    read LImpressora             write LImpressora;    // Configuração da impressora
        property Emitente              : TEmit                  read LEmitente               write LEmitente;      // Configurações do Emitente - Recebedor
        //----------------------------------------------------------------------
        property SalvarLog             : boolean                read LSalvarLog              write LSalvarLog;  // Salvar ou não o LOG
        property Executando            : boolean                read lExecutando             write lExecutando;  // Sinalizar que a thread está executando ainda
        //----------------------------------------------------------------------
        property RetornoPIX            : TpRetornoPIX           read LRetornoPIX;  // Identificador da transação
        //----------------------------------------------------------------------
        procedure SA_EfetuarPagamento;
        procedure SA_EfetuarCancelamento;
        //----------------------------------------------------------------------

   end;
   //---------------------------------------------------------------------------


implementation

{ TEmbedPIX }


constructor TEmbedPIX.create;
begin
   //---------------------------------------------------------------------------
   PinPad        := TACBrAbecsPinPad.Create(nil);  // Inicializar PINPAD
   lExecutando   := true;
   LLiquidadoHML := false;
   LHost         := HostProducao;
   //---------------------------------------------------------------------------
   inherited;
end;

procedure TEmbedPIX.MythreadEnd(sender: tobject);
begin
   lexecutando := false;
   frmwebtef.close;
   frmwebtef.release;
   //---------------------------------------------------------------------------
   if assigned(tthread(sender).fatalexception) then
      begin
         showmessage(exception(tthread(sender).fatalexception).message);
      end;
   //---------------------------------------------------------------------------
end;

function TEmbedPIX.SA_CalcularTempo(tempo: integer): string;
var
   minutos  : integer;
   segundos : integer;
begin
   minutos  := trunc(tempo/60);
   segundos := tempo-(minutos*60);
   Result   := strzero(minutos,2)+':'+strzero(segundos,2);
end;

procedure TEmbedPIX.SA_ConfigurarPinPadPIX;
begin
   //---------------------------------------------------------------------------
   PinPad.IsEnabled   := false;
   //---------------------------------------------------------------------------
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

procedure TEmbedPIX.SA_CriarComprovantes(Cancelamento:boolean = false);
begin
   //---------------------------------------------------------------------------
   if not Cancelamento then
      begin
         //---------------------------------------------------------------------
         LRetornoPIX.ComprovanteCliente.Add('        ');
         LRetornoPIX.ComprovanteCliente.Add('</ce><e>COMPROVANTE DE PIX</e>');
         LRetornoPIX.ComprovanteCliente.Add('VIA CLIENTE');
         LRetornoPIX.ComprovanteCliente.Add('</ae>        ');
         LRetornoPIX.ComprovanteCliente.Add('        ');
         LRetornoPIX.ComprovanteCliente.Add('RECEBEDOR');
         LRetornoPIX.ComprovanteCliente.Add('        ');
         LRetornoPIX.ComprovanteCliente.Add('CNPJ :'+LConfigCNPJ);
         LRetornoPIX.ComprovanteCliente.Add(LEmitente.xNome);
         LRetornoPIX.ComprovanteCliente.Add(LEmitente.xFant);
         LRetornoPIX.ComprovanteCliente.Add(LEmitente.EnderEmit.xLgr+' '+LEmitente.EnderEmit.nro+' '+LEmitente.EnderEmit.xCpl);
         LRetornoPIX.ComprovanteCliente.Add(LEmitente.EnderEmit.xBairro);
         LRetornoPIX.ComprovanteCliente.Add(LEmitente.EnderEmit.xMun+' '+LEmitente.EnderEmit.UF);
         LRetornoPIX.ComprovanteCliente.Add('        ');
         LRetornoPIX.ComprovanteCliente.Add('        ');
         LRetornoPIX.ComprovanteCliente.Add('Valor R$     :'+trim(transform(LValor)));
         LRetornoPIX.ComprovanteCliente.Add('Realizado em : '+formatdatetime('yyyy-mm-dd hh:mm:ss',now));
         LRetornoPIX.ComprovanteCliente.Add('Doc. E2E     : '+LRetornoPIX.E2E);
         LRetornoPIX.ComprovanteCliente.Add('PSP          : Embed-IT');
         LRetornoPIX.ComprovanteCliente.Add('   ');
         LRetornoPIX.ComprovanteCliente.Add('   ');
         LRetornoPIX.ComprovanteCliente.Add('   ');
         //---------------------------------------------------------------------
         LRetornoPIX.ComprovanteLoja.Add('        ');
         LRetornoPIX.ComprovanteLoja.Add('</ce><e>COMPROVANTE DE PIX</e>');
         LRetornoPIX.ComprovanteLoja.Add('VIA LOJISTA');
         LRetornoPIX.ComprovanteLoja.Add('</ae>        ');
         LRetornoPIX.ComprovanteLoja.Add('        ');
         LRetornoPIX.ComprovanteLoja.Add('        ');
         LRetornoPIX.ComprovanteLoja.Add('        ');
         LRetornoPIX.ComprovanteLoja.Add('        ');
         LRetornoPIX.ComprovanteLoja.Add('Valor R$     :'+trim(transform(LValor)));
         LRetornoPIX.ComprovanteLoja.Add('Realizado em : '+formatdatetime('yyyy-mm-dd hh:mm:ss',now));
         LRetornoPIX.ComprovanteLoja.Add('Doc. E2E     : '+LRetornoPIX.E2E);
         LRetornoPIX.ComprovanteLoja.Add('PSP          : Embed-IT');
         LRetornoPIX.ComprovanteLoja.Add('   ');
         LRetornoPIX.ComprovanteLoja.Add('   ');
         LRetornoPIX.ComprovanteLoja.Add('   ');
         //---------------------------------------------------------------------
      end
   else
      begin
         //---------------------------------------------------------------------
         LRetornoPIX.ComprovanteCliente.Add('        ');
         LRetornoPIX.ComprovanteCliente.Add('</ce><e>DEVOLUCAO DE PIX</e>');
         LRetornoPIX.ComprovanteCliente.Add('VIA CLIENTE');
         LRetornoPIX.ComprovanteCliente.Add('</ae>        ');
         LRetornoPIX.ComprovanteCliente.Add('        ');
         LRetornoPIX.ComprovanteCliente.Add('RECEBEDOR');
         LRetornoPIX.ComprovanteCliente.Add('        ');
         LRetornoPIX.ComprovanteCliente.Add('CNPJ :'+LConfigCNPJ);
         LRetornoPIX.ComprovanteCliente.Add(LEmitente.xNome);
         LRetornoPIX.ComprovanteCliente.Add(LEmitente.xFant);
         LRetornoPIX.ComprovanteCliente.Add(LEmitente.EnderEmit.xLgr+' '+LEmitente.EnderEmit.nro+' '+LEmitente.EnderEmit.xCpl);
         LRetornoPIX.ComprovanteCliente.Add(LEmitente.EnderEmit.xBairro);
         LRetornoPIX.ComprovanteCliente.Add(LEmitente.EnderEmit.xMun+' '+LEmitente.EnderEmit.UF);
         LRetornoPIX.ComprovanteCliente.Add('        ');
         LRetornoPIX.ComprovanteCliente.Add('        ');
         LRetornoPIX.ComprovanteCliente.Add('Valor R$     :'+trim(transform(LValor)));
         LRetornoPIX.ComprovanteCliente.Add('Realizado em : '+formatdatetime('yyyy-mm-dd hh:mm:ss',now));
         LRetornoPIX.ComprovanteCliente.Add('Doc. E2E     : '+LRetornoPIX.E2E);
         LRetornoPIX.ComprovanteCliente.Add('PSP          : Embed-IT');
         LRetornoPIX.ComprovanteCliente.Add('   ');
         LRetornoPIX.ComprovanteCliente.Add('   ');
         LRetornoPIX.ComprovanteCliente.Add('   ');
         //---------------------------------------------------------------------
         LRetornoPIX.ComprovanteLoja.Add('        ');
         LRetornoPIX.ComprovanteLoja.Add('</ce><e>DEVOLUCAO DE PIX</e>');
         LRetornoPIX.ComprovanteLoja.Add('VIA LOJISTA');
         LRetornoPIX.ComprovanteLoja.Add('</ae>        ');
         LRetornoPIX.ComprovanteLoja.Add('        ');
         LRetornoPIX.ComprovanteLoja.Add('        ');
         LRetornoPIX.ComprovanteLoja.Add('        ');
         LRetornoPIX.ComprovanteLoja.Add('        ');
         LRetornoPIX.ComprovanteLoja.Add('Valor R$     :'+trim(transform(LValor)));
         LRetornoPIX.ComprovanteLoja.Add('Realizado em : '+formatdatetime('yyyy-mm-dd hh:mm:ss',now));
         LRetornoPIX.ComprovanteLoja.Add('Doc. E2E     : '+LRetornoPIX.E2E);
         LRetornoPIX.ComprovanteLoja.Add('PSP          : Embed-IT');
         LRetornoPIX.ComprovanteLoja.Add('   ');
         LRetornoPIX.ComprovanteLoja.Add('   ');
         LRetornoPIX.ComprovanteLoja.Add('   ');
         //---------------------------------------------------------------------
      end;
   //---------------------------------------------------------------------------
end;

procedure TEmbedPIX.SA_CriarMenuT;
begin
   SA_Criar_Menu(true);
end;

procedure TEmbedPIX.SA_DesativarBtCancelarT;
begin
   SA_DesativarBTCancelar;
end;

procedure TEmbedPIX.SA_DesativarMenuT;
begin
   SA_Criar_Menu(false);
end;

procedure TEmbedPIX.SA_EfetuarCancelamento;
var
   //---------------------------------------------------------------------------
   sair            : boolean;
   HInicio         : TDateTime;
   HultimaLeitura  : TDateTime;  // Para fazer a leitura
   HUltimaContagem : TDateTime;  // Para mostrar na tela o tempo
   TempoEsperando  : integer;
   //---------------------------------------------------------------------------
   Mythread       : TThread;
   //---------------------------------------------------------------------------
   Imprimir       : boolean;
   opcoesColeta   : TStringList;
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   //   Iniciando a tela de TEF
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpEmbedITPIX;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := 'CANCELAMNTO';
   frmwebtef.lbvalor.Caption  := transform(LValor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   //---------------------------------------------------------------------------
   case LConfigAmbiente of
     tpAmbHomologacao : LHost := HostHomologacao;
     tpAmbProducao    : LHost := HostProducao;
   end;
   //---------------------------------------------------------------------------
   Mythread := TThread.CreateAnonymousThread(procedure
      begin
         //---------------------------------------------------------------------
         // Gerar QRCODE
         //------------------------------------------------------------------
         frmwebtef.mensagem := 'Autenticando.';
         TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
         //---------------------------------------------------------------------
         SA_SalvarLog('SOLICITAR CANCELAMENTO PIX','R$ '+transform(LValor)+#13+'Forma '+LForma,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
         //---------------------------------------------------------------------
         SA_EMBEDObterToken;
         if LToken<>'' then
            begin
               //---------------------------------------------------------------
               //   Processar a solicitação do PIX
               //---------------------------------------------------------------
               frmwebtef.mensagem := 'Gerando cobrança';
               TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
               //---------------------------------------------------------------
               HInicio         := time;
               HultimaLeitura  := time;
               HUltimaContagem := time;
               //---------------------------------------------------------------
               SA_EMBEDCancelarCobranca;
               if LRetornoPIX.ID<>'' then
                  begin
                     //---------------------------------------------------------
                     //   Fazer pooling de consulta
                     //---------------------------------------------------------
                     TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar
                     sair := false;
                     while not sair do
                        begin
                           //---------------------------------------------------
                           if SecondsBetween(now,HUltimaContagem)>=1 then  // Passou-se dois segundos da ultima consulta
                              begin
                                 HUltimaContagem    := time;
                                 frmwebtef.mensagem := 'Aguardando pagamento - '+ SA_CalcularTempo(SecondsBetween(HInicio,time));
                                 TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              end;
                           TempoEsperando := SecondsBetween(HInicio,time);
                           //---------------------------------------------------
                           if (SecondsBetween(time,HultimaLeitura)>=3) and (TempoEsperando<=LTempo) then  // Passou-se dois segundos da ultima consulta
                              begin
                                 //---------------------------------------------
                                 HultimaLeitura := time;
                                 //---------------------------------------------
                                 //   Fazer o POLLING de consulta
                                 //---------------------------------------------
                                 SA_EMBEDConsultarDevolucaoCobranca;
                                 if LRetornoPIX.Status = 'DEVOLVIDO' then
                                    begin
                                       //---------------------------------------
                                       //  Processar a impressão do comprovante
                                       //   Pix concluído
                                       //---------------------------------------
                                       //   Comprovante do cliente
                                       //---------------------------------------
                                       imprimir := ConfigImpressaoViaCLI=tpTEFImprimirSempre;
                                       if ConfigImpressaoViaCLI=tpTEFPerguntar then
                                          begin
                                             //---------------------------------
                                             //   Perguntar se quer imprimir
                                             //---------------------------------
                                             opcoesColeta := TStringList.Create;
                                             opcoesColeta.Add('Imprimir');
                                             opcoesColeta.Add('Não Imprimir');
                                             frmwebtef.mensagem := 'Imprimir o comprovante do CLIENTE ?';
                                             frmwebtef.opcoes   := opcoesColeta;
                                             frmwebtef.opcao    := -1;
                                             frmwebtef.tecla    := '';
                                             frmwebtef.Cancelar := false;
                                             //---------------------------------
                                             TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                             TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                             //---------------------------------
                                             while (not frmwebtef.Cancelar) do
                                                begin
                                                  if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                     begin
                                                        //----------------------
                                                        imprimir := true;
                                                        frmwebtef.Cancelar := true;
                                                        //----------------------
                                                     end
                                                  else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                                     frmwebtef.Cancelar := true;
                                                   //---------------------------
                                                   sleep(50);
                                                end;
                                             TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                             TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                             //---------------------------------
                                             frmwebtef.Cancelar := false;
                                             //---------------------------------
                                          end;
                                       if imprimir then
                                          SA_ImprimirTexto(LRetornoPIX.ComprovanteCliente.Text,LImpressora);
                                       //---------------------------------------
                                       //   Comprovante do Lojista
                                       //---------------------------------------
                                       imprimir := ConfigImpressaoViaLJ=tpTEFImprimirSempre;
                                       if ConfigImpressaoViaLJ=tpTEFPerguntar then
                                          begin
                                             //---------------------------------
                                             //   Perguntar se quer imprimir
                                             //---------------------------------
                                             opcoesColeta := TStringList.Create;
                                             opcoesColeta.Add('Imprimir');
                                             opcoesColeta.Add('Não Imprimir');
                                             frmwebtef.mensagem := 'Imprimir o comprovante da LOJA ?';
                                             frmwebtef.opcoes   := opcoesColeta;
                                             frmwebtef.opcao    := -1;
                                             frmwebtef.tecla    := '';
                                             frmwebtef.Cancelar := false;
                                             //---------------------------------
                                             TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                             TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                             //---------------------------------
                                             while (not frmwebtef.Cancelar) do
                                                begin
                                                  if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                     begin
                                                        //----------------------
                                                        imprimir := true;
                                                        frmwebtef.Cancelar := true;
                                                        //----------------------
                                                     end
                                                  else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                                     frmwebtef.Cancelar := true;
                                                   //----------
                                                   sleep(50);
                                                end;
                                             TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                             TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                             //---------------------------------
                                             frmwebtef.Cancelar := false;
                                             //---------------------------------
                                          end;
                                       if imprimir then
                                          SA_ImprimirTexto(LRetornoPIX.ComprovanteLoja.Text,LImpressora);
                                        //--------------------------------------
                                       sair := true;
                                       //---------------------------------------
                                    end
                                 else if (LRetornoPIX.Status<>'') and (LRetornoPIX.Status<>'DEVOLVIDO') and (LRetornoPIX.Status<>'ATIVA') then //='REMOVIDA_PELO_USUARIO_RECEBEDOR' then
                                     begin
                                        //--------------------------------------
                                        //   Consulta removida pelo operador
                                        //--------------------------------------
                                        frmwebtef.mensagem := 'Cobrança expirada';
                                        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                        TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                        //---------------------------------------------------------------
                                        while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                           begin
                                              sleep(50);
                                           end;
                                     end;
                                 //---------------------------------------------
                              end
                           else if TempoEsperando>LTempo then
                              frmwebtef.Cancelar := true;
                           //---------------------------------------------------
                           if frmwebtef.Cancelar then
                              begin
                                 frmwebtef.Cancelar := false;
                                 sair               := true;
                                 //---------------------------------------------
                              end;
                           //---------------------------------------------------
                           sleep(10);
                           //---------------------------------------------------
                        end;
                     //---------------------------------------------------------
                  end
               else
                  begin
                     //---------------------------------------------------------
                     //   Ocorreu erro ao gerar a consulta
                     //---------------------------------------------------------
                     frmwebtef.mensagem := 'Ocorreu erro ao CANCELAR a transação.';
                     TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                     TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                     //---------------------------------------------------------------
                     while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                        begin
                           sleep(50);
                        end;
                     //---------------------------------------------------------
                  end;
               //---------------------------------------------------------------
            end
         else   // Houve erro ao obter o TOKEN
            begin
               //---------------------------------------------------------------
               //  Fazer a rotina para apresentar a mensagem de erro
               //---------------------------------------------------------------
               frmwebtef.mensagem := 'Houve problemas ao realizara a autenticação';
               TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
               TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
               //---------------------------------------------------------------
               while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                  begin
                     sleep(50);
                  end;
               //------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
      end);
   //---------------------------------------------------------------------------
   Mythread.onterminate := MythreadEnd;
   Mythread.start;
   //---------------------------------------------------------------------------

end;

procedure TEmbedPIX.SA_EfetuarPagamento;
var
   //---------------------------------------------------------------------------
   sair            : boolean;
   HInicio         : TDateTime;
   HultimaLeitura  : TDateTime;  // Para fazer a leitura
   HUltimaContagem : TDateTime;  // Para mostrar na tela o tempo
   TempoEsperando  : integer;
   //---------------------------------------------------------------------------
   Mythread       : TThread;
   //---------------------------------------------------------------------------
   Imprimir       : boolean;
   opcoesColeta   : TStringList;
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   //   Iniciando a tela de TEF
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpEmbedITPIX;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LForma;
   frmwebtef.lbvalor.Caption  := transform(LValor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   //---------------------------------------------------------------------------
   case LConfigAmbiente of
     tpAmbHomologacao : LHost := HostHomologacao;
     tpAmbProducao    : LHost := HostProducao;
   end;
   //---------------------------------------------------------------------------
   Mythread := TThread.CreateAnonymousThread(procedure
      begin
         //---------------------------------------------------------------------
         // Gerar QRCODE
         //------------------------------------------------------------------
         frmwebtef.mensagem := 'Autenticando.';
         TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
         //---------------------------------------------------------------------
         SA_SalvarLog('SOLICITAR PIX','R$ '+transform(LValor)+#13+'Forma '+LForma,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
         //---------------------------------------------------------------------
         SA_EMBEDObterToken;
         if LToken<>'' then
            begin
               //---------------------------------------------------------------
               //   Processar a solicitação do PIX
               //---------------------------------------------------------------
               frmwebtef.mensagem := 'Gerando cobrança';
               TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
               //---------------------------------------------------------------
               HInicio         := time;
               HultimaLeitura  := time;
               HUltimaContagem := time;
               //---------------------------------------------------------------
               SA_EMBEDGerarCobrancaPIX;
               if LQRCode<>'' then
                  begin
                     //---------------------------------------------------------
                     //   Fazer pooling de consulta
                     //---------------------------------------------------------
                     TThread.Synchronize(TThread.CurrentThread,
                     procedure
                     begin
                        SA_PintarPIX;   // Mostrar o PIX na tela e no PINPAD
                     end);
                     TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar
                     sair := false;
                     while not sair do
                        begin
                           //---------------------------------------------------
                           if SecondsBetween(now,HUltimaContagem)>=1 then  // Passou-se dois segundos da ultima consulta
                              begin
                                 HUltimaContagem    := time;
                                 frmwebtef.mensagem := 'Aguardando pagamento - '+ SA_CalcularTempo(SecondsBetween(HInicio,time));
                                 TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              end;
                           TempoEsperando := SecondsBetween(HInicio,time);
                           //---------------------------------------------------
                           if (SecondsBetween(time,HultimaLeitura)>=3) and (TempoEsperando<=LTempo) then  // Passou-se dois segundos da ultima consulta
                              begin
                                 //---------------------------------------------
                                 HultimaLeitura := time;
                                 //---------------------------------------------
                                 //   Fazer o POLLING de consulta
                                 //---------------------------------------------
                                 SA_EMBEDConsultarCobranca;
                                 if LRetornoPIX.Status = 'CONCLUIDA' then
                                    begin
                                       //---------------------------------------
                                       TThread.Synchronize(TThread.CurrentThread,SA_RestaurarLogoT);
                                       //---------------------------------------
                                       //  Processar a impressão do comprovante
                                       //   Pix concluído
                                       //---------------------------------------
                                       //   Comprovante do cliente
                                       //---------------------------------------
                                       imprimir := ConfigImpressaoViaCLI=tpTEFImprimirSempre;
                                       if ConfigImpressaoViaCLI=tpTEFPerguntar then
                                          begin
                                             //---------------------------------
                                             //   Perguntar se quer imprimir
                                             //---------------------------------
                                             opcoesColeta := TStringList.Create;
                                             opcoesColeta.Add('Imprimir');
                                             opcoesColeta.Add('Não Imprimir');
                                             frmwebtef.mensagem := 'Imprimir o comprovante do CLIENTE ?';
                                             frmwebtef.opcoes   := opcoesColeta;
                                             frmwebtef.opcao    := -1;
                                             frmwebtef.tecla    := '';
                                             frmwebtef.Cancelar := false;
                                             //---------------------------------
                                             TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                             TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                             //---------------------------------
                                             while (not frmwebtef.Cancelar) do
                                                begin
                                                  if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                     begin
                                                        //----------------------
                                                        imprimir := true;
                                                        frmwebtef.Cancelar := true;
                                                        //----------------------
                                                     end
                                                  else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                                     frmwebtef.Cancelar := true;
                                                   //---------------------------
                                                   sleep(50);
                                                end;
                                             TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                             TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                             //---------------------------------
                                             frmwebtef.Cancelar := false;
                                             //---------------------------------
                                          end;
                                       if imprimir then
                                          SA_ImprimirTexto(LRetornoPIX.ComprovanteCliente.Text,LImpressora);   // Imprimindo
                                       //---------------------------------------
                                       //   Comprovante do Lojista
                                       //---------------------------------------
                                       imprimir := ConfigImpressaoViaLJ=tpTEFImprimirSempre;
                                       if ConfigImpressaoViaLJ=tpTEFPerguntar then
                                          begin
                                             //---------------------------------
                                             //   Perguntar se quer imprimir
                                             //---------------------------------
                                             opcoesColeta := TStringList.Create;
                                             opcoesColeta.Add('Imprimir');
                                             opcoesColeta.Add('Não Imprimir');
                                             frmwebtef.mensagem := 'Imprimir o comprovante da LOJA ?';
                                             frmwebtef.opcoes   := opcoesColeta;
                                             frmwebtef.opcao    := -1;
                                             frmwebtef.tecla    := '';
                                             frmwebtef.Cancelar := false;
                                             //---------------------------------
                                             TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                             TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                             //---------------------------------
                                             while (not frmwebtef.Cancelar) do
                                                begin
                                                  if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                     begin
                                                        //----------------------
                                                        imprimir := true;
                                                        frmwebtef.Cancelar := true;
                                                        //----------------------
                                                     end
                                                  else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                                     frmwebtef.Cancelar := true;
                                                   //----------
                                                   sleep(50);
                                                end;
                                             TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                             TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                             //---------------------------------
                                             frmwebtef.Cancelar := false;
                                             //---------------------------------
                                          end;
                                       if imprimir then
                                          SA_ImprimirTexto(LRetornoPIX.ComprovanteLoja.Text,LImpressora);   // Imprimindo
                                        //--------------------------------------
                                       sair := true;
                                       //---------------------------------------
                                    end
                                 else if (LRetornoPIX.Status<>'') and (LRetornoPIX.Status<>'CONCLUIDA') and (LRetornoPIX.Status<>'ATIVA') then //='REMOVIDA_PELO_USUARIO_RECEBEDOR' then
                                     begin
                                        //--------------------------------------
                                        //   Consulta removida pelo operador
                                        //--------------------------------------
                                        frmwebtef.mensagem := 'Cobrança expirada';
                                        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                        TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                        TThread.Synchronize(TThread.CurrentThread,SA_RestaurarLogoT);
                                        //---------------------------------------------------------------
                                        while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                           begin
                                              sleep(50);
                                           end;
                                     end;
                                 //---------------------------------------------
                              end
                           else if (TempoEsperando>=20) and (LConfigAmbiente=tpAmbHomologacao) and (not LLiquidadoHML) then
                             SA_EMBEDLiquidarCobrancaHML
                           else if TempoEsperando>LTempo then
                              frmwebtef.Cancelar := true;
                           //---------------------------------------------------
                           if frmwebtef.Cancelar then
                              begin
                                 frmwebtef.mensagem := 'Removendo cobrança.';
                                 TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                 TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                 frmwebtef.Cancelar := false;
                                 sair               := true;
                                 //---------------------------------------------
                                 TThread.Synchronize(TThread.CurrentThread,SA_RestaurarLogoT);
                                 //---------------------------------------------
                                 SA_EMBEDRemoverCobranca;   // Remover a transação
                                 //---------------------------------------------
                              end;
                           //---------------------------------------------------
                           sleep(10);
                           //---------------------------------------------------
                        end;
                     //---------------------------------------------------------
                  end
               else
                  begin
                     //---------------------------------------------------------
                     //   Ocorreu erro ao gerar a consulta
                     //---------------------------------------------------------
                     frmwebtef.mensagem := 'Ocorreu erro ao gerar a cobrança';
                     TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                     TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                     //---------------------------------------------------------------
                     while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                        begin
                           sleep(50);
                        end;
                     //---------------------------------------------------------
                  end;
               //---------------------------------------------------------------
            end
         else   // Houve erro ao obter o TOKEN
            begin
               //---------------------------------------------------------------
               //  Fazer a rotina para apresentar a mensagem de erro
               //---------------------------------------------------------------
               frmwebtef.mensagem := 'Houve problemas ao realizar a autenticação';
               TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
               TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
               //---------------------------------------------------------------
               while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                  begin
                     sleep(50);
                  end;
               //------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
      end);
   //---------------------------------------------------------------------------
   Mythread.onterminate := MythreadEnd;
   Mythread.start;
   //---------------------------------------------------------------------------
end;

procedure TEmbedPIX.SA_EMBEDCancelarCobranca;
var
   //---------------------------------------------------------------------------
   LResponse   : IResponse;
   RetornoJSON : TJSONValue;
   //---------------------------------------------------------------------------
   Host        : string;
   Body        : string;
begin
   //---------------------------------------------------------------------------
   LTxID   := '00'+LConfigCNPJ+formatdatetime('yyyymmddhhmmsszz',now);
   //---------------------------------------------------------------------------
   Body        := '{"valor": "'+formatfloat('########0.00',LValor)+'"}';
   //---------------------------------------------------------------------------
   Host        := LHost+'/pix/:'+LE2E+'/devolucao/:'+LTxID;
   SA_SalvarLog('SOLICITAR DEVOLUCAO COBRANCA PIX - '+Host,Body,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   try
      //------------------------------------------------------------------------
      LResponse := TRequest.New.BaseURL(host)
                               .TokenBearer(LToken)
                               .Accept('application/json')
                               .AddBody(body)
                               .Timeout(20000)
                               .Put;
      //------------------------------------------------------------------------
      SA_SalvarLog('RESPOSTA DEVOLVER COBRANCA PIX',LResponse.StatusCode.ToString+' '+LResponse.Content,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      //------------------------------------------------------------------------
      retornoJSON := TJSonObject.ParseJSONValue(LResponse.Content);
      if retornoJSON<>nil then
         begin
            LRetornoPIX.Status     := retornoJSON.GetValue<string>('status','');
            LRetornoPIX.ID         := retornoJSON.GetValue<string>('id','');
            LRetornoPIX.txID       := LTxID;
         end;
      retornoJSON.Free;
      //------------------------------------------------------------------------
   except on e:exception do
      begin
         SA_SalvarLog('ERRO GERAR COBRANCA PIX',e.Message,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      end;
   end;
   //---------------------------------------------------------------------------

end;

procedure TEmbedPIX.SA_EMBEDConsultarCobranca;
var
   //---------------------------------------------------------------------------
   LResponse   : IResponse;
   RetornoJSON : TJSONValue;
   LPix        : TJSONArray;
   //---------------------------------------------------------------------------
begin
   try
      //------------------------------------------------------------------------
      //   Fazer consulta
      //------------------------------------------------------------------------
      SA_SalvarLog('CONSULTAR COBRANCA PIX',LHost+'/cob/'+LTxID,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      LResponse := TRequest.New.BaseURL(LHost+'/cob/'+LTxID)
                               .TokenBearer(LToken)
                               .Accept('application/json')
                               .Timeout(20000)
                               .Get;
      SA_SalvarLog('RETORNO CONSULTAR COBRANCA PIX '+LHost+'/cob/'+LTxID,LResponse.Content,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      //------------------------------------------------------------------------
      if (LResponse.StatusCode>=200) and (LResponse.StatusCode<300) then
         begin
            retornoJSON := TJSonObject.ParseJSONValue(LResponse.Content);
            if RetornoJSON<>nil then
               LRetornoPIX.Status := retornoJSON.GetValue<string>('status','')
            else
               LRetornoPIX.Status := '';
            if LRetornoPIX.Status = 'CONCLUIDA' then
               begin
                  //------------------------------------------------------------
                  LPix   := retornoJSON.GetValue<TJSONArray>('pix',nil);
                  if LPix<>nil then
                     begin
                        LRetornoPIX.DH     := strtodatetimedef(LPix.Items[0].GetValue<string>('horario',''),now);
                        LRetornoPIX.ID     := LTxID;
                        LRetornoPIX.QRCode := LQRCode;
                        LRetornoPIX.valor  := LValor;
                        LRetornoPIX.E2E    := LPix.Items[0].GetValue<string>('endToEndId','');
                        LRetornoPIX.txID   := LTxID;
                        SA_CriarComprovantes;
                     end;
                  //------------------------------------------------------------
               end;
            retornoJSON.Free;
         end;
      //------------------------------------------------------------------------
   except on e:exception do
      begin
         SA_SalvarLog('ERRO GERAR COBRANCA PIX',e.Message,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      end;
   end;
end;

procedure TEmbedPIX.SA_EMBEDConsultarDevolucaoCobranca;
var
   //---------------------------------------------------------------------------
   LResponse   : IResponse;
   RetornoJSON : TJSONValue;
   Horario     : TJSONValue;
   Host        : string;
   //---------------------------------------------------------------------------
begin
   try
      //------------------------------------------------------------------------
      //   Fazer consulta
      //------------------------------------------------------------------------
      Host        := LHost+'/pix/:'+LE2E+'/devolucao/:'+LTxID;
      SA_SalvarLog('CONSULTAR COBRANCA PIX',Host,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      LResponse := TRequest.New.BaseURL(host)
                               .TokenBearer(LToken)
                               .Accept('application/json')
                               .Timeout(20000)
                               .Get;
      SA_SalvarLog('RETORNO CONSULTAR COBRANCA PIX '+Host,LResponse.Content,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      //------------------------------------------------------------------------
      if (LResponse.StatusCode>=200) and (LResponse.StatusCode<300) then
         begin
            retornoJSON   := TJSonObject.ParseJSONValue(LResponse.Content);
            if RetornoJSON<>nil then
               begin
                  Horario            := retornoJSON.GetValue<TJSONValue>('horario',nil);
                  LRetornoPIX.Status := retornoJSON.GetValue<string>('status','');
                  if LRetornoPIX.Status='DEVOLVIDO' then
                     begin
                        LRetornoPIX.DH     := strtodatetimedef(Horario.GetValue<string>('liquidacao',''),now);
                        LRetornoPIX.ID     := LTxID;
                        LRetornoPIX.valor  := LValor;
                        LRetornoPIX.E2E    := LE2E;
                        LRetornoPIX.txID   := LTxID;
                        SA_CriarComprovantes(true);
                     end;
               end
            else
               LRetornoPIX.Status := '';
            retornoJSON.Free;
         end;
      //------------------------------------------------------------------------
   except on e:exception do
      begin
         SA_SalvarLog('ERRO CONSULTAR DEVOLUCAO COBRANCA PIX',e.Message,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      end;
   end;

end;

procedure TEmbedPIX.SA_EMBEDGerarCobrancaPIX;
var
   //---------------------------------------------------------------------------
   LResponse   : IResponse;
   RetornoJSON : TJSONValue;
   //---------------------------------------------------------------------------
   Body        : string;
begin
   //---------------------------------------------------------------------------
   LTxID   := '00'+LConfigCNPJ+formatdatetime('yyyymmddhhmmsszz',now);
   //---------------------------------------------------------------------------
   Body        := '{'+
                      '"calendario": {'+
                          '"expiracao": '+LTempo.ToString+
                      '},'+
                      '"valor": {'+
                          '"original": "'+formatfloat('########0.00',LValor)+'",'+
                          '"modalidadeAlteracao": 1'+
                      '},'+
                      '"chave": "'+LConfigChave+'",'+
                      '"solicitacaoPagador": "'+LEmitente.xNome+'",'+
                      '"infoAdicionais": ['+
                      '{'+
                        '"nome": "'+LEmitente.xFant+'",'+
                        '"valor": "'+LEmitente.EnderEmit.xMun+'"'+
                      '}'+
                    ']'+
                  '}';
   //---------------------------------------------------------------------------
   SA_SalvarLog('GERAR COBRANCA PIX - '+LHost,Body,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   try
      //------------------------------------------------------------------------
      LResponse := TRequest.New.BaseURL(LHost+'/cob/'+LTxID)
                               .TokenBearer(LToken)
                               .Accept('application/json')
                               .AddBody(body)
                               .Timeout(20000)
                               .Put;
      //------------------------------------------------------------------------
      SA_SalvarLog('RESPOSTA GERAR COBRANCA PIX',LResponse.StatusCode.ToString+' '+LResponse.Content,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      //------------------------------------------------------------------------
      if (LResponse.StatusCode>=200) and (LResponse.StatusCode<300) then
         begin
            retornoJSON := TJSonObject.ParseJSONValue(LResponse.Content);
            LQRCode     := '';
            if retornoJSON<>nil then
               LQRCode     := retornoJSON.GetValue<string>('pixCopiaECola','');
            retornoJSON.Free;
         end;
      //------------------------------------------------------------------------
   except on e:exception do
      begin
         SA_SalvarLog('ERRO GERAR COBRANCA PIX',e.Message,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      end;
   end;
   //---------------------------------------------------------------------------
end;

procedure TEmbedPIX.SA_EMBEDLiquidarCobrancaHML;
var
   //---------------------------------------------------------------------------
   LResponse   : IResponse;
   //---------------------------------------------------------------------------
begin
   try
      //------------------------------------------------------------------------
      //   Fazer consulta
      //------------------------------------------------------------------------
      SA_SalvarLog('LIQUIDAR COBRANCA HML PIX',LHost+'/cob/'+LTxID,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      LResponse := TRequest.New.BaseURL(LHost+'/cob/'+LTxID)
                               .TokenBearer(LToken)
                               .AddBody('{"status": "CONCLUIDA"}')
                               .Accept('application/json')
                               .Timeout(20000)
                               .Patch;
      //------------------------------------------------------------------------
      LLiquidadoHML := true;
      SA_SalvarLog('RESPOSTA LIQUIDAR COBRANCA HML PIX',LResponse.StatusCode.ToString+' '+LResponse.Content,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      //------------------------------------------------------------------------
   except on e:exception do
      begin
         SA_SalvarLog('ERRO GERAR COBRANCA PIX',e.Message,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      end;
   end;

end;

procedure TEmbedPIX.SA_EMBEDObterToken;
var
   //---------------------------------------------------------------------------
   RetornoJSON : TJSONValue;
   LResponse   : IResponse;
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   try
      //------------------------------------------------------------------------
      LResponse := TRequest.New
          .BaseURL(LHost+'/bcdx-sso/login')
          .AddParam('username', LConfigUsername, pkGETorPOST, [poDoNotEncode])
          .AddParam('password', LConfigPassword, pkGETorPOST, [poDoNotEncode])
          .Post;
      //------------------------------------------------------------------------
      SA_SalvarLog('RESPOSTA LOGIN',LResponse.StatusCode.ToString+' '+LResponse.Content,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      //------------------------------------------------------------------------
      if LResponse.StatusCode=200 then
         begin
            retornoJSON := TJSonObject.ParseJSONValue(LResponse.Content);
            Ltoken      := retornoJSON.GetValue<string>('access_token','');
            retornoJSON.Free;
         end;
   except on e:exception do
      begin
         SA_SalvarLog('ERRO LOGIN',e.Message,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      end;
   end;
   //---------------------------------------------------------------------------

end;

procedure TEmbedPIX.SA_EMBEDRemoverCobranca;
var
   //---------------------------------------------------------------------------
   LResponse   : IResponse;
   //---------------------------------------------------------------------------
begin
   try
      //------------------------------------------------------------------------
      //   Fazer consulta
      //------------------------------------------------------------------------
      SA_SalvarLog('REMOVER COBRANCA PIX',LHost+'/cob/'+LTxID,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      LResponse := TRequest.New.BaseURL(LHost+'/cob/'+LTxID)
                               .TokenBearer(LToken)
                               .AddBody('{"status": "REMOVIDA_PELO_USUARIO_RECEBEDOR"}')
                               .Accept('application/json')
                               .Timeout(20000)
                               .Patch;
      //------------------------------------------------------------------------
      SA_SalvarLog('RESPOSTA REMOVER COBRANCA PIX',LResponse.StatusCode.ToString+' '+LResponse.Content,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      //------------------------------------------------------------------------
   except on e:exception do
      begin
         SA_SalvarLog('ERRO GERAR COBRANCA PIX',e.Message,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      end;
   end;

end;



procedure TEmbedPIX.SA_MostramensagemT;
begin
   SA_Mostrar_Mensagem(true);
end;

procedure TEmbedPIX.SA_MostrarBtCancelarT;
begin
   SA_AtivarBTCancelar;   // Ativar o botão cancelar na tela de TEF
end;

function TEmbedPIX.SA_PINPAD_MostrarImagem(imagem: TPngImage): boolean;
var
   ms : TMemoryStream;
begin
   ms := TMemoryStream.Create;
   //---------------------------------------------------------------------------
   try
      //------------------------------------------------------------------------
      PinPad.IsEnabled   := true;
      imagem.SaveToStream(ms);
      //------------------------------------------------------------------------
      PinPad.OPN;
      PinPad.LoadMedia( 'LOGO', ms, mtPNG);
      PinPad.DSI('LOGO');
      PinPad.CLO;
      //------------------------------------------------------------------------
      PinPad.IsEnabled   := false;
      Result := true;
   except
      Result := false;
   end;
   //---------------------------------------------------------------------------
   ms.Free;
   //---------------------------------------------------------------------------
end;

procedure TEmbedPIX.SA_PintarPIX;
var
   png    : TPngImage;
   qrsize : Integer;
begin
   //---------------------------------------------------------------------------
   try
      frmwebtef.logomp.Stretch      := true;
      frmwebtef.logomp.Proportional := true;
      PintarQRCode(LQRCode, frmwebtef.logomp.Picture.Bitmap, qrUTF8BOM);
   except on e:exception do
      begin
         SA_SalvarLog('ERRO PINTAR PIX NA TELA',e.Message,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      end
   end;
   //---------------------------------------------------------------------------
   if SA_UsarPinpad then
      begin
         try
            SA_ConfigurarPinPadPIX;
            PinPad.IsEnabled   := true;
            qrsize := min( PinPad.PinPadCapabilities.DisplayGraphicPixels.Cols,
                           PinPad.PinPadCapabilities.DisplayGraphicPixels.Rows) - 20;
            pinpad.IsEnabled   := false;
            png := TPngImage.Create;
            png.Assign(frmwebtef.logomp.Picture.Bitmap);
            png.Resize(qrsize, qrsize);
            png.Canvas.StretchDraw(png.Canvas.ClipRect, frmwebtef.logomp.Picture.Bitmap);
            SA_PINPAD_MostrarImagem(png);
            PinPad.IsEnabled   := false;
         except on e:exception do
            begin
               SA_SalvarLog('ERRO PINTAR PIX NA NO PINPAD',e.Message,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
            end

         end;
      end;
   //---------------------------------------------------------------------------
end;

procedure TEmbedPIX.SA_RestaurarLogoT;
var
   png : TPngImage;
begin
  //----------------------------------------------------------------------------
   frmwebtef.logomp.Stretch      := false;
   frmwebtef.logomp.Proportional := true;
   frmwebtef.logomp.Center       := true;
   frmwebtef.logomp.Picture.LoadFromFile(GetCurrentDir+'\icones\PIXEmbedIT.bmp');
   frmwebtef.logomp.Repaint;
  //----------------------------------------------------------------------------
  if SA_UsarPinpad then
     begin
        try
           SA_ConfigurarPinPadPIX;
           png := TPngImage.Create;
           png.LoadFromFile(LConfigPinPad.PINPAD_Imagem);
           SA_PINPAD_MostrarImagem(png);
           png.Free;
        except on e:exception do
           begin
              SA_SalvarLog('ERRO PINTAR LOGO NO PINPAD',e.Message,GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
           end
        end;
     end;
  //------------------------------------------------------
end;
{
procedure TEmbedPIX.SA_SalvarLog(titulo, dado: string);
begin
   if LSalvarLog then
      SA_Salva_Arquivo_Incremental(titulo + ' ' +
                                   formatdatetime('dd/mm/yyyy hh:mm:ss',now)+#13+dado,
                                   GetCurrentDir+'\TEF_log\logEMBEDPix'+formatdatetime('yyyymmdd',date)+'.txt');
end;
}
function TEmbedPIX.SA_UsarPinpad: boolean;
begin
   Result := ConfigPinPad.PINPAD_Porta<>'';
end;

end.
