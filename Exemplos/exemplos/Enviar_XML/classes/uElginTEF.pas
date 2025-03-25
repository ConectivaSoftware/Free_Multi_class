unit uElginTEF;

interface

uses
   ACBrPosPrinter,
   ACBrImage,
   ACBrDelphiZXingQRCode,
   uKSTypes,
   TypInfo,
   vcl.forms,
   Vcl.Graphics,
   System.JSON,
   uMulticlassFuncoes,
   System.SysUtils,
   system.DateUtils,
   system.Classes,
   Winapi.Windows,
   uwebtefmp;

const
  CDLLTef = 'E1_Tef01.dll';

type
   //---------------------------------------------------------------------------
   TtpComprovante        = (tpLoja, tpCliente);
   TtpOperacaoADM        = (tpOpPerguntar , tpOpCancelamento , tpOpPendencias , tpOpReimpressao);
   //---------------------------------------------------------------------------
   TTefRetorno = record
      automacao_coleta_opcao           : string;
      automacao_coleta_palavra_chave   : string;
      automacao_coleta_retorno         : string;
      automacao_coleta_sequencial      : string;
      automacao_coleta_tipo            : string;
      automacao_coleta_mascara         : string;
      mensagemResultado                : string;
      //------------------------------------------------------------------------
      cnpjCredenciadora                : string;
      codigoAutorizacao                : string;
      comprovanteDiferenciadoLoja      : string;
      comprovanteDiferenciadoPortador  : string;
      dataHoraTransacao                : string;
      formaPagamento                   : string;
      identificadorEstabelecimento     : string;
      identificadorPontoCaptura        : string;
      loja                             : string;
      nomeBandeira                     : string;
      nomeEstabelecimento              : string;
      nomeProduto                      : string;
      nomeProvedor                     : string;
      nsuTerminal                      : string;
      nsuTransacao                     : string;
      panMascarado                     : string;
      resultadoTransacao               : string;
      retorno                          : string;
      sequencial                       : string;
      servico                          : string;
      tipoCartao                       : string;
      transacao                        : string;
      uniqueID                         : string;
      valorTotal                       : string;
      linhasMensagemRetorno            : TStringList;
   end;
   //---------------------------------------------------------------------------
   TElginTEF = class
   private
      //------------------------------------------------------------------------
      LImpressora : TKSConfigImpressora;  // Configuração da impressora
      //------------------------------------------------------------------------
      LTEFTextoPinPad      : string;
      LTEFSistema          : string;
      LTEFSistemaVersao    : string;
      LTEFEstabelecimento  : string;
      LTEFLoja             : string;
      LTEFTerminal         : string;
      LTEFIdCliente        : string;
      LtpOperacaoADM       : TtpOperacaoADM;
      LComprovanteLoja     : TtpTEFImpressao;
      LComprovanteCliente  : TtpTEFImpressao;
      LViaLojaSimplificada : boolean;
      LEstornado           : boolean;
      //------------------------------------------------------------------------
      //   Cancelamento
      //------------------------------------------------------------------------
      LCancelarNSU        : string;
      LCancelarData       : TDate;
      LCancelarValor      : real;
      //------------------------------------------------------------------------
      LSalvarLog          : boolean;
      //------------------------------------------------------------------------
      LSequencial         : integer;
      //------------------------------------------------------------------------
      //  Dados da operação
      LForma                : string;
      LValor                : real;
      LFormaPgto            : TtpElginFormaPgto;
      TpComprovanteImprimir : TtpComprovante;
      LQtdeParcelas         : integer;
      //------------------------------------------------------------------------
      LExecutando           : boolean;
      LdataHoraTransacao    : string;
      //------------------------------------------------------------------------
      LRetornoTEF  : TRetornoPagamentoTEF;      // Retorno do pagamento TEF
      //------------------------------------------------------------------------
      function SA_tpOperacaoADMToInt(tipo:ttpOperacaoADM):integer;
      function SA_ParsingTEF(conteudo : string):TTefRetorno;
      function SA_Opcoes(opcoes:string):TStringList;
      function SA_RecuperarLinhasMensagem(mensagem:string):TStringList;
      function SA_ResumirComprovante(texto:TStringList):TStringList;
      function SA_GerarComprovanteSimplificado:TStringList;
      function SA_DefinirPagamentoELGIN(FormaPgto:TtpElginFormaPgto):TPagamentoELGIN;
      //------------------------------------------------------------------------
      //  Sincronizações para thread
      procedure SA_MostramensagemT;
      procedure SA_MostrarBtCancelarT;
      procedure SA_DesativarBtCancelarT;
      procedure SA_CriarMenuT;
      procedure SA_DesativarMenuT;
      //------------------------------------------------------------------------
   public
      //------------------------------------------------------------------------
      constructor Create();
      //------------------------------------------------------------------------
      procedure SA_Configurar_TEF;
      function SA_Inicializar_TEF:boolean;
      //------------------------------------------------------------------------
      procedure SA_ProcessarPagamento;
      procedure SA_ImprimirComprovante(comprovante:TStringList;pergunta:string);
      function SA_PerguntarOpcoes(opcoes:TStringList;mensagem:string):integer;
      //------------------------------------------------------------------------
      procedure SA_Administrativo;
      procedure SA_AdmCancelamento;
      procedure SA_PagamentoPIX;
      //------------------------------------------------------------------------
      // Configurações
      property TEFTextoPinPad     : string              read LTEFTextoPinPad     write LTEFTextoPinPad;
      property TEFSistema         : string              read LTEFSistema         write LTEFSistema;
      property TEFSistemaVersao   : string              read LTEFSistemaVersao   write LTEFSistemaVersao;
      property TEFEstabelecimento : string              read LTEFEstabelecimento write LTEFEstabelecimento;
      property TEFLoja            : string              read LTEFLoja            write LTEFLoja;
      property TEFTerminal        : string              read LTEFTerminal        write LTEFTerminal;
      property TEFIdCliente       : string              read LTEFIdCliente       write LTEFIdCliente;
      property tpOperacaoADM      : TtpOperacaoADM      read LtpOperacaoADM      write LtpOperacaoADM;
      //------------------------------------------------------------------------
      property Impressora         : TKSConfigImpressora read LImpressora         write LImpressora;  // Configuração da impressora
      //------------------------------------------------------------------------
      property ComprovanteLoja    : TtpTEFImpressao     read LComprovanteLoja    write LComprovanteLoja;
      property ComprovanteCliente : TtpTEFImpressao     read LComprovanteCliente write LComprovanteCliente;
      //------------------------------------------------------------------------
      property SalvarLog          : boolean             read LSalvarLog          write LSalvarLog;
      //------------------------------------------------------------------------
      property Forma              : string              read LForma              write LForma;  // Forma de pagamento para exibir na tela do TEF
      property Valor              : real                read LValor              write LValor;    // Valor da transação
      property FormaPgto          : TtpElginFormaPgto   read LFormaPgto          write LFormaPgto;
      property QtdeParcelas       : integer             read LQtdeParcelas       write LQtdeParcelas;
      //------------------------------------------------------------------------
      property CancelarNSU        : string              read LCancelarNSU        write LCancelarNSU;
      property CancelarData       : TDate               read LCancelarData       write LCancelarData;
      property CancelarValor      : real                read LCancelarValor      write LCancelarValor;
      property Estornado          : boolean             read LEstornado          write LEstornado;
      //------------------------------------------------------------------------
      property Executando          : boolean            read LExecutando;
      property ViaLojaSimplificada : boolean            read LViaLojaSimplificada write LViaLojaSimplificada;
      //------------------------------------------------------------------------
      property RetornoTEF           : TRetornoPagamentoTEF read LRetornoTEF       write LRetornoTEF;      // Retorno do pagamento TEF
      //------------------------------------------------------------------------
   end;
  //----------------------------------------------------------------------------
  //   Declarações de bibliotecas contidas na DLL da ELGIN
  //----------------------------------------------------------------------------
  TFuncSetClientTCP           = function (ip:PAnsiChar; porta:Integer):PAnsiChar; cdecl;
  TFuncConfigurarDadosPDV     = function (textoPinpad:PAnsiChar; versaoAC:PAnsiChar; nomeEstabelecimento:PAnsiChar; loja:PAnsiChar; identificadorPontoCaptura:PAnsiChar):PAnsiChar; cdecl;
  TFuncIniciarOperacaoTEF     = function (dadosCaptura:PAnsiChar):PAnsiChar; cdecl;
  TFuncRecuperarOperacaoTEF   = function (dadosCaptura:PAnsiChar):PAnsiChar; cdecl;
  TFuncRealizarPagamentoTEF   = function (codigoOperacao:Integer; dadosCaptura:PAnsiChar; novaTransacao:Boolean):PAnsiChar; cdecl;
  TFuncRealizarPixTEF         = function (dadosCaptura:PAnsiChar; novaTransacao:Boolean):PAnsiChar; cdecl;
  TFuncRealizarAdmTEF         = function (codigoOperacao:Integer; dadosCaptura:PAnsiChar; novaTransacao:Boolean):PAnsiChar;
  TFuncConfirmarOperacaoTEF   = function (id:Integer; acao:Integer):PAnsiChar;
  TFuncFinalizarOperacaoTEF   = function (id:Integer):PAnsiChar;
  TFuncRealizarColetaPinPad   = function (tipoColeta: integer; confirmar: boolean): PAnsiChar;
  TFuncConfirmarCapturaPinPad = function (tipoCaptura: integer; dadosCaptura: PAnsiChar): PAnsiChar;
  //----------------------------------------------------------------------------
  function SetClientTCP(ip:PAnsiChar; porta:Integer):PAnsiChar;
  function ConfigurarDadosPDV(textoPinpad:PAnsiChar; versaoAC:PAnsiChar; nomeEstabelecimento:PAnsiChar; loja:PAnsiChar; identificadorPontoCaptura:PAnsiChar):PAnsiChar;
  function IniciarOperacaoTEF(dadosCaptura:PAnsiChar):PAnsiChar;
  function RecuperarOperacaoTEF(dadosCaptura:PAnsiChar):PAnsiChar;
  function RealizarPagamentoTEF(codigoOperacao:Integer; dadosCaptura:PAnsiChar; novaTransacao:Boolean):PAnsiChar;
  function RealizarPixTEF(dadosCaptura:PAnsiChar; novaTransacao:Boolean):PAnsiChar;
  function RealizarAdmTEF(codigoOperacao:Integer; dadosCaptura:PAnsiChar; novaTransacao:Boolean):PAnsiChar;
  function ConfirmarOperacaoTEF(id:Integer; acao:Integer):PAnsiChar;
  function FinalizarOperacaoTEF(id:Integer):PAnsiChar;
  function RealizarColetaPinPad(tipoColeta: integer; confirmar: boolean): PAnsiChar;
  function ConfirmarCapturaPinPad(tipoCaptura: integer; dadosCaptura: PAnsiChar): PAnsiChar;
  //----------------------------------------------------------------------------

implementation

{ TElginTEF }

//------------------------------------------------------------------------------
function LoadDLL: THandle;
begin
  if not FileExists(CDLLTef) then
    raise Exception.CreateFmt('DLL %s não encontrada.', [CDLLTef]);

  Result := LoadLibrary(CDLLTef);
  if Result = 0 then
    raise Exception.CreateFmt('Não foi possível carregar a DLL %s', [CDLLTef]);
end;
//------------------------------------------------------------------------------

function SetClientTCP(ip:PAnsiChar; porta:Integer):PAnsiChar;
var
   LHandle  : THandle;
   LDLLFunc : TFuncSetClientTCP;
begin
   LHandle  := LoadDLL;
   LDLLFunc := GetProcAddress(LHandle, 'SetClientTCP');
   if @LDLLFunc = nil then
      raise Exception.Create('Não foi possível carregar a função SetClientTCP');
    Result := LDLLFunc(ip,porta);
end;
//------------------------------------------------------------------------------
function ConfigurarDadosPDV(textoPinpad:PAnsiChar; versaoAC:PAnsiChar; nomeEstabelecimento:PAnsiChar; loja:PAnsiChar; identificadorPontoCaptura:PAnsiChar):PAnsiChar;
var
   LHandle  : THandle;
   LDLLFunc : TFuncConfigurarDadosPDV;
begin
   LHandle  := LoadDLL;
   LDLLFunc := GetProcAddress(LHandle, 'ConfigurarDadosPDV');
   if @LDLLFunc = nil then
      raise Exception.Create('Não foi possível carregar a função ConfigurarDadosPDV');
    Result := LDLLFunc(textoPinpad,versaoAC,nomeEstabelecimento,loja,identificadorPontoCaptura);
end;
//------------------------------------------------------------------------------
function IniciarOperacaoTEF(dadosCaptura:PAnsiChar):PAnsiChar;
var
   LHandle  : THandle;
   LDLLFunc : TFuncIniciarOperacaoTEF;
begin
   LHandle  := LoadDLL;
   LDLLFunc := GetProcAddress(LHandle, 'IniciarOperacaoTEF');
   if @LDLLFunc = nil then
      raise Exception.Create('Não foi possível carregar a função IniciarOperacaoTEF');
    Result := LDLLFunc(dadosCaptura);
