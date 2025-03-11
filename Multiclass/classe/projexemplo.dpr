program projexemplo;

uses
  Vcl.Forms,
  uprinc in 'uprinc.pas' {frmprinc},
  uconfig in 'classes\uconfig.pas' {frmconfig},
  tbotao in 'classes\tbotao.pas',
  uBuscaProd in 'classes\uBuscaProd.pas',
  uKSTypes in 'classes\uKSTypes.pas',
  uprecoprod in 'uprecoprod.pas' {frmprecoprod},
  uMulticlass in 'classes\uMulticlass.pas',
  uwebtefmp in 'classes\uwebtefmp.pas' {frmwebtef},
  upgto in 'classes\upgto.pas' {frmpgto},
  udmMulticlass in 'classes\udmMulticlass.pas' {dmMulticlass: TDataModule},
  uPgtoMulticlass in 'classes\uPgtoMulticlass.pas',
  uMulticlassFuncoes in 'classes\uMulticlassFuncoes.pas',
  ubuscaforma in 'classes\ubuscaforma.pas' {frmbuscaforma},
  uElginTEF in 'classes\uElginTEF.pas',
  uutil in 'uutil.pas' {frmutil},
  uMultiPlusTEF in 'classes\uMultiPlusTEF.pas',
  uEmbedIT in 'classes\uEmbedIT.pas',
  embed_lib in 'classes\embed_lib.pas',
  uVeroTEF in 'classes\uVeroTEF.pas',
  uMKMPix in 'classes\uMKMPix.pas',
  urelatorio in 'urelatorio.pas' {frmrelatorio},
  uVSPague in 'classes\uVSPague.pas',
  ucpfcupom in 'classes\ucpfcupom.pas' {frmcpfcupom},
  uenviarXML in 'uenviarXML.pas' {frmenviarXML};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrmprinc, frmprinc);
  Application.CreateForm(TfrmenviarXML, frmenviarXML);
  Application.Run;
end.
