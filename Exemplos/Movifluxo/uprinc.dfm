object frmprinc: Tfrmprinc
  Left = 0
  Top = 0
  Caption = 'Concilia'#231#227'o financeira'
  ClientHeight = 561
  ClientWidth = 984
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  DesignSize = (
    984
    561)
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 24
    Top = 16
    Width = 930
    Height = 65
  end
  object Label10: TLabel
    Left = 33
    Top = 30
    Width = 913
    Height = 38
    Alignment = taCenter
    AutoSize = False
    Caption = 'EXEMPLO DE CONCILIA'#199#195'O Movifluxo'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 127
    Top = 173
    Width = 104
    Height = 24
    Anchors = [akTop, akRight]
    Caption = 'Data inicial'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 403
    Top = 174
    Width = 89
    Height = 24
    Anchors = [akTop, akRight]
    Caption = 'Data final'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label42: TLabel
    Left = 40
    Top = 106
    Width = 196
    Height = 19
    Caption = 'Token da Software House'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label43: TLabel
    Left = 139
    Top = 133
    Width = 97
    Height = 19
    Caption = 'ID do Cliente'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label45: TLabel
    Left = 242
    Top = 86
    Width = 179
    Height = 14
    Caption = 'Obtido com o time de integra'#231#227'o'
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object edtdti: TMaskEdit
    Left = 237
    Top = 171
    Width = 137
    Height = 30
    Anchors = [akTop, akRight]
    Color = clInactiveCaption
    Ctl3D = False
    EditMask = '99/99/9999'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    MaxLength = 10
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    Text = '  /  /    '
    OnExit = edtdtiExit
  end
  object edtdtf: TMaskEdit
    Left = 494
    Top = 171
    Width = 137
    Height = 30
    Anchors = [akTop, akRight]
    Color = clInactiveCaption
    Ctl3D = False
    EditMask = '99/99/9999'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    MaxLength = 10
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    Text = '  /  /    '
    OnExit = edtdtiExit
  end
  object btok: TBitBtn
    Left = 653
    Top = 162
    Width = 173
    Height = 46
    Anchors = [akTop, akRight]
    Caption = 'F5 - Ok'
    Font.Charset = ANSI_CHARSET
    Font.Color = 16719904
    Font.Height = -21
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = btokClick
  end
  object edtMOVIFLUXOToken: TMaskEdit
    Left = 238
    Top = 103
    Width = 588
    Height = 25
    Color = clInactiveBorder
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    MaxLength = 100
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
    Text = '87287ba14e74e418adbc1c8da51febaf9edc8724'
  end
  object edtMOVIFLUXOIDCliente: TMaskEdit
    Left = 238
    Top = 131
    Width = 588
    Height = 25
    Color = clInactiveBorder
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    MaxLength = 100
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 4
    Text = '0410f22c801d650e735254c7f43ae7f2'
  end
  object edttextoMOVIFLUXO: TMemo
    Left = 24
    Top = 225
    Width = 930
    Height = 312
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 5
  end
end
