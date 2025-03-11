unit uVSPague;

interface

uses
   udmMulticlass,
   synacode,
   vcl.dialogs,
   System.Threading,
   IdBaseComponent,
   IdComponent,
   IdTCPConnection,
   IdTCPClient,
   ACBrPosPrinter,
   uKSTypes,
   vcl.forms,
   Vcl.Graphics,
   uMulticlassFuncoes,
   System.SysUtils,
   system.DateUtils,
   system.Classes,
   uwebtefmp;

type
   //---------------------------------------------------------------------------
   TVSRetornoInicializar = record   // Para demontar o retorno da inicialização do TEF
      Versao     : string;
      Sequencial : string;
      retorno    : string;
      Servico    : string;
      Aplicacao  : string;
      Estado     : string;
      Mensagem   : string;
   end;
   TVSRetornoFinalizar = record   // Para demontar o retorno de finalizar processo de TEF
      Sequencial                          : string;
      Retorno                             : string;
      Servico                             : string;
      automacao_coleta_mensagem           : string;
      automacao_coleta_retorno            : string;
      automacao_coleta_sequencial         : string;
      automacao_coleta_transacao_resposta : string;
   end;
   TVSRetornoSolicitacaoCancelamento = record
      servico                     : string;
      sequencial                  : string;
      transacao_nsu               : string;
      retorno                     : string;
      transacao                   : string;
      mensagem                    : string;
      transacao_codigo_vspague    : string;
      transacao_pagamento         : string;
      transacao_autorizacao       : string;
      transacao_rede              : string;
      transacao_comprovante_2via  : string;
      transacao_comprovante_1via  : string;
      ComprovanteLoja             : string;  // Comprovante simplificado do lojista
      transacao_vencimento        : string;
      transacao_administradora    : string;
      transacao_identificacao     : string;
      transacao_valor             : string;
      transacao_tipo_cartao       : string;
      transacao_data              : string;
      automacao_coleta_mensagem   : string;
      automacao_coleta_retorno    : string;
      automacao_coleta_tipo       : string;
      automacao_coleta_sequencial : string;
      automacao_coleta_mascara    : string;
      automacao_coleta_opcao      : TstringList;
   end;
   TVSRetornoSolicitacaoVenda = record
      Transacao                      : string;
      Sequencial                     : string;
      Retorno                        : string;
      Servico                        : string;
      mensagem                       : string;
      Transacao_nsu                  : string;
      Transacao_codigo_vspague       : string;
      Transacao_Pagamento            : string;
      Transacao_autorizacao          : string;
      Transacao_rede                 : string;
      Transacao_Comprovante1via      : string;
      Transacao_Comprovante2via      : string;
      ComprovanteLoja                : string;  // Comprovante simplificado do lojista
      Transacao_vencimento           : string;
      Transacao_administradora       : string;
      Transacao_identificacao        : string;
      Transacao_valor                : string;
      Transacao_tipo_cartao          : string;
      Transacao_data                 : string;
      transacao_produto              : string;
      transacao_rede_cnpj            : string;
      transacao_payment_id           : string;
      automacao_coleta_mensagem      : string;
      automacao_coleta_retorno       : string;
      automacao_coleta_sequencial    : string;
      automacao_coleta_palavra_chave : string;
      automacao_coleta_timeout       : string;
      automacao_coleta_opcao         : TStringList;
      automacao_coleta_tipo          : string;
      automacao_coleta_mascara       : string;
   end;
   TVSRetornoSolicitacaoPIX = record
      estabelecimento                : string;
      loja                           : string;
      mensagem                       : string;
      retorno                        : string;
      sequencial                     : string;
      servico                        : string;
      terminal                       : string;
      transacao                      : string;
      transacao_autorizacao          : string;
      transacao_resposta             : string; //="TO"
      Transacao_codigo_vspague       : string;
      transacao_pagamento            : string;
      Transacao_Comprovante_1via     : string;
      Transacao_Comprovante_2via     : string;
      ComprovanteLoja                : string;  // Comprovante simplificado do lojista
      transacao_data                 : string;
      transacao_nsu                  : string;
      transacao_produto              : string;
      transacao_rede                 : string;
      transacao_rede_cnpj            : string;
      transacao_valor                : string;
      transacao_payment_id           : string;
      automacao_coleta_opcao         : TStringList;
      automacao_coleta_mascara       : string;
      automacao_coleta_mensagem      : string;
      automacao_coleta_palavra_chave : string;
      automacao_coleta_retorno       : string;
      automacao_coleta_sequencial    : string;
      automacao_coleta_tipo          : string;
      automacao_coleta_mensagem_tipo : string;
      QRCode                         : string;
   end;
   TVSRetornoConfirmacao = record
      Sequencial                    : string;
      Servico                       : string;
      Retorno                       : string;
      Transacao                     : string;
      Mensagem                      : string;
   end;
   TRetornoPendencias = record   // Para fazer o tratamento das pendências
      automacao_coleta_mensagem   : string;
      automacao_coleta_tipo       : string;
      automacao_coleta_retorno    : string;
      automacao_coleta_sequencial : string;
      transacao_pagamento         : string;
      transacao_codigo_vspague    : string;
      transacao_autorizacao       : string;
      transacao_produto           : string;
      transacao_data              : string;
      transacao_administradora    : string;
      transacao                   : string;
      transacao_rede              : string;
      transacao_valor             : string;
      transacao_financiado        : string;
      transacao_tipo_cartao       : string;
      transacao_parcela           : string;
      transacao_nsu               : string;
      automacao_coleta_opcao      : string;
   end;
   //---------------------------------------------------------------------------
   TRetornoExtrato = record   // Para fazer o tratamento do extrato
      retorno                       : string;
      sequencial                    : string;
      servico                       : string;
      transacao                     : string;
      mensagem                      : string;
      transacao_comprovante_1via    : string;
      transacao_data_extrato        : string;
      transacao_pagamento           : string;
      transacao_rede                : string;
      transacao_valor               : string;
      transacao_valor_saque         : string;
      transacao_valor_taxa_embarque : string;
      transacao_valor_taxa_servico  : string;
      transacao_vencimento          : string;
      automacao_coleta_mascara      : string;
      automacao_coleta_mensagem     : string;
      automacao_coleta_retorno      : string;
      automacao_coleta_sequencial   : string;
      automacao_coleta_tipo         : string;
      automacao_coleta_informacao   : string;
      automacao_coleta_opcao        : TStringList;
   end;
   //---------------------------------------------------------------------------
   TVSPagueTEF = class
     Private
         //---------------------------------------------------------------------
         LImpressora : TKSConfigImpressora;  // Configuração da impressora
         //---------------------------------------------------------------------
         LIdTCPClient             : TIdTCPClient;                      // Conexão para comunicar com o VSPAgue
         LRetornoInicializar      : TVSRetornoInicializar;             // Retorno da inicialização
         LRetornoFinalizar        : TVSRetornoFinalizar;               // Retorno da finalização
         LRetornoSolicitacaoVenda : TVSRetornoSolicitacaoVenda;        // Retorno da solicitação da venda
         LRetornoConfirmacaoVenda : TVSRetornoConfirmacao;             // Retorno da confirmação da venda
         LRetornoCancelamento     : TVSRetornoSolicitacaoCancelamento; // Retorno de cancelamento de venda
//         LRetornoConfirmaCanc     : TVSRetornoConfirmacao;             // Retorno da confirmação do cancelamento
         LRetornoSolicitacaoPIX   : TVSRetornoSolicitacaoPIX;          // Retorno da transação PIX
         LRetornoConfirmaPIX      : TVSRetornoConfirmacao;             // Retorno da confirmação do cancelamento
         LRetornoPendencias       : TRetornoPendencias;                // Retorno do tratamento de pendências
         LNumeroTEF               : integer;                           // Para salvar no Banco de dados
         LTurno                   : integer;                           // Numero do turno
         LRetornoExtrato          : TRetornoExtrato;                   // Retorno do tratamento do extrato
         //---------------------------------------------------------------------
         lExecutando      : boolean;
         LSalvarLog       : boolean;
         LVersao          : string;
         LSequencial      : integer;
         LAplicacao       : string;
         LEstabelecimento : string;
         LLoja            : string;
         LTerminal        : string;
         //---------------------------------------------------------------------
         LPagamento_Forma        : string;
         LPagamento_Valor        : real;
         LPagamento_Operacao     : TtpVSPagueFormaPgto;
         LPagamento_QtdeParcelas : integer;
         LCancelamentoData       : TDateTime;
         LCancelamentoValor      : real;
         LCancelamentoNSU        : string;
         LVSPagueImpressaoViaCLI : TtpTEFImpressao;
         LVSPagueImpressaoViaLJ  : TtpTEFImpressao;
         LImpressaoSimplificada  : boolean;
         LTEFAprovado            : boolean;
         LExecutouCancelamento   : boolean;
         //---------------------------------------------------------------------
         function SA_LerRespostaVSPague    : string;
         function SA_LerRespostaVSPaguePIX  : string;
         function SA_VSExtrairTag(tag,texto : string):string;
         function SA_TextoForma(FormaPgto:TtpVSPagueFormaPgto):string;
         function SA_MensagenErroRetornoTEF(CodigoRetorno:string = ''):string;
         function SA_ParsingRetornoVenda(texto:string):TVSRetornoSolicitacaoVenda;
         function SA_ParsingRetornoCancelamento(texto:string):TVSRetornoSolicitacaoCancelamento;
         function SA_ParsingRetornoPIX(texto: string): TVSRetornoSolicitacaoPIX;
         function SA_PerguntarOpcoes(opcoes : integer): integer;
         function SA_DataValida(data:string):boolean;
         function SA_ValidarOpcao(valor : string;lista:TStringList):boolean;
         function transform(valor:real):string;
         function SA_ParsingRetornoConfirmar(texto: string): TVSRetornoConfirmacao;
         procedure SA_SalvarLog(titulo,dado: string);
         procedure SA_EnviarVSPAgue(texto : string);
         procedure SA_Finalizar;
         Procedure SA_Inicializar;
         procedure SA_ParsingRetornoInicializar(texto:string);
         procedure SA_ParsingRetornoFinalizar(texto:string);
         function SA_ParsingRetornoExtrato(texto:string):TRetornoExtrato;

         procedure MythreadEnd(sender: tobject);
         procedure SA_EnviarVenda;
         procedure SA_CancelarVenda;
         procedure SA_ConfirmarVenda;
         procedure SA_ConfirmarPIX;
//         procedure SA_ConfirmarCancelamento;
         procedure SA_NaoConfirmarVenda;
         procedure SA_PagamentoPIX;
         procedure SA_CancelamentoPIX;
         procedure SA_ConfirmarCancelamentoPIX;
         procedure SA_MostramensagemT;
         procedure SA_MostrarBtCancelarT;
         procedure SA_CriarMenuT;
         procedure SA_DesativarMenuT;
         procedure SA_DesativarBtCancelarT;
         procedure SA_EnviarVPendencias;
         procedure SA_EnviarExtrato;

      Public
         //---------------------------------------------------------------------
         constructor Create();
         destructor Destroy(); override;
         procedure SA_ProcessarPagamentoVS;
         procedure SA_ProcessarCancelamentoVS;
         procedure SA_ProcessarPagamentoPIXVS;
         procedure SA_ProcessarCancelamentoPIXVS;
         procedure SA_ProcessarPendenciasVS;
         procedure SA_ProcessarExtratoVS;
         //---------------------------------------------------------------------
         property Impressora              : TKSConfigImpressora               read LImpressora              write LImpressora;  // Configuração da impressora
         //---------------------------------------------------------------------
         property Pagamento_Forma         : string                            read LPagamento_Forma          write LPagamento_Forma;
         property Pagamento_Valor         : real                              read LPagamento_Valor          write LPagamento_Valor;
         property Pagamento_Operacao      : TtpVSPagueFormaPgto               read LPagamento_Operacao       write LPagamento_Operacao;  // Metodo de pagamento
         property Pagamento_QtdeParcelas  : integer                           read LPagamento_QtdeParcelas   write LPagamento_QtdeParcelas;
         property CancelamentoData        : TDateTime                         read LCancelamentoData         write LCancelamentoData;
         property CancelamentoValor       : real                              read LCancelamentoValor        write LCancelamentoValor;
         property CancelamentoNSU         : string                            read LCancelamentoNSU          write LCancelamentoNSU;
         property ImpressaoViaCliente     : TtpTEFImpressao                   read LVSPagueImpressaoViaCLI   write LVSPagueImpressaoViaCLI;
         property ImpressaoViaLoja        : TtpTEFImpressao                   read LVSPagueImpressaoViaLJ    write LVSPagueImpressaoViaLJ;
         property ImpressaoSimplificada   : boolean                           read LImpressaoSimplificada    write LImpressaoSimplificada;
         property Executando              : boolean                           read lExecutando               write lExecutando;
         property TEFAprovado             : boolean                           read LTEFAprovado              write LTEFAprovado;
         property ExecutouCancelamento    : boolean                           read LExecutouCancelamento     write LExecutouCancelamento;
         property RetornoSolicitacaoVenda : TVSRetornoSolicitacaoVenda        read LRetornoSolicitacaoVenda;
         property RetornoSolicitacaoPIX   : TVSRetornoSolicitacaoPIX          read LRetornoSolicitacaoPIX    write LRetornoSolicitacaoPIX; // Retorno da transação PIX
         property RetornoCancelamento     : TVSRetornoSolicitacaoCancelamento read LRetornoCancelamento      write LRetornoCancelamento; // Retorno de cancelamento de venda
         property RetornoPendencias       : TRetornoPendencias                read LRetornoPendencias        write LRetornoPendencias;                // Retorno do tratamento de pendências
         //---------------------------------------------------------------------
         property SalvarLog       : boolean    read LSalvarLog       write LSalvarLog;
         //---------------------------------------------------------------------
         property Versao          : string     read LVersao          write LVersao;
         property Sequencial      : integer    read LSequencial      write LSequencial;
         property Aplicacao       : string     read LAplicacao       write LAplicacao;
         property Estabelecimento : string     read LEstabelecimento write LEstabelecimento;
         property Loja            : string     read LLoja            write LLoja;
         property Terminal        : string     read LTerminal        write LTerminal;
         //---------------------------------------------------------------------
   end;
   //---------------------------------------------------------------------------
implementation

{ TVSPagueTEF }


constructor TVSPagueTEF.Create;
begin
   //---------------------------------------------------------------------------
   LVSPagueImpressaoViaCLI     := tpTEFPerguntar;
   LVSPagueImpressaoViaLJ      := tpTEFPerguntar;
   LIdTCPClient                := TIdTCPClient.create;
   LIdTCPClient.host           := '127.0.0.1';
   LIdTCPClient.port           := 60906;
   LIdTCPClient.connecttimeout := 30000;
   LIdTCPClient.readtimeout    := 30000;
   //---------------------------------------------------------------------------
   lExecutando           := true;
   LExecutouCancelamento := false;
   //---------------------------------------------------------------------------
   inherited;
   //---------------------------------------------------------------------------
end;



destructor TVSPagueTEF.Destroy;
begin
   //---------------------------------------------------------------------------
   LIdTCPClient.free;
   //---------------------------------------------------------------------------
   inherited;
end;


function TVSPagueTEF.SA_LerRespostaVSPague : string;
var
   ok : boolean;
begin
   try
      Result := LIdTCPClient.Socket.ReadLnRFC(Ok,VSPague_Terminador);
   except on e:exception do
      begin
         SA_SalvarLog('ERRO LEITURA MENSAGEM:',e.Message);
      end;
   end;
end;


function TVSPagueTEF.SA_LerRespostaVSPaguePIX: string;
var
   texto   : ansistring;
   sair    : boolean;
   //---------------------------------------------------------------------------
   leitura : TStringStream;
begin
   leitura := TStringStream.create;
   try
      sair    := false;
      while not sair do
         begin
            LIdTCPClient.readtimeout    := 1000;
            LIdTCPClient.Socket.ReadStream(leitura, 1);
            texto := ansistring(leitura.Datastring);
            if pos(VSPague_Terminador,string(texto))>0 then
               sair := true;
         end;
   except on e:exception do
      begin
         SA_SalvarLog('ERRO LEITURA MENSAGEM:',e.Message);
      end;
   end;
   result := string(texto);
end;


function TVSPagueTEF.SA_MensagenErroRetornoTEF(CodigoRetorno:string = ''): string;
begin
   result := '';
   if CodigoRetorno = '' then
      CodigoRetorno := LRetornoInicializar.retorno;
   case strtointdef(CodigoRetorno,0) of
      2:result := 'Sequencial inválido.';
      3:result := 'Transação cancelada pelo operador.';
      4:result := 'Transação cancelada pelo cliente.';
      5:result := 'Parâmetros insuficientes ou inválidos.';
      6:result := 'Problemas de comunicação entre VSPagueCliente e VSPagueServer.';
      7:result := 'Problema entre o VSPagueServer  a rede.';
      8:result := 'Tempo expirado.';
      9:result := 'Erro não catalogado.';
   end;
end;

procedure TVSPagueTEF.SA_NaoConfirmarVenda;
var
   texto    : string;
   resposta : string;
begin
   inc(LSequencial);  // Incrementando a variável "sequencial"
   texto := 'sequencial="'+Lsequencial.tostring+'"'+#13+
            'servico="executar"'+#13+
            'retorno="9"'+#13+
            'transacao="Cartao Vender"';
   SA_SalvarLog('NAO CONFIRMAR',texto);               // Salvando log
   SA_EnviarVSPAgue(texto);                       // Enviando a solicitação de não confirmar
   resposta := SA_LerRespostaVSPague;             // Recebendo o retorno do envio
   SA_SalvarLog('RESPOSTA NAO CONFIRMAR:',resposta);  // Salvando o LOG

end;


procedure TVSPagueTEF.SA_CancelamentoPIX;
var
   texto : string;
   Vltef : string;
begin
   //---------------------------------------------------------------------------
   Vltef := trim(FormatFloat('#####0.00',LCancelamentoValor));
   Vltef := stringreplace(Vltef,',','.',[rfReplaceAll]);
   //---------------------------------------------------------------------------
   inc(LSequencial);  // Incrementando o sequencial
   //---------------------------------------------------------------------------
   texto := 'retorno="1"'+#13+
            'sequencial="'+LSequencial.tostring+'"'+#13+
            'servico="executar"'+#13+
            'transacao="Administracao Cancelar"'+#13+
            'transacao_data="'+formatdatetime('dd/mm/yyyy',LCancelamentoData)+'"'+#13+
            'transacao_nsu="'+LCancelamentoNSU+'"'+#13+
            'transacao_valor="'+Vltef+'"';
   //---------------------------------------------------------------------------
   SA_SalvarLog('SOLICITAR CANCELAMENTO PIX',texto); // Salvar LOG
   //---------------------------------------------------------------------------
   SA_EnviarVSPAgue(texto);
   //---------------------------------------------------------------------------
end;

procedure TVSPagueTEF.SA_CancelarVenda;
var
   texto : string;
   VlStr : string;
