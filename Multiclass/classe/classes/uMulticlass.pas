unit uMulticlass;

interface

uses
   uMoviFluxo,
   PngImage,
   uEmbedPIX,
   uVSPague,
   uMKMPix,
   uVeroTEF,
   uEmbedIT,
   uElginTEF,
   uMultiPlusTEF,
   uKSTypes,
   uBuscaProd,
   uconfig,
   ucpfcupom,
   upgto,
   udmMulticlass,
   uMulticlassFuncoes,
   uPgtoMulticlass,
   forms,
   ACBrNFe.Classes,
   blcksock,
   pcnConversaoNFe,
   ACBrDeviceSerial,
   ACBrPosPrinter,
   Datasnap.DBClient,
   midaslib,
   System.Classes,
   System.SysUtils,
   System.net.httpclient,
   system.IniFiles;

Type
   //---------------------------------------------------------------------------
   TMulticlass = class
     Private
        //----------------------------------------------------------------------
        LTokenConsultaProd : string; // Token para consultar produtos
        //----------------------------------------------------------------------
        LConfig       : TKSConfig;                 // Variável que armazena em memória as configurações
        LProduto      : TKSRespostaConsultaProd;   // Criar uma variável para receber a consulta
        LPagamento    : TPagamentoVenda;           // Variável para receber o resultado do pagamento
        LCancelamento : TDadosCancelamento;        // VVariável para realizar o cancelamento
        //----------------------------------------------------------------------
        procedure SA_CarregarConfig;
        function SA_InternetConectada: boolean;
        function SA_Mov_NSUTEF:integer;
        function SA_Mov_VBISequencial:integer;
        //----------------------------------------------------------------------
        function SA_CriarClasseELGIN     : TElginTEF;
        function SA_CriarClasseMultiplus : TMultiPlusTEF;
        function SA_CriarClasseVero      : TVEROSmartTEF;
        function SA_CriarClasseEmbed     : TEmbedIT;
        function SA_CriarClasseVBI       : TVSPagueTEF;
        //----------------------------------------------------------------------
        function SA_ELGINPagar(forma : TPagamentoFoma)        : TRetornoPagamentoTEF;
        function SA_MultiPlusPagar(forma : TPagamentoFoma)    : TRetornoPagamentoTEF;
        function SA_EmbedITPagar(forma : TPagamentoFoma)      : TRetornoPagamentoTEF;
        function SA_MKMVeroSmartPagar(forma : TPagamentoFoma) : TRetornoPagamentoTEF;
        function SA_MKMPixPagar(forma : TPagamentoFoma)       : TRetornoPagamentoTEF;
        function SA_VBIPagar(forma : TPagamentoFoma)          : TRetornoPagamentoTEF;
        function SA_EmbedPIXPagar(forma : TPagamentoFoma)     : TRetornoPagamentoTEF;
        //----------------------------------------------------------------------
        function SA_Cancelar_TEF_ELGIN(Cancelamento : TDadosCancelamento)     : boolean;
        function SA_Cancelar_TEF_Multiplus(Cancelamento : TDadosCancelamento) : boolean;
        function SA_MKMVeroSmartCancelar(Cancelamento : TDadosCancelamento)   : boolean;
        function SA_EBEDCancelar(Cancelamento : TDadosCancelamento)           : boolean;
        function SA_VBICancelar(cancelamento : TDadosCancelamento)            : boolean;

        //----------------------------------------------------------------------
     Public
        constructor create;
        destructor Destroy(); override;
        //----------------------------------------------------------------------
        property TokenConsultaProd : string             read LTokenConsultaProd write LTokenConsultaProd; // Definir Token manualmente
        //----------------------------------------------------------------------
        property Config       : TKSConfig               read LConfig         write LConfig;      // Variável que armazena em memória as configurações
        property Produto      : TKSRespostaConsultaProd read LProduto        write LProduto;     // Criar uma variável para receber a consulta
        property Pagamento    : TPagamentoVenda         read LPagamento      write LPagamento;   // Variável para receber o resultado do pagamento
        property Cancelamento : TDadosCancelamento      read LCancelamento   write LCancelamento; // VVariável para realizar o cancelamento
        //----------------------------------------------------------------------
        procedure Configurar;                           // Chamar a configuração do sistema
        function ConsultarProduto(CodigoEan : string):TKSRespostaConsultaProd; // Consultar produto no servidor
        procedure DefinirPagamento(TotalPagar : real);  // Chamar a tela de pagamentos para o operador
        procedure ExecutarPagamentos;                   // Executar os pagamentos
        procedure EncerrarVendaCompleta(TotalPagar : real);
        //----------------------------------------------------------------------
        function CancelarTransacao(Cancelamento : TDadosCancelamento):boolean;
        //----------------------------------------------------------------------
        procedure ELGINAdm;
        procedure VSPaguePendencias;
        procedure VSPagueExtrato;
        //----------------------------------------------------------------------
        function MOVIFLUXOConsultar(dti,dtf:TDate) : TMoviFluxoExtrato;
        function MOVIFLUXOListaLojas:TMoviFluxoListaLojas;
        //----------------------------------------------------------------------
        procedure ImprimirTexto(texto:string);
        procedure ImprimirArquivo(arquivo:string);
        function CapturarCPF:string;
        function EnviarArquivo(arquivo:string):boolean;
        //----------------------------------------------------------------------
   end;

implementation

{ TMulticlass }

function TMulticlass.CancelarTransacao(Cancelamento : TDadosCancelamento): boolean;
begin
   Result := false;
   case cancelamento.Evento of
     tpKSEventoVSSPague        : Result := SA_VBICancelar(Cancelamento);
     tpKSEventoMultiplus       : Result := SA_Cancelar_TEF_Multiplus(Cancelamento);
     tpKSEventoElgin           : Result := SA_Cancelar_TEF_ELGIN(Cancelamento);
     tpKSEventoMKMPix          : Result := false;
     tpKSEventoSmartTEFVero    : Result := SA_MKMVeroSmartCancelar(Cancelamento);
     tpKSEventoTEFEmbedIT      : Result := SA_EBEDCancelar(Cancelamento);
     tpKSEventoSmartTEFEmbedIT : Result := SA_EBEDCancelar(Cancelamento);
   end;
end;

function TMulticlass.CapturarCPF: string;
begin
   Application.CreateForm(Tfrmcpfcupom, frmcpfcupom);
   frmcpfcupom.LConfigPinPad := config.ConfigPinPad;
   frmcpfcupom.ShowModal;
   Result := frmcpfcupom.CNPJ_CPF;
   frmcpfcupom.Release;
end;

procedure TMulticlass.Configurar;
begin
   Application.CreateForm(Tfrmconfig, frmconfig);
   frmconfig.Config := LConfig;
   frmconfig.ShowModal;
end;

function TMulticlass.ConsultarProduto(CodigoEan: string):TKSRespostaConsultaProd;
var
   consulta : TKSBuscaprod;
begin
   //---------------------------------------------------------------------------
   if not SA_InternetConectada then   // Conferindo se o PC está conectado à internet
      begin
         LProduto.Status    := stKSFalha;
         LProduto.Consultou := false;
         LProduto.Mensagem  := 'Sem conexão com a INTERNET.';
         Result             := LProduto;
         exit;
      end;
   //---------------------------------------------------------------------------
   consulta               := TKSBuscaprod.Create;
   consulta.ChaveConsulta := config.ConfigServidorProd.ChaveLicenca;
   consulta.CodigoBarras  := CodigoEan;
   consulta.Consultar;
   LProduto := consulta.RespostaConsulta;
   LProduto.Consultou := LProduto.Status = stKSOk;
   Result             := LProduto;
   consulta.Free;
   //---------------------------------------------------------------------------
end;

constructor TMulticlass.create;
begin
   if not DirectoryExists(getcurrentdir+'\TEF_Log') then
      createdir(getcurrentdir+'\TEF_Log');
   Application.CreateForm(TdmMulticlass, dmMulticlass);  // Criar o Data Module
   SA_CarregarConfig;  // Carregar Configurações


