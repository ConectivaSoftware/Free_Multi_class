unit uMultiPlusTEF;

interface

uses
   System.UITypes,
   WinApi.Windows,
   ACBrPosPrinter,
   ACBrImage,
   ACBrDelphiZXingQRCode,
   Vcl.Imaging.pngimage,
   uKSTypes,
   TypInfo,
   vcl.forms,
   Vcl.Graphics,
   System.JSON,
   System.Math,
   uMulticlassFuncoes,
   System.SysUtils,
   system.DateUtils,
   system.Classes,
   ACBrAbecsPinPad,
   ACBrDeviceSerial,
   uwebtefmp;

const
  CDLLTef = 'TefClientmc.dll';

type
   //---------------------------------------------------------------------------
   TpOperacaoMPL            = (tpOpVenda , tpOpCancelamentoVenda);
   TPRetornoMultiPlus       = (TPMultiPlusMENU , TPMultiPlusMSG , TPMultiPlusPERGUNTA , TPMultiPlusRETORNO , TPMultiPlusERROABORTAR , TPMultiPlusERRODISPLAY,TPMultiPlusINDEFINIDO);
   TMultiPlusTTipoDado      = (TtpINT, TtpSTRING, TtpDECIMAL, TtpDATE , TtpINDEFINIDO);
   //---------------------------------------------------------------------------
   TMultiPlusMenu = record
      Titulo : string;
      Opcoes : TStringList;
   end;
   //---------------------------------------------------------------------------
   // Record para fazer uma perguntar
   //---------------------------------------------------------------------------
   TMultiPlusPergunta = record
      Titulo         : string;
      Tipo           : TMultiPlusTTipoDado;
      TamanhoMinimo  : integer;
      TamanhoMaximo  : integer;
      VlMinimo       : string;
      VlMaximo       : string;
      CasasDecimais  : integer;
      Mascara        : string;
      ValorColetado  : string;
   end;
   //---------------------------------------------------------------------------
   //   Tipo RECORD para armazenar os dados de uma solicitação PIX
   //---------------------------------------------------------------------------
   TMultiPlusDadosPix = record
      NSU    : string;
      ORIGEM : string;
      VALOR  : real;
      QRCODE : string;
   end;
   //---------------------------------------------------------------------------
   TMultiPlusRetornoTransacao = record
      CUPOM              : string;
      VALOR              : real;
      COD_BANDEIRA       : string;
      COD_REDE           : string;
      COD_AUTORIZACAO    : string;
      NSU                : string;
      QTDE_PARCELAS      : integer;
      TAXA_SERVICO       : real;
      BIN_CARTAO         : string;
      ULT_DIGITOS_CARTAO : string;
      CNPJ_AUTORIZADORA  : string;
      NOME_CLIENTE       : string;
      NSU_REDE           : string;
      VENCTO_CARTAO      : string;
      COMPROVANTE        : TStringList;
      VIAS_COMPROVANTE   : integer;
      NOME_BANDEIRA      : string;
      NOME_REDE          : string;
      CARTAO_PRE_PAGO    : boolean;
      COD_TIPO_TRANSACAO : string;
      DESC_TRANSACAO     : string;
      DadosPIX           : TMultiPlusDadosPix;
      E2E                : string;   // Retorno da transação PIX
      ComprovanteLoja    : TStringList;
      Data               : TDate;
      Hora               : TTime;
      OperacaoExecutada  : boolean;
   end;
   //---------------------------------------------------------------------------
   TMultiPlusTEF = class
      Private
         //---------------------------------------------------------------------
         LImpressora : TKSConfigImpressora;  // Configuração da impressora
         //---------------------------------------------------------------------
         LSalvarLog            : boolean;
         LExecutando           : boolean;
         //---------------------------------------------------------------------
         LForma                       : string;            // Forma para ser apresentada na tela de apresentação
         LIComprovanteCliente         : TtpTEFImpressao;   // A impressão do comprovante do cliente é automática, pergunta ou não imprimir
         LIComprovanteLoja            : TtpTEFImpressao;   // A impressão do comprovante da loja é automática, pergunta ou não imprimir
         LComprovanteLojaSimplificado : boolean;           // Habilitar a impressão simplificada do comprovante da loja
         //---------------------------------------------------------------------
         //  Parâmetros para realizar a transação
         //---------------------------------------------------------------------
         LTpOperacaoTEF        : TtpMultiplusFormaPgto;
         LCNPJ                 : string;
         LParcela              : integer;
         LCupom                : integer;
         LValor                : real;
         LNSU                  : string;
         LPdv                  : string;
         LCodigoLoja           : string;
         LData                 : TDate;
         LHora                 : TTime;
         LDataHora             : TDateTime;
         //---------------------------------------------------------------------
         LRetornoTransacao     : TMultiPlusRetornoTransacao;  // Retorno da transação
         //---------------------------------------------------------------------
         LConfigPinPad         : TKSConfigPinPad;            // Configuração do PINPAD
         //---------------------------------------------------------------------
         function SA_TpCartaoOperacaoTEFtoINT(tipoCartao : TtpMultiplusFormaPgto):integer;
         function SA_TpCartaoOperacaoTEFtoSTR(tipoCartao: TtpMultiplusFormaPgto): string;
         function SA_RetornoErro(codigo:integer):string;
         //---------------------------------------------------------------------
         //   Funções para tratar as respostas do TEF
         //---------------------------------------------------------------------
         function SA_MultiPlusTPRetorno(retorno:string):TPRetornoMultiPlus;
         function SA_SA_MultiPlusBuscarCampo(campo,retorno:string):string;
         function SA_SA_MultiPlusRetornoTransacao(retorno:string):TMultiPlusRetornoTransacao;
         function SA_SA_MultiPlusMensagemRetorno(retorno:string):string;
         function SA_SA_MultiPlusTipoDado(dado:string):TMultiPlusTTipoDado;
         function SA_SA_MultiPlusPerguntaRetorno(retorno:string):TMultiPlusPergunta;
         function SA_SA_MultiPlusOpcoesMenuRetorno(retorno:string):TMultiPlusMenu;
         function SA_PerguntarOpcoes(opcoes: TStringList;mensagem:string): integer;
         function SA_ValidarRespostaPergunta(Pergunta : TMultiPlusPergunta ; ValorColetado : string):boolean;
         function SA_FormatarRespostaPergunta(pergunta : TMultiPlusPergunta ; ValorColetado : string):string;
         function SA_GerarComprovanteSimplificado(Operacao : TpOperacaoMPL = tpOpVenda): TStringList;
         function SA_ExtrairDadosPIX(DadosPIX:string):TMultiPlusDadosPix;
         function SA_ExtraiCamporDadosPIX(Campo,  DadosPIX: string): string;
         Procedure SA_PintarPix(QRCode:string);
         function SA_UsarPinpad:boolean;
         Procedure SA_ConfigurarPinPad;
         function SA_PINPAD_MostrarImagem(imagem:TPngImage):boolean;
         //---------------------------------------------------------------------
         procedure SA_MostramensagemT;
         procedure SA_MostrarBtCancelarT;
         procedure SA_DesativarBtCancelarT;
         procedure SA_CriarMenuT;
         procedure SA_DesativarMenuT;
         //---------------------------------------------------------------------
      Public
         //---------------------------------------------------------------------
         PinPad               : TACBrAbecsPinPad;
         //---------------------------------------------------------------------
         constructor Create();
         procedure SA_ProcessarPagamento;
         procedure SA_Cancelamento;
         //---------------------------------------------------------------------
         property SalvarLog            : boolean read LSalvarLog write LSalvarLog;
         property Executando           : boolean read LExecutando;
         //---------------------------------------------------------------------
         property Forma                       : string          read LForma               write LForma;   // Forma para ser apresentada na tela de apresentação
         property IComprovanteCliente         : TtpTEFImpressao read LIComprovanteCliente write LIComprovanteCliente;   // A impressão do comprovante do cliente é automática, pergunta ou não imprimir
         property IComprovanteLoja            : TtpTEFImpressao read LIComprovanteLoja    write LIComprovanteLoja;   // A impressão do comprovante da loja é automática, pergunta ou não imprimir
         property ComprovanteLojaSimplificado : boolean         read LComprovanteLojaSimplificado write LComprovanteLojaSimplificado;           // Habilitar a impressão simplificada do comprovante da loja
         //---------------------------------------------------------------------
         //  Parâmetros para realizar a transação
         //---------------------------------------------------------------------
         property TpOperacaoTEF        : TtpMultiplusFormaPgto   read LTpOperacaoTEF write LTpOperacaoTEF;
         property CNPJ                 : string                  read LCNPJ          write LCNPJ;
         property Parcela              : integer                 read LParcela       write LParcela;
         property Cupom                : integer                 read LCupom         write LCupom;
         property Valor                : real                    read LValor         write LValor;
         property NSU                  : string                  read LNSU           write LNSU;
         property Pdv                  : string                  read LPdv           write LPdv;
         property CodigoLoja           : string                  read LCodigoLoja    write LCodigoLoja;
         //---------------------------------------------------------------------
         property RetornoTransacao     : TMultiPlusRetornoTransacao read LRetornoTransacao write LRetornoTransacao;  // Para retornar a transação
         //---------------------------------------------------------------------
         property ConfigPinPad         : TKSConfigPinPad         read LConfigPinPad  write LConfigPinPad;            // Configuração do PINPAD
         property Impressora           : TKSConfigImpressora     read LImpressora    write LImpressora;  // Configuração da impressora
         //---------------------------------------------------------------------
   end;

   TFuncIniciaFuncaoMCInterativo = function( iComando         : Integer;
                                  sCnpjCliente     : PAnsiChar;
                                  iParcela         : Integer;
                                  sCupom           : PAnsiChar;
                                  sValor           : PAnsiChar;
                                  sNsu             : PAnsiChar;
                                  sData            : PAnsiChar;
                                  sNumeroPDV       : PAnsiChar;
                                  sCodigoLoja      : PAnsiChar;
                                  sTipoComunicacao : Integer;
                                  sParametro       : PAnsiChar
                                  ): Integer; cdecl;

   TFuncAguardaFuncaoMCInterativo = function: PAnsiChar; cdecl;

   TFuncContinuaFuncaoMCInterativo = function(sInformacao: PAnsiChar): Integer; cdecl;

   TFuncCancelarFluxoMCInterativo = function: Integer; cdecl;

   TFuncFinalizaFuncaoMCInterativo = function ( iComando         : Integer;
                                     sCnpjCliente     : PAnsiChar;
                                     iParcela         : Integer;
                                     sCupom           : PAnsiChar;
                                     sValor           : PAnsiChar;
                                     sNsu             : PAnsiChar;
                                     sData            : PAnsiChar;
                                     sNumeroPDV       : PAnsiChar;
                                     sCodigoLoja      : PAnsiChar;
                                     sTipoComunicacao : Integer;
                                     sParametro       : PAnsiChar
                                     ): Integer; cdecl;

   //---------------------------------------------------------------------------

   function IniciaFuncaoMCInterativo( iComando         : Integer;
                                      sCnpjCliente     : PAnsiChar;
                                      iParcela         : Integer;
                                      sCupom           : PAnsiChar;
                                      sValor           : PAnsiChar;
                                      sNsu             : PAnsiChar;
                                      sData            : PAnsiChar;
                                      sNumeroPDV       : PAnsiChar;
                                      sCodigoLoja      : PAnsiChar;
                                      sTipoComunicacao : Integer;
                                      sParametro       : PAnsiChar
                                      ): Integer;


   function AguardaFuncaoMCInterativo(): PAnsiChar;

   function ContinuaFuncaoMCInterativo(sInformacao: PAnsiChar): Integer;

   function FinalizaFuncaoMCInterativo( iComando         : Integer;
                                        sCnpjCliente     : PAnsiChar;
                                        iParcela         : Integer;
                                        sCupom           : PAnsiChar;
                                        sValor           : PAnsiChar;
                                        sNsu             : PAnsiChar;
                                        sData            : PAnsiChar;
                                        sNumeroPDV       : PAnsiChar;
                                        sCodigoLoja      : PAnsiChar;
                                        sTipoComunicacao : Integer;
                                        sParametro       : PAnsiChar
                                        ): Integer;

   function CancelarFluxoMCInterativo(): Integer;

   //---------------------------------------------------------------------------
