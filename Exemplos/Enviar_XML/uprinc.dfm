object frmprinc: Tfrmprinc
  Left = 0
  Top = 0
  Caption = 'Enviar arquivo XML'
  ClientHeight = 377
  ClientWidth = 890
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 70
    Top = 176
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
    Left = 757
    Top = 193
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
  object btcancelar: TSpeedButton
    Left = 622
    Top = 257
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
  object btenviarXML: TSpeedButton
    Left = 435
    Top = 257
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
    Height = 38
    Alignment = taCenter
    AutoSize = False
    Caption = 'EXEMPLO PARA ENVIAR XML'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 71
    Top = 109
    Width = 236
    Height = 23
    BiDiMode = bdRightToLeft
    Caption = 'Token para API de produtos'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBiDiMode = False
    ParentFont = False
  end
  object Label3: TLabel
    Left = 504
    Top = 138
    Width = 299
    Height = 16
    BiDiMode = bdRightToLeft
    Caption = 'Solicite '#224' equipe de suporte da Free Multiclass'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentFont = False
  end
  object edtxml: TMaskEdit
    Left = 71
    Top = 201
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
  object edttoken: TMaskEdit
    Left = 310
    Top = 106
    Width = 493
    Height = 31
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 1
    Text = ''
    OnKeyDown = edtxmlKeyDown
  end
  object OpenDialog: TOpenDialog
    Filter = 'Arquivos XML|*.xml'
    Left = 370
    Top = 265
  end
end
