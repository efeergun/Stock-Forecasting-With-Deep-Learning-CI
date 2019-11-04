program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, process, CustApp
  { you can add units after this };
var
  r: TProcess;

type

  { efe }

  efe = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ efe }

procedure efe.DoRun;
var
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }


  r:= TProcess.Create(nil);
  r.Options:= r.Options + [poWaitOnExit];
  r.CommandLine:= 'java -jar ./CI_finance.jar';
  r.Execute;
  r.Free;

  r:= TProcess.Create(nil);
  r.Options:= r.Options + [poWaitOnExit];
  r.CommandLine:= 'python ./process.py';
  r.Execute;
  r.Free;

  r:= TProcess.Create(nil);
  r.Options:= r.Options + [poWaitOnExit];
  r.CommandLine:= 'java -jar ./ShowResults.jar';
  r.Execute;
  r.Free;

  // stop program loop
  Terminate;
end;

constructor efe.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor efe.Destroy;
begin
  inherited Destroy;
end;

procedure efe.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;

var
  Application: efe;
begin
  Application:=efe.Create(nil);
  Application.Title:='money';
  Application.Run;
  Application.Free;
end.