end;

procedure TMulticlass.DefinirPagamento(TotalPagar : real);
var
   PgtoMulticlass : TPgto;
begin
   PgtoMulticlass := TPgto.Create;
   PgtoMulticlass.ValorTotal := TotalPagar;
   PgtoMulticlass.DefinirPagamento;
   LPagamento := PgtoMulticlass.Pagamento;
   PgtoMulticlass.Free;
end;

destructor TMulticlass.Destroy;
begin
  dmMulticlass.Destroy;
  inherited;
 end;

procedure TMulticlass.ELGINAdm;
var
   TEF_Elgin : TElginTEF;
begin
   //---------------------------------------------------------------------------
   TEF_Elgin := TElginTEF.Create;
   //---------------------------------------------------------------------------
   TEF_Elgin.TEFTextoPinPad        := LConfig.ConfigSistema.EmpresaSH;
   TEF_Elgin.TEFSistema            := LConfig.ConfigSistema.Sistema;
   TEF_Elgin.TEFSistemaVersao      := LConfig.ConfigSistema.Versao;
   //---------------------------------------------------------------------------
   TEF_Elgin.TEFEstabelecimento    := LConfig.ConfigEmitente.CNPJCPF;
   if LConfig.ConfigEmitente.xFant<>'' then
      TEF_Elgin.TEFEstabelecimento := LConfig.ConfigEmitente.xFant
   else
      TEF_Elgin.TEFEstabelecimento := LConfig.ConfigEmitente.xNome;
   TEF_Elgin.TEFLoja              := '01';
   TEF_Elgin.TEFIdCliente         := IntToHex(strtointdef(copy(LConfig.ConfigEmitente.CNPJCPF,1,5),0),5);
   TEF_Elgin.ComprovanteLoja      := LConfig.ConfigTEFElgin.ComprovanteLoja;
   TEF_Elgin.ComprovanteCliente   := LConfig.ConfigTEFElgin.ComprovanteCliente;
   TEF_Elgin.SalvarLog            := LConfig.ConfigTEFElgin.SalvarLog;
   TEF_Elgin.ViaLojaSimplificada  := LConfig.ConfigTEFElgin.ComprovanteSimplificado;
   //---------------------------------------------------------------------------
   TEF_Elgin.SA_Configurar_TEF;
   TEF_Elgin.tpOperacaoADM := TtpOperacaoADM(0);
   //---------------------------------------------------------------------------
   TEF_Elgin.SA_Administrativo;

   while TEF_Elgin.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;

   TEF_Elgin.Free;
end;

procedure TMulticlass.EncerrarVendaCompleta(TotalPagar: real);
begin
   DefinirPagamento(TotalPagar);
   if LPagamento.TotalPagamentos>0 then
      ExecutarPagamentos;
end;

function TMulticlass.EnviarArquivo(arquivo: string): boolean;
begin
   if LTokenConsultaProd<>'' then
      LConfig.ConfigServidorProd.ChaveLicenca := LTokenConsultaProd;
   result := SA_Enviar_Arquivo(LConfig.ConfigServidorProd.HostServidor,LConfig.ConfigServidorProd.ChaveLicenca,arquivo);
end;

procedure TMulticlass.ExecutarPagamentos;
var
   d : integer;
begin
   //---------------------------------------------------------------------------
   // Processar os pagamentos
   //---------------------------------------------------------------------------
   if length(LPagamento.Pagamentos)>0 then
      begin
         //---------------------------------------------------------------------
         //   Fazendo o LOOP de pagamentos
         //---------------------------------------------------------------------
         LPagamento.Status := true;
         for d := 1 to length(LPagamento.Pagamentos) do
            begin
               //---------------------------------------------------------------
               case LPagamento.Pagamentos[d-1].Evento of
                  tpKSEventoSolvencia       : LPagamento.Pagamentos[d-1].RetornoTEF.Status := true;
                  tpKSEventoNenhum          : LPagamento.Pagamentos[d-1].RetornoTEF.Status := true;
                  tpKSEventoElgin           : LPagamento.Pagamentos[d-1].RetornoTEF := SA_ELGINPagar(LPagamento.Pagamentos[d-1]);        // Transacionar com ELGIN
                  tpKSEventoMultiplus       : LPagamento.Pagamentos[d-1].RetornoTEF := SA_MultiPlusPagar(LPagamento.Pagamentos[d-1]);    // Transacionar com MULTIPLUS
                  tpKSEventoVSSPague        : LPagamento.Pagamentos[d-1].RetornoTEF := SA_VBIPagar(LPagamento.Pagamentos[d-1]);          // Transacionar com VSPague
                  tpKSEventoTEFEmbedIT      : LPagamento.Pagamentos[d-1].RetornoTEF := SA_EmbedITPagar(LPagamento.Pagamentos[d-1]);      // Transacionar com EMBED IT
                  tpKSEventoSmartTEFEmbedIT : LPagamento.Pagamentos[d-1].RetornoTEF := SA_EmbedITPagar(LPagamento.Pagamentos[d-1]);      // Transacionar com EMBED IT
                  tpKSEventoSmartTEFVero    : LPagamento.Pagamentos[d-1].RetornoTEF := SA_MKMVeroSmartPagar(LPagamento.Pagamentos[d-1]); // Transacionar com SmartVero POS
                  tpKSEventoMKMPix          : LPagamento.Pagamentos[d-1].RetornoTEF := SA_MKMPixPagar(LPagamento.Pagamentos[d-1]);       // Transacionar com SmartVero POS
                  tpKSEventoPIXEmbed        : LPagamento.Pagamentos[d-1].RetornoTEF := SA_EmbedPIXPagar(LPagamento.Pagamentos[d-1]);     // Transacionar com SmartVero POS
               end;
               //---------------------------------------------------------------
               if not(LPagamento.Pagamentos[d-1].RetornoTEF.Status) then
                  begin
                     LPagamento.Status := false;
                     break;
                  end;
               //---------------------------------------------------------------
            end;

         //---------------------------------------------------------------------
      end
   else
      LPagamento.Status := false;
   //---------------------------------------------------------------------------
end;

procedure TMulticlass.ImprimirArquivo(arquivo : string);
var
   linhas : TStringList;
begin
   if fileexists(arquivo) then
      begin
         linhas := TStringList.Create;
         linhas.LoadFromFile(arquivo);
         ImprimirTexto(linhas.Text);
         linhas.Free;
      end;
end;

procedure TMulticlass.ImprimirTexto(texto: string);
begin
   //---------------------------------------------------------------------------
   SA_ImprimirTexto(texto,Config.ConfigImpressora);
end;

function TMulticlass.MOVIFLUXOConsultar(dti,dtf:TDate) : TMoviFluxoExtrato;
var
   MoviFluxo : TMoviFluxo;
begin
   MoviFluxo             := TMoviFluxo.Create;
   MoviFluxo.Token       := LConfig.ConfigMovifluxo.Token;
   MoviFluxo.Homologacao := LConfig.ConfigMovifluxo.Homologacao;
   MoviFluxo.SalvarLOG   := LConfig.ConfigMovifluxo.SalvarLOG;
   MoviFluxo.UserID      := LConfig.ConfigMovifluxo.IDCliente;
   MoviFluxo.Dti         := dti;
   MoviFluxo.Dtf         := dtf;
   MoviFluxo.NSU         := '';
   MoviFluxo.Consultar;  // Consultar a conciliação
   Result := MoviFluxo.Conciliacao;
   MoviFluxo.Free;
   //---------------------------------------------------------------------------
end;

function TMulticlass.MOVIFLUXOListaLojas: TMoviFluxoListaLojas;
var
   MoviFluxo : TMoviFluxo;
begin
   MoviFluxo             := TMoviFluxo.Create;
   MoviFluxo.Token       := LConfig.ConfigMovifluxo.Token;
   MoviFluxo.Homologacao := LConfig.ConfigMovifluxo.Homologacao;
   MoviFluxo.SalvarLOG   := LConfig.ConfigMovifluxo.SalvarLOG;
   Result := MoviFluxo.SA_ListarLojas;  // Consultar a lista de lojas
   MoviFluxo.Free;
   //---------------------------------------------------------------------------
