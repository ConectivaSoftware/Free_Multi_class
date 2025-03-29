unit uconfig;

interface

uses
  uPinpad,
  uMulticlassFuncoes,
  uMoviFluxo,
  blcksock,
  uKSTypes,
  midaslib,
  System.IniFiles,
  AcbrPosPrinter,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.UITypes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Vcl.StdCtrls,
  Vcl.Mask,
  Vcl.ComCtrls,
  Vcl.Imaging.jpeg,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  Vcl.Grids,
  Vcl.DBGrids,
  Datasnap.DBClient,
  pcnConversaoNFe,
  ACBrBase,
  ACBrDeviceSerial,
  ACBrAbecsPinPad,
  Vcl.Imaging.pngimage,
  Vcl.ExtDlgs;

type

  //----------------------------------------------------------------------------
  Tfrmconfig = class(TForm)
    pntitulo: TPanel;
    pnrodape: TPanel;
    btsalvar: TSpeedButton;
    btcancelar: TSpeedButton;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    edtporta_impressora_ESC_POS: TMaskEdit;
    Label53: TLabel;
    btbuscaportawindows: TSpeedButton;
    Label51: TLabel;
    cbimpressora_ESC_POS: TComboBox;
    Label52: TLabel;
    edtavanco: TMaskEdit;
    cblistaimpressoras: TComboBox;
    Image3: TImage;
    Label362: TLabel;
    edtVBIestabelecimento: TMaskEdit;
    Label360: TLabel;
    edtVBILoja: TMaskEdit;
    Label359: TLabel;
    edtVBIterminal: TMaskEdit;
    Label361: TLabel;
    cbVBIComprovanteCliente: TComboBox;
    Label358: TLabel;
    Label357: TLabel;
    cbVBIComprovanteLoja: TComboBox;
    cbVBIComprovanteSimplificado: TCheckBox;
    cbVBISalvarLog: TCheckBox;
    TabSheet2: TTabSheet;
    Label3: TLabel;
    edtchave: TMaskEdit;
    TabSheet5: TTabSheet;
    Image1: TImage;
    Label309: TLabel;
    cbELGIN_impressao_cliente: TComboBox;
    Label310: TLabel;
    cbELGIN_impressao_loja: TComboBox;
    cbELGINcomprovantesimplificado: TCheckBox;
    cbELGIN_SalvarLOG: TCheckBox;
    TabSheet6: TTabSheet;
    Image7: TImage;
    Label307: TLabel;
    edtcnpjMultiPlus: TMaskEdit;
    Label308: TLabel;
    edtLojaMultiPlus: TMaskEdit;
    Label341: TLabel;
    Label340: TLabel;
    edtPDVMultiPlus: TMaskEdit;
    Label305: TLabel;
    cbcomprovanteclientemultiplus: TComboBox;
    Label306: TLabel;
    cbcomprovantelojamultiplus: TComboBox;
    cbcomprovantesimplificadomultiplus: TCheckBox;
    cbsalvarlogmultiplus: TCheckBox;
    TabSheet7: TTabSheet;
    Image16: TImage;
    Label377: TLabel;
    edtmkmpixCNPJ: TMaskEdit;
    Label378: TLabel;
    cbmkmpixComprovanteCliente: TComboBox;
    Label379: TLabel;
    cbmkmpixComprovanteLoja: TComboBox;
    cbmkmpixsalvarLog: TCheckBox;
    TabSheet8: TTabSheet;
    Image18: TImage;
    Label385: TLabel;
    edtVERO_CNPJ: TMaskEdit;
    Label389: TLabel;
    Label391: TLabel;
    edtVEROPDV_DeviceToken: TMaskEdit;
    cbVEROComprovanteCliente: TComboBox;
    Label387: TLabel;
    Label388: TLabel;
    cbVEROComprovanteLoja: TComboBox;
    cbVEROComprovanteSimplificado: TCheckBox;
    cbVEROSalvarLOG: TCheckBox;
    Label1: TLabel;
    edtVEROPdvToken: TMaskEdit;
    edthostprod: TMaskEdit;
    Label2: TLabel;
    TabSheet10: TTabSheet;
    pgcformas: TPageControl;
    TabSheet11: TTabSheet;
    TabSheet12: TTabSheet;
    DBGridformas: TDBGrid;
    btnovaforma: TSpeedButton;
    btalterarforma: TSpeedButton;
    btapagarforma: TSpeedButton;
    edtforma: TMaskEdit;
    Label203: TLabel;
    Label204: TLabel;
    edtatalho_forma: TMaskEdit;
    edtordem: TMaskEdit;
    Label225: TLabel;
    rgevento: TRadioGroup;
    btsalvaforma: TSpeedButton;
    btvoltaforma: TSpeedButton;
    fundolistaforma: TShape;
    fundoedicaoforma: TShape;
    fundoimpressora: TShape;
    fundoconsultaprod: TShape;
    fundovbi: TShape;
    fundoelgin: TShape;
    fundomultiplus: TShape;
    fundomkm: TShape;
    fundovero: TShape;
    pgc: TPageControl;
    Label4: TLabel;
    Label5: TLabel;
    Shape1: TShape;
    Label6: TLabel;
    Shape2: TShape;
    Label7: TLabel;
    Label8: TLabel;
    fundo: TShape;
    pntefconfig: TPanel;
    Label10: TLabel;
    cbformapgto: TComboBox;
    Label9: TLabel;
    edtqtdeparcelas: TMaskEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    TabSheet4: TTabSheet;
    Image6: TImage;
    Label286: TLabel;
    edtembedCodigoAtivacao: TMaskEdit;
    Label15: TLabel;
    edtembedLogin: TMaskEdit;
    Label16: TLabel;
    Label321: TLabel;
    edtembedSenha: TMaskEdit;
    btembedversenha: TSpeedButton;
    Label300: TLabel;
    edtembedSerial: TMaskEdit;
    Label317: TLabel;
    Label301: TLabel;
    cbEmbedComprovanteCliente: TComboBox;
    Label314: TLabel;
    cbEmbedComprovanteLoja: TComboBox;
    cbEmbedSalvarLog: TCheckBox;
    cbpinpad_porta: TComboBox;
    Label330: TLabel;
    Label331: TLabel;
    cbpinpad_Baud: TComboBox;
    Label333: TLabel;
    cbpinpad_DataBits: TComboBox;
    Label332: TLabel;
    cbpinpad_Parity: TComboBox;
    Label335: TLabel;
    cbpinpad_StopBit: TComboBox;
    Label334: TLabel;
    cbpinpad_HandShacking: TComboBox;
    cbpinpad_HardFlow: TCheckBox;
    cbpinpad_SoftFlow: TCheckBox;
    Shape3: TShape;
    Shape4: TShape;
    Label18: TLabel;
    Shape5: TShape;
    Label19: TLabel;
    Shape6: TShape;
    imagem_pinpad: TImage;
    btbuscaimagempinpad: TSpeedButton;
    Shape7: TShape;
    Label20: TLabel;
    fundoembed: TShape;
    Label21: TLabel;
    edtarquivologopinpad: TMaskEdit;
    selecionar_imagem: TOpenPictureDialog;
    btdetectarpinpad: TSpeedButton;
    Shape8: TShape;
    Label22: TLabel;
    Shape9: TShape;
    Label23: TLabel;
    edtfantasia: TMaskEdit;
    Label24: TLabel;
    edtrazao: TMaskEdit;
    Label25: TLabel;
    edtcnpj: TMaskEdit;
    Label26: TLabel;
    edtie: TMaskEdit;
    edtuf: TMaskEdit;
    Label27: TLabel;
    btbuscacidade: TSpeedButton;
    edtcidade: TMaskEdit;
    Label28: TLabel;
    edtbairro: TMaskEdit;
    Label29: TLabel;
    edtcomplemento: TMaskEdit;
    Label30: TLabel;
    edtnro: TMaskEdit;
    Label31: TLabel;
    edtendereco: TMaskEdit;
    Label32: TLabel;
    Label33: TLabel;
    edtcep: TMaskEdit;
    Label34: TLabel;
    edtfone: TMaskEdit;
    Shape10: TShape;
    Label35: TLabel;
    Shape11: TShape;
    selecionar_arquivo: TOpenDialog;
    Label226: TLabel;
    edtarquivo_imagem_forma: TMaskEdit;
    btbuscaimagemforma: TSpeedButton;
    Imagem_botao_forma: TImage;
    imagem_forma_vazia: TImage;
    btgerarToken: TSpeedButton;
    Shape28: TShape;
    Shape29: TShape;
    Label44: TLabel;
    Shape13: TShape;
    Label17: TLabel;
    Shape30: TShape;
    Shape31: TShape;
    Label68: TLabel;
    Shape32: TShape;
    Label73: TLabel;
    Shape12: TShape;
    Label36: TLabel;
    Shape14: TShape;
    Label37: TLabel;
    edtembedUserNamePIX: TMaskEdit;
    Label38: TLabel;
    edtembedPasswordPIX: TMaskEdit;
    btembedPasswordPIX: TSpeedButton;
    Label39: TLabel;
    edtembedCNPJPIX: TMaskEdit;
    Label40: TLabel;
    edtembedChavePIX: TMaskEdit;
    Label41: TLabel;
    cbembedHMLPIX: TCheckBox;
    TabSheet9: TTabSheet;
    fundomovifluxo: TShape;
    Image2: TImage;
    Label42: TLabel;
    edtMOVIFLUXOToken: TMaskEdit;
    Label43: TLabel;
    edtMOVIFLUXOIDCliente: TMaskEdit;
    btMOVIFLUXOBuscarCliente: TSpeedButton;
    cbMOVIFLUXOhml: TCheckBox;
    cbMOVIFLUXOSalvarLOG: TCheckBox;
    cbClientesMovifluxo: TComboBox;
    Label45: TLabel;
    tblformas: TClientDataSet;
    tblformascodigo: TAutoIncField;
    tblformasforma: TStringField;
    tblformasatalho: TStringField;
    tblformasordem: TIntegerField;
    tblformasevento: TIntegerField;
    tblformasDescEvento: TStringField;
    tblformasTipoPgto: TIntegerField;
    tblformasQtdeParcelas: TIntegerField;
    tblformasAruivoImagem: TStringField;
    dtsformas: TDataSource;
    tblpgto: TClientDataSet;
    tblpgtocodigo: TIntegerField;
    StringField1: TStringField;
    IntegerField2: TIntegerField;
    StringField3: TStringField;
    tblpgtoValor: TFloatField;
    tblpgtoFormaTEF: TIntegerField;
    tblpgtoQtdeParcelas: TIntegerField;
    dtspgto: TDataSource;
    procedure FormActivate(Sender: TObject);
    procedure btcancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btbuscaportawindowsClick(Sender: TObject);
    procedure cblistaimpressorasEnter(Sender: TObject);
    procedure cblistaimpressorasSelect(Sender: TObject);
    procedure cblistaimpressorasExit(Sender: TObject);
    procedure btsalvarClick(Sender: TObject);
    procedure DBGridformasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btapagarformaClick(Sender: TObject);
    procedure btnovaformaClick(Sender: TObject);
    procedure btalterarformaClick(Sender: TObject);
    procedure btvoltaformaClick(Sender: TObject);
    procedure TabSheet12Show(Sender: TObject);
    procedure DBGridformasEnter(Sender: TObject);
    procedure DBGridformasExit(Sender: TObject);
    procedure btsalvaformaClick(Sender: TObject);
    procedure edtordemKeyPress(Sender: TObject; var Key: Char);
    procedure edtordemKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TabSheet10Show(Sender: TObject);
    procedure TabSheet11Show(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure TabSheet5Show(Sender: TObject);
    procedure TabSheet6Show(Sender: TObject);
    procedure TabSheet7Show(Sender: TObject);
    procedure TabSheet8Show(Sender: TObject);
    procedure ClientDataSet1DescEventoGetText(Sender: TField; var Text: string;DisplayText: Boolean);
    procedure rgeventoClick(Sender: TObject);
    procedure btembedversenhaClick(Sender: TObject);
    procedure TabSheet4Show(Sender: TObject);
    procedure btbuscaimagempinpadClick(Sender: TObject);
    procedure edtporta_impressora_ESC_POSKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btdetectarpinpadClick(Sender: TObject);
    procedure DBGridformasDblClick(Sender: TObject);
    procedure btbuscaimagemformaClick(Sender: TObject);
    procedure btgerarTokenClick(Sender: TObject);
    procedure btembedPasswordPIXClick(Sender: TObject);
    procedure TabSheet9Show(Sender: TObject);
    procedure btMOVIFLUXOBuscarClienteClick(Sender: TObject);
    procedure cbClientesMovifluxoExit(Sender: TObject);
    procedure cbClientesMovifluxoSelect(Sender: TObject);
    procedure tblformasDescEventoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure tblpgtoValorGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
  public
    NovaForma           : boolean;    // Para definir que o operador clicou no botão de novo ou alterar forma
    Config              : TKSConfig;  // Variável que armazena em memória as configurações
    AcessouForm         : boolean;    // Para informar que a inicialização do Form já aconteceu
    MoviFluxoListaLojas : TMoviFluxoListaLojas; // Para fazer a consulta de clientes
  end;

var
  frmconfig: Tfrmconfig;

implementation

{$R *.dfm}

//------------------------------------------------------------------------------
//   Converter Array para Stringlist
//------------------------------------------------------------------------------
function SA_ArraytoStringList(StrArray:array of string):TStringList;
var
   d : integer;
begin
   Result := TStringList.Create;
   try
      for d := 1 to length(StrArray) do
         Result.Add(StrArray[d-1]);
   except

   end;
end;
//------------------------------------------------------------------------------
//   Retornar a lista de formas de pagamento da operadora de TEF
//------------------------------------------------------------------------------
function SA_ListaFormasTEF(Operadora : TTipoTef):TStringList;
begin
   Result := TStringList.Create;
   //---------------------------------------------------------------------------
   case operadora of
     tpTEFELGIN            : Result := SA_ArraytoStringList(FormasElgin);
     tpTEFMultiPlus        : Result := SA_ArraytoStringList(FormasMultiplus);
     tpVEROSmartTEF        : Result := SA_ArraytoStringList(FormasVero);
     tpTEFVSPAgue          : Result := SA_ArraytoStringList(FormasVSPague);
     tpTEFEmbed            : Result := SA_ArraytoStringList(FormasEmbedIT);
     tpEmbedSmartTEF       : Result := SA_ArraytoStringList(FormasEmbedIT);
   end;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
//  Carregar da tela para a variável Config
//------------------------------------------------------------------------------
function SA_CaregarEdicaoParaConfigVAR:TKSConfig;
begin
//   Result.ConfigEmitente := TEmit.create;
   //---------------------------------------------------------------------------
   //   Carregar as configurações da impressora
   //---------------------------------------------------------------------------
   Result.ConfigImpressora.Nome   := frmconfig.edtporta_impressora_ESC_POS.Text;                      // Nome da impressora selecionada para impressão
   Result.ConfigImpressora.Modelo := TACBrPosPrinterModelo(frmconfig.cbimpressora_ESC_POS.ItemIndex); // Modelo de impressora ACBRPOSPrinter
   Result.ConfigImpressora.Avanco := strtointdef(frmconfig.edtavanco.Text,4);                         // Avanço de linhas ao final de documentos - Imaginando que tenha guilhotina, usar 3
   //---------------------------------------------------------------------------
   //   Carregar as configurações da consulta de produtos
   //---------------------------------------------------------------------------
   Result.ConfigServidorProd.HostServidor := frmconfig.edthostprod.Text; // Host aonde a consulta será feita = http://www.mkmservicos.com.br
   Result.ConfigServidorProd.ChaveLicenca := frmconfig.edtchave.Text;    // Cheve de autorização para consultar produtos
   //---------------------------------------------------------------------------
   // Configurações para o TEF VBI VSPague
   //---------------------------------------------------------------------------
   Result.ConfigTEFVSPague.Estabelecimento         := frmconfig.edtVBIestabelecimento.Text;                          // Código do Estabelecimento - CNPJ
   Result.ConfigTEFVSPague.Loja                    := frmconfig.edtVBILoja.Text;                                     // Código da loja - Fornecido pela VBI na solicitação do TEF
   Result.ConfigTEFVSPague.TerminalPDV             := frmconfig.edtVBIterminal.Text;                                 // Código do terminal
   Result.ConfigTEFVSPague.ComprovanteCliente      := TtpTEFImpressao(frmconfig.cbVBIComprovanteCliente.ItemIndex);  // Impressão do comprovante do cliente
   Result.ConfigTEFVSPague.ComprovanteLoja         := TtpTEFImpressao(frmconfig.cbVBIComprovanteLoja.ItemIndex);     // Impressão do comprovante do lojista
   Result.ConfigTEFVSPague.ComprovanteSimplificado := frmconfig.cbVBIComprovanteSimplificado.Checked;                // Forma da impressão do comprovante do lojista
   Result.ConfigTEFVSPague.SalvarLog               := frmconfig.cbVBISalvarLog.Checked;                              // Habilitar para salvar o LOG
   //---------------------------------------------------------------------------
   // Configurações para o TEF ELGIN HUB
   //---------------------------------------------------------------------------
   Result.ConfigTEFElgin.ComprovanteCliente      := TtpTEFImpressao(frmconfig.cbELGIN_impressao_cliente.ItemIndex); // Impressão do comprovante do cliente
   Result.ConfigTEFElgin.ComprovanteLoja         := TtpTEFImpressao(frmconfig.cbELGIN_impressao_loja.ItemIndex);    // Impressão do comprovante do lojista
   Result.ConfigTEFElgin.ComprovanteSimplificado := frmconfig.cbELGINcomprovantesimplificado.Checked;               // Forma da impressão do comprovante do lojista
   Result.ConfigTEFElgin.SalvarLog               := frmconfig.cbELGIN_SalvarLOG.Checked;                            // Habilitar para salvar o LOG
   //---------------------------------------------------------------------------
   // Configurações para o TEF Multiplus
   //---------------------------------------------------------------------------
   Result.ConfigTEFEMultiplus.CNPJ                    := frmconfig.edtcnpjMultiPlus.Text;                                     // CNPJ da empresa que vai transacionar o TEF
   Result.ConfigTEFEMultiplus.Loja                    := frmconfig.edtLojaMultiPlus.Text;                                     // Código da loja fornecida pelo Multiplus
   Result.ConfigTEFEMultiplus.TerminalPDV             := frmconfig.edtPDVMultiPlus.Text;                                      // Número do terminal de PDV
   Result.ConfigTEFEMultiplus.ComprovanteCliente      := TtpTEFImpressao(frmconfig.cbcomprovanteclientemultiplus.ItemIndex);  // Impressão do comprovante do cliente
   Result.ConfigTEFEMultiplus.ComprovanteLoja         := TtpTEFImpressao(frmconfig.cbcomprovantelojamultiplus.ItemIndex);     // Impressão do comprovante do lojista
   Result.ConfigTEFEMultiplus.ComprovanteSimplificado := frmconfig.cbcomprovantesimplificadomultiplus.Checked;                // Forma da impressão do comprovante do lojista
   Result.ConfigTEFEMultiplus.SalvarLog               := frmconfig.cbsalvarlogmultiplus.Checked;                              // Habilitar para salvar o LOG
   //---------------------------------------------------------------------------
   // Configurações para o MKM PIX
   //---------------------------------------------------------------------------
   Result.ConfigMKMPix.CNPJ               := frmconfig.edtmkmpixCNPJ.Text;                                     // CNPJ da empresa que vai transacionar o TEF wIni.WriteString('TKSConfigMKMPix','Token','Codigo_token');               //: string;  // Código da loja, fornecida pela MKM
   Result.ConfigMKMPix.ComprovanteCliente := TtpTEFImpressao(frmconfig.cbmkmpixComprovanteCliente.ItemIndex);  // Impressão do comprovante do cliente
   Result.ConfigMKMPix.ComprovanteLoja    := TtpTEFImpressao(frmconfig.cbmkmpixComprovanteLoja.ItemIndex);     // Impressão do comprovante do lojista
   Result.ConfigMKMPix.SalvarLog          := frmconfig.cbmkmpixsalvarLog.Checked;                              // Habilitar para salvar o LOG
   //---------------------------------------------------------------------------
   //   Configuração com o SMART POS VERO
   //---------------------------------------------------------------------------
   Result.ConfigSMARTTEFVero.MerchatDocumentNumber   := frmconfig.edtVERO_CNPJ.Text;                                   // CNPJ da empresa que vai usar o TEF
   Result.ConfigSMARTTEFVero.PdvToken                := frmconfig.edtVEROPdvToken.Text;                                // Código de homologação da Software House - Fornecido pela VERO/BANRISUL
   Result.ConfigSMARTTEFVero.DeviceToken             := frmconfig.edtVEROPDV_DeviceToken.Text;                         // Número de autorização do POS - Obtida ao instalar o VERO CLIENT na maquininha POS
   Result.ConfigSMARTTEFVero.ComprovanteCliente      := TtpTEFImpressao(frmconfig.cbVEROComprovanteCliente.ItemIndex); // Impressão do comprovante do cliente
   Result.ConfigSMARTTEFVero.ComprovanteLoja         := TtpTEFImpressao(frmconfig.cbVEROComprovanteLoja.ItemIndex);    // Impressão do comprovante do lojista
   Result.ConfigSMARTTEFVero.ComprovanteSimplificado := frmconfig.cbVEROComprovanteSimplificado.Checked;               // Forma da impressão do comprovante do lojista
   Result.ConfigSMARTTEFVero.SalvarLog               := frmconfig.cbVEROSalvarLOG.Checked;                             // Habilitar para salvar o LOG
   //---------------------------------------------------------------------------
   //   Configurações do Mercado Pago
   //---------------------------------------------------------------------------
   Result.ConfigEmbedIT.CodigoAtivacao     := frmconfig.edtembedCodigoAtivacao.Text;                          // gerado pelo time de integração
   Result.ConfigEmbedIT.Username           := frmconfig.edtembedLogin.Text;                                   // gerado pelo time de integração
   Result.ConfigEmbedIT.password           := frmconfig.edtembedSenha.Text;                                   // gerado pelo time de integração
   Result.ConfigEmbedIT.DeviceSerial       := frmconfig.edtembedSerial.Text;                                  // obtido através da aplicação PDV Mobi no POS
   Result.ConfigEmbedIT.CNPJPIX            := frmconfig.edtembedCNPJPIX.Text;                                 // CNPJ do cliente
   Result.ConfigEmbedIT.ChavePIX           := frmconfig.edtembedChavePIX.Text;                                // Chave PIX do cliente
   Result.ConfigEmbedIT.UsernamePIX        := frmconfig.edtembedUserNamePIX.Text;                             // UserName para autenticação TOKEN BEARER
   Result.ConfigEmbedIT.PasswordPIX        := frmconfig.edtembedPasswordPIX.Text;                             // Senha para autenticação TOKEN BEARER
   Result.ConfigEmbedIT.AmbientePIX        := tpAmbProducao;                                                  // Operar em homologaçã ou produção, default produção
   if frmconfig.cbembedHMLPIX.Checked then
      Result.ConfigEmbedIT.AmbientePIX     := tpAmbHomologacao;
   Result.ConfigEmbedIT.ComprovanteCliente := TtpTEFImpressao(frmconfig.cbEmbedComprovanteCliente.ItemIndex); // Impressão do comprovante do cliente
   Result.ConfigEmbedIT.ComprovanteLoja    := TtpTEFImpressao(frmconfig.cbEmbedComprovanteLoja.ItemIndex);    // Impressão do comprovante do lojista
   Result.ConfigEmbedIT.SalvarLog          := frmconfig.cbEmbedSalvarLog.Checked;                             // Habilitar para salvar o LOG
   //---------------------------------------------------------------------------
   Result.ConfigPinPad.PINPAD_Porta       := frmconfig.cbpinpad_porta.Text;
   Result.ConfigPinPad.PINPAD_Baud        := strtoint(frmconfig.cbpinpad_Baud.Items[frmconfig.cbpinpad_Baud.ItemIndex]);
   Result.ConfigPinPad.PINPAD_DataBits    := strtoint(frmconfig.cbpinpad_DataBits.Items[frmconfig.cbpinpad_DataBits.ItemIndex]);
   Result.ConfigPinPad.PINPAD_StopBit     := TACBrSerialStop(frmconfig.cbpinpad_StopBit.ItemIndex);
   Result.ConfigPinPad.PINPAD_Parity      := TACBrSerialParity(frmconfig.cbpinpad_Parity.ItemIndex);
   Result.ConfigPinPad.PINPAD_HandShaking := TACBrHandShake(frmconfig.cbpinpad_HandShacking.ItemIndex);
   Result.ConfigPinPad.PINPAD_SoftFlow    := frmconfig.cbpinpad_SoftFlow.Checked;
   Result.ConfigPinPad.PINPAD_HardFlow    := frmconfig.cbpinpad_HardFlow.Checked;
   Result.ConfigPinPad.PINPAD_Imagem      := frmconfig.edtarquivologopinpad.Text;
   //---------------------------------------------------------------------------
   Result.ConfigEmitente.CNPJCPF                   := frmconfig.edtcnpj.Text;
   Result.ConfigEmitente.xNome                     := frmconfig.edtrazao.Text;
   Result.ConfigEmitente.xFant                     := frmconfig.edtfantasia.Text;
   Result.ConfigEmitente.EnderEmit.xLgr            := frmconfig.edtendereco.Text;
   Result.ConfigEmitente.EnderEmit.nro             := frmconfig.edtnro.Text;
   Result.ConfigEmitente.EnderEmit.xCpl            := frmconfig.edtcomplemento.Text;
   Result.ConfigEmitente.EnderEmit.xMun            := frmconfig.edtcidade.Text;
   Result.ConfigEmitente.EnderEmit.UF              := frmconfig.edtuf.Text;
   Result.ConfigEmitente.EnderEmit.CEP             := strtointdef(frmconfig.edtcep.Text,0);
   Result.ConfigEmitente.EnderEmit.fone            := frmconfig.edtfone.Text;
   Result.ConfigEmitente.IE                        := frmconfig.edtie.Text;
   //---------------------------------------------------------------------------
   Result.ConfigMovifluxo.Token                    := frmconfig.edtMOVIFLUXOToken.Text;
   Result.ConfigMovifluxo.IDCliente                := frmconfig.edtMOVIFLUXOIDCliente.Text;
   Result.ConfigMovifluxo.Homologacao              := frmconfig.cbMOVIFLUXOhml.Checked;
   Result.ConfigMovifluxo.SalvarLOG                := frmconfig.cbMOVIFLUXOSalvarLOG.Checked;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
//   Carregar as configurações para a edição
//------------------------------------------------------------------------------
procedure SA_CarregarConfigParaEdicao(config:TKSConfig);
var
   d     : integer;
begin
   //---------------------------------------------------------------------------
   //   Configuração da impressora
   //---------------------------------------------------------------------------
   frmconfig.edtporta_impressora_ESC_POS.Text := config.ConfigImpressora.Nome;
   frmconfig.cbimpressora_ESC_POS.ItemIndex   := ord(config.ConfigImpressora.Modelo);
   frmconfig.edtavanco.Text                   := config.ConfigImpressora.Avanco.ToString;
   //---------------------------------------------------------------------------
   //   Configuração do servidor de consulta
   //---------------------------------------------------------------------------
   frmconfig.edthostprod.Text := config.ConfigServidorProd.HostServidor;
   frmconfig.edtchave.Text    := config.ConfigServidorProd.ChaveLicenca;
   //---------------------------------------------------------------------------
   //  Configurações do TEF VSPague
   //---------------------------------------------------------------------------
   frmconfig.edtVBIestabelecimento.Text           := config.ConfigTEFVSPague.Estabelecimento;
   frmconfig.edtVBILoja.Text                      := config.ConfigTEFVSPague.Loja;
   frmconfig.edtVBIterminal.Text                  := config.ConfigTEFVSPague.TerminalPDV;
   frmconfig.cbVBIComprovanteCliente.ItemIndex    := ord(config.ConfigTEFVSPague.ComprovanteCliente);
   frmconfig.cbVBIComprovanteLoja.ItemIndex       := ord(config.ConfigTEFVSPague.ComprovanteLoja);
   frmconfig.cbVBIComprovanteSimplificado.Checked := config.ConfigTEFVSPague.ComprovanteSimplificado;
   frmconfig.cbVBISalvarLog.Checked               := config.ConfigTEFVSPague.SalvarLog;
   //---------------------------------------------------------------------------
   //   Configurações ELGIN
   //---------------------------------------------------------------------------
   frmconfig.cbELGIN_impressao_cliente.ItemIndex    := ord(config.ConfigTEFElgin.ComprovanteCliente);
   frmconfig.cbELGIN_impressao_loja.ItemIndex       := ord(config.ConfigTEFElgin.ComprovanteLoja);
   frmconfig.cbELGINcomprovantesimplificado.Checked := config.ConfigTEFElgin.ComprovanteSimplificado;
   frmconfig.cbELGIN_SalvarLOG.Checked              := config.ConfigTEFElgin.SalvarLog;
   //---------------------------------------------------------------------------
   //  Configurações MULTIPLUS
   //---------------------------------------------------------------------------
   frmconfig.edtcnpjMultiPlus.Text                      := config.ConfigTEFEMultiplus.CNPJ;
   frmconfig.edtLojaMultiPlus.Text                      := config.ConfigTEFEMultiplus.Loja;
   frmconfig.edtPDVMultiPlus.Text                       := config.ConfigTEFEMultiplus.TerminalPDV;
   frmconfig.cbcomprovanteclientemultiplus.ItemIndex    := ord(config.ConfigTEFEMultiplus.ComprovanteCliente);
   frmconfig.cbcomprovantelojamultiplus.ItemIndex       := ord(config.ConfigTEFEMultiplus.ComprovanteLoja);
   frmconfig.cbcomprovantesimplificadomultiplus.Checked := config.ConfigTEFEMultiplus.ComprovanteSimplificado;
   frmconfig.cbsalvarlogmultiplus.Checked               := config.ConfigTEFEMultiplus.SalvarLog;
   //---------------------------------------------------------------------------
   //   Configurações PIX MKM
   //---------------------------------------------------------------------------
   frmconfig.edtmkmpixCNPJ.Text                         := config.ConfigMKMPix.CNPJ;
   frmconfig.cbmkmpixComprovanteCliente.ItemIndex       := ord(config.ConfigMKMPix.ComprovanteCliente);
   frmconfig.cbmkmpixComprovanteLoja.ItemIndex          := ord(config.ConfigMKMPix.ComprovanteLoja);
   frmconfig.cbmkmpixsalvarLog.Checked                  := config.ConfigMKMPix.SalvarLog;
   //---------------------------------------------------------------------------
   //   Configuração para SMART TEF VERO
   //---------------------------------------------------------------------------
   frmconfig.edtVERO_CNPJ.Text                     := config.ConfigSMARTTEFVero.MerchatDocumentNumber;
   frmconfig.edtVEROPdvToken.Text                  := config.ConfigSMARTTEFVero.PdvToken;
   frmconfig.edtVEROPDV_DeviceToken.Text           := config.ConfigSMARTTEFVero.DeviceToken;
   frmconfig.cbVEROComprovanteCliente.ItemIndex    := ord(config.ConfigSMARTTEFVero.ComprovanteCliente);
   frmconfig.cbVEROComprovanteLoja.ItemIndex       := ord(config.ConfigSMARTTEFVero.ComprovanteLoja);
   frmconfig.cbVEROComprovanteSimplificado.Checked := config.ConfigSMARTTEFVero.ComprovanteSimplificado;
   frmconfig.cbVEROSalvarLOG.Checked               := config.ConfigSMARTTEFVero.SalvarLog;
   //---------------------------------------------------------------------------
   frmconfig.edtembedCodigoAtivacao.Text           := config.ConfigEmbedIT.CodigoAtivacao;
   frmconfig.edtembedLogin.Text                    := config.ConfigEmbedIT.Username;
   frmconfig.edtembedSenha.Text                    := config.ConfigEmbedIT.password;
   frmconfig.edtembedSerial.Text                   := config.ConfigEmbedIT.DeviceSerial;
   frmconfig.edtembedCNPJPIX.Text                  := config.ConfigEmbedIT.CNPJPIX;                                 // CNPJ do cliente
   frmconfig.edtembedChavePIX.Text                 := config.ConfigEmbedIT.ChavePIX;                                // Chave PIX do cliente
   frmconfig.edtembedUserNamePIX.Text              := config.ConfigEmbedIT.UsernamePIX;                             // UserName para autenticação TOKEN BEARER
   frmconfig.edtembedPasswordPIX.Text              := config.ConfigEmbedIT.PasswordPIX;                             // Senha para autenticação TOKEN BEARER
   frmconfig.cbembedHMLPIX.Checked                 := config.ConfigEmbedIT.AmbientePIX=tpAmbHomologacao;            // Operar em homologaçã
   frmconfig.cbEmbedComprovanteCliente.ItemIndex   := ord(config.ConfigEmbedIT.ComprovanteCliente);
   frmconfig.cbEmbedComprovanteLoja.ItemIndex      := ord(config.ConfigEmbedIT.ComprovanteLoja);
   frmconfig.cbEmbedSalvarLog.Checked              := config.ConfigEmbedIT.SalvarLog;
   //---------------------------------------------------------------------------
   for d := 1 to frmconfig.cbpinpad_porta.Items.Count do
      begin
         if config.ConfigPinPad.PINPAD_Porta=frmconfig.cbpinpad_porta.Items[d-1] then
            frmconfig.cbpinpad_porta.ItemIndex := d-1;
      end;
   for d := 1 to frmconfig.cbpinpad_Baud.Items.Count do
      begin
         if config.ConfigPinPad.PINPAD_Baud.ToString=frmconfig.cbpinpad_Baud.Items[d-1] then
            frmconfig.cbpinpad_Baud.ItemIndex := d-1;
      end;
   for d := 1 to frmconfig.cbpinpad_DataBits.Items.Count do
      begin
         if config.ConfigPinPad.PINPAD_DataBits.ToString=frmconfig.cbpinpad_DataBits.Items[d-1] then
            frmconfig.cbpinpad_DataBits.ItemIndex := d-1;
      end;
   //---------------------------------------------------------------------------
   frmconfig.cbpinpad_StopBit.ItemIndex      := ord(config.ConfigPinPad.PINPAD_StopBit);
   frmconfig.cbpinpad_Parity.ItemIndex       := ord(config.ConfigPinPad.PINPAD_Parity);
   frmconfig.cbpinpad_HandShacking.ItemIndex := ord(config.ConfigPinPad.PINPAD_HandShaking);
   frmconfig.cbpinpad_SoftFlow.Checked       := config.ConfigPinPad.PINPAD_SoftFlow;
   frmconfig.cbpinpad_HardFlow.Checked       := config.ConfigPinPad.PINPAD_HardFlow;
   frmconfig.edtarquivologopinpad.Text       := config.ConfigPinPad.PINPAD_Imagem;
   //---------------------------------------------------------------------------
   //   Carregando a imagem para a tela
   //---------------------------------------------------------------------------
   if fileexists(config.ConfigPinPad.PINPAD_Imagem) then
      frmconfig.imagem_pinpad.Picture.LoadFromFile(config.ConfigPinPad.PINPAD_Imagem);
   //---------------------------------------------------------------------------
   frmconfig.edtcnpj.Text           := config.ConfigEmitente.CNPJCPF;
   frmconfig.edtrazao.Text          := config.ConfigEmitente.xNome;
   frmconfig.edtfantasia.Text       := config.ConfigEmitente.xFant;
   frmconfig.edtendereco.Text       := config.ConfigEmitente.EnderEmit.xLgr;
   frmconfig.edtnro.Text            := config.ConfigEmitente.EnderEmit.nro;
   frmconfig.edtcomplemento.Text    := config.ConfigEmitente.EnderEmit.xCpl;
   frmconfig.edtcidade.Text         := config.ConfigEmitente.EnderEmit.xMun;
   frmconfig.edtuf.Text             := config.ConfigEmitente.EnderEmit.UF;
   frmconfig.edtcep.Text            := config.ConfigEmitente.EnderEmit.CEP.ToString;
   frmconfig.edtfone.Text           := config.ConfigEmitente.EnderEmit.fone;
   frmconfig.edtie.Text             := config.ConfigEmitente.IE;
   //---------------------------------------------------------------------------
   frmconfig.edtMOVIFLUXOToken.Text       := config.ConfigMovifluxo.Token;
   frmconfig.edtMOVIFLUXOIDCliente.Text   := config.ConfigMovifluxo.IDCliente;
   frmconfig.cbMOVIFLUXOhml.Checked       := config.ConfigMovifluxo.Homologacao;
   frmconfig.cbMOVIFLUXOSalvarLOG.Checked := config.ConfigMovifluxo.SalvarLOG;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
//   Procedure para salvar as configurações
//------------------------------------------------------------------------------
procedure SA_GravarConfig(config:TKSConfig);
var
  wIni: TIniFile;
begin
   wIni := TIniFile.Create(GetCurrentDir+'\config.ini');
   try
      //------------------------------------------------------------------------
      //   Configurações da SH
      //------------------------------------------------------------------------
      wIni.WriteString('TKSConfigSistema','Sistema',config.ConfigSistema.Sistema);          // Nome da impressora selecionada para impressão
      wIni.WriteString('TKSConfigSistema','Versao',config.ConfigSistema.Versao);            // Modelo de impressora ACBRPOSPrinter
      wIni.WriteString('TKSConfigSistema','EmpresaSH',config.ConfigSistema.EmpresaSH);      // Avanço de linhas ao final de documentos - Imaginando que tenha guilhotina, usar 3
      //------------------------------------------------------------------------
      // Configurações da impressora
      //------------------------------------------------------------------------
      wIni.WriteString('KSConfigImpressora','Nome',config.ConfigImpressora.Nome);           // Nome da impressora selecionada para impressão
      wIni.WriteInteger('KSConfigImpressora','Modelo',ord(config.ConfigImpressora.Modelo)); // Modelo de impressora ACBRPOSPrinter
      wIni.WriteInteger('KSConfigImpressora','Avanco',config.ConfigImpressora.Avanco);      // Avanço de linhas ao final de documentos - Imaginando que tenha guilhotina, usar 3
      //------------------------------------------------------------------------
      // Consulta de produtos
      //------------------------------------------------------------------------
      wIni.WriteString('KSConfigConsultaProd','HostServidor',config.ConfigServidorProd.HostServidor); // Host aonde a consulta será feita = http://www.mkmservicos.com.br
      wIni.WriteString('KSConfigConsultaProd','ChaveLicenca',config.ConfigServidorProd.ChaveLicenca); // Cheve de autorização para consultar produtos
      //------------------------------------------------------------------------
      // Configurações para o TEF VBI VSPague
      //------------------------------------------------------------------------
      wIni.WriteString('KSConfigTEFVSPague','Estabelecimento',config.ConfigTEFVSPague.Estabelecimento);                 // Código do Estabelecimento - CNPJ
      wIni.WriteString('KSConfigTEFVSPague','Loja',config.ConfigTEFVSPague.Loja);                                       // Código da loja - Fornecido pela VBI na solicitação do TEF
      wIni.WriteString('KSConfigTEFVSPague','TerminalPDV',config.ConfigTEFVSPague.TerminalPDV);                         // Código do terminal
      wIni.WriteInteger('KSConfigTEFVSPague','ComprovanteCliente',ord(config.ConfigTEFVSPague.ComprovanteCliente));     // Impressão do comprovante do cliente
      wIni.WriteInteger('KSConfigTEFVSPague','ComprovanteLoja',ord(config.ConfigTEFVSPague.ComprovanteLoja));           // Impressão do comprovante do lojista
      wIni.WriteBool('KSConfigTEFVSPague','ComprovanteSimplificado',config.ConfigTEFVSPague.ComprovanteSimplificado);   // Forma da impressão do comprovante do lojista
      wIni.WriteBool('KSConfigTEFVSPague','SalvarLog',config.ConfigTEFVSPague.SalvarLog);                               // Habilitar para salvar o LOG
      //------------------------------------------------------------------------
      // Configurações para o TEF ELGIN HUB
      //------------------------------------------------------------------------
      wIni.WriteInteger('KSConfigTEFElgin','ComprovanteCliente',ord(config.ConfigTEFElgin.ComprovanteCliente));             // Impressão do comprovante do cliente
      wIni.WriteInteger('KSConfigTEFElgin','ComprovanteLoja',ord(config.ConfigTEFElgin.ComprovanteLoja));                   // Impressão do comprovante do lojista
      wIni.WriteBool('KSConfigTEFElgin','ComprovanteSimplificado',config.ConfigTEFElgin.ComprovanteSimplificado);           // Forma da impressão do comprovante do lojista
      wIni.WriteBool('KSConfigTEFElgin','SalvarLog',config.ConfigTEFElgin.SalvarLog);                                       // Habilitar para salvar o LOG
      //------------------------------------------------------------------------
      // Configurações para o TEF Multiplus
     //------------------------------------------------------------------------
      wIni.WriteString('KSConfigTEFMultiplus','CNPJ',config.ConfigTEFEMultiplus.CNPJ);                                      // CNPJ da empresa que vai transacionar o TEF
      wIni.WriteString('KSConfigTEFMultiplus','Loja',config.ConfigTEFEMultiplus.Loja);                                      // Código da loja fornecida pelo Multiplus
      wIni.WriteString('KSConfigTEFMultiplus','TerminalPDV',config.ConfigTEFEMultiplus.TerminalPDV);                        // Número do terminal de PDV
      wIni.WriteInteger('KSConfigTEFMultiplus','ComprovanteCliente',ord(config.ConfigTEFEMultiplus.ComprovanteCliente));    // Impressão do comprovante do cliente
      wIni.WriteInteger('KSConfigTEFMultiplus','ComprovanteLoja',ord(config.ConfigTEFEMultiplus.ComprovanteLoja));          // Impressão do comprovante do lojista
      wIni.WriteBool('KSConfigTEFMultiplus','ComprovanteSimplificado',config.ConfigTEFEMultiplus.ComprovanteSimplificado);  // Forma da impressão do comprovante do lojista
      wIni.WriteBool('KSConfigTEFMultiplus','SalvarLog',config.ConfigTEFEMultiplus.SalvarLog);                              // Habilitar para salvar o LOG
      wIni.WriteInteger('KSConfigTEFMultiplus','NSUTef',config.ConfigTEFEMultiplus.NSUTef);                                 // Numero sequencial para cada transação
      //------------------------------------------------------------------------
      // Configurações para o MKM PIX
      //------------------------------------------------------------------------
      wIni.WriteString('KSConfigMKMPix','CNPJ',config.ConfigMKMPix.CNPJ);                                    // CNPJ da empresa que vai transacionar o TEF wIni.WriteString('TKSConfigMKMPix','Token','Codigo_token');               //: string;  // Código da loja, fornecida pela MKM
      wIni.WriteString('KSConfigMKMPix','SecretKey',config.ConfigMKMPix.SecretKey);                          // SecretKey - Fornecido pela MKM
      wIni.WriteString('KSConfigMKMPix','Token',config.ConfigMKMPix.Token);                                  // SecretKey - Fornecido pela MKM
      wIni.WriteInteger('KSConfigMKMPix','ComprovanteCliente',ord(config.ConfigMKMPix.ComprovanteCliente));  // Impressão do comprovante do cliente
      wIni.WriteInteger('KSConfigMKMPix','ComprovanteLoja',ord(config.ConfigMKMPix.ComprovanteLoja));        // Impressão do comprovante do lojista
      wIni.WriteBool('KSConfigMKMPix','SalvarLog',config.ConfigMKMPix.SalvarLog);                            // Habilitar para salvar o LOG
      //------------------------------------------------------------------------
      wIni.WriteString('KSConfigFormaSMARTVERO','MerchatDocumentNumber',config.ConfigSMARTTEFVero.MerchatDocumentNumber);   // CNPJ da empresa que vai usar o TEF
      wIni.WriteString('KSConfigFormaSMARTVERO','PdvToken',config.ConfigSMARTTEFVero.PdvToken);// string;                   // Código de homologação da Software House - Fornecido pela VERO/BANRISUL
      wIni.WriteString('KSConfigFormaSMARTVERO','DeviceToken',config.ConfigSMARTTEFVero.DeviceToken);                       // Número de autorização do POS - Obtida ao instalar o VERO CLIENT na maquininha POS
      wIni.WriteInteger('KSConfigFormaSMARTVERO','ComprovanteCliente',ord(config.ConfigSMARTTEFVero.ComprovanteCliente));   // Impressão do comprovante do cliente
      wIni.WriteInteger('KSConfigFormaSMARTVERO','ComprovanteLoja',ord(config.ConfigSMARTTEFVero.ComprovanteLoja));         // Impressão do comprovante do lojista
      wIni.WriteBool('KSConfigFormaSMARTVERO','ComprovanteSimplificado',config.ConfigSMARTTEFVero.ComprovanteSimplificado); // Forma da impressão do comprovante do lojista
      wIni.WriteBool('KSConfigFormaSMARTVERO','SalvarLog',config.ConfigSMARTTEFVero.SalvarLog);                             // Habilitar para salvar o LOG
      //------------------------------------------------------------------------
      wIni.WriteString('KSConfigEmbedIT','CodigoAtivacao',config.ConfigEmbedIT.CodigoAtivacao);                            //
      wIni.WriteString('KSConfigEmbedIT','Username',config.ConfigEmbedIT.Username);                                        //
      wIni.WriteString('KSConfigEmbedIT','password',config.ConfigEmbedIT.password);                                        //
      wIni.WriteString('KSConfigEmbedIT','DeviceSerial',config.ConfigEmbedIT.DeviceSerial);                                //
      wIni.WriteString('KSConfigEmbedIT','CNPJPIX',config.ConfigEmbedIT.CNPJPIX);                                          //
      wIni.WriteString('KSConfigEmbedIT','ChavePIX',config.ConfigEmbedIT.ChavePIX);                                        //
      wIni.WriteString('KSConfigEmbedIT','UserNamePIX',config.ConfigEmbedIT.UsernamePIX);                                  //
      wIni.WriteString('KSConfigEmbedIT','PasswordPIX',config.ConfigEmbedIT.PasswordPIX);                                  //
      wIni.WriteInteger('KSConfigEmbedIT','AmbientePIX',ord(config.ConfigEmbedIT.AmbientePIX));                            //
      wIni.WriteInteger('KSConfigEmbedIT','ComprovanteCliente',ord(config.ConfigEmbedIT.ComprovanteCliente));  // Impressão do comprovante do cliente
      wIni.WriteInteger('KSConfigEmbedIT','ComprovanteLoja',ord(config.ConfigEmbedIT.ComprovanteLoja));        // Impressão do comprovante do lojista
      wIni.WriteBool('KSConfigEmbedIT','SalvarLog',config.ConfigEmbedIT.SalvarLog);                            // Habilitar para salvar o LOG
      //------------------------------------------------------------------------
      //   Salvando configurações do PINPAD
      //------------------------------------------------------------------------
      wIni.WriteString('KSConfigPinPad','Porta',config.ConfigPinPad.PINPAD_Porta);
      wIni.WriteInteger('KSConfigPinPad','Baud',config.ConfigPinPad.PINPAD_Baud);
      wIni.WriteInteger('KSConfigPinPad','DataBits',config.ConfigPinPad.PINPAD_DataBits);
      wIni.WriteInteger('KSConfigPinPad','StopBit',ord(config.ConfigPinPad.PINPAD_StopBit));
      wIni.WriteInteger('KSConfigPinPad','Parity',ord(config.ConfigPinPad.PINPAD_Parity));
      wIni.WriteInteger('KSConfigPinPad','HandShaking',ord(config.ConfigPinPad.PINPAD_HandShaking));
      wIni.WriteBool('KSConfigPinPad','SoftFlow',config.ConfigPinPad.PINPAD_SoftFlow);
      wIni.WriteBool('KSConfigPinPad','HardFlow',config.ConfigPinPad.PINPAD_HardFlow);
      wIni.WriteString('KSConfigPinPad','Imagem',config.ConfigPinPad.PINPAD_Imagem);
      //------------------------------------------------------------------------
      wIni.WriteString('KSConfigEmitente','CNPJCPF',config.ConfigEmitente.CNPJCPF);
      wIni.WriteString('KSConfigEmitente','xNome',config.ConfigEmitente.xNome);
      wIni.WriteString('KSConfigEmitente','xFant',config.ConfigEmitente.xFant);
      wIni.WriteString('KSConfigEmitente','xLgr',config.ConfigEmitente.EnderEmit.xLgr);
      wIni.WriteString('KSConfigEmitente','nro',config.ConfigEmitente.EnderEmit.nro);
      wIni.WriteString('KSConfigEmitente','xCpl',config.ConfigEmitente.EnderEmit.xCpl);
      wIni.WriteString('KSConfigEmitente','xBairro',config.ConfigEmitente.EnderEmit.xBairro);
      wIni.WriteString('KSConfigEmitente','xMun',config.ConfigEmitente.EnderEmit.xMun);
      wIni.WriteString('KSConfigEmitente','UF',config.ConfigEmitente.EnderEmit.UF);
      wIni.WriteInteger('KSConfigEmitente','CEP',config.ConfigEmitente.EnderEmit.CEP);
      wIni.WriteString('KSConfigEmitente','fone',config.ConfigEmitente.EnderEmit.fone);
      wIni.WriteString('KSConfigEmitente','IE',config.ConfigEmitente.IE);
      //------------------------------------------------------------------------
      wIni.WriteString('KSConfigMovifluxo','Token',config.ConfigMovifluxo.Token);
      wIni.WriteString('KSConfigMovifluxo','IDCliente',config.ConfigMovifluxo.IDCliente);
      wIni.WriteBool('KSConfigMovifluxo','Homologacao',config.ConfigMovifluxo.Homologacao);
      wIni.WriteBool('KSConfigMovifluxo','SalvarLOG',config.ConfigMovifluxo.SalvarLOG);
      //------------------------------------------------------------------------
   finally
      wIni.Free;
   end;

end;
//------------------------------------------------------------------------------
//  Ajustar a edição de formas de pagamento
//------------------------------------------------------------------------------
procedure SA_AjustarEdicaoFormas;
begin
   //---------------------------------------------------------------------------
   case frmconfig.rgevento.ItemIndex of
      0,1,5,9:frmconfig.pntefconfig.Visible := false;
      2,3,4,6,7,8:frmconfig.pntefconfig.Visible := true;
   end;
   //---------------------------------------------------------------------------
   case frmconfig.rgevento.ItemIndex of
      2:frmconfig.cbformapgto.Items   := SA_ListaFormasTEF(tpTEFVSPAgue);
      3:frmconfig.cbformapgto.Items   := SA_ListaFormasTEF(tpTEFMultiPlus);
      4:frmconfig.cbformapgto.Items   := SA_ListaFormasTEF(tpTEFELGIN);
      6:frmconfig.cbformapgto.Items   := SA_ListaFormasTEF(tpVEROSmartTEF);
      7,8:frmconfig.cbformapgto.Items := SA_ListaFormasTEF(tpEmbedSmartTEF);
   end;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------

procedure Tfrmconfig.btalterarformaClick(Sender: TObject);
begin
   if tblformascodigo.Text<>'' then
      begin
         NovaForma                 := false;
         pgcformas.ActivePageIndex := 1;
      end
   else
      begin
         beep;
         ShowMessage('Não existe forma de pagamento cadastrada para alterar !');
      end;
end;

procedure Tfrmconfig.btapagarformaClick(Sender: TObject);
begin
   if tblformascodigo.Text<>'' then
      begin
         //---------------------------------------------------------------------
         beep;
         if messagedlg('A forma de pagamento selecionada será excluída ?!',mtconfirmation,[mbyes,mbno],0)= mryes then
            tblformas.Delete;
         //---------------------------------------------------------------------
      end
   else
      begin
         //---------------------------------------------------------------------
         beep;
         ShowMessage('Não existe forma de pagamento cadastrada para apagar !');
         //---------------------------------------------------------------------
      end;


end;

procedure Tfrmconfig.btbuscaimagemformaClick(Sender: TObject);
var
   caminho : string;
begin
   //---------------------------------------------------------------------------
   caminho := GetCurrentDir; // Obtendo o PATH atual
   //---------------------------------------------------------------------------
   selecionar_imagem.FileName := edtarquivo_imagem_forma.Text;
   selecionar_imagem.Filter   := 'Imagens BMP |*.bmp';
   selecionar_imagem.Execute;  // Abrir a janela para selecionar o arquivo de imagem
   if selecionar_imagem.FileName<>'' then
      begin
         if fileexists(selecionar_imagem.FileName) then
            begin
               edtarquivo_imagem_forma.Text      := extractfilename(selecionar_imagem.FileName);  // Carregando o nome do arquivo para a edição
               CopyFile(pchar(selecionar_imagem.FileName),pchar(GetCurrentDir+'\icones\'+ExtractFileName(selecionar_imagem.FileName)),false);
               Imagem_botao_forma.Picture.LoadFromFile(GetCurrentDir+'\icones\'+edtarquivo_imagem_forma.Text);   // Carregando a imagem para o Tpicture
            end;

      end;
   ChDir(caminho);  // Restaurar o path
   //---------------------------------------------------------------------------
end;

procedure Tfrmconfig.btbuscaimagempinpadClick(Sender: TObject);
var
   caminho : string;
begin
   //---------------------------------------------------------------------------
   caminho := GetCurrentDir; // Obtendo o PATH atual
   //---------------------------------------------------------------------------
   selecionar_imagem.FileName := edtarquivologopinpad.Text;
   selecionar_imagem.Execute;  // Abrir a janela para selecionar o arquivo de imagem
   if selecionar_imagem.FileName<>'' then
      begin
         edtarquivologopinpad.Text         := selecionar_imagem.FileName;  // Carregando o nome do arquivo para a edição
         config.ConfigPinPad.PINPAD_Imagem := edtarquivologopinpad.Text;   // Atualizando o registro de configurações
      end;
   ChDir(caminho);  // Restaurar o path
   //---------------------------------------------------------------------------
   imagem_pinpad.Picture.LoadFromFile(edtarquivologopinpad.Text);   // Carregando a imagem para o Tpicture
   //---------------------------------------------------------------------------
end;

procedure Tfrmconfig.btbuscaportawindowsClick(Sender: TObject);
var
   impressora : TACBrPosPrinter;
   lista      : TStringList;
begin
   impressora := TACBrPosPrinter.Create(nil);
   lista := TStringList.Create;
   impressora.Device.AcharPortasSeriais( lista );
   impressora.Device.AcharPortasUSB( lista );
   impressora.Device.AcharPortasRAW( lista );
   impressora.Device.AcharPortasBlueTooth( lista );
   cblistaimpressoras.Items := lista;
   lista.Free;
   impressora.Free;
   //---------------------------------------------------------------------------
   cblistaimpressoras.Visible := true;
   cblistaimpressoras.Left    := edtporta_impressora_ESC_POS.Left;
   cblistaimpressoras.Top     := edtporta_impressora_ESC_POS.Top;
   cblistaimpressoras.Width   := edtporta_impressora_ESC_POS.Width;
   cblistaimpressoras.SetFocus;
   //---------------------------------------------------------------------------
end;

procedure Tfrmconfig.btcancelarClick(Sender: TObject);
begin
   frmconfig.Close;
end;

procedure Tfrmconfig.btembedPasswordPIXClick(Sender: TObject);
begin
   if edtembedPasswordPIX.PasswordChar=#0 then
      edtembedPasswordPIX.PasswordChar := '*'
   else if edtembedPasswordPIX.PasswordChar<>#0 then
      edtembedPasswordPIX.PasswordChar := #0;
end;

procedure Tfrmconfig.btembedversenhaClick(Sender: TObject);
begin
   if edtembedSenha.PasswordChar=#0 then
      edtembedSenha.PasswordChar := '*'
   else if edtembedSenha.PasswordChar<>#0 then
      edtembedSenha.PasswordChar := #0;
end;

procedure Tfrmconfig.btgerarTokenClick(Sender: TObject);
begin
   beep;
   showmessage('Função ainda não foi implementada no servidor. Contacte o administrador da classe para solicitar o TOKEN.');
end;

procedure Tfrmconfig.btMOVIFLUXOBuscarClienteClick(Sender: TObject);
var
   MoviFluxo : TMoviFluxo;
   d         : integer;
begin
   //---------------------------------------------------------------------------
   MoviFluxo             := TMoviFluxo.Create;
   MoviFluxo.Token       := Config.ConfigMovifluxo.Token;
   MoviFluxo.Homologacao := Config.ConfigMovifluxo.Homologacao;
   MoviFluxo.SalvarLOG   := Config.ConfigMovifluxo.SalvarLOG;
   MoviFluxoListaLojas   := MoviFluxo.SA_ListarLojas;  // Consultar a lista de lojas
   MoviFluxo.Free;
   //---------------------------------------------------------------------------
   cbClientesMovifluxo.Items.Clear;
   if length(MoviFluxoListaLojas)>1 then
      begin
         //---------------------------------------------------------------------
         for d := 1 to length(MoviFluxoListaLojas) do
            cbClientesMovifluxo.Items.Add(MoviFluxoListaLojas[d-1].cnpj+' '+MoviFluxoListaLojas[d-1].nome_empresa);
         //---------------------------------------------------------------------
         cbClientesMovifluxo.Left      := edtMOVIFLUXOIDCliente.Left;
         cbClientesMovifluxo.Top       := edtMOVIFLUXOIDCliente.Top;
         cbClientesMovifluxo.Width     := edtMOVIFLUXOIDCliente.Width;
         cbClientesMovifluxo.ItemIndex := 0;
         cbClientesMovifluxo.Visible   := true;
         //---------------------------------------------------------------------
         cbClientesMovifluxo.DroppedDown := true;
         cbClientesMovifluxo.SetFocus;

         //---------------------------------------------------------------------
      end
   else
      edtMOVIFLUXOIDCliente.Text := MoviFluxoListaLojas[0].user_id;
   //---------------------------------------------------------------------------
end;

procedure Tfrmconfig.btnovaformaClick(Sender: TObject);
begin
   NovaForma                 := true;
   pgcformas.ActivePageIndex := 1;
end;

procedure Tfrmconfig.btsalvaformaClick(Sender: TObject);
begin
   if length(edtforma.Text)>=5 then
      begin
         //---------------------------------------------------------------------
         if rgevento.ItemIndex<0 then
            rgevento.ItemIndex := 0;
         if cbformapgto.ItemIndex<0 then
            cbformapgto.ItemIndex := 0;
         //---------------------------------------------------------------------
         if NovaForma then
            tblformas.Append
         else
            tblformas.edit;
         tblformas.FieldByName('forma').AsString         := edtforma.Text;
         tblformas.FieldByName('atalho').AsString        := edtatalho_forma.Text;
         tblformas.FieldByName('ordem').AsInteger        := strtointdef(edtordem.Text,9);
         tblformas.FieldByName('evento').AsInteger       := rgevento.ItemIndex;
         tblformas.FieldByName('TipoPgto').AsInteger     := cbformapgto.ItemIndex;
         tblformas.FieldByName('QtdeParcelas').AsInteger := strtointdef(edtqtdeparcelas.Text,0);
         tblformas.FieldByName('AruivoImagem').AsString  := edtarquivo_imagem_forma.Text;
         tblformas.Post;
         tblformas.SaveToFile(GetCurrentDir+'\formas.xml');
         //---------------------------------------------------------------------
         pgcformas.ActivePageIndex := 0;
      end
   else
      begin
         beep;
         showmessage('O descritivo da forma de poagamento é muito pequeno (Mínimo 5 letras)!');
      end;

end;

procedure Tfrmconfig.btsalvarClick(Sender: TObject);
begin
   //---------------------------------------------------------------------------
   SA_ConfigMultiPlus(config.ConfigSistema.EmpresaSH,frmconfig.cbpinpad_porta.Text);  // Configurar multiplus
   //---------------------------------------------------------------------------
   config := SA_CaregarEdicaoParaConfigVAR;  // Carregando as configurações da edição para a variável de memória
   SA_GravarConfig(config);                  // Salvando as configurações da variável de memória para o arquivo
   tblformas.SaveToFile(GetCurrentDir+'\formas.xml');
   //---------------------------------------------------------------------------
   btcancelar.Click;
   //---------------------------------------------------------------------------
end;

procedure Tfrmconfig.btvoltaformaClick(Sender: TObject);
begin
   pgcformas.ActivePageIndex := 0;
end;

procedure Tfrmconfig.cbClientesMovifluxoExit(Sender: TObject);
begin
   cbClientesMovifluxo.Visible := false;
end;

procedure Tfrmconfig.cbClientesMovifluxoSelect(Sender: TObject);
begin
   if cbClientesMovifluxo.ItemIndex>=0 then
      edtMOVIFLUXOIDCliente.Text := frmconfig.MoviFluxoListaLojas[cbClientesMovifluxo.ItemIndex].user_id;
   cbClientesMovifluxo.Visible := false;
end;

procedure Tfrmconfig.cblistaimpressorasEnter(Sender: TObject);
begin
   cblistaimpressoras.DroppedDown := true;
end;

procedure Tfrmconfig.cblistaimpressorasExit(Sender: TObject);
begin
   cblistaimpressoras.Visible := false;
end;

procedure Tfrmconfig.cblistaimpressorasSelect(Sender: TObject);
begin
   if cblistaimpressoras.ItemIndex>=0 then
      edtporta_impressora_ESC_POS.Text := cblistaimpressoras.Items[cblistaimpressoras.ItemIndex];
   edtporta_impressora_ESC_POS.SetFocus;
end;

procedure Tfrmconfig.ClientDataSet1DescEventoGetText(Sender: TField;  var Text: string; DisplayText: Boolean);
begin
   case tblformas.FieldByName('evento').AsInteger of
      0:text := 'Solvência - Dinheiro';
      1:text := 'Nenhum';
      2:text := 'TEF VSPague';
      3:text := 'TEF Multiplus';
      4:text := 'TEF ELGIN';
      5:text := 'MKM Pix';
      6:text := 'SMART TEF Vero';
      7:text := 'WEB TEF Mercado Pago';
      8:text := 'Embed-IT TEF';
      9:text := 'Embed-IT Smart Pos';
   end;
end;

procedure Tfrmconfig.DBGridformasDblClick(Sender: TObject);
begin
   btalterarforma.Click;
end;

procedure Tfrmconfig.DBGridformasEnter(Sender: TObject);
begin
   NovaForma                 := false;
   (Sender as TDBGrid).Color := clWindow;
end;

procedure Tfrmconfig.DBGridformasExit(Sender: TObject);
begin
   (Sender as TDBGrid).Color := clInactiveBorder;
end;

procedure Tfrmconfig.DBGridformasKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
   case key of
      vk_insert : btnovaforma.Click;
      vk_return : btalterarforma.Click;
      vk_delete : btapagarforma.Click;
      vk_escape : btcancelar.Click;
   end;
end;

procedure Tfrmconfig.edtordemKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
   case key of
      vk_return:perform(40,0,0);
      vk_escape:btvoltaforma.Click;
      vk_up:perform(40,0,1);
      vk_down:perform(40,0,0);
   end;
end;

procedure Tfrmconfig.edtordemKeyPress(Sender: TObject; var Key: Char);
begin
   if not charinset(key, ['0'..'9',#8]) then
      key := #0;
end;

procedure Tfrmconfig.edtporta_impressora_ESC_POSKeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
begin
   case key of
      vk_escape:btcancelar.Click;
      vk_return:perform(40,0,0);
   end;
end;

procedure Tfrmconfig.FormActivate(Sender: TObject);
var
   lista   : TStringList;
   LPinPad : TACBrAbecsPinPad;
begin
   frmconfig.Repaint;
   Application.ProcessMessages;
   //---------------------------------------------------------------------------
   //   Preparando as portas do PINPAD
   //---------------------------------------------------------------------------
   lista := TStringList.Create;
   LPinPad := TACBrAbecsPinPad.Create(frmconfig);
   LPinPad.Device.AcharPortasSeriais( lista );
   cbpinpad_porta.Items.Clear;
   cbpinpad_porta.Items.Text := lista.Text;
   lista.Free;
   LPinPad.Free;
   //---------------------------------------------------------------------------
   if not AcessouForm then
      begin
         //---------------------------------------------------------------------
         AcessouForm    := true;
         pntitulo.Align := alTop;
         pnrodape.Align := alBottom;
         fundo.Align    := alClient;
         //---------------------------------------------------------------------
         SA_CarregarConfigParaEdicao(Config);  // Carragando as configurações da variável de memória para a edição
         //---------------------------------------------------------------------
      end;
   //---------------------------------------------------------------------------
end;

procedure Tfrmconfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   frmconfig.Release;
end;

procedure Tfrmconfig.FormCreate(Sender: TObject);
begin
   //---------------------------------------------------------------------------
   tblformas.CreateDataSet;
   tblpgto.CreateDataSet;
   //---------------------------------------------------------------------------
   if fileexists(GetCurrentDir+'\formas.xml') then
      begin
         tblformas.Close;
         tblformas.Open;
         tblformas.EmptyDataSet;
         tblformas.LoadFromFile(GetCurrentDir+'\formas.xml');
      end;
   //---------------------------------------------------------------------------
   AcessouForm               := false; // Inicializando a variável que informa se o FORM já foi inicializado
   pgc.ActivePageIndex       := 0;     // Ajustando a página para inicializar, independentemente da forma que ficou durante3 a codificação
   pgcformas.ActivePageIndex := 0;     // Ajustando a página para inicializar, independentemente da forma que ficou durante3 a codificação
   //---------------------------------------------------------------------------
end;

procedure Tfrmconfig.rgeventoClick(Sender: TObject);
begin
   SA_AjustarEdicaoFormas;
end;

procedure Tfrmconfig.btdetectarpinpadClick(Sender: TObject);
var
   d      : integer;
   Pinpad : TKSPinpad;
begin
   //---------------------------------------------------------------------------
   Pinpad := TKSPinpad.Create;   // inicializa pinpad Detectando
   Config.ConfigPinPad := Pinpad.ConfigPinPad;
   Config.ConfigPinPad.PINPAD_Imagem := edtarquivologopinpad.Text;
   Pinpad.MostrarImagem(Config.ConfigPinPad.PINPAD_Imagem);   // Mostrando a imagem
   Pinpad.Free;
   //---------------------------------------------------------------------------
   Config.ConfigPinPad.PINPAD_Imagem := edtarquivologopinpad.Text;
   //---------------------------------------------------------------------------
   for d := 1 to frmconfig.cbpinpad_porta.Items.Count do
      begin
         if config.ConfigPinPad.PINPAD_Porta=frmconfig.cbpinpad_porta.Items[d-1] then
            frmconfig.cbpinpad_porta.ItemIndex := d-1;
      end;
   for d := 1 to frmconfig.cbpinpad_Baud.Items.Count do
      begin
         if config.ConfigPinPad.PINPAD_Baud.ToString=frmconfig.cbpinpad_Baud.Items[d-1] then
            frmconfig.cbpinpad_Baud.ItemIndex := d-1;
      end;
   for d := 1 to frmconfig.cbpinpad_DataBits.Items.Count do
      begin
         if config.ConfigPinPad.PINPAD_DataBits.ToString=frmconfig.cbpinpad_DataBits.Items[d-1] then
            frmconfig.cbpinpad_DataBits.ItemIndex := d-1;
      end;
   //---------------------------------------------------------------------------
   frmconfig.cbpinpad_StopBit.ItemIndex      := ord(config.ConfigPinPad.PINPAD_StopBit);
   frmconfig.cbpinpad_Parity.ItemIndex       := ord(config.ConfigPinPad.PINPAD_Parity);
   frmconfig.cbpinpad_HandShacking.ItemIndex := ord(config.ConfigPinPad.PINPAD_HandShaking);
   frmconfig.cbpinpad_SoftFlow.Checked       := config.ConfigPinPad.PINPAD_SoftFlow;
   frmconfig.cbpinpad_HardFlow.Checked       := config.ConfigPinPad.PINPAD_HardFlow;
   //---------------------------------------------------------------------------

end;

procedure Tfrmconfig.TabSheet10Show(Sender: TObject);
begin
   tblformas.Open;
   btsalvar.Visible          := true;
   btcancelar.Visible        := true;

end;

procedure Tfrmconfig.TabSheet11Show(Sender: TObject);
begin
   btsalvar.Visible          := true;
   btcancelar.Visible        := true;
   fundolistaforma.Align := alClient;
end;

procedure Tfrmconfig.TabSheet12Show(Sender: TObject);
begin
   fundoedicaoforma.Align := alClient;
   //---------------------------------------------------------------------------
   btsalvar.Visible     := false;  // Desativando os botões de salvar geral
   btcancelar.Visible   := false;
   //---------------------------------------------------------------------------
   edtforma.Text                := '';
   edtatalho_forma.Text         := '';
   edtordem.Text                := '9';
   rgevento.ItemIndex           := 0;
   cbformapgto.ItemIndex        := 0;
   edtqtdeparcelas.Text         := '';
   //---------------------------------------------------------------------------
   if not NovaForma then  // Está alterando uma forma, carregar os dados da forma para os campos
      begin
         edtforma.Text                := tblformasforma.Text;
         edtatalho_forma.Text         := tblformasatalho.Text;
         edtordem.Text                := tblformasordem.Text;
         rgevento.ItemIndex           := tblformas.FieldByName('evento').AsInteger;
         edtarquivo_imagem_forma.Text := tblformasAruivoImagem.Text;
         Imagem_botao_forma.Picture := imagem_forma_vazia.Picture;
         if edtarquivo_imagem_forma.Text<>'' then  // Verificado se existe imagem associada à forma
            begin
               if fileexists(GetCurrentDir+'\icones\'+edtarquivo_imagem_forma.Text) then
                  Imagem_botao_forma.Picture.LoadFromFile(GetCurrentDir+'\icones\'+edtarquivo_imagem_forma.Text);   // Carregando a imagem para o Tpicture
            end;
      end;
   //---------------------------------------------------------------------------
   SA_AjustarEdicaoFormas;   // Mostrando as configurações da forma de pagamento
   //---------------------------------------------------------------------------
   edtforma.SelectAll;
   edtforma.SetFocus;
   //---------------------------------------------------------------------------
end;

procedure Tfrmconfig.TabSheet1Show(Sender: TObject);
begin
   fundovbi.Align     := alClient;
   btsalvar.Visible   := true;
   btcancelar.Visible := true;

end;

procedure Tfrmconfig.TabSheet2Show(Sender: TObject);
begin
   fundoconsultaprod.Align := alClient;
   btsalvar.Visible        := true;
   btcancelar.Visible      := true;
   if edthostprod.Text = '' then
      edthostprod.Text := 'http://www.mkmservicos.com.br';
end;

procedure Tfrmconfig.TabSheet3Show(Sender: TObject);
begin
   fundoimpressora.Align := alClient;
   edtporta_impressora_ESC_POS.SetFocus;
end;

procedure Tfrmconfig.TabSheet4Show(Sender: TObject);
begin
   fundoembed.Align   := alClient;
   btsalvar.Visible   := true;
   btcancelar.Visible := true;
end;

procedure Tfrmconfig.TabSheet5Show(Sender: TObject);
begin
   fundoelgin.Align   := alClient;
   btsalvar.Visible   := true;
   btcancelar.Visible := true;

end;

procedure Tfrmconfig.TabSheet6Show(Sender: TObject);
begin
   fundomultiplus.Align := alClient;
   btsalvar.Visible     := true;
   btcancelar.Visible   := true;

end;

procedure Tfrmconfig.TabSheet7Show(Sender: TObject);
begin
   fundomkm.Align     := alClient;
   btsalvar.Visible   := true;
   btcancelar.Visible := true;

end;

procedure Tfrmconfig.TabSheet8Show(Sender: TObject);
begin
   fundovero.Align    := alClient;
   btsalvar.Visible   := true;
   btcancelar.Visible := true;

end;

procedure Tfrmconfig.TabSheet9Show(Sender: TObject);
begin
   fundomovifluxo.Align        := alClient;
   cbClientesMovifluxo.Visible := false;
end;

procedure Tfrmconfig.tblformasDescEventoGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
   case tblformas.FieldByName('evento').AsInteger of
      0:text := 'Solvência - Dinheiro';
      1:text := 'Nenhum';
      2:text := 'TEF VSPague';
      3:text := 'TEF Multiplus';
      4:text := 'TEF ELGIN';
      5:text := 'MKM Pix';
      6:text := 'SMART TEF Vero';
      7:text := 'Embed-IT TEF';
      8:text := 'Embed-IT Smart Pos';
      9:text := 'Embed-IT PIX';
   end;
end;

procedure Tfrmconfig.tblpgtoValorGetText(Sender: TField; var Text: string;  DisplayText: Boolean);
begin
   text := transform(se((Sender as TField).value<>null,(Sender as TField).value,0));
end;

end.
