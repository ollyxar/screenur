unit uSettings;

interface

uses
  SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  IniFiles, FileCtrl, Buttons, LCLType, LCLIntf {$IFDEF WINDOWS}, Registry,
  Windows, Messages{$ENDIF}{$IFDEF UNIX}, Hotkey{$ENDIF};

type

  { TSettingsForm }

  TSettingsForm = class(TForm)
    GroupBox1: TGroupBox;
    PrntScrRadio: TRadioButton;
    CustomRadio: TRadioButton;
    ModPrint: TComboBox;
    KeyPrint: TEdit;
    SaveBtn: TButton;
    GroupBox2: TGroupBox;
    UploadBox: TCheckBox;
    UploadKey: TEdit;
    UploadShift: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    SaveBox: TCheckBox;
    ImagesDir: TEdit;
    SpeedButton1: TSpeedButton;
    GroupBox3: TGroupBox;
    ClipboardBox: TCheckBox;
    LinkToClipRadio: TRadioButton;
    ImageToClipRadio: TRadioButton;
    GroupBox4: TGroupBox;
    StartupBox: TCheckBox;
    AutohideBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ClipboardBoxClick(Sender: TObject);
  private
    procedure ShowSettings;
  public
    { Public declarations }
  end;

  ss_State = (ss_None = 0, ss_Alt = 1, ss_Ctrl = 2, ss_Shift = 3);

  TSettings = packed record
    autohide: boolean;
    images_dir: string;
    link_to_clipboard: boolean;
    image_to_clipboard: boolean;
    prnt_key: word;
    prnt_mode: 0 .. 4;
    save: boolean;
    upload: boolean;
    upload_btn1: ss_State;
    upload_btn2: word;
    use_clipboard: boolean;
    use_prntscr: boolean;
    use_startup: boolean;
  end;

procedure LoadSettings;
procedure SaveSettings;
function StringToKey(s: string): word;
function KeyToString(k: word): string;
{$IFDEF UNIX}
procedure ScreenshotCallback;
{$ENDIF}

var
  SettingsForm: TSettingsForm;
  Settings: TSettings;
  {$IFDEF WINDOWS}
  keyid: ATOM;
  {$ENDIF}
  {$IFDEF UNIX}
  hot: THotkeyThread;
  {$ENDIF}

implementation

uses uMain;

{$R *.dfm}

function StringToKey(s: string): word;
begin
  Result := Ord(PChar(s)[0]);
  s := UpperCase(s);
  if s = 'ENTER' then
    Result := $0D
  else if s = 'SHIFT' then
    Result := $10
  else if s = 'ALT' then
    Result := $12
  else if s = 'CTRL' then
    Result := $11
  else if s = 'SPACE' then
    Result := $20
  else if s = 'F1' then
    Result := $70
  else if s = 'F2' then
    Result := $71
  else if s = 'F3' then
    Result := $72
  else if s = 'F4' then
    Result := $73
  else if s = 'F5' then
    Result := $74
  else if s = 'F6' then
    Result := $75
  else if s = 'F7' then
    Result := $76
  else if s = 'F8' then
    Result := $77
  else if s = 'F9' then
    Result := $78
  else if s = 'F10' then
    Result := $79
  else if s = 'F11' then
    Result := $7A
  else if s = 'F12' then
    Result := $7B;
end;

function KeyToString(k: word): string;
begin
  Result := chr(k);
  if k = $0D then
    Result := 'ENTER'
  else if k = $10 then
    Result := 'SHIFT'
  else if k = $12 then
    Result := 'ALT'
  else if k = $11 then
    Result := 'CTRL'
  else if k = $20 then
    Result := 'SPACE'
  else if k = $70 then
    Result := 'F1'
  else if k = $71 then
    Result := 'F2'
  else if k = $72 then
    Result := 'F3'
  else if k = $73 then
    Result := 'F4'
  else if k = $74 then
    Result := 'F5'
  else if k = $75 then
    Result := 'F6'
  else if k = $76 then
    Result := 'F7'
  else if k = $77 then
    Result := 'F8'
  else if k = $78 then
    Result := 'F9'
  else if k = $79 then
    Result := 'F10'
  else if k = $7A then
    Result := 'F11'
  else if k = $7B then
    Result := 'F12';