end;

function TMulticlass.SA_Cancelar_TEF_ELGIN(Cancelamento : TDadosCancelamento):boolean;
var
   TEF_Elgin : TElginTEF;
begin
   //---------------------------------------------------------------------------
   TEF_Elgin                       := SA_CriarClasseELGIN;
   //---------------------------------------------------------------------------
   TEF_Elgin.tpOperacaoADM := tpOpCancelamento;
   TEF_Elgin.CancelarNSU   := Cancelamento.NSU;
   TEF_Elgin.CancelarData  := Cancelamento.Data;
   TEF_Elgin.CancelarValor := Cancelamento.Valor;
   //---------------------------------------------------------------------------
   TEF_Elgin.SA_AdmCancelamento;
   while TEF_Elgin.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   //---------------------------------------------------------------------------
   Result := TEF_Elgin.Estornado;
   //---------------------------------------------------------------------------
   TEF_Elgin.Free;
   //---------------------------------------------------------------------------
end;

function TMulticlass.SA_Cancelar_TEF_Multiplus(Cancelamento : TDadosCancelamento): boolean;
var
   TEF_MultiPlus : TMultiPlusTEF;
begin
   //---------------------------------------------------------------------------
   TEF_MultiPlus                 := SA_CriarClasseMultiplus;
   //---------------------------------------------------------------------------
   TEF_MultiPlus.Valor           := Cancelamento.Valor;
   TEF_MultiPlus.forma           := 'CANCELAMENTO';
   TEF_MultiPlus.Cupom           := strtointdef(Cancelamento.Documento,0);
   TEF_MultiPlus.NSU             := Cancelamento.NSU;
   TEF_MultiPlus.TpOperacaoTEF   := tpMPlPerguntar;
   //---------------------------------------------------------------------------
   TEF_MultiPlus.SA_Cancelamento;    // Cartão normal
   //---------------------------------------------------------------------------
   while TEF_MultiPlus.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   //---------------------------------------------------------------------------
   Result := TEF_MultiPlus.RetornoTransacao.OperacaoExecutada;
   //---------------------------------------------------------------------------
   TEF_MultiPlus.Free;
   //---------------------------------------------------------------------------
end;

procedure TMulticlass.SA_CarregarConfig;
var
  wIni : TIniFile;
