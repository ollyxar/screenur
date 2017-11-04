unit uHistory;

interface

uses
  SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Grids,
  LCLType, LCLIntf;

type
  { THistoryForm }
  THistoryForm = class(TForm)
    HistoryList: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HistoryForm: THistoryForm;

implementation

{$R *.dfm}

procedure THistoryForm.FormCreate(Sender: TObject);
begin
  with HistoryList do
  begin
    ColWidths[0] := 130;
    ColWidths[1] := 230;
    Cells[0, 0] := 'Date';
    Cells[1, 0] := 'Link';
  end;
end;

procedure THistoryForm.FormShow(Sender: TObject);
begin
  ShowWindow(Handle, SW_HIDE);
end;


end.
