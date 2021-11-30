unit UWorld;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

  Const

  //Максимальное длина игрового мира
  GameWorldMaxX = 100;
  GameWorld: array[0..GameWorldMaxX - 1] of byte = (1, 2, 1, 1, 1, 1, 1, 1, 1, 1,
                                                       1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                                                       1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                                                       1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                                                       1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                                                       1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                                                       1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                                                       1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                                                       1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                                                       1, 1, 1, 1, 1, 1, 1, 1, 1, 1 );
type

  TGameWorld = class (TObject)
  public
  //TimerAnimation: TTimer;
  //Массив спрайтов игрового пространства
  WorldX, WorldY: integer;
  ImgGameWorld: array[0..1] of TBitMap;
  //Задаём спрайты игрового пространства
  GameWorldArr: array[0..GameWorldMaxX - 1] of byte;
  //procedure TimerAnimationProccessing(Sender: TObject);
  procedure Show;
  Constructor CreateGameWorld(ownerForm: TWinControl);
  Destructor Destroy(); override;
  end;

implementation

Uses MainProg, Star1;

constructor TGameWorld.CreateGameWorld(ownerForm: TWinControl);
var
i:integer;
begin
//Присваиваем значение переменным игрового пространства по X и Y
WorldX:=0;
WorldY:=200;

//Загружаем спрайты в массив игрового пространства
For i:=0 to length(ImgGameWorld) - 1  Do
   begin
   ImgGameWorld[i]:=TBitMap.Create;
   ImgGameWorld[i].LoadFromFile('Ground'+IntToStr(i+1)+'.bmp');
   ImgGameWorld[i].Transparent:=True;
   ImgGameWorld[i].TransparentMode:=tmFixed;
   ImgGameWorld[i].TransparentColor:=clBlack;
   //ImgMassStar[i].Canvas.Brush.Color:=clPurple;
   end;
//Включаем таймер звёзд
//self.TimerAnimation := TTimer.Create(nil);
//self.TimerAnimation.OnTimer:=self.TimerAnimationProccessing;
//self.TimerAnimation.Interval:=round((Random*200)+500);
//TimerAnimation.Enabled:=true;
end;

procedure TGameWorld.Show;
var
i, Xscreen: integer;
sprindex: byte;
begin
xScreen := self.WorldX;
for i := 0 to 90 do
  begin
   //Читаем из массива игрового пространства номер спрайта
   sprindex := self.GameWorld[i] - 1;
  VirtBitmap.Canvas.Draw(xScreen, self.WorldY, self.ImgGameWorld[sprindex]);
  // Прибавляем 10. 10 - размер спрайтов по 10 пикселей, учтём это
  xScreen:= xScreen + 10;
  end;
end;

//Это деструктор спрайтов игрового пространства
destructor TGameWorld.Destroy;
var
i:byte;
begin
//Здесь мы удаляем из памяти звёзды
For i:=0 to length(ImgGameWorld) - 1  Do
   begin
   ImgGameWorld[i].Free;
   //ImgMassStar[i].Canvas.Brush.Color:=clPurple;
   end;
//Удаляем таймер
//TimerAnimation.free;
//Вызов деструктора родительского класса
inherited;
end;

end.
