unit uMain;

interface

uses
  {$IFDEF WINDOWS}Windows, Messages,{$ENDIF} Classes, SysUtils, FileUtil,
  UniqueInstance, IdHTTP, IdSSLOpenSSL,
  IdAntiFreeze, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, Menus,
  Spin, IdMultipartFormData, EncdDecd, IniFiles, LCLType, IntfGraphics,
  LCLIntf, Math, Clipbrd, fpjson, jsonparser, FPimage, Types, dateutils,
  versionSupport;

type
  { TMainForm }
  TMainForm = class(TForm)
    ArrowBtn: TImage;
    BackImg: TImage;
    CircleBtn: TImage;
    ColorImg: TImage;
    ForwardImg: TImage;
    HoverImg: TImage;
    http: TIdHTTP;
    IdAntiFreeze1: TIdAntiFreeze;
    DragImg: TImage;
    ImageList1: TImageList;
    LineBtn: TImage;
    {$IFDEF WINDOWS}
    MainImage: TPaintBox;
    {$ELSE}
    {$IFDEF UNIX}
    MainImage: TImage;
    {$ENDIF}
    {$ENDIF}
    PalleteImg: TImage;
    TextPnl: TPanel;
    PencilBtn: TImage;
    PressedImg: TImage;
    ResizeImg: TImage;
    About2: TMenuItem;
    MenuItem1: TMenuItem;
    Exit2: TMenuItem;
    Printscreen1: TMenuItem;
    History1: TMenuItem;
    ScissorsBtn: TImage;
    Settings1: TMenuItem;
    PopupMenu1: TPopupMenu;
    FontSizeEdit: TSpinEdit;
    SquareBtn: TImage;
    ssl: TIdSSLIOHandlerSocketOpenSSL;
    Memo1: TMemo;
    HideTimer: TTimer;
    TextBtn: TImage;
    HotkeyTimer: TTimer;
    ToolsImg: TImage;
    ToolsPnl: TPanel;
    TrayIcon1: TTrayIcon;
    UniqueInstance1: TUniqueInstance;
    UploadBtn: TImage;
    VolumeImg: TImage;
    VolumePaletteImg: TImage;
    procedure About2Click(Sender: TObject);
    procedure ArrowBtnClick(Sender: TObject);
    procedure ArrowBtnMouseEnter(Sender: TObject);
    procedure BackImgClick(Sender: TObject);
    procedure CircleBtnClick(Sender: TObject);
    procedure CircleBtnMouseEnter(Sender: TObject);
    procedure ColorImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ColorImgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure ColorImgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure DragImgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure Exit2Click(Sender: TObject);
    procedure FontSizeEditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ForwardImgClick(Sender: TObject);
    procedure HideTimerTimer(Sender: TObject);
    procedure History1Click(Sender: TObject);
    procedure HotkeyTimerTimer(Sender: TObject);
    procedure LineBtnClick(Sender: TObject);
    procedure LineBtnMouseEnter(Sender: TObject);
    procedure MainImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure MainImageMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure MainImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure MainImagePaint(Sender: TObject);
    procedure Painter;
    procedure Memo1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure PalleteImgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure PencilBtnClick(Sender: TObject);
    procedure PencilBtnMouseEnter(Sender: TObject);
    procedure PencilBtnMouseLeave(Sender: TObject);
    procedure Printscreen1Click(Sender: TObject);
    procedure ResizeImgMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure ScissorsBtnClick(Sender: TObject);
    procedure ScissorsBtnMouseEnter(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure SquareBtnClick(Sender: TObject);
    procedure SquareBtnMouseEnter(Sender: TObject);
    procedure TextBtnClick(Sender: TObject);
    procedure TextBtnMouseEnter(Sender: TObject);
    procedure TextPnlPaint(Sender: TObject);
    procedure ToolsImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ToolsImgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure TrayIcon1Click(Sender: TObject);
    procedure UploadBtnClick(Sender: TObject);
    procedure VolumeImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure VolumeImgMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure VolumeImgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
  private
    FShift: TShiftState;
    FX, FY: integer;
    pressed_x, pressed_y: integer;
    volume_x, color_x: integer;
    procedure PencilPaint(X, Y: integer; Original: boolean = False);
    procedure ArrowPaint(X, Y: integer; Original: boolean = False);
    procedure LinePaint(X, Y: integer; Original: boolean = False);
    procedure CatchUp;
    procedure SquarePaint(X, Y: integer; Original: boolean = False);
    procedure CirclePaint(X, Y: integer; Original: boolean = False);
    procedure ScissorsPaint(X, Y: integer; Original: boolean = False);
    procedure ScissorsMove(X, Y: integer; Shift: TShiftState = []);
    procedure FillTextBackground;
    procedure FillMemoBackground;
  public
    procedure PrepareBitmap;
    procedure Upload;
    procedure SaveImg;
    procedure TextPaint;
    procedure MakeScreenshot(n: integer = -1);
    procedure Undo;
    procedure GoForward;
    procedure SelectionPaint(Movement: boolean = False);
  end;

  TTool = (iNone, iText, iPencil, iArrow, iLine, iCircle, iSquare,
    iScissors);

  { TTools }

  TTools = class
  private
    FCurrent: TTool;
    procedure OnChange(t: TTool);
  public
    Prev: TTool;
    property Current: TTool read FCurrent write OnChange;
  end;

  { TScissors }

  TScissors = class
  public
    SelectedRect: TRect;
    CurrentRect: TRect;
    PrevRect: TRect;
    Selected: boolean;
    Moving: boolean;
    FB: TBitmap;
    function InRect(X, Y: word): boolean;
    constructor Create;
    destructor Destroy; override;
  end;

  { THistory }

  THistory = class
  private
    Points: array of TBitmap;
    Current: integer;
  const
    Limit = 20;
  public
    CanBack: boolean;
    CanForward: boolean;
    Overlay: TBitmap;
    Original: TBitmap;
    constructor Create;
    destructor Destroy; override;
    procedure Add(Point: TBitmap);
    procedure OnChange;
    procedure Clear;
    function Back: TBitmap;
    function GoForward: TBitmap;
    function GetCurrent: TBitmap;
  end;

  { TUploadThread }
  TUploadThread = class(TThread)
  private
    procedure MyModal;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: boolean);
  end;

procedure GlobalHide;
procedure MyModalProcess;
procedure UploadProcess;
function Overlay(InputColor: TFPColor; n: shortint = 32): TFPColor;

var
  MainForm: TMainForm;
  Tools: TTools;
  Scissors: TScissors;
  coordX: integer;
  coordY: integer;
  History: THistory;
  Ini: TIniFile;
  CurrentMonitor: TMonitor;
  MyMouse: TPoint;
  fromX: integer = 0;
  fromY: integer = 0;
  toX: integer = 0;
  toY: integer = 0;
  SelectedFrom, SelectedTo: TPoint;
  BmpPen: TBitmap;
  Volume: integer = 2;
  Colour: TColor = clLime;
  first_start: boolean = True;
  FMustClose: boolean = False;
  Link: string;

implementation

{$R *.lfm}

uses uModal, uSettings, uHistory;

procedure GlobalHide;
begin
  MainForm.Hide;
  History.Clear;
end;

procedure DrawAntialisedLine(Canvas: TCanvas; const AX1, AY1, AX2, AY2: real;
  const LineColor: TColor);
