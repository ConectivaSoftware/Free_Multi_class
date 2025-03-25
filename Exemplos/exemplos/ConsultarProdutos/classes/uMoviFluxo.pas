unit uMoviFluxo;

interface

Uses
   uMulticlassFuncoes,
   uKSTypes,
   System.JSON,
   RESTRequest4d,
   IPPeerClient,
   IPPeerCommon,
   System.Classes,
   System.SysUtils;


Type
   TMoviFluxo = class
      const
         URLProd = 'https://movifluxo/api/v2';
         URLHml  = 'https://sandbox.movifluxo.com.br/api/v2';
      private
         URL          : string; // URL que o sistema vai operar
         //---------------------------------------------------------------------
         LToken       : string;
         LDti         : TDate;    // Data inicial
         LDtf         : TDate;    // Data final
         LUserID      : string;   // Identificação do cliente
         LNSU         : string;   // NSU especifico
         LHomologacao : boolean;  // Habilitar modo homologação
         //---------------------------------------------------------------------
         LPaginaAtual : integer;
         LQtdePaginas : integer;
         //---------------------------------------------------------------------
         LSalvarLOG   : boolean;
         //---------------------------------------------------------------------
         LConciliacao : TMoviFluxoExtrato;  // Relação de movimentos
         //---------------------------------------------------------------------
         Function SA_ConsultarPrevisao   : TMoviFluxoItensPrevisao;
         Function SA_ConsultarLiquidacao : TMoviFluxoItensLiquidacao;
         //---------------------------------------------------------------------
      public
         //---------------------------------------------------------------------
         constructor Create;
         destructor Destroy(); override;
         //---------------------------------------------------------------------
         property Token       : string     read LToken      write LToken;
         property SalvarLOG   : boolean    read LSalvarLOG  write LSalvarLOG;
         property Homologacao : boolean    read LHomologacao write LHomologacao;  // Habilitar modo homologação
         //---------------------------------------------------------------------
         property Dti         : TDate      read LDti        write LDti;    // Data inicial para buscar
         property Dtf         : TDate      read LDtf        write LDtf;    // Data final para buscar
         property UserID      : string     read LUserID     write LUserID; // Identificação do cliente
         property NSU         : string     read LNSU        write LNSU;    // NSU especifico
         //---------------------------------------------------------------------
         property Conciliacao : TMoviFluxoExtrato read LConciliacao   write LConciliacao;  // Relação de movimento
         //---------------------------------------------------------------------
         function SA_ListarLojas : TMoviFluxoListaLojas; // Listagem de clientes
         //---------------------------------------------------------------------
         procedure Consultar;
         procedure ConsultarPrevisoes;
         procedure ConsultarLiquidacoes;
         //---------------------------------------------------------------------
   end;

implementation

{ TMoviFluxo }

procedure TMoviFluxo.Consultar;
begin
   ConsultarPrevisoes;
   ConsultarLiquidacoes;
end;

procedure TMoviFluxo.ConsultarLiquidacoes;
var
   ItensLiquidacao : TMoviFluxoItensLiquidacao;
begin
   LPaginaAtual := 1;
   while LPaginaAtual<=LQtdePaginas do
      begin
         ItensLiquidacao          := SA_ConsultarLiquidacao;
         LConciliacao.Liquidacoes := LConciliacao.Liquidacoes + ItensLiquidacao;
      end;
end;

procedure TMoviFluxo.ConsultarPrevisoes;
var
   ItensPrevisao : TMoviFluxoItensPrevisao;
begin
   LPaginaAtual := 1;
   while LPaginaAtual<=LQtdePaginas do
      begin
         ItensPrevisao         := SA_ConsultarPrevisao;
         LConciliacao.Previsao := LConciliacao.Previsao + ItensPrevisao;
      end;
end;

constructor TMoviFluxo.Create;
begin
   LSalvarLOG   := true;
   LPaginaAtual := 1;
   LQtdePaginas := 999999;
   LHomologacao := false;    // Desabilitar modo homologação
   URL          := URLProd;  // URL de produção
end;


destructor TMoviFluxo.Destroy;
begin
  inherited;
end;

function TMoviFluxo.SA_ConsultarLiquidacao: TMoviFluxoItensLiquidacao;
var
   //---------------------------------------------------------------------------
   RetornoJSON  : TJSONValue;
   Pagination   : TJSONValue;
   ListaDados   : TJSONArray;
   LResponse    : IResponse;
   //---------------------------------------------------------------------------
   d            : integer;
   //---------------------------------------------------------------------------
   Total    : integer;
   pageSize : integer;
   //---------------------------------------------------------------------------
