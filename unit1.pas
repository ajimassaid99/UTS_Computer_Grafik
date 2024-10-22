unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, math;


type
  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton; // Tombol untuk translasi
    Button2: TButton; // Tombol untuk scaling
    Button3: TButton; // Tombol untuk rotasi
    Button4: TButton; // Tombol untuk warna jendela
    Button5: TButton; // Tombol untuk warna pintu
    Button6: TButton; // Tombol untuk warna atap
    Button7: TButton; // Tombol untuk warna lantai
    Button9: TButton;
    ColorDialog1: TColorDialog; // ColorDialog untuk jendela
    ColorDialog2: TColorDialog; // ColorDialog untuk pintu
    ColorDialog3: TColorDialog; // ColorDialog untuk atap
    ColorDialog4: TColorDialog; // ColorDialog untuk lantai
    ColorDialog5: TColorDialog;
    Edit1: TEdit; // Untuk translasi X
    Edit2: TEdit; // Untuk translasi Y
    Edit3: TEdit; // Untuk skala
    Edit4: TEdit; // Untuk rotasi
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    PaintBox1: TPaintBox;
    Panel1: TPanel;
    Timer1: TTimer;
    TrackBar1: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
  private
    // Variabel untuk menyimpan status transformasi dan warna
    TranslationX, TranslationY: Integer;
    ScaleFactor: Double;
    RotationAngle: Double;
    WindowColor, DoorColor, RoofColor,WallColor, FloorColor: TColor;
    procedure DrawHouse; // Prosedur untuk menggambar rumah dengan transformasi
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

const
  SHIFT_X = 400;  // Konstanta untuk menggeser semua koordinat X sejauh 400 piksel

// Inisialisasi variabel global
procedure TForm1.FormCreate(Sender: TObject);
begin
  TranslationX := 0;
  TranslationY := 0;
  ScaleFactor := 1.0;
  RotationAngle := 0.0;
  // Warna default
  WindowColor := clSkyBlue;
  DoorColor := clRed;
  RoofColor := clRed;
  FloorColor := clGray;
  WallColor := clYellow;
end;

// Menggambar rumah dengan transformasi
procedure TForm1.DrawHouse;
var
  CenterX, CenterY: Integer;

  function RotateX(x, y: Integer): Integer;
  begin
    Result := CenterX + Round((x - CenterX) * Cos(RotationAngle) - (y - CenterY) * Sin(RotationAngle));
  end;

  function RotateY(x, y: Integer): Integer;
  begin
    Result := CenterY + Round((x - CenterX) * Sin(RotationAngle) + (y - CenterY) * Cos(RotationAngle));
  end;