implementation

{ TMultiPlusTEF }

function LoadDLL: THandle;
begin
  if not FileExists(CDLLTef) then
    raise Exception.CreateFmt('DLL %s não encontrada.', [CDLLTef]);

  Result := LoadLibrary(CDLLTef);
  if Result = 0 then
    raise Exception.CreateFmt('Não foi possível carregar a DLL %s', [CDLLTef]);
end;

function IniciaFuncaoMCInterativo( iComando         : Integer;
                                  sCnpjCliente     : PAnsiChar;
                                  iParcela         : Integer;
                                  sCupom           : PAnsiChar;
                                  sValor           : PAnsiChar;
                                  sNsu             : PAnsiChar;
                                  sData            : PAnsiChar;
                                  sNumeroPDV       : PAnsiChar;
                                  sCodigoLoja      : PAnsiChar;
                                  sTipoComunicacao : Integer;
                                  sParametro       : PAnsiChar
                                  ): Integer;
var
   LHandle  : THandle;
   LDLLFunc : TFuncIniciaFuncaoMCInterativo;
begin
   LHandle  := LoadDLL;
   LDLLFunc := GetProcAddress(LHandle, 'IniciaFuncaoMCInterativo');
   if @LDLLFunc = nil then
      raise Exception.Create('Não foi possível carregar a função IniciaFuncaoMCInterativo');

    Result := LDLLFunc(iComando, sCnpjCliente, iParcela, sCupom, sValor, sNsu, sData, sNumeroPdv, sCodigoLoja,
       sTipoComunicacao, sParametro);
end;

function AguardaFuncaoMCInterativo: PAnsiChar;
var
  LHandle  : THandle;
  LDLLFunc : TFuncAguardaFuncaoMCInterativo;
begin
  LHandle  := LoadDLL;
  LDLLFunc := GetProcAddress(LHandle, 'AguardaFuncaoMCInterativo');
  if @LDLLFunc = nil then
    raise Exception.Create('Não foi possível carregar a função AguardaFuncaoMCInterativo');
   Result := LDLLFunc;
end;

function ContinuaFuncaoMCInterativo(sInformacao: PAnsiChar): Integer;
var
   LHandle  : THandle;
   LDLLFunc : TFuncContinuaFuncaoMCInterativo;
begin
   LHandle  := LoadDLL;
   LDLLFunc := GetProcAddress(LHandle, 'ContinuaFuncaoMCInterativo');
   if @LDLLFunc = nil then
     raise Exception.Create('Não foi possível carregar a função ContinuaFuncaoMCInterativo');

   Result := LDLLFunc(sInformacao);
end;

function FinalizaFuncaoMCInterativo( iComando         : Integer;
                                     sCnpjCliente     : PAnsiChar;
                                     iParcela         : Integer;
                                     sCupom           : PAnsiChar;
                                     sValor           : PAnsiChar;
                                     sNsu             : PAnsiChar;
                                     sData            : PAnsiChar;
                                     sNumeroPDV       : PAnsiChar;
                                     sCodigoLoja      : PAnsiChar;
                                     sTipoComunicacao : Integer;
                                     sParametro       : PAnsiChar
                                     ): Integer;
var
   LHandle  : THandle;
   LDLLFunc : TFuncFinalizaFuncaoMCInterativo;
begin
   LHandle  := LoadDLL;
   LDLLFunc := GetProcAddress(LHandle, 'FinalizaFuncaoMCInterativo');
   if @LDLLFunc = nil then
      raise Exception.Create('Não foi possível carregar a função FinalizaFuncaoMCInterativo');

   Result := LDLLFunc(iComando, sCnpjCliente, iParcela, sCupom, sValor, sNsu, sData, sNumeroPDV, sCodigoLoja, sTipoComunicacao,
      sParametro);
end;

function CancelarFluxoMCInterativo(): Integer;
var
   LHandle  : THandle;
   LDLLFunc : TFuncCancelarFluxoMCInterativo;
begin
   LHandle  := LoadDLL;
   LDLLFunc := GetProcAddress(LHandle, 'CancelarFluxoMCInterativo');
   if @LDLLFunc = nil then
      raise Exception.Create('Não foi possível carregar a função CancelarFluxoMCInterativo');
   Result := LDLLFunc;
end;

constructor TMultiPlusTEF.Create;
begin
   //---------------------------------------------------------------------------
   LExecutando  := true;
   LData        := date;
   LHora        := Time;
   LDataHora    := now;
   //---------------------------------------------------------------------------
   PinPad := TACBrAbecsPinPad.Create(nil);
   //---------------------------------------------------------------------------
   LRetornoTransacao.ComprovanteLoja := TStringList.Create;
   LRetornoTransacao.COMPROVANTE     := TStringList.Create;
   LRetornoTransacao.ComprovanteLoja := TStringList.Create;
   //---------------------------------------------------------------------------
   inherited;
   //---------------------------------------------------------------------------
end;

