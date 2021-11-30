unit UIsle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, UWorld;

  Const
ImgIsleMax = 6;
  //������������ ����� �������� ����
  TextureWidth = 16; //16 ��� 10
// ����� �������� ����
  GameIsleMaxX = 110;
//������ �������� ������������
  GameIsleConst: array[0..GameIsleMaxX - 1] of byte = (0, 1, 2, 3, 4, 5, 6, 0, 0, 0,
                                                       0, 1, 2, 3, 4, 5, 6, 0, 0, 0,
                                                       0, 1, 2, 3, 4, 5, 6, 0, 0, 0,
                                                       0, 1, 2, 3, 4, 5, 6, 0, 0, 0,
                                                       0, 1, 2, 3, 4, 5, 6, 0, 0, 0,
                                                       0, 1, 2, 3, 4, 5, 6, 0, 0, 0,
                                                       0, 1, 2, 3, 4, 5, 6, 0, 0, 0,
                                                       0, 1, 2, 3, 4, 5, 6, 0, 0, 0,
                                                       0, 1, 2, 3, 4, 5, 6, 0, 0, 0,
                                                       0, 1, 2, 3, 4, 5, 6, 0, 0, 0,
                                                       1, 0, 0, 0, 0, 0, 0, 0, 0, 0 );

type

  TGameIsle = class (TObject)
  public
  //TimerAnimation: TTimer;
  //������ �������� �������� ������������
  IsleX, IsleY: integer;
  ImgGameIsle: array[0..ImgIsleMax] of TBitmap;
  //����� ������� ����
  GameIsleArr: array[0..GameIsleMaxX - 1] of byte;
  //procedure TimerAnimationProccessing(Sender: TObject);
  procedure Show;
  Constructor CreateGameIsle(ownerForm: TWinControl);
  Destructor Destroy(); override;
  end;

implementation

Uses UMainProg, UStar;

constructor TGameIsle.CreateGameIsle(ownerForm: TWinControl);
var
i:integer;
begin
//����������� �������� ���������� �������� ������������ �� X � Y
IsleX := 0;//40
IsleY := 250;

for i := 0 to length(GameIsleArr) - 1 Do
  begin
  GameIsleArr[i] := GameIsleConst[i];
  end;

  For i := 0 to length(ImgGameIsle) - 1  Do
   begin
   ImgGameIsle[i]:=TBitMap.Create;
   ImgGameIsle[i].LoadFromFile(ExePath + 'Graphics\Isle'+IntToStr(i)+'.bmp');
   ImgGameIsle[i].Transparent:=True;
   ImgGameIsle[i].TransparentMode:=tmFixed;
   ImgGameIsle[i].TransparentColor:=clBlack;
   //ImgMassStar[i].Canvas.Brush.Color:=clPurple;
   end;
//�������� ������ ����
//self.TimerAnimation := TTimer.Create(nil);
//self.TimerAnimation.OnTimer:=self.TimerAnimationProccessing;
//self.TimerAnimation.Interval:=round((Random*200)+500);
//TimerAnimation.Enabled:=true;
end;

procedure TGameIsle.Show();
var
i, Xscreen: integer;
sprindex: byte;
FirstBrick: integer;
LastBrick : integer;
begin
xScreen := 0;

//�� ������ ������� ���������� XWorld ����������� � ������ ������, � �������� �� ������ ������ �������� ������� ������������.
FirstBrick := round(IsleX div TextureWidth);
LastBrick := FirstBrick + round(VirtBitmap.Width div TextureWidth * TextureWidth/TextureWidth);
if FirstBrick <= 0 then
  begin
  FirstBrick := 0;
  if IsleX < 0 then IsleX:= 0;
  end;
if LastBrick >= Length(GameIsleArr) then
  begin
  LastBrick := Length(GameIsleArr);
  if IsleX > (((LastBrick + 1) * TextureWidth) - VirtBitmap.Width) then IsleX := ((LastBrick + 1) * TextureWidth) - VirtBitmap.Width;
  end;
xScreen := -round(IsleX - IsleX div TextureWidth * TextureWidth);
for i := FirstBrick to LastBrick do
  begin
   //������ �� ������� �������� ������������ ����� �������
  sprindex := self.GameIsleArr[i];
  //���������� ����������� Xscreen � ���������� ������������ ������.
  VirtBitmap.Canvas.Draw(xScreen, self.IsleY, self.ImgGameIsle[sprindex]);
  // ���������� 10. 10 - ������ �������� �� 10 ��������, ���� ���
  xScreen:= xScreen + TextureWidth;
  end;

VirtBitmap.Canvas.Font.Size := 8;
VirtBitmap.Canvas.Font.Color := clWhite;
VirtBitmap.Canvas.TextOut( 300, 10, 'UIsleX=' + inttostr(IsleX));
VirtBitmap.Canvas.TextOut( 300, 30, 'FirstBrickStars=' + inttostr(FirstBrick));
VirtBitmap.Canvas.TextOut( 300, 50, 'LastBrickStars=' + inttostr(LastBrick));

end;


//��� ���������� �������� �������� ������������
destructor TGameIsle.Destroy;
var
i:byte;
begin
//����� �� ������� �� ������ �����
For i:=0 to length(ImgGameIsle) - 1  Do
   begin
   ImgGameIsle[i].Free;
   //ImgMassStar[i].Canvas.Brush.Color:=clPurple;
   end;
//������� ������
//TimerAnimation.free;
//����� ����������� ������������� ������
inherited;
end;

end.
