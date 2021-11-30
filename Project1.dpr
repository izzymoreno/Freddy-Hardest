program Project1;

uses
  Forms,
  UMainProg in 'UMainProg.pas' {Form1},
  UStar in 'UStar.pas',
  UWorld in 'UWorld.pas',
  UFreddy in 'UFreddy.pas',
  UIsle in 'UIsle.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