end;
//------------------------------------------------------------------------------
function RecuperarOperacaoTEF(dadosCaptura:PAnsiChar):PAnsiChar;
var
   LHandle  : THandle;
   LDLLFunc : TFuncRecuperarOperacaoTEF;
begin
   LHandle  := LoadDLL;
   LDLLFunc := GetProcAddress(LHandle, 'RecuperarOperacaoTEF');
   if @LDLLFunc = nil then
      raise Exception.Create('Não foi possível carregar a função RecuperarOperacaoTEF');
    Result := LDLLFunc(dadosCaptura);
end;
//------------------------------------------------------------------------------
function RealizarPagamentoTEF(codigoOperacao:Integer; dadosCaptura:PAnsiChar; novaTransacao:Boolean):PAnsiChar;
var
   LHandle  : THandle;
   LDLLFunc : TFuncRealizarPagamentoTEF;
begin
   LHandle  := LoadDLL;
   LDLLFunc := GetProcAddress(LHandle, 'RealizarPagamentoTEF');
   if @LDLLFunc = nil then
      raise Exception.Create('Não foi possível carregar a função RealizarPagamentoTEF');
    Result := LDLLFunc(codigoOperacao,dadosCaptura,novaTransacao);
end;
//------------------------------------------------------------------------------
function RealizarPixTEF(dadosCaptura:PAnsiChar; novaTransacao:Boolean):PAnsiChar;
var
   LHandle  : THandle;
   LDLLFunc : TFuncRealizarPixTEF;
begin
   LHandle  := LoadDLL;
   LDLLFunc := GetProcAddress(LHandle, 'RealizarPixTEF');
   if @LDLLFunc = nil then
      raise Exception.Create('Não foi possível carregar a função RealizarPixTEF');
    Result := LDLLFunc(dadosCaptura,novaTransacao);
end;
//------------------------------------------------------------------------------
function RealizarAdmTEF(codigoOperacao:Integer; dadosCaptura:PAnsiChar; novaTransacao:Boolean):PAnsiChar;
var
   LHandle  : THandle;
   LDLLFunc : TFuncRealizarAdmTEF;
begin
   LHandle  := LoadDLL;
   LDLLFunc := GetProcAddress(LHandle, 'RealizarAdmTEF');
   if @LDLLFunc = nil then
      raise Exception.Create('Não foi possível carregar a função RealizarAdmTEF');
    Result := LDLLFunc(codigoOperacao,dadosCaptura,novaTransacao);
end;
//------------------------------------------------------------------------------
function ConfirmarOperacaoTEF(id:Integer; acao:Integer):PAnsiChar;
var
   LHandle  : THandle;
   LDLLFunc : TFuncConfirmarOperacaoTEF;
begin
   LHandle  := LoadDLL;
   LDLLFunc := GetProcAddress(LHandle, 'ConfirmarOperacaoTEF');
   if @LDLLFunc = nil then
      raise Exception.Create('Não foi possível carregar a função ConfirmarOperacaoTEF');
    Result := LDLLFunc(id,acao);
end;
//------------------------------------------------------------------------------
function FinalizarOperacaoTEF(id:Integer):PAnsiChar;
var
   LHandle  : THandle;
   LDLLFunc : TFuncFinalizarOperacaoTEF;
begin
   LHandle  := LoadDLL;
   LDLLFunc := GetProcAddress(LHandle, 'FinalizarOperacaoTEF');
   if @LDLLFunc = nil then
      raise Exception.Create('Não foi possível carregar a função FinalizarOperacaoTEF');
    Result := LDLLFunc(id);
end;
//------------------------------------------------------------------------------
function RealizarColetaPinPad(tipoColeta: integer; confirmar: boolean): PAnsiChar;
var
   LHandle  : THandle;
   LDLLFunc : TFuncRealizarColetaPinPad;
begin
   LHandle  := LoadDLL;
   LDLLFunc := GetProcAddress(LHandle, 'RealizarColetaPinPad');
   if @LDLLFunc = nil then
      raise Exception.Create('Não foi possível carregar a função RealizarColetaPinPad');
    Result := LDLLFunc(tipoColeta,confirmar);
end;
//------------------------------------------------------------------------------
function ConfirmarCapturaPinPad(tipoCaptura: integer; dadosCaptura: PAnsiChar): PAnsiChar;
var
   LHandle  : THandle;
   LDLLFunc : TFuncConfirmarCapturaPinPad;
begin
   LHandle  := LoadDLL;
   LDLLFunc := GetProcAddress(LHandle, 'ConfirmarCapturaPinPad');
   if @LDLLFunc = nil then
      raise Exception.Create('Não foi possível carregar a função ConfirmarCapturaPinPad');
    Result := LDLLFunc(tipoCaptura,dadosCaptura);
end;
//------------------------------------------------------------------------------
constructor TElginTEF.Create;
begin
   LExecutando          := true;
   LSequencial          := 0;
   LSalvarLog           := true;
   LFormaPgto           := ElginPgtoPerguntar;
   LQtdeParcelas        := 0;
   LViaLojaSimplificada := false;
   //---------------------------------------------------------------------------
   inherited;
   //---------------------------------------------------------------------------
end;


procedure TElginTEF.SA_AdmCancelamento;
var
   payload      : TJsonObject; // Objeto JSON para armazenar os dados da transação
   inicializar  : boolean;  // Flag para sinalizar se foi possível inicializar o TEF ELGIN
   resultado    : string;
   sair         : boolean;
   RespReqTEF   : TTefRetorno; // Retorno da requisição inicial de ADM
   RespConsTEF  : TTefRetorno; // Retorno da requisição de ADM
   //---------------------------------------------------------------------------
   comprovanteDiferenciadoLoja     : TStringList;
   comprovanteDiferenciadoPortador : TStringList;
   //---------------------------------------------------------------------------      
   DadoColeta       : string;   // Dado obtido do operador para a coleta
   conteudo_default : string;  // Informação que vai entrar no campo
   opcoesColeta     : TStringList;
   opcaoColeta      : integer;
   //---------------------------------------------------------------------------   
