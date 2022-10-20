unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Math, StdCtrls;

Const
//Основные константы
xmin = 0;
ymin = 0;
XScreenMax = 880;
YScreenMax = 600;


type
  TForm1 = class(TForm)
    Image1: TImage;
    TimerFPS: TTimer;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

//Заводим виртуальный Canvas
VirtBitmap: TBitmap;

//Пуск
implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
//Заполняем Canvas чёрным цветом
Form1.Image1.Canvas.Brush.Color:=clBlack;
Form1.Image1.Canvas.FillRect(Rect(xmin,ymin,XScreenMax,YScreenMax));
Form1.Image1.Width:=XScreenMax;
Form1.Image1.Height:=YScreenMax;
//Создаём виртуальный Bitmap
VirtBitmap:=TBitmap.Create;
VirtBitmap.Width:=Image1.Width;
VirtBitmap.Height:=Image1.Height;
end;

end.