var
  swapped: boolean;

  procedure plot(const x, y, c: real);
  var
    resclr: TColor;
  begin
    if swapped then
      resclr := Canvas.Pixels[round(y), round(x)]
    else
      resclr := Canvas.Pixels[round(x), round(y)];
    resclr := RGB(round(GetRValue(resclr) * (1 - c) + GetRValue(LineColor) * c),
      round(GetGValue(resclr) * (1 - c) + GetGValue(LineColor) * c),
      round(GetBValue(resclr) * (1 - c) + GetBValue(LineColor) * c));
    if swapped then
      Canvas.Pixels[round(y), round(x)] := resclr
    else
      Canvas.Pixels[round(x), round(y)] := resclr;
  end;

  function rfrac(const x: real): real; inline;
  begin
    rfrac := 1 - frac(x);
  end;

  procedure swap(var a, b: real);
  var
    tmp: real;
  begin
    tmp := a;
    a := b;
    b := tmp;
  end;

var
  x1, x2, y1, y2, dx, dy, gradient, xend, yend, xgap, xpxl1, ypxl1,
  xpxl2, ypxl2, intery: real;
  x: integer;

begin

  x1 := AX1;
  x2 := AX2;
  y1 := AY1;
  y2 := AY2;

  dx := x2 - x1;
  dy := y2 - y1;
  swapped := abs(dx) < abs(dy);
  if swapped then
  begin
    swap(x1, y1);
    swap(x2, y2);
    swap(dx, dy);
  end;
  if x2 < x1 then
  begin
    swap(x1, x2);
    swap(y1, y2);
  end;

  if dx = 0 then dx := 0.000000001;
  gradient := dy / dx;

  xend := round(x1);
  yend := y1 + gradient * (xend - x1);
  xgap := rfrac(x1 + 0.5);
  xpxl1 := xend;
  ypxl1 := floor(yend);
  plot(xpxl1, ypxl1, rfrac(yend) * xgap);
  plot(xpxl1, ypxl1 + 1, frac(yend) * xgap);
  intery := yend + gradient;

  xend := round(x2);
  yend := y2 + gradient * (xend - x2);
  xgap := frac(x2 + 0.5);
  xpxl2 := xend;
  ypxl2 := floor(yend);
  plot(xpxl2, ypxl2, rfrac(yend) * xgap);
  plot(xpxl2, ypxl2 + 1, frac(yend) * xgap);

  for x := round(xpxl1) + 1 to round(xpxl2) - 1 do
  begin
    plot(x, floor(intery), rfrac(intery));
    plot(x, floor(intery) + 1, frac(intery));
    intery := intery + gradient;
  end;

end;

{ TTools }

procedure TTools.OnChange(t: TTool);
var
  Cur: TCursorImage;
const
  crPen = 5;
begin
  if t = iNone then
  begin
    MainForm.PressedImg.Visible := False;
    MainForm.MainImage.Cursor := crCross;
  end
  else
  begin
    MainForm.PressedImg.Visible := True;
    Prev := t;
    SaveSettings;
  end;

  FCurrent := t;

  if t = iSquare then
  begin
    MainForm.MainImage.Cursor := crArrow;
    MainForm.PressedImg.Left := MainForm.SquareBtn.Left;
  end;

  if t = iScissors then
  begin
    MainForm.MainImage.Cursor := crCross;
    Scissors.FB.Assign(History.GetCurrent);
    MainForm.PressedImg.Left := MainForm.ScissorsBtn.Left;
  end;

  if t = iArrow then
  begin
    MainForm.MainImage.Cursor := crArrow;
    MainForm.PressedImg.Left := MainForm.ArrowBtn.Left;
  end;

  if t = iPencil then
  begin
    Cur := TCursorImage.Create;
    Cur.LoadFromResourceName(HINSTANCE, 'PEN');
    Screen.Cursors[crPen] := Cur.ReleaseHandle;
    Cur.Free;
    MainForm.MainImage.Cursor := crPen;
    BmpPen.Height := History.GetCurrent.Height;
    BmpPen.Width := History.GetCurrent.Width;
    BmpPen.Canvas.CopyRect(History.GetCurrent.Canvas.ClipRect,
      History.GetCurrent.Canvas, History.GetCurrent.Canvas.ClipRect);
    MainForm.PressedImg.Left := MainForm.PencilBtn.Left;
  end;

  if t = iLine then
  begin
    MainForm.MainImage.Cursor := crArrow;
    MainForm.PressedImg.Left := MainForm.LineBtn.Left;
  end;

  if t = iCircle then
  begin
    MainForm.MainImage.Cursor := crArrow;
    MainForm.PressedImg.Left := MainForm.CircleBtn.Left;
  end;

  if t = iText then
  begin
    MainForm.MainImage.Cursor := crIBeam;
    MainForm.PressedImg.Left := MainForm.TextBtn.Left;
  end;
end;

{ TMainForm }

procedure TMainForm.Undo;
var
  B: TBitmap;
begin
  B := TBitmap.Create;
  B.Assign(History.Back);
  MainImage.Canvas.CopyRect(B.Canvas.ClipRect, B.Canvas, B.Canvas.ClipRect);
  B.Free;
  {$IFDEF UNIX}
  SelectionPaint;
  {$ENDIF}
end;

procedure TMainForm.Upload;
{$IFDEF WINDOWS}
var
  UploadThread: TUploadThread;
{$ENDIF}
begin
  {$IFDEF WINDOWS}
  UploadThread := TUploadThread.Create(True);
  {$ENDIF}
  TrayIcon1.Animate := True;
  TrayIcon1.AnimateInterval := 50;
  TrayIcon1.Icons := ImageList1;
  {$IFDEF WINDOWS}
  UploadThread.Start;
  {$ENDIF}
  {$IFDEF UNIX}
  UploadProcess;
  if Link <> '' then
    MyModalProcess;
  {$ENDIF}
end;


procedure TMainForm.SaveImg;
var
  jpgImg: TJPEGImage;
  r: TRect;
begin
  r.Left := Min(SelectedFrom.x, SelectedTo.x);
  r.Top := Min(SelectedFrom.y, SelectedTo.y);
  r.Right := Max(SelectedFrom.x, SelectedTo.x);
  r.Bottom := Max(SelectedFrom.y, SelectedTo.y);
  jpgImg := TJPEGImage.Create;
  jpgImg.CompressionQuality := 100;
  jpgImg.LoadFromBitmapHandles(History.GetCurrent.Handle,
    History.GetCurrent.MaskHandle, @r);
  GlobalHide;
  jpgImg.SaveToFile(Settings.images_dir + '\' +
    FormatDateTime('yyyy-mm-dd_hh-nn-ss', now) + '.jpg');
  jpgImg.Free;
end;

procedure TMainForm.TextPaint;
var
  i: integer;
  B: TBitmap;
begin
  B := TBitmap.Create;
  B.Height := History.GetCurrent.Height;
  B.Width := History.GetCurrent.Width;
  B.Canvas.CopyRect(History.GetCurrent.Canvas.ClipRect,
    History.GetCurrent.Canvas, History.GetCurrent.Canvas.ClipRect);

  with B.Canvas do
  begin
    Brush.Style := bsClear;
    Font.color := Colour;
    Font.Size := FontSizeEdit.Value;
    for i := 0 to Memo1.Lines.Count - 1 do
      TextOut(TextPnl.Left + Memo1.Left + TextWidth('s'), TextPnl.Top + Memo1.Top + 2 + i *
        (trunc(FontSizeEdit.Value * 1.8)), Memo1.Lines[i]);
  end;
  History.Add(B);
  B.Free;
  Memo1.Clear;
  TextPnl.Visible := False;