begin
   //---------------------------------------------------------------------------
   //   Iniciando a tela de TEF
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpTEFELGIN;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := '';
   frmwebtef.lbvalor.Caption  := '';
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   SA_MostrarADM;
   //---------------------------------------------------------------------------
   //---------------------------------------------------------------------------
   LExecutando := true;
   //---------------------------------------------------------------------------
   TThread.CreateAnonymousThread(procedure
   begin
      //------------------------------------------------------------------------
      //   Inicializar TEF
      //------------------------------------------------------------------------
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
         frmwebtef.mensagem := 'Inicializando TEF...';
         SA_Mostrar_Mensagem(true);
      end);
      inicializar := SA_Inicializar_TEF;   // Inicializando o TEF
   
      //------------------------------------------------------------------------
      if not inicializar then
         begin
            resultado := UTF8ToString(FinalizarOperacaoTEF(1));
            SA_SalvarLog('Resposta FINALIZAR',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
            frmwebtef.mensagem := 'Erro na inicialização do TEF';
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
               SA_Mostrar_Mensagem(true);
            end);
            //------------------------------------------------------------------
            SA_AtivarBTCancelar;
            while not frmwebtef.Cancelar do
               begin
                  sleep(50);
               end;
            //------------------------------------------------------------------
            lExecutando := false;
            sair        := true;
            //------------------------------------------------------------------
         end;
      //------------------------------------------------------------------------
      if not sair  then
         begin
            //------------------------------------------------------------------
            inc(LSequencial);   // Incrementando o numero sequencial para realizar a chamada à DLL
            payload := TJsonObject.Create;
            payload.AddPair('sequencial', LSequencial.ToString);
            payload.AddPair('transacao_data',formatdatetime('dd/MM/yy',LCancelarData));
            payload.AddPair('transacao_nsu',LCancelarNSU);
            payload.AddPair('transacao_valor',trim(stringreplace(transform(CancelarValor),',','.',[rfReplaceAll])));
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
               frmwebtef.mensagem := 'Iniciando CANCELAMENTO ADM...';
               SA_Mostrar_Mensagem(true);
            end);
            //------------------------------------------------------------------
            SA_SalvarLog('CANCELAMENTO ADM:',payload.ToString,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
            resultado :=  UTF8ToString(RealizarAdmTEF( SA_tpOperacaoADMToInt(LtpOperacaoADM) , PAnsiChar(AnsiString(payload.ToString)), True));
            SA_SalvarLog('Resposta CANCELAMENTO ADM:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
            //------------------------------------------------------------------
            RespReqTEF  := SA_ParsingTEF(resultado);
            RespConsTEF := RespReqTEF;
            //------------------------------------------------------------------
            while not sair do
               begin
                  //------------------------------------------------------------
                  if RespConsTEF.retorno='' then  // Tem que processar o retorno
                     begin
                        //------------------------------------------------------
                        //  Consultar TEF
                        //------------------------------------------------------
                        if (RespConsTEF.automacao_coleta_tipo='X') and (RespConsTEF.automacao_coleta_opcao<>'') then
                           begin
                              //------------------------------------------------
                              //  Criar menu de opções
                              //------------------------------------------------
                              opcoesColeta := SA_Opcoes(RespConsTEF.automacao_coleta_opcao);
                              //------------------------------------------------
                              frmwebtef.mensagem := RespConsTEF.mensagemResultado;
                              frmwebtef.opcoes   := opcoesColeta;
                              frmwebtef.opcao    := -1;
                              frmwebtef.tecla    := '';
                              frmwebtef.Cancelar := false;
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              //------------------------------------------------
                              opcaoColeta  := SA_PerguntarOpcoes(opcoesColeta,RespConsTEF.mensagemResultado);   // Apanhando a opção do menu
                              if opcaoColeta<>-1 then
                                 DadoColeta   := opcoesColeta[opcaoColeta-1]  // Obtendo dado para a coleta
                              else
                                 DadoColeta   := '';   // Definindo o valor vazio para coleta
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                              //------------------------------------------------
                           end
                        else if (RespConsTEF.automacao_coleta_tipo='X') and (RespConsTEF.automacao_coleta_opcao='') then
                           begin
                              //------------------------------------------------
                              //  Coletar dado string do teclado
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,
                              procedure
                                 begin
                                    SA_ColetarValor(RespConsTEF.mensagemResultado,'',RespConsTEF.automacao_coleta_palavra_chave='transacao_administracao_senha');
                                    SA_AtivarBTCancelar;
                                 end);
                              //------------------------------------------------
                              DadoColeta              := '';
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              while (frmwebtef.dado_digitado='') and(not frmwebtef.Cancelar) do
                                 begin
                                    sleep(10);
                                 end;
                              DadoColeta   := frmwebtef.dado_digitado;
                              frmwebtef.pncaptura.Visible := false;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                           end
                        else if (RespConsTEF.automacao_coleta_tipo='N') then
                           begin
                              //------------------------------------------------
                              //  Coletar dado numerico do teclado
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,
                               procedure
                                 begin
                                   SA_ColetarValor(RespConsTEF.mensagemResultado,'',false);
                                 end);
                              //---------------------------------------------------
                              SA_AtivarBTCancelar;
                              if RespConsTEF.automacao_coleta_palavra_chave='transacao_valor' then
                                 frmwebtef.CaracteresDigitaveis := ['0'..'9',',',#8]
                              else
                                 frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              DadoColeta              := '';
                              while (DadoColeta='') and (not frmwebtef.Cancelar) do
                                 begin
                                    //---------------------------------------------
                                    sleep(10);
                                    //---------------------------------------------
                                    if (frmwebtef.dado_digitado<>'') and (untransform(frmwebtef.dado_digitado)>0)  then
                                       begin
                                          if RespConsTEF.automacao_coleta_palavra_chave='transacao_valor' then
                                             DadoColeta := trim(stringreplace(transform(untransform(frmwebtef.dado_digitado)),',','.',[rfReplaceAll]))
                                          else
                                             DadoColeta := frmwebtef.dado_digitado;
                                       end
                                    else if (frmwebtef.dado_digitado<>'') then
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
                           end
                        else if (RespConsTEF.automacao_coleta_tipo='D') then
                           begin
                              //------------------------------------------------
                              //  Coletar dado DATA do teclado
                              //------------------------------------------------
                              conteudo_default := '';
                              if uppercase(RespConsTEF.mensagemResultado)='DATA DO EXTRATO' then
                                 conteudo_default := formatdatetime('dd/mm/yyyy',date);

                              TThread.Synchronize(TThread.CurrentThread,
                               procedure
                                 begin
                                   SA_ColetarValor(RespConsTEF.mensagemResultado,'99/99/9999',false,conteudo_default);
                                 end);
                              //------------------------------------------------
                              SA_AtivarBTCancelar;
                              frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              DadoColeta              := '';
                              while (DadoColeta='') and (not frmwebtef.Cancelar) do
                                 begin
                                    //------------------------------------------
                                    sleep(10);
                                    //------------------------------------------
                                    if (frmwebtef.dado_digitado<>'') and (DataValida(frmwebtef.dado_digitado)) then
                                       DadoColeta := formatdatetime(RespConsTEF.automacao_coleta_mascara,strtodate(frmwebtef.dado_digitado))
                                    else if (frmwebtef.dado_digitado<>'') then
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
                           end
                        else if (RespConsTEF.automacao_coleta_tipo='') and (RespConsTEF.automacao_coleta_retorno='0') then
                           begin
                              //------------------------------------------------
                              //  Mostrar mensagem somente
                              //------------------------------------------------
                              frmwebtef.mensagem := RespConsTEF.mensagemResultado;
                              TThread.Synchronize(TThread.CurrentThread,
                               procedure
                                 begin
                                    SA_Mostrar_Mensagem(true);
                                 end);
                              //------------------------------------------------
                           end;
                        //------------------------------------------------------
                        if (RespConsTEF.automacao_coleta_tipo='') and (RespConsTEF.automacao_coleta_opcao='') and (RespConsTEF.automacao_coleta_retorno='0') then
                           begin
                              //------------------------------------------------
                              //   Fazer Consulta
                              //------------------------------------------------
                              payload := TJsonObject.Create;
                              payload.AddPair('automacao_coleta_retorno', RespConsTEF.automacao_coleta_retorno);
                              payload.AddPair('automacao_coleta_sequencial', RespConsTEF.automacao_coleta_sequencial);
                              SA_SalvarLog('CONSULTAR:',payload.ToString,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);   // Salvar LOG
                              //------------------------------------------
                              resultado :=  UTF8ToString(RealizarAdmTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
                              SA_SalvarLog('Resposta CONSULTAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);   // Salvar LOG
                              RespConsTEF  := SA_ParsingTEF(resultado);
                              sair := false;
                              //------------------------------------------------
                           end
                        else
                           begin
                              if DadoColeta<>'' then   // Foi digitado algum dado
                                 begin
                                    //------------------------------------------
                                    //   Enviar o dado coletado
                                    //   É necessário informar os dados coletados do operador
                                    //------------------------------------------
                                    frmwebtef.mensagem := 'ENVIANDO DADOS PARA TEF';
                                    TThread.Synchronize(TThread.CurrentThread,
                                    procedure
                                       begin
                                          SA_Mostrar_Mensagem(true);
                                       end);
                                    //------------------------------------------
                                    payload := TJsonObject.Create;
                                    payload.AddPair('automacao_coleta_retorno', RespConsTEF.automacao_coleta_retorno);
                                    payload.AddPair('automacao_coleta_sequencial', RespConsTEF.automacao_coleta_sequencial);
                                    payload.AddPair('automacao_coleta_informacao', DadoColeta);
                                    SA_SalvarLog('INFORMAR COLETA:',payload.ToString,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);   // Salvar LOG
                                    resultado :=  UTF8ToString(RealizarAdmTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
                                    SA_SalvarLog('Resposta INFORMAR COLETA:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);   // Salvar LOG
                                    RespConsTEF   := SA_ParsingTEF(resultado);
                                    DadoColeta    := '';
                                 end
                              else
                                 begin
                                    //------------------------------------------
                                    // Finalizar a operação
                                    //------------------------------------------
                                    resultado := UTF8ToString(FinalizarOperacaoTEF(1)); // Finalizando a operação de TEF
                                    SA_SalvarLog('Resposta FINALIZAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);   // Salvar LOG
                                    sair := true;
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                           end;
                        //------------------------------------------------------
                     end
                  else if RespConsTEF.retorno='0' then
                     begin
                        //------------------------------------------------------
                        //   Verificar se há impressos a serem executados
                        //------------------------------------------------------
                        LSequencial := strtointdef(RespConsTEF.sequencial,0);
                        SA_SalvarLog('CONFIRMAR:','Nro Sequencial = '+RespConsTEF.sequencial,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);   // Salvar LOG
                        resultado   := UTF8ToString(ConfirmarOperacaoTEF(LSequencial,1));

                        SA_SalvarLog('Resposta CONFIRMAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);   // Salvar LOG

                        LEstornado := true;
                        if RespConsTEF.comprovanteDiferenciadoLoja<>'' then
                           begin
                              if LComprovanteLoja<>tpTEFNaoImprimir then
                                 begin
                                    TpComprovanteImprimir            := tpLoja;
                                    comprovanteDiferenciadoLoja      := TStringList.Create;
                                    comprovanteDiferenciadoLoja.Text := StringReplace(RespConsTEF.comprovanteDiferenciadoLoja,'\r\n',#13,[rfReplaceAll, rfIgnoreCase]);
                                    SA_ImprimirComprovante(comprovanteDiferenciadoLoja,'Imprimir comprovante da loja ?');
                                    comprovanteDiferenciadoLoja.Free;
                                 end;
                           end;
                        if RespConsTEF.comprovanteDiferenciadoPortador<>'' then
                           begin
                              if LComprovanteCliente<>tpTEFNaoImprimir then
                                 begin
                                    TpComprovanteImprimir                := tpCliente;
                                    comprovanteDiferenciadoPortador      := TStringList.Create;
                                    comprovanteDiferenciadoPortador.Text := StringReplace(RespConsTEF.comprovanteDiferenciadoPortador,'\r\n',#13,[rfReplaceAll, rfIgnoreCase]);
                                    SA_ImprimirComprovante(comprovanteDiferenciadoPortador,'Imprimir comprovante do cliente ?');
                                    comprovanteDiferenciadoPortador.Free;
                                 end;
                           end;
                        //------------------------------------------------------
                        resultado := UTF8ToString(FinalizarOperacaoTEF(1)); // Finalizando a operação de TEF
                        SA_SalvarLog('Resposta FINALIZAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);   // Salvar LOG
                        sair := true;
                        //------------------------------------------------------
                     end;
                  //------------------------------------------------------------
               end;
         end;
      //------------------------------------------------------------------------
      frmwebtef.Close;
      frmwebtef.Release;
      lExecutando := false;
      //------------------------------------------------------------------------
   end).Start;
   //---------------------------------------------------------------------------      
end;

procedure TElginTEF.SA_Administrativo;
var
   payload      : TJsonObject; // Objeto JSON para armazenar os dados da transação
   inicializar  : boolean;  // Flag para sinalizar se foi possível inicializar o TEF ELGIN
   resultado    : string;
   sair         : boolean;
   RespReqTEF   : TTefRetorno; // Retorno da requisição inicial de ADM
   RespConsTEF  : TTefRetorno; // Retorno da requisição de ADM
   DadoColeta   : string;   // Dado obtido do operador para a coleta
   //---------------------------------------------------------------------------
   opcoesColeta  : TStringList;
   opcaoColeta   : integer;
   //---------------------------------------------------------------------------
   comprovanteDiferenciadoLoja     : TStringList;
   comprovanteDiferenciadoPortador : TStringList;
   //---------------------------------------------------------------------------
   conteudo_default : string;  // Informação que vai entrar no campo
begin
   //---------------------------------------------------------------------------
   //   Iniciando a tela de TEF
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpTEFELGIN;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LForma;
   frmwebtef.lbvalor.Caption  := transform(LValor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;

   SA_MostrarADM;
   //---------------------------------------------------------------------------
   LExecutando := true;
   //---------------------------------------------------------------------------
   TThread.CreateAnonymousThread(procedure
   begin
      //------------------------------------------------------------------------
      //   Inicializar TEF
      //------------------------------------------------------------------------
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
         frmwebtef.mensagem := 'Inicializando TEF...';
         SA_Mostrar_Mensagem(true);
      end);
      //------------------------------------------------------------------------
      sair        := false;
      inicializar := SA_Inicializar_TEF;   // Inicializando o TEF
      //------------------------------------------------------------------------
      if not inicializar then
         begin
            resultado := UTF8ToString(FinalizarOperacaoTEF(1));
            SA_SalvarLog('Resposta FINALIZAR',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
            frmwebtef.mensagem := 'Erro na inicialização do TEF';
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
               SA_Mostrar_Mensagem(true);
            end);
            //------------------------------------------------------------------
            SA_AtivarBTCancelar;
            while not frmwebtef.Cancelar do
               begin
                  sleep(50);
               end;
            //------------------------------------------------------------------
            lExecutando := false;
            sair        := true;
            //------------------------------------------------------------------
         end;
      //------------------------------------------------------------------------

      if not sair  then
         begin
            //------------------------------------------------------------------
            inc(LSequencial);   // Incrementando o numero sequencial para realizar a chamada à DLL
            payload := TJsonObject.Create;
            payload.AddPair('sequencial', LSequencial.ToString);
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
               frmwebtef.mensagem := 'Iniciando ADM...';
               SA_Mostrar_Mensagem(true);
            end);
            //------------------------------------------------------------------
            SA_SalvarLog('ADM:',payload.ToString,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
            resultado :=  UTF8ToString(RealizarAdmTEF( SA_tpOperacaoADMToInt(LtpOperacaoADM) , PAnsiChar(AnsiString(payload.ToString)), True));
            SA_SalvarLog('Resposta ADM:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
            //------------------------------------------------------------------
            RespReqTEF  := SA_ParsingTEF(resultado);
            //------------------------------------------------------------------
            if (RespReqTEF.retorno<>'') then   // Ocorreu um erro que exige a finalização da operação
               begin
                  //------------------------------------------------------------
                  //   Mostrar a mensagem de erro na tela
                  //------------------------------------------------------------
                  resultado := UTF8ToString(FinalizarOperacaoTEF(1)); // Finalizando a operação de TEF
                  SA_SalvarLog('Resposta FINALIZAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);   // Salvar LOG
                  if RespReqTEF.mensagemResultado<>'' then   // Se o TEF mandou exibir alguma mensagem
                     frmwebtef.mensagem := RespReqTEF.mensagemResultado
                  else   // Sem mensagem nenhuma, criando uma padrão
                     frmwebtef.mensagem := 'Ocorreu erro na requisição de pagamento...';
                  SA_Mostrar_Mensagem(true);
                  SA_AtivarBTCancelar;
                  sair := true;
                  while not frmwebtef.Cancelar do   // Esperando que o operador cancelar
                     begin
                        sleep(50);
                     end;
                  //------------------------------------------------------------
               end
            else if RespReqTEF.retorno='' then   //   É necessário ficar monitorando e fazer coleta
               begin
                  //------------------------------------------------------------
                  RespConsTEF := RespReqTEF;
                  while not sair do
                     begin
                        //------------------------------------------------------
                        DadoColeta   := '';
                        if frmwebtef.Cancelar then
                           break;
                        //------------------------------------------------------
                        if RespConsTEF.automacao_coleta_tipo='X' then  // Tem que coletar um valor alfanumerico
                           begin
                              if RespConsTEF.automacao_coleta_opcao<>'' then   // Tem que abrir um Menu de opções
                                 begin
                                    //------------------------------------------
                                    //  Criar menu de opções
                                    //------------------------------------------
                                     opcoesColeta := SA_Opcoes(RespConsTEF.automacao_coleta_opcao);
                                     //---------------------------------------------------
                                     frmwebtef.mensagem := RespConsTEF.mensagemResultado;
                                     frmwebtef.opcoes   := opcoesColeta;
                                     frmwebtef.opcao    := -1;
                                     frmwebtef.tecla    := '';
                                     frmwebtef.Cancelar := false;
                                     //---------------------------------------------------
                                     TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                     TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                     //---------------------------------------------------
                                     opcaoColeta  := SA_PerguntarOpcoes(opcoesColeta,RespConsTEF.mensagemResultado);   // Apanhando a opção do menu
                                     if opcaoColeta<>-1 then
                                        DadoColeta   := opcoesColeta[opcaoColeta-1]  // Obtendo dado para a coleta
                                     else
                                        DadoColeta   := '';   // Definindo o valor vazio para coleta
                                     //---------------------------------------------------
                                     TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                     TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                    //------------------------------------------
                                 end
                              else   // Tem que coletar dados obtidos do teclado
                                 begin
                                    //------------------------------------------
                                    // Criar uma tela para digitar os dados
                                    //------------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,
                                    procedure
                                       begin
                                          SA_ColetarValor(RespConsTEF.mensagemResultado,'',RespConsTEF.automacao_coleta_palavra_chave='transacao_administracao_senha');
                                          SA_AtivarBTCancelar;
                                       end);
                                    //------------------------------------------
                                    DadoColeta              := '';
                                    frmwebtef.dado_digitado := '';
                                    frmwebtef.Cancelar      := false;
                                    while (frmwebtef.dado_digitado='') and(not frmwebtef.Cancelar) do
                                       begin
                                          sleep(10);
                                       end;
                                    DadoColeta   := frmwebtef.dado_digitado;
                                    frmwebtef.pncaptura.Visible := false;
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    //------------------------------------------
                                 end;
                           end
                        else if RespConsTEF.automacao_coleta_tipo='N' then  // Tem que coletar um valor numerico
                           begin
                              //------------------------------------------------
                              //  Tem que coletar dados numéricos
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,
                               procedure
                                 begin
                                   SA_ColetarValor(RespConsTEF.mensagemResultado,'',false);
                                 end);
                              //---------------------------------------------------
                              SA_AtivarBTCancelar;
                              if RespConsTEF.automacao_coleta_palavra_chave='transacao_valor' then
                                 frmwebtef.CaracteresDigitaveis := ['0'..'9',',',#8]
                              else
                                 frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              DadoColeta              := '';
                              while (DadoColeta='') and (not frmwebtef.Cancelar) do
                                 begin
                                    //---------------------------------------------
                                    sleep(10);
                                    //---------------------------------------------
                                    if (frmwebtef.dado_digitado<>'') and (untransform(frmwebtef.dado_digitado)>0)  then
                                       begin
                                          if RespConsTEF.automacao_coleta_palavra_chave='transacao_valor' then
                                             DadoColeta := trim(stringreplace(transform(untransform(frmwebtef.dado_digitado)),',','.',[rfReplaceAll]))
                                          else
                                             DadoColeta := frmwebtef.dado_digitado;
                                       end
                                    else if (frmwebtef.dado_digitado<>'') then
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
                           end
                        else if RespConsTEF.automacao_coleta_tipo='D' then  // Tem que coletar um valor numerico
                           begin
                              //----------------------------------------------------
                              //   Coletar Data do operador
                              //----------------------------------------------------
                              conteudo_default := '';
                              if uppercase(RespConsTEF.mensagemResultado)='DATA DO EXTRATO' then
                                 conteudo_default := formatdatetime('dd/mm/yyyy',date);

                              TThread.Synchronize(TThread.CurrentThread,
                               procedure
                                 begin
                                   SA_ColetarValor(RespConsTEF.mensagemResultado,'99/99/9999',false,conteudo_default);
                                 end);
                              //---------------------------------------------------
                              SA_AtivarBTCancelar;
                              frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              DadoColeta              := '';
                              while (DadoColeta='') and (not frmwebtef.Cancelar) do
                                 begin
                                    //---------------------------------------------
                                    sleep(10);
                                    //---------------------------------------------
                                    if (frmwebtef.dado_digitado<>'') and (DataValida(frmwebtef.dado_digitado)) then
                                       DadoColeta := formatdatetime(RespConsTEF.automacao_coleta_mascara,strtodate(frmwebtef.dado_digitado))
                                    else if (frmwebtef.dado_digitado<>'') then
                                       begin
                                          frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                          frmwebtef.pnalerta.Color        := clRed;
                                          frmwebtef.pnalerta.Font.Color   := clYellow;
                                          frmwebtef.dado_digitado         := '';
                                       end;
                                    //---------------------------------------------
                                 end;
                              //---------------------------------------------------
                              frmwebtef.pncaptura.Visible := false;
                              frmwebtef.edtdado.Enabled   := false;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                           end
                        else if RespConsTEF.automacao_coleta_tipo='' then  // Somente mostrar uma mensagem na tela
                           begin
                              //------------------------------------------------
                              //   Ápenas mostrar uma mensagem na tela e verificar se a operação foi concluída
                              //------------------------------------------------
                              //   Mostrar a mensagem
                              //------------------------------------------------
                              frmwebtef.mensagem := RespConsTEF.mensagemResultado;
                              TThread.Synchronize(TThread.CurrentThread,
                              procedure
                                 begin
                                    SA_Mostrar_Mensagem(true);
                                 end);
                              //------------------------------------------------
                           end;
                        //------------------------------------------------------
                        if RespConsTEF.automacao_coleta_tipo<>'' then
                           begin
                              if DadoColeta<>'' then
                                 begin
                                    //------------------------------------------
                                    //   É necessário informar os dados coletados do operador
                                    //------------------------------------------
                                    frmwebtef.mensagem := 'ENVIANDO DADOS PARA TEF';
                                    TThread.Synchronize(TThread.CurrentThread,
                                    procedure
                                       begin
                                          SA_Mostrar_Mensagem(true);
                                       end);
                                    //------------------------------------------
                                    payload := TJsonObject.Create;
                                    payload.AddPair('automacao_coleta_retorno', RespConsTEF.automacao_coleta_retorno);
                                    payload.AddPair('automacao_coleta_sequencial', RespConsTEF.automacao_coleta_sequencial);
                                    payload.AddPair('automacao_coleta_informacao', DadoColeta);
                                    SA_SalvarLog('INFORMAR COLETA:',payload.ToString,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);   // Salvar LOG
                                    resultado :=  UTF8ToString(RealizarAdmTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
                                    SA_SalvarLog('Resposta INFORMAR COLETA:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);   // Salvar LOG
                                    RespConsTEF  := SA_ParsingTEF(resultado);
                                    sair := false;
                                    //------------------------------------------
                                    SA_Mostrar_Mensagem(false);
                                    //------------------------------------------
                                 end
                              else
                                 begin
                                    //------------------------------------------
                                    //   A coleta foi cancelada, finalizar a operação
                                    //------------------------------------------
                                    frmwebtef.mensagem := 'CANCELAR OPERAÇÃO';
                                    TThread.Synchronize(TThread.CurrentThread,
                                    procedure
                                       begin
                                          SA_Mostrar_Mensagem(true);
                                       end);
                                    //------------------------------------------
                                    payload := TJsonObject.Create;
                                    payload.AddPair('automacao_coleta_retorno', '9');
                                    payload.AddPair('automacao_coleta_sequencial', RespConsTEF.automacao_coleta_sequencial);
                                    //------------------------------------------
                                    SA_SalvarLog('CANCELAR COLETA:',payload.ToString,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                                    //------------------------------------------
                                    resultado :=  UTF8ToString(RealizarAdmTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
                                    //------------------------------------------
                                    SA_SalvarLog('Resposta CANCELAR COLETA:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                                    //--------------------------------------------
                                    resultado := UTF8ToString(FinalizarOperacaoTEF(1)); // Finalizando a operação de TEF
                                    SA_SalvarLog('Resposta FINALIZAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);   // Salvar LOG
                                    RespConsTEF  := SA_ParsingTEF(resultado);
                                    frmwebtef.mensagem := 'Operação cancelada pelo operador...';
                                    SA_Mostrar_Mensagem(true);
                                    SA_AtivarBTCancelar;
                                    sair := true;
                                    frmwebtef.Cancelar := false;
                                    while not frmwebtef.Cancelar do   // Esperando que o operador cancelar
                                       begin
                                          sleep(50);
                                       end;
                                    //------------------------------------------
                                 end;
                           end
                        else   // Somente exibir mensagem na tela e fazer nova consulta
                           begin
                              //------------------------------------------------
                              //   Fazer nova consulta
                              //------------------------------------------------
                              frmwebtef.mensagem := 'CONSULTANDO TEF';
                              TThread.Synchronize(TThread.CurrentThread,
                              procedure
                                 begin
                                    SA_Mostrar_Mensagem(true);
                                 end);
                              //------------------------------------------------
                              payload := TJsonObject.Create;
                              payload.AddPair('automacao_coleta_retorno', RespConsTEF.automacao_coleta_retorno);
                              payload.AddPair('automacao_coleta_sequencial', RespConsTEF.automacao_coleta_sequencial);
                              SA_SalvarLog('CONSULTAR:',payload.ToString,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);   // Salvar LOG
                              //------------------------------------------------
                              resultado :=  UTF8ToString(RealizarAdmTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
                              SA_SalvarLog('Resposta CONSULTAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);   // Salvar LOG
                              RespConsTEF  := SA_ParsingTEF(resultado);
                              sair := false;
                              //------------------------------------------------
                           end;
                        //------------------------------------------------------
                        if (RespConsTEF.automacao_coleta_retorno<>'0') and (not sair) then
                           begin
                              //------------------------------------------------
                              if (RespConsTEF.retorno='0') or (RespConsTEF.retorno='1') then
                                 begin
                                    //------------------------------------------
                                    //   Verificar se há impressos a serem executados
                                    //------------------------------------------
                                    if RespConsTEF.comprovanteDiferenciadoLoja<>'' then
                                       begin
                                          if LComprovanteLoja<>tpTEFNaoImprimir then
                                             begin
                                                TpComprovanteImprimir            := tpLoja;
                                                comprovanteDiferenciadoLoja      := TStringList.Create;
                                                comprovanteDiferenciadoLoja.Text := StringReplace(RespConsTEF.comprovanteDiferenciadoLoja,'\r\n',#13,[rfReplaceAll, rfIgnoreCase]);
                                                SA_ImprimirComprovante(comprovanteDiferenciadoLoja,'Imprimir comprovante da loja ?');
                                                comprovanteDiferenciadoLoja.Free;
                                             end;
                                       end;
                                    if RespConsTEF.comprovanteDiferenciadoPortador<>'' then
                                       begin
                                          if LComprovanteCliente<>tpTEFNaoImprimir then
                                             begin
                                                TpComprovanteImprimir                := tpCliente;
                                                comprovanteDiferenciadoPortador      := TStringList.Create;
                                                comprovanteDiferenciadoPortador.Text := StringReplace(RespConsTEF.comprovanteDiferenciadoPortador,'\r\n',#13,[rfReplaceAll, rfIgnoreCase]);
                                                SA_ImprimirComprovante(comprovanteDiferenciadoPortador,'Imprimir comprovante do cliente ?');
                                                comprovanteDiferenciadoPortador.Free;
                                             end;
                                       end;
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                              frmwebtef.mensagem := 'Finalizando conexão...';
                              SA_Mostrar_Mensagem(true);
                              resultado := UTF8ToString(FinalizarOperacaoTEF(1)); // Finalizando a operação de TEF
                              SA_SalvarLog('Resposta FINALIZAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);   // Salvar LOG
                              //------------------------------------------------
                              if RespConsTEF.mensagemResultado<>'' then
                                 frmwebtef.mensagem := RespConsTEF.mensagemResultado
                              else
                                 frmwebtef.mensagem := 'Ocorreu um erro na operação !';
                              //------------------------------------------------
                              SA_Mostrar_Mensagem(true);
                              SA_AtivarBTCancelar;
                              sair := true;
                              frmwebtef.Cancelar := false;
                              while not frmwebtef.Cancelar do   // Esperando que o operador cancelar
                                 begin
                                    sleep(50);
                                 end;
                              //------------------------------------------------
                           end;
                        //------------------------------------------------------
                        //******************************************************
                        //------------------------------------------------------
                     end;
                  //------------------------------------------------------------
               end;
            //------------------------------------------------------------------
         end;
      //------------------------------------------------------------------------
      frmwebtef.Close;
      frmwebtef.Release;
      lExecutando := false;
      //------------------------------------------------------------------------
   end).Start;
   //---------------------------------------------------------------------------
end;



procedure TElginTEF.SA_Configurar_TEF;
begin
  SetClientTCP(pansichar(ansistring('127.0.0.1')), 60906);
  ConfigurarDadosPDV(pansichar(ansistring(TEFTextoPinPad)), pansichar(ansistring(TEFSistema)), pansichar(ansistring(TEFEstabelecimento)), pansichar(ansistring(TEFLoja)), pansichar(ansistring(LTEFIdCliente)));
end;

procedure TElginTEF.SA_CriarMenuT;
begin
   SA_Criar_Menu(true);
end;

function TElginTEF.SA_DefinirPagamentoELGIN(FormaPgto : TtpElginFormaPgto): TPagamentoELGIN;
begin
   //---------------------------------------------------------------------------
   //   Tipo de financiamento = "A vista", "Parcelado", "" (perguntar), "Pre-datado"
   //---------------------------------------------------------------------------
   case FormaPgto of
     ElginPgtoPerguntar                : result.FormaPgtoPAYLOAD := '';
     ElginPgtoCreditoPerguntar         : result.FormaPgtoPAYLOAD := '';
     ElginPgtoCreditoVista             : result.FormaPgtoPAYLOAD := 'A vista';
     ElginPgtoCreditoPaceladoPerguntar : result.FormaPgtoPAYLOAD := 'Parcelado';
     ElginPgtoCreditoParceladoLoja     : result.FormaPgtoPAYLOAD := 'Parcelado';
     ElginPgtoCreditoParceladoADM      : result.FormaPgtoPAYLOAD := 'Parcelado';
     ElginPgtoDebitoPerguntar          : result.FormaPgtoPAYLOAD := '';
     ElginPgtoDebitoVista              : result.FormaPgtoPAYLOAD := 'A vista';
     ElginPgtoDebitpPre                : result.FormaPgtoPAYLOAD := 'Pre-datado';
     ElginPgtoPIX                      : result.FormaPgtoPAYLOAD := 'A vista';
   end;
   //---------------------------------------------------------------------------
   //   Tipo de parcelamento = "Estabelecimento", "Administradora", "" (perguntar)
   //---------------------------------------------------------------------------
   case FormaPgto of
     ElginPgtoPerguntar                : result.tpFinPAYLOAD := '';
     ElginPgtoCreditoPerguntar         : result.tpFinPAYLOAD := '';
     ElginPgtoCreditoVista             : result.tpFinPAYLOAD := '';
     ElginPgtoCreditoPaceladoPerguntar : result.tpFinPAYLOAD := '';
     ElginPgtoCreditoParceladoLoja     : result.tpFinPAYLOAD := 'Estabelecimento';
     ElginPgtoCreditoParceladoADM      : result.tpFinPAYLOAD := 'Administradora';
     ElginPgtoDebitoPerguntar          : result.tpFinPAYLOAD := '';
     ElginPgtoDebitoVista              : result.tpFinPAYLOAD := '';
     ElginPgtoDebitpPre                : result.tpFinPAYLOAD := 'Estabelecimento';
     ElginPgtoPIX                      : result.tpFinPAYLOAD := '';
   end;
   //---------------------------------------------------------------------------
   //   Tipo de Cartao = 0 - Perguntar / 1 - Credito / 2 - Debito / 3 - Voucher / 4 - Frota / 5 - Private Label
   //---------------------------------------------------------------------------
   case FormaPgto of
     ElginPgtoPerguntar                : result.tipoCartao := 0;
     ElginPgtoCreditoPerguntar         : result.tipoCartao := 1;
     ElginPgtoCreditoVista             : result.tipoCartao := 1;
     ElginPgtoCreditoPaceladoPerguntar : result.tipoCartao := 1;
     ElginPgtoCreditoParceladoLoja     : result.tipoCartao := 1;
     ElginPgtoCreditoParceladoADM      : result.tipoCartao := 1;
     ElginPgtoDebitoPerguntar          : result.tipoCartao := 2;
     ElginPgtoDebitoVista              : result.tipoCartao := 2;
     ElginPgtoDebitpPre                : result.tipoCartao := 2;
     ElginPgtoPIX                      : result.tipoCartao := 0;
   end;
   //---------------------------------------------------------------------------
end;

procedure TElginTEF.SA_DesativarBtCancelarT;
begin
   SA_DesativarBTCancelar;
end;

procedure TElginTEF.SA_DesativarMenuT;
begin
   SA_Criar_Menu(false);
end;

function TElginTEF.SA_GerarComprovanteSimplificado: TStringList;
begin
   Result := TStringList.Create;
   Result.Add('</ce>COMPROVANTE TEF - Via Lojista');
   Result.Add('</ae>');
   Result.Add('   Realizada em   '+LdataHoraTransacao);
   Result.Add('       Valor R$   '+transform(LValor));
   Result.Add('     Forma Pgto   '+LForma);
   Result.Add('            NSU   '+LRetornoTEF.NSU);
   Result.Add('        Cod.Aut.  '+LRetornoTEF.cAut);
   Result.Add('       Bandeira   '+LRetornoTEF.Bandeira);
end;

procedure TElginTEF.SA_ImprimirComprovante(comprovante: TStringList;  pergunta: string);
var
   sair          : boolean;
   tipoimpressao : TtpTEFImpressao;
begin
   tipoimpressao := tpTEFPerguntar;
   case TpComprovanteImprimir of
      tpLoja    : tipoimpressao := LComprovanteLoja;
      tpCliente : tipoimpressao := LComprovanteCliente;
   end;
   //---------------------------------------------------------------------------
   if tipoimpressao=tpTEFPerguntar then
      begin
         frmwebtef.mensagem := pergunta;
         frmwebtef.opcoes   := TStringList.Create;
         frmwebtef.opcoes.Add('Imprimir');
         frmwebtef.opcoes.Add('Não imprimir');
         frmwebtef.tecla    := '';
         frmwebtef.opcao    := 0;
         frmwebtef.Cancelar := false;
         SA_Criar_Menu(true);
         sair := false;
         while not sair do
            begin
               //---------------------------------------------------------------
               if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                  begin
                     //---------------------------------------------------------
                     SA_ImprimirTexto(SA_ResumirComprovante(comprovante).Text,LImpressora); //   Executar a impressão
                     sair := true;
                     //---------------------------------------------------------
                  end
               else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                  sair := true;
               if frmwebtef.Cancelar then
                  sair := true;
               //---------------------------------------------------------------
               sleep(30);
               //---------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
         SA_Criar_Menu(false);
         //---------------------------------------------------------------------
      end
   else if tipoimpressao=tpTEFImprimirSempre then
      SA_ImprimirTexto(SA_ResumirComprovante(comprovante).Text,LImpressora); //   Executar a impressão
   //---------------------------------------------------------------------------

   //---------------------------------------------------------------------------
end;


function TElginTEF.SA_Inicializar_TEF: boolean;
var
   payload   : TJsonObject;
   resultado : string;
   RespJSON  : TJSONValue;
   RespTEF   : TJSONValue;
   codigoTEF : integer;
begin
   //---------------------------------------------------------------------------
   payload   := TJsonObject.Create;
   //---------------------------------------------------------------------------
   payload.AddPair('aplicacao',LTEFSistema);
   payload.AddPair('aplicacao_tela',LTEFSistema);
   payload.AddPair('versao',LTEFSistemaVersao);
   payload.AddPair('estabelecimento',LTEFEstabelecimento);
   payload.AddPair('loja',LTEFLoja);
   payload.AddPair('terminal',LTEFTerminal);
   payload.AddPair('nomeAC',LTEFSistema);
   payload.AddPair('textoPinpad',LTEFTextoPinPad);
   payload.AddPair('versaoAC',LTEFSistemaVersao);
   payload.AddPair('nomeEstabelecimento',LTEFEstabelecimento);
   payload.AddPair('identificadorPontoCaptura',LTEFIdCliente);
   //---------------------------------------------------------------------------
   SA_SalvarLog('INICIALIZAR',payload.ToString,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);

   resultado := UTF8ToString(IniciarOperacaoTEF(PAnsiChar(AnsiString(payload.ToString))));
   RespJSON  := TJSonObject.ParseJSONValue(TEncoding.UTF8.GetBytes( resultado ),0) as TJSONValue;
   payload.Free;
   SA_SalvarLog('INICIALIZAR Resposta',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   codigoTEF := 0;
   try
      codigoTEF := RespJSON.GetValue<integer>('codigo',0);
   except
   end;
   //---------------------------------------------------------------------------
   try
      RespTEF     := RespJSON.GetValue<TJSONObject>('tef');      // Parsing na resposta
      Result      := (RespTEF.GetValue<string>('retorno','') = '1') and (codigoTEF=0);  // Pegando o resultado da operação
      LSequencial := RespTEF.GetValue<integer>('sequencial',0);  // Pegando o numero sequencial para gerir as operações
      RespTEF.Free;
   except
      Result      := false;
      LSequencial := 0;
   end;
   //---------------------------------------------------------------------------
end;

procedure TElginTEF.SA_MostramensagemT;
begin
   SA_Mostrar_Mensagem(true);
end;

procedure TElginTEF.SA_MostrarBtCancelarT;
begin
   SA_AtivarBTCancelar;   // Ativar o botão cancelar na tela de TEF
end;

function TElginTEF.SA_Opcoes(opcoes: string): TStringList;
var
   palavra : string;
begin
   Result := TStringList.Create;
   while pos(';',opcoes)>0 do
      begin
         palavra := copy(opcoes,1,pos(';',opcoes)-1);
         Delete(opcoes,1,length(palavra)+1);
         Result.Add(palavra);
      end;
   if opcoes<>'' then
      Result.Add(opcoes);
end;
//------------------------------------------------------------------------------
//   Processar PIX
//------------------------------------------------------------------------------
procedure TElginTEF.SA_PagamentoPIX;
var
   inicializar  : boolean;
   sair         : boolean; 
   resultado    : string;
   payload      : TJsonObject; // Objeto JSON para armazenar os dados da transação   
   RespReqTEF   : TTefRetorno; // Retorno da requisição inicial de pagamento
   //---------------------------------------------------------------------------   
   comprovanteDiferenciadoLoja     : TStringList;
   comprovanteDiferenciadoPortador : TStringList;
   //---------------------------------------------------------------------------
   opcoesColeta : TStringList;
   opcaoColeta  : integer;
   DadoColeta   : string;   // Dado obtido do operador para a coleta
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   //   Pagamento com  PIX
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpTEFELGIN;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LForma;
   frmwebtef.lbvalor.Caption  := transform(LValor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   //---------------------------------------------------------------------------
   TThread.CreateAnonymousThread(procedure
   begin
      //------------------------------------------------------------------------
      //  Iniciando THREAD para processar o PIX
      //   Inicializar TEF
      //------------------------------------------------------------------------
      TThread.Synchronize(TThread.CurrentThread,procedure
         begin
            frmwebtef.mensagem := 'Inicializando TEF...';
            SA_Mostrar_Mensagem(true);
         end);
      //------------------------------------------------------------------------
      inicializar := SA_Inicializar_TEF;
      //------------------------------------------------------------------------
      if not inicializar then
         begin
            resultado := UTF8ToString(FinalizarOperacaoTEF(1));
            SA_SalvarLog('Resposta FINALIZAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
            frmwebtef.mensagem := 'Erro na inicialização do TEF';
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,procedure
               begin
                  SA_Mostrar_Mensagem(true);
               end);
            //------------------------------------------------------------------
            SA_AtivarBTCancelar;
            while not frmwebtef.Cancelar do
               begin
                  sleep(30);
               end;
            //------------------------------------------------------------------
            lExecutando := false;
            frmwebtef.Close;
            frmwebtef.Release;
            //------------------------------------------------------------------
            exit;
         end;
      //------------------------------------------------------------------------
      inc(LSequencial);   // Incrementando o numero sequencial para realizar a chamada à DLL
      payload := TJsonObject.Create;
      payload.AddPair('sequencial', LSequencial.ToString);
      payload.AddPair('valorTotal', SA_Limpacampo(transform(LValor)));
      //------------------------------------------------------------------------
      TThread.Synchronize(TThread.CurrentThread,procedure
         begin
            frmwebtef.mensagem := 'Solicitando pagamento...';
            SA_Mostrar_Mensagem(true);
         end);
      //------------------------------------------------------------------------
      SA_SalvarLog('VENDER:',payload.ToString,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      resultado   := UTF8ToString(RealizarPixTEF(PAnsiChar(AnsiString(payload.ToString)), true));
      SA_SalvarLog('Resposta VENDER:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      //------------------------------------------------------------------------
      RespReqTEF  := SA_ParsingTEF(resultado);
      //------------------------------------------------------------------------
      sair := false;
      while not sair do   // Fazendo o fluxo do TEF
         begin
            //------------------------------------------------------------------
            if RespReqTEF.retorno='' then  // Não houve retorno do TEF
               begin
                  //------------------------------------------------------------
                  if (RespReqTEF.automacao_coleta_retorno<>'0') then
                     begin
                        //------------------------------------------------------
                        //  Mostrar mensagem, finalizar TEF e sair da rotina
                        //------------------------------------------------------
                        TThread.Synchronize(TThread.CurrentThread,procedure
                           begin
                              frmwebtef.mensagem := RespReqTEF.mensagemResultado;
                              SA_Mostrar_Mensagem(true);
                           end);
                        //------------------------------------------------------
                        resultado := UTF8ToString(FinalizarOperacaoTEF(1));
                        SA_SalvarLog('Resposta FINALIZAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                        //------------------------------------------------------
                        SA_AtivarBTCancelar;
                        //------------------------------------------------------
                        while not frmwebtef.Cancelar do
                           begin
                              sleep(10);
                           end;
                        //------------------------------------------------------
                        sair := true;
                        //------------------------------------------------------
                     end
                  else if RespReqTEF.automacao_coleta_retorno='0' then
                     begin
                        //------------------------------------------------------
                        //   Examinar TEF
                        //------------------------------------------------------
                        if (RespReqTEF.automacao_coleta_tipo='') then  // Tem que consultar
                           begin
                              //------------------------------------------------
                              //   Apresentar mensagem
                              //------------------------------------------------
                              if not pos('QRCODE;',RespReqTEF.mensagemResultado)=0 then  // Não é o QRCODE PIX imagem
                                 begin
                                    frmwebtef.mensagem := RespReqTEF.mensagemResultado;
                                    TThread.Synchronize(TThread.CurrentThread,procedure
                                       begin
                                          SA_Mostrar_Mensagem(true);
                                       end);
                                 end
                              else   // É QRCODE
                                 begin
                                    TThread.Synchronize(TThread.CurrentThread,procedure
                                       begin
                                          //------------------------------------
                                          //   Apresentar a mensagem de LER QRCODE
                                          //------------------------------------
                                          frmwebtef.mensagem := 'Faça a leitura do QRCODE no PINPAD ...';
                                          TThread.Synchronize(TThread.CurrentThread,procedure
                                             begin
                                                SA_Mostrar_Mensagem(true);
                                             end);
                                          //------------------------------------
//                                          SA_MostrarImagem(true);
//                                          PintarQRCode(SA_RecuperarQRCODE(RespReqTEF.mensagemResultado), frmwebtef.qrcode_pix.Picture.Bitmap, qrUTF8BOM);
                                       end);
                                 end;
                              //------------------------------------------------
                              //  Consultar TEF
                              //------------------------------------------------
                              payload := TJsonObject.Create;
                              payload.AddPair('automacao_coleta_retorno',RespReqTEF.automacao_coleta_retorno);
                              payload.AddPair('automacao_coleta_sequencial',RespReqTEF.automacao_coleta_sequencial);
                              //------------------------------------------------
                              SA_SalvarLog('CONSULTA PIX:',payload.ToString,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                              //------------------------------------------------
                              resultado   := UTF8ToString( RealizarPixTEF(PAnsiChar(AnsiString(payload.ToString)), false));
                              //------------------------------------------------
                              SA_SalvarLog('Resposta CONSULTA PIX:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                              //------------------------------------------------
                              RespReqTEF  := SA_ParsingTEF(resultado);
                              //------------------------------------------------
                           end
                        else if (RespReqTEF.automacao_coleta_tipo<>'') and (RespReqTEF.automacao_coleta_opcao<>'') then  // Tem que consultar
                           begin
                              //------------------------------------------------
                              //  Criar menu de opções
                              //------------------------------------------------
                               opcoesColeta := SA_Opcoes(RespReqTEF.automacao_coleta_opcao);
                               //---------------------------------------------------
                               frmwebtef.mensagem := RespReqTEF.mensagemResultado;
                               frmwebtef.opcoes   := opcoesColeta;
                               frmwebtef.opcao    := -1;
                               frmwebtef.tecla    := '';
                               frmwebtef.Cancelar := false;
                               //---------------------------------------------------
                               TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                               TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                               //---------------------------------------------------
                               opcaoColeta  := SA_PerguntarOpcoes(opcoesColeta,RespReqTEF.mensagemResultado);   // Apanhando a opção do menu
                               if opcaoColeta<>-1 then
                                  DadoColeta   := opcoesColeta[opcaoColeta-1]  // Obtendo dado para a coleta
                               else
                                  DadoColeta   := '';   // Definindo o valor vazio para coleta
                               //---------------------------------------------------
                               TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                               TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                              if DadoColeta<>'' then   // Tem que enviar a resposta
                                 begin
                                    //------------------------------------------
                                    //  Enviara a requisição
                                    //------------------------------------------
                                    payload := TJsonObject.Create;
                                    payload.AddPair('automacao_coleta_retorno', RespReqTEF.automacao_coleta_retorno);
                                    payload.AddPair('automacao_coleta_sequencial', RespReqTEF.automacao_coleta_sequencial);
                                    payload.AddPair('automacao_coleta_informacao', DadoColeta);
                                    //------------------------------------------
                                    SA_SalvarLog('EVIAR TIPO PIX:',payload.ToString,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                                    //------------------------------------------
                                    resultado   := UTF8ToString( RealizarPixTEF(PAnsiChar(AnsiString(payload.ToString)), false));
                                    //------------------------------------------
                                    SA_SalvarLog('Resposta EVIAR TIPO PIX:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                                    //------------------------------------------
                                    RespReqTEF  := SA_ParsingTEF(resultado);
                                    //------------------------------------------
                                 end
                              else
                                 begin
                                    //------------------------------------------
                                    //  Cancelar a operação
                                    //------------------------------------------
                                    payload := TJsonObject.Create;
                                    payload.AddPair('automacao_coleta_retorno', '9');
                                    //------------------------------------------
                                    SA_SalvarLog('CANCELAR PIX:',payload.ToString,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                                    //------------------------------------------
                                    resultado   := UTF8ToString( RealizarPixTEF(PAnsiChar(AnsiString(payload.ToString)), false));
                                    //------------------------------------------
                                    SA_SalvarLog('Resposta CANCELAR PIX:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                                    //------------------------------------------
                                    resultado := UTF8ToString(FinalizarOperacaoTEF(1));
                                    //------------------------------------------
                                    RespReqTEF  := SA_ParsingTEF(resultado);
                                    SA_SalvarLog('Resposta FINALIZAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                           end;
                        //------------------------------------------------------
                     end;

                  //------------------------------------------------------------
               end
            else if RespReqTEF.retorno='0' then   // Houve resposta da transação
               begin
                  //------------------------------------------------------------
                  //   Processar o retorno do TEF PIX
                  //   Capturar os dados da transação em BD
                  //------------------------------------------------------------
                  LRetornoTEF.NSU              := RespReqTEF.nsuTerminal;
                  LRetornoTEF.Nome_do_Produto  := RespReqTEF.tipoCartao;
                  LRetornoTEF.cAut             := RespReqTEF.codigoAutorizacao;
                  LRetornoTEF.rede             := RespReqTEF.nomeProvedor;
                  LRetornoTEF.Bandeira         := RespReqTEF.nomeBandeira;
                  LRetornoTEF.CNPJAdquirente   := RespReqTEF.cnpjCredenciadora;
                  //------------------------------------------------------------
                  resultado   := UTF8ToString(ConfirmarOperacaoTEF(LSequencial,1));  // Confirmar operação
                  //------------------------------------------------------------
                  SA_SalvarLog('Resposta CONFIRMAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                  //------------------------------------------------------------
                  resultado := UTF8ToString(FinalizarOperacaoTEF(1));   // Finalizando a transação
                  //------------------------------------------------------------
                  SA_SalvarLog('Resposta FINALIZAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                  //------------------------------------------------------------
                  //   TEF confirmado
                  //------------------------------------------------------------
                  if RespReqTEF.comprovanteDiferenciadoLoja<>'' then
                     begin
                        if LComprovanteLoja<>tpTEFNaoImprimir then
                           begin
                              TpComprovanteImprimir            := tpLoja;
                              comprovanteDiferenciadoLoja      := TStringList.Create;
                              comprovanteDiferenciadoLoja.Text := StringReplace(RespReqTEF.comprovanteDiferenciadoLoja,'\r\n',#13,[rfReplaceAll, rfIgnoreCase]);
                              if LComprovanteLoja=tpTEFImprimirSempre then
                                 SA_ImprimirTexto(comprovanteDiferenciadoLoja.Text,LImpressora)
                              else if LComprovanteLoja=tpTEFPerguntar then
                                 begin
                                    //------------------------------------------
                                    //   Perguntar se quer imprimir
                                    //------------------------------------------
                                    opcoesColeta := TStringList.Create;
                                    opcoesColeta.Add('Imprimir');
                                    opcoesColeta.Add('Não Imprimir');
                                    frmwebtef.mensagem := 'Imprimir o comprovante da LOJA ?';
                                    frmwebtef.opcoes   := opcoesColeta;
                                    frmwebtef.opcao    := -1;
                                    frmwebtef.tecla    := '';
                                    frmwebtef.Cancelar := false;
                                    //------------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                     //-----------------------------------------
                                     while (not frmwebtef.Cancelar) do
                                        begin
                                          if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                             begin
                                                //------------------------------
                                                SA_ImprimirTexto(comprovanteDiferenciadoLoja.Text,LImpressora); //   Executar a impressão
                                                frmwebtef.Cancelar := true;
                                                //------------------------------
                                             end
                                          else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                             frmwebtef.Cancelar := true;
                                           //-----------------------------------
                                           sleep(50);
                                        end;
                                    //------------------------------------------
                                 end;
                              comprovanteDiferenciadoLoja.Free;
                           end;
                     end;
                  if RespReqTEF.comprovanteDiferenciadoPortador<>'' then
                     begin
                        if LComprovanteCliente<>tpTEFNaoImprimir then
                           begin
                              TpComprovanteImprimir                := tpCliente;
                              comprovanteDiferenciadoPortador      := TStringList.Create;
                              comprovanteDiferenciadoPortador.Text := StringReplace(RespReqTEF.comprovanteDiferenciadoPortador,'\r\n',#13,[rfReplaceAll, rfIgnoreCase]);
                              if LComprovanteCliente=tpTEFImprimirSempre then
                                 SA_ImprimirTexto(comprovanteDiferenciadoPortador.Text,LImpressora) //  Imprimir automático
                              else
                                 begin
                                    //------------------------------------------
                                    //  Criar menu de imprimir
                                    //------------------------------------------
                                    opcoesColeta := TStringList.Create;
                                    opcoesColeta.Add('Imprimir');
                                    opcoesColeta.Add('Não Imprimir');
                                    frmwebtef.mensagem := 'Imprimir o comprovante do CLIENTE ?';
                                    frmwebtef.opcoes   := opcoesColeta;
                                    frmwebtef.opcao    := -1;
                                    frmwebtef.tecla    := '';
                                    frmwebtef.Cancelar := false;
                                    //------------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                     //-----------------------------------------
                                     while (not frmwebtef.Cancelar) do
                                        begin
                                          if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                             begin
                                                //------------------------------
                                                //   Executar a impressão
                                                //------------------------------
                                                SA_ImprimirTexto(comprovanteDiferenciadoPortador.Text,LImpressora);
                                                frmwebtef.Cancelar := true;
                                                //------------------------------
                                             end
                                          else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                             frmwebtef.Cancelar := true;
                                           //-----------------------------------
                                           sleep(50);
                                        end;
                                    //------------------------------------------
                                 end;
                              comprovanteDiferenciadoPortador.Free;
                           end;
                     end;
                  //------------------------------------------------------------
                  sair := true;
                  //------------------------------------------------------------
               end;
            //------------------------------------------------------------------
         end;
      //------------------------------------------------------------------------
      //   Fechando a janela do TEF
      //------------------------------------------------------------------------
      frmwebtef.Close;
      frmwebtef.Release;
      lExecutando := false;
      //---------------------------------------------------------------------------

   end).Start;
   //---------------------------------------------------------------------------
end;

function TElginTEF.SA_ParsingTEF(conteudo: string): TTefRetorno;
var
   JSONConteudo : TJSONValue;
   JSONTef      : TJSONValue;
   MensagemOP   : string;
begin
   //---------------------------------------------------------------------------
   try
      JSONConteudo := TJSonObject.ParseJSONValue(TEncoding.UTF8.GetBytes( conteudo ),0) as TJSONValue;
   except
      exit;
   end;
   //---------------------------------------------------------------------------
   try
      MensagemOP               := JSONConteudo.GetValue<string>('mensagem','');
      Result.retorno           := inttostr(JSONConteudo.GetValue<integer>('codigo',9));
      Result.mensagemResultado := JSONConteudo.GetValue<string>('mensagem','');
   except
   end;
   //---------------------------------------------------------------------------
   try
      JSONTef      := JSONConteudo.GetValue<TJSONObject>('tef',nil);
   except
      exit;
   end;
   if JSONTef=nil then
      exit;
   //---------------------------------------------------------------------------
   Result.linhasMensagemRetorno           := TStringList.Create;
   Result.automacao_coleta_opcao          := JSONTef.GetValue<string>('automacao_coleta_opcao','');
   Result.automacao_coleta_palavra_chave  := JSONTef.GetValue<string>('automacao_coleta_palavra_chave','');
   Result.automacao_coleta_retorno        := JSONTef.GetValue<string>('automacao_coleta_retorno','');
   Result.automacao_coleta_sequencial     := JSONTef.GetValue<string>('automacao_coleta_sequencial','');
   Result.automacao_coleta_tipo           := JSONTef.GetValue<string>('automacao_coleta_tipo','');
   Result.automacao_coleta_mascara        := JSONTef.GetValue<string>('automacao_coleta_mascara','');
   Result.mensagemResultado               := JSONTef.GetValue<string>('mensagemResultado','');
   Result.cnpjCredenciadora               := JSONTef.GetValue<string>('cnpjCredenciadora','');
   Result.codigoAutorizacao               := JSONTef.GetValue<string>('codigoAutorizacao','');
   Result.comprovanteDiferenciadoLoja     := JSONTef.GetValue<string>('comprovanteDiferenciadoLoja','');
   Result.comprovanteDiferenciadoPortador := JSONTef.GetValue<string>('comprovanteDiferenciadoPortador','');
   Result.dataHoraTransacao               := JSONTef.GetValue<string>('dataHoraTransacao','');
   Result.formaPagamento                  := JSONTef.GetValue<string>('formaPagamento','');
   Result.identificadorEstabelecimento    := JSONTef.GetValue<string>('identificadorEstabelecimento','');
   Result.identificadorPontoCaptura       := JSONTef.GetValue<string>('identificadorPontoCaptura','');
   Result.loja                            := JSONTef.GetValue<string>('loja','');
   Result.nomeBandeira                    := JSONTef.GetValue<string>('nomeBandeira','');
   Result.nomeEstabelecimento             := JSONTef.GetValue<string>('nomeEstabelecimento','');
   Result.nomeProduto                     := JSONTef.GetValue<string>('nomeProduto','');
   Result.nomeProvedor                    := JSONTef.GetValue<string>('nomeProvedor','');
   Result.nsuTerminal                     := JSONTef.GetValue<string>('nsuTerminal','');
   Result.nsuTransacao                    := JSONTef.GetValue<string>('nsuTransacao','');
   Result.panMascarado                    := JSONTef.GetValue<string>('panMascarado','');
   Result.resultadoTransacao              := JSONTef.GetValue<string>('resultadoTransacao','');
   Result.retorno                         := JSONTef.GetValue<string>('retorno','');
   Result.sequencial                      := JSONTef.GetValue<string>('sequencial','');
   Result.servico                         := JSONTef.GetValue<string>('servico','');
   Result.tipoCartao                      := JSONTef.GetValue<string>('tipoCartao','');
   Result.transacao                       := JSONTef.GetValue<string>('transacao','');
   Result.uniqueID                        := JSONTef.GetValue<string>('uniqueID','');
   Result.valorTotal                      := JSONTef.GetValue<string>('valorTotal','');
   Result.linhasMensagemRetorno           := SA_RecuperarLinhasMensagem(Result.mensagemResultado);
   //---------------------------------------------------------------------------
   JSONConteudo.Free;
   //---------------------------------------------------------------------------
end;

function TElginTEF.SA_PerguntarOpcoes(opcoes: TStringList;mensagem:string): integer;
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

procedure TElginTEF.SA_ProcessarPagamento;
var
   inicializar  : boolean;
   resultado    : string;
   payload      : TJsonObject; // Objeto JSON para armazenar os dados da transação
   RespReqTEF   : TTefRetorno; // Retorno da requisição inicial de pagamento
   RespConsTEF  : TTefRetorno; // Retorno da requisição inicial de pagamento
   retorno      : string;
   sair         : boolean;
   //---------------------------------------------------------------------------
   comprovanteDiferenciadoLoja     : TStringList;
   comprovanteDiferenciadoPortador : TStringList;
   ImprimirComprovante             : boolean;
   //---------------------------------------------------------------------------
   opcoesColeta : TStringList;
   opcaoColeta  : integer;
   //---------------------------------------------------------------------------
   Consultar_TEF : boolean;
   //---------------------------------------------------------------------------
   Qtde_Parcelas : string;
   //---------------------------------------------------------------------------
   PagamentoELGIN : TPagamentoELGIN;
begin
   //---------------------------------------------------------------------------
   //   Iniciando a tela de TEF
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpTEFELGIN;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LForma;
   frmwebtef.lbvalor.Caption  := transform(LValor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   //---------------------------------------------------------------------------
   TThread.CreateAnonymousThread(procedure
   begin
      //---------------------------------------------------------------------------
      //   Inicializar TEF
      //---------------------------------------------------------------------------
      frmwebtef.mensagem := 'Inicializando TEF...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      //---------------------------------------------------------------------------
      inicializar := SA_Inicializar_TEF;
      //---------------------------------------------------------------------------
      if not inicializar then
         begin
            resultado := UTF8ToString(FinalizarOperacaoTEF(1));
            SA_SalvarLog('FINALIZAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
            frmwebtef.mensagem := 'Erro na inicialização do TEF';
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            //---------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
            while not frmwebtef.Cancelar do
               begin
                  sleep(50);
               end;
            //---------------------------------------------------------------------
            lExecutando := false;
            frmwebtef.Close;
            frmwebtef.Release;
            //---------------------------------------------------------------------
            exit;
         end;
      //------------------------------------------------------------------------
      ///   Processar o pagamento
      //------------------------------------------------------------------------
      PagamentoELGIN := SA_DefinirPagamentoELGIN(LFormaPgto);   // Criar as formas de como chamar a DLL
      inc(LSequencial);   // Incrementando o numero sequencial para realizar a chamada à DLL
      payload := TJsonObject.Create;
      payload.AddPair('sequencial', LSequencial.ToString);
      payload.AddPair('valorTotal', SA_Limpacampo(transform(LValor)));
      if PagamentoELGIN.FormaPgtoPAYLOAD<>'' then
         payload.AddPair('formaPagamento', PagamentoELGIN.FormaPgtoPAYLOAD);
      if PagamentoELGIN.tpFinPAYLOAD<>'' then
         payload.AddPair('tipoFinanciamento', PagamentoELGIN.tpFinPAYLOAD);
      if LQtdeParcelas>0 then
         payload.AddPair('transacao_parcela', LQtdeParcelas.ToString);
      //---------------------------------------------------------------------------
      frmwebtef.mensagem := 'Solicitando pagamento...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      //---------------------------------------------------------------------------
      SA_SalvarLog('VENDER:',payload.ToString,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      resultado   := UTF8ToString(RealizarPagamentoTEF( PagamentoELGIN.tipoCartao , PAnsiChar(AnsiString(payload.ToString)), True));
      SA_SalvarLog('Resposta VENDER',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
      RespReqTEF  := SA_ParsingTEF(resultado);
      retorno     := RespReqTEF.retorno;  // Pegar o retorno
      //---------------------------------------------------------------------------
      if ((strtointdef(retorno,0)>=1) and (strtointdef(retorno,0)<=8)) or (retorno='-1') then   // Ocorreu um erro que exige a finalização da operação
         begin
            //---------------------------------------------------------------------
            //   Mostrar a mensagem de erro na tela
            //---------------------------------------------------------------------
            resultado := UTF8ToString(FinalizarOperacaoTEF(1)); // Finalizando a operação de TEF
            SA_SalvarLog('Resposta FINALIZAR TEF:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);   // Salvar LOG
            if RespReqTEF.mensagemResultado<>'' then   // Se o TEF mandou exibir alguma mensagem
               frmwebtef.mensagem := RespReqTEF.mensagemResultado
            else   // Sem mensagem nenhuma, criando uma padrão
               frmwebtef.mensagem := 'Ocorreu erro na requisição de pagamento...';
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
            while not frmwebtef.Cancelar do   // Esperando que o operador cancelar
               begin
                  sleep(50);
               end;
            //---------------------------------------------------------------------
         end
      else if strtointdef(retorno,0)=9 then   // Ocorreu um erro que requer o cancelamento da operação
         begin
            //---------------------------------------------------------------------
            //  Mostrar a mensagem do TEF na tela
            //---------------------------------------------------------------------
            if RespReqTEF.mensagemResultado<>'' then   // Se o TEF mandou exibir alguma mensagem
               frmwebtef.mensagem := RespReqTEF.mensagemResultado
            else   // Sem mensagem nenhuma, criando uma padrão
               frmwebtef.mensagem := 'Ocorreu erro na requisição de pagamento...';
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            //---------------------------------------------------------------------
            payload := TJsonObject.Create;
            payload.AddPair('sequencial', LSequencial.ToString);  // Executando o cancelamento
            payload.AddPair('automacao_coleta_retorno', '9');
            //---------------------------------------------------------------------
            SA_SalvarLog('CANCELAR:',payload.ToString,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
            //---------------------------------------------------------------------
            resultado   := UTF8ToString(RealizarPagamentoTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
            //---------------------------------------------------------------------
            SA_SalvarLog('Resposta CANCELAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
            //---------------------------------------------------------------------
            resultado := UTF8ToString(FinalizarOperacaoTEF(1));   // Finalizando a transação
            SA_SalvarLog('Resposta FINALIZAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
            //---------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
            while not frmwebtef.Cancelar do   // Esperando que o operador cancelar
               begin
                  sleep(50);
               end;
            //---------------------------------------------------------------------
         end
      else if strtointdef(retorno,0)=0 then   //   É necessário ficar monitorando e fazer coleta
         begin
            //---------------------------------------------------------------------
            RespConsTEF         := RespReqTEF;
            RespConsTEF.retorno := '';
            //---------------------------------------------------------------------
            //   Fazendo LOOP de consulta no TEF
            //---------------------------------------------------------------------
            sair               := false;
            frmwebtef.tecla    := '';
            frmwebtef.Cancelar := false;
            Consultar_TEF      := true;
            while not sair do
               begin
                  //---------------------------------------------------------------
                  if RespConsTEF.retorno='' then  // É pra continuar fazendo leitura
                     begin
                        //---------------------------------------------------------
                        if RespConsTEF.automacao_coleta_tipo='N' then   // Tem que digitar um valor numérico
                           begin
                              //---------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,
                               procedure
                                  begin
                                     SA_ColetarValor(RespConsTEF.mensagemResultado,'',false);
                                  end);
                              //---------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              frmwebtef.AceitaVazio   := true;
                              Qtde_Parcelas           := '';
                              while (Qtde_Parcelas='') and (not frmwebtef.Cancelar) do
                                 begin
                                    //---------------------------------------------
                                    sleep(10);
                                    //---------------------------------------------
                                    if (frmwebtef.dado_digitado<>'') and (strtointdef(frmwebtef.dado_digitado,0)>=2) and (strtointdef(frmwebtef.dado_digitado,0)<=99) or (length(frmwebtef.dado_digitado)>2)  then
                                       Qtde_Parcelas := frmwebtef.dado_digitado
                                    else if (frmwebtef.dado_digitado<>'') then
                                       begin
                                          frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                          frmwebtef.pnalerta.Color        := clRed;
                                          frmwebtef.pnalerta.Font.Color   := clYellow;
                                          frmwebtef.dado_digitado         := '';
                                       end;
                                    //---------------------------------------------
                                 end;
                              //------------------------------------------------
                              if Qtde_Parcelas='&*&' then
                                 Qtde_Parcelas := '';
                              //------------------------------------------------
                              frmwebtef.pncaptura.Visible := false;
                              frmwebtef.edtdado.Enabled   := false;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //---------------------------------------------------
                              if not frmwebtef.Cancelar then
                                 begin
                                    frmwebtef.mensagem := 'Enviando dados ao TEF';
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    //---------------------------------------------
                                    SA_SalvarLog('COLETA:','{"automacao_coleta_sequencial":"'+RespConsTEF.automacao_coleta_sequencial+'","automacao_coleta_retorno":"'+RespConsTEF.automacao_coleta_retorno+'","automacao_coleta_informacao":"'+Qtde_Parcelas+'"}',GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                                    //---------------------------------------------
                                    resultado   := UTF8ToString(RealizarPagamentoTEF( 0 , PAnsiChar(AnsiString('{"automacao_coleta_sequencial":"'+RespConsTEF.automacao_coleta_sequencial+'","automacao_coleta_retorno":"'+RespConsTEF.automacao_coleta_retorno+'","automacao_coleta_informacao":"'+Qtde_Parcelas+'"}')), false));
                                    //---------------------------------------------
                                    SA_SalvarLog('Resposta COLETA:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                                    //---------------------------------------------
                                    RespconsTEF   := SA_ParsingTEF(resultado);
                                    Consultar_TEF := false;
                                    //---------------------------------------------
                                    frmwebtef.mensagem := RespconsTEF.mensagemResultado;
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    //---------------------------------------------
                                 end;
                              //---------------------------------------------------
                           end
                        else if (RespConsTEF.automacao_coleta_tipo='X') and (RespConsTEF.automacao_coleta_opcao<>'') then // Criar menu de opções string
                           begin
                              //----------------------------------------------------
                              //    Fazer a coleta das opções
                              //----------------------------------------------------
                              opcoesColeta := SA_Opcoes(RespConsTEF.automacao_coleta_opcao);
                              //----------------------------------------------------
                              frmwebtef.mensagem := RespConsTEF.mensagemResultado;
                              frmwebtef.opcoes   := opcoesColeta;
                              frmwebtef.opcao    := -1;
                              frmwebtef.tecla    := '';
                              frmwebtef.Cancelar := false;
                              //----------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                              //----------------------------------------------------
                              application.ProcessMessages;
                              opcaoColeta  := SA_PerguntarOpcoes(opcoesColeta,RespConsTEF.mensagemResultado);
                              //----------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //---------------------------------------------------
                              if opcaoColeta<>-1 then
                                 begin
                                    //----------------------------------------------
                                    payload := TJsonObject.Create;
                                    payload.AddPair('automacao_coleta_sequencial', RespConsTEF.automacao_coleta_sequencial);
                                    payload.AddPair('automacao_coleta_retorno', RespConsTEF.automacao_coleta_retorno);
                                    payload.AddPair('automacao_coleta_informacao', opcoesColeta[opcaoColeta-1]);
                                    //----------------------------------------------
                                    SA_SalvarLog('COLETA:',payload.ToString,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                                    //----------------------------------------------
                                    resultado   := UTF8ToString(RealizarPagamentoTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
                                    //----------------------------------------------
                                    SA_SalvarLog('Resposta COLETA:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                                    //----------------------------------------------
                                    RespconsTEF  := SA_ParsingTEF(resultado);
                                    Consultar_TEF := false;
                                    //----------------------------------------------
                                 end;
                              opcoesColeta.Free;
                              //-----------------------------------------------------
                           end
                        else if (RespConsTEF.automacao_coleta_tipo='X') and (RespConsTEF.automacao_coleta_opcao='') then // Coletar informação string do teclado
                           begin
                              //------------------------------------------------
                              // Criar uma tela para digitar os dados
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              TThread.Synchronize(TThread.CurrentThread,
                              procedure
                                 begin
                                    SA_ColetarValor(RespConsTEF.mensagemResultado,'',RespConsTEF.automacao_coleta_palavra_chave='transacao_administracao_senha');
                                 end);
                              //------------------------------------------------
                              Qtde_Parcelas           := '';
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              while (frmwebtef.dado_digitado='') and(not frmwebtef.Cancelar) do
                                 begin
                                    sleep(10);
                                 end;
                              Qtde_Parcelas   := frmwebtef.dado_digitado;
                              frmwebtef.pncaptura.Visible := false;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                              payload := TJsonObject.Create;
                              payload.AddPair('automacao_coleta_sequencial', RespConsTEF.automacao_coleta_sequencial);
                              payload.AddPair('automacao_coleta_retorno', RespConsTEF.automacao_coleta_retorno);
                              payload.AddPair('automacao_coleta_informacao', Qtde_Parcelas);
                              //------------------------------------------------
                              SA_SalvarLog('COLETA:',payload.ToString,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                              //------------------------------------------------
                              resultado   := UTF8ToString(RealizarPagamentoTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
                              //------------------------------------------------
                              SA_SalvarLog('Resposta COLETA:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                              //------------------------------------------------
                              RespconsTEF  := SA_ParsingTEF(resultado);
                              Consultar_TEF := false;
                              //------------------------------------------------
                              frmwebtef.mensagem := RespconsTEF.mensagemResultado;
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              //------------------------------------------------
                           end
                        else if RespConsTEF.automacao_coleta_tipo='D' then // Coletar informação DATA do teclado
                           begin
                              //----------------------------------------------------
                              //   Coletar Data do operador
                              //----------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              TThread.Synchronize(TThread.CurrentThread,procedure
                                 begin
                                    SA_ColetarValor(RespConsTEF.mensagemResultado,'99/99/9999',false);
                                 end);
                              //---------------------------------------------------
                              frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              Qtde_Parcelas           := '';
                              while (Qtde_Parcelas='') and (not frmwebtef.Cancelar) do
                                 begin
                                    //---------------------------------------------
                                    sleep(10);
                                    //---------------------------------------------
                                    if (frmwebtef.dado_digitado<>'') and (DataValida(frmwebtef.dado_digitado)) then
                                       Qtde_Parcelas := frmwebtef.dado_digitado
                                    else if (frmwebtef.dado_digitado<>'') then
                                       begin
                                          frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                          frmwebtef.pnalerta.Color        := clRed;
                                          frmwebtef.pnalerta.Font.Color   := clYellow;
                                          frmwebtef.dado_digitado         := '';
                                       end;
                                    //---------------------------------------------
                                 end;
                              //---------------------------------------------------
                              frmwebtef.pncaptura.Visible := false;
                              frmwebtef.edtdado.Enabled   := false;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //---------------------------------------------------
                              if DataValida(Qtde_Parcelas) then
                                 begin
                                    frmwebtef.mensagem := 'Enviando dados ao TEF';
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    payload := TJsonObject.Create;
                                    payload.AddPair('automacao_coleta_sequencial', RespConsTEF.automacao_coleta_sequencial);
                                    payload.AddPair('automacao_coleta_retorno', RespConsTEF.automacao_coleta_retorno);
                                    payload.AddPair('automacao_coleta_informacao', Qtde_Parcelas);
                                    //---------------------------------------------
                                    SA_SalvarLog('COLETA:',payload.ToString,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                                    //---------------------------------------------
                                    resultado   := UTF8ToString(RealizarPagamentoTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
                                    //---------------------------------------------
                                    SA_SalvarLog('Resposta COLETA:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                                    //---------------------------------------------
                                    RespconsTEF  := SA_ParsingTEF(resultado);
                                    Consultar_TEF := false;
                                    //---------------------------------------------
                                    frmwebtef.mensagem := RespconsTEF.mensagemResultado;
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    //---------------------------------------------
                                 end;
                              //----------------------------------------------------
                           end
                        else   // Apenas esperar e fazer a apresentação da mensagem
                           begin
                              //---------------------------------------------------
                              if RespConsTEF.mensagemResultado<>'' then
                                 begin
                                    frmwebtef.mensagem := RespConsTEF.mensagemResultado;
                                    if RespConsTEF.linhasMensagemRetorno.Count>1 then
                                       begin
                                          frmwebtef.mensagem  := '';
                                          frmwebtef.mensagem1 := trim(RespConsTEF.linhasMensagemRetorno[0]);
                                          frmwebtef.mensagem2 := trim(RespConsTEF.linhasMensagemRetorno[1]);
                                       end;
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    Consultar_TEF := true;
                                 end;
                              //---------------------------------------------------
                              if RespConsTEF.automacao_coleta_retorno='9' then
                                 begin
                                    //---------------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                    while not frmwebtef.Cancelar do   // Esperando que o operador cancelar
                                       begin
                                          sleep(50);
                                       end;
                                    //---------------------------------------------
                                    sair          := true;
                                    //---------------------------------------------
                                 end;
                              //---------------------------------------------------
                           end;
                        //---------------------------------------------------------
                     end
                  else    //   Operação deve ser encerrada
                     begin
                        //---------------------------------------------------------
                        if ((strtointdef(RespConsTEF.retorno,0)>=2) and (strtointdef(RespConsTEF.retorno,0)<=9)) or (RespConsTEF.retorno = '-1') then //   Ocorreu um erro que necessita finalizar a operação TEF
                           begin
                              //---------------------------------------------------
                              sair    := true;
                              //---------------------------------------------------
                              if RespConsTEF.retorno='9' then
                                 begin
                                    //---------------------------------------------
                                    resultado   := UTF8ToString(ConfirmarOperacaoTEF(LSequencial,0));
                                    //---------------------------------------------
                                    SA_SalvarLog('Resposta CANCELAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                                    //---------------------------------------------
                                 end;
                              //---------------------------------------------------
                              resultado := UTF8ToString(FinalizarOperacaoTEF(1));   // Finalizando a transação
                              //---------------------------------------------------
                              SA_SalvarLog('Resposta FINALIZAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                              //---------------------------------------------------
                              if RespConsTEF.mensagemResultado<>'' then
                                 frmwebtef.mensagem := RespConsTEF.mensagemResultado
                              else
                                 frmwebtef.mensagem := 'Ocorreu um erro na transação TEF...';
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              while not frmwebtef.Cancelar do   // Esperando que o operador cancelar
                                 begin
                                    sleep(50);
                                 end;
                              //---------------------------------------------------
                           end
                        else if RespConsTEF.retorno='0' then  // Operação finalizada com sucesso
                           begin
                              //------------------------------------------------
                              //   Capturar os dados da transação em BD
                              //------------------------------------------------
                              LRetornoTEF.Status          := true;
                              LRetornoTEF.NSU             := RespConsTEF.nsuTerminal;
                              LRetornoTEF.Nome_do_Produto := RespConsTEF.tipoCartao;
                              LRetornoTEF.cAut            := RespConsTEF.codigoAutorizacao;
                              LRetornoTEF.rede            := RespConsTEF.nomeProvedor;
                              LRetornoTEF.Bandeira        := RespConsTEF.nomeBandeira;
                              LRetornoTEF.CNPJAdquirente  := RespConsTEF.cnpjCredenciadora;
                              LRetornoTEF.ComprovanteLoja := RespConsTEF.comprovanteDiferenciadoLoja;
                              LRetornoTEF.ComprovanteCli  := RespConsTEF.comprovanteDiferenciadoPortador;
                              LRetornoTEF.ComprovanteRed  := SA_GerarComprovanteSimplificado.Text;
                              //------------------------------------------------
                              LdataHoraTransacao := RespConsTEF.dataHoraTransacao;
                              LSequencial        := strtointdef(RespConsTEF.sequencial,0);
                              //---------------------------------------------------
                              resultado   := UTF8ToString(ConfirmarOperacaoTEF(LSequencial,1));  // Confirmar operação
                              //---------------------------------------------------
                              SA_SalvarLog('Resposta CONFIRMAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                              //---------------------------------------------------
                              resultado := UTF8ToString(FinalizarOperacaoTEF(1));   // Finalizando a transação
                              //---------------------------------------------------
                              SA_SalvarLog('Resposta FINALIZAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                              //---------------------------------------------------
                              //   TEF confirmado
                              //---------------------------------------------------
                              if LRetornoTEF.ComprovanteLoja<>'' then
                                 begin
                                    if LComprovanteLoja<>tpTEFNaoImprimir then
                                       begin
                                          TpComprovanteImprimir            := tpLoja;
                                          comprovanteDiferenciadoLoja      := TStringList.Create;
                                          comprovanteDiferenciadoLoja.Text := StringReplace(LRetornoTEF.ComprovanteLoja,'\r\n',#13,[rfReplaceAll, rfIgnoreCase]);
                                          if LComprovanteLoja=tpTEFImprimirSempre then
                                             begin
                                                if LViaLojaSimplificada then
                                                   SA_ImprimirTexto(SA_GerarComprovanteSimplificado.Text,LImpressora)
                                                else  // Impressão do comprovante do lojista normal
                                                   SA_ImprimirTexto(SA_ResumirComprovante(comprovanteDiferenciadoLoja).Text,LImpressora);
                                             end
                                          else if LComprovanteLoja=tpTEFPerguntar then
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
                                                 //--------------------------------
                                                while (not frmwebtef.Cancelar) do
                                                   begin
                                                     if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                        begin
                                                           //---------------------
                                                           //   Executar a impressão
                                                           //---------------------
                                                           if LViaLojaSimplificada then
                                                              SA_ImprimirTexto(SA_GerarComprovanteSimplificado.Text,LImpressora)
                                                           else
                                                              SA_ImprimirTexto(SA_ResumirComprovante(comprovanteDiferenciadoLoja).Text,LImpressora);
                                                           //-------------------
                                                        end
                                                     else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                                        frmwebtef.Cancelar := true;
                                                      //--------------------------
                                                      sleep(50);
                                                   end;
                                                //------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                             end;
                                          comprovanteDiferenciadoLoja.Free;
                                       end;
                                 end;
                              //------------------------------------------------
                              if LRetornoTEF.ComprovanteCli<>'' then
                                 begin
                                    if LComprovanteCliente<>tpTEFNaoImprimir then
                                       begin
                                          TpComprovanteImprimir                := tpCliente;
                                          comprovanteDiferenciadoPortador      := TStringList.Create;
                                          comprovanteDiferenciadoPortador.Text := StringReplace(LRetornoTEF.ComprovanteCli,'\r\n',#13,[rfReplaceAll, rfIgnoreCase]);
                                          if LComprovanteCliente=tpTEFImprimirSempre then  //  Imprimir automaticamente
                                             SA_ImprimirTexto(comprovanteDiferenciadoPortador.Text,LImpressora)
                                          else
                                             begin
                                                //---------------------------------
                                                //  Criar menu de imprimir
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
                                                //--------------------------------
                                                while (not frmwebtef.Cancelar) do
                                                   begin
                                                     if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                        SA_ImprimirTexto(comprovanteDiferenciadoPortador.Text,LImpressora)
                                                     else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                                        frmwebtef.Cancelar := true;
                                                      //--------------------------
                                                      sleep(50);
                                                   end;

                                                //------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                             end;
                                          comprovanteDiferenciadoPortador.Free;
                                       end;
                                 end;
                              //---------------------------------------------------
                              sair := true;
                              //---------------------------------------------------
                           end;
                        //---------------------------------------------------------
                     end;
                  //---------------------------------------------------------------
                  //***************************************************************
                  //---------------------------------------------------------------
                  if (not sair) and (Consultar_TEF) then   // Se não é pra parar o LOOP, então faz nova leitura
                     begin
                        //---------------------------------------------------------
                        sleep(100);
                        //---------------------------------------------------------
                        payload := TJsonObject.Create;
                        payload.AddPair('automacao_coleta_retorno',RespConsTEF.automacao_coleta_retorno);
                        payload.AddPair('automacao_coleta_sequencial',RespConsTEF.automacao_coleta_sequencial);
                        payload.AddPair('sequencial', LSequencial.ToString);
                        //---------------------------------------------------------
                        SA_SalvarLog('CONSULTA:',payload.ToString,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                        //---------------------------------------------------------
                        resultado   := UTF8ToString(RealizarPagamentoTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
                        //---------------------------------------------------------
                        SA_SalvarLog('Resposta CONSULTA:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                        //---------------------------------------------------------
                        RespConsTEF  := SA_ParsingTEF(resultado);
                        //---------------------------------------------------------
                     end;
                  //---------------------------------------------------------------
                  if frmwebtef.Cancelar then
                     begin
                        //---------------------------------------------------------
                        sair := true;
                        //---------------------------------------------------------
                        if RespConsTEF.retorno='9' then
                           begin
                              //---------------------------------------------------
                              resultado   := UTF8ToString(ConfirmarOperacaoTEF(LSequencial,0));
                              //---------------------------------------------------
                              SA_SalvarLog('Resposta CANCELAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                              //---------------------------------------------------
                           end;
                        //---------------------------------------------------------
                        resultado := UTF8ToString(FinalizarOperacaoTEF(1));   // Finalizando a transação
                        //---------------------------------------------------------
                        SA_SalvarLog('Resposta FINALIZAR:',resultado,GetCurrentDir+'\TEF_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
                        //---------------------------------------------------------
                     end;

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

function TElginTEF.SA_RecuperarLinhasMensagem(mensagem:string): TStringList;
var
   d      : integer;
   linhas : TStringList;
begin
   Result      := TStringList.Create;
   linhas      := TStringList.Create;
   linhas.Text := mensagem;
   for d := 1 to linhas.Count do
      begin
         if trim(linhas[d-1])<>'' then
            Result.Add(linhas[d-1]);
      end;
   linhas.Free;

end;

function TElginTEF.SA_ResumirComprovante(texto: TStringList): TStringList;
var
   d : integer;
begin
   Result := TStringList.Create;
   for d := 1 to texto.Count do
      begin
         if trim(texto[d-1])<>'' then
            begin
               if trim(texto[d-1])<>'------------------------------------' then
                  Result.Add(copy(texto[d-1]+StringOfChar(' ',40),1,40))

            end;

      end;
end;

function TElginTEF.SA_tpOperacaoADMToInt(tipo: ttpOperacaoADM): integer;
begin
   Result := 0;
   case tipo of
     tpOpPerguntar    : Result := 0;
     tpOpCancelamento : Result := 1;
     tpOpPendencias   : Result := 2;
     tpOpReimpressao  : Result := 3;
   end;
end;

end.
