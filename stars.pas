Uses Crt;
label 1, 2, 3, 4, 5, 6, l1, l2, l3;
CONST MaxStars = 400; ScreenDist = 40;
Type S1 = Record
     X,Y: Integer;
     Z: Byte;
End;
Type S2 = Record
     X,Y: Integer;
End;

Var Star: Array[1..MaxStars] of S1;
Var OldStars: Array[1..MaxStars] of S2;
Var Stars: Array[1..MaxStars] of S2;
Var X, Y, T, C: Integer;

Procedure PutPixel (Xx, Yy : Integer; Col: Byte);
begin
Mem[$A000:Xx + Yy * 320]:=Col;
end;

Procedure Pal(Col,R,G,B : Byte); assembler;
asm
  mov    dx,3c8h
  mov    al,[col]
  out    dx,al
  inc    dx
  mov    al,[r]
  out    dx,al
  mov    al,[g]
  out    dx,al
  mov    al,[b]
  out    dx,al
end;

Procedure WaitRetrace; assembler;
label
  e1, e2;
asm
  mov dx,3DAh
e1:
  in al,dx
  and al,08h
  jnz e1
e2:
  in al,dx
  and al,08h
  jz  e2
end;

Procedure NewStar;
label l1, l2, l3;
Begin;
l1: Star[T].Z:= 63;
 IF Star[T].Z = 0 then goto l1;
l2: Star[T].X:= Random(320) - 160;
 IF Star[T].X = 0 then goto l2;
l3: Star[T].Y:= Random(200) - 100;
 IF Star[T].Y = 0 then goto l3;
End;

Begin;
Randomize;

asm
  mov ax, 13h
  int 10h
end;

T:= 255;
For C:=1 to 64 do BEGIN
 Pal(T,C,C,C);
 T:= T - 1;
END;

For T:= 1 to MaxStars do BEGIN
1: Star[T].Z:= Random(63) + 1;
 IF Star[T].Z = 0 then goto 1;
2: Star[T].X:= Random(320) - 160;
 IF Star[T].X = 0 then goto 2;
3: Star[T].Y:= Random(200) - 100;
 IF Star[T].Y = 0 then goto 3;
END;

Repeat

For T:= 1 to MaxStars do BEGIN
 Stars[T].X:= ScreenDist * Star[T].X div Star[T].Z;
 Stars[T].Y:= ScreenDist * Star[T].Y div Star[T].Z;
End;

For T:= 1 to MaxStars do BEGIN
 PutPixel(OldStars[T].X, OldStars[T].Y, 0);
End;

For T:= 1 to MaxStars do BEGIN
 X:= Stars[T].X + 160;
 Y:= Stars[T].Y + 100;
 IF (X > 0) and (X < 320) and (Y > 0) and (Y < 200) Then PutPixel(X,Y, Star[T].Z + 192);
END;

WaitRetrace;

For T:= 1 to MaxStars do BEGIN
 OldStars[T].X:= Stars[T].X + 160;
 OldStars[T].Y:= Stars[T].Y + 100;
 Star[T].Z:= Star[T].Z - 1;
 X:= Stars[T].X + 160;
 Y:= Stars[T].Y + 100;
 IF (X < 0) or (X > 320) or (Y < 0) or (Y > 200) then NewStar;
 IF Star[T].Z = 0 then NewStar;
End;

Until KeyPressed;

asm
  mov ax, 3h
  int 10h
end;

Textcolor(15);
Textbackground(0);
Writeln('                 Hope you liked this Star Field Simulation');
Writeln;
Writeln('       If your version was modified and you would like to have a copy');
Writeln('      of the original, please Email me, please specify BASIC or PASCAL');
Writeln('                           Email:  pwac@flinet.com');
Writeln('        If you would like any programs writin or if you live in the');
Writeln('               West Palm Beach Florida area. ACS can help you.');
Writeln('   For any of the above mentioned please visit http://www.flinet.com/~pwac');
WriteLn;

END.