end;

procedure TMainForm.MakeScreenshot(n: integer = -1);
var
  DC: HDC;
  C: TCanvas;
  R: TRect;
  B: TBitmap;
  tmp_img: TLazIntfImage;
  ImgHandle, ImgMaskHandle: HBitmap;
  x, y: integer;
begin
  MyMouse.x := Mouse.CursorPos.X;
  MyMouse.y := Mouse.CursorPos.Y;
  if n > -1 then
    CurrentMonitor := Screen.Monitors[n]
  else
    CurrentMonitor := Screen.MonitorFromPoint(MyMouse);

  DC := GetDC(0);
  try
    C := TCanvas.Create;
    B := TBitmap.Create;
    try
      R := CurrentMonitor.BoundsRect;
      MainImage.Width := R.Right - R.Left;
      MainImage.Height := R.Bottom - R.Top;

      {$IFDEF UNIX}
      B.LoadFromDevice(DC);
      MainImage.Canvas.CopyRect(Rect(0, 0, R.Right - R.Left, R.Bottom - R.Top),
        B.Canvas, R);
      B.Canvas.CopyRect(Rect(0, 0, R.Right - R.Left, R.Bottom - R.Top), B.Canvas, R);
      B.Width := MainImage.Width;
      B.Height := MainImage.Height;
      {$ENDIF}

      {$IFDEF WINDOWS}
      B.Width := MainImage.Width;
      B.Height := MainImage.Height;
      C.Handle := DC;
      B.Canvas.CopyRect(Rect(0, 0, R.Right - R.Left, R.Bottom - R.Top), C, R);
      MainImage.Canvas.CopyRect(Rect(0, 0, R.Right - R.Left, R.Bottom - R.Top), C, R);
      {$ENDIF}

      History.Original.Assign(B);

      tmp_img := TLazIntfImage.Create(MainImage.Width, MainImage.Height);
      tmp_img.LoadFromBitmap(B.Handle, B.MaskHandle);

      for y := 0 to R.Bottom - R.Top - 1 do
      begin
        for x := 0 to R.Right - R.Left - 1 do
        begin
          tmp_img.Colors[x, y] := Overlay(tmp_img.Colors[x, y]);
        end;
      end;
      tmp_img.CreateBitmaps(ImgHandle, ImgMaskHandle, False);
      tmp_img.Free;
      B.Handle := ImgHandle;
      B.MaskHandle := ImgMaskHandle;
      MainImage.Canvas.CopyRect(B.Canvas.ClipRect, B.Canvas, B.Canvas.ClipRect);
      History.Overlay.Assign(B);
    finally
      C.Free;
      B.Free;
    end;
  finally
    ReleaseDC(0, DC);
  end;

  CatchUp;
end;

procedure TMainForm.DragImgMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  if ssLeft in Shift then
  begin
    TextPnl.Left := TextPnl.Left + X - DragImg.Width div 2;
    TextPnl.Top := TextPnl.Top + Y - DragImg.Height div 2;
    FillMemoBackground;
    Refresh;
  end;
end;

procedure TMainForm.About2Click(Sender: TObject);
begin
  Application.MessageBox(
    'Author: Olexy Sviridenko aka Alex Slipknot (alexslipknot@europe.com)',
    PChar('Screenur v ' + GetFileVersion), MB_ICONASTERISK);
end;

procedure TMainForm.ArrowBtnClick(Sender: TObject);
begin
  Tools.Current := iArrow;
  MainForm.TextPaint;
end;

procedure TMainForm.ArrowBtnMouseEnter(Sender: TObject);
begin
  HoverImg.Visible := True;
  HoverImg.Left := ArrowBtn.Left;
end;

procedure TMainForm.BackImgClick(Sender: TObject);
begin
  Undo;
end;

procedure TMainForm.CircleBtnClick(Sender: TObject);
begin
  Tools.Current := iCircle;
  TextPaint;
end;

procedure TMainForm.CircleBtnMouseEnter(Sender: TObject);
begin
  HoverImg.Visible := True;
  HoverImg.Left := CircleBtn.Left;
end;

procedure TMainForm.ColorImgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  color_x := X;
end;

procedure TMainForm.ColorImgMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  if ssLeft in Shift then
  begin
    if (ColorImg.Left >= 111) and (ColorImg.Left <= 410) then
    begin
      ColorImg.Left := ColorImg.Left + X - color_x;
      Colour := ToolsImg.Picture.Bitmap.Canvas.Pixels[ColorImg.Left +
        3, ColorImg.Top + 6];
      Memo1.Font.Color := Colour;
      with ColorImg.Picture.Bitmap.Canvas do
      begin
        Pen.Style := psClear;
        Brush.Color := Colour;
        Brush.Style := bsSolid;
        Ellipse(4, 4, 12, 12);
      end;
    end;
    if ColorImg.Left + X - color_x < 111 then
      ColorImg.Left := 111;
    if ColorImg.Left + X - color_x > 410 then
      ColorImg.Left := 410;
  end;
end;

procedure TMainForm.ColorImgMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  // prevent fast movement
  if ColorImg.Left < 111 then
    ColorImg.Left := 111;
  if ColorImg.Left > 410 then
    ColorImg.Left := 410;
  SaveSettings;
end;

function Overlay(InputColor: TFPColor; n: shortint = 32): TFPColor;
begin
  Result.Red := (InputColor.Red * n) shr 6;
  Result.Green := (InputColor.Green * n) shr 6;
  Result.Blue := (InputColor.Blue * n) shr 6;
end;

procedure TMainForm.ArrowPaint(X, Y: integer; Original: boolean = False);
var
  i, j: integer;
  overall: integer;
  Points: array of TPoint;
  deltax, deltay: extended;
  lx, ly, kx, ky: extended;
  C: TCanvas;
  B: TBitmap;
begin
  overall := (Volume - 1) div 2;
  C := TCanvas.Create;
  if Original then
  begin
    B := TBitmap.Create;
    B.Height := History.GetCurrent.Height;
    B.Width := History.GetCurrent.Width;
    B.Canvas.CopyRect(History.GetCurrent.Canvas.ClipRect,
      History.GetCurrent.Canvas, History.GetCurrent.Canvas.ClipRect);
    C.Handle := B.Canvas.Handle;
  end
  else
  begin
    SelectionPaint;
    C.Handle := MainImage.Canvas.Handle;
  end;

  with C do
  begin
    // paint arrow
    Pen.color := Colour;
    Brush.Style := bsClear;

    deltax := coordX - X;
    deltay := coordY - Y;
    kx := Sign(deltax);
    ky := Sign(deltay);

    if deltay = 0 then
      deltay := 1;

    if Abs(deltax) > Abs(deltay) then
      ky := kx * deltay / deltax
    else
      kx := ky * deltax / deltay;
    lx := coordX;
    ly := coordY;

    SetLength(Points, 3);
    Points[0] := Point(Round(lx - Volume * 7 * kx + Volume * 2 * ky),
      Round(ly - Volume * 7 * ky - Volume * 2 * kx));
    Points[1] := Point(Round(lx), Round(ly));
    Points[2] := Point(Round(lx - Volume * 7 * kx - Volume * 2 * ky),
      Round(ly - Volume * 7 * ky + Volume * 2 * kx));

    Brush.Color := Colour;
    Brush.Style := bsSolid;
    Polygon(Points);
    Brush.Style := bsClear;

    // fix for linux to prevent not clear text
    Polygon(Points);

    // pain line for arrow
    for i := -overall to (overall * 2 + 1) do
      for j := -overall to (overall * 2 + 1) do
      begin
        //MoveTo(coordX, coordY);
        //LineTo(X + i, Y + j);
        DrawAntialisedLine(C, coordX, coordY, X + i, Y + j, Colour);
      end;
  end;

  if Original then
  begin
    History.Add(B);
    B.Free;
  end;

  C.Free;
