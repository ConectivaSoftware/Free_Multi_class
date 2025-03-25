object frmprinc: Tfrmprinc
  Left = 0
  Top = 0
  Caption = 'Exemplo transacionando TEF MULTIPLUS'
  ClientHeight = 470
  ClientWidth = 893
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 24
    Top = 16
    Width = 841
    Height = 65
  end
  object Label1: TLabel
    Left = 36
    Top = 30
    Width = 821
    Height = 51
    Alignment = taCenter
    AutoSize = False
    Caption = 'TEF MULTIPLUS - Exemplo direto'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 233
    Top = 290
    Width = 61
    Height = 19
    Caption = 'Valor R$'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object btenviarXML: TSpeedButton
    Left = 296
    Top = 395
    Width = 181
    Height = 45
    Caption = 'Transacionar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = btenviarXMLClick
  end
  object btcancelar: TSpeedButton
    Left = 483
    Top = 395
    Width = 181
    Height = 45
    Caption = 'ESC - Cancelar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = btcancelarClick
  end
  object Label10: TLabel
    Left = 250
    Top = 324
    Width = 45
    Height = 19
    Caption = 'Forma'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label9: TLabel
    Left = 199
    Top = 356
    Width = 96
    Height = 19
    Caption = 'Qtde Parcelas'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Shape2: TShape
    Left = 24
    Top = 87
    Width = 841
    Height = 58
  end
  object Label2: TLabel
    Left = 32
    Top = 96
    Width = 827
    Height = 49
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'Para transacionar com MULTIPLUS, certifique se que a biblioteca ' +
      'DLL "TefClientmc.dll" esteja dispon'#237'vel na pasta da aplica'#231#227'o. C' +
      'ertifique-se tamb'#233'm que a aplica'#231#227'o est'#225' sendo executada como ad' +
      'ministrador.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label307: TLabel
    Left = 242
    Top = 159
    Width = 53
    Height = 25
    Caption = 'CNPJ'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label308: TLabel
    Left = 259
    Top = 192
    Width = 37
    Height = 25
    Caption = 'Loja'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label340: TLabel
    Left = 255
    Top = 227
    Width = 41
    Height = 25
    Caption = 'PDV'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object edtvalor: TMaskEdit
    Left = 299
    Top = 284
    Width = 160
    Height = 31
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = ''
    OnKeyPress = edtvalorKeyPress
  end
  object cbformapgto: TComboBox
    Left = 299
    Top = 321
    Width = 379
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemIndex = 0
    ParentFont = False
    TabOrder = 1
    Text = 'Perguntar'
    Items.Strings = (
      'Perguntar'
      'Credito Perguntar'
      'Credito Vista'
      'Credito Pacelado Pergunta'
      'Credito Parcelado Loja'
      'Credito Parcelado ADM'
      'Debito Perguntar'
      'Debito Vista'
      'Debito Pre'
      'Frota'
      'Voucher'
      'PIX'
      'PIXMercado Pago'
      'PIX Pic Pay')
  end
  object edtqtdeparcelas: TMaskEdit
    Left = 299
    Top = 354
    Width = 35
    Height = 25
    CharCase = ecUpperCase
    Color = clInactiveBorder
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 1
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    Text = ''
    OnKeyPress = edtqtdeparcelasKeyPress
  end
  object edtcnpjMultiPlus: TMaskEdit
    Left = 299
    Top = 157
    Width = 240
    Height = 31
    Color = clInactiveBorder
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 100
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
    Text = '60177876000130'
  end
  object edtLojaMultiPlus: TMaskEdit
    Left = 299
    Top = 190
    Width = 104
    Height = 31
    Color = clInactiveBorder
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 100
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 4
    Text = '000167'
  end
  object edtPDVMultiPlus: TMaskEdit
    Left = 299
    Top = 225
    Width = 104
    Height = 31
    Color = clInactiveBorder
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 100
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 5
    Text = '01'
  end
end