begin
  // Tentukan pusat dari dinding rumah
  CenterX := 200 + SHIFT_X + TranslationX;
  CenterY := 275 + TranslationY;

  // Bersihkan area PaintBox
  PaintBox1.Canvas.Brush.Color := clWhite;
  PaintBox1.Canvas.FillRect(PaintBox1.ClientRect);

  with PaintBox1.Canvas do
  begin
    // Gambar dinding rumah (persegi panjang kuning)
    Brush.Color := WallColor;
    Polygon([Point(RotateX(CenterX - Round(100 * ScaleFactor), CenterY - Round(75 * ScaleFactor)),
                   RotateY(CenterX - Round(100 * ScaleFactor), CenterY - Round(75 * ScaleFactor))),
             Point(RotateX(CenterX + Round(100 * ScaleFactor), CenterY - Round(75 * ScaleFactor)),
                   RotateY(CenterX + Round(100 * ScaleFactor), CenterY - Round(75 * ScaleFactor))),
             Point(RotateX(CenterX + Round(100 * ScaleFactor), CenterY + Round(75 * ScaleFactor)),
                   RotateY(CenterX + Round(100 * ScaleFactor), CenterY + Round(75 * ScaleFactor))),
             Point(RotateX(CenterX - Round(100 * ScaleFactor), CenterY + Round(75 * ScaleFactor)),
                   RotateY(CenterX - Round(100 * ScaleFactor), CenterY + Round(75 * ScaleFactor)))]);

    // Gambar atap (trapesium merah)
    Brush.Color := RoofColor;
    Polygon([Point(RotateX(CenterX - Round(120 * ScaleFactor), CenterY - Round(75 * ScaleFactor)),
                   RotateY(CenterX - Round(120 * ScaleFactor), CenterY - Round(75 * ScaleFactor))),
             Point(RotateX(CenterX + Round(120 * ScaleFactor), CenterY - Round(75 * ScaleFactor)),
                   RotateY(CenterX + Round(120 * ScaleFactor), CenterY - Round(75 * ScaleFactor))),
             Point(RotateX(CenterX + Round(70 * ScaleFactor), CenterY - Round(125 * ScaleFactor)),
                   RotateY(CenterX + Round(70 * ScaleFactor), CenterY - Round(125 * ScaleFactor))),
             Point(RotateX(CenterX - Round(70 * ScaleFactor), CenterY - Round(125 * ScaleFactor)),
                   RotateY(CenterX - Round(70 * ScaleFactor), CenterY - Round(125 * ScaleFactor)))]);

    // Gambar pintu (persegi panjang merah)
    Brush.Color := DoorColor;
    Polygon([Point(RotateX(CenterX - Round(20 * ScaleFactor), CenterY - Round(5 * ScaleFactor)),
                   RotateY(CenterX - Round(20 * ScaleFactor), CenterY - Round(5 * ScaleFactor))),
             Point(RotateX(CenterX + Round(20 * ScaleFactor), CenterY - Round(5 * ScaleFactor)),
                   RotateY(CenterX + Round(20 * ScaleFactor), CenterY - Round(5 * ScaleFactor))),
             Point(RotateX(CenterX + Round(20 * ScaleFactor), CenterY + Round(75 * ScaleFactor)),
                   RotateY(CenterX + Round(20 * ScaleFactor), CenterY + Round(75 * ScaleFactor))),
             Point(RotateX(CenterX - Round(20 * ScaleFactor), CenterY + Round(75 * ScaleFactor)),
                   RotateY(CenterX - Round(20 * ScaleFactor), CenterY + Round(75 * ScaleFactor)))]);

    // Gambar gagang pintu (lingkaran hitam kecil)
    Brush.Color := clBlack;
    Ellipse(RotateX(CenterX + Round(15 * ScaleFactor), CenterY + Round(35 * ScaleFactor)) - 2,
            RotateY(CenterX + Round(15 * ScaleFactor), CenterY + Round(35 * ScaleFactor)) - 2,
            RotateX(CenterX + Round(15 * ScaleFactor), CenterY + Round(35 * ScaleFactor)) + 2,
            RotateY(CenterX + Round(15 * ScaleFactor), CenterY + Round(35 * ScaleFactor)) + 2);

    // Gambar jendela kiri (persegi panjang biru muda)
    Brush.Color := WindowColor;
    Polygon([Point(RotateX(CenterX - Round(80 * ScaleFactor), CenterY - Round(45 * ScaleFactor)),
                   RotateY(CenterX - Round(80 * ScaleFactor), CenterY - Round(45 * ScaleFactor))),
             Point(RotateX(CenterX - Round(40 * ScaleFactor), CenterY - Round(45 * ScaleFactor)),
                   RotateY(CenterX - Round(40 * ScaleFactor), CenterY - Round(45 * ScaleFactor))),
             Point(RotateX(CenterX - Round(40 * ScaleFactor), CenterY - Round(5 * ScaleFactor)),
                   RotateY(CenterX - Round(40 * ScaleFactor), CenterY - Round(5 * ScaleFactor))),
             Point(RotateX(CenterX - Round(80 * ScaleFactor), CenterY - Round(5 * ScaleFactor)),
                   RotateY(CenterX - Round(80 * ScaleFactor), CenterY - Round(5 * ScaleFactor)))]);

    // Gambar jendela kanan (persegi panjang biru muda)
    Polygon([Point(RotateX(CenterX + Round(40 * ScaleFactor), CenterY - Round(45 * ScaleFactor)),
                   RotateY(CenterX + Round(40 * ScaleFactor), CenterY - Round(45 * ScaleFactor))),
             Point(RotateX(CenterX + Round(80 * ScaleFactor), CenterY - Round(45 * ScaleFactor)),
                   RotateY(CenterX + Round(80 * ScaleFactor), CenterY - Round(45 * ScaleFactor))),
             Point(RotateX(CenterX + Round(80 * ScaleFactor), CenterY - Round(5 * ScaleFactor)),
                   RotateY(CenterX + Round(80 * ScaleFactor), CenterY - Round(5 * ScaleFactor))),
             Point(RotateX(CenterX + Round(40 * ScaleFactor), CenterY - Round(5 * ScaleFactor)),
                   RotateY(CenterX + Round(40 * ScaleFactor), CenterY - Round(5 * ScaleFactor)))]);

    // Gambar alas rumah (abu-abu)
    Brush.Color := FloorColor;
    Polygon([Point(RotateX(CenterX - Round(120 * ScaleFactor), CenterY + Round(75 * ScaleFactor)),
                   RotateY(CenterX - Round(120 * ScaleFactor), CenterY + Round(75 * ScaleFactor))),
             Point(RotateX(CenterX + Round(120 * ScaleFactor), CenterY + Round(75 * ScaleFactor)),
                   RotateY(CenterX + Round(120 * ScaleFactor), CenterY + Round(75 * ScaleFactor))),
             Point(RotateX(CenterX + Round(120 * ScaleFactor), CenterY + Round(95 * ScaleFactor)),
                   RotateY(CenterX + Round(120 * ScaleFactor), CenterY + Round(95 * ScaleFactor))),
             Point(RotateX(CenterX - Round(120 * ScaleFactor), CenterY + Round(95 * ScaleFactor)),
                   RotateY(CenterX - Round(120 * ScaleFactor), CenterY + Round(95 * ScaleFactor)))]);
  end;