begin
   //---------------------------------------------------------------------------
   //   Definindo Default
   //---------------------------------------------------------------------------
   LConfig.ConfigServidorProd.HostServidor := 'http://www.mkmservicos.com.br'; // Host aonde a consulta será feita = http://www.mkmservicos.com.br
   //---------------------------------------------------------------------------
   if not FileExists(GetCurrentDir+'\config.ini') then
      exit;
   //---------------------------------------------------------------------------
   wIni                             := TIniFile.Create(GetCurrentDir+'\config.ini');
   LConfig.ConfigEmitente           := TEmit.create;
   //---------------------------------------------------------------------------
   //  Configurações da SH
   //---------------------------------------------------------------------------
   LConfig.ConfigSistema.Sistema   := 'Free Multiclass';
   LConfig.ConfigSistema.Versao    := '1.0';
   LConfig.ConfigSistema.EmpresaSH := 'MKM Automacao';
   //---------------------------------------------------------------------------
   //   Carregar as configurações da impressora
   //---------------------------------------------------------------------------
   LConfig.ConfigImpressora.Nome   := wIni.ReadString('KSConfigImpressora','Nome','');   // Nome da impressora selecionada para impressão
   LConfig.ConfigImpressora.Modelo := TACBrPosPrinterModelo(wIni.ReadInteger('KSConfigImpressora','Modelo',0)); // Modelo de impressora ACBRPOSPrinter
   LConfig.ConfigImpressora.Avanco := wIni.ReadInteger('KSConfigImpressora','Avanco',4); // Avanço de linhas ao final de documentos - Imaginando que tenha guilhotina, usar 3
   //---------------------------------------------------------------------------
   //   Carregar as configurações da consulta de produtos
   //---------------------------------------------------------------------------
   LConfig.ConfigServidorProd.HostServidor := wIni.ReadString('KSConfigConsultaProd','HostServidor','http://www.mkmservicos.com.br'); // Host aonde a consulta será feita = http://www.mkmservicos.com.br
   LConfig.ConfigServidorProd.ChaveLicenca := wIni.ReadString('KSConfigConsultaProd','ChaveLicenca','');                              // Cheve de autorização para consultar produtos
   //---------------------------------------------------------------------------
   // Configurações para o TEF VBI VSPague
   //---------------------------------------------------------------------------
   LConfig.ConfigTEFVSPague.Estabelecimento         := wIni.ReadString('KSConfigTEFVSPague','Estabelecimento','');                      // Código do Estabelecimento - CNPJ
   LConfig.ConfigTEFVSPague.Loja                    := wIni.ReadString('KSConfigTEFVSPague','Loja','');                                 // Código da loja - Fornecido pela VBI na solicitação do TEF
   LConfig.ConfigTEFVSPague.TerminalPDV             := wIni.ReadString('KSConfigTEFVSPague','TerminalPDV','');                          // Código do terminal
   LConfig.ConfigTEFVSPague.ComprovanteCliente      := TtpTEFImpressao(wIni.ReadInteger('KSConfigTEFVSPague','ComprovanteCliente',0));  // Impressão do comprovante do cliente
   LConfig.ConfigTEFVSPague.ComprovanteLoja         := TtpTEFImpressao(wIni.ReadInteger('KSConfigTEFVSPague','ComprovanteLoja',0));     // Impressão do comprovante do lojista
   LConfig.ConfigTEFVSPague.ComprovanteSimplificado := wIni.ReadBool('KSConfigTEFVSPague','ComprovanteSimplificado',true);         // Forma da impressão do comprovante do lojista
   LConfig.ConfigTEFVSPague.SalvarLog               := wIni.ReadBool('KSConfigTEFVSPague','SalvarLog',true);                       // Habilitar para salvar o LOG
   LConfig.ConfigTEFVSPague.Sequencial              := wIni.ReadInteger('KSConfigTEFVSPague','Sequencial',0); // Numero sequencial para cada transação - Reiniciado a cada dia
   LConfig.ConfigTEFVSPague.Data                    := wIni.ReadDate('KSConfigTEFVSPague','data',date); // Data para controlar o número sequencial
   if LConfig.ConfigTEFVSPague.Data<>date then
      LConfig.ConfigTEFVSPague.Sequencial           := 0;  // Se adata for diferente de hoje, reiniciar
   //---------------------------------------------------------------------------
   // Configurações para o TEF ELGIN HUB
   //---------------------------------------------------------------------------
   LConfig.ConfigTEFElgin.ComprovanteCliente      := TtpTEFImpressao(wIni.ReadInteger('KSConfigTEFElgin','ComprovanteCliente',0)); // Impressão do comprovante do cliente
   LConfig.ConfigTEFElgin.ComprovanteLoja         := TtpTEFImpressao(wIni.ReadInteger('KSConfigTEFElgin','ComprovanteLoja',0));    // Impressão do comprovante do lojista
   LConfig.ConfigTEFElgin.ComprovanteSimplificado := wIni.ReadBool('KSConfigTEFElgin','ComprovanteSimplificado',true);              // Forma da impressão do comprovante do lojista
   LConfig.ConfigTEFElgin.SalvarLog               := wIni.ReadBool('KSConfigTEFElgin','SalvarLog',true);                            // Habilitar para salvar o LOG
   //---------------------------------------------------------------------------
   // Configurações para o TEF Multiplus
   //---------------------------------------------------------------------------
   LConfig.ConfigTEFEMultiplus.CNPJ                    := wIni.rEADString('KSConfigTEFMultiplus','CNPJ','');                                 // CNPJ da empresa que vai transacionar o TEF
   LConfig.ConfigTEFEMultiplus.Loja                    := wIni.ReadString('KSConfigTEFMultiplus','Loja','');                                 // Código da loja fornecida pelo Multiplus
   LConfig.ConfigTEFEMultiplus.TerminalPDV             := wIni.ReadString('KSConfigTEFMultiplus','TerminalPDV','');                          // Número do terminal de PDV
   LConfig.ConfigTEFEMultiplus.ComprovanteCliente      := TtpTEFImpressao(wIni.ReadInteger('KSConfigTEFMultiplus','ComprovanteCliente',0));  // Impressão do comprovante do cliente
   LConfig.ConfigTEFEMultiplus.ComprovanteLoja         := TtpTEFImpressao(wIni.ReadInteger('KSConfigTEFMultiplus','ComprovanteLoja',0));     // Impressão do comprovante do lojista
   LConfig.ConfigTEFEMultiplus.ComprovanteSimplificado := wIni.ReadBool('KSConfigTEFMultiplus','ComprovanteSimplificado',true);              // Forma da impressão do comprovante do lojista
   LConfig.ConfigTEFEMultiplus.SalvarLog               := wIni.ReadBool('KSConfigTEFMultiplus','SalvarLog',true);                            // Habilitar para salvar o LOG
   LConfig.ConfigTEFEMultiplus.NSUTef                  := wIni.ReadInteger('KSConfigTEFMultiplus','NSUTef',0);                               // Numero sequencial para cada operação TEF
   //---------------------------------------------------------------------------
   // Configurações para o MKM PIX
   //---------------------------------------------------------------------------
   LConfig.ConfigMKMPix.CNPJ               := wIni.ReadString('KSConfigMKMPix','CNPJ','');                                 // CNPJ da empresa que vai transacionar o TEF wIni.WriteString('TKSConfigMKMPix','Token','Codigo_token');               //: string;  // Código da loja, fornecida pela MKM
   LConfig.ConfigMKMPix.SecretKey          := wIni.ReadString('KSConfigMKMPix','SecretKey','');                            // SecretKey - Fornecido pela MKM
   LConfig.ConfigMKMPix.Token              := wIni.ReadString('KSConfigMKMPix','Token','');                                // SecretKey - Fornecido pela MKM
   LConfig.ConfigMKMPix.ComprovanteCliente := TtpTEFImpressao(wIni.ReadInteger('KSConfigMKMPix','ComprovanteCliente',0));  // Impressão do comprovante do cliente
   LConfig.ConfigMKMPix.ComprovanteLoja    := TtpTEFImpressao(wIni.ReadInteger('KSConfigMKMPix','ComprovanteLoja',0));     // Impressão do comprovante do lojista
   LConfig.ConfigMKMPix.SalvarLog          := wIni.ReadBool('KSConfigMKMPix','SalvarLog',true);                            // Habilitar para salvar o LOG
   //---------------------------------------------------------------------------
   //   Configuração com o SMART POS VERO
   //---------------------------------------------------------------------------
   LConfig.ConfigSMARTTEFVero.MerchatDocumentNumber   := wIni.ReadString('KSConfigFormaSMARTVERO','MerchatDocumentNumber','');               // CNPJ da empresa que vai usar o TEF
   LConfig.ConfigSMARTTEFVero.PdvToken                := wIni.ReadString('KSConfigFormaSMARTVERO','PdvToken','');// string;                  // Código de homologação da Software House - Fornecido pela VERO/BANRISUL
   LConfig.ConfigSMARTTEFVero.DeviceToken             := wIni.ReadString('KSConfigFormaSMARTVERO','DeviceToken','');                         // Número de autorização do POS - Obtida ao instalar o VERO CLIENT na maquininha POS
   LConfig.ConfigSMARTTEFVero.ComprovanteCliente      := TtpTEFImpressao(wIni.ReadInteger('KSConfigFormaSMARTVERO','ComprovanteCliente',0)); // Impressão do comprovante do cliente
   LConfig.ConfigSMARTTEFVero.ComprovanteLoja         := TtpTEFImpressao(wIni.ReadInteger('KSConfigFormaSMARTVERO','ComprovanteLoja',0));    // Impressão do comprovante do lojista
   LConfig.ConfigSMARTTEFVero.ComprovanteSimplificado := wIni.ReadBool('KSConfigFormaSMARTVERO','ComprovanteSimplificado',true);             // Forma da impressão do comprovante do lojista
   LConfig.ConfigSMARTTEFVero.SalvarLog               := wIni.ReadBool('KSConfigFormaSMARTVERO','SalvarLog',true);                           // Habilitar para salvar o LOG
   //---------------------------------------------------------------------------
   //   Configurações do TEF Embed-IT
   //---------------------------------------------------------------------------
   LConfig.ConfigEmbedIT.CodigoAtivacao     := wIni.ReadString('KSConfigEmbedIT','CodigoAtivacao','');                      // gerado pelo time de integração
   LConfig.ConfigEmbedIT.Username           := wIni.ReadString('KSConfigEmbedIT','Username','');                            // gerado pelo time de integração
   LConfig.ConfigEmbedIT.password           := wIni.ReadString('KSConfigEmbedIT','password','');                            // gerado pelo time de integração
   LConfig.ConfigEmbedIT.DeviceSerial       := wIni.ReadString('KSConfigEmbedIT','DeviceSerial','');;                       // obtido através da aplicação PDV Mobi no POS
   LConfig.ConfigEmbedIT.CNPJPIX            := wIni.ReadString('KSConfigEmbedIT','CNPJPIX','');                            //
   LConfig.ConfigEmbedIT.ChavePIX           := wIni.ReadString('KSConfigEmbedIT','ChavePIX','');                            //
   LConfig.ConfigEmbedIT.UsernamePIX        := wIni.ReadString('KSConfigEmbedIT','UserNamePIX','');                            //
   LConfig.ConfigEmbedIT.PasswordPIX        := wIni.ReadString('KSConfigEmbedIT','PasswordPIX','');                            //
   LConfig.ConfigEmbedIT.AmbientePIX        := TEMBEDAmbiente(wIni.ReadInteger('KSConfigEmbedIT','AmbientePIX',0));                            //
   LConfig.ConfigEmbedIT.ComprovanteCliente := TtpTEFImpressao(wIni.ReadInteger('KSConfigEmbedIT','ComprovanteCliente',0)); // Impressão do comprovante do cliente
   LConfig.ConfigEmbedIT.ComprovanteLoja    := TtpTEFImpressao(wIni.ReadInteger('KSConfigEmbedIT','ComprovanteLoja',0));    // Impressão do comprovante do lojista
   LConfig.ConfigEmbedIT.SalvarLog          := wIni.ReadBool('KSConfigEmbedIT','SalvarLog',true);                           // Habilitar para salvar o LOG
   //---------------------------------------------------------------------------
   LConfig.ConfigPinPad.PINPAD_Porta       := wIni.ReadString('KSConfigPinPad','Porta','');
   LConfig.ConfigPinPad.PINPAD_Baud        := wIni.ReadInteger('KSConfigPinPad','Baud',9600);
   LConfig.ConfigPinPad.PINPAD_DataBits    := wIni.ReadInteger('KSConfigPinPad','DataBits',8);
   LConfig.ConfigPinPad.PINPAD_StopBit     := TACBrSerialStop(wIni.ReadInteger('KSConfigPinPad','StopBit',0));
   LConfig.ConfigPinPad.PINPAD_Parity      := TACBrSerialParity(wIni.ReadInteger('KSConfigPinPad','Parity',0));
   LConfig.ConfigPinPad.PINPAD_HandShaking := TACBrHandShake(wIni.ReadInteger('KSConfigPinPad','HandShaking',0));
   LConfig.ConfigPinPad.PINPAD_SoftFlow    := wIni.ReadBool('KSConfigPinPad','SoftFlow',false);
   LConfig.ConfigPinPad.PINPAD_HardFlow    := wIni.ReadBool('KSConfigPinPad','HardFlow',false);
   LConfig.ConfigPinPad.PINPAD_Imagem      := wIni.ReadString('KSConfigPinPad','Imagem','');
   //---------------------------------------------------------------------------
   LConfig.ConfigEmitente.CNPJCPF                      := wIni.ReadString('KSConfigEmitente','CNPJCPF','');
   LConfig.ConfigEmitente.xNome                        := wIni.ReadString('KSConfigEmitente','xNome','');
   LConfig.ConfigEmitente.xFant                        := wIni.ReadString('KSConfigEmitente','xFant','');
   LConfig.ConfigEmitente.EnderEmit.xLgr               := wIni.ReadString('KSConfigEmitente','xLgr','');
   LConfig.ConfigEmitente.EnderEmit.nro                := wIni.ReadString('KSConfigEmitente','nro','');
   LConfig.ConfigEmitente.EnderEmit.xCpl               := wIni.ReadString('KSConfigEmitente','xCpl','');
   LConfig.ConfigEmitente.EnderEmit.xMun               := wIni.ReadString('KSConfigEmitente','xMun','');
   LConfig.ConfigEmitente.EnderEmit.UF                 := wIni.ReadString('KSConfigEmitente','UF','');
   LConfig.ConfigEmitente.EnderEmit.CEP                := wIni.ReadInteger('KSConfigEmitente','CEP',0);
   LConfig.ConfigEmitente.EnderEmit.fone               := wIni.ReadString('KSConfigEmitente','fone','');
   LConfig.ConfigEmitente.IE                           := wIni.ReadString('KSConfigEmitente','IE','');
   //---------------------------------------------------------------------------
   Lconfig.ConfigMovifluxo.Token                       := wIni.ReadString('KSConfigMovifluxo','Token','');
   Lconfig.ConfigMovifluxo.IDCliente                   := wIni.ReadString('KSConfigMovifluxo','IDCliente','');
   Lconfig.ConfigMovifluxo.Homologacao                 := wIni.ReadBool('KSConfigMovifluxo','Homologacao',false);
   Lconfig.ConfigMovifluxo.SalvarLOG                   := wIni.ReadBool('KSConfigMovifluxo','SalvarLOG',true);
   //---------------------------------------------------------------------------