end;

procedure TMainForm.LinePaint(X, Y: integer; Original: boolean = False);
var
  C: TCanvas;
  B: TBitmap;
  i, j: integer;
  overall: integer;
begin
  overall := (Volume - 1) div 2;
  C := TCanvas.Create;

  if Original then
  begin
    B := TBitmap.Create;
    B.Height := History.GetCurrent.Height;
    B.Width := History.GetCurrent.Width;
    B.Canvas.CopyRect(History.GetCurrent.Canvas.ClipRect,
      History.GetCurrent.Canvas, History.GetCurrent.Canvas.ClipRect);
    C.Handle := B.Canvas.Handle;
  end
  else
  begin
    SelectionPaint;
    C.Handle := MainImage.Canvas.Handle;
  end;

  with C do
  begin
    // pain line
    Pen.color := Colour;
    for i := -overall to (overall * 2 + 1) do
      for j := -overall to (overall * 2 + 1) do
      begin
        {MoveTo(coordX + i, coordY + j);
        LineTo(X + i, Y + j);}
        //Line(coordX + i, coordY + j, X + i, Y + j);
        DrawAntialisedLine(C, coordX + i, coordY + j, X + i, Y + j, Colour);
      end;

  end;

  if Original then
  begin
    History.Add(B);
    B.Free;
  end;

  C.Free;
end;

procedure TMainForm.Exit2Click(Sender: TObject);
begin
  FMustClose := True;
  MainForm.Close;
end;

procedure TMainForm.FontSizeEditChange(Sender: TObject);
begin
  Memo1.Font.Size := FontSizeEdit.Value;
  Memo1.Refresh;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  cur: TCursorImage;
  i: integer;
  mi: TMenuItem;
begin
  DoubleBuffered := True;
  TextPnl.DoubleBuffered := True;
  FontSizeEdit.DoubleBuffered := True;
  {$IFDEF WINDOWS}
  MainImage := TPaintBox.Create(Self);
  {$ENDIF}
  {$IFDEF UNIX}
  MainImage := TImage.Create(Self);
  {$ENDIF}
  MainImage.Parent := MainForm;
  MainImage.OnMouseDown := @MainImageMouseDown;
  MainImage.OnMouseMove := @MainImageMouseMove;
  MainImage.OnMouseUp := @MainImageMouseUp;
  MainImage.OnPaint := @MainImagePaint;

  History := THistory.Create;
  Scissors := TScissors.Create;
  Tools := TTools.Create;
  BmpPen := TBitmap.Create;

  Tools.Current := iNone;
  Tools.Prev := iArrow;

  Ini := TIniFile.Create(GetUserDir + 'screenur.ini');
  LoadSettings;
  {$IFDEF WINDOWS}
  HotkeyTimer.Enabled := True;
  {$ENDIF}
  Width := 0;
  Height := 0;
  http.Request.CustomHeaders.Add('Authorization: Client-ID bd4169f5e5586d1');

  TrayIcon1.Visible := True;
  MainForm.Hide;

  cur := TCursorImage.Create;
  cur.LoadFromResourceName(HINSTANCE, 'CROSS');
  Screen.Cursors[crCross] := cur.ReleaseHandle;
  cur.Free;
  MainImage.Cursor := crCross;

  ColorImgMouseMove(self, [ssLeft], 0, 0);
  MainForm.ShowInTaskBar := stNever;
  if Screen.MonitorCount > 1 then
  begin
    for i := 1 to Screen.MonitorCount - 1 do
    begin
      mi := TMenuItem.Create(PopupMenu1);
      mi.Caption := 'Print screen (monitor ' + IntToStr(i + 1) + ')';
      mi.OnClick := @Printscreen1Click;
      mi.ImageIndex := i;
      PopupMenu1.Items.Insert(i, mi);
    end;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  {$IFDEF WINDOWS}
  UnregisterHotKey(handle, keyid);
  GlobalDeleteAtom(keyid);
  {$ENDIF}
  Ini.Free;
  History.Free;
  Scissors.Free;
  Tools.Free;
  BmpPen.Free;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (not MainForm.Visible) then
    Exit;

  if Key = VK_ESCAPE then
  begin
    GlobalHide;
  end;

  if (ssCtrl in Shift) and (Key = $31) then
  begin
    ScissorsBtnClick(Self);
  end;
  if (ssCtrl in Shift) and (Key = $32) then
  begin
    PencilBtnClick(Self);
  end;
  if (ssCtrl in Shift) and (Key = $33) then
  begin
    LineBtnClick(Self);
  end;
  if (ssCtrl in Shift) and (Key = $34) then
  begin
    ArrowBtnClick(Self);
  end;
  if (ssCtrl in Shift) and (Key = $35) then
  begin
    TextBtnClick(Self);
  end;
  if (ssCtrl in Shift) and (Key = $36) then
  begin
    CircleBtnClick(Self);
  end;
  if (ssCtrl in Shift) and (Key = $37) then
  begin
    SquareBtnClick(Self);
  end;

  if (ssCtrl in Shift) and (ssShift in Shift) and (Key = $5A) then
  begin
    GoForward;
    Exit;
  end;
  if (ssCtrl in Shift) and (Key = $5A) then
  begin
    Undo;
    Exit;
  end;

  if Key = Settings.upload_btn2 then
  begin
    if (Settings.upload_btn1 = ss_None) and (Tools.Current <> iText) then
    begin
      PrepareBitmap;
      if Settings.Upload then
        Upload;
      if Settings.save then
        SaveImg;
    end
    else if (ssCtrl in Shift) and (Settings.upload_btn1 = ss_Ctrl) then
    begin
      PrepareBitmap;
      if Settings.Upload then
        Upload;
      if Settings.save then
        SaveImg;
    end
    else if (ssShift in Shift) and (Settings.upload_btn1 = ss_Shift) then
    begin
      PrepareBitmap;
      if Settings.Upload then
        Upload;
      if Settings.save then
        SaveImg;
    end
    else if (ssAlt in Shift) and (Settings.upload_btn1 = ss_Alt) then
    begin
      PrepareBitmap;
      if Settings.Upload then
        Upload;
      if Settings.save then
        SaveImg;
    end;
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  ShowWindow(Handle, SW_HIDE);
  if first_start then
  begin
    first_start := False;
    MainForm.Hide;
  end;
end;

procedure TMainForm.ForwardImgClick(Sender: TObject);
begin
  GoForward;
end;

procedure TMainForm.HideTimerTimer(Sender: TObject);
var
  i: integer;
begin
  ModalForm.AlphaBlend := True;
  HideTimer.Enabled := False;

  i := 255;

  while i > 50 do
  begin
    i := i - 10;
    ModalForm.AlphaBlendValue := i;
    Sleep(1);
    Application.ProcessMessages;
  end;

  ModalForm.Close;
  ModalForm.AlphaBlendValue := 50;
end;

procedure TMainForm.History1Click(Sender: TObject);
begin
  HistoryForm.Show;
end;

