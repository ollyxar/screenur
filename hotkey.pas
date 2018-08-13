unit Hotkey;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, xlib, x;

type

  TCallback = procedure;

  TModifier = (NoModifier, KeyShift, KeyControl, KeyAlt);

  { THotkeyThread }

  THotkeyThread = class(TThread)
  private
    fDisplay: PDisplay;
    fRoot: TWindow;
    fEvent: TXEvent;
    fCallback: TCallback;
    fKeycode: TKeyCode;
    fModifier: word;
    procedure Grab;
    procedure Ungrab;
    procedure Callback;
  protected
    procedure Execute; override;
  public
    constructor Create(ACallback: TCallback; AKey: PChar; AModifier: TModifier;
      CreateSuspended: boolean);
    destructor Destroy; override;
  end;

implementation

{ THotkeyThread }

procedure THotkeyThread.Grab;
begin
  XGrabKey(fDisplay, fKeycode, AnyModifier, fRoot, 1, GrabModeAsync, GrabModeAsync);
end;

procedure THotkeyThread.Ungrab;
begin
  XUngrabKey(fDisplay, fKeycode, AnyModifier, fRoot);
end;

procedure THotkeyThread.Callback;
begin
  fCallback();
end;

procedure THotkeyThread.Execute;
begin
  while (not Terminated) do
    begin
    if XPending(fDisplay) > 0 then
    begin
      XNextEvent(fDisplay, @fEvent);

      if (fEvent.xkey.state and (ShiftMask or ControlMask or Mod1Mask or Mod4Mask)) =
        fModifier then
        case fEvent._type of
          KeyPress:
          begin
            Ungrab;
            Synchronize(@Callback);
          end;
          KeyRelease:
          begin
            Grab;
          end
          else
          begin
            Ungrab;
            XSendEvent(fDisplay, fRoot, True, fEvent.xkey._type, @fEvent);
            Grab;
          end;
        end
      else
      begin
        Ungrab;
        XSendEvent(fDisplay, fRoot, True, fEvent.xkey._type, @fEvent);
        Grab;
      end;
    end else sleep(100);
    end;
end;

constructor THotkeyThread.Create(ACallback: TCallback; AKey: PChar;
  AModifier: TModifier; CreateSuspended: boolean);
begin
  inherited Create(CreateSuspended);

  FreeOnTerminate := False;
  fDisplay := XOpenDisplay(nil);
  fCallback := ACallback;
  fKeycode := XKeysymToKeycode(fDisplay, XStringToKeysym(AKey));

  case AModifier of
    NoModifier: fModifier := 0;
    KeyShift: fModifier := ShiftMask;
    KeyControl: fModifier := ControlMask;
    KeyAlt: fModifier := Mod1Mask;
  end;

  if (fDisplay = nil) then
  begin
    raise Exception.Create('Cannot open display');
  end;

  fRoot := DefaultRootWindow(fDisplay);
  Grab;
  XSelectInput(fDisplay, fRoot, KeyPressMask or KeyReleaseMask);
end;

destructor THotkeyThread.Destroy;
begin
  Ungrab;
  XCloseDisplay(fDisplay);
  inherited Destroy;
end;

end.