begin
   //---------------------------------------------------------------------------
   inc(LSequencial);  // Incrementando o sequencial
   //---------------------------------------------------------------------------
   VlStr := trim(FormatFloat('#####0.00',LCancelamentoValor));
   VlStr := stringreplace(vlstr,',','.',[rfReplaceAll]);
   texto := 'sequencial="'+LSequencial.tostring+'"'+#13+
            'retorno="1"'+#13+
            'servico="executar"'+#13+
            'transacao="Administracao Cancelar"'+#13+            'transacao_data="'+formatdatetime('dd/MM/yyyy HH:mm:ss',lcancelamentoData)+'"'+#13+            'transacao_nsu="'+lcancelamentonsu+'"'+#13+            'transacao_valor="'+VlStr+'"';   //---------------------------------------------------------------------------
   SA_SalvarLog('SOLICITAR CANCELAMENTO DE VENDA',texto); // Salvar LOG
   //---------------------------------------------------------------------------
   SA_EnviarVSPAgue(texto);  // Enviando a solicitação de venda ao VSPague
   //---------------------------------------------------------------------------
end;
procedure TVSPagueTEF.SA_ConfirmarCancelamentoPIX;
var
   texto    : string;
   resposta : string;
begin
   texto := 'retorno="0"'+#13+
            'transacao="Administracao Cancelar"'+#13+
            'servico="executar"'+#13+
            'sequencial="'+LRetornoSolicitacaoPIX.sequencial+'"';
   SA_SalvarLog('CONFIRMAR CANCELAMENTO PIX',texto);                   // Salvando log
   SA_EnviarVSPAgue(texto);                                            // Enviando a solicitação de confirmar
   resposta := SA_LerRespostaVSPague;                                  // Recebendo o retorno do envio
   SA_SalvarLog('RESPOSTA CONFIRMAR CANCELAMENTO PIX:',resposta);      // Salvando o LOG
   LRetornoConfirmaPIX := SA_ParsingRetornoConfirmar(resposta);        // Desmontando a respostaend;
end;

procedure TVSPagueTEF.SA_ConfirmarPIX;
var
   texto    : string;
   resposta : string;
begin
   texto := 'retorno="0"'+#13+
            'transacao="Digital Pagar"'+#13+
            'servico="executar"'+#13+
            'sequencial="'+LRetornoSolicitacaoPIX.sequencial+'"';
   SA_SalvarLog('CONFIRMAR PGTO PIX',texto);                       // Salvando log
   SA_EnviarVSPAgue(texto);                                        // Enviando a solicitação de confirmar
   resposta := SA_LerRespostaVSPague;                              // Recebendo o retorno do envio
   SA_SalvarLog('RESPOSTA CONFIRMAR PGTO PIX:',resposta);          // Salvando o LOG
   LRetornoConfirmaPIX := SA_ParsingRetornoConfirmar(resposta);    // Desmontando a respostaend;
end;

procedure TVSPagueTEF.SA_ConfirmarVenda;
var
   texto    : string;
   resposta : string;
begin
   texto := 'sequencial="'+Lsequencial.tostring+'"'+#13+
            'servico="executar"'+#13+
            'retorno="0"'+#13+
            'transacao="Cartao Vender"';
   SA_SalvarLog('CONFIRMAR',texto);               // Salvando log
   SA_EnviarVSPAgue(texto);                       // Enviando a solicitação de confirmar
   resposta := SA_LerRespostaVSPague;             // Recebendo o retorno do envio
   SA_SalvarLog('RESPOSTA CONFIRMAR:',resposta);  // Salvando o LOG
   LRetornoConfirmacaoVenda := SA_ParsingRetornoConfirmar(resposta);          // Desmontando a respostaend;
end;

function TVSPagueTEF.SA_DataValida(data: string): boolean;
begin
   try
      strtodate(data);
      Result := true;
   except
      Result := false;
   end;
end;


