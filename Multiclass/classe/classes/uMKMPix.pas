unit uMKMPix;

interface

uses
   clipbrd,
   synacode,
   ACBrPosPrinter,
   ACBrImage,
   ACBrNFe.Classes,
   ACBrDelphiZXingQRCode,
   Vcl.Imaging.pngimage,
   vcl.forms,
   uKSTypes,
   uMulticlassFuncoes,
   uwebtefmp,
   ACBrAbecsPinPad,
   ACBrDeviceSerial,
   RESTRequest4d,
   System.Math,
   System.JSON,
   System.DateUtils,
   System.SysUtils,
   System.Classes,
   udmMultiClass;

type
   //---------------------------------------------------------------------------
   TMKMPix = class
     private
        //----------------------------------------------------------------------
        LForma        : string;
        LValor        : real;
        LTempo        : integer;
        //----------------------------------------------------------------------
        LConfigPinPad : TKSConfigPinPad;      // Configuração do PINPAD
        LImpressora   : TKSConfigImpressora;  // Configuração da impressora
        LEmitente     : TEmit;                // Configurações do Emitente - Recebedor
        //----------------------------------------------------------------------
        LChave                : string;
        LCNPJ                 : string;
        LHostMKMPIX           : string;
        LImprimirViaCliente   : TtpTEFImpressao;
        LImprimirViaLoja      : TtpTEFImpressao;
        //----------------------------------------------------------------------
        LQRCode               : string;
        LStatusTransacao      : TTMKMPixStatusConsulta;
        LE2E                  : string;
        LTxID                 : string;
        LValidade             : TDateTime;
        LComprovanteCliente   : TStringList;
        LComprovanteLoja      : TStringList;
        LNumeroTEF            : integer;
        //----------------------------------------------------------------------
        LExecutando           : boolean;
        LData                 : TDate;
        LHora                 : TTime;
        LDataHora             : TDateTime;
        LSalvarLog            : boolean;
        //----------------------------------------------------------------------
        procedure SA_GerarCobrancaPIX;
        procedure SA_PIXConsultarCobranca;
        procedure SA_PintarPIX(QRCode: string);
        function SA_UsarPinpad:boolean;
        Procedure SA_ConfigurarPinPadPIX;
        function SA_PINPAD_MostrarImagem(imagem:TPngImage):boolean;
        function SA_StatusPIX(status:string):TTMKMPixStatusConsulta;
        procedure SA_CriarComprovantes;
        //----------------------------------------------------------------------
        procedure SA_MostramensagemT;
        procedure SA_MostrarBtCancelarT;
        procedure SA_DesativarBtCancelarT;
        procedure SA_CriarMenuT;
        procedure SA_RestaurarLogoT;
        //----------------------------------------------------------------------
     public
        //----------------------------------------------------------------------
        PinPad                : TACBrAbecsPinPad;
        //----------------------------------------------------------------------
        property Forma              : string  read LForma        write LForma;
        property Valor              : real    read LValor        write LValor;
        property Tempo              : integer read LTempo        write LTempo;
        //----------------------------------------------------------------------
        property ConfigPinPad       : TKSConfigPinPad            read LConfigPinPad  write LConfigPinPad;  // Configuração do PINPAD
        property Impressora         : TKSConfigImpressora        read LImpressora    write LImpressora;    // Configuração da impressora
        property Emitente           : TEmit                      read LEmitente      write LEmitente;      // Configurações do Emitente - Recebedor
        //----------------------------------------------------------------------
        property Chave              : string             read LChave              write LChave;
        property CNPJ               : string             read LCNPJ               write LCNPJ;
        property HostMKMPIX         : string             read LHostMKMPIX         write LHostMKMPIX;
        property SalvarLog          : boolean            read LSalvarLog          write LSalvarLog;
        property ImprimirViaCliente : TtpTEFImpressao    read LImprimirViaCliente write LImprimirViaCliente;
        property ImprimirViaLoja    : TtpTEFImpressao    read LImprimirViaLoja    write LImprimirViaLoja;
        property Executando         : boolean            read LExecutando         write LExecutando;
        property E2E                : string             read LE2E                write LE2E;
        property TxID               : string             read LTxID               write LTxID;
        property ComprovanteCliente : TStringList        read LComprovanteCliente;
        property ComprovanteLoja    : TStringList        read LComprovanteLoja;
        property NumeroTEF          : integer            read LNumeroTEF          write LNumeroTEF;
        //----------------------------------------------------------------------
        constructor Create();
        procedure SA_ProcessarPagamento;
        //----------------------------------------------------------------------
   end;

