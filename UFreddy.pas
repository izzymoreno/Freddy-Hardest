unit UFreddy;
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, UWorld;

Const

//������������ �������� �������� ������ �������� ����� � ������ ��������������
MaxImgFreddyMoveLeft = 4;
MaxImgFreddyMoveRight = 4;
MaxImgFreddyMoveSitLeft = 1;
MaxImgFreddyMoveSitRight = 1;
MaxImgFreddyKickLeft = 5;
MaxImgFreddyKickRight = 5;

type
    TFreddyDirection = (FreddydirectionLeft, FreddydirectionCenter, FreddydirectionRight);

type

  TFreddy = class (TObject)
  public
  Name: string;
  //������ �������� ������
  //��������
  ImgMassFreddyMoveLeft: array[0..MaxImgFreddyMoveLeft-1] of TBitMap;
  ImgMassFreddyMoveRight: array[0..MaxImgFreddyMoveRight-1] of TBitMap;
  ImgMassFreddyMoveSitLeft: array[0..MaxImgFreddyMoveSitLeft-1] of TBitMap;
  ImgMassFreddyMoveSitRight: array[0..MaxImgFreddyMoveSitRight-1] of TBitMap;
  //����� ������
  ImgMassFreddyKickLeft: array[0..MaxImgFreddyKickLeft-1] of TBitMap;
  ImgMassFreddyKickRight: array[0..MaxImgFreddyKickRight-1] of TBitMap;


  owner:TWinControl;
  shagx,shagy, sprleftindex, sprrightindex, sprindexshag:integer;
  XFreddy,YFreddy,sprindex:integer;
  FreddySit: boolean;
  FreddyKick: boolean;
  ThereMove: TFreddyDirection;
  TimerAnimation: TTimer;
  procedure Show;
  procedure TimerAnimationProcessing(Sender: TObject);
  Constructor CreateFreddy(X,Y: integer; ownerForm: TWinControl);
  Destructor Destroy(); override;
  end;

implementation

Uses UMainProg;

constructor TFreddy.CreateFreddy(X, Y:integer; ownerForm: TWinControl);
var
i:integer;
begin
//Randomize
self.TimerAnimation:=TTimer.Create(nil);
self.TimerAnimation.OnTimer:=self.TimerAnimationProcessing;
self.TimerAnimation.Interval:=round(145);
//self.TimTimerAnimation.Interval:=round((Random*120)+(Random*60)+1);
//������������ ���������� �� X ��� ����, ����� ��� ������������
ThereMove := FreddydirectionRight;
XFreddy:=X;
YFreddy:=Y;
//self.grad:=0;
self.owner:=ownerForm;
//��������� ��� ������� �������� ������
For i:=0 to MaxImgFreddyMoveLeft-1 Do
   begin
   ImgMassFreddyMoveLeft[i]:=TBitMap.Create;
   ImgMassFreddyMoveLeft[i].LoadFromFile(ExePath+'Graphics\Freddy\FreddyMoveLeft\Freddy'+IntToStr(i+1)+'.bmp');
   end;
For i:=0 to MaxImgFreddyMoveRight-1 Do
   begin
   ImgMassFreddyMoveRight[i]:=TBitMap.Create;
   ImgMassFreddyMoveRight[i].LoadFromFile(ExePath+'Graphics\Freddy\FreddyMoveRight\Freddy'+IntToStr(i+1)+'.bmp');
   end;
For i:=0 to MaxImgFreddyMoveSitLeft-1 Do
   begin
   ImgMassFreddyMoveSitLeft[i]:=TBitMap.Create;
   ImgMassFreddyMoveSitLeft[i].LoadFromFile(ExePath+'Graphics\Freddy\FreddySitLeft\Freddy'+IntToStr(i+1)+'.bmp');
   end;
For i:=0 to MaxImgFreddyMoveSitRight-1 Do
   begin
   ImgMassFreddyMoveSitRight[i]:=TBitMap.Create;
   ImgMassFreddyMoveSitRight[i].LoadFromFile(ExePath+'Graphics\Freddy\FreddySitRight\Freddy'+IntToStr(i+1)+'.bmp');
   end;