procedure TMainForm.HotkeyTimerTimer(Sender: TObject);
{$IFDEF WINDOWS}
var
  message: MSG;
{$ENDIF}
begin
  {$IFDEF WINDOWS}
  HotkeyTimer.Enabled := False;
  while GetMessage(message, 0, 0, 0) do
  begin
    if message.message = WM_HOTKEY then
    begin
      MainForm.MakeScreenshot;
      sleep(10);
    end;
    if FMustClose then
    begin
      break;
      Close;
    end;
    TranslateMessage(message);
    DispatchMessage(message);
  end;
  {$ENDIF}
end;

procedure TMainForm.LineBtnClick(Sender: TObject);
begin
  Tools.Current := iLine;
  MainForm.TextPaint;
end;

procedure TMainForm.LineBtnMouseEnter(Sender: TObject);
begin
  HoverImg.Visible := True;
  HoverImg.Left := LineBtn.Left;
end;

procedure TMainForm.GoForward;
var
  B: TBitmap;
begin
  B := TBitmap.Create;
  B.Assign(History.GoForward);
  MainImage.Canvas.CopyRect(B.Canvas.ClipRect, B.Canvas, B.Canvas.ClipRect);
  B.Free;
  {$IFDEF UNIX}
  SelectionPaint;
  {$ENDIF}
end;

procedure TMainForm.SelectionPaint(Movement: boolean = False);
var
  t_posX, t_posY, l_posX, l_posY, t_left: integer;
  p: TPoint;
  r: TRect;
begin
  if Movement then
  begin
    p.x := FX;
    p.y := FY;
  end
  else
    p := SelectedTo;

  r.Left := Min(SelectedFrom.X, p.X);
  r.Top := Min(SelectedFrom.Y, p.Y);
  r.Right := Max(SelectedFrom.X, p.X);
  r.Bottom := Max(SelectedFrom.Y, p.Y);

  with MainImage.Canvas do
  begin
    CopyRect(ClientRect, History.Overlay.Canvas, ClientRect);

    if (Tools.Current = iPencil) and (ssLeft in FShift) then
    begin
      CopyRect(r, BmpPen.Canvas, r);
    end
    else
    if Tools.Current = iScissors then
    begin
      CopyRect(r, Scissors.FB.Canvas, r);
    end
    else
    begin
      CopyRect(r, History.GetCurrent.Canvas, r);
    end;

    MoveTo(SelectedFrom.x, 0);
    LineTo(SelectedFrom.x, Height);

    MoveTo(p.x, 0);
    LineTo(p.x, Height);

    MoveTo(0, SelectedFrom.y);
    LineTo(Width, SelectedFrom.y);

    MoveTo(0, p.y);
    LineTo(Width, p.y);

    Pen.Mode := pmCopy;
    Brush.Style := bsClear;

    if p.x < SelectedFrom.x then
      t_posX := p.x + abs(p.x - SelectedFrom.x) div 2 -
        TextWidth(IntToStr(abs(p.x - SelectedFrom.x))) div 2
    else
      t_posX := SelectedFrom.x + abs(p.x - SelectedFrom.x) div 2 -
        TextWidth(IntToStr(abs(p.x - SelectedFrom.x))) div 2;

    if p.y < SelectedFrom.y then
      t_posY := p.y - 20
    else
      t_posY := SelectedFrom.y - 20;

    if p.x < SelectedFrom.x then
      l_posX := p.x - 10 - TextWidth(IntToStr(abs(p.y - SelectedFrom.y)))
    else
      l_posX := SelectedFrom.x - 10 -
        TextWidth(IntToStr(abs(p.y - SelectedFrom.y)));

    if p.y < SelectedFrom.y then
      l_posY := p.y + abs(p.Y - SelectedFrom.Y) div 2 -
        TextWidth(IntToStr(abs(p.Y - SelectedFrom.Y))) div 2
    else
      l_posY := SelectedFrom.Y + abs(p.Y - SelectedFrom.Y) div 2 -
        TextWidth(IntToStr(abs(p.Y - SelectedFrom.Y))) div 2;

    if Movement then
    begin
      if FX < fromX then
        t_left := FX + (fromX - FX) div 2 - ToolsPnl.Width div 2
      else
        t_left := fromX - (fromX - FX) div 2 - ToolsPnl.Width div 2;
      ToolsPnl.Left := t_left;

      if FY < fromY then
      begin
        if CurrentMonitor.Height - fromY > ToolsPnl.Height then
          ToolsPnl.Top := fromY
        else if FY - CurrentMonitor.Top > ToolsPnl.Height then
          ToolsPnl.Top := FY - ToolsPnl.Height
        else
          ToolsPnl.Top := fromY - ToolsPnl.Height;
      end
      else
      begin
        if CurrentMonitor.Height - FY > ToolsPnl.Height then
          ToolsPnl.Top := FY
        else if fromY - CurrentMonitor.Top > ToolsPnl.Height then
          ToolsPnl.Top := fromY - ToolsPnl.Height
        else
          ToolsPnl.Top := FY - ToolsPnl.Height;
      end;
    end;
    Brush.Style := bsClear;
    Font.Color := clLime;
    Font.Size := 12;

    TextOut(t_posX, t_posY, IntToStr(abs(p.x - SelectedFrom.x)));
    TextOut(l_posX, l_posY, IntToStr(abs(p.y - SelectedFrom.y)));
  end;
end;

procedure TMainForm.PencilPaint(X, Y: integer; Original: boolean = False);
var
  i, j: integer;
  overall: integer;
begin
  overall := (Volume - 1) div 2;
  SelectionPaint;

  with BmpPen.Canvas do
  begin
    Pen.color := Colour;
    for i := -overall to (overall * 2 + 1) do
      for j := -overall to (overall * 2 + 1) do
      begin
        MoveTo(coordX + i, coordY + j);
        LineTo(X + i, Y + j);
      end;
  end;

  if Original then
  begin
    History.Add(BmpPen);
  end;

  coordX := X;
  coordY := Y;
end;

procedure TMainForm.SquarePaint(X, Y: integer; Original: boolean = False);
var
  C: TCanvas;
  B: TBitmap;
  i, j: integer;
  overall: integer;
begin
  overall := (Volume - 1) div 2;
  C := TCanvas.Create;
  if Original then
  begin
    B := TBitmap.Create;
    B.Height := History.GetCurrent.Height;
    B.Width := History.GetCurrent.Width;
    B.Canvas.CopyRect(History.GetCurrent.Canvas.ClipRect,
      History.GetCurrent.Canvas, History.GetCurrent.Canvas.ClipRect);
    C.Handle := B.Canvas.Handle;
  end
  else
  begin
    SelectionPaint;
    C.Handle := MainImage.Canvas.Handle;
  end;

  with C do
  begin
    // pain square
    Pen.color := Colour;
    for i := -overall to (overall * 2 + 1) do
      for j := -overall to (overall * 2 + 1) do
      begin
        MoveTo(coordX + i, coordY + j);
        LineTo(coordX + i, Y + j);
        MoveTo(coordX + i, coordY + j);
        LineTo(X + i, coordY + j);
        MoveTo(X + i, Y + j);
        LineTo(X + i, coordY + j);
        MoveTo(X + i, Y + j);
        LineTo(coordX + i, Y + j);
      end;
  end;

  if Original then
  begin
    History.Add(B);
    B.Free;
  end;

  C.Free;
end;

procedure TMainForm.CirclePaint(X, Y: integer; Original: boolean = False);
var
  C: TCanvas;
  B: TBitmap;
  i, j: integer;
  overall: integer;
