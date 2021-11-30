unit UStar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

Const

//Максимальное значение спрайтов звёзд
MaxImageStar = 5;

//Выбор направления движения звёзд
type
    TMoveDirection = (directionLeft, directionRight);

type

  TMyStar = class (TObject)
  public
  Name: string;
  TimerAnimation: TTimer;
  //Массив спрайтов звёзд
  XStar,YStar: integer;
  sprleftindex,sprrightindex:integer;
  sprminleft,sprminright:integer;
  sprmaxright,sprmaxleft:integer;
  ThereMove: TMoveDirection;
  ImgMassStar: array[0..MaxImageStar-1] of TBitMap;
  procedure TimerAnimationProccessing(Sender: TObject);
  procedure Show;
  Constructor CreateStar(X,Y: integer; Move: string; ownerForm: TWinControl);
  Destructor Destroy(); override;
  end;

implementation

Uses MainProg;

constructor TMyStar.CreateStar(X, Y:integer; Move:string; ownerForm: TWinControl);
var
i:integer;
begin
//Инициализируем генератор случайных чисел для мух
Randomize;
XStar:=X;//round(Random*xmax);
YStar:=Y;//round(Random*ymax);
//Загружаем все спрайты гусениц
For i:=0 to MaxImageStar-1 Do
   begin
   ImgMassStar[i]:=TBitMap.Create;
   ImgMassStar[i].LoadFromFile('Star'+IntToStr(i+1)+'.bmp');
   ImgMassStar[i].Transparent:=True;
   ImgMassStar[i].TransparentMode:=tmFixed;
   ImgMassStar[i].TransparentColor:=clBlack;
   //ImgMassStar[i].Canvas.Brush.Color:=clPurple;
   end;
//Заводим переменные для анимации звезды
sprminleft := 0;
sprminright := 2;
sprmaxleft := 1;
sprmaxright := 3;
sprleftindex := sprminleft;
sprrightindex := sprminright;
ThereMove := directionLeft;
//Включаем таймер звёзд
self.TimerAnimation := TTimer.Create(nil);
self.TimerAnimation.OnTimer:=self.TimerAnimationProccessing;
self.TimerAnimation.Interval:=round((Random*200)+500);
TimerAnimation.Enabled:=true;
end;

procedure TMyStar.TimerAnimationProccessing(Sender: TObject);
var
i: integer;
begin
//Таймер мигания звёзд
//Необходимо менять индексы у спрайтов звёзд.
//Берём первую звезду и присваиваем ей минимальный индекс,
//Берём вторую звезду и присваеваем ей минимальный индекс, берём к-тую звезду и так со всеми звёздами
self.sprleftindex := sprleftindex+1;
if sprleftindex >= MaxImageStar-1 then
  sprleftindex :=0;

end;

procedure TMyStar.Show;
begin
If (self.ThereMove = directionLeft) then
     VirtBitmap.Canvas.Draw(self.XStar, self.YStar, self.ImgMassStar[self.sprleftindex])
end;

//Это деструктор звёзд
destructor TMyStar.Destroy;
var
i:byte;
begin
//Здесь мы удаляем из памяти звёзды
For i:=0 to MaxImageStar - 1 Do
   begin
   //Если объект существует в памяти, то мы его удаляем
   if ImgMassStar[i] <> nil then Freeandnil(ImgMassStar[i]);
   end;
//Удаляем таймер
TimerAnimation.free;
//Вызов деструктора родительского класса
inherited;
end;


end.
