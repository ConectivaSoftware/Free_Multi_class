unit uVeroTEF;

interface

uses
   RESTRequest4D,
   uMulticlassFuncoes,
   uKSTypes,
   uwebtefmp,
   ACBRPosPrinter,
   System.SysUtils,
   System.DateUtils,
   system.json,
   system.Classes,
   PngImage,
   jpeg,
   synacode,
   vcl.graphics,
   Vcl.dialogs,
   Vcl.Forms;

type
   //---------------------------------------------------------------------------
   TVEROTipoImagem           = (tpImageBMP,tpImageJPG,tpImageJPEG,tpImagePNG,tpImagePDF,tpImageDesconhecido);
   TtpImpressaoDocumento     = (tpVEROTexto,tpVEROImagem);
   //---------------------------------------------------------------------------
   TpVEROResp = record  // Retorno de uma transação VERO
      transaction_token : string;
      status            : string;
      amount            : real;
      transaction_name  : string;
      card_brand        : string;
      card_pan          : string;
      auth_code         : string;
      nsu               : string;
      receipt_store     : string;
      receipt_client    : string;
      date_created      : string;
      date_started      : string;
      date_ended        : string;
      group             : string;
      //------------------------------------------------------------------------
      mensagemErro      : string;
      //------------------------------------------------------------------------
      ComprovanteCliente      : TStringList;
      ComprovanteLoja         : TStringList;
      ComprovanteSimplificado : TStringList;
      //------------------------------------------------------------------------
      PagamentoExcluido       : boolean; // Resposta quando um pagamento é excluido
      //------------------------------------------------------------------------
   end;
   //---------------------------------------------------------------------------
   TVEROSmartTEF = class
      private
        //----------------------------------------------------------------------
        LImpressora : TKSConfigImpressora;  // Configuração da impressora
        //----------------------------------------------------------------------
        LpdvToken                 : string;
        LdeviceToken              : string;
        LmerchantDocumentNumber   : string;
        LNomeMaquina              : string;   // Nome da maquininha para fazer Pre Venda - Grupo
        //----------------------------------------------------------------------
        LSalvarLOG         : boolean;  // Variável que habilita salvar LOGs de comunicação
        LExecutando        : boolean;  // Informar que o processamento está executando - Usado para aguardar a THREAD tereminar o processamento
        LTerminalVinculado : boolean;  // Se o terminal foi vinculado ao PDV
        LImpressoRealizado : boolean;  // Se a impressão ocorreu normalmente
        //----------------------------------------------------------------------
        LComprovanteLoja             : TtpTEFImpressao;  // Impressão do comprovante da loja
        LComprovanteCliente          : TtpTEFImpressao;  // Impressão do comprovante do cliente
        LComprovanteLojaSimplificado : boolean;          // Impressão do comprovante da loja ser simplificado, somente com as informações para conferência
        LTurno                       : integer;          // Numero do turno no PDV
        LNumeroTEF                   : integer;
        //----------------------------------------------------------------------
        LPagamento_Forma        : string;           // Forma de pagamento que será apresenada na tela do TEF
        LPagamento_Valor        : real;             // Valor da transação
        LPagamento_Parcelas     : integer;          // Quantidade de parcelas ewm caso de pagamento com cartão de crédito parcelado
        LPagamento_Pedido       : string;           // Documento da venda
        LPagamento_FormaTEF     : TtpVEROFormaPgto; // Forma de pagamento que define como serpa transacionado no TEF
        LPagamento_PrazoPre     : integer;          // Prazo para pre datado
        LPagamento_DiaMensal    : integer;          // Dia para vencimento quando reccorrente
        LPagamento_Mensagem     : string;           // Mensagem a ser apresentada na SMART
        LComprovanteImprimir    : string;           // Comprovante a ser impresso no SMART POS VERO
        LImagemImprimir         : string;           // Imagem em formato BASE64
        LArquivoImagemImprimir  : string;           // Nome do arquivo para imprimir
        //----------------------------------------------------------------------
        LCancelamento_NSU       : string;      // NSU para cancelamento
        LCancelamento_Valor     : real;        // Valor para cancelamento - Poderia usar LPagamento_Valor, mas para ficar mais intuitivo usei outra PROPERTY
        LCancelamento_Forma     : string;      // Forma de pagamento para cancelamento
        //----------------------------------------------------------------------
        LCancelamento_transactionToken : string; // Token para excluir um pagamento da fila
        //----------------------------------------------------------------------
        LResp : TpVEROResp;  // Resposta da requisição
        //----------------------------------------------------------------------
        procedure SA_VincularTerminalPDV;
        procedure SA_FazerPagamento;
        procedure SA_FazerPagamentoPreVenda;
        procedure SA_FazerCancelamento;
        procedure SA_ExcluirPagamento;
        procedure SA_ConsultarPagamento;
        procedure SA_SalvarLog(titulo, dado: string);
        function SA_FormaToSTR(forma:TtpVEROFormaPgto):string;
        function SA_Valor : string;
        //----------------------------------------------------------------------
        procedure MythreadEnd(sender: tobject);
        procedure SA_MostramensagemT;
        procedure SA_MostrarBtCancelarT;
        procedure SA_DesativarBtCancelarT;
        procedure SA_CriarMenuT;
        procedure SA_DesativarMenuT;
        function SA_CalcularTempo(tempo:integer):string;
        //----------------------------------------------------------------------
        function SA_Tipo_Imagem(nome:string):TVEROTipoImagem;
        procedure SA_CarregarArquivoJPGBase64;
        procedure SA_ImprimirCupom(tipo:TtpImpressaoDocumento);
        //----------------------------------------------------------------------
      public
        //----------------------------------------------------------------------
        constructor Create();
        destructor Destroy(); override;
        //----------------------------------------------------------------------
        property Impressora               : TKSConfigImpressora read LImpressora write LImpressora;  // Configuração da impressora
        //----------------------------------------------------------------------
        property pdvToken                 : string read LpdvToken                write LpdvToken;    // Token da aplicação
        property deviceToken              : string read LdeviceToken             write LdeviceToken; // Token da maquininha
        property merchantDocumentNumber   : string read LmerchantDocumentNumber  write LmerchantDocumentNumber;
        property NomeMaquina              : string read LNomeMaquina             write LNomeMaquina;   // Nome da maquininha para fazer Pre Venda - Grupo
        //----------------------------------------------------------------------
        property SalvarLOG  : boolean read LSalvarLOG  write LSalvarLOG;  // Variável que habilita salvar LOGs de comunicação
        property Executando : boolean read LExecutando write LExecutando; // Informar que o processamento está executando - Usado para aguardar a THREAD tereminar o processamento
        //----------------------------------------------------------------------
        property ComprovanteLoja             : TtpTEFImpressao read LComprovanteLoja             write LComprovanteLoja;  // Impressão do comprovante da loja
        property ComprovanteCliente          : TtpTEFImpressao read LComprovanteCliente          write LComprovanteCliente;  // Impressão do comprovante do cliente
        property ComprovanteLojaSimplificado : boolean         read LComprovanteLojaSimplificado write LComprovanteLojaSimplificado;                   // Impressão do comprovante da loja ser simplificado, somente com as informações para conferência
        property Turno                       : integer         read LTurno                       write LTurno;  // Numero do turno no PDV
        property NumeroTEF                   : integer         read LNumeroTEF;
        //----------------------------------------------------------------------
        property Pagamento_Forma        : string           read LPagamento_Forma       write LPagamento_Forma;        // Forma de pagamento que será apresenada na tela do TEF
        property Pagamento_Valor        : real             read LPagamento_Valor       write LPagamento_Valor;        // Valor da transação
        property Pagamento_Parcelas     : integer          read LPagamento_Parcelas    write LPagamento_Parcelas;     // Quantidade de parcelas ewm caso de pagamento com cartão de crédito parcelado
        property Pagamento_Pedido       : string           read LPagamento_Pedido      write LPagamento_Pedido;       // Documento da venda
        property Pagamento_FormaTEF     : TtpVEROFormaPgto read LPagamento_FormaTEF    write LPagamento_FormaTEF;     // Forma de pagamento que define como serpa transacionado no TEF
        property Pagamento_PrazoPre     : integer          read LPagamento_PrazoPre    write LPagamento_PrazoPre;     // Prazo para pre datado
        property Pagamento_DiaMensal    : integer          read LPagamento_DiaMensal   write LPagamento_DiaMensal;    // Dia para vencimento quando reccorrente
        property Pagamento_Mensagem     : string           read LPagamento_Mensagem    write LPagamento_Mensagem;     // Mensagem a ser apresentada na SMART
        property ComprovanteImprimir    : string           read LComprovanteImprimir   write LComprovanteImprimir;    // Comprovante a ser impresso no SMART POS VERO
        property ImagemImprimir         : string           read LImagemImprimir        write LImagemImprimir;         // Imagem em formato BASE64
        property ArquivoImagemImprimir  : string           read LArquivoImagemImprimir write LArquivoImagemImprimir;  // Nome do arquivo para imprimir
        //----------------------------------------------------------------------
        property Cancelamento_NSU       : string      read LCancelamento_NSU    write LCancelamento_NSU;    // NSU para cancelamento
        property Cancelamento_Valor     : real        read LCancelamento_Valor  write LCancelamento_Valor;  // Valor para cancelamento - Poderia usar LPagamento_Valor, mas para ficar mais intuitivo usei outra PROPERTY
        property Cancelamento_Forma     : string      read LCancelamento_Forma  write LCancelamento_Forma;  // Forma de pagamento para cancelamento
        //----------------------------------------------------------------------
        property Cancelamento_transactionToken : string read LCancelamento_transactionToken write LCancelamento_transactionToken; // Token para excluir um pagamento da fila
        //----------------------------------------------------------------------
        property Resp                   : TpVEROResp  read LResp;  // Resposta da requisição
        property ImpressoRealizado      : boolean     read LImpressoRealizado write LImpressoRealizado;  // Se a impressão ocorreu normalmente
        //----------------------------------------------------------------------
        procedure SA_ProcessarPagamento;
        procedure SA_ProcessarPagamentoPreVenda;
        procedure SA_ProcessarCancelamento;
        procedure SA_ProcessarExclusaoPgtoPrevenda;
        procedure SA_ImprimirTextoSMART;
        procedure SA_ImprimirImagem;

        //----------------------------------------------------------------------
   end;
