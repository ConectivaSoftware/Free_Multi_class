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
  TtpTEFImpressao        = (tpTEFImprimirSempre, tpTEFPerguntar , tpTEFNaoImprimir);  // Forma de impressão nos eventos de TEF
  //----------------------------------------------------------------------------
  TtpVSPagueFormaPgto     = (VSPgtoPerguntar, VSPgtoCreditoPerguntar,VSPgtoCreditoVista,VSPgtoCreditoPaceladoPerguntar,VSPgtoCreditoParceladoLoja,VSPgtoCreditoParceladoADM,VSPgtoDebitoPerguntar,VSPgtoDebitoVista,VSPgtoDebitpPre,VSPgtoPIX);
  TtpElginFormaPgto       = (ElginPgtoPerguntar, ElginPgtoCreditoPerguntar,ElginPgtoCreditoVista,ElginPgtoCreditoPaceladoPerguntar,ElginPgtoCreditoParceladoLoja,ElginPgtoCreditoParceladoADM,ElginPgtoDebitoPerguntar,ElginPgtoDebitoVista,ElginPgtoDebitpPre,ElginPgtoPIX);
  TtpMultiplusFormaPgto   = (tpMPlPerguntar,tpMPlcreditoPerguntar,tpMPlCreditoVista, tpMPlCreditoParceladoPerguntar , tpMPlCreditoaParceladoLoja , tpMPlCreditoParceladoADM , tpMPlDebitoPerguntar, tpMPlDebitoVista, tpMPlDebitoPre, tpMPlFrota, tpMPlVoucher , tpMPlPIX, tpMPlPIXMercadoPago,tpMPlPIXPicPay);
  TtpVEROFormaPgto        = (tpVeroPerguntar, tpVEROCreditoPerguntar, tpVEROCreditoVista, tpVEROCreditoParceladoPerguntar,tpVEROCreditoParceladoLoja,tpVEROCreditoParceladoADM,tpVEROCreditoMensal,tpVERODebitoPerguntar,tpVERODebitoVista,tpVERODebitoBANRI,tpVERODebitoBanriPre,tpVEROBanriPrazo,tpVEROBanriMinuto,tpVEROVoucher,tpVEROPIX,tpVEROWLLET);
  TtpEmbedIFormaPgto      = (tpEmbedPgtoPerguntar,tpEmbedPgtoCreditoPerguntar,tpEmbedPgtoCreditoVista,tpEmbedPgtoCreditoParceladoPerguntar,tpEmbedPgtoCreditoParceladoLoja,tpEmbedPgtoCreditoParceladoADM,tpEmbedPgtoDebito,tpEmbedPgtoPIX,tpEmbedPgtoNenhum);
  TEMBEDAmbiente          = (tpAmbHomologacao,tpAmbProducao); // Ambiente de operação do PIX
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
     Forma             : string;                     // Descrição da forma de pagamento
     Atalho            : string;                     // Atalho da forma de pagamento
     Ordem             : integer;                    // Ordem em que a forma será apresentada na tela
     Evento            : TKSEventoFormaPgto;         // Evento da forma de pagamento
     ConfigVSPague     : TKSConfigFormaTEFVSPague;   // Configurações para VSPague
     ConfigElgin       : TKSConfigFormaTEFElgin;     // Configuração para ELGIN
     ConfigMultiplus   : TKSConfigFormaTEFMultiplus; // Configuração para Multiplus
     ConfigVero        : TKSConfigFormaSMARTVERO;    // Configuração para VERO
  end;
  //----------------------------------------------------------------------------
  TKSFormas = array of TKSForma;   // Lista de formas de pagamento
  //----------------------------------------------------------------------------
  TKSConfigImpressora = record    // Configurações da impressora
     Nome   : string;                 // Porta da impressora que utilizará o ACBRPOSPrinter
     Modelo : TACBrPosPrinterModelo;  // Modelo de impressora - Modelos ACBRPOSPrinter
     Avanco : integer;                // Quantidade de linhas que a impressora vai avançar após a impressão
  end;
  //----------------------------------------------------------------------------
  TKSConfigConsultaProd = record  // Consulta de produtos
     HostServidor : string;   // Endereço do servidor de consulta de produtos
     ChaveLicenca : string;   // Chave de licença para consultar o servidor
  end;
  //----------------------------------------------------------------------------
  TKSConfigTEFVSPague = record // Configurações para o TEF VBI VSPague
     Estabelecimento         : string; // Código do Estabelecimento - CNPJ
     Loja                    : string; // Código da loja - Fornecido pela VBI na solicitação do TEF
     TerminalPDV             : string; // Código do terminal
     ComprovanteCliente      : TtpTEFImpressao; // Impressão do comprovante do cliente
     ComprovanteLoja         : TtpTEFImpressao; // Impressão do comprovante do lojista
     ComprovanteSimplificado : boolean;  // Forma da impressão do comprovante do lojista
     SalvarLog               : boolean;  // Habilitar para salvar o LOG
     //-------------------------------------------------------------------------
     Sequencial              : integer;   // Numero sequencia que deve ser reiniciado a cada dia
     Data                    : TDate;     // Data para marcar a data de controle do sequencial
     //-------------------------------------------------------------------------
  end;
  //----------------------------------------------------------------------------
  TKSConfigTEFElgin = record // Configurações para o TEF ELGIN HUB
     ComprovanteCliente      : TtpTEFImpressao; // Impressão do comprovante do cliente
     ComprovanteLoja         : TtpTEFImpressao; // Impressão do comprovante do lojista
     ComprovanteSimplificado : boolean;  // Forma da impressão do comprovante do lojista
     SalvarLog               : boolean;  // Habilitar para salvar o LOG
  end;
  //----------------------------------------------------------------------------
  TKSConfigTEFMultiplus = record // Configurações para o TEF Multiplus
     CNPJ                    : string;  // CNPJ da empresa que vai transacionar o TEF
     Loja                    : string;  // Código da loja, fornecida pelo Multiplus quando solicitado a licença de TEF
     TerminalPDV             : string;  // Número do terminal de PDV
     ComprovanteCliente      : TtpTEFImpressao; // Impressão do comprovante do cliente
     ComprovanteLoja         : TtpTEFImpressao; // Impressão do comprovante do lojista
     ComprovanteSimplificado : boolean;  // Forma da impressão do comprovante do lojista
     SalvarLog               : boolean;  // Habilitar para salvar o LOG
     NSUTef                  : integer;  // Numero sequencial que a cada transação deverá ser um novo, incrementado
  end;
  //----------------------------------------------------------------------------
  TKSConfigMKMPix = record // Configurações para o MKM PIX
     CNPJ               : string;  // CNPJ da empresa que vai transacionar o TEF
     Token              : string;  // Código da loja, fornecida pela MKM
     SecretKey          : string;  // SecretKey - Fornecido pela MKM
     ComprovanteCliente : TtpTEFImpressao; // Impressão do comprovante do cliente
     ComprovanteLoja    : TtpTEFImpressao; // Impressão do comprovante do lojista
     SalvarLog          : boolean;         // Habilitar para salvar o LOG
  end;
  //----------------------------------------------------------------------------
  TKSConfigSMARTTEFVero = record // Configurações para o VERO SMART POS
     MerchatDocumentNumber   : string;          // CNPJ da empresa que vai usar o TEF
     PdvToken                : string;          // Código de homologação da Software House - Fornecido pela VERO/BANRISUL
     DeviceToken             : string;          // Número de autorização do POS - Obtida ao instalar o VERO CLIENT na maquininha POS
     ComprovanteCliente      : TtpTEFImpressao; // Impressão do comprovante do cliente
     ComprovanteLoja         : TtpTEFImpressao; // Impressão do comprovante do lojista
     ComprovanteSimplificado : boolean;         // Forma da impressão do comprovante do lojista
     SalvarLog               : boolean;         // Habilitar para salvar o LOG
  end;
  //----------------------------------------------------------------------------
  TKSConfigEmbedIT = record
     CodigoAtivacao     : string;          // gerado pelo time de integração
     Username           : string;          // gerado pelo time de integração
     password           : string;          // gerado pelo time de integração
     DeviceSerial       : string;          // obtido através da aplicação PDV Mobi no POS
     CNPJPIX            : string;
     ChavePIX           : string;
     UsernamePIX        : string;
     PasswordPIX        : string;
     AmbientePIX        : TEMBEDAmbiente;  // Ambiente em que a aplicação vai operar
     ComprovanteCliente : TtpTEFImpressao; // Impressão do comprovante do cliente
     ComprovanteLoja    : TtpTEFImpressao; // Impressão do comprovante do lojista
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
     Emit               : TEmit;              // Dados do emitente da NFCe do padrão ACBR
  end;
  //----------------------------------------------------------------------------
  TKSConfigSistema = record
     Sistema   : string; // Nome do sistema de ERP
     Versao    : string; // Versão do sistema de ERP
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
  TKSConfig = record // Configurações gerais para emissão da NFCe
     ConfigSistema       : TKSConfigSistema;           // Dados da SH e sistema
     ConfigEmitente      : TEmit;                      // Dados do emitente da NFCe do padrão ACBR
     ConfigImpressora    : TKSConfigImpressora;        // Configurações da impressora
     ConfigServidorProd  : TKSConfigConsultaProd;      // Consulta de produtos
     ConfigTEFVSPague    : TKSConfigTEFVSPague;        // Configurações para o TEF VBI VSPague
     ConfigTEFElgin      : TKSConfigTEFElgin;          // Configurações para o TEF ELGIN HUB
     ConfigTEFEMultiplus : TKSConfigTEFMultiplus;      // Configurações para o TEF Multiplus
     ConfigMKMPix        : TKSConfigMKMPix;            // Configurações para o MKM PIX
     ConfigSMARTTEFVero  : TKSConfigSMARTTEFVero;      // Configurações para o VERO SMART POS
     ConfigEmbedIT       : TKSConfigEmbedIT;           // Configuração para EMBED-IT
     ConfigPinPad        : TKSConfigPinPad;            // Configuração do PINPAD
     ConfigMovifluxo     : TKSConfigMovifluxo;         // Configuração da MOVIFLUXO - Conciliações
  end;
  //----------------------------------------------------------------------------
  TRetornoPagamentoTEF = record
     Status           : boolean;  // Para informar que o TEF teve sucesso ou não
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
  //   Para parametrização nos pagamentos
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
     Liquido             : real;              // Valor líquido
     TotalPagamentos     : real;              // Soma dos pagamentos realizados - contidos na lista de pagamentos
     Troco               : real;              // Valor do troco
     Pagamentos          : TPagamentosForma;  // Lista de pagamentos
     Status              : boolean;           // Para informar que a transação teve sucesso;
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
     barra     : string;                   //  Código de Barras
     ref       : string;                   //  Referrência
     descricao : string;                   //  Descrição do produto
     un        : string;                   //  Unidade de Medida
     marca     : string;                   //  Marca
     ncm       : string;                   //  Código NCM
     cest      : string;                   //  Código CEST
     preco     : real;                     //  Preço do produto
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
  //  Item de conciliação - Previsao
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
