object frmprecoprod: Tfrmprecoprod
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'frmprecoprod'
  ClientHeight = 267
  ClientWidth = 952
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
    Left = 8
    Top = 8
    Width = 65
    Height = 65
    Brush.Color = clCream
  end
  object btsalvar: TSpeedButton
    Left = 556
    Top = 185
    Width = 184
    Height = 50
    Caption = '&Ok'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = btsalvarClick
  end
  object btvolta: TSpeedButton
    Left = 746
    Top = 185
    Width = 184
    Height = 50
    Caption = 'ESC - Voltar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = btvoltaClick
  end
  object Label3: TLabel
    Left = 17
    Top = 91
    Width = 118
    Height = 29
    Caption = 'Descri'#231#227'o'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label9: TLabel
    Left = 646
    Top = 91
    Width = 38
    Height = 29
    Caption = 'UN'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label6: TLabel
    Left = 703
    Top = 91
    Width = 204
    Height = 29
    Caption = 'C'#243'digo de barras'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Shape4: TShape
    Left = 17
    Top = 17
    Width = 913
    Height = 65
    Brush.Color = clSilver
    Pen.Style = psClear
    Shape = stRoundRect
  end
  object titulo: TLabel
    Left = 20
    Top = 11
    Width = 908
    Height = 61
    Alignment = taCenter
    AutoSize = False
    Caption = 'Edi'#231#227'o do pre'#231'o do produto'
    Color = clSilver
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -43
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label15: TLabel
    Left = 97
    Top = 192
    Width = 151
    Height = 37
    Caption = 'Venda R$'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Bevel1: TBevel
    Left = 17
    Top = 165
    Width = 913
    Height = 4
  end
  object edtdescricao: TMaskEdit
    Left = 17
    Top = 119
    Width = 627
    Height = 19
    CharCase = ecUpperCase
    Color = clInactiveBorder
    Ctl3D = False
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 60
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    Text = ''
  end
  object edtun: TMaskEdit
    Left = 647
    Top = 119
    Width = 50
    Height = 19
    CharCase = ecUpperCase
    Color = clInactiveBorder
    Ctl3D = False
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    Text = ''
  end
  object edtbarra: TMaskEdit
    Left = 701
    Top = 119
    Width = 229
    Height = 19
    CharCase = ecUpperCase
    Color = clInactiveBorder
    Ctl3D = False
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 20
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    Text = ''
  end
  object edtvenda: TMaskEdit
    Left = 251
    Top = 190
    Width = 229
    Height = 19
    CharCase = ecUpperCase
    Color = clInactiveBorder
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 14
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
    Text = ''
    OnKeyDown = edtvendaKeyDown
    OnKeyPress = edtvendaKeyPress
  end
end
