object frmpgto: Tfrmpgto
  Left = 32
  Top = 46
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Finaliza'#231#227'o de venda'
  ClientHeight = 760
  ClientWidth = 1118
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    1118
    760)
  PixelsPerInch = 96
  TextHeight = 13
  object fundo: TShape
    Left = 0
    Top = 0
    Width = 65
    Height = 89
    Brush.Color = 12906495
  end
  object Shape1: TShape
    Left = 14
    Top = 11
    Width = 1092
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    Brush.Color = clSilver
    Pen.Style = psClear
    Shape = stRoundRect
  end
  object Label9: TLabel
    Left = 19
    Top = 8
    Width = 1080
    Height = 64
    Hint = 'Cliente selecionado para a venda em andamento'
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'DEFINI'#199#195'O DE PAGAMENTOS'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -48
    Font.Name = 'Arial Black'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object placa_util: TShape
    Left = 14
    Top = 661
    Width = 1092
    Height = 79
    Anchors = [akLeft, akRight, akBottom]
    Brush.Color = 10461183
    Pen.Style = psClear
    Shape = stRoundRect
    ExplicitTop = 634
    ExplicitWidth = 1074
  end
  object Label1: TLabel
    Left = 31
    Top = 89
    Width = 191
    Height = 33
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = 'Valor bruto R$'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label2: TLabel
    Left = 54
    Top = 131
    Width = 168
    Height = 33
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = 'Desconto R$'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label3: TLabel
    Left = 83
    Top = 216
    Width = 139
    Height = 33
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = 'L'#237'quido R$'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label4: TLabel
    Left = 31
    Top = 258
    Width = 191
    Height = 33
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = 'Pagamento R$'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label5: TLabel
    Left = 38
    Top = 300
    Width = 184
    Height = 33
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = 'Valor pago R$'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label6: TLabel
    Left = 23
    Top = 342
    Width = 199
    Height = 33
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = 'Saldo pagar R$'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label7: TLabel
    Left = 104
    Top = 384
    Width = 118
    Height = 33
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = 'Troco R$'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label8: TLabel
    Left = 55
    Top = 173
    Width = 167
    Height = 33
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = 'Encargos R$'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object btbuscaforma: TSpeedButton
    Left = 14
    Top = 424
    Width = 412
    Height = 61
    Anchors = [akTop, akRight]
    Caption = 'Selecionar forma de pagamento'
    Font.Charset = ANSI_CHARSET
    Font.Color = 3026478
    Font.Height = -21
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = btbuscaformaClick
  end
  object Shape2: TShape
    Left = 14
    Top = 495
    Width = 412
    Height = 156
    Anchors = [akTop, akRight, akBottom]
  end
  object Label10: TLabel
    Left = 19
    Top = 502
    Width = 401
    Height = 142
    Alignment = taCenter
    Anchors = [akTop, akRight, akBottom]
    AutoSize = False
    Caption = 
      'Para conceder desconto nesta tela, digite o percentual tecle " -' +
      ' " (sinal de subtra'#231#227'o) Para criar um acr'#233'scimo, digite o percen' +
      'tual que deseja e tecle " + " (Tecla adi'#231#227'o)   Para encerrar a v' +
      'enda com desconto, clique no bot'#227'o ou use a tecla de fun'#231#227'o indi' +
      'cada, com o valor do desconto digitado.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object edtbruto: TMaskEdit
    Left = 226
    Top = 86
    Width = 200
    Height = 39
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    BiDiMode = bdLeftToRight
    BorderStyle = bsNone
    Color = clMoneyGreen
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    Text = '0,00'
    OnEnter = edtbrutoEnter
  end
  object edtdesconto: TMaskEdit
    Left = 226
    Top = 128
    Width = 200
    Height = 39
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    BiDiMode = bdLeftToRight
    BorderStyle = bsNone
    Color = clMoneyGreen
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    Text = '0,00'
    OnEnter = edtbrutoEnter
  end
  object edtliquido: TMaskEdit
    Left = 226
    Top = 213
    Width = 200
    Height = 39
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    BiDiMode = bdLeftToRight
    BorderStyle = bsNone
    Color = clMoneyGreen
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    Text = '0,00'
    OnEnter = edtbrutoEnter
  end
  object edtpgto: TMaskEdit
    Left = 226
    Top = 255
    Width = 200
    Height = 39
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    BiDiMode = bdLeftToRight
    BorderStyle = bsNone
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
    Text = '0,00'
    OnEnter = edtpgtoEnter
    OnExit = edtpgtoExit
    OnKeyDown = edtpgtoKeyDown
    OnKeyPress = edtpgtoKeyPress
  end
  object edtpagamentos: TMaskEdit
    Left = 226
    Top = 297
    Width = 200
    Height = 39
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    BiDiMode = bdLeftToRight
    BorderStyle = bsNone
    Color = clMoneyGreen
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
    Text = '0,00'
    OnEnter = edtbrutoEnter
  end
  object edtsaldo: TMaskEdit
    Left = 226
    Top = 339
    Width = 200
    Height = 39
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    BiDiMode = bdLeftToRight
    BorderStyle = bsNone
    Color = clMoneyGreen
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 5
    Text = '0,00'
    OnEnter = edtbrutoEnter
  end
  object edttroco: TMaskEdit
    Left = 226
    Top = 381
    Width = 200
    Height = 39
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    BiDiMode = bdLeftToRight
    BorderStyle = bsNone
    Color = clMoneyGreen
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 6
    Text = '0,00'
    OnEnter = edtbrutoEnter
  end
  object dbgridpgto: TDBGrid
    Left = 442
    Top = 499
    Width = 668
    Height = 156
    Anchors = [akTop, akRight, akBottom]
    BorderStyle = bsNone
    Ctl3D = False
    DataSource = dmMulticlass.dtspgto
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 7
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'forma'
        Title.Alignment = taCenter
        Title.Caption = 'Forma de Pagamento'
        Width = 233
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DescEvento'
        Title.Alignment = taCenter
        Title.Caption = 'Descri'#231#227'o do Evento'
        Width = 266
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Valor'
        Title.Alignment = taCenter
        Title.Caption = 'Valor R$'
        Width = 133
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'codigo'
        Visible = True
      end>
  end
  object edtencargos: TMaskEdit
    Left = 226
    Top = 170
    Width = 200
    Height = 39
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    BiDiMode = bdLeftToRight
    BorderStyle = bsNone
    Color = clMoneyGreen
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 8
    Text = '0,00'
    OnEnter = edtbrutoEnter
  end
  object teclado: TTouchKeyboard
    Left = 438
    Top = 86
    Width = 435
    Height = 399
    Anchors = [akTop, akRight]
    GradientEnd = clSilver
    GradientStart = clGray
    Layout = 'NumPad'
  end
  object pnformas: TPanel
    Left = 879
    Top = 86
    Width = 227
    Height = 399
    Anchors = [akTop, akRight]
    ParentBackground = False
    TabOrder = 10
    object btforma1: TSpeedButton
      Left = 5
      Top = 8
      Width = 210
      Height = 71
      Caption = '* * *'
      Font.Charset = ANSI_CHARSET
      Font.Color = 2960685
      Font.Height = -15
      Font.Name = 'Arial Black'
      Font.Style = [fsBold]
      Layout = blGlyphTop
      ParentFont = False
      OnClick = btforma1Click
    end
    object btforma2: TSpeedButton
      Left = 5
      Top = 84
      Width = 210
      Height = 71
      Caption = '* * *'
      Font.Charset = ANSI_CHARSET
      Font.Color = 2960685
      Font.Height = -15
      Font.Name = 'Arial Black'
      Font.Style = [fsBold]
      Layout = blGlyphTop
      ParentFont = False
      OnClick = btforma1Click
    end
    object btforma4: TSpeedButton
      Left = 5
      Top = 237
      Width = 210
      Height = 71
      Caption = '* * *'
      Font.Charset = ANSI_CHARSET
      Font.Color = 2960685
      Font.Height = -15
      Font.Name = 'Arial Black'
      Font.Style = [fsBold]
      Layout = blGlyphTop
      ParentFont = False
      OnClick = btforma1Click
    end
    object btforma3: TSpeedButton
      Left = 5
      Top = 161
      Width = 210
      Height = 71
      Caption = '* * *'
      Font.Charset = ANSI_CHARSET
      Font.Color = 2960685
      Font.Height = -15
      Font.Name = 'Arial Black'
      Font.Style = [fsBold]
      Layout = blGlyphTop
      ParentFont = False
      OnClick = btforma1Click
    end
    object btforma5: TSpeedButton
      Left = 5
      Top = 314
      Width = 210
      Height = 71
      Caption = '* * *'
      Font.Charset = ANSI_CHARSET
      Font.Color = 2960685
      Font.Height = -15
      Font.Name = 'Arial Black'
      Font.Style = [fsBold]
      Layout = blGlyphTop
      ParentFont = False
      OnClick = btforma1Click
    end
  end
end
