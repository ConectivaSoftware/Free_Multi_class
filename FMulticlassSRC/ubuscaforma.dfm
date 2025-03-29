object frmbuscaforma: Tfrmbuscaforma
  Left = 131
  Top = 9
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = 'Formas de Pagamento'
  ClientHeight = 669
  ClientWidth = 1000
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
  PixelsPerInch = 96
  TextHeight = 13
  object fundo: TShape
    Left = 1
    Top = 11
    Width = 49
    Height = 62
    Brush.Color = 12906495
  end
  object Shape2: TShape
    Left = 17
    Top = 17
    Width = 959
    Height = 80
    Brush.Color = clSilver
    Pen.Style = psClear
    Shape = stRoundRect
  end
  object Label9: TLabel
    Left = 20
    Top = 17
    Width = 951
    Height = 77
    Alignment = taCenter
    AutoSize = False
    Caption = 'Formas de Pagamento'
    Font.Charset = ANSI_CHARSET
    Font.Color = 4802889
    Font.Height = -48
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Shape1: TShape
    Left = 17
    Top = 596
    Width = 959
    Height = 61
    Brush.Color = 12040191
    Pen.Style = psClear
    Shape = stRoundRect
  end
  object Shape3: TShape
    Left = 17
    Top = 104
    Width = 959
    Height = 486
    Brush.Color = 8563455
    Pen.Style = psClear
  end
  object btok: TBitBtn
    Left = 586
    Top = 602
    Width = 173
    Height = 46
    Caption = 'ENTER - Ok'
    Font.Charset = ANSI_CHARSET
    Font.Color = 16719904
    Font.Height = -21
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btokClick
  end
  object btcancela: TBitBtn
    Left = 770
    Top = 602
    Width = 193
    Height = 46
    Caption = 'ESC - Cancelar'
    Font.Charset = ANSI_CHARSET
    Font.Color = 14483456
    Font.Height = -21
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = btcancelaClick
  end
  object dbgridforma: TDBGrid
    Left = 27
    Top = 114
    Width = 936
    Height = 462
    BorderStyle = bsNone
    Ctl3D = False
    DataSource = dtsformas
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -19
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = dbgridformaDblClick
    OnKeyDown = dbgridformaKeyDown
    OnKeyPress = dbgridformaKeyPress
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'atalho'
        Title.Alignment = taCenter
        Title.Caption = 'Atalho'
        Width = 47
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'forma'
        Title.Alignment = taCenter
        Title.Caption = 'Descri'#231#227'o'
        Width = 393
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'DescEvento'
        Title.Alignment = taCenter
        Title.Caption = 'A'#231#227'o da forma'
        Width = 445
        Visible = True
      end>
  end
  object dtsformas: TDataSource
    AutoEdit = False
    DataSet = tblformas
    Left = 97
    Top = 40
  end
  object tblformas: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 56
    Top = 40
    object tblformascodigo: TAutoIncField
      FieldName = 'codigo'
    end
    object tblformasforma: TStringField
      FieldName = 'forma'
    end
    object tblformasatalho: TStringField
      FieldName = 'atalho'
      Size = 1
    end
    object tblformasordem: TIntegerField
      FieldName = 'ordem'
    end
    object tblformasevento: TIntegerField
      FieldName = 'evento'
    end
    object tblformasDescEvento: TStringField
      FieldKind = fkCalculated
      FieldName = 'DescEvento'
      OnGetText = tblformasDescEventoGetText
      Size = 30
      Calculated = True
    end
    object tblformasTipoPgto: TIntegerField
      FieldName = 'TipoPgto'
    end
    object tblformasQtdeParcelas: TIntegerField
      FieldName = 'QtdeParcelas'
    end
    object tblformasAruivoImagem: TStringField
      FieldName = 'AruivoImagem'
      Size = 100
    end
  end
end
