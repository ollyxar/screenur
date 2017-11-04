object SettingsForm: TSettingsForm
  Left = 339
  Height = 257
  Top = 228
  Width = 656
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 257
  ClientWidth = 656
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  OnCreate = FormCreate
  OnShow = FormShow
  Position = poScreenCenter
  LCLVersion = '1.6.0.4'
  object GroupBox1: TGroupBox
    Left = 8
    Height = 88
    Top = 8
    Width = 317
    Caption = 'Capture screen'
    ClientHeight = 70
    ClientWidth = 313
    TabOrder = 0
    object Label1: TLabel
      Left = 243
      Height = 13
      Top = 35
      Width = 8
      Caption = '+'
      ParentColor = False
    end
    object PrntScrRadio: TRadioButton
      Left = 16
      Height = 19
      Top = 11
      Width = 138
      Caption = 'Snapshot on PrintScreen'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object CustomRadio: TRadioButton
      Left = 16
      Height = 19
      Top = 34
      Width = 150
      Caption = 'Custom snapshot shortcut:'
      TabOrder = 1
    end
    object ModPrint: TComboBox
      Left = 172
      Height = 22
      Top = 31
      Width = 65
      ItemHeight = 16
      ItemIndex = 0
      Items.Strings = (
        'ALT'
        'CTRL'
        'SHIFT'
      )
      Style = csOwnerDrawFixed
      TabOrder = 2
      Text = 'ALT'
    end
    object KeyPrint: TEdit
      Left = 257
      Height = 21
      Top = 32
      Width = 38
      CharCase = ecUppercase
      MaxLength = 10
      TabOrder = 3
      Text = 'P'
    end
  end
  object SaveBtn: TButton
    Left = 573
    Height = 25
    Top = 224
    Width = 75
    Caption = 'Ok'
    OnClick = SaveBtnClick
    TabOrder = 1
  end
  object GroupBox2: TGroupBox
    Left = 8
    Height = 110
    Top = 102
    Width = 317
    Caption = 'Pictures'
    ClientHeight = 92
    ClientWidth = 313
    TabOrder = 2
    object Label2: TLabel
      Left = 243
      Height = 13
      Top = 19
      Width = 8
      Caption = '+'
      ParentColor = False
    end
    object SpeedButton1: TSpeedButton
      Left = 272
      Height = 21
      Top = 55
      Width = 23
      Flat = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E00000000000000000000ABBCC3678591
        6785916785916785916785916785916785916785916785916785916785916C89
        95FFFFFFFFFFFFFFFFFF67859172BDDD72BDDD72BDDD72BDDD72BDDD72BDDD39
        7087599BB678BDDC77BDDA7AC1DF78C3E3678591FFFFFFFFFFFF67859173BEDF
        73C0DF73C0DF73C0DF75BEDF73BFDE3970875A9CB877C4E478C3E378C5E479C4
        E477C1E0678591FFFFFF67859177C1E277C2E277C2E275C2E477C2E277C2E239
        70875B9EBA7AC8E87AC6E679C6E578C4E576C0E3678591FFFFFF67859178C6E7
        78C6E778C6E778C6E878C6E878C6E83970875C9FBB7CCAEB7BC8E97AC7E778C4
        E578C2E3678591FFFFFF6785917CCBEC7CCBEC7CCBED7CCBEC7DCBEC7DCBED39
        70875EA1BD7ECDEE7CCAEB7AC7E878C5E678C4E4678591FFFFFF67859180CFF1
        80CFF180CFF181CFF180CFF181CFF13970875FA3BF81D1F27ECDEE7AC8E979C6
        E779C6E6678591FFFFFF6B889584D5F784D5F684D5F684D5F684D5F684D4F739
        70875596B183D4F581D1F27ECDEE7AC7E85981938AA1ABFFFFFF708C9887DAFC
        87DAFC86DAFE87DAFC86DAFC86D8FC87DAFC3C748B5596B183D4F581D1F26C8F
        9F8FA5AEFFFFFFFFFFFF77929D8BDEFE8BDEFE8BDEFE8BDEFE8BDEFE89DEFE8B
        DEFE8ADDFE447F9785D7F983D4F577929DFFFFFFFFFFFFFFFFFF7E98A28CE2FE
        8EE2FE8EE2FE8EE2FE8EE2FE8CE2FE8EE2FE8CE1FE4C8AA387D9FB85D7F97E98
        A2FFFFFFFFFFFFFFFFFF879FA990E5FE90E7FE90E7FE91E5FE90E5FE91E7FE91
        E7FE90E5FE5495AF88DBFD87D9FB879FA9FFFFFFFFFFFFFFFFFF90A6AF92E8FE
        92E8FE92EAFE92EAFE92E8FE92E8FE92E8FE92E8FE5DA1BC88DBFD88DBFD90A6
        AFFFFFFFFFFFFFFFFFFF9BAFB793EAFE93EAFE93EAFE93EAFE93EAFE93EAFE93
        EAFE93EAFE65ACC988DBFD88DBFD9BAFB7FFFFFFFFFFFFFFFFFFA4B6BE93EAFE
        93EAFE93EAFE93EAFE93EAFE93EAFE93EAFE93EAFE6DB6D588DBFD88DBFDA4B6
        BEFFFFFFFFFFFFFFFFFFD6DEE1B0C0C6B1C0C7B1C0C7B1C0C7B1C0C7B1C0C7B0
        C0C6B1C0C7B1C0C7B1C0C7B1C0C7D6DEE1FFFFFFFFFFFFFFFFFF
      }
      OnClick = SpeedButton1Click
    end
    object UploadBox: TCheckBox
      Left = 16
      Height = 19
      Top = 9
      Width = 84
      Caption = 'Upload image'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object UploadKey: TEdit
      Left = 257
      Height = 21
      Top = 16
      Width = 38
      CharCase = ecUppercase
      MaxLength = 10
      TabOrder = 1
      Text = 'ENTER'
    end
    object UploadShift: TComboBox
      Left = 172
      Height = 22
      Top = 16
      Width = 65
      ItemHeight = 16
      ItemIndex = 0
      Items.Strings = (
        '------'
        'ALT'
        'CTRL'
        'SHIFT'
      )
      Style = csOwnerDrawFixed
      TabOrder = 2
      Text = '------'
    end
    object SaveBox: TCheckBox
      Left = 16
      Height = 19
      Top = 32
      Width = 75
      Caption = 'Save image'
      TabOrder = 3
    end
    object ImagesDir: TEdit
      Left = 16
      Height = 21
      Top = 55
      Width = 257
      TabOrder = 4
      Text = 'ImagesDir'
    end
  end
  object GroupBox3: TGroupBox
    Left = 331
    Height = 110
    Top = 102
    Width = 317
    Caption = 'Result'
    ClientHeight = 92
    ClientWidth = 313
    TabOrder = 3
    object ClipboardBox: TCheckBox
      Left = 16
      Height = 19
      Top = 9
      Width = 134
      Caption = 'Copy result to clipboard'
      Checked = True
      OnClick = ClipboardBoxClick
      State = cbChecked
      TabOrder = 0
    end
    object LinkToClipRadio: TRadioButton
      Left = 16
      Height = 19
      Top = 32
      Width = 122
      Caption = 'Copy link to clipboard'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object ImageToClipRadio: TRadioButton
      Left = 159
      Height = 19
      Top = 32
      Width = 135
      Caption = 'Copy image to clipboard'
      TabOrder = 2
    end
    object AutohideBox: TCheckBox
      Left = 16
      Height = 19
      Top = 57
      Width = 176
      Caption = 'Automatically hide result window'
      TabOrder = 3
    end
  end
  object GroupBox4: TGroupBox
    Left = 331
    Height = 88
    Top = 8
    Width = 317
    Caption = 'Startup'
    ClientHeight = 70
    ClientWidth = 313
    TabOrder = 4
    object StartupBox: TCheckBox
      Left = 16
      Height = 19
      Top = 24
      Width = 144
      Caption = 'Launch on system startup'
      TabOrder = 0
    end
  end
end