begin
  overall := (Volume - 1) div 2;
  C := TCanvas.Create;
  if Original then
  begin
    B := TBitmap.Create;
    B.Height := History.GetCurrent.Height;
    B.Width := History.GetCurrent.Width;
    B.Canvas.CopyRect(History.GetCurrent.Canvas.ClipRect,
      History.GetCurrent.Canvas, History.GetCurrent.Canvas.ClipRect);
    C.Handle := B.Canvas.Handle;
  end
  else
  begin
    SelectionPaint;
    C.Handle := MainImage.Canvas.Handle;
  end;

  with C do
  begin
    // pain circle
    Pen.color := Colour;
    Brush.Style := bsClear;
    for i := -overall to (overall * 2 + 1) do
      for j := -overall to (overall * 2 + 1) do
      begin
        Ellipse(coordX + i, coordY + j, X + i, Y + j);
      end;
  end;

  if Original then
  begin
    History.Add(B);
    B.Free;
  end;

  C.Free;
end;

procedure TMainForm.ScissorsMove(X, Y: integer; Shift: TShiftState = []);
var
  difX, difY: integer;
begin
  SelectionPaint;

  difX := coordX - X;
  difY := coordY - Y;

  Scissors.CurrentRect := Rect(Scissors.PrevRect.Left - difX,
    Scissors.PrevRect.Top - difY, Scissors.PrevRect.Right - difX,
    Scissors.PrevRect.Bottom - difY);

  with MainImage.Canvas do
  begin
    if ssShift in Shift then
    begin
      Brush.color := clWhite;
      FillRect(Scissors.SelectedRect);
    end;
    CopyRect(Scissors.CurrentRect, Scissors.FB.Canvas, Scissors.SelectedRect);
  end;
end;

procedure TMainForm.FillTextBackground;
begin
  TextPnl.Canvas.CopyRect(TextPnl.Canvas.ClipRect, History.GetCurrent.Canvas,
    Rect(TextPnl.Left, TextPnl.Top, TextPnl.Left + TextPnl.Width,
    TextPnl.Top + TextPnl.Height));
  TextPnl.Invalidate;
end;

procedure TMainForm.FillMemoBackground;
begin
  Memo1.Brush.Bitmap := TBitmap.Create;
  Memo1.Brush.Bitmap.Height := Memo1.Height;
  Memo1.Brush.Bitmap.Width := Memo1.Width;
  Memo1.Brush.Bitmap.Canvas.CopyRect(Rect(-2, -2, Memo1.Width - 2, Memo1.Height - 2),
    History.GetCurrent.Canvas, Rect(TextPnl.Left + Memo1.Left,
    TextPnl.Top + Memo1.Top, TextPnl.Left + Memo1.Left + Memo1.Width,
    TextPnl.Top + Memo1.Top + Memo1.Height));
  Memo1.Invalidate;
end;

procedure TMainForm.ScissorsPaint(X, Y: integer; Original: boolean = False);
var
  C: TCanvas;
begin
  C := TCanvas.Create;
  if Original then
  begin
    C.Handle := Scissors.FB.Canvas.Handle;
  end
  else
  begin
    SelectionPaint;
    C.Handle := MainImage.Canvas.Handle;
  end;

  with C do
  begin
    // pain square
    Pen.color := clLime;
    Pen.Style := psDash;
    MoveTo(coordX, coordY);
    LineTo(coordX, Y);
    MoveTo(coordX, coordY);
    LineTo(X, coordY);
    MoveTo(X, Y);
    LineTo(X, coordY);
    MoveTo(X, Y);
    LineTo(coordX, Y);

    if Original then
    begin
      if ssShift in FShift then
      begin
        Brush.color := clWhite;
        FillRect(Scissors.SelectedRect);
      end;
      CopyRect(Scissors.CurrentRect, Scissors.FB.Canvas, Scissors.SelectedRect);

      if X < coordX then
      begin
        Scissors.SelectedRect.Left := X;
        Scissors.SelectedRect.Right := coordX;
      end
      else
      begin
        Scissors.SelectedRect.Left := coordX;
        Scissors.SelectedRect.Right := X;
      end;

      if Y < coordY then
      begin
        Scissors.SelectedRect.Top := Y;
        Scissors.SelectedRect.Bottom := coordY;
      end
      else
      begin
        Scissors.SelectedRect.Top := coordY;
        Scissors.SelectedRect.Bottom := Y;
      end;

      Scissors.Selected := True;
      Scissors.CurrentRect := Scissors.SelectedRect;
      Scissors.PrevRect := Scissors.SelectedRect;
    end;
    Pen.Style := psSolid;
  end;

  C.Free;
end;

procedure TMainForm.MainImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  // set coords
  coordX := X;
  coordY := Y;
  fromX := X;
  fromY := Y;

  if Tools.Current = iNone then
  begin
    SelectedFrom.x := X;
    SelectedFrom.y := Y;
    SelectedTo.x := X;
    SelectedTo.y := Y;
  end;

  if Tools.Current = iPencil then
  begin
    BmpPen.Height := History.GetCurrent.Height;
    BmpPen.Width := History.GetCurrent.Width;
    BmpPen.Canvas.CopyRect(History.GetCurrent.Canvas.ClipRect,
      History.GetCurrent.Canvas, History.GetCurrent.Canvas.ClipRect);
  end;

  if Scissors.Selected then
    Scissors.Selected := False;

  if (Tools.Current = iScissors) and (not Scissors.InRect(X, Y)) then
    Scissors.FB.Assign(History.GetCurrent);

  if (Tools.Current = iScissors) and (Scissors.InRect(X, Y)) then
  begin
    Scissors.Moving := True;
  end;

  if Tools.Current = iText then
  begin
    if Memo1.Lines.Text <> '' then
      TextPaint;
    TextPnl.Visible := True;
    TextPnl.Left := X;
    TextPnl.Top := Y;
    Memo1.Font.Size := FontSizeEdit.Value;
    Memo1.Font.color := Colour;
    Memo1.SetFocus;
    Refresh;
    FillMemoBackground;
  end;
end;

procedure TMainForm.MainImageMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  FShift := Shift;
  FX := X;
  FY := Y;
  {$IFDEF UNIX}
  Painter;
  {$ENDIF}
end;

procedure TMainForm.CatchUp;
begin
  History.Clear;
  History.Add(History.Original);

  with MainForm do
  begin
    Show;
    Left := CurrentMonitor.Left;
    Top := CurrentMonitor.Top;
    Width := CurrentMonitor.Width;
    Height := CurrentMonitor.Height;
    Update;
  end;
  ShowWindow(Handle, SW_SHOWFULLSCREEN);

  fromX := Left;
  toX := Left;
  fromY := Top;
  toY := Top;
  SelectedFrom.x := fromX;
  SelectedFrom.y := fromY;
  SelectedTo.x := toX;
  SelectedTo.y := toX;
  Tools.Current := iNone;
  MainImage.Cursor := crCross;
  PressedImg.Visible := False;

  Application.BringToFront;

  MainImageMouseDown(Self, mbLeft, [ssLeft], Width div 2, Height div 2);
  MainImageMouseMove(Self, [ssLeft], Width div 2, Height div 2);
  MainImageMouseUp(Self, mbLeft, [ssLeft], Width div 2, Height div 2);
  MainImage.Invalidate;

  ToolsPnl.Top := Top + Height - ToolsPnl.Height;

  SelectionPaint(True);
end;