end;


function TMulticlass.SA_CriarClasseELGIN : TElginTEF;
begin
   Result := TElginTEF.Create;
   //---------------------------------------------------------------------------
   Result.TEFTextoPinPad        := LConfig.ConfigSistema.EmpresaSH;
   Result.TEFSistema            := LConfig.ConfigSistema.Sistema;
   Result.TEFSistemaVersao      := LConfig.ConfigSistema.Versao;
   //---------------------------------------------------------------------------
   Result.TEFEstabelecimento    := LConfig.ConfigEmitente.CNPJCPF;
   if LConfig.ConfigEmitente.xFant<>'' then
      Result.TEFEstabelecimento := LConfig.ConfigEmitente.xFant
   else
      Result.TEFEstabelecimento := LConfig.ConfigEmitente.xNome;
   Result.TEFLoja              := '01';
   Result.TEFIdCliente         := IntToHex(strtointdef(copy(LConfig.ConfigEmitente.CNPJCPF,1,5),0),5);
   Result.ComprovanteLoja      := LConfig.ConfigTEFElgin.ComprovanteLoja;
   Result.ComprovanteCliente   := LConfig.ConfigTEFElgin.ComprovanteCliente;
   Result.SalvarLog            := LConfig.ConfigTEFElgin.SalvarLog;
   Result.ViaLojaSimplificada  := LConfig.ConfigTEFElgin.ComprovanteSimplificado;
   Result.Impressora           := LConfig.ConfigImpressora;
   Result.SA_Configurar_TEF;
   //---------------------------------------------------------------------------
end;

function TMulticlass.SA_CriarClasseEmbed: TEmbedIT;
begin
   //---------------------------------------------------------------------------
   Result := TEmbedIT.Create;
   Result.POSUsername               := lconfig.ConfigEmbedIT.Username;
   Result.POSPassword               := lconfig.ConfigEmbedIT.password;
   Result.POSNumeroSerial           := lconfig.ConfigEmbedIT.DeviceSerial;
   Result.EmbedPagueImpressaoViaCLI := lconfig.ConfigEmbedIT.ComprovanteCliente;
   Result.EmbedPagueImpressaoViaLJ  := lconfig.ConfigEmbedIT.ComprovanteLoja;
   Result.SalvarLog                 := lconfig.ConfigEmbedIT.SalvarLog;
   Result.ImpressaoSimplificada     := false;
   Result.CodigoAtivacao            := lconfig.ConfigEmbedIT.CodigoAtivacao;
   Result.Impressora                := LConfig.ConfigImpressora;   // Configuração da impressora
   //---------------------------------------------------------------------------
end;

function TMulticlass.SA_CriarClasseMultiplus: TMultiPlusTEF;
begin
   //---------------------------------------------------------------------------
   Result                             := TMultiPlusTEF.Create;
   Result.IComprovanteCliente         := LConfig.ConfigTEFEMultiplus.ComprovanteCliente;
   Result.IComprovanteLoja            := LConfig.ConfigTEFEMultiplus.ComprovanteLoja;
   Result.ComprovanteLojaSimplificado := LConfig.ConfigTEFEMultiplus.ComprovanteSimplificado;
   Result.CNPJ                        := LConfig.ConfigTEFEMultiplus.CNPJ;
   Result.CodigoLoja                  := LConfig.ConfigTEFEMultiplus.Loja;
   Result.Pdv                         := LConfig.ConfigTEFEMultiplus.TerminalPDV;
   Result.SalvarLog                   := LConfig.ConfigTEFEMultiplus.SalvarLog;
   Result.ConfigPinPad                := LConfig.ConfigPinPad;
   Result.Impressora                  := LConfig.ConfigImpressora;
   //---------------------------------------------------------------------------
end;

function TMulticlass.SA_CriarClasseVBI : TVSPagueTEF;
begin
   //---------------------------------------------------------------------------
   Result                       := TVSPagueTEF.Create;
   Result.Versao                := LConfig.ConfigSistema.Versao;
   Result.Aplicacao             := LConfig.ConfigSistema.Versao;
   Result.Estabelecimento       := LConfig.ConfigTEFVSPague.Estabelecimento;
   Result.loja                  := LConfig.ConfigTEFVSPague.Loja;
   Result.Terminal              := LConfig.ConfigTEFVSPague.TerminalPDV;
   //---------------------------------------------------------------------------
   Result.ImpressaoViaCliente   := LConfig.ConfigTEFVSPague.ComprovanteCliente;
   Result.ImpressaoViaLoja      := LConfig.ConfigTEFVSPague.ComprovanteLoja;
   Result.ImpressaoSimplificada := LConfig.ConfigTEFVSPague.ComprovanteSimplificado;
   Result.SalvarLog             := LConfig.ConfigTEFVSPague.SalvarLog;
   //---------------------------------------------------------------------------
end;

function TMulticlass.SA_CriarClasseVero: TVEROSmartTEF;
begin
   //---------------------------------------------------------------------------
   Result := TVEROSmartTEF.Create;
   //---------------------------------------------------------------------------
   Result.ComprovanteCliente          := LConfig.ConfigSMARTTEFVero.ComprovanteCliente; //tVEROImpressaoPerguntar;
   Result.ComprovanteLoja             := LConfig.ConfigSMARTTEFVero.ComprovanteLoja; //tVEROImpressaoPerguntar;
   Result.ComprovanteLojaSimplificado := LConfig.ConfigSMARTTEFVero.ComprovanteSimplificado;
   Result.SalvarLog                   := LConfig.ConfigSMARTTEFVero.SalvarLog;
   //---------------------------------------------------------------------------
   Result.Pagamento_Mensagem  := LConfig.ConfigSistema.Sistema;
   //---------------------------------------------------------------------------
   Result.pdvToken                 := LConfig.ConfigSMARTTEFVero.PdvToken;    // Token da aplicação recebida na homologação
   Result.deviceToken              := LConfig.ConfigSMARTTEFVero.DeviceToken; // Token da maquininha
   Result.merchantDocumentNumber   := LConfig.ConfigSMARTTEFVero.MerchatDocumentNumber;  // CNPJ do cliente usuário
   Result.Impressora               := LConfig.ConfigImpressora;                          //  Configuração da impressora
   //---------------------------------------------------------------------------