implementation

{ TMKMPix }

constructor TMKMPix.Create;
begin
   //---------------------------------------------------------------------------
   LExecutando         := true;
   LData               := date;
   LHora               := Time;
   LDataHora           := now;
   LStatusTransacao    := tPgtoPIXIndefinido;
   LComprovanteCliente := TStringList.Create;
   LComprovanteLoja    := TStringList.Create;
   //---------------------------------------------------------------------------
   PinPad := TACBrAbecsPinPad.Create(nil);
   //---------------------------------------------------------------------------
   inherited;
   //---------------------------------------------------------------------------
end;

procedure TMKMPix.SA_ConfigurarPinPadPIX;
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

procedure TMKMPix.SA_CriarComprovantes;
begin
   //---------------------------------------------------------------------------
   LComprovanteCliente.Add('</ce><e>COMPROVANTE DE PIX</e>');
   LComprovanteCliente.Add('        ');
   LComprovanteCliente.Add('</ce>VIA CLIENTE');
   LComprovanteCliente.Add('</ae>        ');
   LComprovanteCliente.Add('RECEBEDOR:');
   LComprovanteCliente.Add(LEmitente.CNPJCPF);
   LComprovanteCliente.Add(LEmitente.xNome);
   LComprovanteCliente.Add(LEmitente.xFant);
   LComprovanteCliente.Add(LEmitente.EnderEmit.xLgr+' '+LEmitente.EnderEmit.nro+' '+LEmitente.EnderEmit.xCpl);
   LComprovanteCliente.Add(LEmitente.EnderEmit.xMun+' '+LEmitente.EnderEmit.UF);
   LComprovanteCliente.Add('   ');
   LComprovanteCliente.Add('Valor R$ '+transform(LValor));
   LComprovanteCliente.Add('Realizado em : '+formatdatetime('yyyy-mm-dd hh:mm:ss',now));
   LComprovanteCliente.Add('    Doc. E2E : '+LE2E);
   LComprovanteCliente.Add('         PSP : MKM PIX');
   LComprovanteCliente.Add(' ');
   //---------------------------------------------------------------------------
   LComprovanteLoja.Add('</ce><e>COMPROVANTE DE PIX</e>');
   LComprovanteLoja.Add('        ');
   LComprovanteLoja.Add('</ce>VIA LOJA');
   LComprovanteLoja.Add('</ae>        ');
   LComprovanteCliente.Add('   ');
   LComprovanteLoja.Add('Valor R$ '+transform(LValor));
   LComprovanteLoja.Add('Realizado em : '+formatdatetime('yyyy-mm-dd hh:mm:ss',now));
   LComprovanteLoja.Add('    Doc. E2E : '+LE2E);
   LComprovanteLoja.Add('         PSP : MKM PIX');
   LComprovanteLoja.Add(' ');

   //---------------------------------------------------------------------------
end;

procedure TMKMPix.SA_CriarMenuT;
begin
   SA_Criar_Menu(true);
end;

procedure TMKMPix.SA_DesativarBtCancelarT;
begin
   SA_DesativarBTCancelar;
end;

procedure TMKMPix.SA_GerarCobrancaPIX;
var
   LResponse   : IResponse;
   RetornoJSON : TJSONValue;

