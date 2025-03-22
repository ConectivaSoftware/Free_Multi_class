unit uEmbedIT;

interface

uses
   JSON,
   ACBrJSON,
   ACBRNfe.Classes,
   system.classes,
   System.SysUtils,
   System.Threading,
   Vcl.forms,
   Vcl.Graphics,
   vcl.dialogs,
   udmMulticlass,
   ACBrPosPrinter,
   uKSTypes,
   uMultiClassfuncoes,
   uwebtefmp,
   embed_lib;

type
   //---------------------------------------------------------------------------
   TResultado = record
      //------------------------------------------------------------------------
      TEFAprovado        : boolean;
      //------------------------------------------------------------------------
      status_code        : integer;
      status_message     : string;
      //------------------------------------------------------------------------
      aid                : string; // AID - Não sei o que é, deve ser um número que identifica a transação
      nsu                : string; // NSU
      valor              : string; // Valor da transação
      parcelas           : string; // Quantidade de parcelas
      financiamento      : string; // Tipo de financiamento - Loja, ADM ou NONE
      codigo_autorizacao : string; // Código de autorização
      bandeira           : string; // Bandeira do cartão
      rede               : string; // Bandeira do cartão
      numero_cartao      : string; // Mascara do cartão
      data_hora          : string; // Data da transação tpo TimeStamp
      tipo_cartao        : string; // Débito ou crédito,
      via_loja           : string; // Comprovante da loja
      via_cliente        : string; // Comprovante do cliente
      ComprovanteLoja    : string; // Comprovante simplificado da loja
      //------------------------------------------------------------------------
   end;
   //---------------------------------------------------------------------------
   TResposta = record
      codigo    : integer;
      Mensagem  : string;
      Resultado : TResultado;
   end;
   //---------------------------------------------------------------------------
   TtpTEF             = (EmbedPOS,EmbedTEF);   // Tipo de TEF que vai transacionar - Smart Pos ou TEF convencional
   //---------------------------------------------------------------------------
   TEmbedIT = class
      Private
         //---------------------------------------------------------------------
         lib : TEmbedLib;  //  Classe da LIB
         //---------------------------------------------------------------------
         LEmpresa    : TEmit;              // Dados do emitente da NFCe do padrão ACBR
         LImpressora : TKSConfigImpressora;  // Configuração da impressora
         //---------------------------------------------------------------------
         //   TEF Convencional
         //---------------------------------------------------------------------
         LCodigoAtivacao    : string;
         //---------------------------------------------------------------------
         //   Para transacionar com SMART POS
         //---------------------------------------------------------------------
         LPOSUsername     : string; // Nome de usuário fornecido
         LPOSPassword     : string; // Senha fornecida
         LPOSNumeroSerial : string; // Número serial do POS
         //---------------------------------------------------------------------
         LTipoTEF           : TtpTEF;
         //---------------------------------------------------------------------
         LEmbedPagueImpressaoViaCLI : TtpTEFImpressao;
         LEmbedPagueImpressaoViaLJ  : TtpTEFImpressao;
         LImpressaoSimplificada     : boolean;
         LSalvarLog                 : boolean;
         //---------------------------------------------------------------------
         LPagamento_Forma        : string;
         LPagamento_Valor        : real;
         LPagamento_Operacao     : TtpEmbedIFormaPgto;
         LPagamento_QtdeParcelas : integer;
         //---------------------------------------------------------------------
         LCancelamento_Forma : string;
         LCancelamento_Valor : real;
         LCancelamento_NSU   : string;
         LCancelamento_Data  : TDate;
         //---------------------------------------------------------------------
         lExecutando      : boolean;
         LRespostaTEF     : TResposta;  // Resultado da operação de TEF
         //---------------------------------------------------------------------
         procedure MythreadEnd(sender: tobject);
         procedure SA_MostramensagemT;
         procedure SA_CriarMenuT;
         procedure SA_MostrarBtCancelarT;
         procedure SA_DesativarBtCancelarT;
         procedure SA_DesativarMenuT;
         //---------------------------------------------------------------------
         function SA_OpcoesPagamento:TStringList;
         function SA_ItemMenuPgtoSelecionado(item:integer):TtpEmbedIFormaPgto;
         function SA_ParsingResposta(conteudo:string):TResposta;
         //---------------------------------------------------------------------
         //   Funções que operam com TEF convencional
         //---------------------------------------------------------------------
         Function SA_ConfigurarAPI:TResposta;
         function SA_IniciarApi:TResposta;
         function SA_DebitoAPI:TResposta;
         function SA_CreditoAPI:TResposta;
         function SA_GetStatusAPI:TResposta;
         function SA_FinalizarAPI:TResposta;
         function SA_DesfazerAPI:TResposta;
         function SA_CancelarAPI:TResposta;
         function SA_AbortarAPI:TResposta;
         //---------------------------------------------------------------------
      Public
         //---------------------------------------------------------------------
         constructor Create;
         //---------------------------------------------------------------------
         //   TEF Convencional
         //---------------------------------------------------------------------
         property CodigoAtivacao    : string read LCodigoAtivacao    write LCodigoAtivacao;    // Código fornecido pela EMBED quando do cadastramento do cliente
         //---------------------------------------------------------------------
         //   Para transacionar com SMART POS
         //---------------------------------------------------------------------
         property POSUsername     : string read LPOSUsername     write LPOSUsername;     // Nome de usuário fornecido
         property POSPassword     : string read LPOSPassword     write LPOSPassword;     // Senha fornecida
         property POSNumeroSerial : string read LPOSNumeroSerial write LPOSNumeroSerial; // Número serial do POS
        //----------------------------------------------------------------------
         property TipoTEF           : TtpTEF read LTipoTEF           write LTipoTEF;           // Tipo de TEF que vai transacionar - Smartpos ou TEF convencional
         //---------------------------------------------------------------------
         property EmbedPagueImpressaoViaCLI : TtpTEFImpressao   read LEmbedPagueImpressaoViaCLI write LEmbedPagueImpressaoViaCLI;
         property EmbedPagueImpressaoViaLJ  : TtpTEFImpressao   read LEmbedPagueImpressaoViaLJ  write LEmbedPagueImpressaoViaLJ;
         property ImpressaoSimplificada     : boolean           read LImpressaoSimplificada     write LImpressaoSimplificada;
         property SalvarLog                 : boolean           read LSalvarLog                 write LSalvarLog;
         //---------------------------------------------------------------------
         property Pagamento_Forma         : string              read LPagamento_Forma           write LPagamento_Forma;
         property Pagamento_Valor         : real                read LPagamento_Valor           write LPagamento_Valor;
         property Pagamento_Operacao      : TtpEmbedIFormaPgto  read LPagamento_Operacao        write LPagamento_Operacao;      // Metodo de pagamento
         property Pagamento_QtdeParcelas  : integer             read LPagamento_QtdeParcelas    write LPagamento_QtdeParcelas;  // Quantidade de parcelas - Quando for informado 0 o sistema perguta
         //---------------------------------------------------------------------
         property Cancelamento_Forma      : string              read LCancelamento_Forma        write LCancelamento_Forma;
         property Cancelamento_Valor      : real                read LCancelamento_Valor        write LCancelamento_Valor;
         property Cancelamento_NSU        : string              read LCancelamento_NSU          write LCancelamento_NSU;
         property Cancelamento_Data       : TDate               read LCancelamento_Data         write LCancelamento_Data;
         //---------------------------------------------------------------------
         property Impressora              : TKSConfigImpressora read LImpressora                write LImpressora;  // Configuração da impressora
         property Empresa                 : TEmit               read LEmpresa                   write LEmpresa;              // Dados do emitente da NFCe do padrão ACBR                                                   // Para salvar no Banco de dados
         //---------------------------------------------------------------------
         property Executando              : boolean             read lExecutando                write lExecutando;
         property RespostaTEF             : TResposta           read LRespostaTEF               write LRespostaTEF;  // Resultado da operação de TEF
         //---------------------------------------------------------------------
         procedure SA_ProcessarPagamento;  // Realizar pagamento
         procedure SA_ProcessarCancelamento; // Fazer o cancelamento
         //---------------------------------------------------------------------
   end;

