{$I hkeys.inc}
unit hkeys;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  TMultimediaKeys = class;

  { TKeyCapture }

  TKeyCapture = class
  protected
    procedure BeginGrab; virtual; abstract;
    procedure EndGrab; virtual; abstract;
    function GetGrabbed: Boolean; Virtual;
  public
    Owner: TMultimediaKeys;
    Property Grabbed: Boolean read GetGrabbed;
  end;

  { TMultimediaKeys }

  TMultimediaKeys = class
  private
    fMode: integer;
    KeyCapture: TKeyCapture;
  public
    constructor Create(Mode:Integer);
    destructor Destroy; override;
    property Mode:integer read fMode;

  end;

implementation

{ TMultimediaKeys }
{$I mmkeys.inc}

function TKeyCapture.GetGrabbed: Boolean;
begin
  result:=False;
end;


end.
