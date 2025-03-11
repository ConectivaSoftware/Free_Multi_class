object dmMulticlass: TdmMulticlass
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 468
  Width = 705
  object tblformas: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
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
  object dtsformas: TDataSource
    AutoEdit = False
    DataSet = tblformas
    Left = 89
    Top = 40
  end
  object tblpgto: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 104
    object tblpgtocodigo: TIntegerField
      FieldName = 'codigo'
    end
    object StringField1: TStringField
      FieldName = 'forma'
    end
    object IntegerField2: TIntegerField
      FieldName = 'evento'
    end
    object StringField3: TStringField
      FieldKind = fkCalculated
      FieldName = 'DescEvento'
      OnGetText = tblformasDescEventoGetText
      Size = 30
      Calculated = True
    end
    object tblpgtoValor: TFloatField
      FieldName = 'Valor'
      OnGetText = tblpgtoValorGetText
    end
    object tblpgtoFormaTEF: TIntegerField
      FieldName = 'FormaTEF'
    end
    object tblpgtoQtdeParcelas: TIntegerField
      FieldName = 'QtdeParcelas'
    end
  end
  object dtspgto: TDataSource
    AutoEdit = False
    DataSet = tblpgto
    Left = 89
    Top = 104
  end
end