procedure TMultiPlusTEF.SA_Cancelamento;
var
   //---------------------------------------------------------------------------
   vlTransformado : string;
   IRetorno       : integer;
   CRetorno       : integer;
   SRetorno       : WideString;
   sair           : boolean;
   //---------------------------------------------------------------------------
   acao     : TPRetornoMultiPlus;
   Menu     : TMultiPlusMenu;
   Pergunta : TMultiPlusPergunta;
   //---------------------------------------------------------------------------
   opcaoColeta             : integer;    //  Quando selecionar uma opção do menu
   ImprimirComprovante     : boolean;    // Para sinalizar se o comprovante será impresso ou não
   ConteudoInicial         : string;
   Resposta_pergunta       : string;
   Leitura_pergunta        : boolean;
   finalizado              : boolean;
   qtdetentativasfinalizar : integer;
   SairLoopImpressao       : boolean;
   Comando                 : integer;
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   //   Iniciando a tela de TEF
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpTEFMultiPlus;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LForma;
   frmwebtef.lbvalor.Caption  := transform(LValor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   //---------------------------------------------------------------------------
   TThread.CreateAnonymousThread(procedure
   begin
      //------------------------------------------------------------------------
      //   Cancelamento de operação
      //------------------------------------------------------------------------
      //   Inicializar TEF
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Inicializando TEF...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      //------------------------------------------------------------------------
      vlTransformado := trim(FormatFloat('#####0.00',LValor));   // Formatando o valor para TEF
      vlTransformado := StringReplace(vlTransformado,'.',',',[]); // Substituindo o ponto decimal por vírgula
      if LParcela=0 then // Se a qtde parcelas for zero, transfromar para 1
         LParcela := 1;
      //------------------------------------------------------------------------
      Comando := 5;
      if LTpOperacaoTEF=tpMPlPIX then
         Comando := 54;
      SA_SalvarLog('REALIZAR CANCELAMENTO','R$:'+vlTransformado+' FORMA Pgto.:'+LForma+' NSU:'+LNSU+' Cupom Nr.:'+LCupom.ToString+' Tipo Cartao:'+SA_TpCartaoOperacaoTEFtoSTR(LTpOperacaoTEF)+' Parcelas:'+LParcela.ToString,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      IRetorno := IniciaFuncaoMCInterativo(comando,
                                           PAnsiChar(AnsiString(LCNPJ)),
                                           LParcela,
                                           PAnsiChar(AnsiString(LCupom.ToString)),
                                           PAnsiChar(AnsiString(vlTransformado)),
                                           PAnsiChar(AnsiString(LNSU)),
                                           PAnsiChar(AnsiString(formatdatetime('yyyyMMdd',LData))),
                                           PAnsiChar(AnsiString(LPdv)),
                                           PAnsiChar(AnsiString(LCodigoLoja)),
                                           0,
                                           '');
      //------------------------------------------------------------------------
      if IRetorno=0 then
         begin
            //------------------------------------------------------------------
            //  Sem ocorrência de erros, continuar o processo
            //------------------------------------------------------------------
            sair    := false;
            while not sair do
               begin
                  //------------------------------------------------------------
                  //   Fazer fluxo de consulta do TEF
                  //------------------------------------------------------------
                  SRetorno := widestring(AguardaFuncaoMCInterativo());
                  if SRetorno<>'' then   // Se o retorno não é vazio, verificar que tipo de retorno
                     begin
                        //------------------------------------------------------
                        //  acao = TPRetornoMultiPlus e de acordo com o retorno deverá ser executado um processo
                        // TPRetornoMultiPlus = (TPMultiPlusMENU , TPMultiPlusMSG , TPMultiPlusPERGUNTA , TPMultiPlusRETORNO , TPMultiPlusERROABORTAR , TPMultiPlusERRODISPLAY,TPMultiPlusINDEFINIDO);
                        //------------------------------------------------------
                        SA_SalvarLog('RESPOSTA AguardaFuncaoMCInterativo',SRetorno,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);  // Salvar LOG - Se ativado
                        //------------------------------------------------------
                        acao     := SA_MultiPlusTPRetorno(SRetorno);
                        //------------------------------------------------------
                        if acao=TPMultiPlusMSG then // Somente mostrar uma mensagem na tela
                           begin
                              //------------------------------------------------
                              //  Mostrar a mensagem na tela
                              //------------------------------------------------
                              frmwebtef.mensagem := SA_SA_MultiPlusMensagemRetorno(SRetorno);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              //------------------------------------------------
                           end
                        else if (acao=TPMultiPlusERROABORTAR) or (acao=TPMultiPlusERRODISPLAY) then // Somente mostrar uma mensagem na tela e encerrar o processo
                           begin
                              //------------------------------------------------
                              //   Ocorreu um evento que provocou o encerramento do processo (Abortar é apoiar o LULA)
                              //------------------------------------------------
                              frmwebtef.mensagem := SA_SA_MultiPlusMensagemRetorno(SRetorno);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                              while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                 begin
                                    sleep(50);
                                 end;
                              sair := true;   // Ativar a saída do LOOP
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                           end
                        else if acao=TPMultiPlusMENU then  // Deverá ser apresentado um menu de opções
                           begin
                              //------------------------------------------------
                              //  Criar um menu de opções para o operador escolher
                              //------------------------------------------------
                              Menu     := SA_SA_MultiPlusOpcoesMenuRetorno(SRetorno);
                              SRetorno := '';
                              acao     := TPMultiPlusINDEFINIDO;
                              //------------------------------------------------
                              frmwebtef.mensagem := menu.Titulo;
                              frmwebtef.opcoes   := menu.Opcoes;
                              frmwebtef.opcao    := -1;
                              frmwebtef.tecla    := '';
                              frmwebtef.Cancelar := false;
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                              TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                              //------------------------------------------------
                              application.ProcessMessages;
                              opcaoColeta  := SA_PerguntarOpcoes(menu.Opcoes,menu.Titulo);
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                              if opcaoColeta<>-1 then
                                 begin
                                    //------------------------------------------
                                    //   Enviar a coleta do item do menu para a DLL
                                    //------------------------------------------
                                    SA_SalvarLog('ENVIAR OPCAO MENU ContinuaFuncaoMCInterativo',pergunta.Titulo+' = '+opcaoColeta.ToString,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);  // Salvar LOG - Se ativado
                                    CRetorno := ContinuaFuncaoMCInterativo(PAnsiChar(AnsiString(opcaoColeta.ToString)));
                                    if CRetorno<>0 then // Houve um erro ao enviar o dado
                                       begin
                                          //------------------------------------
                                          frmwebtef.mensagem := SA_RetornoErro(CRetorno);
                                          SA_SalvarLog('ERRO ENVIAR OPCAO MENU ContinuaFuncaoMCInterativo',CRetorno.ToString+' '+frmwebtef.mensagem,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);  // Salvar LOG - Se ativado
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                          //------------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                                          while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                             begin
                                                sleep(50);
                                             end;
                                          sair := true;   // Ativar a saída do LOOP
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          //------------------------------------
                                       end;
                                    //------------------------------------------
                                 end
                              else
                                 sair := true;   // Ativar a saída do LOOP, o operador desistiu de responder e cancelou a operação
                              //------------------------------------------------
                           end
                        else if acao=TPMultiPlusPERGUNTA then  // Deverá ser perguntado algo
                           begin
                              //------------------------------------------------
                              //  Fazer uma pergunta ao operador
                              //------------------------------------------------
                              Pergunta := SA_SA_MultiPlusPerguntaRetorno(SRetorno);
                              //---------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,
                               procedure
                                  begin
                                     if pergunta.Tipo=TtpDATE then  // Se o tipo é data, o valor inicial é adata atual
                                        ConteudoInicial := FormatDateTime('dd/mm/yyyy',date);
                                     SA_ColetarValor(pergunta.Titulo,pergunta.mascara,false,ConteudoInicial);
                                  end);
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              Resposta_pergunta       := '';
                              Leitura_pergunta        := true;
                              //------------------------------------------------
                              while Leitura_pergunta do
                                 begin
                                    //------------------------------------------
                                    sleep(10);
                                    //------------------------------------------
                                    if (frmwebtef.dado_digitado<>'') and (not frmwebtef.Cancelar) then
                                       begin
                                          Resposta_pergunta := frmwebtef.dado_digitado;
                                          Leitura_pergunta  := not SA_ValidarRespostaPergunta(pergunta,Resposta_pergunta);
                                       end;


                                    if (frmwebtef.dado_digitado<>'') and (not SA_ValidarRespostaPergunta(pergunta,frmwebtef.dado_digitado)) then
                                       begin
                                          frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                          frmwebtef.pnalerta.Color        := clRed;
                                          frmwebtef.pnalerta.Font.Color   := clYellow;
                                          frmwebtef.dado_digitado         := '';
                                       end;
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                              frmwebtef.pncaptura.Visible := false;
                              frmwebtef.edtdado.Enabled   := false;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                              if not frmwebtef.Cancelar then
                                 begin
                                    pergunta.ValorColetado := SA_FormatarRespostaPergunta(pergunta,frmwebtef.dado_digitado);  // Formatar o dado coletado para enviar para a DLL
                                    SA_SalvarLog('ENVIAR DADO DA PERGUNTA ContinuaFuncaoMCInterativo',pergunta.Titulo+' = '+frmwebtef.dado_digitado,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);  // Salvar LOG - Se ativado
                                    CRetorno := ContinuaFuncaoMCInterativo(PAnsiChar(AnsiString(pergunta.ValorColetado))); // Enviar o dado coletado
                                    if CRetorno<>0 then // Houve um erro ao enviar o dado
                                       begin
                                          //------------------------------------
                                          frmwebtef.mensagem := SA_RetornoErro(CRetorno);
                                          SA_SalvarLog('ERRO ENVIAR DADO DA PERGUNTA ContinuaFuncaoMCInterativo',pergunta.Titulo+' = '+frmwebtef.dado_digitado + ' ' + frmwebtef.mensagem,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);  // Salvar LOG - Se ativado
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                          //------------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                                          while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                             begin
                                                sleep(50);
                                             end;
                                          sair := true;   // Ativar a saída do LOOP
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          //------------------------------------
                                       end;
                                    //------------------------------------------
                                 end
                               else
                                 sair := true;  // Coleta foi cancelado pelo operador, cancelar o TEF
                              //------------------------------------------------
                           end
                        else if acao=TPMultiPlusRETORNO then
                           begin
                              //------------------------------------------------
                              //   Confirmar a transação
                              //------------------------------------------------
                              RetornoTransacao := SA_SA_MultiPlusRetornoTransacao(SRetorno);
                              //------------------------------------------------
                              //   Fazer 3 tentativas de confirmação
                              //------------------------------------------------
                              finalizado              := false;
                              qtdetentativasfinalizar := 0;
                              while not finalizado do
                                 begin
                                    //------------------------------------------
                                    inc(qtdetentativasfinalizar);
                                    //------------------------------------------
                                    SA_SalvarLog('ENVIAR CONFIRMACAO CANCELAMENTO FinalizaFuncaoMCInterativo','NSU:'+RetornoTransacao.NSU+
                                                                                                 ' R$:'+vlTransformado+
                                                                                                 ' Parcela:'+LParcela.ToString+
                                                                                                 ' Cupom:'+LCupom.ToString+
                                                                                                 ' Data:'+formatdatetime('yyyyMMdd',date)+
                                                                                                 ' PDV:'+LPdv+
                                                                                                 ' Cod.Loja:'+LCodigoLoja+
                                                                                                 ' CNPJ:'+LCNPJ+' Tentativa Nr. '+qtdetentativasfinalizar.tostring,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);  // Salvar LOG - Se ativado
                                    try
                                        //--------------------------------------------
                                        // Enviando a confirmação da transação
                                        //--------------------------------------------
                                        CRetorno := FinalizaFuncaoMCInterativo(98,
                                                                               PAnsiChar(AnsiString(LCNPJ)),
                                                                               LParcela,
                                                                               PAnsiChar(AnsiString(LCupom.ToString)),
                                                                               PAnsiChar(AnsiString(vlTransformado)),
                                                                               PAnsiChar(AnsiString(RetornoTransacao.NSU)),
                                                                               PAnsiChar(AnsiString(formatdatetime('yyyyMMdd',LData))),
                                                                               PAnsiChar(AnsiString(LPdv)),
                                                                               PAnsiChar(AnsiString(LCodigoLoja)),
                                                                               0,
                                                                               '');
                                        //--------------------------------------------
                                        SA_SalvarLog('RETORNO ENVIAR CONFIRMACAO CANCELAMENTO FinalizaFuncaoMCInterativo',cretorno.ToString+' Retorno OK (função foi executada sem erros)',GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                                        //--------------------------------------------
                                    except on e:exception do
                                       begin
                                          SA_SalvarLog('ERRO ENVIAR CONFIRMACAO FinalizaFuncaoMCInterativo',e.Message,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                                       end;
                                    end;
                                    //------------------------------------------
                                    if (qtdetentativasfinalizar=3) or (CRetorno<>33) then
                                       finalizado := true;
                                    //------------------------------------------
                                 end;
                              //                              CRetorno := 0;
                              //------------------------------------------------
                              if CRetorno=0 then   // A confirmação da transação foi realizada com sucesso
                                 begin
                                    //------------------------------------------
                                    sair := true;
                                    //------------------------------------------
                                    //   Imprimir comprovante, processar a finalização do processo
                                    //------------------------------------------
                                    if RetornoTransacao.COMPROVANTE.Count>0 then // Existe comprovante a ser impresso
                                       begin
                                          //------------------------------------
                                          //******************************************
                                          //   Impressão do comprovante do cliente
                                          //******************************************
                                          //------------------------------------
                                          if LIComprovanteCliente=tpTEFImprimirSempre then  // Imprimir o comprovante automaticamente
                                             ImprimirComprovante := true
                                          else if LIComprovanteCliente=tpTEFPerguntar then  // Perguntar se quer imprimir o comprovante
                                             begin
                                                //------------------------------
                                                //   Perguntar se quer imprimir
                                                //------------------------------
                                                frmwebtef.mensagem := 'Imprimir o comprovante do CLIENTE ?';
                                                frmwebtef.opcoes   := TStringList.Create;
                                                frmwebtef.opcoes.Clear;
                                                frmwebtef.opcoes.Add('Imprimir');
                                                frmwebtef.opcoes.Add('Não Imprimir');
                                                frmwebtef.opcao    := -1;
                                                frmwebtef.tecla    := '';
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                                TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                                //------------------------------
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
                                                      //------------------------
                                                      sleep(50);
                                                   end;
                                                //------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                             end;
                                          //------------------------------------
                                          if ImprimirComprovante then
                                             SA_ImprimirTexto(RetornoTransacao.COMPROVANTE.Text,LImpressora);
                                          //------------------------------------
                                          //******************************************
                                          //   Impressão do comprovante da loja
                                          //******************************************
                                          //------------------------------------
                                          if LComprovanteLojaSimplificado then   // Criar um comprovante simplificado para imprimir no lugar daquele recebido da DLL
                                             RetornoTransacao.ComprovanteLoja.Text := SA_GerarComprovanteSimplificado(tpOpCancelamentoVenda).Text;  // Gerando o comprovante simplificado
                                          if LIComprovanteCliente=tpTEFImprimirSempre then  // Imprimir o comprovante automaticamente
                                             ImprimirComprovante := true
                                          else if LIComprovanteCliente=tpTEFPerguntar then  // Perguntar se quer imprimir o comprovante
                                             begin
                                                //------------------------------
                                                //   Perguntar se quer imprimir
                                                //------------------------------
                                                frmwebtef.mensagem := 'Imprimir o comprovante da LOJA ?';
                                                frmwebtef.opcoes   := TStringList.Create;
                                                frmwebtef.opcoes.Clear;
                                                frmwebtef.opcoes.Add('Imprimir');
                                                frmwebtef.opcoes.Add('Não Imprimir');
                                                frmwebtef.opcao    := -1;
                                                frmwebtef.tecla    := '';
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                                TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                                //------------------------------
                                                ImprimirComprovante := false;
                                                SairLoopImpressao   := false;
                                                while (not SairLoopImpressao) do  // Esperando o operador confirmar ou cancelar a impressão
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
                                                      //------------------------
                                                      sleep(50);
                                                   end;
                                                //------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                             end;
                                          //------------------------------------
                                          if ImprimirComprovante then
                                             SA_ImprimirTexto(RetornoTransacao.ComprovanteLoja.Text,LImpressora);
                                          //------------------------------------

                                       end;
                                 end
                              else   // Ocorreu um erro ao confirmar a transação
                                 begin
                                    //------------------------------------------
                                    //   Tratar a falha da confirmação
                                    //------------------------------------------
                                    frmwebtef.mensagem := SA_RetornoErro(CRetorno);
                                    SA_SalvarLog('ERRO ENVIAR CONFIRMACAO FinalizaFuncaoMCInterativo',CRetorno.ToString+' '+SA_RetornoErro(CRetorno),GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);  // Salvar LOG - Se ativado
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    //------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                                    while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                       begin
                                          sleep(50);
                                       end;
                                    sair := true;   // Ativar a saída do LOOP
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                           end;
                        //------------------------------------------------------
                     end;
                  //------------------------------------------------------------
               end;
            //------------------------------------------------------------------
         end
      else
         begin
            //------------------------------------------------------------------
            //  Ocorreu um erro
            //------------------------------------------------------------------
            CancelarFluxoMCInterativo;
            SA_SalvarLog('RESPOSTA REALIZAR CANCELAMENTO',SA_RetornoErro(IRetorno),GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
            frmwebtef.mensagem := SA_RetornoErro(IRetorno);
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
            while not frmwebtef.Cancelar do
               begin
                  sleep(50);
               end;
            TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
            //------------------------------------------------------------------
         end;
      //------------------------------------------------------------------------
      //   Fechando a janela do TEF
      //------------------------------------------------------------------------
      frmwebtef.Close;
      frmwebtef.Release;
      lExecutando := false;
      //------------------------------------------------------------------------


      //------------------------------------------------------------------------
   end).Start;
   //---------------------------------------------------------------------------
end;
procedure TMultiPlusTEF.SA_ConfigurarPinPad;
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

procedure TMultiPlusTEF.SA_CriarMenuT;
begin
   SA_Criar_Menu(true);
end;

procedure TMultiPlusTEF.SA_DesativarBtCancelarT;
begin
   SA_DesativarBTCancelar;
end;

procedure TMultiPlusTEF.SA_DesativarMenuT;
begin
   SA_Criar_Menu(false);
end;

//------------------------------------------------------------------------------
//   Extrair um campo de dentro da string do PIX com delimitador "|"
//------------------------------------------------------------------------------
function TMultiPlusTEF.SA_ExtraiCamporDadosPIX(Campo,  DadosPIX: string): string;
var
   posicao : integer;
begin
   //---------------------------------------------------------------------------
   // #NSU=297451687|ORIGEM=GERENCIANET|VALOR=1,25|QRCODE=00020101021226830014BR.GOV.BCB.PIX2561qrcodespix.sejaefi.com.br/v2/644a50911e914d8db93eec75d9bffdd75204000053039865802BR5905EFISA6008SAOPAULO62070503***63046283
   //   inicio=6 / fim = 15 => fim-inicio = 9
   //---------------------------------------------------------------------------
   DadosPIX := DadosPIX +'|';  // Incluindo um delimitador no final da string;
   //---------------------------------------------------------------------------
   Result := '';
   posicao := pos(campo+'=',DadosPIX)+length(campo);
   if posicao>0 then
      delete(DadosPIX,1,posicao);
   //---------------------------------------------------------------------------
   posicao := pos('|',DadosPIX)-1;
   if posicao>0 then
      Result := copy(DadosPIX,1,posicao);
   //---------------------------------------------------------------------------
end;

function TMultiPlusTEF.SA_ExtrairDadosPIX(DadosPIX: string): TMultiPlusDadosPix;
begin
   Result.NSU    := SA_ExtraiCamporDadosPIX('NSU',DadosPIX);
   Result.ORIGEM := SA_ExtraiCamporDadosPIX('ORIGEM',DadosPIX);
   Result.VALOR  := untransform(SA_ExtraiCamporDadosPIX('VALOR',DadosPIX));
   Result.QRCODE := SA_ExtraiCamporDadosPIX('QRCODE',DadosPIX);
end;

function TMultiPlusTEF.SA_FormatarRespostaPergunta(pergunta: TMultiPlusPergunta;  ValorColetado: string): string;
var
   VlInt     : integer;
   VlString  : string;
   VlDecimal : real;
   VlData    : TDate;
begin
   //---------------------------------------------------------------------------
   VlInt     := 0;
   VlString  := '';
   VlDecimal := 0;
   VlData    := strtodate('01/01/1800');
   //---------------------------------------------------------------------------
   // TMultiPlusTTipoDado = (TtpINT, TtpSTRING, TtpDECIMAL, TtpDATE , TtpINDEFINIDO);
   //---------------------------------------------------------------------------
   try
      case pergunta.Tipo of
        TtpINT        : VlInt     := strtoint(trim(ValorColetado));
        TtpSTRING     : VlString  := trim(ValorColetado);
        TtpDECIMAL    : VlDecimal := untransform(trim(ValorColetado));
        TtpDATE       : VlData    := StrToDate(trim(ValorColetado));
      end;
   except
      Result := '';
      exit;
   end;
   //---------------------------------------------------------------------------
   if pergunta.Tipo=TtpINT then
      Result := VlInt.ToString
   else if pergunta.Tipo=TtpSTRING then
      Result := VlString
   else if pergunta.Tipo=TtpDECIMAL then
      Result := FormatFloat('#####0,00',VlDecimal)
   else if pergunta.Tipo=TtpDATE then
      Result := formatdatetime('DD/MM/YY',VlData)
   else
      Result := ValorColetado;
   //---------------------------------------------------------------------------
end;

function TMultiPlusTEF.SA_GerarComprovanteSimplificado(Operacao : TpOperacaoMPL = tpOpVenda): TStringList;
begin
   Result := TStringList.Create;
   Result.Add('</ce>COMPROVANTE TEF - Via Lojista');
   Result.Add('</ae>');
   if Operacao=tpOpCancelamentoVenda then
      begin
         Result.Add('   CANCELAMENTO DE PAGAMENTO');
         Result.Add('   ');
      end;
   Result.Add('   Realizada em   '+formatdatetime('dd/mm/yyyy hh:mm:ss',now));
   Result.Add('       Valor R$   '+transform(LRetornoTransacao.VALOR));
   Result.Add('     Forma Pgto   '+LForma);
   Result.Add('            NSU   '+LRetornoTransacao.NSU);
   Result.Add('        Cod.Aut.  '+LRetornoTransacao.COD_AUTORIZACAO);
   Result.Add('       Bandeira   '+LRetornoTransacao.NOME_BANDEIRA);
end;

//------------------------------------------------------------------------------
//  Desmontar o retorno do MULTIPLUS
//------------------------------------------------------------------------------
procedure TMultiPlusTEF.SA_MostramensagemT;
begin
   SA_Mostrar_Mensagem(true);
end;

procedure TMultiPlusTEF.SA_MostrarBtCancelarT;
begin
   SA_AtivarBTCancelar;   // Ativar o botão cancelar na tela de TEF
end;

function TMultiPlusTEF.SA_MultiPlusTPRetorno( retorno: string): TPRetornoMultiPlus;
var
   fim     : integer;
   comando : string;
begin
   Result := TPMultiPlusINDEFINIDO;
   //---------------------------------------------------------------------------
   // [MENU]#MODO#1-MAGNETICO|2-DIGITADO
   // [MSG]#AGUARDE A SENHA
   // [PERGUNTA]#INFORME O NSU#INT#0#0#0,00#0,00#0
   // [RETORNO]#CAMPO0160=CUPOM#CAMPO0002=VALOR#CAMPO0132=COD BANDEIRA...
   // [ERROABORTAR]#CANCELADO PELO OPERADOR
   // [ERRODISPLAY]#T14-CARTAO INVALIDO
   //
   //  TPRetornoMultiPlus = (TPMultiPlusMENU , TPMultiPlusMSG , TPMultiPlusPERGUNTA , TPMultiPlusRETORNO , TPMultiPlusERROABORTAR , TPMultiPlusERRODISPLAY,TPMultiPlusINDEFINIDO);
   //---------------------------------------------------------------------------
   fim     := pos(']',retorno);
   comando := copy(retorno,1,fim);
   if comando='[MENU]' then
      Result := TPMultiPlusMENU
   else if comando='[MSG]' then
      Result := TPMultiPlusMSG
   else if comando='[PERGUNTA]' then
      Result := TPMultiPlusPERGUNTA
   else if comando='[RETORNO]' then
      Result := TPMultiPlusRETORNO
   else if comando='[ERROABORTAR]' then
      Result := TPMultiPlusERROABORTAR
   else if comando='[ERRODISPLAY]' then
      Result := TPMultiPlusERRODISPLAY;
   //---------------------------------------------------------------------------
end;

function TMultiPlusTEF.SA_PerguntarOpcoes(opcoes: TStringList;  mensagem: string): integer;
var
   sair : boolean;
begin
   Result             := -1;
   frmwebtef.opcao    := 0;
   frmwebtef.tecla    := '';
   frmwebtef.Cancelar := false;
   sair               := false;
   while not sair do
      begin
         //---------------------------------------------------------------------
         if frmwebtef.Cancelar then
            begin
               Result := -1;
               sair := true;
            end;

         if (frmwebtef.opcao<>0) then
            begin
               Result := frmwebtef.opcao;
               sair   := true;
            end;

         if (strtointdef(frmwebtef.tecla,256)<=opcoes.Count) and (strtointdef(frmwebtef.tecla,256)<>0) then
           begin
              Result := strtointdef(frmwebtef.tecla,-1);
              sair   := true;
           end;

         //---------------------------------------------------------------------
         if not sair then
            sleep(50);
         //---------------------------------------------------------------------
      end;
   //---------------------------------------------------------------------------
end;

function TMultiPlusTEF.SA_PINPAD_MostrarImagem(imagem: TPngImage): boolean;
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

procedure TMultiPlusTEF.SA_PintarPix(QRCode: string);
var
   png    : TPngImage;
   qrsize : Integer;
begin
   //---------------------------------------------------------------------------
   try
      PintarQRCode(QRCode, frmwebtef.logomp.Picture.Bitmap, qrUTF8BOM);
   except on e:exception do
      begin
         SA_SalvarLog('ERRO PINTAR PIX NA TELA',e.Message,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      end
   end;
   //---------------------------------------------------------------------------
   if SA_UsarPinpad then
      begin
         try
            SA_ConfigurarPinPad;
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
               SA_SalvarLog('ERRO PINTAR PIX NA NO PINPAD',e.Message,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
            end

         end;
      end;
   //---------------------------------------------------------------------------
end;

procedure TMultiPlusTEF.SA_ProcessarPagamento;
var
   //---------------------------------------------------------------------------
   IRetorno            : integer;    // Retorno da função que inicializa o TEF
   SRetorno            : widestring; // Retorno da função que faz a transação com o TEF
   FRetorno            : integer;    // Retorno para monitorar o encerramento do modo interativo
   CRetorno            : integer;    // Retorno da função que envia um dado para a DLL durante o processo de coleta
   opcaoColeta         : integer;    //  Quando selecionar uma opção do menu
   ImprimirComprovante : boolean;    // Para sinalizar se o comprovante será impresso ou não
   //---------------------------------------------------------------------------
   acao     : TPRetornoMultiPlus;
   Menu     : TMultiPlusMenu;
   Pergunta : TMultiPlusPergunta;
   //---------------------------------------------------------------------------
   sair                    : boolean;
   ConteudoInicial         : string;
   //---------------------------------------------------------------------------
   vlTransformado          : string;
   finalizado              : boolean;
   qtdetentativasfinalizar : integer;
   Resposta_pergunta       : string;
   Leitura_pergunta        : boolean;
   SairLoopImpressao       : boolean;
   //---------------------------------------------------------------------------
   RetornoMsg : string;   // Para processar a mensagem em caso de ser PIX
   DadosPix   : TMultiPlusDadosPix;
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   //   Iniciando a tela de TEF
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpTEFMultiPlus;
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
      frmwebtef.mensagem := 'Inicializando TEF...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      //------------------------------------------------------------------------
      vlTransformado := trim(FormatFloat('#####0.00',LValor));   // Formatando o valor para TEF
      vlTransformado := StringReplace(vlTransformado,'.',',',[]); // Substituindo o ponto decimal por vírgula
      if LParcela=0 then // Se a qtde parcelas for zero, transfromar para 1
         LParcela := 1;
      //------------------------------------------------------------------------
      SA_SalvarLog('REALIZAR PAGAMENTO',
                                        'R$:'+vlTransformado+
                                        ' FORMA Pgto.:'+LForma+
                                        ' NSU:'+LNSU+
                                        ' Cupom Nr.:'+LCupom.ToString+
                                        ' Tipo Cartao:'+SA_TpCartaoOperacaoTEFtoSTR(LTpOperacaoTEF)+
                                        ' Parcelas:'+LParcela.ToString,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);

      IRetorno := IniciaFuncaoMCInterativo(SA_TpCartaoOperacaoTEFtoINT(LTpOperacaoTEF),
                                           PAnsiChar(AnsiString(LCNPJ)),
                                           LParcela,
                                           PAnsiChar(AnsiString(LCupom.ToString)),
                                           PAnsiChar(AnsiString(vlTransformado)),
                                           PAnsiChar(AnsiString(LNSU)),
                                           PAnsiChar(AnsiString(formatdatetime('yyyyMMdd',LData))),
                                           PAnsiChar(AnsiString(LPdv)),
                                           PAnsiChar(AnsiString(LCodigoLoja)),
                                           0,
                                           '');
      //------------------------------------------------------------------------
      if IRetorno=0 then
         begin
            //------------------------------------------------------------------
            //  Sem ocorrência de erros, continuar o processo
            //------------------------------------------------------------------
            sair    := false;
            while not sair do
               begin
                  //------------------------------------------------------------
                  // Verificar se o operador cancelou a operação
                  //------------------------------------------------------------
                  if (frmwebtef.Cancelar) and (LTpOperacaoTEF in[tpMPlPIX, tpMPlPIXMercadoPago,tpMPlPIXPicPay]) then
                     begin
                        //------------------------------------------------------
                        TThread.Synchronize(TThread.CurrentThread,
                           procedure
                              begin
                                 frmwebtef.logomp.Picture.LoadFromFile(GetCurrentDir+'\icones\tef_mplpay.bmp');
                                 frmwebtef.logomp.Repaint;
                              end);
                        //------------------------------------------------------
                        SA_SalvarLog('REMOVER PAGAMENTO PIX',
                                                          'R$:'+vlTransformado+
                                                          ' FORMA Pgto.:'+LForma+
                                                          ' NSU:'+DadosPix.NSU+
                                                          ' Cupom Nr.:'+LCupom.ToString+
                                                          ' Tipo Cartao:'+SA_TpCartaoOperacaoTEFtoSTR(LTpOperacaoTEF)+
                                                          ' Parcelas:'+LParcela.ToString,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                        //------------------------------------------------------
                        FinalizaFuncaoMCInterativo(55,
                                                   PAnsiChar(AnsiString(LCNPJ)),
                                                   LParcela,
                                                   PAnsiChar(AnsiString(LCupom.ToString)),
                                                   PAnsiChar(AnsiString(vlTransformado)),
                                                   PAnsiChar(AnsiString(DadosPix.NSU)),
                                                   PAnsiChar(AnsiString(formatdatetime('yyyyMMdd',LData))),
                                                   PAnsiChar(AnsiString(LPdv)),
                                                   PAnsiChar(AnsiString(LCodigoLoja)),
                                                   0,
                                                   '');
                        //------------------------------------------------------
                     end;
                  //------------------------------------------------------------
                  //   Fazer fluxo de consulta do TEF
                  //------------------------------------------------------------
                  try
                     SRetorno := widestring(AguardaFuncaoMCInterativo());
                  except on e:exception do
                     begin
                        SA_SalvarLog('ERRO AguardaFuncaoMCInterativo',e.Message,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);  // Salvar LOG - Se ativado
                     end;
                  end;
                  if SRetorno<>'' then   // Se o retorno não é vazio, verificar que tipo de retorno
                     begin
                        //------------------------------------------------------
                        //  acao = TPRetornoMultiPlus e de acordo com o retorno deverá ser executado um processo
                        // TPRetornoMultiPlus = (TPMultiPlusMENU , TPMultiPlusMSG , TPMultiPlusPERGUNTA , TPMultiPlusRETORNO , TPMultiPlusERROABORTAR , TPMultiPlusERRODISPLAY,TPMultiPlusINDEFINIDO);
                        //------------------------------------------------------
                        SA_SalvarLog('RESPOSTA AguardaFuncaoMCInterativo',SRetorno,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);  // Salvar LOG - Se ativado
                        //------------------------------------------------------
                        acao     := SA_MultiPlusTPRetorno(SRetorno);
                        //------------------------------------------------------
                        if acao=TPMultiPlusMSG then // Somente mostrar uma mensagem na tela
                           begin
                              //------------------------------------------------
                              //  Mostrar a mensagem na tela
                              //------------------------------------------------
                              RetornoMsg := SA_SA_MultiPlusMensagemRetorno(SRetorno);
                              if (pos('NSU=',RetornoMsg)>0) and (pos('|ORIGEM=',RetornoMsg)>0) and (pos('|QRCODE=',RetornoMsg)>0) then
                                 begin
                                    DadosPix := SA_ExtrairDadosPIX(RetornoMsg);
                                    SA_SalvarLog('QRCODE OBTIDO',DadosPix.QRCODE,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);  // Salvar LOG - Se ativado
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                                    TThread.Synchronize(TThread.CurrentThread,
                                       procedure
                                          begin
                                             frmwebtef.logomp.Stretch      := true;
                                             frmwebtef.logomp.Proportional := true;
                                             SA_PintarPix(DadosPix.QRCODE);
                                          end);
                                    frmwebtef.mensagem := 'PIX => NSU: '+DadosPix.NSU+' ORIGEM:'+DadosPix.ORIGEM+' Valor:'+trim(transform(DadosPix.VALOR));
                                 end
                              else
                                 frmwebtef.mensagem := RetornoMsg;
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              //------------------------------------------------
                           end
                        else if (acao=TPMultiPlusERROABORTAR) or (acao=TPMultiPlusERRODISPLAY) then // Somente mostrar uma mensagem na tela e encerrar o processo
                           begin
                              //------------------------------------------------
                              //   Ocorreu um evento que provocou o encerramento do processo (Abortar é apoiar o LULA)
                              //------------------------------------------------
                              frmwebtef.mensagem := SA_SA_MultiPlusMensagemRetorno(SRetorno);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                              while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                 begin
                                    sleep(50);
                                 end;
                              sair := true;   // Ativar a saída do LOOP
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                           end
                        else if acao=TPMultiPlusMENU then  // Deverá ser apresentado um menu de opções
                           begin
                              //------------------------------------------------
                              //  Criar um menu de opções para o operador escolher
                              //------------------------------------------------
                              Menu     := SA_SA_MultiPlusOpcoesMenuRetorno(SRetorno);
                              SRetorno := '';
                              acao     := TPMultiPlusINDEFINIDO;
                              //------------------------------------------------
                              frmwebtef.mensagem := menu.Titulo;
                              frmwebtef.opcoes   := menu.Opcoes;
                              frmwebtef.opcao    := -1;
                              frmwebtef.tecla    := '';
                              frmwebtef.Cancelar := false;
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                              TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                              //------------------------------------------------
                              application.ProcessMessages;
                              opcaoColeta  := SA_PerguntarOpcoes(menu.Opcoes,menu.Titulo);
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                              if opcaoColeta<>-1 then
                                 begin
                                    //------------------------------------------
                                    //   Enviar a coleta do item do menu para a DLL
                                    //------------------------------------------
                                    SA_SalvarLog('ENVIAR OPCAO MENU ContinuaFuncaoMCInterativo',pergunta.Titulo+' = '+opcaoColeta.ToString,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);  // Salvar LOG - Se ativado
                                    CRetorno := ContinuaFuncaoMCInterativo(PAnsiChar(AnsiString(opcaoColeta.ToString)));
                                    if CRetorno<>0 then // Houve um erro ao enviar o dado
                                       begin
                                          //------------------------------------
                                          frmwebtef.mensagem := SA_RetornoErro(CRetorno);
                                          SA_SalvarLog('ERRO ENVIAR OPCAO MENU ContinuaFuncaoMCInterativo',CRetorno.ToString+' '+frmwebtef.mensagem,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);  // Salvar LOG - Se ativado
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                          //------------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                                          while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                             begin
                                                sleep(50);
                                             end;
                                          sair := true;   // Ativar a saída do LOOP
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          //------------------------------------
                                       end;
                                    //------------------------------------------
                                 end
                              else
                                 begin
                                    sair := true;   // Ativar a saída do LOOP, o operador desistiu de responder e cancelou a operação

                                 end;
                              //------------------------------------------------
                           end
                        else if acao=TPMultiPlusPERGUNTA then  // Deverá ser perguntado algo
                           begin
                              //------------------------------------------------
                              //  Fazer uma pergunta ao operador
                              //------------------------------------------------
                              Pergunta := SA_SA_MultiPlusPerguntaRetorno(SRetorno);
                              //---------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,
                               procedure
                                  begin
                                     if pergunta.Tipo=TtpDATE then  // Se o tipo é data, o valor inicial é adata atual
                                        ConteudoInicial := FormatDateTime('dd/mm/yyyy',date);
                                     SA_ColetarValor(pergunta.Titulo,pergunta.mascara,false,ConteudoInicial);
                                  end);
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              frmwebtef.AceitaVazio   := true;
                              Resposta_pergunta       := '';
                              Leitura_pergunta        := true;
                              //------------------------------------------------
                              while Leitura_pergunta do
                                 begin
                                    //------------------------------------------
                                    sleep(10);
                                    //------------------------------------------
                                    if (frmwebtef.dado_digitado<>'') and (not frmwebtef.Cancelar) then
                                       begin
                                          Resposta_pergunta := frmwebtef.dado_digitado;
                                          Leitura_pergunta  := not SA_ValidarRespostaPergunta(pergunta,Resposta_pergunta);
                                       end
                                    else if frmwebtef.Cancelar then
                                       begin
                                         Leitura_pergunta  := false;
                                         Resposta_pergunta := '';
                                       end;
                                    if (frmwebtef.dado_digitado<>'') and (not SA_ValidarRespostaPergunta(pergunta,frmwebtef.dado_digitado)) then
                                       begin
                                          frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                          frmwebtef.pnalerta.Color        := clRed;
                                          frmwebtef.pnalerta.Font.Color   := clYellow;
                                          frmwebtef.dado_digitado         := '';
                                       end;
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                              frmwebtef.pncaptura.Visible := false;
                              frmwebtef.edtdado.Enabled   := false;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                              if Resposta_pergunta='&*&' then
                                 Resposta_pergunta := '';

                              if not frmwebtef.Cancelar then
                                 begin
                                    pergunta.ValorColetado := SA_FormatarRespostaPergunta(pergunta,Resposta_pergunta);  // Formatar o dado coletado para enviar para a DLL
                                    SA_SalvarLog('ENVIAR DADO DA PERGUNTA ContinuaFuncaoMCInterativo',pergunta.Titulo+' = '+pergunta.ValorColetado,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);  // Salvar LOG - Se ativado
                                    CRetorno := ContinuaFuncaoMCInterativo(PAnsiChar(AnsiString(pergunta.ValorColetado))); // Enviar o dado coletado
                                    if CRetorno<>0 then // Houve um erro ao enviar o dado
                                       begin
                                          //------------------------------------
                                          frmwebtef.mensagem := SA_RetornoErro(CRetorno);
                                          SA_SalvarLog('ERRO ENVIAR DADO DA PERGUNTA ContinuaFuncaoMCInterativo',pergunta.Titulo+' = '+frmwebtef.dado_digitado + ' ' + frmwebtef.mensagem,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);  // Salvar LOG - Se ativado
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                          //------------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                                          while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                             begin
                                                sleep(50);
                                             end;
                                          sair := true;   // Ativar a saída do LOOP
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          //------------------------------------
                                       end;
                                    //------------------------------------------
                                 end
                               else
                                 sair := true;  // Coleta foi cancelado pelo operador, cancelar o TEF
                              //------------------------------------------------

                           end
                        else if (acao=TPMultiPlusRETORNO) and (not (LTpOperacaoTEF in[tpMPlPIX, tpMPlPIXMercadoPago,tpMPlPIXPicPay])) or ((LTpOperacaoTEF in[tpMPlPIX, tpMPlPIXMercadoPago,tpMPlPIXPicPay]) and (pos('|STATUS=REMOVIDA',string(SRetorno))=0) )  then
                           begin
                              //------------------------------------------------
                              //   Confirmar a transação
                              //------------------------------------------------
                              RetornoTransacao := SA_SA_MultiPlusRetornoTransacao(SRetorno);
                              //------------------------------------------------
                              //   Fazer 3 tentativas de confirmação
                              //------------------------------------------------
                              finalizado              := false;
                              qtdetentativasfinalizar := 0;
                              while not finalizado do
                                 begin
                                    //------------------------------------------
                                    inc(qtdetentativasfinalizar);
                                    //------------------------------------------
                                    SA_SalvarLog('ENVIAR CONFIRMACAO FinalizaFuncaoMCInterativo','NSU:'+RetornoTransacao.NSU+
                                                                                                 ' R$:'+vlTransformado+
                                                                                                 ' Parcela:'+LParcela.ToString+
                                                                                                 ' Cupom:'+LCupom.ToString+
                                                                                                 ' Data:'+formatdatetime('yyyyMMdd',date)+
                                                                                                 ' PDV:'+LPdv+
                                                                                                 ' Cod.Loja:'+LCodigoLoja+
                                                                                                 ' CNPJ:'+LCNPJ+' Tentativa Nr. '+qtdetentativasfinalizar.tostring,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);  // Salvar LOG - Se ativado
                                    try
                                        //--------------------------------------------
                                        // Enviando a confirmação da transação
                                        //--------------------------------------------
                                        CRetorno := FinalizaFuncaoMCInterativo(98,                                                        // iComando: Integer;
                                                                               PAnsiChar(AnsiString(LCNPJ)),
                                                                               LParcela,
                                                                               PAnsiChar(AnsiString(LCupom.ToString)),
                                                                               PAnsiChar(AnsiString(vlTransformado)),
                                                                               PAnsiChar(AnsiString(RetornoTransacao.NSU)),
                                                                               PAnsiChar(AnsiString(formatdatetime('yyyyMMdd',LData))),
                                                                               PAnsiChar(AnsiString(LPdv)),
                                                                               PAnsiChar(AnsiString(LCodigoLoja)),
                                                                               0,
                                                                               '');
                                        //--------------------------------------------
                                        SA_SalvarLog('RETORNO ENVIAR CONFIRMACAO FinalizaFuncaoMCInterativo',cretorno.ToString+' Retorno OK (função foi executada sem erros)',GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                                        //--------------------------------------------
                                    except on e:exception do
                                       begin
                                          SA_SalvarLog('ERRO ENVIAR CONFIRMACAO FinalizaFuncaoMCInterativo',e.Message,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                                       end;
                                    end;
                                    //------------------------------------------
                                    if (qtdetentativasfinalizar=3) or (CRetorno<>33) then
                                       finalizado := true;

                                    //------------------------------------------
                                 end;
                              //                              CRetorno := 0;
                              //------------------------------------------------
                              if CRetorno=0 then   // A confirmação da transação foi realizada com sucesso
                                 begin
                                    //------------------------------------------
                                    sair := true;
                                    //------------------------------------------
                                    //   Imprimir comprovante, processar a finalização do processo
                                    //------------------------------------------
                                    if RetornoTransacao.COMPROVANTE.Count>0 then // Existe comprovante a ser impresso
                                       begin
                                          //------------------------------------
                                          //******************************************
                                          //   Impressão do comprovante do cliente
                                          //******************************************
                                          //------------------------------------
                                          if LIComprovanteCliente=tpTEFImprimirSempre then  // Imprimir o comprovante automaticamente
                                             ImprimirComprovante := true
                                          else if LIComprovanteCliente=tpTEFPerguntar then  // Perguntar se quer imprimir o comprovante
                                             begin
                                                //------------------------------
                                                //   Perguntar se quer imprimir
                                                //------------------------------
                                                frmwebtef.mensagem := 'Imprimir o comprovante do CLIENTE ?';
                                                frmwebtef.opcoes   := TStringList.Create;
                                                frmwebtef.opcoes.Clear;
                                                frmwebtef.opcoes.Add('Imprimir');
                                                frmwebtef.opcoes.Add('Não Imprimir');
                                                frmwebtef.opcao    := -1;
                                                frmwebtef.tecla    := '';
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                                TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                                //------------------------------
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
                                                      //------------------------
                                                      sleep(50);
                                                   end;
                                                //------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                             end;
                                          //------------------------------------
                                          if ImprimirComprovante then
                                             SA_ImprimirTexto(RetornoTransacao.COMPROVANTE.Text,LImpressora);
                                          //------------------------------------
                                          //******************************************
                                          //   Impressão do comprovante da loja
                                          //******************************************
                                          //------------------------------------
                                          if LComprovanteLojaSimplificado then   // Criar um comprovante simplificado para imprimir no lugar daquele recebido da DLL
                                             RetornoTransacao.ComprovanteLoja.Text := SA_GerarComprovanteSimplificado.Text;  // Gerando o comprovante simplificado
                                          if LIComprovanteCliente=tpTEFImprimirSempre then  // Imprimir o comprovante automaticamente
                                             ImprimirComprovante := true
                                          else if LIComprovanteCliente=tpTEFPerguntar then  // Perguntar se quer imprimir o comprovante
                                             begin
                                                //------------------------------
                                                //   Perguntar se quer imprimir
                                                //------------------------------
                                                frmwebtef.mensagem := 'Imprimir o comprovante da LOJA ?';
                                                frmwebtef.opcoes   := TStringList.Create;
                                                frmwebtef.opcoes.Clear;
                                                frmwebtef.opcoes.Add('Imprimir');
                                                frmwebtef.opcoes.Add('Não Imprimir');
                                                frmwebtef.opcao    := -1;
                                                frmwebtef.tecla    := '';
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                                TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                                //------------------------------
                                                ImprimirComprovante := false;
                                                SairLoopImpressao   := false;
                                                while (not SairLoopImpressao) do  // Esperando o operador confirmar ou cancelar a impressão
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
                                                      //------------------------
                                                      sleep(50);
                                                   end;
                                                //------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                             end;
                                          //------------------------------------
                                          if ImprimirComprovante then
                                             SA_ImprimirTexto(RetornoTransacao.ComprovanteLoja.Text,LImpressora);
                                          //------------------------------------

                                       end;
                                 end
                              else   // Ocorreu um erro ao confirmar a transação
                                 begin
                                    //------------------------------------------
                                    //   Tratar a falha da confirmação
                                    //------------------------------------------
                                    frmwebtef.mensagem := SA_RetornoErro(CRetorno);
                                    SA_SalvarLog('ERRO ENVIAR CONFIRMACAO FinalizaFuncaoMCInterativo',CRetorno.ToString+' '+SA_RetornoErro(CRetorno),GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);  // Salvar LOG - Se ativado
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    //------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                                    while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                       begin
                                          sleep(50);
                                       end;
                                    sair := true;   // Ativar a saída do LOOP
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                              //------------------------------------------------
                           end
                        else if (acao=TPMultiPlusRETORNO) and ((LTpOperacaoTEF in[tpMPlPIX, tpMPlPIXMercadoPago,tpMPlPIXPicPay]))  then
                           begin
                              sair := true;   // Ativar a saída do LOOP
                           end;
                        //------------------------------------------------------
                     end;
                  //------------------------------------------------------------
               end;
            //------------------------------------------------------------------
            // Executar as funções que são necessárias após o processo ser encerrado
            //------------------------------------------------------------------
            if (acao=TPMultiPlusERROABORTAR) or (acao=TPMultiPlusERRODISPLAY) or ((acao=TPMultiPlusMENU) and (opcaoColeta=-1)) or ((acao=TPMultiPlusPERGUNTA) and (Resposta_pergunta='')) then
               begin
                  FRetorno := CancelarFluxoMCInterativo;
                  SA_SalvarLog('RESPOSTA CancelarFluxoMCInterativo',FRetorno.ToString+' = '+SA_RetornoErro(FRetorno),GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
               end;

            //------------------------------------------------------------------
         end
      else
         begin
            //------------------------------------------------------------------
            //  Ocorreu um erro
            //------------------------------------------------------------------
            CancelarFluxoMCInterativo;
            SA_SalvarLog('RESPOSTA REALIZAR PAGAMENTO',SA_RetornoErro(IRetorno),GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
            frmwebtef.mensagem := SA_RetornoErro(IRetorno);
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
            while not frmwebtef.Cancelar do
               begin
                  sleep(50);
               end;
            TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
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

function TMultiPlusTEF.SA_RetornoErro(codigo: integer): string;
begin
   case codigo of
      01:Result := 'Erro genérico na execução';
      30:Result := 'Não foi encontrado o caminho do ClientD.exe';
      31:Result := 'ConfigMC.ini está vazio';
      32:Result := 'ClientD.exe não encontrado';
      33:Result := 'ClientD.exe não está em execução';
      34:Result := 'Erro ao iniciar ClientD.exe';
      35:Result := 'Erro interno do ClientD.exe';
      36:Result := 'Erro interno do ClientD.exe';
      37:Result := 'Erro na leitura do arquivo ConfigMC.ini';
      38:Result := 'Valor da transação com formato incorreto';
      39:Result := 'Executável de envio de transações não encontrado';
      40:Result := 'CNPJ Inválido ou no formato incorreto';
      41:Result := 'ClientD.exe está em processo de atualização';
      42:Result := 'A automação não está sendo executada no modo administrador';
      43:Result := 'ClientD.exe está em execução devido a uma transação anterior';
      44:Result := 'Parâmetros ausentes em operação que utiliza o sParametro';
      45:Result := 'Parâmetros no formato incorreto em operação que utiliza o sParametro';
      46:Result := 'Erro ao identificar localização da DLL';
      47:Result := 'Não Foi encontrada a localização da DLL';
      48:Result := 'Não houve confirmação da conclusão da execução do ClientD';
      49:Result := 'Número de parcelas inválido';
   end;
end;

//------------------------------------------------------------------------------
//   Buscar um campo dentro da TAG
//------------------------------------------------------------------------------
function TMultiPlusTEF.SA_SA_MultiPlusBuscarCampo(campo,  retorno: string): string;
var
   posicao : integer;
begin
   //---------------------------------------------------------------------------
   posicao := pos(campo,retorno)+10;
   //---------------------------------------------------------------------------
   if posicao=0 then
      begin
         Result := '';
         exit;
      end;
   //---------------------------------------------------------------------------
   while (retorno[posicao]<>'#') and (posicao<length(retorno)) do
      begin
         Result := Result + retorno[posicao];
         inc(posicao);
      end;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
//   Buscar a mensagem do retorno
//------------------------------------------------------------------------------
function TMultiPlusTEF.SA_SA_MultiPlusMensagemRetorno(retorno: string): string;
var
   inicio : integer;
begin
   //---------------------------------------------------------------------------
   // [MSG]#AGUARDE A SENHA
   // [ERROABORTAR]#CANCELADO PELO OPERADOR
   // [ERRODISPLAY]#T14-CARTAO INVALIDO
   //---------------------------------------------------------------------------
   inicio := pos(']#',retorno);
   delete(retorno,1,inicio+1);
   Result := trim(retorno);
end;

//------------------------------------------------------------------------------
//   Desmontar itens para o MENU MULTIPLUS
//------------------------------------------------------------------------------
function TMultiPlusTEF.SA_SA_MultiPlusOpcoesMenuRetorno(retorno: string): TMultiPlusMenu;
var
   inicio : integer;
   opcao  : string;
begin
   //---------------------------------------------------------------------------
   // [MENU]#MODO#1-MAGNETICO|2-DIGITADO
   //---------------------------------------------------------------------------
   Result.Titulo := 'Selecione a Opção';
   Result.Opcoes := TStringList.Create;
   inicio  := pos('#',retorno);
   retorno := copy(retorno,inicio+1,length(retorno)-inicio);
   inicio  := pos('#',retorno);
   Result.Titulo := copy(retorno,1,inicio-1);
   retorno := copy(retorno,inicio+1,length(retorno)-inicio);
   //---------------------------------------------------------------------------
   while pos('|',retorno)>0 do
      begin
         inicio := pos('|',retorno);
         opcao  := copy(retorno,1,inicio-1);;
         if trim(opcao)<>'' then
            begin
               Result.Opcoes.Add(opcao);
               opcao := '';
               retorno := copy(retorno,inicio+1,length(retorno)-inicio);
            end;
      end;
   if trim(retorno)<>'' then
      Result.Opcoes.Add(trim(retorno));
   //---------------------------------------------------------------------------
end;

//------------------------------------------------------------------------------
//   Desmontar o retorno para o tipo PERGUNTA
//------------------------------------------------------------------------------
function TMultiPlusTEF.SA_SA_MultiPlusPerguntaRetorno( retorno: string): TMultiPlusPergunta;
var
   inicio     : integer;
   informacao : string;
begin
   //---------------------------------------------------------------------------
   // [PERGUNTA]#INFORME O NSU#INT#0#0#0,00#0,00#0
   // [PERGUNTA]#TITULO#TIPO DE DADO#TAMANHO MINIMO#TAMANHO MAXIMO#VALOR MINIMO#VALOR MAXIMO#CASAS DECIMAIS
   //---------------------------------------------------------------------------
   //   Yítulo
   //---------------------------------------------------------------------------
   delete(retorno,1,11);
   inicio        := pos('#',retorno);
   Result.Titulo := copy(retorno,1,inicio-1);  // Pegando o título da pergunta
   delete(retorno,1,inicio);
   //---------------------------------------------------------------------------
   //   Tipo de dado
   //---------------------------------------------------------------------------
   inicio        := pos('#',retorno);
   informacao    := copy(retorno,1,inicio-1);
   Result.Tipo   := SA_SA_MultiPlusTipoDado(informacao); // Tipo de dado
   delete(retorno,1,inicio);
   //---------------------------------------------------------------------------
   //   Tamanho mínimo
   //---------------------------------------------------------------------------
   inicio               := pos('#',retorno);
   informacao           := copy(retorno,1,inicio-1);
   Result.TamanhoMinimo := strtointdef(informacao,1);  // Tamanho mínimo
   delete(retorno,1,inicio);
   //---------------------------------------------------------------------------
   //  Tamanho máximo
   //---------------------------------------------------------------------------
   inicio               := pos('#',retorno);
   informacao           := copy(retorno,1,inicio-1);
   Result.TamanhoMaximo := strtointdef(informacao,50);
   delete(retorno,1,inicio);
   //---------------------------------------------------------------------------
   //  Valor minimo
   //---------------------------------------------------------------------------
   inicio               := pos('#',retorno);
   informacao           := copy(retorno,1,inicio-1);
   Result.VlMinimo      := trim(informacao);
   delete(retorno,1,inicio);
   //---------------------------------------------------------------------------
   //  Valor máximo
   //---------------------------------------------------------------------------
   inicio               := pos('#',retorno);
   informacao           := copy(retorno,1,inicio-1);
   Result.VlMaximo      := trim(informacao);
   delete(retorno,1,inicio);
   //---------------------------------------------------------------------------
   //   Casas decimais
   //---------------------------------------------------------------------------
   Result.CasasDecimais      := strtointdef(retorno,2);
   //---------------------------------------------------------------------------
   case Result.Tipo of
     TtpINT        : Result.Mascara := StringofChar('9', Result.TamanhoMaximo );
     TtpSTRING     : Result.Mascara := StringofChar('a', Result.TamanhoMaximo );
     TtpDECIMAL    : Result.Mascara := '####0,'+StringofChar('0', Result.CasasDecimais );
     TtpDATE       : Result.Mascara := '99/99/9999' ;
     TtpINDEFINIDO : Result.Mascara := '';
   end;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
//   Buscar a mensagem do retorno
//------------------------------------------------------------------------------
function TMultiPlusTEF.SA_SA_MultiPlusRetornoTransacao(  retorno: string): TMultiPlusRetornoTransacao;
var
   comprovante : string;
begin
   //---------------------------------------------------------------------------
   Result.OperacaoExecutada  := false;
   Result.COMPROVANTE        := TStringList.Create;
   Result.ComprovanteLoja    := TStringList.Create;
   if retorno='' then
      exit;
   //---------------------------------------------------------------------------
   //  Número Cupom
   //---------------------------------------------------------------------------
   Result.CUPOM               := SA_SA_MultiPlusBuscarCampo('CAMPO0160',retorno);                //  Número Cupom
   Result.VALOR               := untransform(SA_SA_MultiPlusBuscarCampo('CAMPO0002',retorno));   //  Valor da operação
   Result.COD_BANDEIRA        := SA_SA_MultiPlusBuscarCampo('CAMPO0132',retorno);                //  Código da bandeira
   Result.COD_REDE            := SA_SA_MultiPlusBuscarCampo('CAMPO0131',retorno);                //  Código da rede
   Result.COD_AUTORIZACAO     := SA_SA_MultiPlusBuscarCampo('CAMPO0135',retorno);                //  Código de autorização
   Result.NSU                 := SA_SA_MultiPlusBuscarCampo('CAMPO0133',retorno);                //  NSU
   Result.QTDE_PARCELAS       := strtointdef(SA_SA_MultiPlusBuscarCampo('CAMPO0505',retorno),1); //  Qtde de Parcelas
   Result.TAXA_SERVICO        := untransform(SA_SA_MultiPlusBuscarCampo('CAMPO0504',retorno));   //  Taxa de serviço
   Result.BIN_CARTAO          := SA_SA_MultiPlusBuscarCampo('CAMPO0136',retorno);                //  BIN do cartão
   Result.ULT_DIGITOS_CARTAO  := SA_SA_MultiPlusBuscarCampo('CAMPO1190',retorno);                //  Ultimos dígitos do cartão
   Result.CNPJ_AUTORIZADORA   := SA_SA_MultiPlusBuscarCampo('CAMPO0950',retorno);                //  CNPJ da autorizadora
   Result.NOME_CLIENTE        := SA_SA_MultiPlusBuscarCampo('CAMPO1003',retorno);                //  Nome do cliente
   Result.NSU_REDE            := SA_SA_MultiPlusBuscarCampo('CAMPO0134',retorno);                //  NSU da Rede
   Result.VENCTO_CARTAO       := SA_SA_MultiPlusBuscarCampo('CAMPO0513',retorno);                //  Vencimento do cartão
   comprovante                := SA_SA_MultiPlusBuscarCampo('CAMPO122',retorno);                 //  Comprovante
   Result.VIAS_COMPROVANTE    := strtointdef(SA_SA_MultiPlusBuscarCampo('CAMPO0003',retorno),1); // Qtde vias comprovante
   Result.NOME_BANDEIRA       := SA_SA_MultiPlusBuscarCampo('CAMPO9999',retorno);                // Nome da bandeira
   Result.NOME_REDE           := SA_SA_MultiPlusBuscarCampo('CAMPO9998',retorno);                // Nome da Rede
   if SA_SA_MultiPlusBuscarCampo('CAMPO4221',retorno)='S' then                                   // Cartão pré pago
      Result.CARTAO_PRE_PAGO  := true
   else
      Result.CARTAO_PRE_PAGO  := false;
   Result.COD_TIPO_TRANSACAO  := SA_SA_MultiPlusBuscarCampo('CAMPO0100',retorno);                // Código do tipo de transação
   Result.DESC_TRANSACAO      := SA_SA_MultiPlusBuscarCampo('CAMPO0101',retorno);                // Descrição do tipo da transação
   Result.E2E                 := SA_SA_MultiPlusBuscarCampo('CAMPO2620',retorno);                // E2E - ID da transação
   Result.Data                := LData;
   Result.Hora                := LHora;
   //---------------------------------------------------------------------------
   if comprovante<>'' then
      begin
         Result.OperacaoExecutada    := true;
         comprovante                 := StringReplace(comprovante,'CORTAR','| |',[rfReplaceAll, rfIgnoreCase]);
         Result.COMPROVANTE.Text     := StringReplace(comprovante,'|',#13,[rfReplaceAll, rfIgnoreCase]);
         Result.ComprovanteLoja.Text := Result.COMPROVANTE.Text;
      end;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
//   Retornar qual o tipo de dado
//------------------------------------------------------------------------------
function TMultiPlusTEF.SA_SA_MultiPlusTipoDado(  dado: string): TMultiPlusTTipoDado;
begin
   //---------------------------------------------------------------------------
   Result := TtpINDEFINIDO;
   if trim(dado)='' then   // Se o tipo de dado é vazio
      exit;
   //---------------------------------------------------------------------------
   // TMultiPlusTTipoDado = (TtpINT, TtpSTRING, TtpDECIMAL, TtpDATE , TtpINDEFINIDO);
   // ('INT', 'STRING', 'DECIMAL', 'DATE');
   //---------------------------------------------------------------------------
   if uppercase(dado)='INT' then
      Result := TtpINT
   else if uppercase(dado)='STRING' then
      Result := TtpSTRING
   else if uppercase(dado)='DECIMAL' then
      Result := TtpDECIMAL
   else if uppercase(dado)='DATE' then
      Result := TtpDATE;
   //---------------------------------------------------------------------------
end;


function TMultiPlusTEF.SA_TpCartaoOperacaoTEFtoINT(tipoCartao: TtpMultiplusFormaPgto): integer;
begin
   //---------------------------------------------------------------------------
   //  Tipos de operação com ccartões TEF
   //   0 - Crédito a vista / 1 - Credito / 2 - Crédito parcelado Loja / 3 - Crédito parcelado ADM / 4 - Débito
   //   11 - Frota / 18 - Voucher
   //   20 - Débito a vista
   //   51 - PIX PSP cliente / 52 - PIX Mercado Pago / 53 - PIX PicPay
   //---------------------------------------------------------------------------
   Result := 99;
   case tipoCartao of
     tpMPlCreditoVista          : Result := 0;
     tpMPlcreditoPerguntar      : Result := 1;
     tpMPlCreditoaParceladoLoja : Result := 2;
     tpMPlCreditoParceladoADM   : Result := 3;
     tpMPlDebitoPerguntar       : Result := 4;
     tpMPlFrota                 : Result := 11;
     tpMPlDebitoVista           : Result := 20;
     tpMPlVoucher               : Result := 18;
     tpMPlPIX                   : Result := 51;
     tpMPlPIXMercadoPago        : Result := 52;
     tpMPlPIXPicPay             : Result := 53;
   end;
   //---------------------------------------------------------------------------
end;

function TMultiPlusTEF.SA_TpCartaoOperacaoTEFtoSTR(tipoCartao: TtpMultiplusFormaPgto): string;
begin
   case tipoCartao of
     tpMPlCreditoVista          : Result := 'Credito a vista';
     tpMPlcreditoPerguntar      : Result := 'Credito';
     tpMPlCreditoaParceladoLoja : Result := 'Credito Parcelado Lojista';
     tpMPlCreditoParceladoADM   : Result := 'Credito Parcelado Administradora';
     tpMPlDebitoPerguntar       : Result := 'Debito';
     tpMPlFrota                 : Result := 'Frota';
     tpMPlDebitoVista           : Result := 'Debito a Vista';
     tpMPlVoucher               : Result := 'Voucher';
     tpMPlPIX                   : Result := 'PIX';
     tpMPlPIXMercadoPago        : Result := 'PIX Mercado Pago';
     tpMPlPIXPicPay             : Result := 'Pic Pay';
   end;
end;


function TMultiPlusTEF.SA_UsarPinpad: boolean;
begin
   Result := ConfigPinPad.PINPAD_Porta<>'';
end;

function TMultiPlusTEF.SA_ValidarRespostaPergunta(Pergunta: TMultiPlusPergunta;  ValorColetado: string): boolean;
var
   VlInt     : integer;
   VlString  : string;
   VlDecimal : real;
begin
   //---------------------------------------------------------------------------
   VlInt     := 0;
   VlString  := '';
   VlDecimal := 0;
   //---------------------------------------------------------------------------
   // TMultiPlusTTipoDado = (TtpINT, TtpSTRING, TtpDECIMAL, TtpDATE , TtpINDEFINIDO);
   //---------------------------------------------------------------------------
   try
      case pergunta.Tipo of
        TtpINT        : VlInt     := strtoint(trim(ValorColetado));
        TtpSTRING     : VlString  := trim(ValorColetado);
        TtpDECIMAL    : VlDecimal := untransform(trim(ValorColetado));
      end;
   except
      Result := false;
      exit;
   end;
   //---------------------------------------------------------------------------
   try
      if pergunta.Tipo=TtpINT then
         Result := (VlInt>=untransform(Pergunta.VlMinimo)) and (VlInt<=untransform(Pergunta.VlMaximo))
      else if pergunta.Tipo=TtpSTRING then
         Result := (length(VlString)>=Pergunta.TamanhoMinimo) and (length(VlString)<=Pergunta.TamanhoMaximo)
      else if pergunta.Tipo=TtpDECIMAL then
         Result := (VlDecimal>=untransform(Pergunta.VlMinimo)) and (VlDecimal<=untransform(Pergunta.VlMaximo))
      else
         Result := true;
   except on e:exception do
      begin
         Result := false;
         SA_SalvarLog('ERRO VALIDACAO DO TIPO DE DADO',e.Message,GetCurrentDir+'\TEF_Log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      end;
   end;
   //---------------------------------------------------------------------------
end;

end.