begin
   //---------------------------------------------------------------------------
   try
      //------------------------------------------------------------------------
      SA_SalvarLog('GERAR QRCODE MSSC','{"chave":"'+LChave+'",'+
                               '"cnpj":"'+LCNPJ+'",'+
                               '"valor":"'+formatfloat('###,##0.00',LValor)+'",'+
                               '"espera":"'+ltempo.ToString+'"'+
                               '}',
                               GetCurrentDir+'\TEF_Log\logMKMPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      //------------------------------------------------------------------------
      LResponse := TRequest.New.BaseURL(LHostMKMPIX+':12090/cobrancapixmkm')
                     .AddBody('{"chave":"'+string(encodeBase64(ansistring(LChave)))+'",'+
                               '"cnpj":"'+LCNPJ+'",'+
                               '"valor":"'+formatfloat('###,##0.00',LValor)+'",'+
                               '"espera":"'+ltempo.ToString+'"'+
                               '}')
                               .Accept('application/json')
                               .Timeout(20000)
                               .Post;
      //------------------------------------------------------------------------
      if LResponse.StatusCode=200 then
         begin
            retornoJSON := TJSonObject.ParseJSONValue(LResponse.Content );
            LQRCode     := retornoJSON.GetValue<string>('QRCode','');
            LTxID       := retornoJSON.GetValue<string>('TxID','');
            LValidade   := strtodatetime(retornoJSON.GetValue<string>('validade',''));
            retornoJSON.Free;
         end
      else
         SA_SalvarLog('FALHA GERAR QRCODE MSSC',LResponse.Content+' '+LResponse.StatusCode.ToString,GetCurrentDir+'\TEF_Log\logMKMPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      //------------------------------------------------------------------------
   except on e:exception do
      begin
         SA_SalvarLog('FALHA AO CHAMAR SERCVIDOR MSSC',e.Message,GetCurrentDir+'\TEF_Log\logMKMPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      end;
   end;
end;


procedure TMKMPix.SA_MostramensagemT;
begin
   SA_Mostrar_Mensagem(true);
end;

procedure TMKMPix.SA_MostrarBtCancelarT;
begin
   SA_AtivarBTCancelar;   // Ativar o botão cancelar na tela de TEF
end;

function TMKMPix.SA_PINPAD_MostrarImagem(imagem: TPngImage): boolean;
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

procedure TMKMPix.SA_PintarPIX(QRCode: string);
var
   png    : TPngImage;
   qrsize : Integer;
begin
   //---------------------------------------------------------------------------
   try
      PintarQRCode(QRCode, frmwebtef.logomp.Picture.Bitmap, qrUTF8BOM);
   except on e:exception do
      begin
         SA_SalvarLog('ERRO PINTAR PIX NA TELA',e.Message,GetCurrentDir+'\TEF_Log\logMKMPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
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
               SA_SalvarLog('ERRO PINTAR PIX NA NO PINPAD',e.Message,GetCurrentDir+'\TEF_Log\logMKMPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
            end

         end;
      end;
   //---------------------------------------------------------------------------
end;
procedure TMKMPix.SA_PIXConsultarCobranca;
var
   LResponse   : IResponse;
   RetornoJSON : TJSONValue;
begin
   //---------------------------------------------------------------------------
   try
      //------------------------------------------------------------------------
      SA_SalvarLog('CONSULTAR PIX MSSC','{"chave":"'+LChave+'",'+
                               '"cnpj":"'+LCNPJ+'",'+
                               '"TxID":"'+LTxID+'",'+
                               '"espera":"'+ltempo.ToString+'"'+
                               '}',
                               GetCurrentDir+'\TEF_Log\logMKMPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      //------------------------------------------------------------------------
      LResponse := TRequest.New.BaseURL(LHostMKMPIX+':12090/consultapixmkm')
                     .AddBody('{"chave":"'+string(encodeBase64(ansistring(LChave)))+'",'+
                               '"cnpj":"'+LCNPJ+'",'+
                               '"TxID":"'+LTxID+'"'+
                               '}')
                               .Accept('application/json')
                               .Timeout(20000)
                               .Post;
      if LResponse.StatusCode=200 then
         begin
            retornoJSON      := TJSonObject.ParseJSONValue(LResponse.Content );
            LE2E             := retornoJSON.GetValue<string>('E2E','');
            LStatusTransacao := SA_StatusPIX(retornoJSON.GetValue<string>('statuspix',''));
            SA_SalvarLog('CONSULTAR MSSC',LResponse.Content+' '+LResponse.StatusCode.ToString + retornoJSON.GetValue<string>('statuspix',''),GetCurrentDir+'\TEF_Log\logMKMPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
            retornoJSON.Free;
         end
      else
         SA_SalvarLog('FALHA CONSULTAR MSSC',LResponse.Content+' '+LResponse.StatusCode.ToString,GetCurrentDir+'\TEF_Log\logMKMPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   except on e:exception do
      begin
         SA_SalvarLog('ERRO CONSULTAR MSSC',e.Message,GetCurrentDir+'\TEF_Log\logMKMPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      end;

   end;
end;

procedure TMKMPix.SA_ProcessarPagamento;
var
   sair                : boolean;
   HInicio             : ttime;
   ImprimirComprovante : boolean;
   SairLoopImpressao   : boolean;
   //---------------------------------------------------------------------------
   TempoEsperando      : integer;
   horageracao         : TTime;
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   //   Iniciando a tela de TEF
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpMKMPix;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LForma;
   frmwebtef.lbvalor.Caption  := transform(LValor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   //---------------------------------------------------------------------------
   TThread.CreateAnonymousThread(procedure
   begin
      //------------------------------------------------------------------------
      //   Inicializar TEF
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Inicializando MKM PIX...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      //------------------------------------------------------------------------
      SA_GerarCobrancaPIX;  // Chamar a API para gerar o PIX
      horageracao := now;
      LValidade   := IncSecond(horageracao,ltempo);
      if (LTxID<>'') and (LQRCode<>'') then
         begin
            //------------------------------------------------------------------
            //   Pintar QRCode na tela e no PINPAD
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
               frmwebtef.logomp.Stretch      := true;
               frmwebtef.logomp.Proportional := true;
               SA_PintarPIX(LQRCode);
            end);
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
            sair           := false;
            HInicio        := now;
            TempoEsperando := 0;
            Clipboard.AsText := lQRCode;
            while not sair do
               begin
                  //------------------------------------------------------------
                  //   Verificar se o operador clicou no CANCELAR
                  //------------------------------------------------------------
                  if (frmwebtef.Cancelar) or ((now>LValidade)) then
                     begin
                        frmwebtef.Cancelar := false;
                        sair := true;
                        //------------------------------------------------------
                        HInicio := now;
                        //------------------------------------------------------
                        TThread.Synchronize(TThread.CurrentThread,SA_RestaurarLogoT);
                     end;
                  //------------------------------------------------------------
                  if (LStatusTransacao=tPgtoPIXAguardando) or (LStatusTransacao=tPgtoPIXIndefinido) then   // Aguardando pagamento
                     begin
                        TempoEsperando := LTempo-SecondsBetween(now,horageracao);
                        frmwebtef.mensagem := 'EXPIRA EM : '+formatdatetime('hh:mm:ss',LValidade)+' - '+TempoEsperando.ToString;
                        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                     end;
                  //------------------------------------------------------------
                  if SecondsBetween(now,hinicio)>2 then // Somente faz a consulta se o tempo decorrido desde a ultima consulta form maior que 2 segundos
                     begin
                        //------------------------------------------------------
                        //   Consultar PSP
                        //------------------------------------------------------
                        SA_PIXConsultarCobranca;   // Realizando a consulta no MKM MSSC
                        hinicio := now;
                        if LStatusTransacao=tPgtoPIXRealizado then   // O Pagamento foi confirmado
                           begin
                              //------------------------------------------------
                              //   Pix concluído
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_RestaurarLogoT);
                              //------------------------------------------------
                              //  Confirmar pagamento, imprimir comprovantes
                              //------------------------------------------------
                              LData     := Date;
                              LHora     := Time;
                              LDataHora := Now;
                              SA_CriarComprovantes;
                              //------------------------------------------------
                              //   Impressão da via do cliente
                              //------------------------------------------------
                              ImprimirComprovante := false;
                              if LImprimirViaCliente=tpTEFImprimirSempre then  // Imprimir o comprovante automaticamente
                                 ImprimirComprovante := true
                              else if LImprimirViaCliente=tpTEFPerguntar then  // Imprimir o comprovante automaticamente
                                 begin
                                    //------------------------------------------
                                    //   Perguntar se quer imprimir comprovante
                                    //------------------------------------------
                                    frmwebtef.mensagem := 'Imprimir o comprovante do CLIENTE ?';
                                    frmwebtef.opcoes   := TStringList.Create;
                                    frmwebtef.opcoes.Clear;
                                    frmwebtef.opcoes.Add('Imprimir');
                                    frmwebtef.opcoes.Add('Não Imprimir');
                                    frmwebtef.opcao    := -1;
                                    frmwebtef.tecla    := '';
                                    frmwebtef.Cancelar := false;
                                    //------------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                    TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                    //------------------------------------------
                                    ImprimirComprovante := false;
                                    SairLoopImpressao   := false;
                                    while (not SairLoopImpressao) do  // Aguardando o operador confirmar ou cancelar a impressão
                                       begin
                                         if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                            begin
                                               ImprimirComprovante := true;
                                               SairLoopImpressao   := true;
                                            end
                                         else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) or (frmwebtef.Cancelar) then
                                            begin
                                               ImprimirComprovante := false;
                                               SairLoopImpressao   := true;
                                            end;
                                          //------------------------------------
                                          sleep(50);
                                       end;
                                    //------------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    frmwebtef.Cancelar := false;
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                              if ImprimirComprovante then
                                 SA_ImprimirTexto(LComprovanteLoja.Text,LImpressora);
                              //------------------------------------------------
                              //   Via do comprovante da loja
                              //------------------------------------------------
                              ImprimirComprovante := false;
                              if LImprimirViaLoja=tpTEFImprimirSempre then  // Imprimir o comprovante automaticamente
                                 ImprimirComprovante := true
                              else if LImprimirViaLoja=tpTEFPerguntar then  // Imprimir o comprovante automaticamente
                                 begin
                                    //------------------------------------------
                                    //   Perguntar se quer imprimir comprovante
                                    //------------------------------------------
                                    frmwebtef.mensagem := 'Imprimir o comprovante da LOJA ?';
                                    frmwebtef.opcoes   := TStringList.Create;
                                    frmwebtef.opcoes.Clear;
                                    frmwebtef.opcoes.Add('Imprimir');
                                    frmwebtef.opcoes.Add('Não Imprimir');
                                    frmwebtef.opcao    := -1;
                                    frmwebtef.tecla    := '';
                                    frmwebtef.Cancelar := false;
                                    //------------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                    TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                    //------------------------------------------
                                    ImprimirComprovante := false;
                                    SairLoopImpressao   := false;
                                    while (not SairLoopImpressao) do  // Aguardando o operador confirmar ou cancelar a impressão
                                       begin
                                         if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                            begin
                                               ImprimirComprovante := true;
                                               SairLoopImpressao   := true;
                                            end
                                         else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) or (frmwebtef.Cancelar) then
                                            begin
                                               ImprimirComprovante := false;
                                               SairLoopImpressao   := true;
                                            end;
                                          //------------------------------------
                                          sleep(50);
                                       end;
                                    //------------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    frmwebtef.Cancelar := false;
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                              if ImprimirComprovante then
                                 SA_ImprimirTexto(LComprovanteLoja.Text,LImpressora);
                              //------------------------------------------------
                              sair := true;
                              //------------------------------------------------
                           end
                        else if LStatusTransacao=tPgtoPIXAguardando then   // Aguardando pagamento
                           begin
                              //------------------------------------------------
                              // Mostrar mensagem do tempo aguardando
                              //------------------------------------------------
                              frmwebtef.mensagem := 'Aguardando pagamento PIX...';
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                           end
                        else if LStatusTransacao=tPgtoPIXErro then   // Erro na consulta
                           begin
                              //------------------------------------------------
                              frmwebtef.mensagem := 'Ocorreu erro ao consultar PIX...';
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              //------------------------------------------------
                           end
                        else if LStatusTransacao=tPgtoPIXCancelado then   // Cancelado pelo operador
                           begin
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_RestaurarLogoT);
                              frmwebtef.mensagem := 'Cancelada pelo operador...';
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              //------------------------------------------------
                              while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                 begin
                                    sleep(50);
                                 end;
                              sair := true;   // Ativar a saída do LOOP
                              //------------------------------------------------
                           end
                        else if LStatusTransacao=tPgtoPIXIndefinido then   // Indefinido
                           begin
                           end
                        else if LStatusTransacao=tPgtoPIXExpirado then   // Tempo expirou
                           begin
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_RestaurarLogoT);
                              //------------------------------------------------
                              frmwebtef.mensagem := 'Tempo de espera expirou...';
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              //------------------------------------------------
                              while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                 begin
                                    sleep(50);
                                 end;
                              sair := true;   // Ativar a saída do LOOP
                              //------------------------------------------------
                           end;
                        //------------------------------------------------------
                     end;
               end;
            //------------------------------------------------------------------
         end
      else
         begin
            //------------------------------------------------------------------
            //  Ocorreu um erro
            //------------------------------------------------------------------
            SA_SalvarLog('RESPOSTA REALIZAR PAGAMENTO','Não foi possível gerar o QRCODE',GetCurrentDir+'\TEF_Log\logMKMPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
            frmwebtef.mensagem := 'Ocorreu erro ao gerar a cobrança';
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
            while not frmwebtef.Cancelar do
               begin
                  sleep(50);
               end;
            //------------------------------------------------------------------
         end;
      //------------------------------------------------------------------------
      //   Fechando a janela do TEF
      //------------------------------------------------------------------------
      frmwebtef.Close;
      frmwebtef.Release;
      lExecutando := false;
      //------------------------------------------------------------------------

   end).Start;
   //---------------------------------------------------------------------------
end;

procedure TMKMPix.SA_RestaurarLogoT;
var
   png : TPngImage;
begin
  //----------------------------------------------------------------------------
   frmwebtef.logomp.Stretch      := false;
   frmwebtef.logomp.Proportional := true;
   frmwebtef.logomp.Center       := true;
   frmwebtef.logomp.Picture.LoadFromFile(GetCurrentDir+'\icones\tef_mkmpix.bmp');
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
              SA_SalvarLog('ERRO PINTAR LOGO NO PINPAD',e.Message,GetCurrentDir+'\TEF_Log\logMKMPix'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
           end
        end;
     end;
  //------------------------------------------------------
end;

function TMKMPix.SA_StatusPIX(status: string): TTMKMPixStatusConsulta;
begin
   //---------------------------------------------------------------------------
   if status='APPROVED' then
      Result := tPgtoPIXRealizado
   else if status='EXPIRED' then
      Result := tPgtoPIXExpirado
   else if status='REFUSED' then
      Result := tPgtoPIXErro
   else if status='CREATED' then
      Result := tPgtoPIXAguardando
   else
      Result := tPgtoPIXIndefinido;
   //---------------------------------------------------------------------------
end;

function TMKMPix.SA_UsarPinpad: boolean;
begin
   Result := ConfigPinPad.PINPAD_Porta<>'';
end;

end.
