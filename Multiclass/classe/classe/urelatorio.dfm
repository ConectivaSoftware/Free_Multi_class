object frmrelatorio: Tfrmrelatorio
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Transa'#231#245'es de TEF'
  ClientHeight = 437
  ClientWidth = 1013
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGridtef: TDBGrid
    Left = 18
    Top = 88
    Width = 913
    Height = 209
    DataSource = frmprinc.dtstef
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDrawColumnCell = DBGridtefDrawColumnCell
    OnKeyDown = DBGridtefKeyDown
    Columns = <
      item
        Expanded = False
        FieldName = 'Status'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Numero'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DataHora'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Valor'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FormaADM'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'OperadoraTEF'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DescEvento'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NSU'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'cAut'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'rede'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Bandeira'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CNPJAdquirente'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'E2E'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TxID'
        Visible = True
      end>
  end
  object pntitulo: TPanel
    Left = 8
    Top = 16
    Width = 973
    Height = 57
    Caption = 'Relat'#243'rio'
    Color = clSilver
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
  end
  object pnrodape: TPanel
    Left = 8
    Top = 374
    Width = 973
    Height = 63
    Color = clSilver
    ParentBackground = False
    TabOrder = 2
    DesignSize = (
      973
      63)
    object btcancelartef: TSpeedButton
      Left = 10
      Top = 8
      Width = 247
      Height = 49
      Caption = 'F6 - Cancelar transa'#231#227'o'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btcancelartefClick
    end
    object btcancelar: TSpeedButton
      Left = 761
      Top = 8
      Width = 202
      Height = 49
      Anchors = [akTop, akRight]
      Caption = 'ESC - Cancelar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btcancelarClick
      ExplicitLeft = 661
    end
    object btcomprovante: TSpeedButton
      Left = 263
      Top = 8
      Width = 247
      Height = 49
      Caption = 'F2 - Ver comprovante'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btcomprovanteClick
    end
    object btreimprimir: TSpeedButton
      Left = 512
      Top = 9
      Width = 247
      Height = 49
      Caption = 'F5 - Reimprimir'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btreimprimirClick
    end
  end
end
