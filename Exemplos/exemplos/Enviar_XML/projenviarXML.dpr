program projenviarXML;

uses
  Vcl.Forms,
  uprinc in 'uprinc.pas' {frmprinc},
  embed_lib in 'classes\embed_lib.pas',
  tbotao in 'classes\tbotao.pas',
  ubuscaforma in 'classes\ubuscaforma.pas' {frmbuscaforma},
  uBuscaProd in 'classes\uBuscaProd.pas',
  uconfig in 'classes\uconfig.pas' {frmconfig},
  ucpfcupom in 'classes\ucpfcupom.pas' {frmcpfcupom},
  udmMulticlass in 'classes\udmMulticlass.pas' {dmMulticlass: TDataModule},
  uElginTEF in 'classes\uElginTEF.pas',
  uEmbedIT in 'classes\uEmbedIT.pas',
  uEmbedPIX in 'classes\uEmbedPIX.pas',
  uKSTypes in 'classes\uKSTypes.pas',
  uMKMPix in 'classes\uMKMPix.pas',
  uMoviFluxo in 'classes\uMoviFluxo.pas',
  uMulticlass in 'classes\uMulticlass.pas',
  uMulticlassFuncoes in 'classes\uMulticlassFuncoes.pas',
  uMultiPlusTEF in 'classes\uMultiPlusTEF.pas',
  upgto in 'classes\upgto.pas' {frmpgto},
  uPgtoMulticlass in 'classes\uPgtoMulticlass.pas',
  uVeroTEF in 'classes\uVeroTEF.pas',
  uVSPague in 'classes\uVSPague.pas',
  uwebtefmp in 'classes\uwebtefmp.pas' {frmwebtef};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrmprinc, frmprinc);
  Application.Run;
end.