end;

function TMulticlass.SA_EBEDCancelar(Cancelamento: TDadosCancelamento): boolean;
var
   EMBED   : TEmbedIT;
begin
   //---------------------------------------------------------------------------
   EMBED := SA_CriarClasseEmbed;
   //---------------------------------------------------------------------------
   EMBED.Cancelamento_Forma        := 'CANCELAMENTO';
   EMBED.Cancelamento_Valor        := Cancelamento.Valor;
   EMBED.Cancelamento_NSU          := Cancelamento.NSU;
   EMBED.Cancelamento_Data         := Cancelamento.Data;
   //---------------------------------------------------------------------------
   EMBED.SA_ProcessarCancelamento;
   while EMBED.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   //---------------------------------------------------------------------------
   Result := EMBED.RespostaTEF.Resultado.TEFAprovado;
   //---------------------------------------------------------------------------
   EMBED.Free;
   //---------------------------------------------------------------------------
end;

function TMulticlass.SA_ELGINPagar(forma: TPagamentoFoma): TRetornoPagamentoTEF;
var
   TEF_Elgin : TElginTEF;
begin
   //---------------------------------------------------------------------------
   TEF_Elgin                       := SA_CriarClasseELGIN;
   //---------------------------------------------------------------------------
   TEF_Elgin.Valor                := forma.Valor;
   TEF_Elgin.Forma                := forma.Forma;
   TEF_Elgin.FormaPgto            := forma.FormaElgin;
   TEF_Elgin.QtdeParcelas         := forma.Parcelas;
   //---------------------------------------------------------------------------
//   TEF_Elgin.SA_Configurar_TEF;
   if TEF_Elgin.FormaPgto<>ElginPgtoPIX then  // Se não for PIX fazer transação com cartão normal
      TEF_Elgin.SA_ProcessarPagamento    // Cartão normal
   else
      TEF_Elgin.SA_PagamentoPIX;   // Pagamento PIX
   //---------------------------------------------------------------------------
   while TEF_Elgin.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   //---------------------------------------------------------------------------
   Result := TEF_Elgin.RetornoTEF;
   //---------------------------------------------------------------------------
   TEF_Elgin.Free;
   //---------------------------------------------------------------------------
end;

function TMulticlass.SA_EmbedITPagar(forma: TPagamentoFoma): TRetornoPagamentoTEF;
var
   EMBED     : TEmbedIT;
begin
   //---------------------------------------------------------------------------
   EMBED := SA_CriarClasseEmbed;
{
   EMBED := TEmbedIT.Create;
   EMBED.POSUsername               := lconfig.ConfigEmbedIT.Username;
   EMBED.POSPassword               := lconfig.ConfigEmbedIT.password;
   EMBED.POSNumeroSerial           := lconfig.ConfigEmbedIT.DeviceSerial;
   EMBED.EmbedPagueImpressaoViaCLI := lconfig.ConfigEmbedIT.ComprovanteCliente;
   EMBED.EmbedPagueImpressaoViaLJ  := lconfig.ConfigEmbedIT.ComprovanteLoja;
   EMBED.SalvarLog                 := lconfig.ConfigEmbedIT.SalvarLog;
   EMBED.ImpressaoSimplificada     := false;
}
   if forma.Evento=tpKSEventoTEFEmbedIT then
      EMBED.TipoTEF                := EmbedTEF
   else if forma.Evento=tpKSEventoSmartTEFEmbedIT then
      EMBED.TipoTEF                := EmbedPOS;
   //---------------------------------------------------------------------------
//   EMBED.CodigoAtivacao   := lconfig.ConfigEmbedIT.CodigoAtivacao;
   //---------------------------------------------------------------------------
   EMBED.Pagamento_Forma        := forma.Forma;
   EMBED.Pagamento_Valor        := forma.Valor;
   EMBED.Pagamento_Operacao     := forma.FormaEmbed;
   EMBED.Pagamento_QtdeParcelas := forma.Parcelas;
//   EMBED.Impressora             := LConfig.ConfigImpressora;   // Configuração da impressora
   //---------------------------------------------------------------------------
   EMBED.SA_ProcessarPagamento;
   while EMBED.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   //---------------------------------------------------------------------------
   Result.Status          := EMBED.RespostaTEF.Resultado.TEFAprovado;
   Result.NSU             := EMBED.RespostaTEF.Resultado.nsu;
   Result.Nome_do_Produto := EMBED.RespostaTEF.Resultado.rede;
   Result.cAut            := EMBED.RespostaTEF.Resultado.codigo_autorizacao;
   Result.rede            := EMBED.RespostaTEF.Resultado.rede;
   Result.Bandeira        := EMBED.RespostaTEF.Resultado.bandeira;
   Result.CNPJAdquirente  := ''; //EMBED.RespostaTEF.Resultado.
   Result.ComprovanteLoja := EMBED.RespostaTEF.Resultado.via_loja;
   Result.ComprovanteCli  := EMBED.RespostaTEF.Resultado.via_cliente;
   Result.ComprovanteRed  := EMBED.RespostaTEF.Resultado.ComprovanteLoja;
   //---------------------------------------------------------------------------
   EMBED.Free;
   //---------------------------------------------------------------------------

end;

function TMulticlass.SA_EmbedPIXPagar(forma: TPagamentoFoma): TRetornoPagamentoTEF;
var
   PIXEmbed : TEmbedPIX;
begin
   //---------------------------------------------------------------------------
   PIXEmbed := TEmbedPIX.create;
   //---------------------------------------------------------------------------
   PIXEmbed.Impressora              := LConfig.ConfigImpressora;
   PIXEmbed.ConfigPinPad            := LConfig.ConfigPinPad;
   PIXEmbed.Emitente                := LConfig.ConfigEmitente;
   PIXEmbed.ConfigImpressaoViaCLI   := LConfig.ConfigEmbedIT.ComprovanteCliente;
   PIXEmbed.ConfigImpressaoViaLJ    := LConfig.ConfigEmbedIT.ComprovanteLoja;;
   PIXEmbed.SalvarLog               := LConfig.ConfigEmbedIT.SalvarLog;
   //---------------------------------------------------------------------------
   PIXEmbed.Forma := forma.Forma;
   PIXEmbed.Valor := forma.Valor;
   PIXEmbed.Tempo := 360;
   //---------------------------------------------------------------------------
   PIXEmbed.ConfigCNPJ     := LConfig.ConfigEmbedIT.CNPJPIX;
   PIXEmbed.ConfigChave    := LConfig.ConfigEmbedIT.ChavePIX;
   PIXEmbed.ConfigUsername := LConfig.ConfigEmbedIT.UsernamePIX;
   PIXEmbed.ConfigPassword := LConfig.ConfigEmbedIT.PasswordPIX;
   PIXEmbed.ConfigAmbiente := LConfig.ConfigEmbedIT.AmbientePIX;
   //---------------------------------------------------------------------------
   PIXEmbed.SA_EfetuarPagamento;
   while PIXEmbed.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   //---------------------------------------------------------------------------
   Result.Status := PIXEmbed.RetornoPIX.E2E<>'';
   //---------------------------------------------------------------------------
   PIXEmbed.Destroy;
   //---------------------------------------------------------------------------

end;

function TMulticlass.SA_InternetConectada: boolean;
var
   http      : THTTPClient;
begin
   Result               := false;
   http                 := THTTPClient.Create;
   http.ResponseTimeout := 1000;
   try
      Result := http.head('https://google.com').StatusCode<400;
   except
   end;
   http.DisposeOf;
   //---------------------------------------------------------------------------
end;


function TMulticlass.SA_MKMPixPagar(forma: TPagamentoFoma): TRetornoPagamentoTEF;
var
   MKMPix : TMKMPix;