begin
   try
      //------------------------------------------------------------------------
      SA_SalvarLog('SOLICITAR LIQUIDACOES',URL + '/liquidacoes/',GetCurrentDir+'\TEF_log\logMoviFluxo'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLOG);
      //------------------------------------------------------------------------
      URL := URLProd;
      if LHomologacao then
         URL := URLHml;
      //------------------------------------------------------------------------
      LResponse := TRequest.New
                   .BaseURL(URL + '/liquidacoes/')
                   .AddParam('external_id','D41D8CD98F00B204E9800998ECF8427E') // Chave fixa para autenticação
                   .AddParam('size', '100')
                   .AddParam('row', LPaginaAtual.ToString)
                   .AddParam('user_id', LUserID)
                   .AddParam('startDate', formatdatetime('yyyy-mm-dd',LDti))
                   .AddParam('endDate', formatdatetime('yyyy-mm-dd',LDtf))
                   .AddHeader('Authorization', 'Token '+LToken,[poDoNotEncode])
//                   .AddHeader('Authorization', 'Token 87287ba14e74e418adbc1c8da51febaf9edc8724',[poDoNotEncode])
                   .Accept('application/json')
                   .Get;
      SA_SalvarLog('RESPOSTA LIQUIDACOES',LResponse.StatusCode.ToString+' '+LResponse.Content,GetCurrentDir+'\TEF_log\logMoviFluxo'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLOG);
      //------------------------------------------------------------------------
      if LResponse.StatusCode=200 then
         begin
            //------------------------------------------------------------------
            retornoJSON := TJSonObject.ParseJSONValue(LResponse.Content);
            if retornoJSON<>nil then
               begin
                  //------------------------------------------------------------
                  //   Processando extrato
                  //------------------------------------------------------------
                  Pagination := retornoJSON.GetValue<TJSONValue>('pagnation',nil);
                  if Pagination<>nil then
                     begin
                        Total        := Pagination.GetValue<integer>('total',0);
                        pageSize     := Pagination.GetValue<integer>('pageSize',0);
                        LQtdePaginas := 1;
                        if (total mod pageSize)>0 then
                           LQtdePaginas := trunc(total/pageSize) + 1
                        else
                           LQtdePaginas := trunc(total/pageSize);
                        inc(LPaginaAtual);
                     end;
                  //------------------------------------------------------------
                  ListaDados := retornoJSON.GetValue<TJSONArray>('data',nil);
                  if ListaDados<>nil then
                     begin
                        //------------------------------------------------------
                        //   Desmontar os dados
                        //------------------------------------------------------
                        setlength(Result,ListaDados.Count);
                        for d := 1 to ListaDados.Count do
                           begin
                              Result[d-1].adquirente              := ListaDados.Items[d-1].GetValue<string>('adquirente','');
                              Result[d-1].codigo_pedido           := ListaDados.Items[d-1].GetValue<string>('codigo_pedido','');
                              Result[d-1].nsu                     := ListaDados.Items[d-1].GetValue<string>('nsu','');
                              Result[d-1].meio_pagamento          := ListaDados.Items[d-1].GetValue<string>('meio_pagamento','');
                              Result[d-1].bandeira                := ListaDados.Items[d-1].GetValue<string>('bandeira','');
                              Result[d-1].produto                 := ListaDados.Items[d-1].GetValue<string>('produto','');
                              Result[d-1].estabelecimento         := ListaDados.Items[d-1].GetValue<string>('estabelecimento','');
                              Result[d-1].data_pagamento          := strtodatedef(ListaDados.Items[d-1].GetValue<string>('data_pagamento',''),date);
                              Result[d-1].valor_bruto_transacao   := ListaDados.Items[d-1].GetValue<real>('valor_bruto_transacao',0);
                              Result[d-1].valor_bruto_parcela     := ListaDados.Items[d-1].GetValue<real>('valor_bruto_parcela',0);
                              Result[d-1].valor_liquido_parcela   := ListaDados.Items[d-1].GetValue<real>('valor_liquido_parcela',0);
                              Result[d-1].taxa_administrativa     := ListaDados.Items[d-1].GetValue<real>('taxa_administrativa',0);
                              Result[d-1].parcela                 := ListaDados.Items[d-1].GetValue<integer>('parcela',0);
                              Result[d-1].plano                   := ListaDados.Items[d-1].GetValue<integer>('plano',0);  // Qtde de parcelas
                              Result[d-1].codigo_banco            := ListaDados.Items[d-1].GetValue<string>('codigo_banco','');
                              Result[d-1].nome_banco              := ListaDados.Items[d-1].GetValue<string>('nome_banco','');
                              Result[d-1].agencia                 := ListaDados.Items[d-1].GetValue<string>('agencia','');
                              Result[d-1].conta_corrente_poupanca := ListaDados.Items[d-1].GetValue<string>('conta_corrente_poupanca','');
                           end;

                        //------------------------------------------------------
                     end;
                  //------------------------------------------------------------
               end;
            //------------------------------------------------------------------
            retornoJSON.Free;
            //------------------------------------------------------------------
         end
      else
         LPaginaAtual := LQtdePaginas + 1;
      //------------------------------------------------------------------------
   except on e:exception do
      begin
         SA_SalvarLog('ERRO CONSULTAR LIQUIDACOES',e.Message,GetCurrentDir+'\TEF_log\logMoviFluxo'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLOG);
      end;
   end;

