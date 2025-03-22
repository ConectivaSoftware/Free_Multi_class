object frmconciliacao: Tfrmconciliacao
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmconciliacao'
  ClientHeight = 675
  ClientWidth = 1076
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
  OnCreate = FormCreate
  DesignSize = (
    1076
    675)
  PixelsPerInch = 96
  TextHeight = 13
  object fundo: TShape
    Left = 1
    Top = 11
    Width = 49
    Height = 62
    Brush.Color = 12906495
  end
  object Shape1: TShape
    Left = 839
    Top = 543
    Width = 216
    Height = 114
    Anchors = [akLeft, akTop, akRight]
    Brush.Color = 12040191
    Pen.Style = psClear
    Shape = stRoundRect
  end
  object Shape5: TShape
    Left = 17
    Top = 601
    Width = 816
    Height = 56
    Anchors = [akLeft, akTop, akRight]
    Brush.Color = 12040191
    Pen.Style = psClear
    Shape = stRoundRect
  end
  object Shape2: TShape
    Left = 17
    Top = 17
    Width = 1038
    Height = 80
    Anchors = [akLeft, akTop, akRight]
    Brush.Color = clSilver
    Pen.Style = psClear
    Shape = stRoundRect
    ExplicitWidth = 1039
  end
  object Label9: TLabel
    Left = 20
    Top = 17
    Width = 1030
    Height = 77
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Concilia'#231#227'o financeira'
    Font.Charset = ANSI_CHARSET
    Font.Color = 4802889
    Font.Height = -48
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    ExplicitWidth = 1031
  end
  object Shape3: TShape
    Left = 17
    Top = 102
    Width = 1038
    Height = 61
    Anchors = [akLeft, akTop, akRight]
    Brush.Color = 12040191
    Pen.Style = psClear
    Shape = stRoundRect
    ExplicitWidth = 1039
  end
  object Label1: TLabel
    Left = 361
    Top = 121
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
    ExplicitLeft = 362
  end
  object Label2: TLabel
    Left = 634
    Top = 121
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
  object Shape4: TShape
    Left = 17
    Top = 542
    Width = 816
    Height = 56
    Anchors = [akLeft, akTop, akRight]
    Brush.Color = 12040191
    Pen.Style = psClear
    Shape = stRoundRect
  end
  object Label5: TLabel
    Left = 33
    Top = 554
    Width = 139
    Height = 24
    Anchors = [akTop, akRight]
    Caption = 'Receb'#237'veis R$'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 327
    Top = 554
    Width = 88
    Height = 24
    Anchors = [akTop, akRight]
    Caption = 'Taxas R$'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 568
    Top = 554
    Width = 101
    Height = 24
    Anchors = [akTop, akRight]
    Caption = 'L'#237'quido R$'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 52
    Top = 617
    Width = 123
    Height = 24
    Anchors = [akTop, akRight]
    Caption = 'Liquidado R$'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 327
    Top = 617
    Width = 88
    Height = 24
    Anchors = [akTop, akRight]
    Caption = 'Taxas R$'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 568
    Top = 617
    Width = 101
    Height = 24
    Anchors = [akTop, akRight]
    Caption = 'L'#237'quido R$'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object btok: TBitBtn
    Left = 868
    Top = 110
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
    TabOrder = 0
    OnClick = btokClick
  end
  object btcancela: TBitBtn
    Left = 853
    Top = 556
    Width = 188
    Height = 88
    Anchors = [akRight, akBottom]
    Caption = 'ESC - Cancelar'
    Font.Charset = ANSI_CHARSET
    Font.Color = 14483456
    Font.Height = -19
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btcancelaClick
  end
  object edtdti: TMaskEdit
    Left = 468
    Top = 118
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
    TabOrder = 2
    Text = '  /  /    '
    OnEnter = edtdtiEnter
    OnExit = edtdtiExit
    OnKeyDown = edtdtfKeyDown
  end
  object edtdtf: TMaskEdit
    Left = 725
    Top = 118
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
    TabOrder = 3
    Text = '  /  /    '
    OnEnter = edtdtiEnter
    OnExit = edtdtiExit
    OnKeyDown = edtdtfKeyDown
  end
  object pgc: TPageControl
    Left = 17
    Top = 176
    Width = 1039
    Height = 361
    ActivePage = TabSheet3
    TabOrder = 4
    object TabSheet1: TTabSheet
      Caption = 'Previs'#227'o'
      object DBGridprevisoes: TDBGrid
        Left = 16
        Top = 17
        Width = 995
        Height = 296
        DataSource = frmprinc.dtsprevisao
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnKeyDown = DBGridliquidacoesKeyDown
        Columns = <
          item
            Expanded = False
            FieldName = 'adquirente'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'codigo_pedido'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'nsu'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'meio_pagamento'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'produto'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'estabelecimento'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'data_venda'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'data_prevista_pagamento'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'valor_bruto_transacao'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'valor_bruto_parcela'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'valor_liquido_parcela'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'taxa_adquirencia'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'bandeira'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'parcela'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'plano'
            Visible = True
          end>
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Liquida'#231#227'o'
      ImageIndex = 1
      object DBGridliquidacoes: TDBGrid
        Left = 18
        Top = 18
        Width = 995
        Height = 303
        DataSource = frmprinc.dtsliquidacao
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnKeyDown = DBGridliquidacoesKeyDown
        Columns = <
          item
            Expanded = False
            FieldName = 'adquirente'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'codigo_pedido'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'nsu'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'meio_pagamento'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'bandeira'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'produto'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'estabelecimento'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'data_pagamento'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'valor_bruto_transacao'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'valor_bruto_parcela'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'valor_liquido_parcela'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'taxa_administrativa'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'parcela'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'plano'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'codigo_banco'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'nome_banco'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'agencia'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'conta_corrente_poupanca'
            Visible = True
          end>
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Texto'
      ImageIndex = 2
      object edttextoMOVIFLUXO: TMemo
        Left = 14
        Top = 16
        Width = 1001
        Height = 305
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object edtrecebiveis: TMaskEdit
    Left = 178
    Top = 552
    Width = 137
    Height = 30
    Anchors = [akTop, akRight]
    Color = clInactiveCaption
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 5
    Text = ''
    OnEnter = edtdtiEnter
    OnExit = edtdtiExit
    OnKeyDown = edtdtfKeyDown
  end
  object edttaxasrecebiveis: TMaskEdit
    Left = 418
    Top = 552
    Width = 137
    Height = 30
    Anchors = [akTop, akRight]
    Color = clInactiveCaption
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 6
    Text = ''
    OnEnter = edtdtiEnter
    OnExit = edtdtiExit
    OnKeyDown = edtdtfKeyDown
  end
  object edtliquidorecebiveis: TMaskEdit
    Left = 673
    Top = 552
    Width = 137
    Height = 30
    Anchors = [akTop, akRight]
    Color = clInactiveCaption
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 7
    Text = ''
    OnEnter = edtdtiEnter
    OnExit = edtdtiExit
    OnKeyDown = edtdtfKeyDown
  end
  object edtliquidado: TMaskEdit
    Left = 178
    Top = 615
    Width = 137
    Height = 30
    Anchors = [akTop, akRight]
    Color = clInactiveCaption
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 8
    Text = ''
    OnEnter = edtdtiEnter
    OnExit = edtdtiExit
    OnKeyDown = edtdtfKeyDown
  end
  object edttaxasliquidado: TMaskEdit
    Left = 418
    Top = 615
    Width = 137
    Height = 30
    Anchors = [akTop, akRight]
    Color = clInactiveCaption
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 9
    Text = ''
    OnEnter = edtdtiEnter
    OnExit = edtdtiExit
    OnKeyDown = edtdtfKeyDown
  end
  object edtliquidoliquidado: TMaskEdit
    Left = 673
    Top = 615
    Width = 137
    Height = 30
    Anchors = [akTop, akRight]
    Color = clInactiveCaption
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 10
    Text = ''
    OnEnter = edtdtiEnter
    OnExit = edtdtiExit
    OnKeyDown = edtdtfKeyDown
  end
end