implementation

{ TEmbedIT }

constructor TEmbedIT.Create;
begin
   //---------------------------------------------------------------------------
   lib := TEmbedLib.Create(GetCurrentDir+'\lib-embed-x86.dll');
   //---------------------------------------------------------------------------
   LSalvarLog            := true;
   lExecutando           := true;
   LTipoTEF              := EmbedTEF;
   LRespostaTEF.Resultado.TEFAprovado := false;
   //---------------------------------------------------------------------------
end;

procedure TEmbedIT.MythreadEnd(sender: tobject);
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

function TEmbedIT.SA_AbortarAPI: TResposta;
var
   Retorno : string;
begin
   //---------------------------------------------------------------------------
   SA_SalvarLog('ABORTAR OPERACAO','{"processar": {"operacao": "abortar"}}',GetCurrentDir+'\TEF_Log\logTEFEMBED'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   //---------------------------------------------------------------------------
   Retorno := string(lib.Processar(ansistring('{"processar": {"operacao": "abortar"}}')));
   //---------------------------------------------------------------------------
   SA_SalvarLog('RESPOSTA ABORTAR OPERACAO',Retorno,GetCurrentDir+'\TEF_Log\logTEFEMBED'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   //---------------------------------------------------------------------------
   Result  := SA_ParsingResposta(Retorno);
   //---------------------------------------------------------------------------
end;

function TEmbedIT.SA_CancelarAPI: TResposta;
var
   Input   : string;
   Retorno : string;
begin
   Input   :=  '{'+
                   '"processar": {'+
                       '"operacao": "cancelar",'+         // cancelar
                       '"valor": "'+floattostr(LCancelamento_Valor*100)+'",'+                    // em centavos (se R$ 1,00 logo 100)
                       '"data": "'+formatdatetime('ddmmyyyy',LCancelamento_Data)+'",'+                     // no formato DDMMAAAA
                       '"nsu": "'+LCancelamento_NSU+'"'+                      // igual está no comprovante recebido com 9 caracteres
                   '}'+
               '}';
   //---------------------------------------------------------------------------
   SA_SalvarLog('SOLICITANDO CANCELAMENTO',Input,GetCurrentDir+'\TEF_Log\logTEFEMBED'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   //---------------------------------------------------------------------------
   Retorno := string(lib.Processar(ansistring(Input)));
   //---------------------------------------------------------------------------
   SA_SalvarLog('RESPOSTA CANCELAMENTO',Retorno,GetCurrentDir+'\TEF_Log\logTEFEMBED'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   //---------------------------------------------------------------------------
   Result  := SA_ParsingResposta(Retorno);
   //---------------------------------------------------------------------------

end;

Function TEmbedIT.SA_ConfigurarAPI:TResposta;
var
   input   : string;
   Retorno : string;
begin
   //---------------------------------------------------------------------------
   if LTipoTEF=EmbedPOS then   // É maquininha POS - Iniciar na modalidade POS
      begin
         //---------------------------------------------------------------------
         //   Modalidade POS
         //---------------------------------------------------------------------
         Input    := '{'+
                         '"configs": {'+
                             '"produto": "pos",'+
                             '"sub_produto": "1",'+
                             '"infos": {'+
                                 '"username": "'+LPOSUsername+'",'+                   // gerado pelo time de integração
                                 '"password": "'+LPOSPassword+'",'+                   // gerado pelo time de integração
                                 '"pos_numero_serial_padrao": "'+LPOSNumeroSerial+'"'+    // obtido através da aplicação PDV Mobi no POS
                             '}'+
                         '}'+
                     '}';


      end
   else if LTipoTEF=EmbedTEF then  // É TEF convencional
      begin
         //---------------------------------------------------------------------
         //   Iniciar na modalidade TEF
         //---------------------------------------------------------------------
         input := '{'+
                      '"configs": {'+
                          '"produto": "tef",'+
                          '"sub_produto": "1",'+
                          '"infos": {'+
                              '"timeout": "300",'+
                              '"codigo_ativacao": "'+LCodigoAtivacao+'",'+  // gerado pelo time de integração
                              '"nome_app": "Agente Comercial - Executive",'+
                              '"versao_app": "4.5",'+
                              '"texto_pinpad": "MKM Automacao"'+
                          '}'+
                      '}'+
                  '}';
      end;
   //---------------------------------------------------------------------------
   SA_SalvarLog('CONFIGURANDO O TEF',Input,GetCurrentDir+'\TEF_Log\logTEFEMBED'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   //---------------------------------------------------------------------------
   Retorno := string(lib.Configurar(ansistring(Input)));
   //---------------------------------------------------------------------------
   SA_SalvarLog('RESPOSTA CONFIGURANDO O TEF',Retorno,GetCurrentDir+'\TEF_Log\logTEFEMBED'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   //---------------------------------------------------------------------------
   Result  := SA_ParsingResposta(Retorno);
   //---------------------------------------------------------------------------
end;

function TEmbedIT.SA_CreditoAPI: TResposta;
var
   Input         : String;
   Retorno       : String;
   Financiamento : string;
begin
   //---------------------------------------------------------------------------
   case LPagamento_Operacao of
     tpEmbedPgtoCreditoVista         : Financiamento := '0';
     tpEmbedPgtoCreditoParceladoLoja : Financiamento := '1';
     tpEmbedPgtoCreditoParceladoADM  : Financiamento := '2';
   end;
   //---------------------------------------------------------------------------
   if LTipoTEF=EmbedTEF then  // TEF Convencional
      begin
         //---------------------------------------------------------------------
         //   Operação por TEF convencional
         //---------------------------------------------------------------------
         Input := '{'+
                      '"processar": {'+
                          '"operacao": "credito",'+          // credito
                          '"valor": "'+floattostr(LPagamento_valor*100)+'",'+     // em centavos (se R$ 1,00 logo 100)
                          '"parcelas": "'+LPagamento_QtdeParcelas.tostring+'",'+  // 1 a 99 (se a vista logo 1)
                          '"financiamento": "'+Financiamento+'"'+                 // 0 - a vista; 1 - estabelecimento; 2 - administradora
                      '}'+
                  '}';
         //---------------------------------------------------------------------
      end
   else if LTipoTEF=EmbedPOS then  // Operação com smart POS
      begin
         //---------------------------------------------------------------------
         //   Operação por SMART POS
         //---------------------------------------------------------------------
         Input := '{'+
                      '"processar": {'+
                          '"operacao": "credito",'+          // credito
                          '"valor": "'+floattostr(LPagamento_valor*100)+'",'+     // em centavos (se R$ 1,00 logo 100)
                          '"parcelas": "'+LPagamento_QtdeParcelas.tostring+'"'+  // 1 a 99 (se a vista logo 1)
                      '}'+
                  '}';
         //---------------------------------------------------------------------

      end;
   //---------------------------------------------------------------------------
   SA_SalvarLog('PAGAMENTO CREDITO',Input,GetCurrentDir+'\TEF_Log\logTEFEMBED'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   //---------------------------------------------------------------------------
   Retorno := string(lib.Processar(ansistring(Input)));
   Result  := SA_ParsingResposta(Retorno);
   //---------------------------------------------------------------------------
   SA_SalvarLog('RESPOSTA PAGAMENTO CREDITO',Retorno,GetCurrentDir+'\TEF_Log\logTEFEMBED'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   //---------------------------------------------------------------------------
end;

procedure TEmbedIT.SA_CriarMenuT;
begin
   SA_Criar_Menu(true);
end;

function TEmbedIT.SA_DebitoAPI: TResposta;
var
   Input   : String;
   Retorno : string;
begin
   //---------------------------------------------------------------------------
   Input := '{'+
                '"processar": {'+
                    '"operacao": "debito",'+                           // debito
                    '"valor": "'+floattostr(LPagamento_valor*100)+'"'+ // em centavos (se R$ 1,00 logo 100)
                '}'+
            '}';
   //---------------------------------------------------------------------------
   SA_SalvarLog('VENDA DEBITO',Input,GetCurrentDir+'\TEF_Log\logTEFEMBED'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   //---------------------------------------------------------------------------
   Retorno := string(lib.Processar(ansistring(Input)));
   //---------------------------------------------------------------------------
   SA_SalvarLog('RESPOSTA VENDA DEBITO',Retorno,GetCurrentDir+'\TEF_Log\logTEFEMBED'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   //---------------------------------------------------------------------------
   Result  := SA_ParsingResposta(Retorno);
   //---------------------------------------------------------------------------
end;

procedure TEmbedIT.SA_DesativarBtCancelarT;
begin
   SA_DesativarBTCancelar;
end;

procedure TEmbedIT.SA_DesativarMenuT;
begin
   SA_Criar_Menu(false);
end;

function TEmbedIT.SA_DesfazerAPI: TResposta;
var
   Retorno : string;
   Input   : string;
begin
   Input   :=  '{'+
                   '"finalizar": {'+
                       '"operacao": "confirmar",'+
                       '"valor": "0"'+                     // 0 - não (desfaz); 1 - sim (confirmar)
                   '}'+
               '}';
   //---------------------------------------------------------------------------
   SA_SalvarLog('FINALIZAR',input,GetCurrentDir+'\TEF_Log\logTEFEMBED'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   //---------------------------------------------------------------------------
   Retorno := string(lib.Finalizar(ansistring(Input)));
   //---------------------------------------------------------------------------
   SA_SalvarLog('RESPOSTA FINALIZAR',Retorno,GetCurrentDir+'\TEF_Log\logTEFEMBED'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   //---------------------------------------------------------------------------
   Result  := SA_ParsingResposta(Retorno);
   //---------------------------------------------------------------------------
end;

function TEmbedIT.SA_FinalizarAPI: TResposta;
var
   Retorno : string;
   Input   : string;
begin
   if LTipoTEF=EmbedTEF then  // TEF Convencional
      begin
         //---------------------------------------------------------------------
         //   Criando JSON para confirmar a transação
         //---------------------------------------------------------------------
         Input   :=  '{'+
                         '"finalizar": {'+
                             '"operacao": "confirmar",'+
                             '"valor": "1"'+                     // 0 - não (desfaz); 1 - sim (confirmar)
                         '}'+
                     '}'
            end
   else if LTipoTEF=EmbedPOS then  // A operação é POS
      Input := '{"finalizar": {"operacao": ""}}';
   //---------------------------------------------------------------------------
   SA_SalvarLog('FINALIZAR',input,GetCurrentDir+'\TEF_Log\logTEFEMBED'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   //---------------------------------------------------------------------------
   Retorno := string(lib.Finalizar(ansistring(Input)));
   //---------------------------------------------------------------------------
   SA_SalvarLog('RESPOSTA FINALIZAR',Retorno,GetCurrentDir+'\TEF_Log\logTEFEMBED'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   //---------------------------------------------------------------------------
   Result  := SA_ParsingResposta(Retorno);
   //---------------------------------------------------------------------------
end;

function TEmbedIT.SA_GetStatusAPI: TResposta;
var
   Retorno : String;
begin
   //---------------------------------------------------------------------------
   Retorno := string(lib.Processar('get_status'));
   SA_SalvarLog('RESPOSTA GetStatus',retorno,GetCurrentDir+'\TEF_Log\logTEFEMBED'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   //---------------------------------------------------------------------------
   Result  := SA_ParsingResposta(Retorno);
   //---------------------------------------------------------------------------
end;

function TEmbedIT.SA_IniciarApi: TResposta;
var
   Retorno  : string;
   operacao : string;
begin
   operacao := 'tef';  // Definir a operação para inicialização como paadrão sendo TEF
   if LTipoTEF=EmbedPOS then  // Se o tipo for POS
      operacao := 'pos';
   //---------------------------------------------------------------------------
   SA_SalvarLog('INICIANDO O TEF','{"iniciar": {"operacao": "'+operacao+'"}}',GetCurrentDir+'\TEF_Log\logTEFEMBED'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   //---------------------------------------------------------------------------
   Retorno := string(lib.Iniciar(ansistring('{"iniciar": {"operacao": "'+operacao+'"}}')));
   //---------------------------------------------------------------------------
   SA_SalvarLog('RESPOSTA INICIAR O TEF',Retorno,GetCurrentDir+'\TEF_Log\logTEFEMBED'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLog);
   //---------------------------------------------------------------------------
   Result  := SA_ParsingResposta(Retorno);
   //---------------------------------------------------------------------------
end;

function TEmbedIT.SA_ItemMenuPgtoSelecionado(item: integer): TtpEmbedIFormaPgto;
begin
   //---------------------------------------------------------------------------
   Result := tpEmbedPgtoPerguntar;
   //---------------------------------------------------------------------------
   if LPagamento_Operacao=tpEmbedPgtoPerguntar then
      begin
         Result := TtpEmbedIFormaPgto(item);
         case item of
            1:Result := tpEmbedPgtoDebito;
            2:Result := tpEmbedPgtoCreditoVista;
            3:Result := tpEmbedPgtoCreditoParceladoLoja;
            4:Result := tpEmbedPgtoCreditoParceladoADM;
            5:Result := tpEmbedPgtoNenhum;
         end;
      end
   else if LPagamento_Operacao=tpEmbedPgtoCreditoPerguntar then
      begin
         case item of
            1:Result := tpEmbedPgtoCreditoVista;
            2:Result := tpEmbedPgtoCreditoParceladoLoja;
            3:Result := tpEmbedPgtoCreditoParceladoADM;
            4:Result := tpEmbedPgtoNenhum;
         end;
      end;
   //---------------------------------------------------------------------------
end;

procedure TEmbedIT.SA_MostramensagemT;
begin
   SA_Mostrar_Mensagem(true);
end;

procedure TEmbedIT.SA_MostrarBtCancelarT;
begin
   SA_AtivarBTCancelar;   // Ativar o botão cancelar na tela de TEF
end;

function TEmbedIT.SA_OpcoesPagamento: TStringList;
begin
   //---------------------------------------------------------------------------
   //   Função para criar a lista de opções de pagamento para op operador escolher
   //---------------------------------------------------------------------------
   Result := TStringList.Create;
   if LPagamento_Operacao=tpEmbedPgtoPerguntar then
      begin
         Result.Add('Debito');
         Result.Add('Credito a Vista');
         Result.Add('Credito parcelado pela loja');
         Result.Add('Credito parcelado pela ADMINISTRADORA');
         Result.Add('Desistir');
      end
   else if LPagamento_Operacao=tpEmbedPgtoCreditoPerguntar then
      begin
         Result.Add('Credito a Vista');
         Result.Add('Credito parcelado pela loja');
         Result.Add('Credito parcelado pela ADMINISTRADORA');
         Result.Add('Desistir');
      end;
   //---------------------------------------------------------------------------
end;

function TEmbedIT.SA_ParsingResposta(conteudo: string): TResposta;
var
   //---------------------------------------------------------------------------
   JSONRet : TJSonValue;
   Status  : TJSONValue;
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   Result.codigo   := 99;
   Result.Mensagem := '';
   Result.Resultado.status_code    := 99;
   Result.Resultado.status_message := '';
   //---------------------------------------------------------------------------
   try
      JSONRet := TJSonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(conteudo),0) as TJSONValue;
   except
      exit;
   end;
   //---------------------------------------------------------------------------
   Result.codigo   := JSONRet.GetValue<integer>('codigo',99);
   Result.Mensagem := UTF8ToString(ansistring(JSONRet.GetValue<string>('mensagem','')));
   Status          := JSONRet.GetValue<TJSONValue>('resultado',nil);;
   if status<>nil then
      begin
         //---------------------------------------------------------------------
         Result.Resultado.status_code    := Status.GetValue<integer>('status_code',99);
         Result.Resultado.status_message := UTF8ToString(ansistring(Status.GetValue<string>('status_message','')));
         //---------------------------------------------------------------------
         Result.Resultado.aid                := Status.GetValue<string>('aid','');
         Result.Resultado.nsu                := Status.GetValue<string>('nsu','');
         Result.Resultado.valor              := Status.GetValue<string>('valor','');
         Result.Resultado.parcelas           := Status.GetValue<string>('parcelas','');
         Result.Resultado.financiamento      := Status.GetValue<string>('financiamento','');
         Result.Resultado.codigo_autorizacao := Status.GetValue<string>('codigo_autorizacao','');
         Result.Resultado.bandeira           := Status.GetValue<string>('bandeira','');
         Result.Resultado.rede               := Status.GetValue<string>('rede','');
         Result.Resultado.numero_cartao      := Status.GetValue<string>('numero_cartao','');
         Result.Resultado.data_hora          := Status.GetValue<string>('data_hora','');
         Result.Resultado.tipo_cartao        := Status.GetValue<string>('tipo_cartao','');
         Result.Resultado.via_loja           := Status.GetValue<string>('via_loja','');
         Result.Resultado.via_cliente        := Status.GetValue<string>('via_cliente','');
         //---------------------------------------------------------------------
         if (Result.Resultado.status_code=0) and (Result.Resultado.via_cliente<>'') and (LTipoTEF=EmbedTEF) then
            begin
               Result.Resultado.ComprovanteLoja  := '<e><ce>COMPROVANTE TEF<ae></e></lf>'+
                                                    '<e><ce>Via Lojista<ae></e></lf></lf>'+
                                                    '   Realizada em   '+Result.Resultado.data_hora+'</lf>'+
                                                    '       Valor R$   '+Result.Resultado.valor+'</lf>'+
                                                    '     Forma Pgto   '+LPagamento_Forma+'</lf>'+
                                                    '            NSU   '+Result.Resultado.nsu+'</lf>'+
                                                    '       Bandeira   '+Result.Resultado.bandeira+'</lf>'+
                                                    ' Tipo de Cartao   '+Result.Resultado.tipo_cartao+'</lf></lf>';
            end
         else if (Result.Resultado.status_code=0) and (LTipoTEF=EmbedPOS) then   // Criar os comprovantes para SMART POS
            begin
               Result.Resultado.via_loja         := '<e><ce>COMPROVANTE TEF<ae></e></lf>'+
                                                    '<e><ce>Via Lojista<ae></e></lf></lf>'+
                                                    '   Realizada em   '+Result.Resultado.data_hora+'</lf>'+
                                                    '       Valor R$   '+Result.Resultado.valor+'</lf>'+
                                                    '     Forma Pgto   '+LPagamento_Forma+'</lf>'+
                                                    '            NSU   '+Result.Resultado.nsu+'</lf>'+
                                                    '        C.Aut.:   '+Result.Resultado.codigo_autorizacao+'</lf>'+
                                                    '       Bandeira   '+Result.Resultado.bandeira+'</lf>'+
                                                    '           Rede   '+Result.Resultado.rede+'</lf>';

               Result.Resultado.via_cliente      := '<e><ce>COMPROVANTE TEF<ae></e><ae></lf>'+
                                                    '<e><ce>Via Cliente<ae></e></lf></lf>'+
                                                    '<ce>'+LEmpresa.xFant+'<ae></lf>'+
                                                    '<ce>'+LEmpresa.xNome+'<ae></lf>'+
                                                    'CNPJ:'+LEmpresa.CNPJCPF+'</lf>'+
                                                    '<c>'+LEmpresa.EnderEmit.xLgr+', '+LEmpresa.EnderEmit.nro+' - '+LEmpresa.EnderEmit.xBairro+'</c></lf></lf>'+
                                                    '<c>'+LEmpresa.EnderEmit.xMun+'/'+LEmpresa.EnderEmit.UF+'</c></lf></lf>'+
                                                    '   Realizada em   '+Result.Resultado.data_hora+'</lf>'+
                                                    '       Valor R$   '+Result.Resultado.valor+'</lf>'+
                                                    '            NSU   '+Result.Resultado.nsu+'</lf>'+
                                                    '        C.Aut.:   '+Result.Resultado.codigo_autorizacao+'</lf>'+
                                                    '       Bandeira   '+Result.Resultado.bandeira+'</lf>'+
                                                    '           Rede   '+Result.Resultado.rede+'</lf></lf>';

               Result.Resultado.ComprovanteLoja  := Result.Resultado.via_loja;
            end;
         //---------------------------------------------------------------------
      end;
   //---------------------------------------------------------------------------
   JSONRet.Free;
end;

procedure TEmbedIT.SA_ProcessarCancelamento;
var
   Mythread         : TThread;
   sair             : boolean;
   Imprimir         : boolean;
   //---------------------------------------------------------------------------
   opcoesColeta    : TStringList;
   //---------------------------------------------------------------------------
   RetornoConfigurar  : TResposta;  // Resposta da função configurar
   RetornoIniciar     : TResposta;  // Resposta da função iniciar
   RetornoTransacao   : TResposta;  // Resposta da transação TEF = Record
   StatusTransacao    : TResposta; // Resposta da transação TEF
   PodeTransacionar   : boolean;    // Verificação se pode transacionar
   Mensagem           : string;     // Mensagem que será apresentada ao operador
   //---------------------------------------------------------------------------
begin
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpTEFEmbed;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LCancelamento_Forma;
   frmwebtef.lbvalor.Caption  := transform(LCancelamento_Valor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   //---------------------------------------------------------------------------
   Mythread := TThread.CreateAnonymousThread(procedure
   begin
      //------------------------------------------------------------------------
      //   Executar a transação
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Conectando com Embed-IT...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      //------------------------------------------------------------------------
      PodeTransacionar   := false;
      Mensagem           := 'ERRO - Não foi possível se conectar com o TEF';
      RetornoConfigurar := SA_ConfigurarAPI;  // Configurar o TEF
      if RetornoConfigurar.codigo=0 then
         begin
            RetornoIniciar    := SA_IniciarApi;  // Iniciar o TEF
            if RetornoIniciar.codigo=0 then
               PodeTransacionar   := true
            else
               mensagem := uppercase(RetornoIniciar.Mensagem);
         end
      else
        mensagem := uppercase(RetornoConfigurar.Mensagem);
      //------------------------------------------------------------------------
      if PodeTransacionar then
         begin
            //------------------------------------------------------------------
            RetornoTransacao := SA_CancelarAPI;
            //------------------------------------------------------------------
            if (RetornoTransacao.codigo=0) and (RetornoTransacao.Resultado.status_code=1) then   // O TEF foi iniciado e está processando a operação
               begin
                  //------------------------------------------------------------
                  frmwebtef.mensagem := uppercase(RetornoTransacao.Resultado.status_message);
                  TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                  //------------------------------------------------------------
                  //  Continuar monitorando a operação
                  //------------------------------------------------------------
                  sair := false;
                  while not sair do
                     begin
                        StatusTransacao := SA_GetStatusAPI;
                        if StatusTransacao.Resultado.status_code=-1 then  // Ocorreu um erro='-1'
                           begin
                              //------------------------------------------------
                              //   Processar a mensagem de erro
                              //------------------------------------------------
                              frmwebtef.Cancelar := false;
                              frmwebtef.mensagem := 'A transação não foi aprovada !';
                              if StatusTransacao.Resultado.status_message<>'' then
                                 frmwebtef.mensagem := uppercase(StatusTransacao.Resultado.status_message);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                 begin
                                    sleep(50);
                                 end;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              Sair := true;
                              //------------------------------------------------
                           end
                        else if (StatusTransacao.Resultado.status_code=0) and (StatusTransacao.Resultado.via_loja<>'') then   // Autorizado
                           begin
                              //------------------------------------------------
                              //  Transação aprovada
                              //------------------------------------------------
                              SA_FinalizarAPI;
                              LRespostaTEF                       := StatusTransacao;
                              LRespostaTEF.Resultado.TEFAprovado := true;  // O TEF aprovou a transação
                              sair                               := true;
                              //------------------------------------------------
                              //   Impressão via Loja
                              //------------------------------------------------
                              if StatusTransacao.Resultado.via_loja<>'' then   // Tem via da loja para imprimir
                                 begin
                                    Imprimir := LEmbedPagueImpressaoViaLJ=tpTEFImprimirSempre;
                                    if LEmbedPagueImpressaoViaLJ=tpTEFPerguntar then  // Perguntar se quer imprimir o comprovante
                                       begin
                                          //------------------------------------
                                          //   Criar menu
                                          //------------------------------------
                                          opcoesColeta       := TStringList.Create;
                                          opcoesColeta.Add('Imprimir');
                                          opcoesColeta.Add('Não Imprimir');
                                          frmwebtef.mensagem := 'Imprimir comprovante da LOJA ?';
                                          //------------------------------------
                                          frmwebtef.opcoes   := opcoesColeta;
                                          frmwebtef.opcao    := -1;
                                          frmwebtef.tecla    := '';
                                          frmwebtef.Cancelar := false;
                                          //------------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                          //------------------------------------
                                          while (not frmwebtef.Cancelar) do
                                             begin
                                               if (strtointdef(frmwebtef.tecla,0)=1) or (frmwebtef.opcao=1) then
                                                  begin
                                                     //-------------------------
                                                     Imprimir           := true;
                                                     frmwebtef.Cancelar := true;
                                                     //-------------------------
                                                  end
                                               else if (strtointdef(frmwebtef.tecla,0)=2) or (frmwebtef.opcao=2) then
                                                  begin
                                                     //-------------------------
                                                     Imprimir           := false;
                                                     frmwebtef.Cancelar := true;
                                                     //-------------------------
                                                  end;
                                                //------------------------------
                                                sleep(50);
                                             end;
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          opcoesColeta.Free;
                                          //------------------------------------
                                          if Imprimir then
                                             begin
                                                if LImpressaoSimplificada then
                                                   SA_ImprimirTexto(StatusTransacao.Resultado.ComprovanteLoja,LImpressora)   // Imprimindo
                                                else
                                                   SA_ImprimirTexto(StatusTransacao.Resultado.via_loja,LImpressora);   // Imprimindo
                                             end;
                                          //------------------------------------
                                       end;

                                 end;
                              //------------------------------------------------
                              //   Impressão via Cliente
                              //------------------------------------------------
                              if StatusTransacao.Resultado.via_cliente<>'' then   // Tem via da clientepara imprimir
                                 begin
                                    Imprimir   := LEmbedPagueImpressaoViaCLI=tpTEFImprimirSempre;
                                    if LEmbedPagueImpressaoViaLJ=tpTEFPerguntar then  // Perguntar se quer imprimir o comprovante
                                       begin
                                          //------------------------------------
                                          //   Criar menu
                                          //------------------------------------
                                          opcoesColeta       := TStringList.Create;
                                          opcoesColeta.Add('Imprimir');
                                          opcoesColeta.Add('Não Imprimir');
                                          frmwebtef.mensagem := 'Imprimir comprovante do CLIENTE ?';
                                          //------------------------------------
                                          frmwebtef.opcoes   := opcoesColeta;
                                          frmwebtef.opcao    := -1;
                                          frmwebtef.tecla    := '';
                                          frmwebtef.Cancelar := false;
                                          //------------------------------------
                                          TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                          //------------------------------------
                                          while (not frmwebtef.Cancelar) do
                                             begin
                                               if (strtointdef(frmwebtef.tecla,0)=1) or (frmwebtef.opcao=1) then
                                                  begin
                                                     //-------------------------
                                                     Imprimir           := true;
                                                     frmwebtef.Cancelar := true;
                                                     //-------------------------
                                                  end
                                               else if (strtointdef(frmwebtef.tecla,0)=2) or (frmwebtef.opcao=2) then
                                                  begin
                                                     //-------------------------
                                                     Imprimir           := false;
                                                     frmwebtef.Cancelar := true;
                                                     //-------------------------
                                                  end;
                                                //------------------------------
                                                sleep(50);
                                             end;
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                          TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                          opcoesColeta.Free;
                                          //------------------------------------
                                          if Imprimir then
                                             SA_ImprimirTexto(StatusTransacao.Resultado.via_cliente,LImpressora);   // Imprimindo
                                          //------------------------------------
                                       end;

                                 end;
                              //------------------------------------------------
                           end
                        else if (StatusTransacao.Resultado.status_code=0) and (StatusTransacao.Resultado.via_loja='') then   // Autorizado
                           begin
                              //------------------------------------------------
                              SA_DesfazerAPI;
                              sair := true;
                              //------------------------------------------------
                              //   Retorno de finalizado sem comprovante
                              //------------------------------------------------
                              frmwebtef.Cancelar := false;
                              frmwebtef.mensagem := 'Não foi possível finalizar a transação de pagamento com o TEF !';
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                 begin
                                    sleep(50);
                                 end;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                           end
                        else if StatusTransacao.Resultado.status_code=1 then  // Processando a transação
                           begin
                              //------------------------------------------------
                              // Mostrando a mensagem de processamento
                              //------------------------------------------------
                              frmwebtef.mensagem := 'Processando transação. Aguarde...';
                              if StatusTransacao.Resultado.status_message<>'' then
                                 frmwebtef.mensagem := uppercase(StatusTransacao.Resultado.status_message);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              //------------------------------------------------
                           end;
                     end;
                  //------------------------------------------------------------
               end
            else  // Houve erro ao processar a chamada de TEF
               begin
                  //------------------------------------------------------------
                  // Ocorreu algum erro ao iniciar o TEF
                  //   Mostrar mensagem de erro
                  //------------------------------------------------------------
                  frmwebtef.Cancelar := false;
                  frmwebtef.mensagem := 'Não foi possível iniciar a transação de pagamento com o TEF !';
                  if RetornoTransacao.codigo<>99 then
                     begin
                        if RetornoTransacao.Mensagem<>'' then
                           frmwebtef.mensagem := uppercase(RetornoTransacao.Mensagem);
                        if RetornoTransacao.Resultado.status_message<>'' then
                           frmwebtef.mensagem := uppercase(RetornoTransacao.Resultado.status_message);
                     end;
                  TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                  TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                  while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                     begin
                        sleep(50);
                     end;
                  TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                  //------------------------------------------------------------
               end;
         end
      else
         begin
            //------------------------------------------------------------------
            // Ocorreu algum erro ao iniciar o TEF
            //------------------------------------------------------------------
            frmwebtef.Cancelar := false;
            frmwebtef.mensagem := uppercase(Mensagem); // 'Não foi possível iniciar a transação com o TEF !';
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
            while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
               begin
                  sleep(50);
               end;
            TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
            //------------------------------------------------------------------
         end;
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Obtendo a sequência da operação...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      //------------------------------------------------------------------------
   end);
   //---------------------------------------------------------------------------
   Mythread.onterminate := MythreadEnd;
   Mythread.start;
   //---------------------------------------------------------------------------
end;

procedure TEmbedIT.SA_ProcessarPagamento;
var
   Mythread         : TThread;
   sair             : boolean;
   Imprimir         : boolean;
   //---------------------------------------------------------------------------
   opcoesColeta    : TStringList;
   Numero_Digitado : string;   // Quando a coleta é numérica
   //---------------------------------------------------------------------------
   RetornoConfigurar  : TResposta;  // Resposta da função configurar
   RetornoIniciar     : TResposta;  // Resposta da função iniciar
   RetornoTransacao   : TResposta;  // Resposta da transação TEF = Record
   StatusTransacao    : TResposta;  // Resposta da transação TEF
   PodeTransacionar   : boolean;    // Verificação se pode transacionar
   Mensagem           : string;     // Mensagem que será apresentada ao operador
   //---------------------------------------------------------------------------
begin
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpTEFEmbed;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LPagamento_Forma;
   frmwebtef.lbvalor.Caption  := transform(LPagamento_Valor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   //---------------------------------------------------------------------------
   Mythread := TThread.CreateAnonymousThread(procedure
   begin
      if LPagamento_Operacao in[tpEmbedPgtoPerguntar,tpEmbedPgtoCreditoPerguntar] then // Verificar as formas de pagamento
         begin
            //------------------------------------------------------------------
            //   Tratar as formas de pagamento se é perguntar ou se é crédito não definido
            //------------------------------------------------------------------
            opcoesColeta       := SA_OpcoesPagamento;
            frmwebtef.mensagem := 'Selecione a opção de pagamento ?';
            //------------------------------------------------------------------
            frmwebtef.opcoes   := opcoesColeta;
            frmwebtef.opcao    := -1;
            frmwebtef.tecla    := '';
            frmwebtef.Cancelar := false;
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
            //------------------------------------------------------------------
            while (not frmwebtef.Cancelar) do
               begin
                 if (strtointdef(frmwebtef.tecla,0) in[1..4]) or (frmwebtef.opcao in[1..4]) then
                    begin
                       //-------------------------------------------------------
                       if (frmwebtef.tecla<>'') then
                          frmwebtef.opcao := strtoint(frmwebtef.tecla);
                       LPagamento_Operacao := SA_ItemMenuPgtoSelecionado(frmwebtef.opcao);
                       frmwebtef.Cancelar  := true;
                       //-------------------------------------------------------
                    end
                 else if (frmwebtef.tecla='5') or (frmwebtef.opcao=5) then
                    begin
                       frmwebtef.Cancelar  := true;
                       LPagamento_Operacao := tpEmbedPgtoNenhum;
                    end;
                  //------------------------------------------------------------
                  sleep(50);
               end;
            TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
            TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
            opcoesColeta.Free;
            //------------------------------------------------------------------
         end;
      //------------------------------------------------------------------------
      //  Quantidade de parcelas para crédito ADM ou Loja
      //------------------------------------------------------------------------
      if (LPagamento_Operacao in[tpEmbedPgtoCreditoParceladoLoja,tpEmbedPgtoCreditoParceladoADM]) and (LPagamento_QtdeParcelas<=1) then
         begin
            //------------------------------------------------------------------
            //   Perguntar a quantidade de parcelas
            //   Coletar dado numérico
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
            TThread.Synchronize(TThread.CurrentThread,
             procedure
                begin
                   SA_ColetarValor('Qual a quantidade de parcelas ?','',false);
                end);
            frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
            frmwebtef.dado_digitado := '';
            frmwebtef.Cancelar      := false;
            frmwebtef.AceitaVazio   := false;
            Numero_Digitado         := '';
            while (Numero_Digitado='') and (not frmwebtef.Cancelar) do
               begin
                  //------------------------------------------------------------
                  sleep(10);
                  //------------------------------------------------------------
                  if  (frmwebtef.dado_digitado<>'') then
                     begin
                        if (strtointdef(frmwebtef.dado_digitado,0)>1) and (strtointdef(frmwebtef.dado_digitado,0)<=99) then
                           Numero_Digitado := frmwebtef.dado_digitado;
                     end
                  else if (frmwebtef.dado_digitado<>'') then
                     begin
                        frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                        frmwebtef.pnalerta.Color        := clRed;
                        frmwebtef.pnalerta.Font.Color   := clYellow;
                        frmwebtef.dado_digitado         := '';
                     end;
                  //------------------------------------------------------------
               end;
            //------------------------------------------------------------------
            LPagamento_QtdeParcelas := strtointdef(Numero_Digitado,0);
            frmwebtef.pncaptura.Visible := false;
            frmwebtef.edtdado.Enabled   := false;
            TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
            //------------------------------------------------------------------
         end;
      //------------------------------------------------------------------------
      if (LPagamento_Operacao=tpEmbedPgtoNenhum) or ((LPagamento_Operacao in[tpEmbedPgtoCreditoParceladoLoja,tpEmbedPgtoCreditoParceladoADM]) and (LPagamento_QtdeParcelas<=1) )  then
         begin
            //------------------------------------------------------------------
            //   A operação não contém os dados necessários para transacionar
            //------------------------------------------------------------------
            frmwebtef.Cancelar := false;
            frmwebtef.mensagem := 'Operação inválida ou cancelada pelo operador !';
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
            while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
               begin
                  sleep(50);
               end;
            TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
            //------------------------------------------------------------------
         end
      else
         begin
            //------------------------------------------------------------------
            //   Executar a transação
            //------------------------------------------------------------------
            frmwebtef.mensagem := 'Conectando com Embed-IT...';
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            //------------------------------------------------------------------
            PodeTransacionar   := false;
            Mensagem           := 'ERRO - Não foi possível se conectar com o TEF';
            RetornoConfigurar := SA_ConfigurarAPI;  // Configurar o TEF
            if RetornoConfigurar.codigo=0 then
               begin
                  RetornoIniciar    := SA_IniciarApi;  // Iniciar o TEF
                  if RetornoIniciar.codigo=0 then
                     PodeTransacionar   := true
                  else
                     mensagem := uppercase(RetornoIniciar.Mensagem);
               end
            else
              mensagem := uppercase(RetornoConfigurar.Mensagem);
            //------------------------------------------------------------------
            if PodeTransacionar then
               begin
                  //------------------------------------------------------------
                  if LPagamento_Operacao=tpEmbedPgtoDebito then
                     RetornoTransacao := SA_DebitoAPI
                  else if LPagamento_Operacao in[tpEmbedPgtoCreditoVista,tpEmbedPgtoCreditoParceladoLoja,tpEmbedPgtoCreditoParceladoADM] then
                     RetornoTransacao := SA_CreditoAPI;
                  //------------------------------------------------------------
                  if (RetornoTransacao.codigo=0) and (RetornoTransacao.Resultado.status_code=1) then   // O TEF foi iniciado e está processando a operação
                     begin
                        //------------------------------------------------------
                        frmwebtef.mensagem := uppercase(RetornoTransacao.Resultado.status_message);
                        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                        //------------------------------------------------------
                        //  Continuar monitorando a operação
                        //------------------------------------------------------
                        if LTipoTEF=EmbedPOS then   // Se a operação for SMART POS, colocar um botão de desistir
                           TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                        //------------------------------------------------------
                        sair               := false;
                        frmwebtef.Cancelar := false;
                        while not sair do
                           begin
                              StatusTransacao := SA_GetStatusAPI;
                              if StatusTransacao.Resultado.status_code=-1 then  // Ocorreu um erro='-1'
                                 begin
                                    //------------------------------------------
                                    //   Processar a mensagem de erro
                                    //------------------------------------------
                                    frmwebtef.Cancelar := false;
                                    frmwebtef.mensagem := 'A transação não foi aprovada !';
                                    if StatusTransacao.Resultado.status_message<>'' then
                                       frmwebtef.mensagem := uppercase(StatusTransacao.Resultado.status_message);
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                    while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                       begin
                                          sleep(50);
                                       end;
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    Sair := true;
                                    //------------------------------------------
                                 end
                              else if (StatusTransacao.Resultado.status_code=0) and (StatusTransacao.Resultado.via_loja<>'') then   // Autorizado para TEF convencional
                                 begin
                                    //------------------------------------------
                                    //  Transação aprovada
                                    //------------------------------------------
                                    SA_FinalizarAPI;
                                    LRespostaTEF := StatusTransacao;
                                    LRespostaTEF.Resultado.TEFAprovado := true;  // O TEF aprovou a transação
                                    sair             := true;
                                    //------------------------------------------
                                    //   Impressão via Loja
                                    //------------------------------------------
                                    if StatusTransacao.Resultado.via_loja<>'' then   // Tem via da loja para imprimir
                                       begin
                                          Imprimir := LEmbedPagueImpressaoViaLJ=tpTEFImprimirSempre;
                                          if LEmbedPagueImpressaoViaLJ=tpTEFPerguntar then  // Perguntar se quer imprimir o comprovante
                                             begin
                                                //------------------------------
                                                //   Criar menu
                                                //------------------------------
                                                opcoesColeta       := TStringList.Create;
                                                opcoesColeta.Add('Imprimir');
                                                opcoesColeta.Add('Não Imprimir');
                                                frmwebtef.mensagem := 'Imprimir comprovante da LOJA ?';
                                                //------------------------------
                                                frmwebtef.opcoes   := opcoesColeta;
                                                frmwebtef.opcao    := -1;
                                                frmwebtef.tecla    := '';
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                                TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                                //------------------------------
                                                while (not frmwebtef.Cancelar) do
                                                   begin
                                                     if (strtointdef(frmwebtef.tecla,0)=1) or (frmwebtef.opcao=1) then
                                                        begin
                                                           //-------------------
                                                           Imprimir           := true;
                                                           frmwebtef.Cancelar := true;
                                                           //-------------------
                                                        end
                                                     else if (strtointdef(frmwebtef.tecla,0)=2) or (frmwebtef.opcao=2) then
                                                         begin
                                                            Imprimir           := false;
                                                            frmwebtef.Cancelar := true;
                                                         end;
                                                      //------------------------
                                                      sleep(50);
                                                   end;
                                                TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                                TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                                opcoesColeta.Free;
                                                //------------------------------
                                                if Imprimir then
                                                   begin
                                                      if LImpressaoSimplificada then
                                                         SA_ImprimirTexto(StatusTransacao.Resultado.ComprovanteLoja,LImpressora)
                                                      else
                                                         SA_ImprimirTexto(StatusTransacao.Resultado.via_loja,LImpressora);   // Imprimindo
                                                   end;
                                                //------------------------------
                                             end;

                                       end;
                                    //------------------------------------------
                                    //   Impressão via Cliente
                                    //------------------------------------------
                                    if StatusTransacao.Resultado.via_cliente<>'' then   // Tem via da clientepara imprimir
                                       begin
                                          Imprimir   := LEmbedPagueImpressaoViaCLI=tpTEFImprimirSempre;
                                          if LEmbedPagueImpressaoViaLJ=tpTEFPerguntar then  // Perguntar se quer imprimir o comprovante
                                             begin
                                                //------------------------------
                                                //   Criar menu
                                                //------------------------------
                                                opcoesColeta       := TStringList.Create;
                                                opcoesColeta.Add('Imprimir');
                                                opcoesColeta.Add('Não Imprimir');
                                                frmwebtef.mensagem := 'Imprimir comprovante do CLIENTE ?';
                                                //------------------------------
                                                frmwebtef.opcoes   := opcoesColeta;
                                                frmwebtef.opcao    := -1;
                                                frmwebtef.tecla    := '';
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                                TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                                //------------------------------
                                                while (not frmwebtef.Cancelar) do
                                                   begin
                                                     if (strtointdef(frmwebtef.tecla,0)=1) or (frmwebtef.opcao=1) then
                                                        begin
                                                           //-------------------
                                                           Imprimir           := true;
                                                           frmwebtef.Cancelar := true;
                                                           //-------------------
                                                        end
                                                     else if (strtointdef(frmwebtef.tecla,0)=2) or (frmwebtef.opcao=2) then
                                                        begin
                                                           //-------------------
                                                           Imprimir           := true;
                                                           frmwebtef.Cancelar := true;
                                                           //-------------------
                                                        end;
                                                      //------------------------
                                                      sleep(50);
                                                   end;
                                                TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                                TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                                opcoesColeta.Free;
                                                //------------------------------
                                                if Imprimir then
                                                   SA_ImprimirTexto(StatusTransacao.Resultado.via_cliente,LImpressora);   // Imprimindo
                                                 //-----------------------------
                                             end;
                                       end;
                                    frmwebtef.Cancelar := false;
                                    //------------------------------------------
                                 end
                              else if (StatusTransacao.Resultado.status_code=0) and (StatusTransacao.Resultado.via_loja='') then   // Autorizado
                                 begin
                                    //------------------------------------------
                                    SA_DesfazerAPI;
                                    sair := true;
                                    //------------------------------------------
                                    //   Retorno de finalizado sem comprovante
                                    //------------------------------------------
                                    frmwebtef.Cancelar := false;
                                    frmwebtef.mensagem := 'Não foi possível finalizar a transação de pagamento com o TEF !';
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                    while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                       begin
                                          sleep(50);
                                       end;
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    //------------------------------------------
                                 end
                              else if StatusTransacao.Resultado.status_code=1 then  // Processando a transação
                                 begin
                                    //------------------------------------------
                                    // Mostrando a mensagem de processamento
                                    //------------------------------------------
                                    frmwebtef.mensagem := 'Processando transação. Aguarde...';
                                    if StatusTransacao.Resultado.status_message<>'' then
                                       frmwebtef.mensagem := uppercase(StatusTransacao.Resultado.status_message);
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                              if (frmwebtef.Cancelar) and (LTipoTEF=EmbedPOS) then
                                 begin
                                    //------------------------------------------
                                    SA_AbortarAPI;
                                    sair := true;
                                    //------------------------------------------
                                    //   Retorno de finalizado sem comprovante
                                    //------------------------------------------
                                    frmwebtef.Cancelar := false;
                                    frmwebtef.mensagem := 'A operação foi cancelada pelo operador !';
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
                           end;
                        //------------------------------------------------------
                     end
                  else  // Houve erro ao processar a chamada de TEF
                     begin
                        //------------------------------------------------------
                        // Ocorreu algum erro ao iniciar o TEF
                        //   Mostrar mensagem de erro
                        //------------------------------------------------------
                        frmwebtef.Cancelar := false;
                        frmwebtef.mensagem := 'Não foi possível iniciar a transação de pagamento com o TEF !';
                        if RetornoTransacao.codigo<>99 then
                           begin
                              if RetornoTransacao.Mensagem<>'' then
                                 frmwebtef.mensagem := uppercase(RetornoTransacao.Mensagem);
                              if RetornoTransacao.Resultado.status_message<>'' then
                                 frmwebtef.mensagem := uppercase(RetornoTransacao.Resultado.status_message);
                           end;
                        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                        TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                        while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                           begin
                              sleep(50);
                           end;
                        TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                        //------------------------------------------------------
                     end;
               end
            else
               begin
                  //------------------------------------------------------------
                  // Ocorreu algum erro ao iniciar o TEF
                  //------------------------------------------------------------
                  frmwebtef.Cancelar := false;
                  frmwebtef.mensagem := uppercase(Mensagem); // 'Não foi possível iniciar a transação com o TEF !';
                  TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                  TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                  while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                     begin
                        sleep(50);
                     end;
                  TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                  //------------------------------------------------------------
               end;
            //------------------------------------------------------------------
            frmwebtef.mensagem := 'Obtendo a sequência da operação...';
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            //------------------------------------------------------------------
         end;
   end);
   //---------------------------------------------------------------------------
   Mythread.onterminate := MythreadEnd;
   Mythread.start;
   //---------------------------------------------------------------------------
end;


end.