end;

{$IFDEF UNIX}
procedure ScreenshotCallback;
begin
  MainForm.MakeScreenshot();
end;

{$ENDIF}

procedure TSettingsForm.ClipboardBoxClick(Sender: TObject);
begin
  if ClipboardBox.Checked then
  begin
    LinkToClipRadio.Enabled := True;
    ImageToClipRadio.Enabled := True;
  end
  else
  begin
    LinkToClipRadio.Enabled := False;
    ImageToClipRadio.Enabled := False;
  end;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
begin
  LoadSettings;
  ShowSettings;
  {$IFDEF UNIX}
  SettingsForm.StartupBox.Enabled := False;
  {$ENDIF}
end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
  ShowWindow(Handle, SW_HIDE);
end;

procedure TSettingsForm.SaveBtnClick(Sender: TObject);
begin
  SaveSettings;
  ShowSettings;
  Close;
end;

procedure TSettingsForm.ShowSettings;
begin
  PrntScrRadio.Checked := Settings.use_prntscr;
  UploadBox.Checked := Settings.upload;
  SaveBox.Checked := Settings.save;
  CustomRadio.Checked := not PrntScrRadio.Checked;
  ClipboardBox.Checked := Settings.use_clipboard;
  StartupBox.Checked := Settings.use_startup;
  AutohideBox.Checked := Settings.autohide;

  if ClipboardBox.Checked then
  begin
    LinkToClipRadio.Enabled := True;
    ImageToClipRadio.Enabled := True;
  end
  else
  begin
    LinkToClipRadio.Enabled := False;
    ImageToClipRadio.Enabled := False;
  end;

  LinkToClipRadio.Checked := Settings.link_to_clipboard;
  ImageToClipRadio.Checked := not LinkToClipRadio.Checked;

  case Settings.prnt_mode of
    0:
      ModPrint.ItemIndex := -1;
    1:
      ModPrint.ItemIndex := 0;
    2:
      ModPrint.ItemIndex := 1;
    4:
      ModPrint.ItemIndex := 2
  end;

  KeyPrint.Text := KeyToString(Settings.prnt_key);
  UploadShift.ItemIndex := integer(Settings.upload_btn1);
  UploadKey.Text := KeyToString(Settings.upload_btn2);
  ImagesDir.Text := Settings.images_dir;
end;

procedure TSettingsForm.SpeedButton1Click(Sender: TObject);
var
  root, directory: string;
begin
  directory := ImagesDir.Text;
  if (SelectDirectory('Select a directory', root, directory)) then
    ImagesDir.Text := directory;
end;

