unit uModal;

interface

uses
  SysUtils, Variants, LCLType, Classes, Graphics, LCLIntf, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type

  { TModalForm }

  TModalForm = class(TForm)
    Edit1: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ModalForm: TModalForm;

implementation

{$R *.dfm}

procedure TModalForm.FormShow(Sender: TObject);
begin
  ShowWindow(Handle, SW_HIDE);
  Left := Monitor.Width - Width - 20;
  Top := Monitor.Height - Height - 60;
  Edit1.SetFocus;
end;

procedure TModalForm.Label2Click(Sender: TObject);
begin
  Close;
end;

end.
