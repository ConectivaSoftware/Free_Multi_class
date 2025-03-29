program projexemplo;

uses
  Vcl.Forms,
  uprinc in 'uprinc.pas' {frmprinc},
  uprecoprod in 'uprecoprod.pas' {frmprecoprod},
  uutil in 'uutil.pas' {frmutil},
  urelatorio in 'urelatorio.pas' {frmrelatorio},
  uenviarXML in 'uenviarXML.pas' {frmenviarXML},
  uconciliacao in 'uconciliacao.pas' {frmconciliacao};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrmprinc, frmprinc);
  Application.Run;
end.
