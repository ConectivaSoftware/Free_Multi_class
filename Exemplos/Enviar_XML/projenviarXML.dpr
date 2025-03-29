program projenviarXML;

uses
  Vcl.Forms,
  uprinc in 'uprinc.pas' {frmprinc};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrmprinc, frmprinc);
  Application.Run;
end.