end;

function TMoviFluxo.SA_ConsultarPrevisao: TMoviFluxoItensPrevisao;
var
   //---------------------------------------------------------------------------
   RetornoJSON  : TJSONValue;
   Pagination   : TJSONValue;
   ListaDados   : TJSONArray;
   LResponse    : IResponse;
   //---------------------------------------------------------------------------
   d            : integer;
   Host         : string;
   //---------------------------------------------------------------------------
   Total    : integer;
   pageSize : integer;
   //---------------------------------------------------------------------------
begin
   try
      //------------------------------------------------------------------------
      SA_SalvarLog('SOLICITAR PREVISAO',Host,GetCurrentDir+'\TEF_log\logMoviFluxo'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLOG);
      //------------------------------------------------------------------------
      URL := URLProd;
      if LHomologacao then
         URL := URLHml;
      //------------------------------------------------------------------------
      LResponse := TRequest.New
                   .BaseURL(URL + '/previsoes/')
                   .AddParam('external_id','D41D8CD98F00B204E9800998ECF8427E')  // Chave fixa para autenticação
                   .AddParam('size', '100')
                   .AddParam('row', LPaginaAtual.ToString)
                   .AddParam('user_id', LUserID)
                   .AddParam('startDate', formatdatetime('yyyy-mm-dd',LDti))
                   .AddParam('endDate', formatdatetime('yyyy-mm-dd',LDtf))
                   .AddHeader('Authorization', 'Token '+LToken,[poDoNotEncode])
//                   .AddHeader('Authorization', 'Token 87287ba14e74e418adbc1c8da51febaf9edc8724',[poDoNotEncode])
                   .Accept('application/json')
                   .Get;
      SA_SalvarLog('RESPOSTA PREVISAO',LResponse.StatusCode.ToString+' '+LResponse.Content,GetCurrentDir+'\TEF_log\logMoviFluxo'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLOG);
      //------------------------------------------------------------------------
      if LResponse.StatusCode=200 then
         begin
            //------------------------------------------------------------------
            retornoJSON := TJSonObject.ParseJSONValue(LResponse.Content);
            if retornoJSON<>nil then
               begin
                  //------------------------------------------------------------
                  //   Processando extrato
                  //------------------------------------------------------------
                  Pagination := retornoJSON.GetValue<TJSONValue>('pagnation',nil);
                  if Pagination<>nil then
                     begin
                        Total        := Pagination.GetValue<integer>('total',0);
                        pageSize     := Pagination.GetValue<integer>('pageSize',0);
                        LQtdePaginas := 1;
                        if (total mod pageSize)>0 then
                           LQtdePaginas := trunc(total/pageSize) + 1
                        else
                           LQtdePaginas := trunc(total/pageSize);
                        inc(LPaginaAtual);
                     end;
                  //------------------------------------------------------------
                  ListaDados := retornoJSON.GetValue<TJSONArray>('data',nil);
                  if ListaDados<>nil then
                     begin
                        //------------------------------------------------------
                        //   Desmontar os dados
                        //------------------------------------------------------
                        setlength(Result,ListaDados.Count);
                        for d := 1 to ListaDados.Count do
                           begin
                              Result[d-1].adquirente              := ListaDados.Items[d-1].GetValue<string>('adquirente','');
                              Result[d-1].codigo_pedido           := ListaDados.Items[d-1].GetValue<string>('codigo_pedido','');
                              Result[d-1].nsu                     := ListaDados.Items[d-1].GetValue<string>('nsu','');
                              Result[d-1].meio_pagamento          := ListaDados.Items[d-1].GetValue<string>('meio_pagamento','');
                              Result[d-1].produto                 := ListaDados.Items[d-1].GetValue<string>('produto','');
                              Result[d-1].estabelecimento         := ListaDados.Items[d-1].GetValue<string>('estabelecimento','');
                              Result[d-1].data_venda              := strtodatedef(ListaDados.Items[d-1].GetValue<string>('data_venda',''),date);
                              Result[d-1].data_prevista_pagamento := strtodatedef(ListaDados.Items[d-1].GetValue<string>('data_prevista_pagamento',''),date);
                              Result[d-1].valor_bruto_transacao   := ListaDados.Items[d-1].GetValue<real>('valor_bruto_transacao',0);
                              Result[d-1].valor_bruto_parcela     := ListaDados.Items[d-1].GetValue<real>('valor_bruto_parcela',0);
                              Result[d-1].valor_liquido_parcela   := ListaDados.Items[d-1].GetValue<real>('valor_liquido_parcela',0);
                              Result[d-1].taxa_adquirencia        := ListaDados.Items[d-1].GetValue<real>('taxa_adquirencia',0);
                              Result[d-1].bandeira                := ListaDados.Items[d-1].GetValue<string>('bandeira','');
                              Result[d-1].parcela                 := ListaDados.Items[d-1].GetValue<integer>('parcela',0);
                              Result[d-1].plano                   := ListaDados.Items[d-1].GetValue<integer>('plano',0);
                           end;

                        //------------------------------------------------------
                     end;
                  //------------------------------------------------------------
               end;
            //------------------------------------------------------------------
            retornoJSON.Free;
            //------------------------------------------------------------------
         end
      else
         LPaginaAtual := LQtdePaginas + 1;
      //------------------------------------------------------------------------
   except on e:exception do
      begin
         LPaginaAtual := LQtdePaginas + 1;
         SA_SalvarLog('ERRO LISTAGEM LOJAS',e.Message,GetCurrentDir+'\TEF_log\logMoviFluxo'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLOG);
      end;
   end;