implementation

{ TVEROSmartTEF }

constructor TVEROSmartTEF.Create;
begin
   //---------------------------------------------------------------------------
   LTerminalVinculado            := false;
   LResp.transaction_token       := '';
   LResp.ComprovanteCliente      := TStringList.Create;
   LResp.ComprovanteLoja         := TStringList.Create;
   LResp.ComprovanteSimplificado := TStringList.Create;
   lExecutando                   := true;
   //---------------------------------------------------------------------------
   inherited;
   //---------------------------------------------------------------------------
end;

destructor TVEROSmartTEF.Destroy;
begin
  //----------------------------------------------------------------------------
  try
     LResp.ComprovanteCliente.Free;
     LResp.ComprovanteLoja.Free;
     LResp.ComprovanteSimplificado.Free;
  except
  end;
  //----------------------------------------------------------------------------
  inherited;
  //----------------------------------------------------------------------------
end;

procedure TVEROSmartTEF.MythreadEnd(sender: tobject);
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

function TVEROSmartTEF.SA_CalcularTempo(tempo: integer): string;
var
   minutos  : integer;
   segundos : integer;
begin
   minutos  := trunc(tempo/60);
   segundos := tempo-(minutos*60);
   Result   := strzero(minutos,2)+':'+strzero(segundos,2);
end;

procedure TVEROSmartTEF.SA_CarregarArquivoJPGBase64;
var
   stream     : TStringStream;
   arquivoPDF : TFileStream;
   //---------------------------------------------------------------------------
   imagem_png : TPngImage;
   imagem_bmp : TBitmap;
   imagem_jpg : TJPEGImage;
   //---------------------------------------------------------------------------

begin
   //---------------------------------------------------------------------------
   LImagemImprimir := '';
   stream          := TStringStream.Create;
   if fileexists(LArquivoImagemImprimir) then
      begin
         try
            if SA_Tipo_Imagem(LArquivoImagemImprimir)=tpImageBMP then   // BMP
               begin
                  //------------------------------------------------------------
                  imagem_bmp := TBitmap.Create;
                  imagem_bmp.LoadFromFile(LArquivoImagemImprimir);
                  imagem_bmp.SaveToStream(stream);
                  imagem_bmp.Free;
                  //------------------------------------------------------------
               end
            else if (SA_Tipo_Imagem(LArquivoImagemImprimir)=tpImageJPG) or (SA_Tipo_Imagem(LArquivoImagemImprimir)=tpImageJPEG) then // JPEG
               begin
                  //------------------------------------------------------------
                  imagem_jpg     := TJPEGImage.Create;
                  imagem_jpg.LoadFromFile(LArquivoImagemImprimir);
                  imagem_jpg.SaveToStream(stream);
                  imagem_jpg.Free;
                  //------------------------------------------------------------
               end
            else if SA_Tipo_Imagem(LArquivoImagemImprimir)=tpImagePNG then // PNG
               begin
                  //------------------------------------------------------------
                  imagem_png     := TPngImage.Create;
                  imagem_png.LoadFromFile(LArquivoImagemImprimir);
                  imagem_png.SaveToStream(stream);
                  imagem_png.Free;
                  //------------------------------------------------------------
               end
            else if SA_Tipo_Imagem(LArquivoImagemImprimir)=tpImagePDF then // PDF
               begin
                  //------------------------------------------------------------
                  arquivoPDF  := TFileStream.Create(LArquivoImagemImprimir,fmOpenRead);
                  stream.LoadFromStream(arquivoPDF);
                  arquivoPDF.Free;
                  //------------------------------------------------------------
               end;
            //------------------------------------------------------------------
            if stream.DataString<>'' then
                LImagemImprimir := string(EncodeBase64(ansistring(stream.DataString)));
            //------------------------------------------------------------------
         except on e:Exception do
            begin
               SA_SalvarLog('ERRO CARREGAR IMAGEM',e.Message);   // Salvando LOG
            end;
         end;
         //---------------------------------------------------------------------
      end;
   //---------------------------------------------------------------------------
   stream.Free;
end;

procedure TVEROSmartTEF.SA_ConsultarPagamento;
var
   JSONStr    : string;
   LResponse  : IResponse;
   RespJSON   : TJSONValue;
   RespStatus : TJSONObject;
   status     : string;
