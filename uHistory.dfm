object HistoryForm: THistoryForm
  Left = 0
  Height = 219
  Top = 0
  Width = 411
  BorderStyle = bsDialog
  Caption = 'History'
  ClientHeight = 219
  ClientWidth = 411
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  OnCreate = FormCreate
  OnShow = FormShow
  Position = poScreenCenter
  LCLVersion = '1.6.0.4'
  object HistoryList: TStringGrid
    Left = 8
    Height = 203
    Top = 8
    Width = 395
    ColCount = 2
    DefaultColWidth = 180
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goAlwaysShowEditor, goThumbTracking]
    RowCount = 2
    TabOrder = 0
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
  end
end
