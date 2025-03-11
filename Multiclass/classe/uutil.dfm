object frmutil: Tfrmutil
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmutil'
  ClientHeight = 550
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object fundo: TShape
    Left = 1
    Top = 11
    Width = 49
    Height = 62
    Brush.Color = clSilver
  end
  object Shape2: TShape
    Left = 20
    Top = 20
    Width = 425
    Height = 73
    Brush.Color = 16744448
    Pen.Style = psClear
    Shape = stRoundRect
  end
  object Label20: TLabel
    Left = 26
    Top = 18
    Width = 416
    Height = 76
    Alignment = taCenter
    AutoSize = False
    Caption = 'Utilit'#225'rios'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -48
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object btadmelgin: TSpeedButton
    Left = 20
    Top = 99
    Width = 425
    Height = 54
    Caption = 'A - Administrativo ELGIN'
    Font.Charset = ANSI_CHARSET
    Font.Color = 3026478
    Font.Height = -21
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = btadmelginClick
  end
  object btlistatef: TSpeedButton
    Left = 20
    Top = 399
    Width = 425
    Height = 54
    Caption = 'Z - Relat'#243'rio de TEF'
    Font.Charset = ANSI_CHARSET
    Font.Color = 3026478
    Font.Height = -21
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = btlistatefClick
  end
  object btVBIPendencias: TSpeedButton
    Left = 20
    Top = 159
    Width = 425
    Height = 54
    Caption = 'B - Pendencias VSPague'
    Font.Charset = ANSI_CHARSET
    Font.Color = 3026478
    Font.Height = -21
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = btVBIPendenciasClick
  end
  object btVBIExtrato: TSpeedButton
    Left = 20
    Top = 219
    Width = 425
    Height = 54
    Caption = 'C - Extrato VSPague'
    Font.Charset = ANSI_CHARSET
    Font.Color = 3026478
    Font.Height = -21
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = btVBIExtratoClick
  end
  object btEnviarXML: TSpeedButton
    Left = 20
    Top = 339
    Width = 425
    Height = 54
    Caption = 'V - Enviar XML para servidor'
    Font.Charset = ANSI_CHARSET
    Font.Color = 3026478
    Font.Height = -21
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = btEnviarXMLClick
  end
  object btvoltar: TBitBtn
    Left = 20
    Top = 459
    Width = 425
    Height = 56
    Caption = 'ESC - Voltar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -21
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = btvoltarClick
    OnKeyDown = btvoltarKeyDown
    OnKeyPress = btvoltarKeyPress
  end
end