begin
   //---------------------------------------------------------------------------
   MKMPix                             := TMKMPix.Create;
   MKMPix.Forma                       := forma.Forma;
   MKMPix.Valor                       := forma.valor;
   MKMPix.Tempo                       := 360;
   MKMPix.Chave                       := LConfig.ConfigServidorProd.ChaveLicenca;
   MKMPix.CNPJ                        := LConfig.ConfigMKMPix.CNPJ; //
   //---------------------------------------------------------------------------
   MKMPix.HostMKMPIX                  := LConfig.ConfigServidorProd.HostServidor; // 'http://www.mkmservicos.com.br';
   MKMPix.SalvarLog                   := LConfig.ConfigMKMPix.SalvarLog;
   MKMPix.ImprimirViaCliente          := LConfig.ConfigMKMPix.ComprovanteCliente;
   MKMPix.ImprimirViaLoja             := LConfig.ConfigMKMPix.ComprovanteLoja;
   //---------------------------------------------------------------------------
   MKMPix.ConfigPinPad                := LConfig.ConfigPinPad;        // Definindo as configurações do PINPAD
   MKMPix.Impressora                  := LConfig.ConfigImpressora;    // Confgurações da impressora
   MKMPix.Emitente                    := LConfig.ConfigEmitente;      // Configuração do emitente
   //---------------------------------------------------------------------------
   MKMPix.SA_ProcessarPagamento;    // Executar o pagamento PIX
   //---------------------------------------------------------------------------
   while MKMPix.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   //---------------------------------------------------------------------------
   Result.Status          := MKMPix.E2E<>'';
   Result.NSU             := '';
   Result.Nome_do_Produto := 'MKM PIX';
   Result.cAut            := '';
   Result.rede            := '';
   Result.Bandeira        := '';
   Result.CNPJAdquirente  := '23114447000197';
   Result.E2E             := MKMPix.E2E;
   Result.TxID            := MKMPix.TxID;
   Result.ComprovanteLoja := MKMPix.ComprovanteLoja.Text;
   Result.ComprovanteCli  := MKMPix.ComprovanteCliente.Text;
   Result.ComprovanteRed  := MKMPix.ComprovanteLoja.Text;
   //---------------------------------------------------------------------------
   MKMPix.Free;
   //---------------------------------------------------------------------------
end;

function TMulticlass.SA_MKMVeroSmartCancelar(Cancelamento: TDadosCancelamento): boolean;
var
   VEROSmartTEF : TVEROSmartTEF;
begin
   //---------------------------------------------------------------------------
   VEROSmartTEF := SA_CriarClasseVero;
   //---------------------------------------------------------------------------
   VEROSmartTEF.Cancelamento_NSU    := Cancelamento.NSU;
   VEROSmartTEF.Cancelamento_Valor  := Cancelamento.Valor;
   VEROSmartTEF.Cancelamento_Forma  := 'CANCELAMENTO';
   VEROSmartTEF.Pagamento_Mensagem  := 'MKM - CANCELAMENTO R$ '+trim(transform(Cancelamento.Valor));
   //---------------------------------------------------------------------------
   VEROSmartTEF.SA_ProcessarCancelamento;
   while VEROSmartTEF.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   //---------------------------------------------------------------------------
   Result := VEROSmartTEF.Resp.auth_code<>'';
   //---------------------------------------------------------------------------
   VEROSmartTEF.Destroy;
   //---------------------------------------------------------------------------
end;

function TMulticlass.SA_MKMVeroSmartPagar(forma: TPagamentoFoma): TRetornoPagamentoTEF;
var
   VEROSmartTEF : TVEROSmartTEF;
begin
   //---------------------------------------------------------------------------

   VEROSmartTEF := SA_CriarClasseVero;
{
   VEROSmartTEF := TVEROSmartTEF.Create;
   //---------------------------------------------------------------------------
   VEROSmartTEF.ComprovanteCliente          := LConfig.ConfigSMARTTEFVero.ComprovanteCliente; //tVEROImpressaoPerguntar;
   VEROSmartTEF.ComprovanteLoja             := LConfig.ConfigSMARTTEFVero.ComprovanteLoja; //tVEROImpressaoPerguntar;
   VEROSmartTEF.ComprovanteLojaSimplificado := LConfig.ConfigSMARTTEFVero.ComprovanteSimplificado;
   VEROSmartTEF.SalvarLog                   := LConfig.ConfigSMARTTEFVero.SalvarLog;
}
   //---------------------------------------------------------------------------
   VEROSmartTEF.Pagamento_Forma     := forma.Forma;
   VEROSmartTEF.Pagamento_Valor     := forma.Valor;
   VEROSmartTEF.Pagamento_Parcelas  := forma.Parcelas;
   VEROSmartTEF.Pagamento_Pedido    := '';
   VEROSmartTEF.Pagamento_FormaTEF  := forma.FormaVero; //tpVERODebito;
   VEROSmartTEF.Pagamento_PrazoPre  := 0;
   VEROSmartTEF.Pagamento_DiaMensal := 0;
//   VEROSmartTEF.Pagamento_Mensagem  := LConfig.ConfigSistema.Sistema;
   //---------------------------------------------------------------------------
{
   VEROSmartTEF.pdvToken                 := LConfig.ConfigSMARTTEFVero.PdvToken;    // Token da aplicação recebida na homologação
   VEROSmartTEF.deviceToken              := LConfig.ConfigSMARTTEFVero.DeviceToken; // Token da maquininha
   VEROSmartTEF.merchantDocumentNumber   := LConfig.ConfigSMARTTEFVero.MerchatDocumentNumber;  // CNPJ do cliente usuário
   VEROSmartTEF.Impressora               := LConfig.ConfigImpressora;                          //  Configuração da impressora
}
   //---------------------------------------------------------------------------
   VEROSmartTEF.SA_ProcessarPagamento;
   while VEROSmartTEF.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   //---------------------------------------------------------------------------
   Result.Status          := VEROSmartTEF.Resp.auth_code<>'';
   Result.NSU             := VEROSmartTEF.Resp.nsu;
   Result.Nome_do_Produto := VEROSmartTEF.Resp.transaction_name;
   Result.cAut            := VEROSmartTEF.Resp.auth_code;
   Result.rede            := 'VERO';
   Result.Bandeira        := VEROSmartTEF.Resp.card_brand;
   Result.CNPJAdquirente  := '92934215000106';
   Result.ComprovanteLoja := VEROSmartTEF.Resp.ComprovanteLoja.Text;
   Result.ComprovanteCli  := VEROSmartTEF.Resp.ComprovanteCliente.Text;
   Result.ComprovanteRed  := VEROSmartTEF.Resp.ComprovanteSimplificado.Text;
   //---------------------------------------------------------------------------
   VEROSmartTEF.Destroy;
   //---------------------------------------------------------------------------

end;

function TMulticlass.SA_Mov_NSUTEF: integer;   // Função que incrementa o NSU e salva no arquivo INI
var
  wIni: TIniFile;
begin
   inc(LConfig.ConfigTEFEMultiplus.NSUTef);
   Result := LConfig.ConfigTEFEMultiplus.NSUTef;
   wIni := TIniFile.Create(GetCurrentDir+'\config.ini');
   wIni.WriteInteger('KSConfigTEFMultiplus','NSUTef',LConfig.ConfigTEFEMultiplus.NSUTef); // Numero sequencial para cada transação
   wIni.Free;
end;


function TMulticlass.SA_Mov_VBISequencial: integer;
var
  wIni : TIniFile;
begin
   inc(LConfig.ConfigTEFVSPague.Sequencial);
   Result := LConfig.ConfigTEFEMultiplus.NSUTef;
   wIni := TIniFile.Create(GetCurrentDir+'\config.ini');
   wIni.WriteInteger('KSConfigTEFVSPague','Sequencial',LConfig.ConfigTEFVSPague.Sequencial); // Numero sequencial para cada transação
   wIni.WriteDate('KSConfigTEFVSPague','data',date); // Numero sequencial para cada transação
   wIni.Free;
end;

function TMulticlass.SA_MultiPlusPagar(forma : TPagamentoFoma): TRetornoPagamentoTEF;
var
   TEF_MultiPlus : TMultiPlusTEF;
