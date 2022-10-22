unit UWorld;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

  Const
  //Основные константы
  ImgGameWorldMax = 6;
  //6 Кусочков пейзажа земли, которые можно занести в массив. Каждый кусочек соответствует определённому графическому изображению.
  TextureWidth = 16; //10
// 
  GameWorldMaxX = 110;
//Размер игрового пространства по Х
  GameWorldConst: array[0..GameWorldMaxX - 1] of byte = (0, 1, 2, 3, 4, 5, 6, 0, 0, 0,
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

  TGameWorld = class (TObject)
  public
  //TimerAnimation: TTimer;
  //Таймер анимации пейзажа
  WorldX, WorldY: integer;
  ImgGameWorld: array[0..ImgGameWorldMax] of TBitMap;
  //Çàäà¸ì ñïðàéòû èãðîâîãî ïðîñòðàíñòâà
  GameWorldArr: array[0..GameWorldMaxX - 1] of byte;
  //procedure TimerAnimationProccessing(Sender: TObject);
  procedure Show;
  Constructor CreateGameWorld(ownerForm: TWinControl);
  Destructor Destroy(); override;
  end;

implementation

Uses UMainProg, UStar;

constructor TGameWorld.CreateGameWorld(ownerForm: TWinControl);
var
i:integer;
begin
//Ïðèñâàèâàåì çíà÷åíèå ïåðåìåííûì èãðîâîãî ïðîñòðàíñòâà ïî X è Y
WorldX := 0;//40
WorldY := 350;

For i:=0 to length(GameWorldArr) - 1  Do
  begin
  GameWorldArr[i] := GameWorldConst[i];
  end;

//Çàãðóæàåì ñïðàéòû â ìàññèâ èãðîâîãî ïðîñòðàíñòâà
For i := 0 to length(ImgGameWorld) - 1  Do
   begin
   ImgGameWorld[i]:=TBitMap.Create;
   ImgGameWorld[i].LoadFromFile(ExePath + 'Graphics\Ground'+IntToStr(i)+'.bmp');
   ImgGameWorld[i].Transparent:=True;
   ImgGameWorld[i].TransparentMode:=tmFixed;
   ImgGameWorld[i].TransparentColor:=clBlack;
   //ImgMassStar[i].Canvas.Brush.Color:=clPurple;
   end;
//Âêëþ÷àåì òàéìåð çâ¸çä
//self.TimerAnimation := TTimer.Create(nil);
//self.TimerAnimation.OnTimer:=self.TimerAnimationProccessing;
//self.TimerAnimation.Interval:=round((Random*200)+500);
//TimerAnimation.Enabled:=true;
end;



procedure TGameWorld.Show;
var
i, Xscreen: integer;
sprindex: byte;
FirstBrick: integer;
LastBrick : integer;
begin
xScreen := 0;

//Ìû äîëæíû ïèêñåëè êîîðäèíàòû XWorld ïåðåñ÷èòàòü â ïåðâûé êèðïè÷, ñ êîòîðîãî ìû äîëæíû íà÷àòü âûâîäèòü èãðîâîå ïðîñòðàíñòâî.
FirstBrick := round(WorldX div TextureWidth);
LastBrick := FirstBrick + round(VirtBitmap.Width div TextureWidth * TextureWidth/TextureWidth);
if FirstBrick <= 0 then
  begin
  FirstBrick := 0;
  if WorldX < 0 then WorldX:= 0;
  end;
if LastBrick >= Length(GameWorldArr) then
  begin
  LastBrick := Length(GameWorldArr);
  if WorldX > (((LastBrick + 1) * TextureWidth) - VirtBitmap.Width) then WorldX := ((LastBrick + 1) * TextureWidth) - VirtBitmap.Width;
  end;
xScreen := -round(WorldX - WorldX div TextureWidth * TextureWidth);
for i := FirstBrick to LastBrick do
  begin
   //×èòàåì èç ìàññèâà èãðîâîãî ïðîñòðàíñòâà íîìåð ñïðàéòà
  sprindex := self.GameWorldArr[i];
  //Íåîáõîäèìî ïåðåñ÷èòàòü Xscreen â êîîðäèíàòû âèðòóàëüíîãî ýêðàíà.
  VirtBitmap.Canvas.Draw(xScreen, self.WorldY, self.ImgGameWorld[sprindex]);
  // Ïðèáàâëÿåì 10. 10 - ðàçìåð ñïðàéòîâ ïî 10 ïèêñåëåé, ó÷ò¸ì ýòî
  xScreen:= xScreen + TextureWidth;
  end;

VirtBitmap.Canvas.Font.Size := 8;
VirtBitmap.Canvas.Font.Color := clWhite;
VirtBitmap.Canvas.TextOut( 10, 10, 'WorldX=' + inttostr(WorldX));
VirtBitmap.Canvas.TextOut( 10, 30, 'FirstBrick=' + inttostr(FirstBrick));
VirtBitmap.Canvas.TextOut( 10, 50, 'LastBrick=' + inttostr(LastBrick));

end;



//Ýòî äåñòðóêòîð ñïðàéòîâ èãðîâîãî ïðîñòðàíñòâà
destructor TGameWorld.Destroy;
var
i:byte;
begin
//Çäåñü ìû óäàëÿåì èç ïàìÿòè çâ¸çäû
For i:=0 to length(ImgGameWorld) - 1  Do
   begin
   ImgGameWorld[i].Free;
   //ImgMassStar[i].Canvas.Brush.Color:=clPurple;
   end;
//Óäàëÿåì òàéìåð
//TimerAnimation.free;
//Âûçîâ äåñòðóêòîðà ðîäèòåëüñêîãî êëàññà
inherited;
end;

end.
