program NaturalLanguageAPI;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMainform in 'uMainform.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