begin
   //---------------------------------------------------------------------------
   JSONStr := '{'+
                '"pdvToken":"'+LpdvToken+'",'+
                '"transactionToken":["'+LResp.transaction_token+'"]}';
   //---------------------------------------------------------------------------
   SA_SalvarLog('CONSULTAR PAGAMENTO',JSONStr);
   //---------------------------------------------------------------------------
   LResponse := TRequest.New.BaseURL('https://pdv.verostore.com.br/apiTransactionQuery.php')
                      .AddBody(jsonstr)
                      .Accept('application/json')
                      .Post;
   //---------------------------------------------------------------------------
   if LResponse.StatusCode=200 then
      begin
         //---------------------------------------------------------------------
         SA_SalvarLog('RETORNO CONSULTA',LResponse.Content);   // Salvando LOG
         //---------------------------------------------------------------------
         RespJSON                := TJSonObject.ParseJSONValue(TEncoding.UTF8.GetBytes( LResponse.Content  ),0) as TJSONValue;
         RespStatus              := RespJSON.GetValue<TJSONObject>(LResp.transaction_token,nil);
         if RespStatus<>nil then
            begin
               //---------------------------------------------------------------
               status                 := RespStatus.GetValue<string>('status','');
               LResp.status           := status;
               LResp.amount           := untransform(RespStatus.GetValue<string>('amount',''));
               LResp.transaction_name := RespStatus.GetValue<string>('transaction_name','');
               LResp.card_brand       := RespStatus.GetValue<string>('card_brand','');
               LResp.card_pan         := RespStatus.GetValue<string>('card_pan','');
               LResp.auth_code        := RespStatus.GetValue<string>('auth_code','');
               LResp.nsu              := RespStatus.GetValue<string>('nsu','');
               LResp.receipt_store    := RespStatus.GetValue<string>('receipt_store','');
               LResp.receipt_client   := RespStatus.GetValue<string>('receipt_client','');
               LResp.date_created     := RespStatus.GetValue<string>('date_created','');
               LResp.date_started     := RespStatus.GetValue<string>('date_started','');
               LResp.date_ended       := RespStatus.GetValue<string>('date_ended','');
               LResp.group            := RespStatus.GetValue<string>('group','');
               //---------------------------------------------------------------
               LResp.ComprovanteCliente.Text := LResp.receipt_client;   // Comprovante do cliente
               LResp.ComprovanteCliente.Text := StringReplace(LResp.ComprovanteCliente.Text,'n\',#13,[rfReplaceAll]);
               //---------------------------------------------------------------
               LResp.ComprovanteLoja.Text    := LResp.receipt_store;    // Comprovante do lojista
               LResp.ComprovanteLoja.Text    := StringReplace(LResp.ComprovanteLoja.Text,'n\',#13,[rfReplaceAll]);
               //---------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
         RespJSON.DisposeOf;
         //---------------------------------------------------------------------
      end
   else
      begin
         SA_SalvarLog('ERRO REQUISICAO',LResponse.StatusCode.ToString+' '+LResponse.StatusText+' '+LResponse.Content );   // Salvando LOG
         LResp.mensagemErro      := LResponse.StatusCode.ToString+' '+LResponse.StatusText+' '+LResponse.Content;
      end;
   //---------------------------------------------------------------------------
end;

procedure TVEROSmartTEF.SA_CriarMenuT;
begin
   SA_Criar_Menu(true);
end;

procedure TVEROSmartTEF.SA_DesativarBtCancelarT;
begin
   SA_DesativarBTCancelar;
end;

procedure TVEROSmartTEF.SA_DesativarMenuT;
begin
   SA_Criar_Menu(false);
end;

procedure TVEROSmartTEF.SA_ExcluirPagamento;
var
   JSONStr   : string;
   LResponse : IResponse;
   RespJSON  : TJSONValue;
begin
   //---------------------------------------------------------------------------
   JSONStr := '{'+
                '"pdvToken":"'+LpdvToken+'",'+
                '"transactionToken":"'+LCancelamento_transactionToken+'"'+
               '}';
   //---------------------------------------------------------------------------
   SA_SalvarLog('REQUISICAO EXCLUIR PAGAMENTO',JSONStr);
   //---------------------------------------------------------------------------
   LResponse := TRequest.New.BaseURL('https://pdv.verostore.com.br/apiTransactionCancel.php')
                      .AddBody(jsonstr)
                      .Accept('application/json')
                      .Post;
   //---------------------------------------------------------------------------
   LResp.PagamentoExcluido := false;
   if LResponse.StatusCode=200 then
      begin
         //---------------------------------------------------------------------
         SA_SalvarLog('RETORNO REQUISICAO EXCLUSÃO PAGAMENTO',LResponse.Content);   // Salvando LOG
         //---------------------------------------------------------------------
         RespJSON                := TJSonObject.ParseJSONValue(TEncoding.UTF8.GetBytes( LResponse.Content  ),0) as TJSONValue;
         LResp.PagamentoExcluido := RespJSON.GetValue<string>(LCancelamento_transactionToken,'')='Cancelada (PDV)';
         LResp.mensagemErro      := '';
         if RespJSON.GetValue<string>('error_code','')<>'' then
            LResp.mensagemErro      := RespJSON.GetValue<string>('error_code','')+ ' ' + RespJSON.GetValue<string>('error_message','');
         RespJSON.DisposeOf;
         //---------------------------------------------------------------------
      end
   else
      begin
         SA_SalvarLog('ERRO REQUISICAO',LResponse.StatusCode.ToString+' '+LResponse.StatusText+' '+LResponse.Content );   // Salvando LOG
         LResp.mensagemErro      := LResponse.StatusCode.ToString+' '+LResponse.StatusText+' '+LResponse.Content;
      end;
   //---------------------------------------------------------------------------

end;

procedure TVEROSmartTEF.SA_FazerCancelamento;
var
   JSONStr   : string;
   LResponse : IResponse;
   RespJSON  : TJSONValue;
begin
   //---------------------------------------------------------------------------
   JSONStr := '{'+
                '"pdvToken":"'+LpdvToken+'",'+
                '"pdvVersion":"4.5",'+
                '"deviceToken":"'+LdeviceToken+'",'+
                '"merchantDocumentNumber":"'+LmerchantDocumentNumber+'",'+
                '"method":"CANCEL",'+
                '"nsu":'+LCancelamento_NSU+','+
                '"print":false,'+
                '"waitUser":false,'+
                '"comments":"'+LPagamento_Mensagem+'",'+
                '"group":"'+LdeviceToken+'"'+
               '}';
   //---------------------------------------------------------------------------
   SA_SalvarLog('REQUISICAO CANCELAMENTO',JSONStr);
   //---------------------------------------------------------------------------
   LResponse := TRequest.New.BaseURL('https://pdv.verostore.com.br/apiTransactionCreate.php')
                      .AddBody(jsonstr)
                      .Accept('application/json')
                      .Post;
   //---------------------------------------------------------------------------
   if LResponse.StatusCode=200 then
      begin
         //---------------------------------------------------------------------
         SA_SalvarLog('RETORNO REQUISICAO CANCELAMENTO',LResponse.Content);   // Salvando LOG
         //---------------------------------------------------------------------
         RespJSON                := TJSonObject.ParseJSONValue(TEncoding.UTF8.GetBytes( LResponse.Content  ),0) as TJSONValue;
         LResp.transaction_token := RespJSON.GetValue<string>('transaction_token','');
         LResp.mensagemErro      := '';
         RespJSON.DisposeOf;
         //---------------------------------------------------------------------
      end
   else
      begin
         SA_SalvarLog('ERRO REQUISICAO',LResponse.StatusCode.ToString+' '+LResponse.StatusText+' '+LResponse.Content );   // Salvando LOG
         LResp.mensagemErro      := LResponse.StatusCode.ToString+' '+LResponse.StatusText+' '+LResponse.Content;
      end;
   //---------------------------------------------------------------------------
end;
procedure TVEROSmartTEF.SA_FazerPagamento;
var
   JSONStr   : string;
   LResponse : IResponse;
   RespJSON  : TJSONValue;
begin
   //---------------------------------------------------------------------------
   JSONStr := '{'+
                '"pdvToken":"'+LpdvToken+'",'+
                '"pdvVersion":"4.5",'+
                '"deviceToken":"'+LdeviceToken+'",'+
                '"merchantDocumentNumber":"'+LmerchantDocumentNumber+'",'+
                '"amount":'+SA_Valor+','+
                '"method":"'+SA_FormaToSTR(LPagamento_FormaTEF)+'",'+
                '"print":false,'+
                '"waitUser":false,'+
                '"comments":"'+LPagamento_Mensagem+'",'+
                '"group":"'+LdeviceToken+'"'+
               '}';
   //---------------------------------------------------------------------------
   SA_SalvarLog('REQUISICAO PAGAMENTO',JSONStr);
   //---------------------------------------------------------------------------
   LResponse := TRequest.New.BaseURL('https://pdv.verostore.com.br/apiTransactionCreate.php')
                      .AddBody(jsonstr)
                      .Accept('application/json')
                      .Post;
   //---------------------------------------------------------------------------
   if LResponse.StatusCode=200 then
      begin
         //---------------------------------------------------------------------
         SA_SalvarLog('RETORNO REQUISICAO',LResponse.Content);   // Salvando LOG
         //---------------------------------------------------------------------
         RespJSON                := TJSonObject.ParseJSONValue(TEncoding.UTF8.GetBytes( LResponse.Content  ),0) as TJSONValue;
         LResp.transaction_token := RespJSON.GetValue<string>('transaction_token','');
         LResp.mensagemErro      := '';
         RespJSON.DisposeOf;
         //---------------------------------------------------------------------
      end
   else
      begin
         SA_SalvarLog('ERRO REQUISICAO',LResponse.StatusCode.ToString+' '+LResponse.StatusText+' '+LResponse.Content );   // Salvando LOG
         LResp.mensagemErro      := LResponse.StatusCode.ToString+' '+LResponse.StatusText+' '+LResponse.Content;
      end;
   //---------------------------------------------------------------------------
end;

procedure TVEROSmartTEF.SA_FazerPagamentoPreVenda;
var
   JSONStr   : string;
   LResponse : IResponse;
   RespJSON  : TJSONValue;
begin
   //---------------------------------------------------------------------------
   JSONStr := '{'+
                '"pdvToken":"'+LpdvToken+'",'+
                '"pdvVersion":"4.5",'+
                '"deviceToken":"'+LdeviceToken+'",'+
                '"merchantDocumentNumber":"'+LmerchantDocumentNumber+'",'+
                '"amount":'+SA_Valor+','+
                '"method":"'+SA_FormaToSTR(LPagamento_FormaTEF)+'",'+
                '"print":true,'+
                '"waitUser":false,'+
                '"comments":"'+LPagamento_Mensagem+'",'+
                '"group":"'+LNomeMaquina+'"'+
               '}';
   //---------------------------------------------------------------------------
   SA_SalvarLog('REQUISICAO PAGAMENTO PRE VENDA',JSONStr);
   //---------------------------------------------------------------------------
   LResponse := TRequest.New.BaseURL('https://pdv.verostore.com.br/apiTransactionCreate.php')
                      .AddBody(jsonstr)
                      .Accept('application/json')
                      .Post;
   //---------------------------------------------------------------------------
   if LResponse.StatusCode=200 then
      begin
         //---------------------------------------------------------------------
         SA_SalvarLog('RETORNO REQUISICAO PRE VENDA',LResponse.Content);   // Salvando LOG
         //---------------------------------------------------------------------
         RespJSON                := TJSonObject.ParseJSONValue(TEncoding.UTF8.GetBytes( LResponse.Content  ),0) as TJSONValue;
         LResp.transaction_token := RespJSON.GetValue<string>('transaction_token','');
         LResp.mensagemErro      := '';
         RespJSON.DisposeOf;
         //---------------------------------------------------------------------
      end
   else
      begin
         SA_SalvarLog('ERRO REQUISICAO PRE VENDA',LResponse.StatusCode.ToString+' '+LResponse.StatusText+' '+LResponse.Content );   // Salvando LOG
         LResp.mensagemErro      := LResponse.StatusCode.ToString+' '+LResponse.StatusText+' '+LResponse.Content;
      end;
   //---------------------------------------------------------------------------
end;

function TVEROSmartTEF.SA_FormaToSTR(forma: TtpVEROFormaPgto): string;
begin
   //---------------------------------------------------------------------------
   Result := 'UNDEFINED_WITH_AMOUNT';
   //---------------------------------------------------------------------------
   case forma of
     tpVeroPerguntar                 : Result := 'UNDEFINED_WITH_AMOUNT';
     tpVEROCreditoPerguntar          : Result := 'CREDIT_UNDEFINED';
     tpVEROCreditoVista              : Result := 'CREDIT_1X';
     tpVEROCreditoParceladoPerguntar : Result := 'CREDIT_UNDEFINED';
     tpVEROCreditoParceladoLoja      : Result := 'CREDIT_NX_STORE';
     tpVEROCreditoParceladoADM       : Result := 'CREDIT_NX_ISSUER';
     tpVEROCreditoMensal             : Result := 'CREDIT_REPAY';
     tpVERODebitoPerguntar           : Result := 'DEBIT_UNDEFINED';
     tpVERODebitoVista               : Result := 'DEBIT_BRAND';
     tpVERODebitoBANRI               : Result := 'DEBIT_BANRICOMPRAS';
     tpVERODebitoBanriPre            : Result := 'DEBIT_BANRICOMPRAS_PREDATED';
     tpVEROBanriPrazo                : Result := 'DEBIT_BANRICOMPRAS_NX';
     tpVEROBanriMinuto               : Result := 'DEBIT_BANRICOMPRAS_C1M';
     tpVEROVoucher                   : Result := 'VOUCHER';
     tpVEROPIX                       : Result := 'QRCODE_VERO_X';
     tpVEROWLLET                     : Result := 'QRCODE_VERO_WALLET';
   end;
   //---------------------------------------------------------------------------
end;


procedure TVEROSmartTEF.SA_ImprimirCupom(tipo:TtpImpressaoDocumento);
var
   LResponse : IResponse;
   JSONStr   : string;
   RespJSON  : TJSONValue;
   conteudo  : string;
begin
   //---------------------------------------------------------------------------
   // https://pdv.verostore.com.br/apiPrintCreate.php
   //---------------------------------------------------------------------------
   LComprovanteImprimir := StringReplace(LComprovanteImprimir,#13+#10,'\n',[rfReplaceAll]);
   LComprovanteImprimir := StringReplace(LComprovanteImprimir,#13,'\n',[rfReplaceAll]);
   LImpressoRealizado   := false;
   if tipo = tpVEROTexto then   // Imprimir um texto
      conteudo  := '"text":"'+LComprovanteImprimir+'",'
   else   // Imprimir uma imagem
      begin
         SA_CarregarArquivoJPGBase64;
         if LImagemImprimir<>'' then
            conteudo  := '"encoded":"'+LImagemImprimir+'",'
         else
            exit;
      end;
   //---------------------------------------------------------------------------
   JSONStr   := '{'+
                   '"pdvToken":"'+LpdvToken+'",'+
                   '"merchantDocumentNumber":"'+LmerchantDocumentNumber+'",'+
                   '"deviceToken":"'+LdeviceToken+'",'+
                   '"pdvVersion":"4.5",'+
                   '"group":"'+LdeviceToken+'",'+
                   conteudo+
                   '"comments":"'+LPagamento_Mensagem+'"'+
                   '}';
   SA_SalvarLog('IMPRESSAO DE DOCUMENTO TEXTO',JSONStr);
   //---------------------------------------------------------------------------
   LResponse := TRequest.New.BaseURL('https://pdv.verostore.com.br/apiPrintCreate.php')
                      .AddBody(jsonstr)
                      .Accept('application/json')
                      .Post;
   //---------------------------------------------------------------------------
   JSONStr     := '';
   LExecutando := false;
   //---------------------------------------------------------------------------
   if LResponse.StatusCode=200 then
      begin
         //---------------------------------------------------------------------
         SA_SalvarLog('IMPRESSAO DE DOCUMENTO',LResponse.Content);
         RespJSON           := TJSonObject.ParseJSONValue(TEncoding.UTF8.GetBytes( LResponse.Content  ),0) as TJSONValue;
         LImpressoRealizado := RespJSON.GetValue<string>('print_token','') <> '';
         RespJSON.DisposeOf;
         //---------------------------------------------------------------------
      end
   else
      SA_SalvarLog('ERRO IMPRIMIR DOCUMENTO',LResponse.StatusCode.ToString+' '+LResponse.StatusText+' '+LResponse.Content);
   //---------------------------------------------------------------------------

end;

procedure TVEROSmartTEF.SA_ImprimirImagem;
begin
   SA_ImprimirCupom(tpVEROImagem);
end;

procedure TVEROSmartTEF.SA_ImprimirTextoSMART;
begin
   SA_ImprimirCupom(tpVEROTexto);
end;


procedure TVEROSmartTEF.SA_MostramensagemT;
begin
   SA_Mostrar_Mensagem(true);
end;

procedure TVEROSmartTEF.SA_MostrarBtCancelarT;
begin
   SA_AtivarBTCancelar;   // Ativar o botão cancelar na tela de TEF
end;

procedure TVEROSmartTEF.SA_ProcessarCancelamento;
var
   //---------------------------------------------------------------------------
   Mythread : TThread;
   sair     : boolean;
   //---------------------------------------------------------------------------
   HInicio         : TDateTime;
   HultimaLeitura  : TDateTime;  // Para fazer a leitura
   HUltimaContagem : TDateTime;  // Para mostrar na tela o tempo
   //---------------------------------------------------------------------------
   imprimir     : boolean;
   opcoesColeta : TStringList;
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpVEROSmartTEF;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LCancelamento_Forma;
   frmwebtef.lbvalor.Caption  := transform(LCancelamento_Valor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   //---------------------------------------------------------------------------
   Mythread := TThread.CreateAnonymousThread(procedure
      begin
         //---------------------------------------------------------------------
         frmwebtef.mensagem := 'Fazendo vínculo com o PDV SMART...';
         TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
         SA_VincularTerminalPDV;
         if LTerminalVinculado then
            begin
               //---------------------------------------------------------------------
               frmwebtef.mensagem := 'Enviando requisição...';
               TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
               SA_FazerCancelamento;
               if LResp.transaction_token<>'' then
                  begin
                     //---------------------------------------------------------------
                     //   Fazer LOOP de consulta
                     //---------------------------------------------------------------
                     HInicio         := now;
                     HultimaLeitura  := now;
                     HUltimaContagem := now;
                     //---------------------------------------------------------------
                     sair     := false;
                     while not sair do
                        begin
                           //---------------------------------------------------------
                           if SecondsBetween(now,HUltimaContagem)>=1 then  // Passou-se dois segundos da ultima consulta
                              begin
                                 HUltimaContagem := now;
                                 frmwebtef.mensagem := 'Aguardando CANCELAMENTO - '+ SA_CalcularTempo(SecondsBetween(now,HInicio));
                                 TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              end;
                           //------------------------------------------------------
                           if (SecondsBetween(now,HultimaLeitura)>=3) and (not sair) then  // Passou-se dois segundos da ultima consulta
                              begin
                                 //---------------------------------------------------
                                 SA_ConsultarPagamento;  // Fazer uma consulta no pagamento
                                 //---------------------------------------------------
                                 if LResp.status='Disponível' then  // Transação está disponível para os terminais vinculados ao CNPJ/CPF e ao PDV
                                    begin
                                       frmwebtef.mensagem := 'Aguardando CANCELAMENTO - '+ SA_CalcularTempo(SecondsBetween(now,HInicio));
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    end
                                 else if LResp.status='Em andamento' then  // Transação foi iniciada por um terminal
                                    begin
                                       frmwebtef.mensagem := 'CANCELAMENTO em andamento - '+ SA_CalcularTempo(SecondsBetween(now,HInicio));
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    end
                                 else if LResp.status='Cancelada (PDV):' then  // Transação foi cancelada pelo PDV e não será mais exibida aos terminais vinculados
                                    begin
                                       frmwebtef.mensagem := 'Cancelado pelo operador';
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                       sair := true;
                                       while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                          begin
                                             sleep(50);
                                          end;
                                    end
                                 else if LResp.status='Cancelada (Operador)' then  // A transação foi cancelada pelo operador da maquininha após ser iniciada
                                    begin
                                       //---------------------------------------------
                                       frmwebtef.mensagem := 'Cancelado cliente';
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                       sair := true;
                                       while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                          begin
                                             sleep(50);
                                          end;
                                       //---------------------------------------------
                                    end
                                 else if LResp.status='Falha' then  // Houve alguma situação não prevista que impediu que a transação fosse concluída na maquininha
                                    begin
                                       //---------------------------------------------
                                       frmwebtef.mensagem := 'Falha na SMART POS';
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                       sair := true;
                                       while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                          begin
                                             sleep(50);
                                          end;
                                       //---------------------------------------------
                                    end
                                 else if LResp.status='Declinada' then  // A transação foi declinada
                                    begin
                                       //---------------------------------------------
                                       frmwebtef.mensagem := 'Transação declinada';
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                       sair := true;
                                       while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                          begin
                                             sleep(50);
                                          end;
                                       //---------------------------------------------
                                    end
                                 else if LResp.status='Aprovada' then  // A transação foi aprovada.
                                    begin
                                       //---------------------------------------------
                                       //  Operação aprovada - Providenciar a impressão dos comprovantes
                                       //---------------------------------------------
                                       // Comprovante do cliente
                                       //---------------------------------------------
                                       sair     := true;
                                       imprimir := LComprovanteCliente=tpTEFImprimirSempre;
                                       if LComprovanteCliente=tpTEFPerguntar then
                                          begin
                                             //---------------------------------------
                                             //   Perguntar se quer imprimir
                                             //---------------------------------------
                                             opcoesColeta := TStringList.Create;
                                             opcoesColeta.Add('Imprimir');
                                             opcoesColeta.Add('Não Imprimir');
                                             frmwebtef.mensagem := 'Imprimir o comprovante do CLIENTE ?';
                                             frmwebtef.opcoes   := opcoesColeta;
                                             frmwebtef.opcao    := -1;
                                             frmwebtef.tecla    := '';
                                             frmwebtef.Cancelar := false;
                                             //---------------------------------------
                                             TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                             TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                             //---------------------------------------
                                             while (not frmwebtef.Cancelar) do
                                                begin
                                                  if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                     begin
                                                        //----------------------------
                                                        imprimir := true;
                                                        frmwebtef.Cancelar := true;
                                                        //----------------------------
                                                     end
                                                  else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                                     frmwebtef.Cancelar := true;
                                                   //---------------------------------
                                                   sleep(50);
                                                end;
                                             TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                             TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                             //---------------------------------------
                                             frmwebtef.Cancelar := false;
                                             //---------------------------------------
                                             if imprimir then
                                                SA_ImprimirTexto(LResp.ComprovanteCliente.Text,LImpressora);

                                          end;
                                       //---------------------------------------------
                                       // Comprovante do cliente
                                       //---------------------------------------------
                                       imprimir := LComprovanteLoja=tpTEFImprimirSempre;
                                       if LComprovanteLoja=tpTEFPerguntar then
                                          begin
                                             //---------------------------------------
                                             //   Perguntar se quer imprimir
                                             //---------------------------------------
                                             opcoesColeta := TStringList.Create;
                                             opcoesColeta.Add('Imprimir');
                                             opcoesColeta.Add('Não Imprimir');
                                             frmwebtef.mensagem := 'Imprimir o comprovante do LOJISTA ?';
                                             frmwebtef.opcoes   := opcoesColeta;
                                             frmwebtef.opcao    := -1;
                                             frmwebtef.tecla    := '';
                                             frmwebtef.Cancelar := false;
                                             //---------------------------------------
                                             TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                             TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                             //---------------------------------------
                                             while (not frmwebtef.Cancelar) do
                                                begin
                                                  if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                     begin
                                                        //----------------------------
                                                        imprimir := true;
                                                        frmwebtef.Cancelar := true;
                                                        //----------------------------
                                                     end
                                                  else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                                     frmwebtef.Cancelar := true;
                                                   //---------------------------------
                                                   sleep(50);
                                                end;
                                             TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                             TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                             //---------------------------------------
                                             frmwebtef.Cancelar := false;
                                             //---------------------------------------
                                             if imprimir then
                                                SA_Imprimirtexto(LResp.ComprovanteLoja.Text,LImpressora);   // Imprimindo
                                             //---------------------------------------
                                          end;
                                       //---------------------------------------------
                                    end;
                                 //---------------------------------------------------
                              end;
                           //---------------------------------------------------------
                        end;
                     //---------------------------------------------------------------
                  end
               else
                  begin
                     //---------------------------------------------------------------
                     //   Fazer rotina de mostrar a tela de erro
                     //---------------------------------------------------------------
                     frmwebtef.mensagem := LResp.mensagemErro;
                     TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                     TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                     while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                        begin
                           sleep(50);
                        end;
                     //---------------------------------------------------------------
                  end;
            end
         else
            begin
               //---------------------------------------------------------------
               // Tratar falha na vinculação com o terminal
               //---------------------------------------------------------------
               frmwebtef.mensagem := 'Falha ao vincular o terminal ao lojista...';
               TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
               TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
               while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                  begin
                     sleep(50);
                  end;
               //---------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
      end);
   //---------------------------------------------------------------------------
   Mythread.onterminate := MythreadEnd;
   Mythread.start;
   //---------------------------------------------------------------------------

end;

procedure TVEROSmartTEF.SA_ProcessarExclusaoPgtoPrevenda;
var
   //---------------------------------------------------------------------------
   Mythread : TThread;
   sair     : boolean;
   //---------------------------------------------------------------------------
   HInicio         : TDateTime;
   HultimaLeitura  : TDateTime;  // Para fazer a leitura
   HUltimaContagem : TDateTime;  // Para mostrar na tela o tempo
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpVEROSmartTEF;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LPagamento_Forma;
   frmwebtef.lbvalor.Caption  := transform(LPagamento_Valor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   //---------------------------------------------------------------------------
   Mythread := TThread.CreateAnonymousThread(procedure
      begin
         //---------------------------------------------------------------------
         frmwebtef.mensagem := 'Fazendo vínculo com o PDV SMART...';
         TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
         SA_VincularTerminalPDV;
         if LTerminalVinculado then
            begin
               //---------------------------------------------------------------------
               frmwebtef.mensagem := 'Enviando requisição...';
               TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
               SA_ExcluirPagamento;
               if LResp.PagamentoExcluido then
                  begin
                     //---------------------------------------------------------------
                     //   Fazer LOOP de consulta
                     //---------------------------------------------------------------
                     HInicio         := now;
                     HultimaLeitura  := now;
                     HUltimaContagem := now;
                     //---------------------------------------------------------------
                     sair     := false;
                     while not sair do
                        begin
                           //---------------------------------------------------------
                           //   Processar o cancelamento pelo operador
                           //---------------------------------------------------------
                           if SecondsBetween(now,HUltimaContagem)>=1 then  // Passou-se dois segundos da ultima consulta
                              begin
                                 HUltimaContagem := now;
                                 frmwebtef.mensagem := 'Aguardando pagamento - '+ SA_CalcularTempo(SecondsBetween(now,HInicio));
                                 TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              end;
                           //------------------------------------------------------
                           if (SecondsBetween(now,HultimaLeitura)>=3) and (not sair) then  // Passou-se dois segundos da ultima consulta
                              begin
                                 //---------------------------------------------------
                                 LResp.transaction_token := LCancelamento_transactionToken;
                                 SA_ConsultarPagamento;  // Fazer uma consulta no pagamento
                                 //---------------------------------------------------
                                 if LResp.status='Cancelada (PDV)' then  // Transação está disponível para os terminais vinculados ao CNPJ/CPF e ao PDV
                                    begin
                                       //---------------------------------------
                                       //   Sair da rotina como pagamento realizado
                                       //---------------------------------------
                                       sair := true;
                                       LResp.PagamentoExcluido := true;
                                       //---------------------------------------
                                    end
                                 else if LResp.status='Falha' then  // Houve alguma situação não prevista que impediu que a transação fosse concluída na maquininha
                                    begin
                                       //---------------------------------------------
                                       frmwebtef.mensagem := 'Falha na SMART POS';
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                       sair                    := true;
                                       LResp.PagamentoExcluido := false;
                                       while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                          begin
                                             sleep(50);
                                          end;
                                       //---------------------------------------------
                                    end;
                                 //---------------------------------------------------
                              end;
                           //---------------------------------------------------------
                        end;
                     //---------------------------------------------------------------
                  end
               else
                  begin
                     //---------------------------------------------------------------
                     //   Fazer rotina de mostrar a tela de erro
                     //---------------------------------------------------------------
                     frmwebtef.mensagem := LResp.mensagemErro;
                     TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                     TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                     while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                        begin
                           sleep(50);
                        end;
                     //---------------------------------------------------------------
                  end;
            end
         else
            begin
               //---------------------------------------------------------------
               // Tratar falha na vinculação com o terminal
               //---------------------------------------------------------------
               frmwebtef.mensagem := 'Falha ao vincular o terminal ao lojista...';
               TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
               TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
               while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                  begin
                     sleep(50);
                  end;
               //---------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
      end);
   //---------------------------------------------------------------------------
   Mythread.onterminate := MythreadEnd;
   Mythread.start;
   //---------------------------------------------------------------------------
end;

procedure TVEROSmartTEF.SA_ProcessarPagamento;
var
   //---------------------------------------------------------------------------
   Mythread : TThread;
   sair     : boolean;
   //---------------------------------------------------------------------------
   HInicio         : TDateTime;
   HultimaLeitura  : TDateTime;  // Para fazer a leitura
   HUltimaContagem : TDateTime;  // Para mostrar na tela o tempo
   //---------------------------------------------------------------------------
   imprimir     : boolean;
   opcoesColeta : TStringList;
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpVEROSmartTEF;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LPagamento_Forma;
   frmwebtef.lbvalor.Caption  := transform(LPagamento_Valor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   //---------------------------------------------------------------------------
   Mythread := TThread.CreateAnonymousThread(procedure
      begin
         //---------------------------------------------------------------------
         frmwebtef.mensagem := 'Fazendo vínculo com o PDV SMART...';
         TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
         SA_VincularTerminalPDV;
         if LTerminalVinculado then
            begin
               //---------------------------------------------------------------------
               frmwebtef.mensagem := 'Enviando requisição...';
               TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
               SA_FazerPagamento;
               if LResp.transaction_token<>'' then
                  begin
                     //---------------------------------------------------------------
                     //   Fazer LOOP de consulta
                     //---------------------------------------------------------------
                     HInicio         := now;
                     HultimaLeitura  := now;
                     HUltimaContagem := now;
                     //---------------------------------------------------------------
                     TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                     sair     := false;
                     while not sair do
                        begin
                           //---------------------------------------------------
                           //   Processar o cancelamento pelo operador
                           //---------------------------------------------------
                           if frmwebtef.Cancelar then
                              begin
                                 //---------------------------------------------
                                 //  Cancelar operação em andamento
                                 //---------------------------------------------
                                 frmwebtef.mensagem := 'Removendo pagamento';
                                 TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                 LCancelamento_transactionToken := LResp.transaction_token;
                                 TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                 SA_ExcluirPagamento;
                                 frmwebtef.Cancelar := false;
                                 //---------------------------------------------
                              end;
                           //---------------------------------------------------
                           if SecondsBetween(now,HUltimaContagem)>=1 then  // Passou-se dois segundos da ultima consulta
                              begin
                                 HUltimaContagem := now;
                                 frmwebtef.mensagem := 'Aguardando pagamento - '+ SA_CalcularTempo(SecondsBetween(now,HInicio));
                                 TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              end;
                           //------------------------------------------------------
                           if (SecondsBetween(now,HultimaLeitura)>=3) and (not sair) then  // Passou-se dois segundos da ultima consulta
                              begin
                                 //---------------------------------------------------
                                 frmwebtef.mensagem := 'Consultando HOST - '+ SA_CalcularTempo(SecondsBetween(now,HInicio));
                                 TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                 SA_ConsultarPagamento;  // Fazer uma consulta no pagamento
                                 //---------------------------------------------------
                                 if LResp.status='Disponível' then  // Transação está disponível para os terminais vinculados ao CNPJ/CPF e ao PDV
                                    begin
                                       frmwebtef.mensagem := 'Aguardando pagamento - '+ SA_CalcularTempo(SecondsBetween(now,HInicio));
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    end
                                 else if LResp.status='Em andamento' then  // Transação foi iniciada por um terminal
                                    begin
                                       frmwebtef.mensagem := 'Pagamento em andamento - '+ SA_CalcularTempo(SecondsBetween(now,HInicio));
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    end
                                 else if LResp.status='Cancelada (PDV)' then  // Transação foi cancelada pelo PDV e não será mais exibida aos terminais vinculados
                                    begin
                                       frmwebtef.mensagem := 'Cancelado pelo operador';
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                       sair := true;
                                       while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                          begin
                                             sleep(50);
                                          end;
                                    end
                                 else if LResp.status='Cancelada (Operador)' then  // A transação foi cancelada pelo operador da maquininha após ser iniciada
                                    begin
                                       //---------------------------------------------
                                       frmwebtef.mensagem := 'Cancelado cliente';
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                       sair := true;
                                       while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                          begin
                                             sleep(50);
                                          end;
                                       //---------------------------------------------
                                    end
                                 else if LResp.status='Falha' then  // Houve alguma situação não prevista que impediu que a transação fosse concluída na maquininha
                                    begin
                                       //---------------------------------------------
                                       frmwebtef.mensagem := 'Falha na SMART POS';
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                       sair := true;
                                       while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                          begin
                                             sleep(50);
                                          end;
                                       //---------------------------------------
                                    end
                                 else if LResp.status='Declinada' then  // A transação foi declinada
                                    begin
                                       //---------------------------------------
                                       frmwebtef.mensagem := 'Transação declinada';
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                       sair := true;
                                       while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                          begin
                                             sleep(50);
                                          end;
                                       //---------------------------------------
                                    end
                                 else if LResp.status='Aprovada' then  // A transação foi aprovada.
                                    begin
                                       //---------------------------------------
                                       //  Operação aprovada - Providenciar a impressão dos comprovantes
                                       //---------------------------------------
                                       // Comprovante do cliente
                                       //---------------------------------------
                                       sair     := true;
                                       imprimir := LComprovanteCliente=tpTEFImprimirSempre;
                                       if LComprovanteCliente=tpTEFPerguntar then
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
                                             if imprimir then
                                                SA_Imprimirtexto(LResp.ComprovanteCliente.Text,LImpressora);   // Imprimindo

                                          end;
                                       //---------------------------------------
                                       // Comprovante do cliente
                                       //---------------------------------------
                                       imprimir := LComprovanteLoja=tpTEFImprimirSempre;
                                       if LComprovanteLoja=tpTEFPerguntar then
                                          begin
                                             //---------------------------------
                                             //   Perguntar se quer imprimir
                                             //---------------------------------
                                             opcoesColeta := TStringList.Create;
                                             opcoesColeta.Add('Imprimir');
                                             opcoesColeta.Add('Não Imprimir');
                                             frmwebtef.mensagem := 'Imprimir o comprovante do LOJISTA ?';
                                             frmwebtef.opcoes   := opcoesColeta;
                                             frmwebtef.opcao    := -1;
                                             frmwebtef.tecla    := '';
                                             frmwebtef.Cancelar := false;
                                             //---------------------------------------
                                             TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                             TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                             //---------------------------------------
                                             while (not frmwebtef.Cancelar) do
                                                begin
                                                  if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                     begin
                                                        //----------------------------
                                                        imprimir := true;
                                                        frmwebtef.Cancelar := true;
                                                        //----------------------------
                                                     end
                                                  else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                                     frmwebtef.Cancelar := true;
                                                   //---------------------------------
                                                   sleep(50);
                                                end;
                                             TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                             TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                             //---------------------------------------
                                             frmwebtef.Cancelar := false;
                                             //---------------------------------------
                                             if imprimir then
                                                SA_Imprimirtexto(LResp.ComprovanteLoja.Text,LImpressora);   // Imprimindo
                                             //---------------------------------------
                                          end;
                                       //---------------------------------------------
                                    end;
                                 //---------------------------------------------------
                              end;
                           //---------------------------------------------------------
                        end;
                     //---------------------------------------------------------------
                  end
               else
                  begin
                     //---------------------------------------------------------------
                     //   Fazer rotina de mostrar a tela de erro
                     //---------------------------------------------------------------
                     frmwebtef.mensagem := LResp.mensagemErro;
                     TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                     TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                     while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                        begin
                           sleep(50);
                        end;
                     //---------------------------------------------------------------
                  end;
            end
         else
            begin
               //---------------------------------------------------------------
               // Tratar falha na vinculação com o terminal
               //---------------------------------------------------------------
               frmwebtef.mensagem := 'Falha ao vincular o terminal ao lojista...';
               TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
               TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
               while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                  begin
                     sleep(50);
                  end;
               //---------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
      end);
   //---------------------------------------------------------------------------
   Mythread.onterminate := MythreadEnd;
   Mythread.start;
   //---------------------------------------------------------------------------
end;

procedure TVEROSmartTEF.SA_ProcessarPagamentoPreVenda;
var
   //---------------------------------------------------------------------------
   Mythread : TThread;
   sair     : boolean;
   //---------------------------------------------------------------------------
   HInicio         : TDateTime;
   HultimaLeitura  : TDateTime;  // Para fazer a leitura
   HUltimaContagem : TDateTime;  // Para mostrar na tela o tempo
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpVEROSmartTEF;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LPagamento_Forma;
   frmwebtef.lbvalor.Caption  := transform(LPagamento_Valor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   //---------------------------------------------------------------------------
   Mythread := TThread.CreateAnonymousThread(procedure
      begin
         //---------------------------------------------------------------------
         frmwebtef.mensagem := 'Fazendo vínculo com o PDV SMART...';
         TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
         SA_VincularTerminalPDV;
         if LTerminalVinculado then
            begin
               //---------------------------------------------------------------------
               frmwebtef.mensagem := 'Enviando requisição...';
               TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
               SA_FazerPagamentoPreVenda;
               if LResp.transaction_token<>'' then
                  begin
                     //---------------------------------------------------------------
                     //   Fazer LOOP de consulta
                     //---------------------------------------------------------------
                     HInicio         := now;
                     HultimaLeitura  := now;
                     HUltimaContagem := now;
                     //---------------------------------------------------------------
                     sair     := false;
                     while not sair do
                        begin
                           //---------------------------------------------------------
                           //   Processar o cancelamento pelo operador
                           //---------------------------------------------------------
                           if SecondsBetween(now,HUltimaContagem)>=1 then  // Passou-se dois segundos da ultima consulta
                              begin
                                 HUltimaContagem := now;
                                 frmwebtef.mensagem := 'Aguardando pagamento - '+ SA_CalcularTempo(SecondsBetween(now,HInicio));
                                 TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              end;
                           //------------------------------------------------------
                           if (SecondsBetween(now,HultimaLeitura)>=3) and (not sair) then  // Passou-se dois segundos da ultima consulta
                              begin
                                 //---------------------------------------------------
                                 SA_ConsultarPagamento;  // Fazer uma consulta no pagamento
                                 //---------------------------------------------------
                                 if (LResp.status='Disponível') or (LResp.status='Em andamento') then  // Transação está disponível para os terminais vinculados ao CNPJ/CPF e ao PDV
                                    begin
                                       //---------------------------------------
                                       //   Sair da rotina como pagamento realizado
                                       //---------------------------------------
                                       sair := true;
                                       //---------------------------------------
                                    end
                                 else if LResp.status='Falha' then  // Houve alguma situação não prevista que impediu que a transação fosse concluída na maquininha
                                    begin
                                       //---------------------------------------------
                                       frmwebtef.mensagem := 'Falha na SMART POS';
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                       sair := true;
                                       while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                          begin
                                             sleep(50);
                                          end;
                                       //---------------------------------------------
                                    end
                                 else if LResp.status='Declinada' then  // A transação foi declinada
                                    begin
                                       //---------------------------------------------
                                       frmwebtef.mensagem := 'Transação declinada';
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                       TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                       sair := true;
                                       while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                          begin
                                             sleep(50);
                                          end;
                                       //---------------------------------------------
                                    end;
                                 //---------------------------------------------------
                              end;
                           //---------------------------------------------------------
                        end;
                     //---------------------------------------------------------------
                  end
               else
                  begin
                     //---------------------------------------------------------------
                     //   Fazer rotina de mostrar a tela de erro
                     //---------------------------------------------------------------
                     frmwebtef.mensagem := LResp.mensagemErro;
                     TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                     TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                     while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                        begin
                           sleep(50);
                        end;
                     //---------------------------------------------------------------
                  end;
            end
         else
            begin
               //---------------------------------------------------------------
               // Tratar falha na vinculação com o terminal
               //---------------------------------------------------------------
               frmwebtef.mensagem := 'Falha ao vincular o terminal ao lojista...';
               TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
               TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
               while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                  begin
                     sleep(50);
                  end;
               //---------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
      end);
   //---------------------------------------------------------------------------
   Mythread.onterminate := MythreadEnd;
   Mythread.start;
   //---------------------------------------------------------------------------

end;

procedure TVEROSmartTEF.SA_SalvarLog(titulo, dado: string);
begin
   if LSalvarLog then
      SA_Salva_Arquivo_Incremental(titulo + ' ' +
                                   formatdatetime('dd/mm/yyyy hh:mm:ss',now)+#13+dado,
                                   GetCurrentDir+'\TEF_Log\logVERO'+formatdatetime('yyyymmdd',date)+'.txt');
end;


function TVEROSmartTEF.SA_Tipo_Imagem(nome: string): TVEROTipoImagem;
var
   d   : integer;
   tmp : string;
begin
   //---------------------------------------------------------------------------
   d := length(nome);
   //---------------------------------------------------------------------------
   while d>=1 do
      begin
         //---------------------------------------------------------------------
         if nome[d]='.' then
            Break
         else
            tmp := nome[d] + tmp;
         //---------------------------------------------------------------------
         dec(d);
         //---------------------------------------------------------------------
      end;
   //---------------------------------------------------------------------------
   if uppercase(tmp) = 'BMP' then
      Result := tpImageBMP
   else if uppercase(tmp) = 'JPG' then
      Result := tpImageJPG
   else if uppercase(tmp) = 'JPEG' then
      Result := tpImageJPEG
   else if uppercase(tmp) = 'PNG' then
      Result := tpImagePNG
   else if uppercase(tmp) = 'PDF' then
      Result := tpImagePDF
   else
      Result := tpImageDesconhecido;
   //---------------------------------------------------------------------------
end;

function TVEROSmartTEF.SA_Valor: string;
begin
   Result := trim(FormatFloat('#####0.00',LPagamento_Valor));
   Result := stringreplace(Result,',','.',[rfReplaceAll]);
   Result := stringreplace(Result,'.','',[rfReplaceAll]);
end;


procedure TVEROSmartTEF.SA_VincularTerminalPDV;
var
   LResponse : IResponse;
   JSONStr   : string;
   RespJSON  : TJSONValue;
begin
   //---------------------------------------------------------------------------
   if LNomeMaquina<>'' then
      JSONStr   := '{"pdvToken":"'+LpdvToken+'","merchantDocumentNumber":"'+LmerchantDocumentNumber+'","deviceToken":"'+LdeviceToken+'","group":"'+LNomeMaquina+'"}'
   else
      JSONStr   := '{"pdvToken":"'+LpdvToken+'","merchantDocumentNumber":"'+LmerchantDocumentNumber+'","deviceToken":"'+LdeviceToken+'"}';
   SA_SalvarLog('VINCULAR TERMINAL',JSONStr);
   //---------------------------------------------------------------------------
   LResponse := TRequest.New.BaseURL('https://pdv.verostore.com.br/apiDeviceLink.php')
                      .AddBody(jsonstr)
                      .Accept('application/json')
                      .Post;
   //---------------------------------------------------------------------------
   JSONStr   := '';
   //---------------------------------------------------------------------------
   if LResponse.StatusCode=200 then
      begin
         //---------------------------------------------------------------------
         SA_SalvarLog('RETORNO VINCULAR TERMINAL',LResponse.Content);
         RespJSON           := TJSonObject.ParseJSONValue(TEncoding.UTF8.GetBytes( LResponse.Content  ),0) as TJSONValue;
         LTerminalVinculado := RespJSON.GetValue<string>('result','') = 'Success';
         RespJSON.DisposeOf;
         //---------------------------------------------------------------------
      end
   else
      SA_SalvarLog('ERRO VINCULAR TERMINAL',LResponse.StatusCode.ToString+' '+LResponse.StatusText+' '+LResponse.Content);
   //---------------------------------------------------------------------------
end;

end.
