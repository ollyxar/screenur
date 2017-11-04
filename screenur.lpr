program screenur;

{$mode objfpc}{$H+}
{$define UseCThreads}
uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads,
  cmem, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, {$IFDEF WINDOWS}
  Windows, {$ENDIF}
  uMain,
  uModal,
  uSettings,
  uHistory,
  indylaz,
  uniqueinstance_package;

{$R *.res}
{$IFDEF WINDOWS}
var
  Ex: Long;
{$ENDIF}
begin
  //RequireDerivedFormResource := True;
  Application.Initialize;
  {$IFDEF WINDOWS}
  Ex := GetWindowLong(FindWindow(nil, 'screenur'), GWL_EXSTYLE);
  SetWindowLong(FindWindow(nil, 'screenur'), GWL_EXSTYLE, Ex or
    WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);
  {$ENDIF}

  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TModalForm, ModalForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.CreateForm(THistoryForm, HistoryForm);

  MainForm.ShowInTaskBar := stNever;
  ModalForm.ShowInTaskBar := stNever;
  SettingsForm.ShowInTaskBar := stNever;
  HistoryForm.ShowInTaskBar := stNever;

  Application.Run;
end.