begin
   //---------------------------------------------------------------------------
   TEF_MultiPlus                 := SA_CriarClasseMultiplus;
   //---------------------------------------------------------------------------
   TEF_MultiPlus.Valor           := forma.Valor;
   TEF_MultiPlus.forma           := forma.Forma;
   TEF_MultiPlus.Cupom           := SA_Mov_NSUTEF;
   TEF_MultiPlus.NSU             := LConfig.ConfigTEFEMultiplus.NSUTef.ToString;
   TEF_MultiPlus.TpOperacaoTEF   := tpMPlCreditoVista;
   //---------------------------------------------------------------------------
   TEF_MultiPlus.TpOperacaoTEF   := forma.FormaMultiplus;
   TEF_MultiPlus.Parcela         := forma.Parcelas;
   TEF_MultiPlus.Impressora      := LConfig.ConfigImpressora;
   TEF_MultiPlus.SA_ProcessarPagamento;    // Cartão normal
   //---------------------------------------------------------------------------
   while TEF_MultiPlus.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   //---------------------------------------------------------------------------
   Result.Status          := (TEF_MultiPlus.RetornoTransacao.NSU<>'') or (TEF_MultiPlus.RetornoTransacao.E2E<>'');
   Result.NSU             := TEF_MultiPlus.RetornoTransacao.NSU;
   Result.Nome_do_Produto := TEF_MultiPlus.RetornoTransacao.NOME_REDE;
   Result.cAut            := TEF_MultiPlus.RetornoTransacao.COD_AUTORIZACAO;
   Result.rede            := TEF_MultiPlus.RetornoTransacao.NOME_REDE;
   Result.Bandeira        := TEF_MultiPlus.RetornoTransacao.NOME_BANDEIRA;
   Result.CNPJAdquirente  := TEF_MultiPlus.RetornoTransacao.CNPJ_AUTORIZADORA;
   Result.ComprovanteLoja := TEF_MultiPlus.RetornoTransacao.ComprovanteLoja.Text;
   Result.ComprovanteCli  := TEF_MultiPlus.RetornoTransacao.COMPROVANTE.Text;
   Result.ComprovanteRed  := TEF_MultiPlus.RetornoTransacao.ComprovanteLoja.Text;
   //---------------------------------------------------------------------------
   TEF_MultiPlus.Free;
   //---------------------------------------------------------------------------
end;

function TMulticlass.SA_VBICancelar(cancelamento: TDadosCancelamento): boolean;
var
   TEF_VSPague : TVSPagueTEF;
begin
   //---------------------------------------------------------------------------
   TEF_VSPague                    := SA_CriarClasseVBI;
   TEF_VSPague.Pagamento_Forma    := 'CANCELAMENTO';
   TEF_VSPague.CancelamentoValor  := Cancelamento.Valor;
   TEF_VSPague.CancelamentoNSU    := cancelamento.NSU;
   TEF_VSPague.CancelamentoData   := Cancelamento.Data;
   TEF_VSPague.Sequencial         := SA_Mov_VBISequencial;
   //---------------------------------------------------------------------------
   if not cancelamento.pix then
      TEF_VSPague.SA_ProcessarCancelamentoVS
   else
      TEF_VSPague.SA_ProcessarCancelamentoPIXVS;
   //---------------------------------------------------------------------------
   while TEF_VSPague.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   //---------------------------------------------------------------------------
   Result := TEF_VSPague.ExecutouCancelamento;
   //---------------------------------------------------------------------------
   TEF_VSPague.Free;
end;

function TMulticlass.SA_VBIPagar(forma: TPagamentoFoma): TRetornoPagamentoTEF;
var
   TEF_VSPague : TVSPagueTEF;
begin
   //---------------------------------------------------------------------------
   TEF_VSPague                        := SA_CriarClasseVBI;
   TEF_VSPague.Pagamento_Forma        := forma.Forma;
   TEF_VSPague.Pagamento_Valor        := forma.Valor;
   TEF_VSPague.Sequencial             := SA_Mov_VBISequencial;
   TEF_VSPague.Pagamento_Operacao     := forma.FormaVSPague;
   TEF_VSPague.Pagamento_QtdeParcelas := forma.Parcelas;
   //---------------------------------------------------------------------------
   if TEF_VSPague.Pagamento_Operacao=VSPgtoPIX then
      TEF_VSPague.SA_ProcessarPagamentoPIXVS
   else
      TEF_VSPague.SA_ProcessarPagamentoVS;
   //---------------------------------------------------------------------------
   while TEF_VSPague.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   //---------------------------------------------------------------------------
   Result.Status           := TEF_VSPague.TEFAprovado;
   Result.NSU              := TEF_VSPague.RetornoSolicitacaoVenda.Transacao_nsu;
   Result.Nome_do_Produto  := TEF_VSPague.RetornoSolicitacaoVenda.transacao_produto;
   Result.cAut             := TEF_VSPague.RetornoSolicitacaoVenda.Transacao_autorizacao;
   Result.rede             := TEF_VSPague.RetornoSolicitacaoVenda.Transacao_administradora;
   Result.Bandeira         := TEF_VSPague.RetornoSolicitacaoVenda.Transacao_rede;
   Result.CNPJAdquirente   := TEF_VSPague.RetornoSolicitacaoVenda.transacao_rede_cnpj;
   Result.E2E              := '';
   Result.TxID             := '';
   Result.ComprovanteLoja  := TEF_VSPague.RetornoSolicitacaoVenda.Transacao_Comprovante1via;
   Result.ComprovanteCli   := TEF_VSPague.RetornoSolicitacaoVenda.Transacao_Comprovante2via;
   Result.ComprovanteRed   := TEF_VSPague.RetornoSolicitacaoVenda.ComprovanteLoja;
   if TEF_VSPague.Pagamento_Operacao=VSPgtoPIX then
      begin
         Result.NSU              := TEF_VSPague.RetornoSolicitacaoPIX.Transacao_nsu;
         Result.Nome_do_Produto  := TEF_VSPague.RetornoSolicitacaoPIX.transacao_produto;
         Result.cAut             := TEF_VSPague.RetornoSolicitacaoPIX.transacao_autorizacao;
         Result.rede             := TEF_VSPague.RetornoSolicitacaoPIX.transacao_rede;
         Result.Bandeira         := TEF_VSPague.RetornoSolicitacaoPIX.transacao_rede;
         Result.CNPJAdquirente   := SA_Limpacampo(TEF_VSPague.RetornoSolicitacaoPIX.transacao_rede_cnpj);
      end;
   //---------------------------------------------------------------------------
   TEF_VSPague.Free;

end;


procedure TMulticlass.VSPagueExtrato;
var
   TEF_VSPague : TVSPagueTEF;
begin
   //---------------------------------------------------------------------------
   TEF_VSPague                    := SA_CriarClasseVBI;
   TEF_VSPague.Pagamento_Forma    := 'EXTRATO';
   TEF_VSPague.CancelamentoValor  := 0;
   TEF_VSPague.Sequencial         := SA_Mov_VBISequencial;
   //---------------------------------------------------------------------------
   TEF_VSPague.SA_ProcessarExtratoVS;
   //---------------------------------------------------------------------------
   while TEF_VSPague.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   //---------------------------------------------------------------------------
   TEF_VSPague.Free;
end;

procedure TMulticlass.VSPaguePendencias;
var
   TEF_VSPague : TVSPagueTEF;
begin
   //---------------------------------------------------------------------------
   TEF_VSPague                    := SA_CriarClasseVBI;
   TEF_VSPague.Pagamento_Forma    := 'PENDENCIAS';
   TEF_VSPague.CancelamentoValor  := 0;
   TEF_VSPague.Sequencial         := SA_Mov_VBISequencial;
   //---------------------------------------------------------------------------
   TEF_VSPague.SA_ProcessarPendenciasVS;
   //---------------------------------------------------------------------------
   while TEF_VSPague.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   //---------------------------------------------------------------------------
   TEF_VSPague.Free;
end;

end.