procedure TVSPagueTEF.SA_EnviarVSPAgue(texto : string);
begin
   try
      //------------------------------------------------------------------------
      LIdTCPClient.Socket.WriteLnRFC(texto);
      //------------------------------------------------------------------------
   except on e:exception do
      begin
         SA_SalvarLog('ERRO ENVIO MENSAGEM:',texto+#13+e.Message);
      end;
   end;
end;

procedure TVSPagueTEF.SA_Finalizar;
var
   texto    : string;
   resposta : string;
begin
   inc(LSequencial);  // Incrementando a variável "sequencial"
   texto := 'sequencial="'+Lsequencial.tostring+'"'+#13+
            'retorno="1"'+#13+
            'servico="finalizar"';
   SA_SalvarLog('FINALIZAR',texto);               // Salvando log
   SA_EnviarVSPAgue(texto);                       // Enviando a solicitação de finalizar
   resposta := SA_LerRespostaVSPague;             // Recebendo o retorno do envio
   SA_SalvarLog('RESPOSTA FINALIZAR:',resposta);  // Salvando o LOG
   SA_ParsingRetornoFinalizar(resposta);          // Desmontando a resposta
end;


procedure TVSPagueTEF.SA_Inicializar;
var
   texto            : string;
   resposta         : string;
begin
   inc(lSequencial);
   texto := 'versao="'+LVersao+'"'+#13+
            'sequencial="'+LSequencial.tostring+'"'+#13+
            'retorno="1"'+#13+
            'servico="iniciar"'+#13+
            'aplicacao="'+Laplicacao+'"'+#13+
            'estabelecimento="'+Lestabelecimento+'"'+#13+
            'loja="'+Lloja+'"'+#13+
            'terminal="'+Lterminal+'"';
   SA_SalvarLog('INICIALIZAR TEF',texto);              //  Salvar LOG de inicialização
   SA_EnviarVSPAgue(texto);                    //  Enviando o texto para o VSPAgue
   resposta := SA_LerRespostaVSPague;          // Fazendo a leitura do retorno
   SA_SalvarLog('RESPOSTA INICIALIZAR TEF',resposta); // Salvando LOG de retorno
   SA_ParsingRetornoInicializar(resposta);     // Desmontando o retorno para o RECORD
   lSequencial := strtointdef(LRetornoInicializar.Sequencial,1);
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------

procedure TVSPagueTEF.SA_PagamentoPIX;
var
   texto : string;
   Vltef : string;
begin
   //---------------------------------------------------------------------------
   Vltef := trim(FormatFloat('#####0.00',LPagamento_Valor));
   Vltef := stringreplace(Vltef,',','.',[rfReplaceAll]);
   inc(lSequencial);
   //---------------------------------------------------------------------------
   inc(LSequencial);  // Incrementando o sequencial
   //---------------------------------------------------------------------------
   texto := 'retorno="1"'+#13+
            'sequencial="'+LSequencial.tostring+'"'+#13+
            'servico="executar"'+#13+
            'transacao="Digital Pagar"'+#13+
            'transacao_modalidade_pagamento="PIX"'+#13+
            'transacao_valor="'+Vltef+'"';
   //---------------------------------------------------------------------------
   SA_SalvarLog('SOLICITAR VENDA PIX',texto); // Salvar LOG
   //---------------------------------------------------------------------------
   SA_EnviarVSPAgue(texto);
   //---------------------------------------------------------------------------
end;

function TVSPagueTEF.SA_ParsingRetornoCancelamento(texto: string): TVSRetornoSolicitacaoCancelamento;
var
   linhas  : tstringlist;
   d       : integer;
   i       : integer;
   posicao : integer;
   linha   : string;
   tmpstr  : string;
begin
   //---------------------------------------------------------------------------
   result.automacao_coleta_opcao := TStringList.create;
   //---------------------------------------------------------------------------
   linhas      := tstringlist.Create;
   linhas.text := texto;
   for d := 1 to linhas.count do
      begin
         posicao := pos('="',linhas[d-1]);
        if copy(linhas[d-1],1,posicao-1)='transacao' then
            result.Transacao                     := SA_VSExtrairTag('transacao',linhas[d-1])
         else if copy(linhas[d-1],1,posicao-1)='sequencial' then
            result.Sequencial                    := SA_VSExtrairTag('sequencial',linhas[d-1])
         else if copy(linhas[d-1],1,posicao-1)='retorno' then
            result.Retorno                       := SA_VSExtrairTag('retorno',linhas[d-1])
         else if copy(linhas[d-1],1,posicao-1)='servico' then
            result.Servico                       := SA_VSExtrairTag('servico',linhas[d-1])
         else if copy(linhas[d-1],1,posicao-1)='mensagem' then
            begin
               result.mensagem                      := copy(linhas[d-1],10,length(linhas[d-1])-9);
               result.mensagem                      := stringreplace(result.mensagem,'""',#13,[rfReplaceAll, rfIgnoreCase]);
            end
         else if copy(linhas[d-1],1,posicao-1)='automacao_coleta_opcao' then
            begin
               linha   := copy(linhas[d-1],24,length(linhas[d-1])-23);
               tmpstr  := '';
               for I := 1 to length(linha) do
                  begin
                     if linha[i]<>'"' then
                        tmpstr  := tmpstr  + linha[i];
                  end;
               result.automacao_coleta_opcao.text := stringreplace(tmpstr,';',#13,[rfReplaceAll, rfIgnoreCase]);
            end;
      end;
   result.Transacao_nsu                  := SA_VSExtrairTag('transacao_nsu',texto);
   result.Transacao_codigo_vspague       := SA_VSExtrairTag('transacao_codigo_vspague',texto);
   result.Transacao_Pagamento            := SA_VSExtrairTag('transacao_pagamento',texto);
   result.Transacao_autorizacao          := SA_VSExtrairTag('transacao_autorizacao',texto);
   result.Transacao_rede                 := SA_VSExtrairTag('transacao_rede',texto);
   result.transacao_comprovante_1via     := SA_VSExtrairTag('transacao_comprovante_1via',texto);
   result.transacao_comprovante_2via     := SA_VSExtrairTag('transacao_comprovante_2via',texto);
   result.Transacao_vencimento           := SA_VSExtrairTag('transacao_vencimento',texto);
   result.Transacao_administradora       := SA_VSExtrairTag('transacao_administradora',texto);
   result.Transacao_identificacao        := SA_VSExtrairTag('transacao_identificacao',texto);
   result.Transacao_valor                := SA_VSExtrairTag('transacao_valor',texto);
   result.Transacao_tipo_cartao          := SA_VSExtrairTag('transacao_tipo_cartao',texto);
   result.Transacao_data                 := SA_VSExtrairTag('transacao_data',texto);
   result.automacao_coleta_mensagem      := SA_VSExtrairTag('automacao_coleta_mensagem',texto);
   result.automacao_coleta_retorno       := SA_VSExtrairTag('automacao_coleta_retorno',texto);
   result.automacao_coleta_sequencial    := SA_VSExtrairTag('automacao_coleta_sequencial',texto);
   result.automacao_coleta_tipo          := SA_VSExtrairTag('automacao_coleta_tipo',texto);
   result.automacao_coleta_mascara       := SA_VSExtrairTag('automacao_coleta_mascara',texto);
   result.ComprovanteLoja                := '';
   if result.transacao_comprovante_1via<>'' then
      begin
         result.ComprovanteLoja               := '<ce><e>COMPROVANTE TEF</e><ae></lf>'+
                                                 '<ce><e>Via Lojista</e><ae></lf>'+
                                                 '   Realizada em   '+result.Transacao_data+'</lf>'+
                                                 '       Valor R$   '+result.Transacao_valor +'</lf>'+
                                                 '     Forma Pgto   '+LPagamento_Forma+'</lf>'+
                                                 '            NSU   '+result.Transacao_nsu+'</lf>'+
                                                 '       Bandeira   '+result.Transacao_rede+'</lf>';
      end;
   //---------------------------------------------------------------------------
end;


function TVSPagueTEF.SA_ParsingRetornoConfirmar(texto:string): TVSRetornoConfirmacao;
begin
   result.Sequencial := SA_VSExtrairTag('sequencial',texto);
   result.Servico    := SA_VSExtrairTag('servico',texto);
   result.retorno    := SA_VSExtrairTag('retorno',texto);
   result.Transacao  := SA_VSExtrairTag('transacao',texto);
   result.Mensagem   := SA_VSExtrairTag('mensagem',texto);
end;

function TVSPagueTEF.SA_ParsingRetornoExtrato(texto: string): TRetornoExtrato;
var
   linhas  : tstringlist;
   d       : integer;
   i       : integer;
   posicao : integer;
   linha   : string;
   tmpstr  : string;
begin
   result.automacao_coleta_opcao := TStringList.create;
   linhas      := tstringlist.Create;
   linhas.text := texto;
   for d := 1 to linhas.count do
      begin
         posicao := pos('="',linhas[d-1]);
        if copy(linhas[d-1],1,posicao-1)='transacao' then
            result.Transacao                     := SA_VSExtrairTag('transacao',linhas[d-1])
         else if copy(linhas[d-1],1,posicao-1)='sequencial' then
            result.Sequencial                    := SA_VSExtrairTag('sequencial',linhas[d-1])
         else if copy(linhas[d-1],1,posicao-1)='retorno' then
            result.Retorno                       := SA_VSExtrairTag('retorno',linhas[d-1])
         else if copy(linhas[d-1],1,posicao-1)='servico' then
            result.Servico                       := SA_VSExtrairTag('servico',linhas[d-1])
         else if copy(linhas[d-1],1,posicao-1)='mensagem' then
            begin
               result.mensagem                      := copy(linhas[d-1],10,length(linhas[d-1])-9);
               result.mensagem                      := stringreplace(result.mensagem,'""',#13,[rfReplaceAll, rfIgnoreCase]);
            end
         else if copy(linhas[d-1],1,posicao-1)='automacao_coleta_opcao' then
            begin
               linha   := copy(linhas[d-1],24,length(linhas[d-1])-23);
               tmpstr  := '';
               for I := 1 to length(linha) do
                  begin
                     if linha[i]<>'"' then
                        tmpstr  := tmpstr  + linha[i];
                  end;
               result.automacao_coleta_opcao.text := stringreplace(tmpstr,';',#13,[rfReplaceAll, rfIgnoreCase]);
            end;
      end;
   //---------------------------------------------------------------------------
   result.transacao_comprovante_1via       := SA_VSExtrairTag('transacao_comprovante_1via',texto);
   result.transacao_data_extrato           := SA_VSExtrairTag('transacao_data_extrato',texto);
   result.transacao_pagamento              := SA_VSExtrairTag('transacao_pagamento',texto);
   result.transacao_rede                   := SA_VSExtrairTag('transacao_rede',texto);
   result.transacao_valor                  := SA_VSExtrairTag('transacao_valor',texto);
   result.transacao_valor_saque            := SA_VSExtrairTag('transacao_valor_saque',texto);
   result.transacao_valor_taxa_embarque    := SA_VSExtrairTag('transacao_valor_taxa_embarque',texto);
   result.transacao_valor_taxa_servico     := SA_VSExtrairTag('transacao_valor_taxa_servico',texto);
   result.transacao_vencimento             := SA_VSExtrairTag('transacao_vencimento',texto);
   result.automacao_coleta_mascara         := SA_VSExtrairTag('automacao_coleta_mascara',texto);
   result.automacao_coleta_mensagem        := SA_VSExtrairTag('automacao_coleta_mensagem',texto);
   result.automacao_coleta_retorno         := SA_VSExtrairTag('automacao_coleta_retorno',texto);
   result.automacao_coleta_sequencial      := SA_VSExtrairTag('automacao_coleta_sequencial',texto);
   result.automacao_coleta_tipo            := SA_VSExtrairTag('automacao_coleta_tipo',texto);
   result.automacao_coleta_informacao      := SA_VSExtrairTag('automacao_coleta_informacao',texto);
end;

procedure TVSPagueTEF.SA_ParsingRetornoFinalizar(texto: string);
begin
   //---------------------------------------------------------------------------
   LRetornoFinalizar.Sequencial                          := SA_VSExtrairTag('sequencial',texto);
   LRetornoFinalizar.retorno                             := SA_VSExtrairTag('retorno',texto);
   LRetornoFinalizar.Servico                             := SA_VSExtrairTag('servico',texto);
   LRetornoFinalizar.automacao_coleta_mensagem           := SA_VSExtrairTag('automacao_coleta_mensagem',texto);
   LRetornoFinalizar.automacao_coleta_retorno            := SA_VSExtrairTag('automacao_coleta_retorno',texto);
   LRetornoFinalizar.automacao_coleta_sequencial         := SA_VSExtrairTag('automacao_coleta_sequencial',texto);
   LRetornoFinalizar.automacao_coleta_transacao_resposta := SA_VSExtrairTag('automacao_coleta_transacao_resposta',texto);
   //---------------------------------------------------------------------------
end;

procedure TVSPagueTEF.SA_ParsingRetornoInicializar(texto:string);
begin
   //---------------------------------------------------------------------------
   LRetornoInicializar.Versao     := SA_VSExtrairTag('versao',texto);
   LRetornoInicializar.Sequencial := SA_VSExtrairTag('sequencial',texto);
   LRetornoInicializar.retorno    := SA_VSExtrairTag('retorno',texto);
   LRetornoInicializar.Servico    := SA_VSExtrairTag('servico',texto);
   LRetornoInicializar.Aplicacao  := SA_VSExtrairTag('aplicacao',texto);
   LRetornoInicializar.Estado     := SA_VSExtrairTag('estado',texto);
   LRetornoInicializar.Mensagem   := SA_VSExtrairTag('mensagem',texto);
   //---------------------------------------------------------------------------
   LSequencial                 := strtointdef(LRetornoInicializar.Sequencial,9999999);  // Capturando o sequencial
   //---------------------------------------------------------------------------
end;

function TVSPagueTEF.SA_ParsingRetornoPIX(texto: string): TVSRetornoSolicitacaoPIX;
var
   linhas  : tstringlist;
   d       : integer;
   i       : integer;
   posicao : integer;
   linha   : string;
   tmpstr  : string;
begin
   //---------------------------------------------------------------------------
   result.automacao_coleta_opcao := TStringList.create;
   //---------------------------------------------------------------------------
   linhas      := tstringlist.Create;
   linhas.text := texto;
   for d := 1 to linhas.count do
      begin
         posicao := pos('="',linhas[d-1]);
        if copy(linhas[d-1],1,posicao-1)='transacao' then
            result.Transacao                     := SA_VSExtrairTag('transacao',linhas[d-1])
         else if copy(linhas[d-1],1,posicao-1)='sequencial' then
            result.Sequencial                    := SA_VSExtrairTag('sequencial',linhas[d-1])
         else if copy(linhas[d-1],1,posicao-1)='retorno' then
            result.Retorno                       := SA_VSExtrairTag('retorno',linhas[d-1])
         else if copy(linhas[d-1],1,posicao-1)='servico' then
            result.Servico                       := SA_VSExtrairTag('servico',linhas[d-1])
         else if copy(linhas[d-1],1,posicao-1)='mensagem' then
            begin
               result.mensagem                      := copy(linhas[d-1],10,length(linhas[d-1])-9);
               result.mensagem                      := stringreplace(result.mensagem,'""',#13,[rfReplaceAll, rfIgnoreCase]);
            end
         else if copy(linhas[d-1],1,posicao-1)='automacao_coleta_opcao' then
            begin
               linha   := copy(linhas[d-1],24,length(linhas[d-1])-23);
               tmpstr  := '';
               for I := 1 to length(linha) do
                  begin
                     if linha[i]<>'"' then
                        tmpstr  := tmpstr  + linha[i];
                  end;
               result.automacao_coleta_opcao.text := stringreplace(tmpstr,';',#13,[rfReplaceAll, rfIgnoreCase]);
            end;
      end;
   result.estabelecimento                := SA_VSExtrairTag('estabelecimento',texto);
   result.loja                           := SA_VSExtrairTag('loja',texto);
   result.terminal                       := SA_VSExtrairTag('terminal',texto);
   result.Transacao_nsu                  := SA_VSExtrairTag('transacao_nsu',texto);
   result.Transacao_codigo_vspague       := SA_VSExtrairTag('transacao_codigo_vspague',texto);
   result.Transacao_autorizacao          := SA_VSExtrairTag('transacao_autorizacao',texto);
   result.Transacao_rede                 := SA_VSExtrairTag('transacao_rede',texto);
   result.transacao_pagamento            := SA_VSExtrairTag('transacao_pagamento',texto);
   result.transacao_comprovante_1via     := SA_VSExtrairTag('transacao_comprovante_1via',texto);
   result.transacao_comprovante_2via     := SA_VSExtrairTag('transacao_comprovante_2via',texto);
   result.Transacao_valor                := SA_VSExtrairTag('transacao_valor',texto);
   result.Transacao_data                 := SA_VSExtrairTag('transacao_data',texto);
   result.automacao_coleta_mensagem      := SA_VSExtrairTag('automacao_coleta_mensagem',texto);
   result.automacao_coleta_retorno       := SA_VSExtrairTag('automacao_coleta_retorno',texto);
   result.transacao_resposta             := SA_VSExtrairTag('transacao_resposta',texto);
   result.automacao_coleta_sequencial    := SA_VSExtrairTag('automacao_coleta_sequencial',texto);
   result.automacao_coleta_tipo          := SA_VSExtrairTag('automacao_coleta_tipo',texto);
   result.automacao_coleta_mascara       := SA_VSExtrairTag('automacao_coleta_mascara',texto);
   result.transacao_produto              := SA_VSExtrairTag('transacao_produto',texto);
   result.transacao_rede_cnpj            := SA_VSExtrairTag('transacao_rede_cnpj',texto);
   result.automacao_coleta_palavra_chave := SA_VSExtrairTag('automacao_coleta_palavra_chave',texto);
   result.automacao_coleta_mensagem_tipo := SA_VSExtrairTag('automacao_coleta_mensagem_tipo',texto);
   Result.transacao_payment_id           := SA_VSExtrairTag('transacao_payment_id',texto);
   result.ComprovanteLoja                := '';
   result.QRCode                         :=  '';

   if result.transacao_comprovante_1via<>'' then
      begin
         result.ComprovanteLoja               := '<ce><e>COMPROVANTE TEF</e><ae></lf>'+
                                                 '<ce><e>Via Lojista</e><ae></lf>'+
                                                 '   Realizada em   '+result.Transacao_data+'</lf>'+
                                                 '       Valor R$   '+result.Transacao_valor +'</lf>'+
                                                 '     Forma Pgto   '+LPagamento_Forma+'</lf>'+
                                                 '            NSU   '+result.Transacao_nsu+'</lf>'+
                                                 '       Bandeira   '+result.Transacao_rede+'</lf>';
      end;
   //---------------------------------------------------------------------------
end;

function TVSPagueTEF.SA_ParsingRetornoVenda(texto: string): TVSRetornoSolicitacaoVenda;
var
   linhas  : tstringlist;
   d       : integer;
   i       : integer;
   posicao : integer;
   linha   : string;
   tmpstr  : string;
begin
   //---------------------------------------------------------------------------
   result.automacao_coleta_opcao := TStringList.create;
   //---------------------------------------------------------------------------
   linhas      := tstringlist.Create;
   linhas.text := texto;
   for d := 1 to linhas.count do
      begin
         posicao := pos('="',linhas[d-1]);
        if copy(linhas[d-1],1,posicao-1)='transacao' then
            result.Transacao                     := SA_VSExtrairTag('transacao',linhas[d-1])
         else if copy(linhas[d-1],1,posicao-1)='sequencial' then
            result.Sequencial                    := SA_VSExtrairTag('sequencial',linhas[d-1])
         else if copy(linhas[d-1],1,posicao-1)='retorno' then
            result.Retorno                       := SA_VSExtrairTag('retorno',linhas[d-1])
         else if copy(linhas[d-1],1,posicao-1)='servico' then
            result.Servico                       := SA_VSExtrairTag('servico',linhas[d-1])
         else if copy(linhas[d-1],1,posicao-1)='mensagem' then
            result.mensagem                      := SA_VSExtrairTag('mensagem',linhas[d-1])
         else if copy(linhas[d-1],1,posicao-1)='automacao_coleta_opcao' then
            begin
               linha   := copy(linhas[d-1],24,length(linhas[d-1])-23);
               tmpstr  := '';
               for I := 1 to length(linha) do
                  begin
                     if linha[i]<>'"' then
                        tmpstr  := tmpstr  + linha[i];
                  end;
               result.automacao_coleta_opcao.text := stringreplace(tmpstr,';',#13,[rfReplaceAll, rfIgnoreCase]);
            end;
      end;
   result.Transacao_nsu                  := SA_VSExtrairTag('transacao_nsu',texto);
   result.Transacao_codigo_vspague       := SA_VSExtrairTag('transacao_codigo_vspague',texto);
   result.Transacao_Pagamento            := SA_VSExtrairTag('transacao_Pagamento',texto);
   result.Transacao_autorizacao          := SA_VSExtrairTag('transacao_autorizacao',texto);
   result.Transacao_rede                 := SA_VSExtrairTag('transacao_rede',texto);
   result.Transacao_Comprovante1via      := SA_VSExtrairTag('transacao_comprovante_1via',texto);
   result.Transacao_Comprovante2via      := SA_VSExtrairTag('transacao_comprovante_2via',texto);
   result.Transacao_vencimento           := SA_VSExtrairTag('transacao_vencimento',texto);
   result.Transacao_administradora       := SA_VSExtrairTag('transacao_administradora',texto);
   result.Transacao_identificacao        := SA_VSExtrairTag('transacao_identificacao',texto);
   result.Transacao_valor                := SA_VSExtrairTag('transacao_valor',texto);
   result.Transacao_tipo_cartao          := SA_VSExtrairTag('transacao_tipo_cartao',texto);
   result.Transacao_data                 := SA_VSExtrairTag('transacao_data',texto);
   result.transacao_produto              := SA_VSExtrairTag('transacao_produto',texto);
   result.transacao_rede_cnpj            := SA_VSExtrairTag('transacao_rede_cnpj',texto);
   result.automacao_coleta_mensagem      := SA_VSExtrairTag('automacao_coleta_mensagem',texto);
   result.automacao_coleta_retorno       := SA_VSExtrairTag('automacao_coleta_retorno',texto);
   result.automacao_coleta_sequencial    := SA_VSExtrairTag('automacao_coleta_sequencial',texto);
   result.automacao_coleta_palavra_chave := SA_VSExtrairTag('automacao_coleta_palavra_chave',texto);
   result.automacao_coleta_timeout       := SA_VSExtrairTag('automacao_coleta_timeout',texto);
   result.automacao_coleta_tipo          := SA_VSExtrairTag('automacao_coleta_tipo',texto);
   result.automacao_coleta_mascara       := SA_VSExtrairTag('automacao_coleta_mascara',texto);
   result.ComprovanteLoja                := '';
   if result.Transacao_Comprovante1via<>'' then
      begin
         result.ComprovanteLoja               := '<ce><e>COMPROVANTE TEF</e><ae></lf>'+
                                                 '<ce><e>Via Lojista</e><ae></lf>'+
                                                 '   Realizada em   '+result.Transacao_data+'</lf>'+
                                                 '       Valor R$   '+result.Transacao_valor +'</lf>'+
                                                 '     Forma Pgto   '+LPagamento_Forma+'</lf>'+
                                                 '            NSU   '+result.Transacao_nsu+'</lf>'+
                                                 '       Bandeira   '+result.Transacao_rede+'</lf>';
      end;

end;

function TVSPagueTEF.SA_PerguntarOpcoes(opcoes : integer): integer;
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

         if (strtointdef(frmwebtef.tecla,256)<=opcoes) and (strtointdef(frmwebtef.tecla,256)<>0) then
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

procedure TVSPagueTEF.MythreadEnd(sender : tobject);
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

procedure TVSPagueTEF.SA_ProcessarCancelamentoPIXVS;
var
   Mythread         : TThread;
   resposta         : string;
   sair             : boolean;
   Imprimir         : boolean;
   //---------------------------------------------------------------------------
   opcoesColeta    : TStringList;
   texto           : string;   // Para o envio de coleta para o VSPague
   opcaoColeta     : integer;  // Para obter a opção de menu
   Data_Digitada   : string;   // Quando é coletada uma data
   Numero_Digitado : string;   // Quando a coleta é numérica
   //---------------------------------------------------------------------------
   UltimoSequencialColeta : string;
   //---------------------------------------------------------------------------
begin
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpTEFVSPAgue;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LPagamento_Forma;
   frmwebtef.lbvalor.Caption  := transform(LPagamento_Valor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   Mythread := TThread.CreateAnonymousThread(procedure
   begin
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Conectando com VSPague...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      try
         LIdTCPClient.Connect;   // Abrindo a conexão SOCKET com o VSPAGUE
      except
        frmwebtef.mensagem := 'O Gerenciador VSPague não está ativo !';
        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
        TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT); // Ativar o botão cancelar na tela de TEF
        //---------------------------------------------------------------
        while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
           begin
              sleep(50);
           end;
        TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
        //---------------------------------------------------------------
         lTEFAprovado := false;
         exit;
      end;
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Inicializando TEF...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      SA_Inicializar;     // Inicializando a conexão com o TEF
      //------------------------------------------------------------------
      //  Fazer chamada ao PIX
      //------------------------------------------------------------------
      if (strtointdef(LRetornoInicializar.retorno,0)<=2) then  // Sucesso, continuar
         begin
            //------------------------------------------------------------
            //    O TEF tá inicializado e operando normalmente
            //------------------------------------------------------------
            UltimoSequencialColeta := '';
            SA_CancelamentoPIX; // Enviando cancelamento PIX
            sair := false;
            while not sair do
               begin
                  //------------------------------------------------------
                  //  Trabalhar o fluxo do PIX
                  //------------------------------------------------------
                  resposta               := SA_LerRespostaVSPague;          // Fazendo a leitura do retorno
                  if resposta<>'' then
                     SA_SalvarLog('RESPOSTA SOLICITACAO DE CANCELAMENTO PIX',resposta); // Salvando LOG do retorno da solicitação de venda
                  LRetornoSolicitacaoPIX := SA_ParsingRetornoPIX(resposta); // Sesmontando a resposta do PIX
                  if LRetornoSolicitacaoPIX.automacao_coleta_sequencial<>'' then
                     UltimoSequencialColeta := LRetornoSolicitacaoPIX.automacao_coleta_sequencial;
                  if LRetornoSolicitacaoPIX.retorno='0' then   // A transação foi aprovada
                     begin
                        //------------------------------------------------
                        //   Operação aprovada
                        //------------------------------------------------
                        SA_ConfirmarCancelamentoPIX;  // Confirmando pagamento PIX
                        if LRetornoConfirmaPIX.retorno='1' then
                           begin
                              //------------------------------------------
                              //   Imprimir comprovante
                              //------------------------------------------
                              sair                  := true;
                              LExecutouCancelamento := true;
                              //------------------------------------------
                              //   Processar a impressão
                              //------------------------------------------
                              if LRetornoSolicitacaoPIX.Transacao_Comprovante_2via<>'' then   // Comprovante do cliente
                                 begin
                                    //------------------------------------
                                    //   Comprovante do cliente
                                    //------------------------------------
                                    imprimir := LVSPagueImpressaoViaCLI=tpTEFImprimirSempre;
                                    if LVSPagueImpressaoViaCLI=tpTEFPerguntar then
                                       begin
                                          //------------------------------
                                          //   Perguntar se quer imprimir
                                          //------------------------------
                                          opcoesColeta := TStringList.Create;
                                          opcoesColeta.Add('Imprimir');
                                          opcoesColeta.Add('Não Imprimir');
                                          frmwebtef.mensagem := 'Imprimir o comprovante do CLIENTE ?';
                                          frmwebtef.opcoes   := opcoesColeta;
                                          frmwebtef.opcao    := -1;
                                          frmwebtef.tecla    := '';
                                          frmwebtef.Cancelar := false;
                                          //---------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                           //--------------------------------
                                          while (not frmwebtef.Cancelar) do
                                             begin
                                               if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                  begin
                                                     //------------------
                                                     imprimir := true;
                                                     frmwebtef.Cancelar := true;
                                                     //------------------
                                                  end
                                               else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                                  frmwebtef.Cancelar := true;
                                                //--------------------------
                                                sleep(50);
                                             end;
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                          //------------------------------
                                          frmwebtef.Cancelar := false;
                                          //------------------------------
                                       end;
                                    if imprimir then
                                       SA_Imprimirtexto(LRetornoSolicitacaoPIX.Transacao_Comprovante_2via,limpressora);   // Imprimindo
                                    //------------------------------------
                                 end;
                              //------------------------------------------
                              //  Comprovante da loja
                              //------------------------------------------
                              if LRetornoSolicitacaoPIX.ComprovanteLoja<>'' then   // Comprovante do LOJISTA
                                 begin
                                    imprimir := LVSPagueImpressaoViaLJ=tpTEFImprimirSempre;
                                    //------------------------------------
                                    if LVSPagueImpressaoViaLJ=tpTEFPerguntar then
                                       begin
                                          //------------------------------
                                          //   Perguntar se quer imprimir
                                          //------------------------------
                                          opcoesColeta := TStringList.Create;
                                          opcoesColeta.Add('Imprimir');
                                          opcoesColeta.Add('Não Imprimir');
                                          frmwebtef.mensagem := 'Imprimir o comprovante da LOJA ?';
                                          frmwebtef.opcoes   := opcoesColeta;
                                          frmwebtef.opcao    := -1;
                                          frmwebtef.tecla    := '';
                                          frmwebtef.Cancelar := false;
                                          //------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                           //-----------------------------
                                           while (not frmwebtef.Cancelar) do
                                              begin
                                                if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                   begin
                                                      //------------------
                                                      imprimir := true;
                                                      frmwebtef.Cancelar := true;
                                                      //------------------
                                                   end
                                                else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                                   frmwebtef.Cancelar := true;
                                                 //--------------------------
                                                 sleep(50);
                                              end;
                                          //------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          frmwebtef.Cancelar := false;
                                          //------------------------------
                                       end;
                                    //------------------------------------
                                    if imprimir then
                                       begin
                                          if LImpressaoSimplificada then
                                             SA_ImprimirTexto(LRetornoSolicitacaoPIX.ComprovanteLoja,limpressora)   // Imprimindo
                                          else
                                             SA_ImprimirTexto(LRetornoSolicitacaoPIX.Transacao_Comprovante_1via,limpressora);   // Imprimindo
                                       end;
                                 end;
                              //------------------------------------------
                           end
                        else
                           begin
                              //------------------------------------------
                              //  Não conseguiu confirmar
                              //------------------------------------------
                              sair := true;
                              frmwebtef.mensagem := LRetornoConfirmaPIX.mensagem;
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              //---------------------------------------------------------------
                              while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                 begin
                                    sleep(50);
                                 end;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------
                           end;
                        //------------------------------------------------
                     end
                  else if (LRetornoSolicitacaoPIX.retorno='') and (LRetornoSolicitacaoPIX.automacao_coleta_retorno<>'')  then  // é preciso coletar
                     begin
                        //------------------------------------------------
                        //  Fazer coleta
                        //------------------------------------------------
                        if LRetornoSolicitacaoPIX.automacao_coleta_retorno='0' then  // Só responder, não é necessário informar valor
                           begin
                              if (LRetornoSolicitacaoPIX.automacao_coleta_mensagem_tipo<>'') and (not frmwebtef.pnutil.Visible) then
                                 begin
                                    frmwebtef.Cancelar := false;
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);  // Mostrar o botão de cancelar
                                 end;
                              //------------------------------------------------
                              if LRetornoSolicitacaoPIX.automacao_coleta_mensagem<>'' then
                                 begin
                                    //------------------------------------
                                    //   Exibir mensagem
                                    //------------------------------------
                                    if LRetornoSolicitacaoPIX.automacao_coleta_mensagem='QRCODE' then
                                       frmwebtef.mensagem := 'Faça a leitura do QRCODE no PINPAD...'
                                    else
                                       frmwebtef.mensagem := LRetornoSolicitacaoPIX.automacao_coleta_mensagem;
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                 end;
                              //------------------------------------------
                              if (LRetornoSolicitacaoPIX.automacao_coleta_tipo='X') or (LRetornoSolicitacaoPIX.automacao_coleta_tipo='A') then  // Coleta de um tipo texto
                                 begin
                                    //------------------------------------
                                    //   Verificar como é a captação
                                    //------------------------------------
                                    if LRetornoSolicitacaoPIX.automacao_coleta_opcao.count>0 then   // Menu
                                       begin
                                          //------------------------------
                                          //   Perguntar a opção
                                          //------------------------------
                                          opcoesColeta       := TStringList.Create;
                                          opcoesColeta.text  := LRetornoSolicitacaoPIX.automacao_coleta_opcao.text;
                                          frmwebtef.mensagem := LRetornoSolicitacaoPIX.automacao_coleta_mensagem;
                                          frmwebtef.opcoes   := opcoesColeta;
                                          frmwebtef.opcao    := -1;
                                          frmwebtef.tecla    := '';
                                          frmwebtef.Cancelar := false;
                                          //------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                          opcaoColeta  := SA_PerguntarOpcoes(opcoesColeta.count);
                                          //------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                          //------------------------------
                                          if opcaoColeta<>-1 then
                                             begin
                                                //------------------------
                                                //  Enviar seleção do menu
                                                //------------------------
                                                texto := 'automacao_coleta_informacao="'+opcoesColeta[opcaoColeta-1]+'"'+#13+
                                                         'automacao_coleta_retorno="0"'+#13+
                                                         'automacao_coleta_sequencial="'+LRetornoSolicitacaoPIX.automacao_coleta_sequencial+'"';
                                                SA_SalvarLog('COLETA ENVIO',texto);              //  Salvar LOG de inicialização
                                                SA_EnviarVSPAgue(texto);                    //  Enviando o texto para o VSPAgue
                                                //------------------------
                                             end
                                          else
                                             begin
                                                sair := true;
                                             end;
                                          //------------------------------
                                       end
                                    else
                                       begin
                                          //------------------------------
                                          //  Digitar um valor alfanumérico
                                          //------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                          SA_ColetarValor(LRetornoSolicitacaoPIX.automacao_coleta_mensagem,'',false);
                                          frmwebtef.CaracteresDigitaveis := ['0'..'9','A'..'z',#32,#8];
                                          frmwebtef.dado_digitado := '';
                                          frmwebtef.Cancelar      := false;
                                          frmwebtef.AceitaVazio   := false;
                                          Numero_Digitado         := '';
                                          while (Numero_Digitado='') and (not frmwebtef.Cancelar) do
                                             begin
                                                //------------------------
                                                sleep(10);
                                                //------------------------
                                                if frmwebtef.dado_digitado<>'' then
                                                   Numero_Digitado := frmwebtef.dado_digitado
                                                else if (frmwebtef.dado_digitado='') then
                                                   begin
                                                      frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                                      frmwebtef.pnalerta.Color        := clRed;
                                                      frmwebtef.pnalerta.Font.Color   := clYellow;
                                                      frmwebtef.dado_digitado         := '';
                                                   end;
                                                //------------------------
                                             end;
                                          //------------------------------
                                          frmwebtef.pncaptura.Visible := false;
                                          frmwebtef.edtdado.Enabled   := false;
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          //------------------------------
                                          texto := 'automacao_coleta_informacao="'+Numero_Digitado+'"'+#13+
                                                   'automacao_coleta_retorno="0"'+#13+
                                                   'automacao_coleta_sequencial="'+LRetornoSolicitacaoPIX.automacao_coleta_sequencial+'"';
                                          SA_SalvarLog('COLETA NUMERO ENVIO',texto);       //  Salvar LOG de inicialização
                                          SA_EnviarVSPAgue(texto);                         //  Enviando o texto para o VSPAgue
                                          //------------------------------------
                                       end;
                                    //------------------------------------
                                 end
                              else if LRetornoSolicitacaoPIX.automacao_coleta_tipo='D' then  // Coletar data
                                 begin
                                    //------------------------------------
                                    //   Coletar data
                                    //------------------------------------
                                    if LRetornoSolicitacaoPIX.automacao_coleta_mascara='dd/MM/yyyy' then
                                       begin
                                          //------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                          SA_ColetarValor(LRetornoSolicitacaoPIX.automacao_coleta_mensagem,'99/99/9999',false);
                                          //------------------------------
                                          frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                                          frmwebtef.dado_digitado := '';
                                          frmwebtef.Cancelar      := false;
                                          Data_Digitada           := '';
                                          while (Data_Digitada='') and (not frmwebtef.Cancelar) do
                                             begin
                                                //------------------------
                                                sleep(10);
                                                //------------------------
                                                if (frmwebtef.dado_digitado<>'') and (SA_DataValida(frmwebtef.dado_digitado)) then
                                                   Data_Digitada := frmwebtef.dado_digitado
                                                else if (frmwebtef.dado_digitado<>'') then
                                                   begin
                                                      frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                                      frmwebtef.pnalerta.Color        := clRed;
                                                      frmwebtef.pnalerta.Font.Color   := clYellow;
                                                      frmwebtef.dado_digitado         := '';
                                                   end;
                                                //------------------------
                                             end;
                                          //------------------------------
                                          frmwebtef.pncaptura.Visible := false;
                                          frmwebtef.edtdado.Enabled   := false;
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          //------------------------------
                                          if SA_DataValida(Data_Digitada) then
                                             begin
                                                texto := 'automacao_coleta_informacao="'+Data_Digitada+'"'+#13+
                                                         'automacao_coleta_retorno="0"'+#13+
                                                         'automacao_coleta_sequencial="'+LRetornoSolicitacaoPIX.automacao_coleta_sequencial+'"';
                                                SA_SalvarLog('COLETA ENVIO',texto);              //  Salvar LOG de inicialização
                                                SA_EnviarVSPAgue(texto);                    //  Enviando o texto para o VSPAgue
                                             end;
                                       end;
                                    //------------------------------------
                                 end
                              else if LRetornoSolicitacaoPIX.automacao_coleta_tipo='N' then  // Coletar numérico
                                 begin
                                    //------------------------------------
                                    //   Coletar dado numérico
                                    //------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                    SA_ColetarValor(LRetornoSolicitacaoPIX.automacao_coleta_mensagem,'',false);
                                    frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                                    frmwebtef.dado_digitado := '';
                                    frmwebtef.Cancelar      := false;
                                    frmwebtef.AceitaVazio   := false;
                                    Numero_Digitado         := '';
                                    while (Numero_Digitado='') and (not frmwebtef.Cancelar) do
                                       begin
                                          //------------------------------
                                          sleep(10);
                                          //------------------------------
                                          if (LRetornoSolicitacaoPIX.automacao_coleta_opcao.count>0) and (frmwebtef.dado_digitado<>'') then
                                             begin
                                                if SA_ValidarOpcao(frmwebtef.dado_digitado,LRetornoSolicitacaoPIX.automacao_coleta_opcao) then
                                                   Numero_Digitado := frmwebtef.dado_digitado;
                                             end
                                          else if (frmwebtef.dado_digitado<>'') or (length(frmwebtef.dado_digitado)>1)  then
                                             Numero_Digitado := frmwebtef.dado_digitado
                                          else if (frmwebtef.dado_digitado<>'') then
                                             begin
                                                frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                                frmwebtef.pnalerta.Color        := clRed;
                                                frmwebtef.pnalerta.Font.Color   := clYellow;
                                                frmwebtef.dado_digitado         := '';
                                             end;
                                          //------------------------------
                                       end;
                                    //------------------------------------
                                    if Numero_Digitado='&*&' then
                                       Numero_Digitado := '';
                                    //------------------------------------
                                    frmwebtef.pncaptura.Visible := false;
                                    frmwebtef.edtdado.Enabled   := false;
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    //------------------------------------
                                    texto := 'automacao_coleta_informacao="'+Numero_Digitado+'"'+#13+
                                             'automacao_coleta_retorno="0"'+#13+
                                             'automacao_coleta_sequencial="'+LRetornoSolicitacaoPIX.automacao_coleta_sequencial+'"';
                                    SA_SalvarLog('COLETA NUMERO ENVIO',texto);       //  Salvar LOG de inicialização
                                    SA_EnviarVSPAgue(texto);                         //  Enviando o texto para o VSPAgue
                                    //------------------------------------
                                 end
                              else
                                 begin
                                    //------------------------------------
                                    texto := 'automacao_coleta_retorno="0"'+#13+
                                             'automacao_coleta_sequencial="'+LRetornoSolicitacaoPIX.automacao_coleta_sequencial+'"';
                                    SA_SalvarLog('COLETA ENVIO',texto);              //  Salvar LOG de inicialização
                                    SA_EnviarVSPAgue(texto);                    //  Enviando o texto para o VSPAgue
                                    //------------------------------------
                                 end;
                              //------------------------------------------
                           end
                        else if LRetornoSolicitacaoPIX.automacao_coleta_retorno='9' then  // Ocorreu um erro, transação rejeitada
                           begin
                              //------------------------------------------
                              //  Houve um problema
                              //------------------------------------------
                              sair := true;
                              frmwebtef.mensagem := ' '+#13+'OCORREU UM PROBLEMA COM A TRANSAÇÃO'+#13+' '+#13+
                                                    LRetornoSolicitacaoPIX.automacao_coleta_mensagem;
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                              while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                 begin
                                    sleep(50);
                                 end;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------
                           end;
                     //------------------------------------------------
                     end
                  else if LRetornoSolicitacaoPIX.retorno>='2' then  // Falhou, ocorreu algum erro
                     begin
                        //------------------------------------------------
                        // Ocorreu alguma falha, transação não aprovada
                        //------------------------------------------------
                        sair := true;
                        frmwebtef.mensagem := LRetornoSolicitacaoPIX.mensagem;
                        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                        TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                        //---------------------------------------------------------------
                        while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                           begin
                              sleep(50);
                           end;
                        TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                        //------------------------------------------------
                     end
                  else if (LRetornoSolicitacaoPIX.retorno='') and (LRetornoSolicitacaoPIX.automacao_coleta_retorno='')  then  // Expirou ou pode ser cancelado
                     begin
                        if LRetornoSolicitacaoPIX.transacao_resposta='TO' then
                           begin
                              //------------------------------------------------
                              // Tempo expirou
                              //------------------------------------------------
                              sair := true;
                              frmwebtef.mensagem := 'O tempo para pagar expirou.';
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                              //---------------------------------------------------------------
                              while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                 begin
                                    sleep(50);
                                 end;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                           end
                        else
                           begin
                              //------------------------------------------------
                              if frmwebtef.Cancelar then    // Realizar o cancelamento do PIX
                                 begin
                                    frmwebtef.Cancelar := false;
                                    frmwebtef.mensagem := 'Cancelado pelo operador...';
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    texto := 'automacao_coleta_retorno="9"'+#13+
                                             'automacao_coleta_sequencial="'+UltimoSequencialColeta+'"';
                                    SA_SalvarLog('CANCELAMENTO ENVIO',texto);              //  Salvar LOG de inicialização
                                    SA_EnviarVSPAgue(texto);                    //  Enviando o texto para o VSPAgue
                                    resposta               := SA_LerRespostaVSPaguePIX;          // Fazendo a leitura do retorno
                                    if resposta<>'' then
                                       SA_SalvarLog('RESPOSTA CANCELAMENTO DE PIX',resposta); // Salvando LOG do retorno da solicitação de cancelamento PIX
                                    LRetornoSolicitacaoPIX := SA_ParsingRetornoPIX(resposta); // Sesmontando a resposta do PIX
                                    sair := true;
                                 end;
                              //------------------------------------------------
                           end;
                     end;
                  //------------------------------------------------------
               end;

            //------------------------------------------------------------
         end
      else
         begin
            //---------------------------------------------------------------
            //  Ocorreu um erro
            //---------------------------------------------------------------
            if LRetornoInicializar.mensagem<>'' then
               frmwebtef.mensagem := SA_MensagenErroRetornoTEF
            else
               frmwebtef.mensagem := LRetornoInicializar.mensagem;
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT); // Ativar o botão cancelar na tela de TEF
            //---------------------------------------------------------------
            while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
               begin
                  sleep(50);
               end;
            TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
            //---------------------------------------------------------------
         end;
      //---------------------------------------------------------------------------
      //   Finalizar operação
      //---------------------------------------------------------------------------
      SA_Finalizar;   // Finalizando a conexão com o TEF
      //------------------------------------------------------------------------
      //   Fechando a janela do TEF
      //------------------------------------------------------------------------
      LIdTCPClient.DisConnect;
      //------------------------------------------------------------------------
   end);
   //------------------------------------------------------------------------
   Mythread.onterminate := MythreadEnd;
   Mythread.start;
   //------------------------------------------------------------------------

end;

procedure TVSPagueTEF.SA_ProcessarCancelamentoVS;
var
   Mythread         : TThread;
   resposta         : string;
   sair             : boolean;
   Imprimir         : boolean;
   //---------------------------------------------------------------------------
   opcoesColeta    : TStringList;
   texto           : string;   // Para o envio de coleta para o VSPague
   TextoAjuste     : string;   // Para o envio de Ajustes para o VSPague
   opcaoColeta     : integer;  // Para obter a opção de menu
   Data_Digitada   : string;   // Quando é coletada uma data
   Numero_Digitado : string;   // Quando a coleta é numérica
   //---------------------------------------------------------------------------
begin
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpTEFVSPAgue;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LPagamento_Forma;
   frmwebtef.lbvalor.Caption  := transform(LPagamento_Valor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   Mythread := TThread.CreateAnonymousThread(procedure
   begin
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Conectando com VSPague...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      try
         LIdTCPClient.Connect;   // Abrindo a conexão SOCKET com o VSPAGUE
      except
        frmwebtef.mensagem := 'O Gerenciador VSPague não está ativo !';
        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
        TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT); // Ativar o botão cancelar na tela de TEF
        //---------------------------------------------------------------
        while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
           begin
              sleep(50);
           end;
        TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
        //---------------------------------------------------------------
         lTEFAprovado := false;
         exit;
      end;
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Inicializando TEF...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      SA_Inicializar;     // Inicializando a conexão com o TEF
      if (strtointdef(LRetornoInicializar.retorno,0)<=2) then  // Sucesso, continuar
         begin
            //------------------------------------------------------------
            //    O TEF tá inicializado e operando normalmente
            //------------------------------------------------------------
            LExecutouCancelamento := false;
            SA_CancelarVenda;   // Fazendo a solicitação da venda
            while not sair do
               begin
                  resposta := SA_LerRespostaVSPague;          // Fazendo a leitura do retorno
                  SA_SalvarLog('RESPOSTA SOLICITACAO CANCELAMENTO DE VENDA',resposta); // Salvando LOG do retorno da solicitação do cancelamento de venda
                  LRetornoCancelamento := SA_ParsingRetornoCancelamento( resposta );  // Desmontado texto do cancelamento
                  if LRetornoCancelamento.retorno='' then   // Tem coleta pra fazer
                     begin
                        //------------------------------------------------
                        // Coletar informações
                        //------------------------------------------------
                        if LRetornoCancelamento.automacao_coleta_retorno='0' then  // Só responder, não é necessário informar valor
                           begin
                              //------------------------------------------
                              if LRetornoCancelamento.automacao_coleta_mensagem<>'' then
                                 begin
                                    //------------------------------------
                                    //   Exibir mensagem
                                    //------------------------------------
                                    frmwebtef.mensagem := LRetornoCancelamento.automacao_coleta_mensagem;
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                 end;
                              //------------------------------------------
                              if (LRetornoCancelamento.automacao_coleta_tipo='X') or (LRetornoCancelamento.automacao_coleta_tipo='A') then  // Coleta de um tipo texto
                                 begin
                                    //------------------------------------
                                    //   Verificar como é a captação
                                    //------------------------------------
                                    if LRetornoCancelamento.automacao_coleta_opcao.count>0 then   // Menu
                                       begin
                                          //------------------------------
                                          //   Perguntar a opção
                                          //------------------------------
                                          opcoesColeta       := TStringList.Create;
                                          opcoesColeta.text  := LRetornoCancelamento.automacao_coleta_opcao.text;
                                          frmwebtef.mensagem := LRetornoCancelamento.automacao_coleta_mensagem;
                                          frmwebtef.opcoes   := opcoesColeta;
                                          frmwebtef.opcao    := -1;
                                          frmwebtef.tecla    := '';
                                          frmwebtef.Cancelar := false;
                                          //------------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                          opcaoColeta  := SA_PerguntarOpcoes(opcoesColeta.count);
                                          //------------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          //------------------------------------
                                          if opcaoColeta<>-1 then
                                             begin
                                                //------------------------------
                                                //  Enviar seleção do menu
                                                //------------------------------
                                                texto := 'automacao_coleta_informacao="'+opcoesColeta[opcaoColeta-1]+'"'+#13+
                                                         'automacao_coleta_retorno="0"'+#13+
                                                         'automacao_coleta_sequencial="'+LRetornoCancelamento.automacao_coleta_sequencial+'"';
                                                SA_SalvarLog('COLETA ENVIO',texto);              //  Salvar LOG de inicialização
                                                SA_EnviarVSPAgue(texto);                    //  Enviando o texto para o VSPAgue
                                                //------------------------------
                                             end
                                          else
                                             begin
                                                sair := true;
                                             end;
                                          //------------------------------------
                                       end
                                    else
                                       begin
                                          //------------------------------------
                                          //  Digitar um valor alfanumérico
                                          //------------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                          TThread.Synchronize(TThread.CurrentThread,
                                           procedure
                                              begin
                                                 SA_ColetarValor(LRetornoCancelamento.automacao_coleta_mensagem,'',false);
                                              end);

                                          frmwebtef.CaracteresDigitaveis := ['0'..'9','A'..'z',#32,#8];
                                          frmwebtef.dado_digitado := '';
                                          frmwebtef.Cancelar      := false;
                                          frmwebtef.AceitaVazio   := false;
                                          Numero_Digitado         := '';
                                          while (Numero_Digitado='') and (not frmwebtef.Cancelar) do
                                             begin
                                                //------------------------
                                                sleep(10);
                                                //------------------------
                                                if frmwebtef.dado_digitado<>'' then
                                                   Numero_Digitado := frmwebtef.dado_digitado
                                                else if (frmwebtef.dado_digitado='') then
                                                   begin
                                                      frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                                      frmwebtef.pnalerta.Color        := clRed;
                                                      frmwebtef.pnalerta.Font.Color   := clYellow;
                                                      frmwebtef.dado_digitado         := '';
                                                   end;
                                                //------------------------------
                                             end;
                                          //------------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          frmwebtef.pncaptura.Visible := false;
                                          frmwebtef.edtdado.Enabled   := false;
                                          //------------------------------------
                                          texto := 'automacao_coleta_informacao="'+Numero_Digitado+'"'+#13+
                                                   'automacao_coleta_retorno="0"'+#13+
                                                   'automacao_coleta_sequencial="'+LRetornoCancelamento.automacao_coleta_sequencial+'"';
                                          SA_SalvarLog('COLETA NUMERO ENVIO',texto);       //  Salvar LOG de inicialização
                                          SA_EnviarVSPAgue(texto);                         //  Enviando o texto para o VSPAgue
                                          //------------------------------------
                                       end;
                                    //------------------------------------------
                                 end
                              else if LRetornoCancelamento.automacao_coleta_tipo='D' then  // Coletar data
                                 begin
                                    //------------------------------------------
                                    //   Coletar data
                                    //------------------------------------------
                                    if LRetornoCancelamento.automacao_coleta_mascara='dd/MM/yyyy' then
                                       begin
                                          //------------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                          TThread.Synchronize(TThread.CurrentThread,procedure
                                             begin
                                                SA_ColetarValor(LRetornoCancelamento.automacao_coleta_mensagem,'99/99/9999',false);
                                             end);
                                          //------------------------------------
                                          frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                                          frmwebtef.dado_digitado := '';
                                          frmwebtef.Cancelar      := false;
                                          Data_Digitada           := '';
                                          while (Data_Digitada='') and (not frmwebtef.Cancelar) do
                                             begin
                                                //------------------------------
                                                sleep(10);
                                                //------------------------------
                                                if (frmwebtef.dado_digitado<>'') and (SA_DataValida(frmwebtef.dado_digitado)) then
                                                   Data_Digitada := frmwebtef.dado_digitado
                                                else if (frmwebtef.dado_digitado<>'') then
                                                   begin
                                                      frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                                      frmwebtef.pnalerta.Color        := clRed;
                                                      frmwebtef.pnalerta.Font.Color   := clYellow;
                                                      frmwebtef.dado_digitado         := '';
                                                   end;
                                                //------------------------------
                                             end;
                                          //------------------------------------
                                          frmwebtef.pncaptura.Visible := false;
                                          frmwebtef.edtdado.Enabled   := false;
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          //------------------------------------
                                          if SA_DataValida(Data_Digitada) then
                                             begin
                                                texto := 'automacao_coleta_informacao="'+Data_Digitada+'"'+#13+
                                                         'automacao_coleta_retorno="0"'+#13+
                                                         'automacao_coleta_sequencial="'+LRetornoCancelamento.automacao_coleta_sequencial+'"';
                                                SA_SalvarLog('COLETA ENVIO',texto);              //  Salvar LOG de inicialização
                                                SA_EnviarVSPAgue(texto);                    //  Enviando o texto para o VSPAgue
                                             end;
                                       end;
                                    //------------------------------------------
                                 end
                              else if LRetornoCancelamento.automacao_coleta_tipo='N' then  // Coletar numérico
                                 begin
                                    //------------------------------------------
                                    //   Coletar dado numérico
                                    //------------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                    TThread.Synchronize(TThread.CurrentThread,
                                     procedure
                                        begin
                                           SA_ColetarValor(LRetornoCancelamento.automacao_coleta_mensagem,'',false);
                                        end);
                                    frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                                    frmwebtef.dado_digitado := '';
                                    frmwebtef.Cancelar      := false;
                                    frmwebtef.AceitaVazio   := false;
                                    Numero_Digitado         := '';
                                    while (Numero_Digitado='') and (not frmwebtef.Cancelar) do
                                       begin
                                          //------------------------------------
                                          sleep(10);
                                          //------------------------------------
                                          if (LRetornoCancelamento.automacao_coleta_opcao.count>0) and (frmwebtef.dado_digitado<>'') then
                                             begin
                                                if SA_ValidarOpcao(frmwebtef.dado_digitado,LRetornoCancelamento.automacao_coleta_opcao) then
                                                   Numero_Digitado := frmwebtef.dado_digitado;
                                             end
                                          else if (frmwebtef.dado_digitado<>'') or (length(frmwebtef.dado_digitado)>1)  then
                                             Numero_Digitado := frmwebtef.dado_digitado
                                          else if (frmwebtef.dado_digitado<>'') then
                                             begin
                                                frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                                frmwebtef.pnalerta.Color        := clRed;
                                                frmwebtef.pnalerta.Font.Color   := clYellow;
                                                frmwebtef.dado_digitado         := '';
                                             end;
                                          //------------------------------------
                                       end;
                                    //------------------------------------------
                                    if Numero_Digitado='&*&' then
                                       Numero_Digitado := '';
                                    //------------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    frmwebtef.pncaptura.Visible := false;
                                    frmwebtef.edtdado.Enabled   := false;
                                    //------------------------------------------
                                    texto := 'automacao_coleta_informacao="'+Numero_Digitado+'"'+#13+
                                             'automacao_coleta_retorno="0"'+#13+
                                             'automacao_coleta_sequencial="'+LRetornoCancelamento.automacao_coleta_sequencial+'"';
                                    SA_SalvarLog('COLETA NUMERO ENVIO',texto);       //  Salvar LOG de inicialização
                                    SA_EnviarVSPAgue(texto);                         //  Enviando o texto para o VSPAgue
                                    //------------------------------------------
                                 end
                              else
                                 begin
                                    //------------------------------------------
                                    texto := 'automacao_coleta_retorno="0"'+#13+
                                             'automacao_coleta_sequencial="'+LRetornoCancelamento.automacao_coleta_sequencial+'"';
                                    SA_SalvarLog('COLETA ENVIO',texto);              //  Salvar LOG de inicialização
                                    SA_EnviarVSPAgue(texto);                    //  Enviando o texto para o VSPAgue
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                           end
                        else if LRetornoCancelamento.automacao_coleta_retorno>='2' then  // Ocorreu um erro, transação rejeitada
                           begin
                              //------------------------------------------------
                              //  Houve um problema
                              //------------------------------------------------
                              sair := true;
                              frmwebtef.mensagem := ' '+#13+'OCORREU UM PROBLEMA COM A TRANSAÇÃO'+#13+' '+#13+
                                                    LRetornoCancelamento.automacao_coleta_mensagem;
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                 begin
                                    sleep(50);
                                 end;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------
                           end;
                        //------------------------------------------------
                     end
                  else if LRetornoCancelamento.retorno='0' then   // A coleta terminou e o resultado chegou
                     begin
                        //------------------------------------------------------
                        TextoAjuste := 'sequencial="'+Lsequencial.tostring+'"'+#13+
                                       'retorno="0"'+#13+
                                       'servico="executar"'+#13+
                                       'transacao="Administracao Cancelar"';
                        SA_SalvarLog('CONFIRMAR CANCELAMENTO',TextoAjuste);  //  Salvar LOG
                        SA_EnviarVSPAgue(TextoAjuste);                    //  Enviando o texto para o V  SPAgue
                        //------------------------------------------------------
                        LExecutouCancelamento := true;
                        sair                  := true;
                        //------------------------------------------------
                        //   Processar a impressão
                        //------------------------------------------------
                        if LRetornoCancelamento.transacao_comprovante_2via<>'' then   // Comprovante do cliente
                           begin
                              //------------------------------------------
                              //   Comprovante do cliente
                              //------------------------------------------
                              imprimir := LVSPagueImpressaoViaCLI=tpTEFImprimirSempre;
                              if LVSPagueImpressaoViaCLI=tpTEFPerguntar then
                                 begin
                                    //------------------------------------
                                    //   Perguntar se quer imprimir
                                    //------------------------------------
                                    opcoesColeta := TStringList.Create;
                                    opcoesColeta.Add('Imprimir');
                                    opcoesColeta.Add('Não Imprimir');
                                    frmwebtef.mensagem := 'Imprimir o comprovante do CLIENTE ?';
                                    frmwebtef.opcoes   := opcoesColeta;
                                    frmwebtef.opcao    := -1;
                                    frmwebtef.tecla    := '';
                                    frmwebtef.Cancelar := false;
                                    //------------------------------------
//                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                    TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                    //------------------------------------
                                    while (not frmwebtef.Cancelar) do
                                       begin
                                         if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                            begin
                                               //-------------------------
                                               imprimir := true;
                                               frmwebtef.Cancelar := true;
                                               //-------------------------
                                            end
                                         else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                            frmwebtef.Cancelar := true;
                                          //------------------------------
                                          sleep(50);
                                       end;
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
//                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    //------------------------------------
                                    frmwebtef.Cancelar := false;
                                    //------------------------------------
                                 end;
                              if imprimir then
                                 SA_ImprimirTexto(LRetornoCancelamento.transacao_comprovante_2via,limpressora);   // Imprimindo
                              //------------------------------------------
                           end;
                        //------------------------------------------
                        //  Comprovante da loja
                        //------------------------------------------
                        if LRetornoCancelamento.ComprovanteLoja<>'' then   // Comprovante do LOJISTA
                           begin
                              imprimir := LVSPagueImpressaoViaLJ=tpTEFImprimirSempre;
                              //------------------------------------------
                              if LVSPagueImpressaoViaLJ=tpTEFPerguntar then
                                 begin
                                    //------------------------------------
                                    //   Perguntar se quer imprimir
                                    //------------------------------------
                                    opcoesColeta := TStringList.Create;
                                    opcoesColeta.Add('Imprimir');
                                    opcoesColeta.Add('Não Imprimir');
                                    frmwebtef.mensagem := 'Imprimir o comprovante da LOJA ?';
                                    frmwebtef.opcoes   := opcoesColeta;
                                    frmwebtef.opcao    := -1;
                                    frmwebtef.tecla    := '';
                                    frmwebtef.Cancelar := false;
                                    //------------------------------------
//                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                    TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                    //------------------------------------
                                    while (not frmwebtef.Cancelar) do
                                       begin
                                         if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                            begin
                                               //------------------------
                                               imprimir := true;
                                               frmwebtef.Cancelar := true;
                                               //------------------------
                                            end
                                         else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                            frmwebtef.Cancelar := true;
                                          //-----------------------------
                                          sleep(50);
                                       end;
                                    //------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    frmwebtef.Cancelar := false;
                                    //------------------------------------
                                 end;
                                    //------------------------------------
                              if imprimir then
                                 SA_ImprimirTexto(LRetornoCancelamento.transacao_comprovante_1via,limpressora);   // Imprimindo
                           end;
                        //------------------------------------------------
                     end
                  else if strtointdef(LRetornoCancelamento.retorno,9)>=2 then   // Ocorreram erros
                     begin
                        //------------------------------------------------
                        //  Mostrar os erros
                        //------------------------------------------------
                        TextoAjuste := 'sequencial="'+Lsequencial.tostring+'"'+#13+
                                       'retorno="9"';
                        SA_SalvarLog('ENCERRANDO A OPERACAO ERRONEA',TextoAjuste);  //  Salvar LOG
                        SA_EnviarVSPAgue(TextoAjuste);                    //  Enviando o texto para o V  SPAgue
                        //------------------------------------------------
                        sair := true;
                        frmwebtef.mensagem := LRetornoCancelamento.mensagem;
                        TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                        while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                           begin
                              sleep(50);
                           end;
                        TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                        //------------------------------------------------
                     end;
                  //------------------------------------------------------
               end;
         end;
      //------------------------------------------------------------------------
      //   Finalizar operação
      //------------------------------------------------------------------------
      SA_Finalizar;   // Finalizando a conexão com o TEF
      //------------------------------------------------------------------------
      //   Fechando a janela do TEF
      //------------------------------------------------------------------------
      LIdTCPClient.DisConnect;
      //------------------------------------------------------------------------
   end);
   //------------------------------------------------------------------------
   Mythread.onterminate := MythreadEnd;
   Mythread.start;
   //---------------------------------------------------------------------------

end;

procedure TVSPagueTEF.SA_ProcessarExtratoVS;
var
   Mythread         : TThread;
   resposta         : string;
   sair             : boolean;
   //---------------------------------------------------------------------------
   opcoesColeta     : TStringList;
   texto            : string;   // Para o envio de coleta para o VSPague
   opcaoColeta      : integer;  // Para obter a opção de menu
   Data_Digitada    : string;   // Quando é coletada uma data
   Numero_Digitado  : string;   // Quando a coleta é numérica
   Imprimir         : boolean;
   //---------------------------------------------------------------------------
   UltimoSequencialColeta : string;
   //---------------------------------------------------------------------------
begin
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpTEFVSPAgue;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LPagamento_Forma;
   frmwebtef.lbvalor.Caption  := transform(LPagamento_Valor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   Mythread := TThread.CreateAnonymousThread(procedure
   begin
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Conectando com VSPague...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      try
         LIdTCPClient.Connect;   // Abrindo a conexão SOCKET com o VSPAGUE
      except
        frmwebtef.mensagem := 'O Gerenciador VSPague não está ativo !';
        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
        TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT); // Ativar o botão cancelar na tela de TEF
        //---------------------------------------------------------------
        while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
           begin
              sleep(50);
           end;
        TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
        //---------------------------------------------------------------
         lTEFAprovado := false;
         exit;
      end;
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Inicializando TEF...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      SA_Inicializar;     // Inicializando a conexão com o TEF
      //------------------------------------------------------------------
      //  Fazer chamada ao PIX
      //------------------------------------------------------------------
      if (strtointdef(LRetornoInicializar.retorno,0)<=2) then  // Sucesso, continuar
         begin
            //------------------------------------------------------------
            UltimoSequencialColeta := '';
            SA_EnviarExtrato;
            //------------------------------------------------------------
            sair := false;
            while not sair do
               begin
                  //------------------------------------------------------------
                  //  Trabalhar o fluxo das pendencias
                  //------------------------------------------------------------
                  resposta               := SA_LerRespostaVSPague;          // Fazendo a leitura do retorno
                  if resposta<>'' then
                     SA_SalvarLog('RESPOSTA SOLICITACAO DO EXTRATO',resposta); // Salvando LOG do retorno da solicitação de extrato
                  LRetornoExtrato := SA_ParsingRetornoExtrato(resposta); // Sesmontando a resposta de EXTRATO
                  if LRetornoExtrato.automacao_coleta_sequencial<>'' then
                     UltimoSequencialColeta := LRetornoExtrato.automacao_coleta_sequencial;

                  if LRetornoExtrato.retorno='1' then   // A transação foi aprovada
                     begin
                        //------------------------------------------------------
                        //   Operação aprovada
                        //------------------------------------------------------
                        sair         := true;
                        LTEFAprovado := true;
                        //------------------------------------------------------
                        //   Processar a impressão
                        //------------------------------------------------------
                        if LRetornoExtrato.transacao_comprovante_1via<>'' then   // Comprovante
                           begin
                              //------------------------------------------------
                              //   Comprovante do cliente
                              //------------------------------------------------
                              imprimir := LVSPagueImpressaoViaLJ=tpTEFImprimirSempre;
                              if LVSPagueImpressaoViaLJ=tpTEFPerguntar then
                                 begin
                                    //------------------------------------------
                                    //   Perguntar se quer imprimir
                                    //------------------------------------------
                                    opcoesColeta := TStringList.Create;
                                    opcoesColeta.Add('Imprimir');
                                    opcoesColeta.Add('Não Imprimir');
                                    frmwebtef.mensagem := 'Imprimir o comprovante do extrato ?';
                                    frmwebtef.opcoes   := opcoesColeta;
                                    frmwebtef.opcao    := -1;
                                    frmwebtef.tecla    := '';
                                    frmwebtef.Cancelar := false;
                                    //------------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                    //------------------------------------------
                                    while (not frmwebtef.Cancelar) do
                                       begin
                                         if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                            begin
                                               //-------------------------------
                                               imprimir := true;
                                               frmwebtef.Cancelar := true;
                                               //-------------------------------
                                            end
                                         else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                            frmwebtef.Cancelar := true;
                                          //------------------------------------
                                          sleep(50);
                                       end;
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    //------------------------------------------
                                    frmwebtef.Cancelar := false;
                                    //------------------------------------------
                                 end;
                              if imprimir then
                                 SA_ImprimirTexto(LRetornoExtrato.transacao_comprovante_1via,limpressora);   // Imprimindo
                              //------------------------------------------------
                           end;
                        //------------------------------------------------------
                     end
                  else if (LRetornoExtrato.retorno='') and (LRetornoExtrato.automacao_coleta_retorno<>'')  then  // é preciso coletar
                     begin
                        //------------------------------------------------------
                        //  Fazer coleta
                        //------------------------------------------------------
                        if LRetornoExtrato.automacao_coleta_retorno='0' then  //
                           begin
                              if (LRetornoExtrato.automacao_coleta_tipo<>'') and (not frmwebtef.pnutil.Visible) then
                                 begin
                                    frmwebtef.Cancelar := false;
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);  // Mostrar o botão de cancelar
                                 end;
                              //------------------------------------------------
                              if LRetornoExtrato.automacao_coleta_mensagem<>'' then
                                 begin
                                    //------------------------------------------
                                    //   Exibir mensagem
                                    //------------------------------------------
                                    frmwebtef.mensagem := LRetornoExtrato.automacao_coleta_mensagem+#13+
                                                          formatfloat('###,##0.00',strtofloatdef(LRetornoExtrato.transacao_valor,0))+#13;
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                 end;
                              //------------------------------------------------
                              if (LRetornoExtrato.automacao_coleta_tipo='X') or (LRetornoExtrato.automacao_coleta_tipo='A') then  // Coleta de um tipo texto
                                 begin
                                    //------------------------------------------
                                    //   Verificar como é a captação
                                    //------------------------------------------
                                    if LRetornoExtrato.automacao_coleta_opcao.count>0 then   // Menu
                                       begin
                                          //------------------------------------
                                          //   Perguntar a opção
                                          //------------------------------------
                                          opcoesColeta       := TStringList.Create;
                                          opcoesColeta.text  := LRetornoExtrato.automacao_coleta_opcao.text;
                                          frmwebtef.mensagem := LRetornoExtrato.automacao_coleta_mensagem;
                                          frmwebtef.opcoes   := opcoesColeta;
                                          frmwebtef.opcao    := -1;
                                          frmwebtef.tecla    := '';
                                          frmwebtef.Cancelar := false;
                                          //------------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                          opcaoColeta  := SA_PerguntarOpcoes(opcoesColeta.count);
                                          //------------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                          //------------------------------------
                                          if opcaoColeta<>-1 then
                                             begin
                                                //------------------------------
                                                //  Enviar seleção do menu
                                                //------------------------------
                                                texto := 'automacao_coleta_informacao="'+opcoesColeta[opcaoColeta-1]+'"'+#13+
                                                         'automacao_coleta_retorno="0"'+#13+
                                                         'automacao_coleta_sequencial="'+LRetornoExtrato.automacao_coleta_sequencial+'"';
                                                SA_SalvarLog('COLETA ENVIO',texto);              //  Salvar LOG de coleta
                                                SA_EnviarVSPAgue(texto);                    //  Enviando o texto para o VSPAgue
                                                //------------------------------
                                             end
                                          else
                                             begin
                                                sair := true;
                                             end;
                                          //------------------------------------
                                       end
                                    else
                                       begin
                                          //------------------------------------
                                          //  Digitar um valor alfanumérico
                                          //------------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                          SA_ColetarValor(LRetornoExtrato.automacao_coleta_mensagem,'',false);
                                          frmwebtef.CaracteresDigitaveis := ['0'..'9','A'..'z',#32,#8];
                                          frmwebtef.dado_digitado := '';
                                          frmwebtef.Cancelar      := false;
                                          frmwebtef.AceitaVazio   := false;
                                          Numero_Digitado         := '';
                                          while (Numero_Digitado='') and (not frmwebtef.Cancelar) do
                                             begin
                                                //------------------------------
                                                sleep(10);
                                                //------------------------------
                                                if frmwebtef.dado_digitado<>'' then
                                                   Numero_Digitado := frmwebtef.dado_digitado
                                                else if (frmwebtef.dado_digitado='') then
                                                   begin
                                                      frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                                      frmwebtef.pnalerta.Color        := clRed;
                                                      frmwebtef.pnalerta.Font.Color   := clYellow;
                                                      frmwebtef.dado_digitado         := '';
                                                   end;
                                                //------------------------------
                                             end;
                                          //------------------------------------
                                          frmwebtef.pncaptura.Visible := false;
                                          frmwebtef.edtdado.Enabled   := false;
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          //------------------------------------
                                          texto := 'automacao_coleta_informacao="'+Numero_Digitado+'"'+#13+
                                                   'automacao_coleta_retorno="0"'+#13+
                                                   'automacao_coleta_sequencial="'+LRetornoExtrato.automacao_coleta_sequencial+'"';
                                          SA_SalvarLog('COLETA NUMERO ENVIO',texto);       //  Salvar LOG coleta
                                          SA_EnviarVSPAgue(texto);                         //  Enviando o texto para o VSPAgue
                                          //------------------------------------
                                       end;
                                    //------------------------------------------
                                 end
                              else if LRetornoExtrato.automacao_coleta_tipo='D' then  // Coletar data
                                 begin
                                    //------------------------------------------
                                    //   Coletar data
                                    //------------------------------------------
                                    if LRetornoExtrato.automacao_coleta_mascara='dd/MM/yyyy' then
                                       begin
                                          //------------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,procedure
                                             begin
                                                SA_ColetarValor(LRetornoExtrato.automacao_coleta_mensagem,'99/99/9999',false);
                                             end);
                                          //------------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                          frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                                          frmwebtef.dado_digitado := '';
                                          frmwebtef.Cancelar      := false;
                                          Data_Digitada           := '';
                                          while (Data_Digitada='') and (not frmwebtef.Cancelar) do
                                             begin
                                                //------------------------------
                                                sleep(10);
                                                //------------------------------
                                                if (frmwebtef.dado_digitado<>'') and (SA_DataValida(frmwebtef.dado_digitado)) then
                                                   Data_Digitada := frmwebtef.dado_digitado
                                                else if (frmwebtef.dado_digitado<>'') then
                                                   begin
                                                      frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                                      frmwebtef.pnalerta.Color        := clRed;
                                                      frmwebtef.pnalerta.Font.Color   := clYellow;
                                                      frmwebtef.dado_digitado         := '';
                                                   end;
                                                //------------------------------
                                             end;
                                          //------------------------------------
                                          frmwebtef.pncaptura.Visible := false;
                                          frmwebtef.edtdado.Enabled   := false;
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          //------------------------------------
                                          if SA_DataValida(Data_Digitada) then
                                             begin
                                                texto := 'automacao_coleta_informacao="'+Data_Digitada+'"'+#13+
                                                         'automacao_coleta_retorno="0"'+#13+
                                                         'automacao_coleta_sequencial="'+LRetornoExtrato.automacao_coleta_sequencial+'"';
                                                SA_SalvarLog('COLETA ENVIO',texto);              //  Salvar LOG de inicialização
                                                SA_EnviarVSPAgue(texto);                    //  Enviando o texto para o VSPAgue
                                             end;
                                       end;
                                    //------------------------------------------
                                 end
                              else if LRetornoExtrato.automacao_coleta_tipo='N' then  // Coletar numérico
                                 begin
                                    //------------------------------------------
                                    //   Coletar dado numérico
                                    //------------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                    SA_ColetarValor(LRetornoExtrato.automacao_coleta_mensagem,'',false);
                                    frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                                    frmwebtef.dado_digitado := '';
                                    frmwebtef.Cancelar      := false;
                                    frmwebtef.AceitaVazio   := false;
                                    Numero_Digitado         := '';
                                    while (Numero_Digitado='') and (not frmwebtef.Cancelar) do
                                       begin
                                          //------------------------------------
                                          sleep(10);
                                          //------------------------------------
                                          if (LRetornoExtrato.automacao_coleta_opcao.count>0) and (frmwebtef.dado_digitado<>'') then
                                             begin
                                                if SA_ValidarOpcao(frmwebtef.dado_digitado,LRetornoExtrato.automacao_coleta_opcao) then
                                                   Numero_Digitado := frmwebtef.dado_digitado;
                                             end
                                          else if (frmwebtef.dado_digitado<>'') or (length(frmwebtef.dado_digitado)>1)  then
                                             Numero_Digitado := frmwebtef.dado_digitado
                                          else if (frmwebtef.dado_digitado<>'') then
                                             begin
                                                frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                                frmwebtef.pnalerta.Color        := clRed;
                                                frmwebtef.pnalerta.Font.Color   := clYellow;
                                                frmwebtef.dado_digitado         := '';
                                             end;
                                          //------------------------------------
                                       end;
                                    //------------------------------------------
                                    if Numero_Digitado='&*&' then
                                       Numero_Digitado := '';
                                    //------------------------------------------
                                    frmwebtef.pncaptura.Visible := false;
                                    frmwebtef.edtdado.Enabled   := false;
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    //------------------------------------------
                                    texto := 'automacao_coleta_informacao="'+Numero_Digitado+'"'+#13+
                                             'automacao_coleta_retorno="0"'+#13+
                                             'automacao_coleta_sequencial="'+LRetornoExtrato.automacao_coleta_sequencial+'"';
                                    SA_SalvarLog('COLETA NUMERO ENVIO',texto);       //  Salvar LOG de coleta
                                    SA_EnviarVSPAgue(texto);                         //  Enviando o texto para o VSPAgue
                                    //------------------------------------------
                                 end
                              else
                                 begin
                                    //------------------------------------------
                                    texto := 'automacao_coleta_retorno="0"'+#13+
                                             'automacao_coleta_sequencial="'+LRetornoExtrato.automacao_coleta_sequencial+'"';
                                    SA_SalvarLog('COLETA ENVIO',texto);              //  Salvar LOG de coleta
                                    SA_EnviarVSPAgue(texto);                    //  Enviando o texto para o VSPAgue
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                           end
                        else if LRetornoExtrato.automacao_coleta_retorno='9' then  // Ocorreu um erro, transação rejeitada
                           begin
                              //------------------------------------------
                              //  Houve um problema
                              //------------------------------------------
                              sair := true;
                              frmwebtef.mensagem := ' '+#13+'OCORREU UM PROBLEMA COM A TRANSAÇÃO'+#13+' '+#13+
                                                    LRetornoExtrato.automacao_coleta_mensagem;
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                              while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                 begin
                                    sleep(50);
                                 end;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------
                           end;
                     //------------------------------------------------
                     end
                  else if LRetornoExtrato.retorno>='2' then  // Falhou, ocorreu algum erro
                     begin
                        //------------------------------------------------
                        // Ocorreu alguma falha, transação não aprovada
                        //------------------------------------------------
                        sair := true;
                        frmwebtef.mensagem := LRetornoExtrato.mensagem;
                        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                        TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                        //---------------------------------------------------------------
                        while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                           begin
                              sleep(50);
                           end;
                        TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                        //------------------------------------------------
                     end
                  else if (LRetornoExtrato.retorno='') and (LRetornoExtrato.automacao_coleta_retorno='')  then  // Expirou ou pode ser cancelado
                     begin
                        //------------------------------------------------------
                        // Tempo expirou
                        //------------------------------------------------------
                        sair := true;
                        frmwebtef.mensagem := 'O tempo para operar expirou.';
                        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                        TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                        //---------------------------------------------------------------
                        while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                           begin
                              sleep(50);
                           end;
                        TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                        //------------------------------------------------
                     end;
                  //------------------------------------------------------
               end;
            //------------------------------------------------------------
         end
      else
         begin
            //---------------------------------------------------------------
            //  Ocorreu um erro
            //---------------------------------------------------------------
            if LRetornoInicializar.mensagem<>'' then
               frmwebtef.mensagem := SA_MensagenErroRetornoTEF
            else
               frmwebtef.mensagem := LRetornoInicializar.mensagem;
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT); // Ativar o botão cancelar na tela de TEF
            //---------------------------------------------------------------
            while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
               begin
                  sleep(50);
               end;
            TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
            //---------------------------------------------------------------
         end;
      //---------------------------------------------------------------------------
      //   Finalizar operação
      //---------------------------------------------------------------------------
      SA_Finalizar;   // Finalizando a conexão com o TEF
      //------------------------------------------------------------------------
      //   Fechando a janela do TEF
      //------------------------------------------------------------------------
      LIdTCPClient.DisConnect;
      //------------------------------------------------------------------------
   end);
   //------------------------------------------------------------------------
   Mythread.onterminate := MythreadEnd;
   Mythread.start;
   //------------------------------------------------------------------------
end;

procedure TVSPagueTEF.SA_DesativarBtCancelarT;
begin
   SA_DesativarBTCancelar;
end;


procedure TVSPagueTEF.SA_MostramensagemT;
begin
   SA_Mostrar_Mensagem(true);
end;


procedure TVSPagueTEF.SA_MostrarBtCancelarT;
begin
   SA_AtivarBTCancelar;   // Ativar o botão cancelar na tela de TEF
end;

procedure TVSPagueTEF.SA_CriarMenuT;
begin
   SA_Criar_Menu(true);
end;

procedure TVSPagueTEF.SA_DesativarMenuT;
begin
   SA_Criar_Menu(false);
end;



procedure TVSPagueTEF.SA_ProcessarPagamentoPIXVS;
var
   Mythread         : TThread;
   resposta         : string;
   sair             : boolean;
   Imprimir         : boolean;
   //---------------------------------------------------------------------------
   opcoesColeta    : TStringList;
   texto           : string;   // Para o envio de coleta para o VSPague
   opcaoColeta     : integer;  // Para obter a opção de menu
   Data_Digitada   : string;   // Quando é coletada uma data
   Numero_Digitado : string;   // Quando a coleta é numérica
   TextoAjuste     : string;   // Texto para encerrar o fluxo
   //---------------------------------------------------------------------------
   UltimoSequencialColeta : string;
   //---------------------------------------------------------------------------
begin
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpTEFVSPAgue;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LPagamento_Forma;
   frmwebtef.lbvalor.Caption  := transform(LPagamento_Valor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   Mythread := TThread.CreateAnonymousThread(procedure
   begin
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Conectando com VSPague...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      try
         LIdTCPClient.Connect;   // Abrindo a conexão SOCKET com o VSPAGUE
      except
        frmwebtef.mensagem := 'O Gerenciador VSPague não está ativo !';
        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
        TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT); // Ativar o botão cancelar na tela de TEF
        //---------------------------------------------------------------
        while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
           begin
              sleep(50);
           end;
        TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
        //---------------------------------------------------------------
         lTEFAprovado := false;
         exit;
      end;
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Inicializando TEF...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      SA_Inicializar;     // Inicializando a conexão com o TEF
      //------------------------------------------------------------------
      //  Fazer chamada ao PIX
      //------------------------------------------------------------------
      if (strtointdef(LRetornoInicializar.retorno,0)<=2) then  // Sucesso, continuar
         begin
            //------------------------------------------------------------
            //    O TEF tá inicializado e operando normalmente
            //------------------------------------------------------------
            UltimoSequencialColeta := '';
            SA_PagamentoPIX; // Enviando pagamento PIX
            sair := false;
            while not sair do
               begin
                  //------------------------------------------------------
                  //  Trabalhar o fluxo do PIX
                  //------------------------------------------------------
                  resposta               := SA_LerRespostaVSPaguePIX;          // Fazendo a leitura do retorno
                  if resposta<>'' then
                     SA_SalvarLog('RESPOSTA SOLICITACAO DE VENDA PIX',resposta); // Salvando LOG do retorno da solicitação de venda
                  LRetornoSolicitacaoPIX := SA_ParsingRetornoPIX(resposta); // Sesmontando a resposta do PIX
                  if LRetornoSolicitacaoPIX.automacao_coleta_sequencial<>'' then
                     UltimoSequencialColeta := LRetornoSolicitacaoPIX.automacao_coleta_sequencial;
                  if LRetornoSolicitacaoPIX.retorno='0' then   // A transação foi aprovada
                     begin
                        //------------------------------------------------
                        //   Operação aprovada
                        //------------------------------------------------
                        SA_ConfirmarPIX;  // Confirmando pagamento PIX
                        if LRetornoConfirmaPIX.retorno='1' then
                           begin
                              //------------------------------------------
                              //   Imprimir comprovante
                              //------------------------------------------
                              sair         := true;
                              LTEFAprovado := true;
                              //------------------------------------------
                              //   Processar a impressão
                              //------------------------------------------
                              if LRetornoSolicitacaoPIX.Transacao_Comprovante_2via<>'' then   // Comprovante do cliente
                                 begin
                                    //------------------------------------
                                    //   Comprovante do cliente
                                    //------------------------------------
                                    imprimir := LVSPagueImpressaoViaCLI=tpTEFImprimirSempre;
                                    if LVSPagueImpressaoViaCLI=tpTEFPerguntar then
                                       begin
                                          //------------------------------
                                          //   Perguntar se quer imprimir
                                          //------------------------------
                                          opcoesColeta := TStringList.Create;
                                          opcoesColeta.Add('Imprimir');
                                          opcoesColeta.Add('Não Imprimir');
                                          frmwebtef.mensagem := 'Imprimir o comprovante do CLIENTE ?';
                                          frmwebtef.opcoes   := opcoesColeta;
                                          frmwebtef.opcao    := -1;
                                          frmwebtef.tecla    := '';
                                          frmwebtef.Cancelar := false;
                                          //---------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                           //--------------------------------
                                          while (not frmwebtef.Cancelar) do
                                             begin
                                               if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                  begin
                                                     //------------------
                                                     imprimir := true;
                                                     frmwebtef.Cancelar := true;
                                                     //------------------
                                                  end
                                               else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                                  frmwebtef.Cancelar := true;
                                                //--------------------------
                                                sleep(50);
                                             end;
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                          //------------------------------
                                          frmwebtef.Cancelar := false;
                                          //------------------------------
                                       end;
                                    if imprimir then
                                       SA_ImprimirTexto(LRetornoSolicitacaoPIX.Transacao_Comprovante_2via,limpressora);   // Imprimindo
                                    //------------------------------------
                                 end;
                              //------------------------------------------
                              //  Comprovante da loja
                              //------------------------------------------
                              if LRetornoSolicitacaoPIX.ComprovanteLoja<>'' then   // Comprovante do LOJISTA
                                 begin
                                    imprimir := LVSPagueImpressaoViaLJ=tpTEFImprimirSempre;
                                    //------------------------------------
                                    if LVSPagueImpressaoViaLJ=tpTEFPerguntar then
                                       begin
                                          //------------------------------
                                          //   Perguntar se quer imprimir
                                          //------------------------------
                                          opcoesColeta := TStringList.Create;
                                          opcoesColeta.Add('Imprimir');
                                          opcoesColeta.Add('Não Imprimir');
                                          frmwebtef.mensagem := 'Imprimir o comprovante da LOJA ?';
                                          frmwebtef.opcoes   := opcoesColeta;
                                          frmwebtef.opcao    := -1;
                                          frmwebtef.tecla    := '';
                                          frmwebtef.Cancelar := false;
                                          //------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                           //-----------------------------
                                           while (not frmwebtef.Cancelar) do
                                              begin
                                                if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                   begin
                                                      //------------------
                                                      imprimir := true;
                                                      frmwebtef.Cancelar := true;
                                                      //------------------
                                                   end
                                                else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                                   frmwebtef.Cancelar := true;
                                                 //--------------------------
                                                 sleep(50);
                                              end;
                                          //------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          frmwebtef.Cancelar := false;
                                          //------------------------------
                                       end;
                                    //------------------------------------
                                    if imprimir then
                                       begin
                                          if LImpressaoSimplificada then
                                             SA_ImprimirTexto(LRetornoSolicitacaoPIX.ComprovanteLoja,limpressora)   // Imprimindo
                                          else
                                             SA_ImprimirTexto(LRetornoSolicitacaoPIX.Transacao_Comprovante_1via,limpressora);   // Imprimindo
                                       end;
                                 end;
                              //------------------------------------------
                           end
                        else
                           begin
                              //------------------------------------------
                              //  Não conseguiu confirmar
                              //------------------------------------------
                              sair := true;
                              frmwebtef.mensagem := LRetornoConfirmaPIX.mensagem;
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              //---------------------------------------------------------------
                              while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                 begin
                                    sleep(50);
                                 end;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------
                           end;
                        //------------------------------------------------
                     end
                  else if (LRetornoSolicitacaoPIX.retorno='') and (LRetornoSolicitacaoPIX.automacao_coleta_retorno<>'')  then  // é preciso coletar
                     begin
                        //------------------------------------------------
                        //  Fazer coleta
                        //------------------------------------------------
                        if LRetornoSolicitacaoPIX.automacao_coleta_retorno='0' then  // Só responder, não é necessário informar valor
                           begin
                              if (LRetornoSolicitacaoPIX.automacao_coleta_mensagem_tipo<>'') and (not frmwebtef.pnutil.Visible) then
                                 begin
                                    frmwebtef.Cancelar := false;
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);  // Mostrar o botão de cancelar
                                 end;
                              //------------------------------------------------
                              if LRetornoSolicitacaoPIX.automacao_coleta_mensagem<>'' then
                                 begin
                                    //------------------------------------
                                    //   Exibir mensagem
                                    //------------------------------------
                                    if LRetornoSolicitacaoPIX.automacao_coleta_mensagem='QRCODE' then
                                       frmwebtef.mensagem := 'Faça a leitura do QRCODE no PINPAD...'
                                    else
                                       frmwebtef.mensagem := LRetornoSolicitacaoPIX.automacao_coleta_mensagem;
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                 end;
                              //------------------------------------------
                              if (LRetornoSolicitacaoPIX.automacao_coleta_tipo='X') or (LRetornoSolicitacaoPIX.automacao_coleta_tipo='A') then  // Coleta de um tipo texto
                                 begin
                                    //------------------------------------
                                    //   Verificar como é a captação
                                    //------------------------------------
                                    if LRetornoSolicitacaoPIX.automacao_coleta_opcao.count>0 then   // Menu
                                       begin
                                          //------------------------------
                                          //   Perguntar a opção
                                          //------------------------------
                                          opcoesColeta       := TStringList.Create;
                                          opcoesColeta.text  := LRetornoSolicitacaoPIX.automacao_coleta_opcao.text;
                                          frmwebtef.mensagem := LRetornoSolicitacaoPIX.automacao_coleta_mensagem;
                                          frmwebtef.opcoes   := opcoesColeta;
                                          frmwebtef.opcao    := -1;
                                          frmwebtef.tecla    := '';
                                          frmwebtef.Cancelar := false;
                                          //------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                          opcaoColeta  := SA_PerguntarOpcoes(opcoesColeta.count);
                                          //------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                          //------------------------------
                                          if opcaoColeta<>-1 then
                                             begin
                                                //------------------------
                                                //  Enviar seleção do menu
                                                //------------------------
                                                texto := 'automacao_coleta_informacao="'+opcoesColeta[opcaoColeta-1]+'"'+#13+
                                                         'automacao_coleta_retorno="0"'+#13+
                                                         'automacao_coleta_sequencial="'+LRetornoSolicitacaoPIX.automacao_coleta_sequencial+'"';
                                                SA_SalvarLog('COLETA ENVIO',texto);              //  Salvar LOG de inicialização
                                                SA_EnviarVSPAgue(texto);                    //  Enviando o texto para o VSPAgue
                                                //------------------------
                                             end
                                          else
                                             begin
                                                sair := true;
                                             end;
                                          //------------------------------
                                       end
                                    else
                                       begin
                                          //------------------------------
                                          //  Digitar um valor alfanumérico
                                          //------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                          SA_ColetarValor(LRetornoSolicitacaoPIX.automacao_coleta_mensagem,'',false);
                                          frmwebtef.CaracteresDigitaveis := ['0'..'9','A'..'z',#32,#8];
                                          frmwebtef.dado_digitado := '';
                                          frmwebtef.Cancelar      := false;
                                          frmwebtef.AceitaVazio   := false;
                                          Numero_Digitado         := '';
                                          while (Numero_Digitado='') and (not frmwebtef.Cancelar) do
                                             begin
                                                //------------------------
                                                sleep(10);
                                                //------------------------
                                                if frmwebtef.dado_digitado<>'' then
                                                   Numero_Digitado := frmwebtef.dado_digitado
                                                else if (frmwebtef.dado_digitado='') then
                                                   begin
                                                      frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                                      frmwebtef.pnalerta.Color        := clRed;
                                                      frmwebtef.pnalerta.Font.Color   := clYellow;
                                                      frmwebtef.dado_digitado         := '';
                                                   end;
                                                //------------------------
                                             end;
                                          //------------------------------
                                          frmwebtef.pncaptura.Visible := false;
                                          frmwebtef.edtdado.Enabled   := false;
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          //------------------------------
                                          texto := 'automacao_coleta_informacao="'+Numero_Digitado+'"'+#13+
                                                   'automacao_coleta_retorno="0"'+#13+
                                                   'automacao_coleta_sequencial="'+LRetornoSolicitacaoPIX.automacao_coleta_sequencial+'"';
                                          SA_SalvarLog('COLETA NUMERO ENVIO',texto);       //  Salvar LOG de inicialização
                                          SA_EnviarVSPAgue(texto);                         //  Enviando o texto para o VSPAgue
                                          //------------------------------------
                                       end;
                                    //------------------------------------
                                 end
                              else if LRetornoSolicitacaoPIX.automacao_coleta_tipo='D' then  // Coletar data
                                 begin
                                    //------------------------------------
                                    //   Coletar data
                                    //------------------------------------
                                    if LRetornoSolicitacaoPIX.automacao_coleta_mascara='dd/MM/yyyy' then
                                       begin
                                          //------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                          SA_ColetarValor(LRetornoSolicitacaoPIX.automacao_coleta_mensagem,'99/99/9999',false);
                                          //------------------------------
                                          frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                                          frmwebtef.dado_digitado := '';
                                          frmwebtef.Cancelar      := false;
                                          Data_Digitada           := '';
                                          while (Data_Digitada='') and (not frmwebtef.Cancelar) do
                                             begin
                                                //------------------------
                                                sleep(10);
                                                //------------------------
                                                if (frmwebtef.dado_digitado<>'') and (SA_DataValida(frmwebtef.dado_digitado)) then
                                                   Data_Digitada := frmwebtef.dado_digitado
                                                else if (frmwebtef.dado_digitado<>'') then
                                                   begin
                                                      frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                                      frmwebtef.pnalerta.Color        := clRed;
                                                      frmwebtef.pnalerta.Font.Color   := clYellow;
                                                      frmwebtef.dado_digitado         := '';
                                                   end;
                                                //------------------------
                                             end;
                                          //------------------------------
                                          frmwebtef.pncaptura.Visible := false;
                                          frmwebtef.edtdado.Enabled   := false;
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          //------------------------------
                                          if SA_DataValida(Data_Digitada) then
                                             begin
                                                texto := 'automacao_coleta_informacao="'+Data_Digitada+'"'+#13+
                                                         'automacao_coleta_retorno="0"'+#13+
                                                         'automacao_coleta_sequencial="'+LRetornoSolicitacaoPIX.automacao_coleta_sequencial+'"';
                                                SA_SalvarLog('COLETA ENVIO',texto);              //  Salvar LOG de inicialização
                                                SA_EnviarVSPAgue(texto);                    //  Enviando o texto para o VSPAgue
                                             end;
                                       end;
                                    //------------------------------------
                                 end
                              else if LRetornoSolicitacaoPIX.automacao_coleta_tipo='N' then  // Coletar numérico
                                 begin
                                    //------------------------------------
                                    //   Coletar dado numérico
                                    //------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                    SA_ColetarValor(LRetornoSolicitacaoPIX.automacao_coleta_mensagem,'',false);
                                    frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                                    frmwebtef.dado_digitado := '';
                                    frmwebtef.Cancelar      := false;
                                    frmwebtef.AceitaVazio   := false;
                                    Numero_Digitado         := '';
                                    while (Numero_Digitado='') and (not frmwebtef.Cancelar) do
                                       begin
                                          //------------------------------
                                          sleep(10);
                                          //------------------------------
                                          if (LRetornoSolicitacaoPIX.automacao_coleta_opcao.count>0) and (frmwebtef.dado_digitado<>'') then
                                             begin
                                                if SA_ValidarOpcao(frmwebtef.dado_digitado,LRetornoSolicitacaoPIX.automacao_coleta_opcao) then
                                                   Numero_Digitado := frmwebtef.dado_digitado;
                                             end
                                          else if (frmwebtef.dado_digitado<>'') or (length(frmwebtef.dado_digitado)>1)  then
                                             Numero_Digitado := frmwebtef.dado_digitado
                                          else if (frmwebtef.dado_digitado<>'') then
                                             begin
                                                frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                                frmwebtef.pnalerta.Color        := clRed;
                                                frmwebtef.pnalerta.Font.Color   := clYellow;
                                                frmwebtef.dado_digitado         := '';
                                             end;
                                          //------------------------------
                                       end;
                                    //------------------------------------
                                    if Numero_Digitado='&*&' then
                                       Numero_Digitado := '';
                                    //------------------------------------
                                    frmwebtef.pncaptura.Visible := false;
                                    frmwebtef.edtdado.Enabled   := false;
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    //------------------------------------
                                    texto := 'automacao_coleta_informacao="'+Numero_Digitado+'"'+#13+
                                             'automacao_coleta_retorno="0"'+#13+
                                             'automacao_coleta_sequencial="'+LRetornoSolicitacaoPIX.automacao_coleta_sequencial+'"';
                                    SA_SalvarLog('COLETA NUMERO ENVIO',texto);       //  Salvar LOG de inicialização
                                    SA_EnviarVSPAgue(texto);                         //  Enviando o texto para o VSPAgue
                                    //------------------------------------
                                 end
                              else
                                 begin
                                    //------------------------------------
                                    texto := 'automacao_coleta_retorno="0"'+#13+
                                             'automacao_coleta_sequencial="'+LRetornoSolicitacaoPIX.automacao_coleta_sequencial+'"';
                                    SA_SalvarLog('COLETA ENVIO',texto);              //  Salvar LOG de inicialização
                                    SA_EnviarVSPAgue(texto);                    //  Enviando o texto para o VSPAgue
                                    //------------------------------------
                                 end;
                              //------------------------------------------
                           end
                        else if LRetornoSolicitacaoPIX.automacao_coleta_retorno='9' then  // Ocorreu um erro, transação rejeitada
                           begin
                              //------------------------------------------
                              //  Houve um problema
                              //------------------------------------------
                              sair := true;
                              frmwebtef.mensagem := ' '+#13+'OCORREU UM PROBLEMA COM A TRANSAÇÃO'+#13+' '+#13+
                                                    LRetornoSolicitacaoPIX.automacao_coleta_mensagem;
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                              while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                 begin
                                    sleep(50);
                                 end;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------
                           end;
                     //------------------------------------------------
                     end
                  else if LRetornoSolicitacaoPIX.retorno>='2' then  // Falhou, ocorreu algum erro
                     begin
                        //------------------------------------------------------
                        // Ocorreu alguma falha, transação não aprovada
                        //------------------------------------------------------
                        TextoAjuste := 'sequencial="'+Lsequencial.tostring+'"'+#13+
                                       'retorno="9"';
                        SA_SalvarLog('ENCERRANDO A OPERACAO ERRONEA',TextoAjuste);  //  Salvar LOG
                        SA_EnviarVSPAgue(TextoAjuste);                    //  Enviando o texto para o V  SPAgue

                        //------------------------------------------------------
                        sair := true;
                        frmwebtef.mensagem := LRetornoSolicitacaoPIX.mensagem;
                        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                        TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                        //---------------------------------------------------------------
                        while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                           begin
                              sleep(50);
                           end;
                        TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                        //------------------------------------------------
                     end
                  else if (LRetornoSolicitacaoPIX.retorno='') and (LRetornoSolicitacaoPIX.automacao_coleta_retorno='')  then  // Expirou ou pode ser cancelado
                     begin
                        if LRetornoSolicitacaoPIX.transacao_resposta='TO' then
                           begin
                              //------------------------------------------------
                              // Tempo expirou
                              //------------------------------------------------
                              sair := true;
                              frmwebtef.mensagem := 'O tempo para pagar expirou.';
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);   // Ativar o botão cancelar na tela de TEF
                              //---------------------------------------------------------------
                              while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                 begin
                                    sleep(50);
                                 end;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                           end
                        else
                           begin
                              //------------------------------------------------
                              if frmwebtef.Cancelar then    // Realizar o cancelamento do PIX
                                 begin
                                    frmwebtef.Cancelar := false;
                                    frmwebtef.mensagem := 'Cancelado pelo operador...';
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    texto := 'automacao_coleta_retorno="9"'+#13+
                                             'automacao_coleta_sequencial="'+UltimoSequencialColeta+'"';
                                    SA_SalvarLog('CANCELAMENTO ENVIO',texto);              //  Salvar LOG de inicialização
                                    SA_EnviarVSPAgue(texto);                    //  Enviando o texto para o VSPAgue
                                    resposta               := SA_LerRespostaVSPaguePIX;          // Fazendo a leitura do retorno
                                    if resposta<>'' then
                                       SA_SalvarLog('RESPOSTA CANCELAMENTO DE PIX',resposta); // Salvando LOG do retorno da solicitação de cancelamento PIX
                                    LRetornoSolicitacaoPIX := SA_ParsingRetornoPIX(resposta); // Sesmontando a resposta do PIX
                                    sair := true;
                                 end;
                              //------------------------------------------------
                           end;
                     end;
                  //------------------------------------------------------
               end;

            //------------------------------------------------------------
         end
      else
         begin
            //---------------------------------------------------------------
            //  Ocorreu um erro
            //---------------------------------------------------------------
            if LRetornoInicializar.mensagem<>'' then
               frmwebtef.mensagem := SA_MensagenErroRetornoTEF
            else
               frmwebtef.mensagem := LRetornoInicializar.mensagem;
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT); // Ativar o botão cancelar na tela de TEF
            //---------------------------------------------------------------
            while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
               begin
                  sleep(50);
               end;
            TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
            //---------------------------------------------------------------
         end;

      //------------------------------------------------------------------
      //---------------------------------------------------------------------------
      //   Finalizar operação
      //---------------------------------------------------------------------------
      SA_Finalizar;   // Finalizando a conexão com o TEF
      //------------------------------------------------------------------------
      //   Fechando a janela do TEF
      //------------------------------------------------------------------------
      LIdTCPClient.DisConnect;
      //------------------------------------------------------------------------
   end);
   //------------------------------------------------------------------------
   Mythread.onterminate := MythreadEnd;
   Mythread.start;
   //------------------------------------------------------------------------
end;

procedure TVSPagueTEF.SA_ProcessarPagamentoVS;
var
   Mythread         : TThread;
   resposta         : string;
   sair             : boolean;
   Imprimir         : boolean;
   //---------------------------------------------------------------------------
   opcoesColeta    : TStringList;
   texto           : string;   // Para o envio de coleta para o VSPague
   opcaoColeta     : integer;  // Para obter a opção de menu
   Data_Digitada   : string;   // Quando é coletada uma data
   Numero_Digitado : string;   // Quando a coleta é numérica
   //---------------------------------------------------------------------------
   SequeciaColeta  : integer;
   TextoAjuste     : string;
   //---------------------------------------------------------------------------
begin
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpTEFVSPAgue;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LPagamento_Forma;
   frmwebtef.lbvalor.Caption  := transform(LPagamento_Valor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;

   Mythread := TThread.CreateAnonymousThread(procedure
   begin
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Conectando com VSPague...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      try
         LIdTCPClient.Connect;   // Abrindo a conexão SOCKET com o VSPAGUE
      except
        frmwebtef.mensagem := 'O Gerenciador VSPague não está ativo !';
        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
        TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT); // Ativar o botão cancelar na tela de TEF
        //---------------------------------------------------------------
        while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
           begin
              sleep(50);
           end;
        TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
        //---------------------------------------------------------------
         lTEFAprovado := false;
         exit;
      end;
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Inicializando TEF...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      SequeciaColeta  := 0;
      SA_Inicializar;     // Inicializando a conexão com o TEF
      if (strtointdef(LRetornoInicializar.retorno,0)<=2) then  // Sucesso, continuar
         begin
            //------------------------------------------------------------
            //    O TEF tá inicializado e operando normalmente
            //------------------------------------------------------------
            SA_EnviarVenda;   // Fazendo a solicitação da venda
            while not sair do
               begin
                  resposta := SA_LerRespostaVSPague;          // Fazendo a leitura do retorno
                  SA_SalvarLog('RESPOSTA SOLICITACAO DE VENDA',resposta); // Salvando LOG do retorno da solicitação de venda
                  LRetornoSolicitacaoVenda := SA_ParsingRetornoVenda(resposta);  // Desmontando, separando campos
                  if LRetornoSolicitacaoVenda.retorno='' then  // tem que continuar, fazer a coleta se necessário
                     begin
                        //------------------------------------------------
                        //  Fazer coleta
                        //------------------------------------------------
                        if LRetornoSolicitacaoVenda.automacao_coleta_retorno='0' then  // Só responder, não é necessário informar valor
                           begin
                              //------------------------------------------
                              SequeciaColeta  := strtointdef(LRetornoSolicitacaoVenda.automacao_coleta_sequencial,0);
                              if LRetornoSolicitacaoVenda.automacao_coleta_mensagem<>'' then
                                 begin
                                    //------------------------------------
                                    //   Exibir mensagem
                                    //------------------------------------
                                    frmwebtef.mensagem := LRetornoSolicitacaoVenda.automacao_coleta_mensagem;
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                 end;
                              //------------------------------------------
                              if (LRetornoSolicitacaoVenda.automacao_coleta_tipo='X') or (LRetornoSolicitacaoVenda.automacao_coleta_tipo='A') then  // Coleta de um tipo texto
                                 begin
                                    //------------------------------------
                                    //   Verificar como é a captação
                                    //------------------------------------
                                    if LRetornoSolicitacaoVenda.automacao_coleta_opcao.count>0 then   // Menu
                                       begin
                                          //------------------------------
                                          //   Perguntar a opção
                                          //------------------------------
                                          opcoesColeta       := TStringList.Create;
                                          opcoesColeta.text  := LRetornoSolicitacaoVenda.automacao_coleta_opcao.text;
                                          frmwebtef.mensagem := LRetornoSolicitacaoVenda.automacao_coleta_mensagem;
                                          frmwebtef.opcoes   := opcoesColeta;
                                          frmwebtef.opcao    := -1;
                                          frmwebtef.tecla    := '';
                                          frmwebtef.Cancelar := false;
                                          //------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                          opcaoColeta  := SA_PerguntarOpcoes(opcoesColeta.count);
                                          //------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          //------------------------------
                                          if opcaoColeta<>-1 then
                                             begin
                                                //------------------------
                                                //  Enviar seleção do menu
                                                //------------------------
                                                texto := 'automacao_coleta_informacao="'+opcoesColeta[opcaoColeta-1]+'"'+#13+
                                                         'automacao_coleta_retorno="0"'+#13+
                                                         'automacao_coleta_sequencial="'+LRetornoSolicitacaoVenda.automacao_coleta_sequencial+'"';
                                                SA_SalvarLog('COLETA ENVIO',texto);              //  Salvar LOG de inicialização
                                                SA_EnviarVSPAgue(texto);                    //  Enviando o texto para o VSPAgue
                                                //------------------------
                                             end
                                          else
                                             begin
                                                sair := true;
                                             end;
                                          //------------------------------
                                       end
                                    else
                                       begin
                                          //------------------------------
                                          //  Digitar um valor alfanumérico
                                          //------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,
                                           procedure
                                              begin
                                                 SA_ColetarValor(LRetornoSolicitacaoVenda.automacao_coleta_mensagem,'',false);
                                              end);
                                          frmwebtef.CaracteresDigitaveis := ['0'..'9','A'..'z',#32,#8];
                                          frmwebtef.dado_digitado := '';
                                          frmwebtef.Cancelar      := false;
                                          frmwebtef.AceitaVazio   := false;
                                          Numero_Digitado         := '';
                                          while (Numero_Digitado='') and (not frmwebtef.Cancelar) do
                                             begin
                                                //------------------------
                                                sleep(10);
                                                //------------------------
                                                if frmwebtef.dado_digitado<>'' then
                                                   Numero_Digitado := frmwebtef.dado_digitado
                                                else if (frmwebtef.dado_digitado='') then
                                                   begin
                                                      frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                                      frmwebtef.pnalerta.Color        := clRed;
                                                      frmwebtef.pnalerta.Font.Color   := clYellow;
                                                      frmwebtef.dado_digitado         := '';
                                                   end;
                                                //------------------------
                                             end;
                                          //------------------------------
                                          frmwebtef.pncaptura.Visible := false;
                                          frmwebtef.edtdado.Enabled   := false;
                                          //------------------------------
                                          texto := 'automacao_coleta_informacao="'+Numero_Digitado+'"'+#13+
                                                   'automacao_coleta_retorno="0"'+#13+
                                                   'automacao_coleta_sequencial="'+LRetornoSolicitacaoVenda.automacao_coleta_sequencial+'"';
                                          SA_SalvarLog('COLETA NUMERO ENVIO',texto);       //  Salvar LOG de inicialização
                                          SA_EnviarVSPAgue(texto);                         //  Enviando o texto para o VSPAgue
                                          //------------------------------------
                                       end;
                                    //------------------------------------
                                 end
                              else if LRetornoSolicitacaoVenda.automacao_coleta_tipo='D' then  // Coletar data
                                 begin
                                    //------------------------------------
                                    //   Coletar data
                                    //------------------------------------
                                    if LRetornoSolicitacaoVenda.automacao_coleta_mascara='dd/MM/yyyy' then
                                       begin
                                          //------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,procedure
                                             begin
                                                SA_ColetarValor(LRetornoSolicitacaoVenda.automacao_coleta_mensagem,'99/99/9999',false);
                                             end);
                                          //------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                          frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                                          frmwebtef.dado_digitado := '';
                                          frmwebtef.Cancelar      := false;
                                          Data_Digitada           := '';
                                          while (Data_Digitada='') and (not frmwebtef.Cancelar) do
                                             begin
                                                //------------------------
                                                sleep(10);
                                                //------------------------
                                                if (frmwebtef.dado_digitado<>'') and (SA_DataValida(frmwebtef.dado_digitado)) then
                                                   Data_Digitada := frmwebtef.dado_digitado
                                                else if (frmwebtef.dado_digitado<>'') then
                                                   begin
                                                      frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                                      frmwebtef.pnalerta.Color        := clRed;
                                                      frmwebtef.pnalerta.Font.Color   := clYellow;
                                                      frmwebtef.dado_digitado         := '';
                                                   end;
                                                //------------------------
                                             end;
                                          //------------------------------
                                          frmwebtef.pncaptura.Visible := false;
                                          frmwebtef.edtdado.Enabled   := false;
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          //------------------------------
                                          if SA_DataValida(Data_Digitada) then
                                             begin
                                                texto := 'automacao_coleta_informacao="'+Data_Digitada+'"'+#13+
                                                         'automacao_coleta_retorno="0"'+#13+
                                                         'automacao_coleta_sequencial="'+LRetornoSolicitacaoVenda.automacao_coleta_sequencial+'"';
                                                SA_SalvarLog('COLETA ENVIO',texto);              //  Salvar LOG de inicialização
                                                SA_EnviarVSPAgue(texto);                    //  Enviando o texto para o VSPAgue
                                             end;
                                       end;
                                    //------------------------------------
                                 end
                              else if LRetornoSolicitacaoVenda.automacao_coleta_tipo='N' then  // Coletar numérico
                                 begin
                                    //------------------------------------
                                    //   Coletar dado numérico
                                    //------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,
                                     procedure
                                        begin
                                           SA_ColetarValor(LRetornoSolicitacaoVenda.automacao_coleta_mensagem,'',false);
                                        end);
                                    frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                                    frmwebtef.dado_digitado := '';
                                    frmwebtef.Cancelar      := false;
                                    frmwebtef.AceitaVazio   := false;
                                    Numero_Digitado         := '';
                                    while (Numero_Digitado='') and (not frmwebtef.Cancelar) do
                                       begin
                                          //------------------------------
                                          sleep(10);
                                          //------------------------------
                                          if (LRetornoSolicitacaoVenda.automacao_coleta_opcao.count>0) and (frmwebtef.dado_digitado<>'') then
                                             begin
                                                if SA_ValidarOpcao(frmwebtef.dado_digitado,LRetornoSolicitacaoVenda.automacao_coleta_opcao) then
                                                   Numero_Digitado := frmwebtef.dado_digitado;
                                             end
                                          else if (frmwebtef.dado_digitado<>'') or (length(frmwebtef.dado_digitado)>1)  then
                                             Numero_Digitado := frmwebtef.dado_digitado
                                          else if (frmwebtef.dado_digitado<>'') then
                                             begin
                                                frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                                frmwebtef.pnalerta.Color        := clRed;
                                                frmwebtef.pnalerta.Font.Color   := clYellow;
                                                frmwebtef.dado_digitado         := '';
                                             end;
                                          //------------------------------
                                       end;
                                    //------------------------------------
                                    if Numero_Digitado='&*&' then
                                       Numero_Digitado := '';
                                    //------------------------------------
                                    frmwebtef.pncaptura.Visible := false;
                                    frmwebtef.edtdado.Enabled   := false;
                                    //------------------------------------
                                    texto := 'automacao_coleta_informacao="'+Numero_Digitado+'"'+#13+
                                             'automacao_coleta_retorno="0"'+#13+
                                             'automacao_coleta_sequencial="'+LRetornoSolicitacaoVenda.automacao_coleta_sequencial+'"';
                                    SA_SalvarLog('COLETA NUMERO ENVIO',texto);       //  Salvar LOG de inicialização
                                    SA_EnviarVSPAgue(texto);                         //  Enviando o texto para o VSPAgue
                                    //------------------------------------
                                 end
                              else
                                 begin
                                    //------------------------------------
                                    texto := 'automacao_coleta_retorno="0"'+#13+
                                             'automacao_coleta_sequencial="'+LRetornoSolicitacaoVenda.automacao_coleta_sequencial+'"';
                                    SA_SalvarLog('COLETA ENVIO',texto);              //  Salvar LOG de inicialização
                                    SA_EnviarVSPAgue(texto);                    //  Enviando o texto para o V  SPAgue
                                    //------------------------------------
                                 end;
                              //------------------------------------------
                           end
                        else if LRetornoSolicitacaoVenda.automacao_coleta_retorno='5' then  // Ocorreu um erro, transação rejeitada
                           begin
                              TextoAjuste := 'automacao_coleta_retorno="0"'+#13+
                                             'automacao_coleta_sequencial="0"';
                              SA_SalvarLog('COLETA ENVIO',TextoAjuste);              //  Salvar LOG de inicialização
                              SA_EnviarVSPAgue(TextoAjuste);                    //  Enviando o texto para o V  SPAgue                              /
                           end
                        else if strtointdef(LRetornoSolicitacaoVenda.automacao_coleta_retorno,9)>=2 then  // Ocorreu um erro, transação rejeitada
                           begin
                              //------------------------------------------
                              //  Houve um problema
                              //------------------------------------------
                              if SequeciaColeta=0 then
                                 begin
                                    frmwebtef.mensagem := ' '+#13+'OCORREU UM PROBLEMA COM A TRANSAÇÃO'+#13+' '+#13+
                                                          LRetornoSolicitacaoVenda.automacao_coleta_mensagem;
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    TextoAjuste := 'automacao_coleta_retorno="9"'+#13+
                                                   'automacao_coleta_sequencial="'+LRetornoSolicitacaoVenda.automacao_coleta_sequencial+'"';
                                    SA_SalvarLog('COLETA ENVIO',TextoAjuste);              //  Salvar LOG de inicialização
                                    SA_EnviarVSPAgue(TextoAjuste);                    //  Enviando o texto para o V  SPAgue
                                 end
                              else
                                 begin
                                    TextoAjuste := 'automacao_coleta_retorno="9"'+#13+
                                                   'automacao_coleta_sequencial="'+LRetornoSolicitacaoVenda.automacao_coleta_sequencial+'"';


                                    SA_SalvarLog('ENCERRANDO A OPERACAO ERRONEA',TextoAjuste);  //  Salvar LOG
                                    SA_EnviarVSPAgue(TextoAjuste);                    //  Enviando o texto para o V  SPAgue

                                    sair := true;
                                    frmwebtef.mensagem := ' '+#13+'OCORREU UM PROBLEMA COM A TRANSAÇÃO'+#13+' '+#13+
                                                          LRetornoSolicitacaoVenda.automacao_coleta_mensagem;
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                    while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                       begin
                                          sleep(50);
                                       end;
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                 end;
                              //------------------------------------------
                           end;

                        //------------------------------------------------
                     end
                  else if LRetornoSolicitacaoVenda.retorno='0' then  // Sucesso, proceder com a confirmação
                     begin
                        //------------------------------------------------
                        //  Confirmação da operação
                        //------------------------------------------------
                        SA_ConfirmarVenda; // Fazer confirmação da venda
                        if (LRetornoConfirmacaoVenda.retorno='0') or (LRetornoConfirmacaoVenda.retorno='1') then
                           begin
                              sair         := true;
                              LTEFAprovado := true;
                              //------------------------------------------
                              //   Processar a impressão
                              //------------------------------------------
                              if LRetornoSolicitacaoVenda.Transacao_Comprovante2via<>'' then   // Comprovante do cliente
                                 begin
                                    //------------------------------------
                                    //   Comprovante do cliente
                                    //------------------------------------
                                    imprimir := LVSPagueImpressaoViaCLI=tpTEFImprimirSempre;
                                    if LVSPagueImpressaoViaCLI=tpTEFPerguntar then
                                       begin
                                          //------------------------------
                                          //   Perguntar se quer imprimir
                                          //------------------------------
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
                                          //--------------------------------
                                          while (not frmwebtef.Cancelar) do
                                             begin
                                               if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                  begin
                                                     //------------------
                                                     imprimir := true;
                                                     frmwebtef.Cancelar := true;
                                                     //------------------
                                                  end
                                               else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                                  frmwebtef.Cancelar := true;
                                                //--------------------------
                                                sleep(50);
                                             end;
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          //------------------------------
                                          frmwebtef.Cancelar := false;
                                          //------------------------------
                                       end;
                                    if imprimir then
                                       SA_ImprimirTexto(LRetornoSolicitacaoVenda.Transacao_Comprovante2via,limpressora);
                                    //------------------------------------
                                 end;
                              //------------------------------------------
                              //  Comprovante da loja
                              //------------------------------------------
                              if LRetornoSolicitacaoVenda.ComprovanteLoja<>'' then   // Comprovante do LOJISTA
                                 begin
                                    imprimir := LVSPagueImpressaoViaLJ=tpTEFImprimirSempre;
                                    //------------------------------------
                                    if LVSPagueImpressaoViaLJ=tpTEFPerguntar then
                                       begin
                                          //------------------------------
                                          //   Perguntar se quer imprimir
                                          //------------------------------
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
                                           //--------------------------------
                                           while (not frmwebtef.Cancelar) do
                                              begin
                                                if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                   begin
                                                      //------------------
                                                      imprimir           := true;
                                                      frmwebtef.Cancelar := true;
                                                      //------------------
                                                   end
                                                else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                                   frmwebtef.Cancelar := true;
                                                 //--------------------------
                                                 sleep(50);
                                              end;
                                          //------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          frmwebtef.Cancelar := false;
                                          //------------------------------
                                       end;
                                    //------------------------------------
                                    if imprimir then
                                       begin
                                          if LImpressaoSimplificada then
                                             SA_ImprimirTexto(LRetornoSolicitacaoVenda.ComprovanteLoja,limpressora)   // Imprimindo
                                          else
                                             SA_ImprimirTexto(LRetornoSolicitacaoVenda.Transacao_Comprovante1via,limpressora);   // Imprimindo

                                       end;
                                 end;
                              //------------------------------------------
                           end
                        else
                           begin
                              //------------------------------------------
                              //  Houve um problema na confirmação
                              //------------------------------------------
                              sair := true;
                              frmwebtef.mensagem := SA_MensagenErroRetornoTEF(LRetornoConfirmacaoVenda.retorno)+#13+
                                                    LRetornoConfirmacaoVenda.mensagem;
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              SA_NaoConfirmarVenda; // Cancelar venda em andamento - confirmação da venda falhou
                              while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                 begin
                                    sleep(50);
                                 end;
                              //------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------
                           end;

                        //------------------------------------------------
                     end
                  else if LRetornoSolicitacaoVenda.retorno='1' then  // Sucesso, não precisa confirmar
                     begin
                        //------------------------------------------------
                        //  Não precisa confirmar
                        //------------------------------------------------
                        //------------------------------------------------
                     end
                  else   // Ocorreu algum erro
                     begin
                        //------------------------------------------------------
                        //  Apresenta mensagem de erro
                        //------------------------------------------------------
                        TextoAjuste := 'sequencial="'+Lsequencial.tostring+'"'+#13+
                                       'retorno="9"';
                        SA_SalvarLog('ENCERRANDO A OPERACAO ERRONEA',TextoAjuste);  //  Salvar LOG
                        SA_EnviarVSPAgue(TextoAjuste);                    //  Enviando o texto para o V  SPAgue
                        //------------------------------------------------------
                        sair := true;
                        frmwebtef.mensagem := SA_MensagenErroRetornoTEF(LRetornoSolicitacaoVenda.retorno)+#13+
                                              LRetornoSolicitacaoVenda.mensagem;
                        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                        TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                        //---------------------------------------------------------------
                        while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                           begin
                              sleep(50);
                           end;
                        TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                        //------------------------------------------------
                     end

                  //------------------------------------------------------
               end;
            //------------------------------------------------------------
         end
      else
         begin
            //---------------------------------------------------------------
            //  Ocorreu um erro
            //---------------------------------------------------------------
            if LRetornoInicializar.mensagem<>'' then
               frmwebtef.mensagem := SA_MensagenErroRetornoTEF
            else
               frmwebtef.mensagem := LRetornoInicializar.mensagem;
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
            //---------------------------------------------------------------
            while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
               begin
                  sleep(50);
               end;
            TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
            //---------------------------------------------------------------
         end;


      //---------------------------------------------------------------------------
      //   Finalizar operação
      //---------------------------------------------------------------------------
      SA_Finalizar;   // Finalizando a conexão com o TEF
      //------------------------------------------------------------------------
      //   Fechando a janela do TEF
      //------------------------------------------------------------------------
      LIdTCPClient.DisConnect;
      //------------------------------------------------------------------------


      //------------------------------------------------------------------------
   end);
   //------------------------------------------------------------------------
   Mythread.onterminate := MythreadEnd;
   Mythread.start;
   //------------------------------------------------------------------------