//��������� ������� ������ ������ ������
For i:=0 to MaxImgFreddyKickLeft-1 Do
   begin
   ImgMassFreddyKickLeft[i]:=TBitMap.Create;
   ImgMassFreddyKickLeft[i].LoadFromFile(ExePath+'Graphics\Freddy\FreddyKickLeft\Freddy'+IntToStr(i+1)+'.bmp');
   end;
For i:=0 to MaxImgFreddyKickRight-1 Do
   begin
   ImgMassFreddyKickRight[i]:=TBitMap.Create;
   ImgMassFreddyKickRight[i].LoadFromFile(ExePath+'Graphics\Freddy\FreddyKickRight\Freddy'+IntToStr(i+1)+'.bmp');
   end;

//������� ���������� ��� �������� ������
FreddySit := false;
FreddyKick := false;
shagx:=0;
shagy:=0;
sprleftindex := 0;
sprrightindex := 0;
sprindexshag := 0;
//ThereMove:=OwldirectionCenter;
//�������� ������ �������� ������
self.TimerAnimation.Enabled:=true;
end;

procedure TFreddy.TimerAnimationProcessing(Sender: TObject);
begin
//������ ��� �����
//����� �� �������� ����� �������
//������ ��� �����
If (ThereMove = FreddydirectionLeft) then if (FreddyKick = False) then
  begin
   sprleftindex := sprleftindex + sprindexshag;
   if sprleftindex >= MaxImgFreddyMoveLeft then
      sprleftindex := 0;
   end;
//������ ��� ������
If (ThereMove = FreddydirectionRight) then if (FreddyKick = False) then
   begin
   sprrightindex := sprrightindex + sprindexshag;
   if sprrightindex >= MaxImgFreddyMoveRight then
     sprrightindex := 0;
   end;
end;

procedure TFreddy.Show;
var
i: integer;
begin

//������������ ������

   if (Freddy.FreddySit = false) then
     if (ThereMove = FreddydirectionLeft) then
       begin
       VirtBitmap.Canvas.Draw(self.XFreddy, self.YFreddy, self.ImgMassFreddyMoveLeft[sprleftindex]);
       exit;
       end
         else
           if (ThereMove = FreddydirectionRight) then
           begin
           VirtBitmap.Canvas.Draw(self.XFreddy, self.YFreddy, self.ImgMassFreddyMoveRight[sprrightindex]);
           exit;
           end;

   if Freddy.FreddySit = true then
     begin
      if (ThereMove = FreddydirectionLeft) then
        begin
        VirtBitmap.Canvas.Draw(self.XFreddy-8, self.YFreddy+8, self.ImgMassFreddyMoveSitLeft[0]);
        exit;
        end
          else
          if (ThereMove = FreddydirectionRight) then
            begin
            VirtBitmap.Canvas.Draw(self.XFreddy, self.YFreddy+8, self.ImgMassFreddyMoveSitRight[0]);
            exit;
            end;
     end;
end;

//��� ���������� ������
destructor TFreddy.Destroy;
var
i:byte;
begin
//����� �� ������� �� ������ ������
For i:=0 to  MaxImgFreddyMoveLeft-1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if ImgMassFreddyMoveLeft[i]<>nil then ImgMassFreddyMoveLeft[i].free;
   end;
For i:=0 to  MaxImgFreddyMoveRight-1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if ImgMassFreddyMoveRight[i]<>nil then ImgMassFreddyMoveRight[i].free;
   end;
For i:=0 to  MaxImgFreddyMoveSitLeft-1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if ImgMassFreddyMoveSitLeft[i]<>nil then ImgMassFreddyMoveSitLeft[i].free;
   end;
For i:=0 to  MaxImgFreddyMoveSitRight-1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if ImgMassFreddyMoveSitRight[i]<>nil then ImgMassFreddyMoveSitRight[i].free;
   end;
For i:=0 to  MaxImgFreddyKickLeft-1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if ImgMassFreddyKickLeft[i]<>nil then ImgMassFreddyKickLeft[i].free;
   end;
For i:=0 to  MaxImgFreddyKickRight-1 Do
   begin
   //���� ������ ���������� � ������, �� �� ��� �������
   if ImgMassFreddyKickRight[i]<>nil then ImgMassFreddyKickRight[i].free;
   end;
//������� ������ ��������
TimerAnimation.free;
//����� ����������� ������������� ������
inherited;
end;

end.