procedure TMainForm.MainImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Tools.Current = iScissors then
  begin
    ScissorsMove(X, Y, Shift);
    //ScissorsPaint(X, Y, True);
    Scissors.PrevRect := Scissors.CurrentRect;
    Scissors.Moving := False;
  end;

  if (Tools.Current = iScissors) and (not Scissors.Moving) then
  begin
    ScissorsPaint(X, Y, True);
    MainImage.Cursor := crCross;
  end;

  if Tools.Current = iArrow then
  begin
    ArrowPaint(X, Y, True);
  end
  else
  if Tools.Current = iLine then
  begin
    LinePaint(X, Y, True);
  end
  else
  if Tools.Current = iSquare then
  begin
    SquarePaint(X, Y, True);
  end
  else
  if Tools.Current = iCircle then
  begin
    CirclePaint(X, Y, True);
  end
  else
  if Tools.Current = iPencil then
  begin
    PencilPaint(X, Y, True);
  end
  else
  if Tools.Current = iNone then
  begin
    SelectedTo.x := X;
    SelectedTo.y := Y;
  end;

  coordX := X;
  coordY := Y;
  toX := X;
  toY := Y;
end;

procedure TMainForm.MainImagePaint(Sender: TObject);
begin
  {$IFDEF WINDOWS}
  Painter;
  {$ENDIF}
end;


procedure TMainForm.Painter;
const
  fc = $A0ffA0;
var
  r: TRect;
begin
  if TextPnl.Visible then
    TextPnl.Update;

  if ssLeft in FShift then
  begin
    if Tools.Current = iNone then
      SelectionPaint(True);
    if Tools.Current = iPencil then
      PencilPaint(FX, FY);
    if Tools.Current = iLine then
      LinePaint(FX, FY);
    if Tools.Current = iArrow then
      ArrowPaint(FX, FY);
    if Tools.Current = iSquare then
      SquarePaint(FX, FY);
    if Tools.Current = iCircle then
      CirclePaint(FX, FY);
    if (Tools.Current = iScissors) and (Scissors.Moving) then
    begin
      ScissorsMove(FX, FY, FShift);
      MainImage.Cursor := crDrag;
    end;
    if (Tools.Current = iScissors) and (not Scissors.Moving) then
    begin
      ScissorsPaint(FX, FY);
      MainImage.Cursor := crCross;
    end;
  end
  else
  begin
    if (Tools.Current = iScissors) and (Scissors.InRect(FX, FY)) then
      MainImage.Cursor := crDrag;
    if (Tools.Current = iScissors) and (not Scissors.InRect(FX, FY)) then
      MainImage.Cursor := crCross;

    r.Left := Min(SelectedFrom.x, SelectedTo.x);
    r.Top := Min(SelectedFrom.y, SelectedTo.y);
    r.Right := Max(SelectedFrom.x, SelectedTo.x);
    r.Bottom := Max(SelectedFrom.y, SelectedTo.y);
    if not PtInRect(r, Point(FX, FY)) then
    begin
      Tools.Current := iNone;
    end
    else
    begin
      if Tools.Current = iNone then
        Tools.Current := Tools.Prev;
    end;

    if (Tools.Current = iNone) and (toX - fromX = 0) then
    begin
      with MainImage.Canvas do
      begin
        CopyRect(ClientRect, History.Overlay.Canvas,
          ClientRect);
        //Pen.Color := clLime;
        Pen.Color := fc;
        MoveTo(fromX, 0);
        LineTo(fromX, Height);

        MoveTo(FX, 0);
        LineTo(FX, Height);

        MoveTo(0, fromY);
        LineTo(Width, fromY);

        MoveTo(0, FY);
        LineTo(Width, FY);
      end;
    end
    else
    begin
      // Painting nothing :) While area was selected
      SelectionPaint;
    end;
  end;
  MainImage.Invalidate;
  ToolsPnl.Update;
end;

procedure TMainForm.Memo1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = VK_RETURN) then
    TextPaint;
end;

procedure TMainForm.PalleteImgMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  SS: TShiftState;
begin
  SS := [ssLeft];
  ColorImg.Left := X - 2 + PalleteImg.Left;
  color_x := ColorImg.Left;
  ColorImgMouseMove(self, SS, ColorImg.Left, Y);
end;

procedure TMainForm.PencilBtnClick(Sender: TObject);
begin
  Tools.Current := iPencil;
  TextPaint;
end;

procedure TMainForm.PencilBtnMouseEnter(Sender: TObject);
begin
  HoverImg.Visible := True;
  HoverImg.Left := PencilBtn.Left;
end;

procedure TMainForm.PencilBtnMouseLeave(Sender: TObject);
begin
  HoverImg.Visible := False;
end;

procedure TMainForm.Printscreen1Click(Sender: TObject);
begin
  MakeScreenshot(TMenuItem(Sender).ImageIndex);
end;

procedure TMainForm.ResizeImgMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  if ssLeft in Shift then
  begin
    ResizeImg.Left := ResizeImg.Left - ResizeImg.Width div 2 + X;
    ResizeImg.Top := ResizeImg.Top - ResizeImg.Height div 2 + Y;
    Memo1.Width := ResizeImg.Left + 10 - Memo1.Left;
    Memo1.Height := ResizeImg.Top + 10 - Memo1.Top;
    TextPnl.Width := TextPnl.Width - ResizeImg.Width div 2 + X;
    TextPnl.Height := TextPnl.Height - ResizeImg.Height div 2 + Y;
    Refresh;
    FillMemoBackground;
  end;
end;

procedure TMainForm.ScissorsBtnClick(Sender: TObject);
begin
  Tools.Current := iScissors;
  TextPaint;
end;

procedure TMainForm.ScissorsBtnMouseEnter(Sender: TObject);
begin
  HoverImg.Visible := True;
  HoverImg.Left := ScissorsBtn.Left;
end;

procedure TMainForm.Settings1Click(Sender: TObject);
begin
  SettingsForm.Show;
end;

procedure TMainForm.SquareBtnClick(Sender: TObject);
begin
  Tools.Current := iSquare;
  TextPaint;
end;

procedure TMainForm.SquareBtnMouseEnter(Sender: TObject);
begin
  HoverImg.Visible := True;
  HoverImg.Left := SquareBtn.Left;
end;

procedure TMainForm.TextBtnClick(Sender: TObject);
begin
  Tools.Current := iText;
  TextPaint;
end;

procedure TMainForm.TextBtnMouseEnter(Sender: TObject);
begin
  HoverImg.Visible := True;
  HoverImg.Left := TextBtn.Left;
end;

procedure TMainForm.TextPnlPaint(Sender: TObject);
begin
  FillTextBackground;
end;

procedure TMainForm.ToolsImgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  pressed_x := X;
  pressed_y := Y;
end;

procedure TMainForm.ToolsImgMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  if ssLeft in Shift then
  begin
    ToolsPnl.Left := ToolsPnl.Left + X - pressed_x;
    ToolsPnl.Top := ToolsPnl.Top + Y - pressed_y;
  end;
end;

procedure TMainForm.TrayIcon1Click(Sender: TObject);
begin
  MakeScreenshot;
end;

procedure TMainForm.UploadBtnClick(Sender: TObject);
begin
  PrepareBitmap;
  if Settings.upload then
    Upload;
  if Settings.save then
    SaveImg;
end;

procedure TMainForm.VolumeImgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  volume_x := X;
end;

procedure TMainForm.VolumeImgMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  if ssLeft in Shift then
  begin
    if (VolumeImg.Left >= 13) and (VolumeImg.Left <= 90) then
    begin
      VolumeImg.Left := VolumeImg.Left + X - volume_x;
    end;
  end;
