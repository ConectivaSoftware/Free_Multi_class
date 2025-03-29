object frmenviarXML: TfrmenviarXML
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Enviar arquivo XML'
  ClientHeight = 263
  ClientWidth = 776
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
    Width = 733
    Height = 73
    Brush.Color = 16744448
    Pen.Style = psClear
    Shape = stRoundRect
  end
  object Label20: TLabel
    Left = 26
    Top = 18
    Width = 724
    Height = 76
    Alignment = taCenter
    AutoSize = False
    Caption = 'Enviar arquivo XML'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -48
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label5: TLabel
    Left = 20
    Top = 111
    Width = 90
    Height = 19
    Caption = 'Arquivo XML'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object btbuscaxml: TSpeedButton
    Left = 707
    Top = 128
    Width = 46
    Height = 42
    Caption = '...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = btbuscaxmlClick
  end
  object btenviarXML: TSpeedButton
    Left = 385
    Top = 192
    Width = 181
    Height = 45
    Caption = 'Enviar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = btenviarXMLClick
  end
  object btcancelar: TSpeedButton
    Left = 572
    Top = 192
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
  object edtxml: TMaskEdit
    Left = 20
    Top = 132
    Width = 680
    Height = 31
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = ''
    OnKeyDown = edtxmlKeyDown
  end
  object OpenDialog: TOpenDialog
    Filter = 'Arquivos XML|*.xml'
    Left = 32
    Top = 32
  end
end
