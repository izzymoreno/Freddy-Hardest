unit UMainProg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Math, StdCtrls, UStar, UWorld, UFreddy, UIsle;

Const
//�������� ���������
//������������ ���������� ����
MaxStars = 100;
//������ ������
xmax = 642;
ymax = 485;
xmin = 0;
ymin = 0;
XScreenMax = 642;
YScreenMax = 485;


type
  TForm1 = class(TForm)
    Image1: TImage;
    TimerFPS: TTimer;
    Timer1: TTimer;
    //�������� ���������, ������� ������ ����������
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    //�������� ������ �����
    procedure TimerFPSTimer(Sender: TObject);
    //��������� ������� �� �������
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    //��������� ���������� �������
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  //
  Form1: TForm1;
  //������ ����
  ExePath: string;
  //������ �������� ����
  Stars: array[0..MaxStars - 1] of TMyStar;
  //������ ������
  Freddy: TFreddy;
  //������� ������������
  GameWorld: TGameWorld;
  GameIsle: TGameIsle;



//������� ����������� Canvas
VirtBitmap: TBitmap;

//����
implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
i:integer;
SX,SY:integer;
begin
ExePath := ExtractFilePath(Application.ExeName);
//��������� Canvas ������ ������
self.TimerFPS.Enabled:=false;
self.TimerFPS.Interval:=20;
//��������� ������� ������������ ������ ������
Form1.Image1.Canvas.Brush.Color:=clBlack;
//������ ������� ��������������
Form1.Image1.Canvas.FillRect(Rect(xmin,ymin,XScreenMax,YScreenMax));
//������ ������
Form1.Image1.Width:=XScreenMax;
//������ ������
Form1.Image1.Height:=YScreenMax;
//������ ����������� Bitmap
VirtBitmap:=TBitmap.Create;
VirtBitmap.Width:=Image1.Width;
VirtBitmap.Height:=Image1.Height;
VirtBitmap.Canvas.Brush.Color:=clBlack;
VirtBitmap.Canvas.FillRect(Rect(xmin,ymin,XScreenMax,YScreenMax));
//������ �����
for i := 0 to MaxStars-1 do
   begin
   //������ ����� � ������������� ������������ ���������� �� X � ��������� �� Y
//�� X
   SX:=round(Random*xmax);
//
   SY:=round(Random*ymax-250);
//�� Y
   Stars[i]:= TMyStar.CreateStar(SX,SY, 'left', Form1);
   end;
//������ ������� ������������
GameWorld := TGameWorld.CreateGameWorld(Form1);
GameIsle :=  TGameIsle.CreateGameIsle(Form1);
//������ ������
Freddy := TFreddy.CreateFreddy(305, 310, Form1);
//�������� ������ ���������
self.TimerFPS.Enabled:=true;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
i:integer;
begin
//��������� ������ ���������
self.TimerFPS.Enabled:=false;
//������� �� ������ ������ ����
for i := 0 to MaxStars-1 do
   begin
   Stars[i].free;
   end;
//������� �� ������ ������� ������������
GameWorld.Free;
GameIsle.Free;
//������� �� ������ ������
Freddy.Free;
//������� �� ������ ����������� Canvas
VirtBitmap.Free;
end;

//
procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   Form1.Caption := IntToStr(Key);
   case key of
   vk_left:
         begin
//����������� ������� ������������ �� ��� �����
         If Freddy.FreddySit = false then
           begin
           GameWorld.WorldX := GameWorld.WorldX - 3;
           GameIsle.IsleX := GameIsle.IsleX - 1;
           end;
//�������� ������
         Freddy.sprindexshag := 1;
//������������� ���
         Freddy.shagx := -1;
//������ ��������������� �����
         Freddy.ThereMove := FreddydirectionLeft;
         end;
   vk_right:
         begin
//����������� ������� ������������ �� ��� �����
         If Freddy.FreddySit = false then
           begin
           GameWorld.WorldX := GameWorld.WorldX + 3;
           GameIsle.IsleX := GameIsle.IsleX + 1;
           end;
//�������� ������
         Freddy.sprindexshag := 1;
//������������� ���
         Freddy.shagx := 1;
//������ ��������������� ������
         Freddy.ThereMove := FreddydirectionRight;
         end;
   vk_down:
           begin
           Freddy.FreddySit := true;
           Freddy.sprindexshag := 0;
           end;
   vk_up:
        begin
        Freddy.FreddySit := false;
        Freddy.sprindexshag := 0;
        end;
     end;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
//������ ���������������
Freddy.sprindexshag := 0;
end;

procedure TForm1.TimerFPSTimer(Sender: TObject);
var
i:integer;
begin
//�������������� Canvas
VirtBitmap.Canvas.FillRect(Rect(0,0,VirtBitmap.Width,VirtBitmap.Height));
//������� ������� ������������
GameWorld.Show;
//������� ����
GameIsle.Show;
//������� ������
Freddy.Show;
//������ ������ ������������ �� ����������� ������
//�����
for i := 0 to MaxStars - 1 do
   begin
   If Stars[i] <> nil then
      begin
      Stars[i].Show();
      end;
   end;
//�������� ����������� ������
Form1.Image1.Canvas.Draw(10,10,VirtBitmap);
end;

end.