end;

procedure TMainForm.VolumeImgMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  // prevent fast movement
  if VolumeImg.Left < 13 then
    VolumeImg.Left := 13;
  if VolumeImg.Left > 90 then
    VolumeImg.Left := 90;
  Volume := (VolumeImg.Left - 3) div 8;
  SaveSettings;
end;

procedure TMainForm.PrepareBitmap;
var
  r: TRect;
  B: TBitmap;
begin
  // forgotten text
  TextPaint;
  Clipboard.Clear;
  if (Settings.use_clipboard) and (Settings.image_to_clipboard) then
  begin
    r.Left := Min(SelectedFrom.x, SelectedTo.x);
    r.Top := Min(SelectedFrom.y, SelectedTo.y);
    r.Right := Max(SelectedFrom.x, SelectedTo.x);
    r.Bottom := Max(SelectedFrom.y, SelectedTo.y);

    B := TBitmap.Create;
    B.Assign(History.GetCurrent);
    B.Canvas.CopyRect(Rect(0, 0, r.Right - r.Left, r.Bottom - r.Top), B.Canvas, r);
    B.SetSize(r.Right - r.Left, r.Bottom - r.Top);
    Clipboard.Assign(B);
    B.Free;
  end;
end;

{ THistory }

procedure THistory.Add(Point: TBitmap);
var
  i: integer;
begin
  if length(Points) > Limit then
  begin
    for i := 1 to length(Points) - 1 do
      Points[i - 1] := Points[i];
    SetLength(Points, length(Points) - 1);
  end;
  SetLength(Points, length(Points) + 1);
  Points[length(Points) - 1] := TBitmap.Create;
  Points[length(Points) - 1].PixelFormat := pf24bit;
  Points[length(Points) - 1].Assign(Point);
  Current := length(Points) - 1;

  if (length(Points) > 1) then
    CanBack := True;
  OnChange;
end;

function THistory.Back: TBitmap;
begin
  if Current > 0 then
    Current := Current - 1;
  Result := TBitmap.Create;
  Result.Assign(GetCurrent);
  OnChange;
end;

constructor THistory.Create;
begin
  inherited;
  CanBack := False;
  CanForward := False;
  SetLength(Points, 0);
  Current := 0;
  Overlay := TBitmap.Create;
  Original := TBitmap.Create;
end;

destructor THistory.Destroy;
var
  i: integer;
begin
  for i := 0 to Length(Points) - 1 do
    FreeAndNil(Points[i]);
  SetLength(Points, 0);
  Overlay.Free;
  Original.Free;
  inherited Destroy;
end;

function THistory.GoForward: TBitmap;
begin
  if Current < length(Points) - 1 then
  begin
    Current := Current + 1;
  end;
  Result := TBitmap.Create;
  Result.Assign(GetCurrent);
  OnChange;
end;

procedure THistory.OnChange;
begin
  MainForm.BackImg.Visible := CanBack;
  MainForm.ForwardImg.Visible := CanForward;
end;

procedure THistory.Clear;
var
  i: integer;
begin
  for i := 0 to Length(Points) - 1 do
    FreeAndNil(Points[i]);
  SetLength(Points, 0);
end;

function THistory.GetCurrent: TBitmap;
begin
  if (length(Points) > 0) then
    Result := Points[Current]
  else
    Result := TBitmap.Create;

  CanBack := False;
  CanForward := False;

  if Current > 1 then
    CanBack := True;
  if Current < length(Points) - 1 then
    CanForward := True;
end;

{ UploadThread }

procedure UploadProcess;
var
  params: TIdMultipartFormDataStream;
  response: TJSONData;
  stream: TMemoryStream;
  output_stream: TStringStream;
  jpgImg: TJPEGImage;
  ic: TIcon;
  jObject: TJSONObject;
  r: TRect;
begin
  Link := '';
  with MainForm do
  begin
    stream := TMemoryStream.Create;
    output_stream := TStringStream.Create('');

    r.Left := Min(SelectedFrom.x, SelectedTo.x);
    r.Top := Min(SelectedFrom.y, SelectedTo.y);
    r.Right := Max(SelectedFrom.x, SelectedTo.x);
    r.Bottom := Max(SelectedFrom.y, SelectedTo.y);

    jpgImg := TJPEGImage.Create;
    jpgImg.CompressionQuality := 100;
    jpgImg.LoadFromBitmapHandles(History.GetCurrent.Handle,
      History.GetCurrent.MaskHandle, @r);

    MainForm.Hide;

    jpgImg.SaveToStream(stream);
    stream.Position := 0;
    EncodeStream(stream, output_stream);

    params := TIdMultipartFormDataStream.Create;
    params.AddFormField('image', output_stream.DataString);
    params.AddFormField('type', 'base64');

    if stream.Size = 0 then
    begin
      stream.Free;
      jpgImg.Free;
      params.Free;
      Exit;
    end;

    try
      response := GetJSON(http.Post('https://api.imgur.com/3/image', params));
    except
      try
        // second try
        sleep(100);
        response := GetJSON(http.Post('https://api.imgur.com/3/image', params));
      except
        try
          // third try
          sleep(100);
          response := GetJSON(
            http.Post('https://api.imgur.com/3/image', params));
        except
          on E: Exception do
          begin
            SaveImg;
            Application.MessageBox(
              PChar('Your image has been saved to directory.' + #13 + E.Message),
              'Sorry. Something went wrong', MB_ICONWARNING);
          end;
        end;
      end;
    end;

    History.Clear;

    if Assigned(response) and (response <> nil) then
    begin
      jObject := TJSONObject(response);
      jObject := jObject.Get('data', jObject);
      Link := jObject.Get('link');
      ModalForm.Edit1.Text := Link;
      if (Settings.use_clipboard) and (Settings.link_to_clipboard) then
        Clipboard.SetTextBuf(PChar(Link));
    end;

    stream.Free;
    jpgImg.Free;
    params.Free;
    TrayIcon1.Animate := False;
    ic := TIcon.Create;
    ic.LoadFromResourceName(HInstance, 'tray');
    TrayIcon1.Icon := ic;
    ic.Free;
  end;

end;

procedure TUploadThread.Execute;
begin
  UploadProcess;
  if Link <> '' then
    Synchronize(@MyModal);
end;

constructor TUploadThread.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure MyModalProcess;
var
  i: integer;
begin
  if Link = '' then
  begin
    Exit;
  end;
  HistoryForm.HistoryList.InsertRowWithValues(1,
    [FormatDateTime('yyyy-mm-dd hh:nn:ss', now), Link]);

  ModalForm.AlphaBlend := True;
  ModalForm.AlphaBlendValue := 50;
  ModalForm.Show;
  ModalForm.BringToFront;

  i := 50;
  while i < 255 do
  begin
    i := i + 10;
    if i <= 255 then
      ModalForm.AlphaBlendValue := i;
    ModalForm.Update;
    sleep(1);
  end;

  ModalForm.AlphaBlendValue := 255;
  if Settings.autohide then
    MainForm.HideTimer.Enabled := True;
end;

procedure TUploadThread.MyModal;
begin
  MyModalProcess;
end;

{ TScissors }

function TScissors.InRect(X, Y: word): boolean;
begin
  Result := PtInRect(CurrentRect, Point(X, Y));
end;

constructor TScissors.Create;
begin
  FB := TBitmap.Create;
end;

destructor TScissors.Destroy;
begin
  FB.Free;
  inherited Destroy;
end;

end.
