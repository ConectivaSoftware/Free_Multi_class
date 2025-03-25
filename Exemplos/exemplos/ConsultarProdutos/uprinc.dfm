object frmprinc: Tfrmprinc
  Left = 0
  Top = 0
  BiDiMode = bdLeftToRight
  Caption = 'frmprinc'
  ClientHeight = 391
  ClientWidth = 898
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 213
    Top = 181
    Width = 82
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = 'C'#243'digo de barras'
    ParentBiDiMode = False
  end
  object Label2: TLabel
    Left = 243
    Top = 208
    Width = 52
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = 'Refer'#234'ncia'
    ParentBiDiMode = False
  end
  object Label3: TLabel
    Left = 193
    Top = 235
    Width = 102
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = 'Descri'#231#227'o do produto'
    ParentBiDiMode = False
  end
  object Label4: TLabel
    Left = 281
    Top = 262
    Width = 14
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = 'UN'
    ParentBiDiMode = False
  end
  object Label6: TLabel
    Left = 270
    Top = 343
    Width = 25
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = 'CEST'
    ParentBiDiMode = False
  end
  object Label7: TLabel
    Left = 273
    Top = 316
    Width = 22
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = 'NCM'
    ParentBiDiMode = False
  end
  object Label8: TLabel
    Left = 208
    Top = 289
    Width = 87
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = 'Marca /Fabricante'
    ParentBiDiMode = False
  end
  object SpeedButton1: TSpeedButton
    Left = 522
    Top = 178
    Width = 217
    Height = 41
    Caption = 'Consultar produto no WS'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton1Click
  end
  object Label5: TLabel
    Left = 38
    Top = 101
    Width = 257
    Height = 23
    BiDiMode = bdRightToLeft
    Caption = 'Token para consultar produtos'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBiDiMode = False
    ParentFont = False
  end
  object Label9: TLabel
    Left = 440
    Top = 130
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
  object Shape1: TShape
    Left = 24
    Top = 16
    Width = 841
    Height = 65
  end
  object Label10: TLabel
    Left = 36
    Top = 30
    Width = 821
    Height = 38
    Alignment = taCenter
    AutoSize = False
    Caption = 'EXEMPLO PARA CONSULTAR PRODUTO'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edtbarra: TMaskEdit
    Left = 298
    Top = 178
    Width = 209
    Height = 21
    TabOrder = 0
    Text = ''
  end
  object edtref: TMaskEdit
    Left = 298
    Top = 205
    Width = 209
    Height = 21
    TabOrder = 1
    Text = ''
  end
  object edtdescricao: TMaskEdit
    Left = 298
    Top = 232
    Width = 441
    Height = 21
    TabOrder = 2
    Text = ''
  end
  object edtun: TMaskEdit
    Left = 298
    Top = 259
    Width = 33
    Height = 21
    TabOrder = 3
    Text = ''
  end
  object edtmarca: TMaskEdit
    Left = 298
    Top = 286
    Width = 209
    Height = 21
    TabOrder = 4
    Text = ''
  end
  object edtncm: TMaskEdit
    Left = 298
    Top = 313
    Width = 81
    Height = 21
    TabOrder = 5
    Text = ''
  end
  object edtcest: TMaskEdit
    Left = 298
    Top = 340
    Width = 81
    Height = 21
    TabOrder = 6
    Text = ''
  end
  object edttoken: TMaskEdit
    Left = 298
    Top = 98
    Width = 441
    Height = 31
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 7
    Text = ''
  end
end