end;



procedure TVSPagueTEF.SA_ProcessarPendenciasVS;
var
   //---------------------------------------------------------------------------
   Mythread         : TThread;
   //---------------------------------------------------------------------------
begin
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpTEFVSPAgue;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LPagamento_Forma;
   frmwebtef.lbvalor.Caption  := transform(LPagamento_Valor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   Mythread := TThread.CreateAnonymousThread(procedure
   begin
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Conectando com VSPague...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      try
         LIdTCPClient.Connect;   // Abrindo a conexão SOCKET com o VSPAGUE
      except
        frmwebtef.mensagem := 'O Gerenciador VSPague não está ativo !';
        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
        TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT); // Ativar o botão cancelar na tela de TEF
        //---------------------------------------------------------------
        while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
           begin
              sleep(50);
           end;
        TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
        //---------------------------------------------------------------
         lTEFAprovado := false;
         exit;
      end;
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Inicializando TEF...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      SA_Inicializar;     // Inicializando a conexão com o TEF
      //------------------------------------------------------------------
      //  Fazer chamada ao PIX
      //------------------------------------------------------------------
      if (strtointdef(LRetornoInicializar.retorno,0)<=2) then  // Sucesso, continuar
         begin
            //------------------------------------------------------------
            SA_EnviarVPendencias;


            //------------------------------------------------------------
         end
      else
         begin
            //---------------------------------------------------------------
            //  Ocorreu um erro
            //---------------------------------------------------------------
            if LRetornoInicializar.mensagem<>'' then
               frmwebtef.mensagem := SA_MensagenErroRetornoTEF
            else
               frmwebtef.mensagem := LRetornoInicializar.mensagem;
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT); // Ativar o botão cancelar na tela de TEF
            //---------------------------------------------------------------
            while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
               begin
                  sleep(50);
               end;
            TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
            //---------------------------------------------------------------
         end;
      //---------------------------------------------------------------------------
      //   Finalizar operação
      //---------------------------------------------------------------------------
      SA_Finalizar;   // Finalizando a conexão com o TEF
      //------------------------------------------------------------------------
      //   Fechando a janela do TEF
      //------------------------------------------------------------------------
      LIdTCPClient.DisConnect;
      //------------------------------------------------------------------------
   end);
   //------------------------------------------------------------------------
   Mythread.onterminate := MythreadEnd;
   Mythread.start;
   //------------------------------------------------------------------------




