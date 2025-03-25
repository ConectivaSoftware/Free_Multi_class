unit embed_lib;

interface

type
  TEmbedLib = class
  private
    FDLLHandle: THandle;
    FEmbedConfigurar: function(input: PAnsiChar): PAnsiChar; cdecl;
    FEmbedIniciar: function(input: PAnsiChar): PAnsiChar; cdecl;
    FEmbedProcessar: function(input: PAnsiChar): PAnsiChar; cdecl;
    FEmbedFinalizar: function(input: PAnsiChar): PAnsiChar; cdecl;
    FEmbedObterValor: function(json: PAnsiChar; key: PAnsiChar): PAnsiChar; cdecl;
  public
    constructor Create(const DLLPath: string);
    destructor Destroy; override;

    function Configurar(input: AnsiString): AnsiString;
    function Iniciar(input: AnsiString): AnsiString;
    function Processar(input: AnsiString): AnsiString;
    function Finalizar(input: AnsiString): AnsiString;
    function ObterValor(json: AnsiString; key: AnsiString): AnsiString;
  end;

implementation

uses
  SysUtils, Windows;

constructor TEmbedLib.Create(const DLLPath: string);
begin
  FDLLHandle := LoadLibrary(PChar(DLLPath));
  if FDLLHandle = 0 then
    raise Exception.CreateFmt('Não foi possível carregar a DLL: %s', [DLLPath]);

  @FEmbedConfigurar := GetProcAddress(FDLLHandle, 'embed_configurar');
  @FEmbedIniciar := GetProcAddress(FDLLHandle, 'embed_iniciar');
  @FEmbedProcessar := GetProcAddress(FDLLHandle, 'embed_processar');
  @FEmbedFinalizar := GetProcAddress(FDLLHandle, 'embed_finalizar');
  @FEmbedObterValor := GetProcAddress(FDLLHandle, 'embed_obter_valor');

  if not Assigned(FEmbedConfigurar) or not Assigned(FEmbedIniciar) or
     not Assigned(FEmbedProcessar) or not Assigned(FEmbedFinalizar) or
     not Assigned(FEmbedObterValor) then
    raise Exception.Create('Não foi possível encontrar uma ou mais funções na DLL.');
end;

destructor TEmbedLib.Destroy;
begin
  if FDLLHandle <> 0 then
    FreeLibrary(FDLLHandle);
  inherited;
end;

function TEmbedLib.Configurar(input: AnsiString): AnsiString;
begin
  Result := FEmbedConfigurar(PAnsiChar(input));
end;

function TEmbedLib.Iniciar(input: AnsiString): AnsiString;
begin
  Result := FEmbedIniciar(PAnsiChar(input));
end;

function TEmbedLib.Processar(input: AnsiString): AnsiString;
begin
  Result := FEmbedProcessar(PAnsiChar(input));
end;

function TEmbedLib.Finalizar(input: AnsiString): AnsiString;
begin
  Result := FEmbedFinalizar(PAnsiChar(input));
end;

function TEmbedLib.ObterValor(json: AnsiString; key: AnsiString): AnsiString;
begin
  Result := FEmbedObterValor(PAnsiChar(json), PAnsiChar(key));
end;

end.