procedure LoadSettings;
var
{$IFDEF WINDOWS}
  reg: TRegistry;
{$ENDIF}
{$IFDEF UNIX}
  m: TModifier;
{$ENDIF}
begin
  with Settings do
  begin
    use_startup := False;

    {$IFDEF WINDOWS}
    reg := TRegistry.Create;
    reg.Access := KEY_WOW64_64KEY or KEY_ALL_ACCESS;
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
    if reg.ValueExists('Screenur') then
    begin
      reg.WriteString('Screenur', ParamStr(0));
      use_startup := True;
    end;
    reg.CloseKey;
    reg.Free;
    {$ENDIF}

    use_prntscr := ini.ReadBool('Hook', 'PRNTSCR', True);
    prnt_mode := ini.ReadInteger('Hook', 'MOD', 1);
    prnt_key := ini.ReadInteger('Hook', 'key', 80);
    upload := ini.ReadBool('Pictures', 'upload', True);
    save := ini.ReadBool('Pictures', 'save', False);
    upload_btn1 := ss_State(ini.ReadInteger('Pictures', 'upload_btn1', 0));
    upload_btn2 := ini.ReadInteger('Pictures', 'upload_btn2', 13);
    images_dir := ini.ReadString('Pictures', 'images_dir',
      ExtractFileDir(ParamStr(0)));
    use_clipboard := ini.ReadBool('Result', 'use_clipboard', True);
    link_to_clipboard := ini.ReadBool('Result', 'link_to_clipboard', True);
    image_to_clipboard := ini.ReadBool('Result', 'image_to_clipboard', False);
    autohide := ini.ReadBool('Result', 'autohide', False);
    Volume := ini.ReadInteger('Tools', 'volume', 2);
    MainForm.VolumeImg.Left := Volume * 8 + 5;
    Tools.Prev := TTool(ini.ReadInteger('Tools', 'prev', 1));
    MainForm.ColorImg.Left := ini.ReadInteger('Tools', 'color_x', 209);
  end;

  if Settings.use_prntscr then
  begin
    {$IFDEF WINDOWS}
    keyid := GlobalAddAtom('Screenur hotkey');
    RegisterHotKey(MainForm.handle, keyid, 0, VK_SNAPSHOT);
    {$ENDIF}
    {$IFDEF UNIX}
    hot := THotkeyThread.Create(@ScreenshotCallback, 'Print', NoModifier, True);
    {$ENDIF}
  end
  else
  begin
    {$IFDEF WINDOWS}
    RegisterHotKey(MainForm.Handle, keyid, Settings.prnt_mode, Settings.prnt_key);
    {$ENDIF}
    {$IFDEF UNIX}
    case Settings.prnt_mode of
      0: m := NoModifier;
      1: m := KeyAlt;
      2: m := KeyControl;
      3: m := KeyShift;
      else
        m := NoModifier;
    end;

    hot := THotkeyThread.Create(@ScreenshotCallback,
      PChar(KeyToString(Settings.prnt_key)), m, True);
    {$ENDIF}
  end;
  {$IFDEF UNIX}
  if Assigned(SettingsForm) then
    hot.Start;
  {$ENDIF}
end;

procedure SaveSettings;
{$IFDEF WINDOWS}
var
  reg: TRegistry;
{$ENDIF}
begin
  with SettingsForm do
  begin
    {$IFDEF WINDOWS}
    reg := TRegistry.Create;
    reg.Access := KEY_WOW64_64KEY or KEY_ALL_ACCESS;
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
    if StartupBox.Checked then
      reg.WriteString('Screenur', ParamStr(0))
    else
      reg.DeleteValue('Screenur');
    reg.CloseKey;
    reg.Free;
    {$ENDIF}
    {$IFDEF UNIX}
    hot.Terminate;
    hot.Free;
    {$ENDIF}

    ini.WriteBool('Hook', 'PRNTSCR', PrntScrRadio.Checked);
    case ModPrint.ItemIndex of
      0:
        ini.WriteInteger('Hook', 'MOD', 1);
      1:
        ini.WriteInteger('Hook', 'MOD', 2);
      2:
        ini.WriteInteger('Hook', 'MOD', 4);
    end;
    ini.WriteInteger('Hook', 'key', StringToKey(KeyPrint.Text));
    ini.WriteBool('Pictures', 'upload', UploadBox.Checked);
    ini.WriteBool('Pictures', 'save', SaveBox.Checked);
    ini.WriteInteger('Pictures', 'upload_btn1', UploadShift.ItemIndex);
    ini.WriteInteger('Pictures', 'upload_btn2', StringToKey(UploadKey.Text));
    ini.WriteString('Pictures', 'images_dir', ImagesDir.Text);
    ini.WriteBool('Result', 'use_clipboard', ClipboardBox.Checked);
    ini.WriteBool('Result', 'link_to_clipboard', LinkToClipRadio.Checked);
    ini.WriteBool('Result', 'image_to_clipboard', ImageToClipRadio.Checked);
    ini.WriteBool('Result', 'autohide', AutohideBox.Checked);
    ini.WriteInteger('Tools', 'color_x', MainForm.ColorImg.Left);
    ini.WriteInteger('Tools', 'volume', Volume);
    ini.WriteInteger('Tools', 'prev', integer(Tools.Prev));
  end;
  LoadSettings;
end;

end.