end;

procedure TVSPagueTEF.SA_SalvarLog(titulo, dado: string);
begin
   if LSalvarLog then
      SA_Salva_Arquivo_Incremental(titulo + ' ' + formatdatetime('dd/mm/yyyy hh:mm:ss',now)+#13+dado,GetCurrentDir+'\mkm_log\logTEFVSPague'+formatdatetime('yyyymmdd',date)+'.txt');
end;

function TVSPagueTEF.SA_TextoForma(FormaPgto: TtpVSPagueFormaPgto): string;
begin
   case formapgto of
      VSPgtoPerguntar                : result := 'transacao="Cartao Vender"';
      VSPgtoCreditoPerguntar         : result := 'transacao="Cartao Vender"'+#13+'transacao_tipo_cartao="Credito"'+#13;
      VSPgtoCreditoVista             : result := 'transacao="Cartao Vender"'+#13+'transacao_pagamento="A vista"'+#13+'transacao_tipo_cartao="Credito"'+#13;
      VSPgtoCreditoPaceladoPerguntar : result := 'transacao="Cartao Vender"'+#13+'transacao_pagamento="Parcelado"'+#13+'transacao_tipo_cartao="Credito"'+#13;
      VSPgtoCreditoParceladoLoja     : result := 'transacao="Cartao Vender"'+#13+'transacao_pagamento="Parcelado"'+#13+'transacao_tipo_cartao="Credito"'+#13;
      VSPgtoCreditoParceladoADM      : result := 'transacao="Cartao Vender"'+#13+'transacao_pagamento="Parcelado"'+#13+'transacao_tipo_cartao="Credito"'+#13;
      VSPgtoDebitoPerguntar          : result := 'transacao="Cartao Vender"'+#13+'transacao_tipo_cartao="Debito"'+#13;
      VSPgtoDebitoVista              : result := 'transacao="Cartao Vender"'+#13+'transacao_pagamento="A vista"'+#13+'transacao_tipo_cartao="Debito"'+#13;
      VSPgtoDebitpPre                : result := 'transacao="Cartao Vender"'+#13+'transacao_pagamento="Pre-datado"'+#13+'transacao_tipo_cartao="Credito"'+#13;
      VSPgtoPIX                      : result := 'transacao="PIX Vender"'+#13;
   end;
end;

procedure TVSPagueTEF.SA_EnviarExtrato;
var
   texto : string;
begin
   //---------------------------------------------------------------------------
   inc(LSequencial);  // Incrementando o sequencial
   //---------------------------------------------------------------------------
   texto := 'sequencial="'+LSequencial.tostring+'"'+#13+   // Script para venda
            'servico="executar"'+#13+
            'retorno="1"'+#13+
            'transacao="Administracao Extrato Transacao"';
   //---------------------------------------------------------------------------
   SA_SalvarLog('SOLICITAR EXTRATO',texto); // Salvar LOG
   //---------------------------------------------------------------------------
   SA_EnviarVSPAgue(texto);  // Enviando a solicitação de extrato ao VSPague
   //---------------------------------------------------------------------------
end;

procedure TVSPagueTEF.SA_EnviarVenda;
var
   texto : string;
   VlStr : string;
begin
   VlStr := trim(FormatFloat('#####0.00',LPagamento_Valor));
   VlStr := stringreplace(vlstr,',','.',[rfReplaceAll]);
   //---------------------------------------------------------------------------
   inc(LSequencial);  // Incrementando o sequencial
   //---------------------------------------------------------------------------
   texto := 'sequencial="'+LSequencial.tostring+'"'+#13+   // Script para venda
            'servico="executar"'+#13+
            'retorno="1"'+#13+
            SA_TextoForma(LPagamento_Operacao)+
            'transacao_valor="'+VlStr+'"';
   //---------------------------------------------------------------------------
   SA_SalvarLog('SOLICITACAO DE VENDA',texto); // Salvar LOG
   //---------------------------------------------------------------------------
   SA_EnviarVSPAgue(texto);  // Enviando a solicitação de venda ao VSPague
   //---------------------------------------------------------------------------
end;

procedure TVSPagueTEF.SA_EnviarVPendencias;
var
   texto : string;
begin
   //---------------------------------------------------------------------------
   inc(LSequencial);  // Incrementando o sequencial
   //---------------------------------------------------------------------------
   texto := 'sequencial="'+LSequencial.tostring+'"'+#13+   // Script para venda
            'retorno="1"'+#13+
            'servico="executar"'+#13+
            'transacao="Administracao Pendente"'+#13+
            'transacao_opcao="Confirmar"';
   //---------------------------------------------------------------------------
   SA_SalvarLog('VERIFICAR PENDENCIAS',texto); // Salvar LOG
   //---------------------------------------------------------------------------
   SA_EnviarVSPAgue(texto);  // Enviando a solicitação de venda ao VSPague
   //---------------------------------------------------------------------------
end;

function TVSPagueTEF.SA_ValidarOpcao(valor: string;  lista: TStringList): boolean;
begin
   result := lista.IndexOf(valor)>-1;
end;

function TVSPagueTEF.SA_VSExtrairTag(tag, texto: string): string;
var
   inicio  : integer;
   posicao : integer;
   sair    : boolean;
begin
   Result := '';
   inicio := pos(tag+'="',texto);
   if inicio=0 then
      exit;
   //---------------------------------------------------------------------------
   inc(inicio,length(tag)+2);
   posicao := inicio;
   sair    := texto[posicao]='"';
   while not sair do
      begin
         inc(posicao);
         sair := (texto[posicao]='"') or (posicao>=length(texto));
      end;
   if posicao>inicio then
      Result := copy(texto,inicio,posicao-inicio);
   //---------------------------------------------------------------------------
end;

function TVSPagueTEF.transform(valor: real): string;
begin
   Result := '          '+formatfloat('###,###,##0.00',valor);
   Result := copy(Result,length(Result)-13,14);
end;

end.