end;


function TMoviFluxo.SA_ListarLojas : TMoviFluxoListaLojas; // Listagem de clientes;
var
   //---------------------------------------------------------------------------
   RetornoJSON  : TJSONValue;
   ListaIDLojas : TJSONArray;
   LResponse    : IResponse;
   //---------------------------------------------------------------------------
   d : integer;
begin
   try
      //------------------------------------------------------------------------
      SA_SalvarLog('SOLICITAR LISTAGEM LOJAS',URL+'/lista-lojas',GetCurrentDir+'\TEF_log\logMoviFluxo'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLOG);
      //------------------------------------------------------------------------
      URL := URLProd;
      if LHomologacao then
         URL := URLHml;
      //------------------------------------------------------------------------
      LResponse := TRequest.New
          .BaseURL(URL+'/lista-lojas/')
          .AddParam('external_id','D41D8CD98F00B204E9800998ECF8427E') // Chave fixa para autenticação
          .AddParam('size', '100')
          .AddParam('row', '1')
          .AddHeader('Authorization', 'Token '+LToken,[poDoNotEncode])
          .Accept('application/json')
          .Get;
      //------------------------------------------------------------------------
      SA_SalvarLog('RESPOSTA LISTAGEM LOJAS',LResponse.StatusCode.ToString+' '+LResponse.Content,GetCurrentDir+'\TEF_log\logMoviFluxo'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLOG);
      //------------------------------------------------------------------------
      if LResponse.StatusCode=200 then
         begin
            retornoJSON := TJSonObject.ParseJSONValue(LResponse.Content);
            if retornoJSON<>nil then // Teve retorno válido
               begin
                  //------------------------------------------------------------
                  ListaIDLojas := retornoJSON.GetValue<TJSONArray>('data',nil);
                  if ListaIDLojas.Count>0 then
                     begin
                        //------------------------------------------------------
                        //   Listagem das lojas sendo jogada para dentro de um array de strings
                        //------------------------------------------------------
                        setlength(Result,ListaIDLojas.Count);
                        for d := 1 to ListaIDLojas.Count do
                           begin
                              Result[d-1].user_id      := ListaIDLojas.Items[d-1].GetValue<string>('user_id','');
                              Result[d-1].nome_empresa := ListaIDLojas.Items[d-1].GetValue<string>('nome_empresa','');
                              Result[d-1].cnpj         := ListaIDLojas.Items[d-1].GetValue<string>('cnpj','');
                           end;
                        //------------------------------------------------------
                     end;
                  //------------------------------------------------------------
               end;
            //------------------------------------------------------------------
            retornoJSON.Free;
            //------------------------------------------------------------------
         end;
      //------------------------------------------------------------------------
   except on e:exception do
      begin
         SA_SalvarLog('ERRO LISTAGEM LOJAS',e.Message,GetCurrentDir+'\TEF_log\logMoviFluxo'+formatdatetime('yyyymmdd',date)+'.txt',LSalvarLOG);
      end;
   end;
      //------------------------------------------------------------------------
end;

end.
