unit uKSTypes;

interface

uses
   blcksock,
   AcbrDFESSL,
   acbrnfe.classes,
   ACBrPosPrinter,
   ACBrDeviceSerial;

const
  //----------------------------------------------------------------------------
  FormasVSPague     : array of string = ['Perguntar','Credito Perguntar','Credito Vista','Credito Pacelado Perguntar','Credito Parcelado Loja','Credito Parcelado ADM','Debito Perguntar','Debito Vista','Debito Pre','PIX'];
  FormasElgin       : array of string = ['Perguntar','Credito Perguntar','Credito Vista','Credito Pacelado Perguntar','Credito Parcelado Loja','Credito Parcelado ADM','Debito Perguntar','Debito Vista','Debito Pre','PIX'];
  FormasMultiplus   : array of string = ['Perguntar','Credito Perguntar','Credito Vista','Credito Pacelado Perguntar','Credito Parcelado Loja','Credito Parcelado ADM','Debito Perguntar','Debito Vista','Debito Pre','Frota', 'Voucher' , 'PIX', 'PIXMercado Pago','PIX Pic Pay'];
  FormasVero        : array of string = ['Perguntar','Credito Perguntar','Credito Vista','Credito Pacelado Perguntar','Credito Parcelado Loja','Credito Parcelado ADM','Credito Mensal','Debito Perguntar','Debito Vista','Debito BANRI','Debito Banri Pre','Banri Prazo','Banri Minuto','Voucher','PIX','WLLET'];
  FormasEmbedIT     : array of string = ['Perguntar','Credito Perguntar','Credito Vista','Credito Pacelado Perguntar','Credito Parcelado Loja','Credito Parcelado ADM','Debito'];
  //----------------------------------------------------------------------------
  VSPague_Terminador = #13+#10+#09+#09+#13+#10+#09+#09+#09+#13+#10+#09+#09+#13+#10+#09;
