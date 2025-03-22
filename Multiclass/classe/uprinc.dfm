object frmprinc: Tfrmprinc
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'PDV Demonstrativo'
  ClientHeight = 641
  ClientWidth = 1091
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    1091
    641)
  PixelsPerInch = 96
  TextHeight = 13
  object fundo: TShape
    Left = 24
    Top = 168
    Width = 65
    Height = 65
    Brush.Color = clCream
  end
  object Label2: TLabel
    Left = 280
    Top = 482
    Width = 76
    Height = 29
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Digitar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitTop = 365
  end
  object Label3: TLabel
    Left = 716
    Top = 482
    Width = 61
    Height = 29
    Anchors = [akRight, akBottom]
    Caption = 'Qtde.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitTop = 365
  end
  object Label4: TLabel
    Left = 892
    Top = 482
    Width = 103
    Height = 29
    Anchors = [akRight, akBottom]
    Caption = 'Pre'#231'o R$'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitTop = 365
  end
  object Label5: TLabel
    Left = 365
    Top = 489
    Width = 337
    Height = 19
    Anchors = [akLeft, akRight, akBottom]
    Caption = '" = " - Definir pre'#231'o / " * " - Definir Quantidade'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitTop = 372
  end
  object btbuscaprod: TSpeedButton
    Left = 654
    Top = 513
    Width = 57
    Height = 47
    Hint = 'Consultar c'#243'digo de barras no servidor'
    Anchors = [akRight, akBottom]
    Glyph.Data = {
      E6040000424DE604000000000000360000002800000014000000140000000100
      180000000000B0040000C40E0000C40E00000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCE31
      31CE3131CE3131FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCE31319C6300C8D0D4
      C8D0D49C31001010109C0000CE31319C63319C63009C6300FFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF737373CE3131C8D0D4C8D0D410101010
      1010CE31319C63319C6331CE6300FF6331FF63319C63009C6300FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFF5A5A5ACE3131C8D0D46331319C3131CE31319C63
      31FF6331CE6300FF6331FF6331FF6331FF6331FF63319C6300FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF5A5A5ACE63319C3100840000CE31319C6331FF6331CE6300
      FFFFFFFFFFFFCE3131FF6331FF6331FF6331FF63319C6300FFFFFFFFFFFFFFFF
      FFFFFFFF5A5A5A639C9CCE63319C31319C6331CE6300FF6331FFFFFFFFFFFFFF
      FFFFFFFFFFCE3131FF6331FF6331FF63319C6300FFFFFFFFFFFFFFFFFFFFFFFF
      737373639CCEFF6331CE31319C6331FF6331CE6300FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7373739C
      CECE639CCECE63319C6331FF6331CE6300CE6300CE6300CE6300CE6300CE6300
      CE6300CE6300CE6300CE6300FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7373739CCE
      CECE6363CE6331FF6331FF6331FF6331FF6331CE9C31CE9C31FF9C00FF9C00FF
      9C00FF9C00CE6300FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCE3131639C9C9CCEFF
      FF6331FF6331CE6300FFFFFFFFFFFFFFFFFFFFFFFFCE3131FFFF63FFCE00FF9C
      00CE6300FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9C31319C9C639CFFFFFF
      6331CE6300CE6300FFFFFFFFFFFFCE3131CE9C31FFFF9CFFFF63CE6300FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCE31319C31319C9C63C6C6C6CE63
      00CE6300CE3131CE3131CE6300FFCE00FFFF63FF9C00CE6300FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCE3131CE6300CE9C63CECE9CCE6300
      CE6300CE9C31FF9C00CE9C31FF9C00CE6300FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCE6300CE6300FF6331FF6331FF6331FF
      6331CE9C31FF9C00CE6300FFFFFFFFFFFFFF6331FFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCE6300CE6300CE6300CE6300CE63
      00CE6300FFFFFFFFFFFFFFFFFFCE6300FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCE6300
      CE6300CE6300CE6300FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF}
    OnClick = btbuscaprodClick
  end
  object pntitulo: TPanel
    Left = 10
    Top = 8
    Width = 1070
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    Caption = '                      PDV DEMONSTRATIVO'
    Color = 16744448
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -45
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object Shape1: TShape
      Left = 6
      Top = 8
      Width = 240
      Height = 90
    end
    object Label6: TLabel
      Left = 8
      Top = 7
      Width = 237
      Height = 84
      Alignment = taCenter
      AutoSize = False
      Caption = 'Free Multiclass'
      Font.Charset = ANSI_CHARSET
      Font.Color = 4276545
      Font.Height = -32
      Font.Name = 'Arial Black'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
  end
  object pnrodape: TPanel
    Left = 10
    Top = 566
    Width = 1070
    Height = 65
    Anchors = [akLeft, akRight, akBottom]
    Color = 16744448
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      1070
      65)
    object btreiniciarvenda: TSpeedButton
      Left = 852
      Top = 8
      Width = 209
      Height = 50
      Anchors = [akTop, akRight]
      Caption = 'F9 - Cancelar venda'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = btreiniciarvendaClick
      ExplicitLeft = 840
    end
    object btpagar: TSpeedButton
      Left = 644
      Top = 8
      Width = 202
      Height = 50
      Anchors = [akTop, akRight]
      Caption = 'F5 - Finalizar venda'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = btpagarClick
    end
    object Label1: TLabel
      Left = 377
      Top = 19
      Width = 89
      Height = 29
      Anchors = [akTop, akRight]
      Caption = 'Total R$'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -24
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object btconfig: TSpeedButton
      Left = 9
      Top = 8
      Width = 193
      Height = 50
      Caption = 'F2 - Configura'#231#245'es'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = btconfigClick
    end
    object btutil: TSpeedButton
      Left = 204
      Top = 8
      Width = 164
      Height = 50
      Caption = 'F7 - Utilitarios'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = btutilClick
    end
    object edttotal: TMaskEdit
      Left = 472
      Top = 16
      Width = 166
      Height = 35
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Ctl3D = False
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      Text = '0,00'
    end
  end
  object DBGridprod: TDBGrid
    Left = 280
    Top = 124
    Width = 800
    Height = 346
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = dtsvenda
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Barra'
        Title.Alignment = taCenter
        Title.Caption = 'C'#243'd.Barras'
        Width = 173
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'descricao'
        Title.Alignment = taCenter
        Title.Caption = 'Descri'#231#227'o do Produto'
        Width = 411
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'un'
        Title.Alignment = taCenter
        Title.Caption = 'UN'
        Width = 39
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'qtde'
        Title.Alignment = taCenter
        Title.Caption = 'Qtde'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'preco'
        Title.Alignment = taCenter
        Title.Caption = 'Pre'#231'o R$'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'total'
        Title.Alignment = taCenter
        Title.Caption = 'Total R$'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ref'
        Title.Alignment = taCenter
        Title.Caption = 'Refer'#234'ncia'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'marca'
        Title.Alignment = taCenter
        Title.Caption = 'Marca'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ncm'
        Title.Alignment = taCenter
        Title.Caption = 'NCM/SH'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'cest'
        Title.Alignment = taCenter
        Title.Caption = 'CEST'
        Visible = True
      end>
  end
  object edtdigitar: TMaskEdit
    Left = 280
    Top = 513
    Width = 368
    Height = 47
    Anchors = [akLeft, akRight, akBottom]
    CharCase = ecUpperCase
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -35
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
    Text = ''
    OnKeyDown = edtdigitarKeyDown
    OnKeyPress = edtdigitarKeyPress
  end
  object edtqtde: TMaskEdit
    Left = 716
    Top = 513
    Width = 170
    Height = 47
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Ctl3D = False
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -35
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 4
    Text = '1,000'
  end
  object edtpreco: TMaskEdit
    Left = 892
    Top = 513
    Width = 188
    Height = 47
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Ctl3D = False
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -35
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 5
    Text = '0,00'
  end
  object dtsvenda: TDataSource
    DataSet = tblvenda
    Left = 177
    Top = 144
  end
  object tblvenda: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 138
    Top = 144
    object tblvendaBarra: TStringField
      FieldName = 'Barra'
    end
    object tblvendaref: TStringField
      FieldName = 'ref'
    end
    object tblvendadescricao: TStringField
      FieldName = 'descricao'
      Size = 60
    end
    object tblvendaun: TStringField
      FieldName = 'un'
      Size = 2
    end
    object tblvendamarca: TStringField
      FieldName = 'marca'
      Size = 30
    end
    object tblvendancm: TStringField
      FieldName = 'ncm'
      Size = 10
    end
    object tblvendacest: TStringField
      FieldName = 'cest'
      Size = 10
    end
    object tblvendaqtde: TFloatField
      FieldName = 'qtde'
      OnGetText = tblvendaqtdeGetText
    end
    object tblvendapreco: TFloatField
      FieldName = 'preco'
      OnGetText = tblvendaqtdeGetText
    end
    object tblvendatotal: TFloatField
      FieldName = 'total'
      OnGetText = tblvendaqtdeGetText
    end
  end
  object tbltef: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 138
    Top = 208
    object tbltefStatus: TBooleanField
      FieldName = 'Status'
    end
    object tbltefNumero: TAutoIncField
      FieldName = 'Numero'
    end
    object tbltefDataHora: TDateTimeField
      FieldName = 'DataHora'
    end
    object tbltefValor: TFloatField
      FieldName = 'Valor'
    end
    object tbltefForma: TStringField
      FieldName = 'FormaADM'
    end
    object tbltefOperadoraTEF: TIntegerField
      FieldName = 'OperadoraTEF'
    end
    object tbltefNSU: TStringField
      FieldName = 'NSU'
      Size = 30
    end
    object tbltefcAut: TStringField
      FieldName = 'cAut'
      Size = 30
    end
    object tbltefrede: TStringField
      FieldName = 'rede'
      Size = 30
    end
    object tbltefBandeira: TStringField
      FieldName = 'Bandeira'
      Size = 30
    end
    object tbltefCNPJAdquirente: TStringField
      FieldName = 'CNPJAdquirente'
    end
    object tbltefE2E: TStringField
      FieldName = 'E2E'
      Size = 100
    end
    object tbltefTxID: TStringField
      FieldName = 'TxID'
      Size = 100
    end
    object tbltefDescEvento: TStringField
      FieldKind = fkCalculated
      FieldName = 'DescEvento'
      OnGetText = tbltefDescEventoGetText
      Size = 40
      Calculated = True
    end
    object tbltefformatef: TIntegerField
      FieldName = 'formatef'
    end
    object tbltefCancelado: TBooleanField
      FieldName = 'Cancelado'
    end
  end
  object dtstef: TDataSource
    DataSet = tbltef
    Left = 177
    Top = 208
  end
  object tblprod: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 138
    Top = 280
    object tblprodbarra: TStringField
      FieldName = 'barra'
    end
    object tblprodref: TStringField
      FieldName = 'ref'
    end
    object tblproddescricao: TStringField
      FieldName = 'descricao'
      Size = 80
    end
    object tblprodun: TStringField
      FieldName = 'un'
      Size = 2
    end
    object tblprodmarca: TStringField
      FieldName = 'marca'
      Size = 30
    end
    object tblprodncm: TStringField
      FieldName = 'ncm'
      Size = 10
    end
    object tblprodcest: TStringField
      FieldName = 'cest'
      Size = 10
    end
    object tblprodpreco: TFloatField
      FieldName = 'preco'
    end
  end
  object dtsprod: TDataSource
    DataSet = tblprod
    Left = 177
    Top = 280
  end
  object dtsprevisao: TDataSource
    AutoEdit = False
    DataSet = tblprevisao
    Left = 185
    Top = 352
  end
  object tblprevisao: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 144
    Top = 352
    object tblprevisaoadquirente: TStringField
      FieldName = 'adquirente'
      Size = 40
    end
    object tblprevisaocodigo_pedido: TStringField
      FieldName = 'codigo_pedido'
      Size = 30
    end
    object tblprevisaonsu: TStringField
      FieldName = 'nsu'
      Size = 30
    end
    object tblprevisaomeio_pagamento: TStringField
      FieldName = 'meio_pagamento'
      Size = 30
    end
    object tblprevisaoproduto: TStringField
      FieldName = 'produto'
      Size = 30
    end
    object tblprevisaoestabelecimento: TStringField
      FieldName = 'estabelecimento'
      Size = 60
    end
    object tblprevisaodata_venda: TDateField
      FieldName = 'data_venda'
    end
    object tblprevisaodata_prevista_pagamento: TDateField
      FieldName = 'data_prevista_pagamento'
    end
    object tblprevisaovalor_bruto_transacao: TFloatField
      FieldName = 'valor_bruto_transacao'
    end
    object tblprevisaovalor_bruto_parcela: TFloatField
      FieldName = 'valor_bruto_parcela'
    end
    object tblprevisaovalor_liquido_parcela: TFloatField
      FieldName = 'valor_liquido_parcela'
    end
    object tblprevisaotaxa_adquirencia: TFloatField
      FieldName = 'taxa_adquirencia'
    end
    object tblprevisaobandeira: TStringField
      FieldName = 'bandeira'
      Size = 30
    end
    object tblprevisaoparcela: TIntegerField
      FieldName = 'parcela'
    end
    object tblprevisaoplano: TIntegerField
      FieldName = 'plano'
    end
  end
  object dtsliquidacao: TDataSource
    AutoEdit = False
    DataSet = tblliquidacao
    Left = 193
    Top = 424
  end
  object tblliquidacao: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 152
    Top = 424
    object tblliquidacaoadquirente: TStringField
      FieldName = 'adquirente'
      Size = 30
    end
    object tblliquidacaocodigo_pedido: TStringField
      FieldName = 'codigo_pedido'
      Size = 30
    end
    object tblliquidacaonsu: TStringField
      FieldName = 'nsu'
      Size = 30
    end
    object tblliquidacaomeio_pagamento: TStringField
      FieldName = 'meio_pagamento'
      Size = 60
    end
    object tblliquidacaobandeira: TStringField
      FieldName = 'bandeira'
      Size = 30
    end
    object tblliquidacaoproduto: TStringField
      FieldName = 'produto'
      Size = 60
    end
    object tblliquidacaoestabelecimento: TStringField
      FieldName = 'estabelecimento'
      Size = 60
    end
    object tblliquidacaodata_pagamento: TDateField
      FieldName = 'data_pagamento'
    end
    object tblliquidacaovalor_bruto_transacao: TFloatField
      FieldName = 'valor_bruto_transacao'
    end
    object tblliquidacaovalor_bruto_parcela: TFloatField
      FieldName = 'valor_bruto_parcela'
    end
    object tblliquidacaovalor_liquido_parcela: TFloatField
      FieldName = 'valor_liquido_parcela'
    end
    object tblliquidacaotaxa_administrativa: TFloatField
      FieldName = 'taxa_administrativa'
    end
    object tblliquidacaoparcela: TIntegerField
      FieldName = 'parcela'
    end
    object tblliquidacaoplano: TIntegerField
      FieldName = 'plano'
    end
    object tblliquidacaocodigo_banco: TStringField
      FieldName = 'codigo_banco'
      Size = 10
    end
    object tblliquidacaonome_banco: TStringField
      FieldName = 'nome_banco'
      Size = 40
    end
    object tblliquidacaoagencia: TStringField
      FieldName = 'agencia'
      Size = 10
    end
    object tblliquidacaoconta_corrente_poupanca: TStringField
      FieldName = 'conta_corrente_poupanca'
      Size = 30
    end
  end
end
