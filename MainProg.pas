unit UMainProg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Math, StdCtrls, UStar, UWorld, UFreddy, UIsle;

Const
//Основные константы
//Максимальное количество звёзд
MaxStars = 100;
//Размер экрана
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
    //Основная процедура, которая создаёт приложение
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    //Основной таймер видео
    procedure TimerFPSTimer(Sender: TObject);
    //Процедура нажатие на клавишу
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    //Процедура отпускания клавиши
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  //
  Form1: TForm1;
  //Массив звёзд
  ExePath: string;
  //Массив объектов звёзд
  Stars: array[0..MaxStars - 1] of TMyStar;
  //Объект Фредди
  Freddy: TFreddy;
  //Игровое пространство
  GameWorld: TGameWorld;
  GameIsle: TGameIsle;



//Заводим виртуальный Canvas
VirtBitmap: TBitmap;

//Пуск
implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
i:integer;
SX,SY:integer;
begin
ExePath := ExtractFilePath(Application.ExeName);
//Заполняем Canvas чёрным цветом
self.TimerFPS.Enabled:=false;
self.TimerFPS.Interval:=20;
//Заполняем игровое пространство чёрным цветом
Form1.Image1.Canvas.Brush.Color:=clBlack;
//Делаем заливку прямоугольника
Form1.Image1.Canvas.FillRect(Rect(xmin,ymin,XScreenMax,YScreenMax));
//Размер экрана
Form1.Image1.Width:=XScreenMax;
//Размер экрана
Form1.Image1.Height:=YScreenMax;
//Создаём виртуальный Bitmap
VirtBitmap:=TBitmap.Create;
VirtBitmap.Width:=Image1.Width;
VirtBitmap.Height:=Image1.Height;
VirtBitmap.Canvas.Brush.Color:=clBlack;
VirtBitmap.Canvas.FillRect(Rect(xmin,ymin,XScreenMax,YScreenMax));
//Создаём Звёзды
for i := 0 to MaxStars-1 do
   begin
   //Создаём звёзды и устанавливаем максимальную координату по X и случайную по Y
//По X
   SX:=round(Random*xmax);
//
   SY:=round(Random*ymax-250);
//По Y
   Stars[i]:= TMyStar.CreateStar(SX,SY, 'left', Form1);
   end;
//Создаём игровое пространство
GameWorld := TGameWorld.CreateGameWorld(Form1);
GameIsle :=  TGameIsle.CreateGameIsle(Form1);
//Создаём Фредди
Freddy := TFreddy.CreateFreddy(305, 310, Form1);
//Включаем таймер отрисовки
self.TimerFPS.Enabled:=true;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
i:integer;
begin
//Выключаем таймер отрисовки
self.TimerFPS.Enabled:=false;
//Удаляем из памяти массив звёзд
for i := 0 to MaxStars-1 do
   begin
   Stars[i].free;
   end;
//Удаляем из памяти игровое пространство
GameWorld.Free;
GameIsle.Free;
//Удаляем из памяти Фредди
Freddy.Free;
//Удаляем из памяти виртуальный Canvas
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
//Скроллируем игровое пространство на шаг влево
         If Freddy.FreddySit = false then
           begin
           GameWorld.WorldX := GameWorld.WorldX - 3;
           GameIsle.IsleX := GameIsle.IsleX - 1;
           end;
//Анимация Фредди
         Freddy.sprindexshag := 1;
//Устанавливаем шаг
         Freddy.shagx := -1;
//Фредди разворачивается влево
         Freddy.ThereMove := FreddydirectionLeft;
         end;
   vk_right:
         begin
//Скроллируем игровое пространство на шаг влево
         If Freddy.FreddySit = false then
           begin
           GameWorld.WorldX := GameWorld.WorldX + 3;
           GameIsle.IsleX := GameIsle.IsleX + 1;
           end;
//Анимация Фредди
         Freddy.sprindexshag := 1;
//Устанавливаем шаг
         Freddy.shagx := 1;
//Фредди разворачивается вправо
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
//Фредди останавливается
Freddy.sprindexshag := 0;
end;

procedure TForm1.TimerFPSTimer(Sender: TObject);
var
i:integer;
begin
//Перерисовываем Canvas
VirtBitmap.Canvas.FillRect(Rect(0,0,VirtBitmap.Width,VirtBitmap.Height));
//Выводим игровое пространство
GameWorld.Show;
//Выводим небо
GameIsle.Show;
//Выводим Фредди
Freddy.Show;
//Каждый объект отрисовываем на виртуальный канвас
//Звёзды
for i := 0 to MaxStars - 1 do
   begin
   If Stars[i] <> nil then
      begin
      Stars[i].Show();
      end;
   end;
//Копируем виртуальный канвас
Form1.Image1.Canvas.Draw(10,10,VirtBitmap);
end;

end.