type
  //----------------------------------------------------------------------------
  TTMKMPixStatusConsulta = (tPgtoPIXAguardando,tPgtoPIXRealizado,tPgtoPIXInexistente,tPgtoPIXErro,tPgtoPIXCancelado,tPgtoPIXIndefinido,tPgtoPIXExpirado);
  //----------------------------------------------------------------------------
  TTipoTef               = (tpTEFELGIN,tpTEFMultiPlus,tpMKMPix,tpVEROSmartTEF,tpSTONESmartTEF,tpTEFVSPAgue,tpTEFEmbed,tpEmbedSmartTEF,tpEmbedITPIX);
  //----------------------------------------------------------------------------
  TKSEventoFormaPgto     = (tpKSEventoSolvencia,tpKSEventoNenhum,tpKSEventoVSSPague,tpKSEventoMultiplus,tpKSEventoElgin,tpKSEventoMKMPix,tpKSEventoSmartTEFVero,tpKSEventoTEFEmbedIT,tpKSEventoSmartTEFEmbedIT,tpKSEventoPIXEmbed);  // Eventos disparados pela forma de pagamento
  //----------------------------------------------------------------------------
  TtpTEFImpressao        = (tpTEFImprimirSempre, tpTEFPerguntar , tpTEFNaoImprimir);  // Forma de impress�o nos eventos de TEF
  //----------------------------------------------------------------------------
  TtpVSPagueFormaPgto     = (VSPgtoPerguntar, VSPgtoCreditoPerguntar,VSPgtoCreditoVista,VSPgtoCreditoPaceladoPerguntar,VSPgtoCreditoParceladoLoja,VSPgtoCreditoParceladoADM,VSPgtoDebitoPerguntar,VSPgtoDebitoVista,VSPgtoDebitpPre,VSPgtoPIX);
  TtpElginFormaPgto       = (ElginPgtoPerguntar, ElginPgtoCreditoPerguntar,ElginPgtoCreditoVista,ElginPgtoCreditoPaceladoPerguntar,ElginPgtoCreditoParceladoLoja,ElginPgtoCreditoParceladoADM,ElginPgtoDebitoPerguntar,ElginPgtoDebitoVista,ElginPgtoDebitpPre,ElginPgtoPIX);
  TtpMultiplusFormaPgto   = (tpMPlPerguntar,tpMPlcreditoPerguntar,tpMPlCreditoVista, tpMPlCreditoParceladoPerguntar , tpMPlCreditoaParceladoLoja , tpMPlCreditoParceladoADM , tpMPlDebitoPerguntar, tpMPlDebitoVista, tpMPlDebitoPre, tpMPlFrota, tpMPlVoucher , tpMPlPIX, tpMPlPIXMercadoPago,tpMPlPIXPicPay);
  TtpVEROFormaPgto        = (tpVeroPerguntar, tpVEROCreditoPerguntar, tpVEROCreditoVista, tpVEROCreditoParceladoPerguntar,tpVEROCreditoParceladoLoja,tpVEROCreditoParceladoADM,tpVEROCreditoMensal,tpVERODebitoPerguntar,tpVERODebitoVista,tpVERODebitoBANRI,tpVERODebitoBanriPre,tpVEROBanriPrazo,tpVEROBanriMinuto,tpVEROVoucher,tpVEROPIX,tpVEROWLLET);
  TtpEmbedIFormaPgto      = (tpEmbedPgtoPerguntar,tpEmbedPgtoCreditoPerguntar,tpEmbedPgtoCreditoVista,tpEmbedPgtoCreditoParceladoPerguntar,tpEmbedPgtoCreditoParceladoLoja,tpEmbedPgtoCreditoParceladoADM,tpEmbedPgtoDebito,tpEmbedPgtoPIX,tpEmbedPgtoNenhum);
  TEMBEDAmbiente          = (tpAmbHomologacao,tpAmbProducao); // Ambiente de opera��o do PIX
  //----------------------------------------------------------------------------
  TKSConfigFormaTEFVSPague = record
     TipoPgto     : TtpVSPagueFormaPgto;
     QtdeParcelas : integer;
  end;
  //----------------------------------------------------------------------------
  TKSConfigFormaTEFElgin = record
     TipoPgto     : TtpElginFormaPgto;
     QtdeParcelas : integer;
  end;
  //----------------------------------------------------------------------------
  TKSConfigFormaTEFMultiplus = record
     TipoPgto     : TtpMultiplusFormaPgto;
     QtdeParcelas : integer;
  end;
  //----------------------------------------------------------------------------
  TKSConfigFormaSMARTVERO = record
     TipoPgto     : TtpMultiplusFormaPgto;
     QtdeParcelas : integer;
  end;
  //----------------------------------------------------------------------------
  TKSForma = record
     Forma             : string;                     // Descri��o da forma de pagamento
     Atalho            : string;                     // Atalho da forma de pagamento
     Ordem             : integer;                    // Ordem em que a forma ser� apresentada na tela
     Evento            : TKSEventoFormaPgto;         // Evento da forma de pagamento
     ConfigVSPague     : TKSConfigFormaTEFVSPague;   // Configura��es para VSPague
     ConfigElgin       : TKSConfigFormaTEFElgin;     // Configura��o para ELGIN
     ConfigMultiplus   : TKSConfigFormaTEFMultiplus; // Configura��o para Multiplus
     ConfigVero        : TKSConfigFormaSMARTVERO;    // Configura��o para VERO
  end;
  //----------------------------------------------------------------------------
  TKSFormas = array of TKSForma;   // Lista de formas de pagamento
  //----------------------------------------------------------------------------
  TKSConfigImpressora = record    // Configura��es da impressora
     Nome   : string;                 // Porta da impressora que utilizar� o ACBRPOSPrinter
     Modelo : TACBrPosPrinterModelo;  // Modelo de impressora - Modelos ACBRPOSPrinter
     Avanco : integer;                // Quantidade de linhas que a impressora vai avan�ar ap�s a impress�o
  end;
  //----------------------------------------------------------------------------
  TKSConfigConsultaProd = record  // Consulta de produtos
     HostServidor : string;   // Endere�o do servidor de consulta de produtos
     ChaveLicenca : string;   // Chave de licen�a para consultar o servidor
  end;
  //----------------------------------------------------------------------------
  TKSConfigTEFVSPague = record // Configura��es para o TEF VBI VSPague
     Estabelecimento         : string; // C�digo do Estabelecimento - CNPJ
     Loja                    : string; // C�digo da loja - Fornecido pela VBI na solicita��o do TEF
     TerminalPDV             : string; // C�digo do terminal
     ComprovanteCliente      : TtpTEFImpressao; // Impress�o do comprovante do cliente
     ComprovanteLoja         : TtpTEFImpressao; // Impress�o do comprovante do lojista
     ComprovanteSimplificado : boolean;  // Forma da impress�o do comprovante do lojista
     SalvarLog               : boolean;  // Habilitar para salvar o LOG
     //-------------------------------------------------------------------------
     Sequencial              : integer;   // Numero sequencia que deve ser reiniciado a cada dia
     Data                    : TDate;     // Data para marcar a data de controle do sequencial
     //-------------------------------------------------------------------------
  end;
  //----------------------------------------------------------------------------
  TKSConfigTEFElgin = record // Configura��es para o TEF ELGIN HUB
     ComprovanteCliente      : TtpTEFImpressao; // Impress�o do comprovante do cliente
     ComprovanteLoja         : TtpTEFImpressao; // Impress�o do comprovante do lojista
     ComprovanteSimplificado : boolean;  // Forma da impress�o do comprovante do lojista
     SalvarLog               : boolean;  // Habilitar para salvar o LOG
  end;
  //----------------------------------------------------------------------------
  TKSConfigTEFMultiplus = record // Configura��es para o TEF Multiplus
     CNPJ                    : string;  // CNPJ da empresa que vai transacionar o TEF
     Loja                    : string;  // C�digo da loja, fornecida pelo Multiplus quando solicitado a licen�a de TEF
     TerminalPDV             : string;  // N�mero do terminal de PDV
     ComprovanteCliente      : TtpTEFImpressao; // Impress�o do comprovante do cliente
     ComprovanteLoja         : TtpTEFImpressao; // Impress�o do comprovante do lojista
     ComprovanteSimplificado : boolean;  // Forma da impress�o do comprovante do lojista
     SalvarLog               : boolean;  // Habilitar para salvar o LOG
     NSUTef                  : integer;  // Numero sequencial que a cada transa��o dever� ser um novo, incrementado
  end;
  //----------------------------------------------------------------------------
  TKSConfigMKMPix = record // Configura��es para o MKM PIX
     CNPJ               : string;  // CNPJ da empresa que vai transacionar o TEF
     Token              : string;  // C�digo da loja, fornecida pela MKM
     SecretKey          : string;  // SecretKey - Fornecido pela MKM
     ComprovanteCliente : TtpTEFImpressao; // Impress�o do comprovante do cliente
     ComprovanteLoja    : TtpTEFImpressao; // Impress�o do comprovante do lojista
     SalvarLog          : boolean;         // Habilitar para salvar o LOG
  end;
  //----------------------------------------------------------------------------
  TKSConfigSMARTTEFVero = record // Configura��es para o VERO SMART POS
     MerchatDocumentNumber   : string;          // CNPJ da empresa que vai usar o TEF
     PdvToken                : string;          // C�digo de homologa��o da Software House - Fornecido pela VERO/BANRISUL
     DeviceToken             : string;          // N�mero de autoriza��o do POS - Obtida ao instalar o VERO CLIENT na maquininha POS
     ComprovanteCliente      : TtpTEFImpressao; // Impress�o do comprovante do cliente
     ComprovanteLoja         : TtpTEFImpressao; // Impress�o do comprovante do lojista
     ComprovanteSimplificado : boolean;         // Forma da impress�o do comprovante do lojista
     SalvarLog               : boolean;         // Habilitar para salvar o LOG
  end;
  //----------------------------------------------------------------------------
  TKSConfigEmbedIT = record
     CodigoAtivacao     : string;          // gerado pelo time de integra��o
     Username           : string;          // gerado pelo time de integra��o
     password           : string;          // gerado pelo time de integra��o
     DeviceSerial       : string;          // obtido atrav�s da aplica��o PDV Mobi no POS
     CNPJPIX            : string;
     ChavePIX           : string;
     UsernamePIX        : string;
     PasswordPIX        : string;
     AmbientePIX        : TEMBEDAmbiente;  // Ambiente em que a aplica��o vai operar
     ComprovanteCliente : TtpTEFImpressao; // Impress�o do comprovante do cliente
     ComprovanteLoja    : TtpTEFImpressao; // Impress�o do comprovante do lojista
     SalvarLog          : boolean;         // Habilitar para salvar o LOG
  end;
  //----------------------------------------------------------------------------
  TKSConfigPinPad = record
    PINPAD_Porta       : string;             // Porta = COM1, COM2, etc
    PINPAD_Baud        : integer;            // Velocidade da porta do PINPAD
    PINPAD_DataBits    : integer;            // 5,6,7 ou 8 = Normalmente 8
    PINPAD_StopBit     : TACBrSerialStop;    // Stop Bit  = Normalmente 1
    PINPAD_Parity      : TACBrSerialParity;  // Paridade - Normalmente sem PARIDADE
    PINPAD_HandShaking : TACBrHandShake;     // Normalmente NENHUM
    PINPAD_SoftFlow    : boolean;            // Normalmente FALSE
    PINPAD_HardFlow    : boolean;            // Normalmente FALSE
    PINPAD_Imagem      : string;             // Caminho completo para um PNG - 170x73 apr4oximadamente
  end;
  //----------------------------------------------------------------------------
  TKSConfigEmitente = record
     Emit               : TEmit;              // Dados do emitente da NFCe do padr�o ACBR
  end;
  //----------------------------------------------------------------------------
  TKSConfigSistema = record
     Sistema   : string; // Nome do sistema de ERP
     Versao    : string; // Vers�o do sistema de ERP
     EmpresaSH : string; // Nome da empresa SH
  end;
  //----------------------------------------------------------------------------
  TKSConfigMovifluxo = record
     Token       : string;
     IDCliente   : string;
     Homologacao : boolean;
     SalvarLOG   : boolean;
  end;
  //----------------------------------------------------------------------------
  TKSConfig = record // Configura��es gerais para emiss�o da NFCe
     ConfigSistema       : TKSConfigSistema;           // Dados da SH e sistema
     ConfigEmitente      : TEmit;                      // Dados do emitente da NFCe do padr�o ACBR
     ConfigImpressora    : TKSConfigImpressora;        // Configura��es da impressora
     ConfigServidorProd  : TKSConfigConsultaProd;      // Consulta de produtos
     ConfigTEFVSPague    : TKSConfigTEFVSPague;        // Configura��es para o TEF VBI VSPague
     ConfigTEFElgin      : TKSConfigTEFElgin;          // Configura��es para o TEF ELGIN HUB
     ConfigTEFEMultiplus : TKSConfigTEFMultiplus;      // Configura��es para o TEF Multiplus
     ConfigMKMPix        : TKSConfigMKMPix;            // Configura��es para o MKM PIX
     ConfigSMARTTEFVero  : TKSConfigSMARTTEFVero;      // Configura��es para o VERO SMART POS
     ConfigEmbedIT       : TKSConfigEmbedIT;           // Configura��o para EMBED-IT
     ConfigPinPad        : TKSConfigPinPad;            // Configura��o do PINPAD
     ConfigMovifluxo     : TKSConfigMovifluxo;         // Configura��o da MOVIFLUXO - Concilia��es
  end;
  //----------------------------------------------------------------------------
  TRetornoPagamentoTEF = record
     Status           : boolean;  // Para informar que o TEF teve sucesso ou n�o
     NSU              : string;
     Nome_do_Produto  : string;
     cAut             : string;
     rede             : string;
     Bandeira         : string;
     CNPJAdquirente   : string;
     E2E              : string;
     TxID             : string;
     ComprovanteLoja  : String;
     ComprovanteCli   : String;
     ComprovanteRed   : string;
  end;
  //----------------------------------------------------------------------------
  //   Para parametriza��o nos pagamentos
  //----------------------------------------------------------------------------
  TPagamentoFoma = record
     Achou            : boolean;
     Codigo           : integer;
     Forma            : string;
     Evento           : TKSEventoFormaPgto;
     Valor            : real;
     FormaTEF         : integer;
     FormaElgin       : TtpElginFormaPgto;      // Forma de pagamento usado para TEF ELGIN
     FormaVSPague     : TtpVSPagueFormaPgto;    // Forma de pagamento usado para TEF VSPague
     FormaMultiplus   : TtpMultiplusFormaPgto;  // Forma usada para pagamento MultiPlus
     FormaVero        : TtpVEROFormaPgto;       // Forma usada para pagamento VERO
     FormaEmbed       : TtpEmbedIFormaPgto;     // Forma usada para pagamento EMBED-IT
     Parcelas         : integer;                // Quantidade de parcelas
     RetornoTEF       : TRetornoPagamentoTEF;   // Para armazenar o retorno do pagamento;
  end;
  //----------------------------------------------------------------------------
  TPagamentosForma = array of TPagamentoFoma; // Lista de pagamentos
  //----------------------------------------------------------------------------
  TPagamentoVenda = record   // Pagamento
     Bruto               : real;              // Valor bruto da venda
     DescontoConcedido   : real;              // Valor do desconto
     Arredondamento      : real;              // Valor de desconto para arredondamento para ajustar o valor
     Encargo             : real;              // Vlor de Juros e encargos
     Liquido             : real;              // Valor l�quido
     TotalPagamentos     : real;              // Soma dos pagamentos realizados - contidos na lista de pagamentos
     Troco               : real;              // Valor do troco
     Pagamentos          : TPagamentosForma;  // Lista de pagamentos
     Status              : boolean;           // Para informar que a transa��o teve sucesso;
  end;
  //----------------------------------------------------------------------------
  //   Somente para transacionamento ELGIN
  //----------------------------------------------------------------------------
  TPagamentoELGIN = record
     FormaPgtoPAYLOAD : string;   // "A vista", "Parcelado", "" (perguntar), "Pre-datado"
     tpFinPAYLOAD     : string;   // "Estabelecimento", "Administradora", "" (perguntar)
     tipoCartao       : integer;  // 0 - Perguntar / 1 - Credito / 2 - Debito / 3 - Voucher / 4 - Frota / 5 - Private Label
  end;
  //----------------------------------------------------------------------------
  TDadosCancelamento = record
     NSU         : string;
     Data        : TDateTime;
     Valor       : real;
     Documento   : string;
     Evento      : TKSEventoFormaPgto;
     DeviceToken : string;
     PIX         : boolean;  // Utilizado para transacionar cancelamento de PIX pela VSPague
  end;
  //----------------------------------------------------------------------------
  //  Tipo para guardar o cadastro do produto
  //----------------------------------------------------------------------------
  TKSCadastro_prod = record
     barra     : string;                   //  C�digo de Barras
     ref       : string;                   //  Referr�ncia
     descricao : string;                   //  Descri��o do produto
     un        : string;                   //  Unidade de Medida
     marca     : string;                   //  Marca
     ncm       : string;                   //  C�digo NCM
     cest      : string;                   //  C�digo CEST
     preco     : real;                     //  Pre�o do produto
  end;
  //----------------------------------------------------------------------------
  //   Item para montar a NFCe
  //----------------------------------------------------------------------------
  TProdVenda = record
     Prod : TKSCadastro_prod;
     Qtde : real;                     //  Quantidade

  end;
  //----------------------------------------------------------------------------
  TKSStatus = (stKSOk,stKSFalha);
  //----------------------------------------------------------------------------
  TKSRespostaConsultaProd = record
     Status        : TKSStatus;
     Consultou     : boolean;
     Mensagem      : string;
     Produto       : TKSCadastro_prod;
  end;
  //----------------------------------------------------------------------------
  //  Item de concilia��o - Previsao
  //----------------------------------------------------------------------------
  TMoviFluxoItemPrevisao = record
     adquirente              : string;
     codigo_pedido           : string;
     nsu                     : string;
     meio_pagamento          : string;
     produto                 : string;
     estabelecimento         : string;
     data_venda              : TDate;
     data_prevista_pagamento : TDate;
     valor_bruto_transacao   : real;
     valor_bruto_parcela     : real;
     valor_liquido_parcela   : real;
     taxa_adquirencia        : real;
     bandeira                : string;
     parcela                 : integer;
     plano                   : integer;
  end;
  //----------------------------------------------------------------------------
  TMoviFluxoItensPrevisao = array of TMoviFluxoItemPrevisao;  // Extrato do movimento
  //----------------------------------------------------------------------------
  //  Itens do extrato - Liquidacao
  //----------------------------------------------------------------------------
  TMoviFluxoItemLiquidacao = record
     adquirente              : string;
     codigo_pedido           : string;
     nsu                     : string;
     meio_pagamento          : string;
     bandeira                : string;
     produto                 : string;
     estabelecimento         : string;
     data_pagamento          : TDate;
     valor_bruto_transacao   : real;
     valor_bruto_parcela     : real;
     valor_liquido_parcela   : real;
     taxa_administrativa     : real;
     parcela                 : integer;
     plano                   : integer;
     codigo_banco            : string;
     nome_banco              : string;
     agencia                 : string;
     conta_corrente_poupanca : string;
  end;
  //----------------------------------------------------------------------------
  TMoviFluxoItensLiquidacao = array of TMoviFluxoItemLiquidacao;  // Extrato do movimento - Liquidacao
  //----------------------------------------------------------------------------
  TMoviFluxoLoja = record
     user_id      : string;
     nome_empresa : string;
     cnpj         : string;
  end;
  //----------------------------------------------------------------------------
  TMoviFluxoListaLojas = array of TMoviFluxoLoja;
  //----------------------------------------------------------------------------
  TMoviFluxoExtrato = record
     UserID      : string;
     Previsao    : TMoviFluxoItensPrevisao;
     Liquidacoes : TMoviFluxoItensLiquidacao
  end;
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------

implementation

end.