end;

// Tombol translasi
procedure TForm1.Button1Click(Sender: TObject);
var
  geserX, geserY: Integer;
begin
  geserX := StrToIntDef(Edit1.Text, 0);
  geserY := StrToIntDef(Edit2.Text, 0);
  TranslationX := TranslationX + geserX;
  TranslationY := TranslationY - geserY; // Y-axis terbalik
  DrawHouse;
end;

// Tombol skala
procedure TForm1.Button2Click(Sender: TObject);
var
  newScale: Double;
begin
  newScale := StrToFloatDef(Edit3.Text, 1.0);
  ScaleFactor := ScaleFactor * newScale;
  DrawHouse;
end;

// Tombol rotasi
procedure TForm1.Button3Click(Sender: TObject);
var
  angle: Integer;
begin
  angle := StrToIntDef(Edit4.Text, 0);
  RotationAngle := RotationAngle + DegToRad(angle); // Konversi ke radian
  DrawHouse;
end;

// Tombol untuk memilih warna jendela
procedure TForm1.Button4Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
  begin
    WindowColor := ColorDialog1.Color;
    DrawHouse;
  end;
end;

// Tombol untuk memilih warna pintu
procedure TForm1.Button5Click(Sender: TObject);
begin
  if ColorDialog2.Execute then
  begin
    DoorColor := ColorDialog2.Color;
    DrawHouse;
  end;
end;

// Tombol untuk memilih warna atap
procedure TForm1.Button6Click(Sender: TObject);
begin
  if ColorDialog3.Execute then
  begin
    RoofColor := ColorDialog3.Color;
    DrawHouse;
  end;
end;

// Tombol untuk memilih warna lantai
procedure TForm1.Button8Click(Sender: TObject);
begin
  if ColorDialog4.Execute then
  begin
    FloorColor := ColorDialog4.Color;
    DrawHouse;
  end;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  if ColorDialog5.Execute then
  begin
    WallColor := ColorDialog5.Color;
    DrawHouse;
  end;
end;

// Tombol untuk memilih warna Dinding


// Menggambar rumah pertama kali
procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
  DrawHouse;
end;

procedure TForm1.PaintBox1Click(Sender: TObject);
begin

end;

end.

