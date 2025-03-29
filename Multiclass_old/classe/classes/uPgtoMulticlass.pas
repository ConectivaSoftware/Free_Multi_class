unit uPgtoMulticlass;

interface

uses
   uKSTypes,
   udmMulticlass,
   upgto,
   forms;

type
   TPgto = class
      private
         //---------------------------------------------------------------------
         LValorTotal : real;  // Valor total do pagamento
         //---------------------------------------------------------------------
         LPagamento   : TPagamentoVenda;           // Variável para receber o resultado do pagamento
         //---------------------------------------------------------------------
      public
         //---------------------------------------------------------------------

         //---------------------------------------------------------------------
         property ValorTotal : real             read LValorTotal    write LValorTotal;  // Valor total do pagamento
         property Pagamento  : TPagamentoVenda  read LPagamento     write LPagamento;   // Variável para receber o resultado do pagamento
         //---------------------------------------------------------------------
         procedure DefinirPagamento;
         //---------------------------------------------------------------------
   end;

implementation

{ TPgto }


{ TPgto }

procedure TPgto.DefinirPagamento;
begin
   Application.CreateForm(Tfrmpgto, frmpgto);
   frmpgto.TotalPagar := LValorTotal;
   frmpgto.ShowModal;
   LPagamento := frmpgto.PagamentoVenda;
   frmpgto.Release;
end;

end.
