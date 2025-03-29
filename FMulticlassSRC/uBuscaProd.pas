unit uBuscaProd;

interface

uses
   uKSTypes,
   system.JSON,
   system.SysUtils,
   IPPeerClient,
   IPPeerCommon,
   synacode,
   RESTRequest4D;
type
  //----------------------------------------------------------------------------
  TKSBuscaprod = class
     const
        KSHost = 'www.mkmservicos.com.br';
     private
        LChaveConsulta : string;   // Chave de autorização para consulta
        LCodigoBarras  : string;   // Código de barras a ser consultado
        //----------------------------------------------------------------------
        LRespostaConsulta : TKSRespostaConsultaProd;  // Resultado da pesquisa
        //----------------------------------------------------------------------
        procedure SA_Busca_Cadastro_Produto_Servidor_MSSC;
     public
        property ChaveConsulta : string read LChaveConsulta write LChaveConsulta;   // Chave de autorização para consulta
        property CodigoBarras  : string read LCodigoBarras  write LCodigoBarras;    // Código de barras a ser consultado
        //----------------------------------------------------------------------
        property RespostaConsulta : TKSRespostaConsultaProd read LRespostaConsulta;  // Resultado da pesquisa
        //----------------------------------------------------------------------
        procedure Consultar;
        //----------------------------------------------------------------------
  end;

implementation

{ TKSBuscaprod }

procedure TKSBuscaprod.Consultar;
begin
   SA_Busca_Cadastro_Produto_Servidor_MSSC;
end;

procedure TKSBuscaprod.SA_Busca_Cadastro_Produto_Servidor_MSSC;
var
   RespJson  : TJSONValue;
   LResponse : IResponse;
begin
   //---------------------------------------------------------------------------
   LRespostaConsulta.Status   := stKSFalha;
   LRespostaConsulta.Mensagem := 'Sem acesso a internet.';
   //---------------------------------------------------------------------------
   try
      //------------------------------------------------------------------------
      LResponse := TRequest.New.BaseURL('http://'+KSHost+':19016/buscaprod')
                   .AddBody('{"produto":"'+LCodigoBarras+'","chave":"'+string(EncodeBase64(ansistring( LChaveConsulta )))+'"}')
                   .Accept('application/json')
                   .Timeout(5000)
                   .Post;
      //------------------------------------------------------------------------
      if LResponse.StatusCode=200 then
         begin
           //-------------------------------------------------------------------
            RespJson  := TJSonObject.ParseJSONValue(TEncoding.UTF8.GetBytes( LResponse.Content ),0) as TJSONValue;
           //-------------------------------------------------------------------
            if RespJson.GetValue<string>('status','')='OK' then
               begin
                  //------------------------------------------------------------
                  LRespostaConsulta.Status             := stKSOk;
                  LRespostaConsulta.Mensagem           := 'Sucesso';
                  LRespostaConsulta.Produto.descricao  := RespJson.GetValue<string>('desc','');
                  LRespostaConsulta.Produto.un         := RespJson.GetValue<string>('un','');
                  LRespostaConsulta.Produto.barra      := RespJson.GetValue<string>('barra','');
                  LRespostaConsulta.Produto.marca      := RespJson.GetValue<string>('marca','');
                  LRespostaConsulta.Produto.ref        := RespJson.GetValue<string>('ref','');
                  LRespostaConsulta.Produto.ncm        := RespJson.GetValue<string>('ncm','');
                  LRespostaConsulta.Produto.cest       := RespJson.GetValue<string>('cest','');
                  //------------------------------------------------------------
               end
            else
               LRespostaConsulta.Mensagem           := RespJson.GetValue<string>('motivo','');
           //-------------------------------------------------------------------
         end
      else
         LRespostaConsulta.Mensagem := LResponse.StatusText;
   except on e:exception do
      begin
         //---------------------------------------------------------------------
         LRespostaConsulta.Status   := stKSFalha;
         LRespostaConsulta.Mensagem := e.Message;
         //---------------------------------------------------------------------
      end;
   end;
   //---------------------------------------------------------------------------
end;

end.

