{Program Scape}
{$linklib gcc}
{$linklib SDLmain}

Uses dos,
sdl,
crt;
{$asmmode intel}

Label 1, 2, 3, 4, 5, 6, l1, l2, l3;

Const MaxStars =   400;
    ScreenDist =   40;

Type S1 =   Record
    X,Y:   Integer;
    Z:   Byte;
End;

Type S2 =   Record
    X,Y:   Integer;
End;

Var Star:   Array[1..MaxStars] Of S1;

Var OldStars:   Array[1..MaxStars] Of S2;

Var Stars:   Array[1..MaxStars] Of S2;

Var X, Y, T, C:   Integer;

Var scr:   PSDL_Surface;

Procedure PutPixel (Xx, Yy : Integer; Col: Byte);
Begin
    scr[Xx + Yy * 320] := Col;
End;

Procedure NewStar;

Label l1, l2, l3;
Begin;
    l1:   Star[T].Z := 63;
    If Star[T].Z = 0 Then goto l1;
    l2:   Star[T].X := Random(320) - 160;
    If Star[T].X = 0 Then goto l2;
    l3:   Star[T].Y := Random(200) - 100;
    If Star[T].Y = 0 Then goto l3;
End;

Begin;
    Randomize;

    If SDL_Init( SDL_INIT_VIDEO ) < 0 Then HALT;
    scr := SDL_SetVideoMode(320,200,8, SDL_SWSURFACE);


    For T:= 1 To MaxStars Do
        Begin
            1:   Star[T].Z := Random(63) + 1;
            If Star[T].Z = 0 Then goto 1;
            2:   Star[T].X := Random(320) - 160;
            If Star[T].X = 0 Then goto 2;
            3:   Star[T].Y := Random(200) - 100;
            If Star[T].Y = 0 Then goto 3;
        End;

    Repeat

        For T:= 1 To MaxStars Do
            Begin
                Stars[T].X := ScreenDist * Star[T].X Div Star[T].Z;
                Stars[T].Y := ScreenDist * Star[T].Y Div Star[T].Z;
            End;

        For T:= 1 To MaxStars Do
            Begin
                PutPixel(OldStars[T].X, OldStars[T].Y, 0);
            End;

        For T:= 1 To MaxStars Do
            Begin
                X := Stars[T].X + 160;
                Y := Stars[T].Y + 100;
                If (X > 0) And (X < 320) And (Y > 0) And (Y < 200) Then PutPixel(X,Y, Star[T].Z + 192);
            End;

{WaitRetrace;}

        For T:= 1 To MaxStars Do
            Begin
                OldStars[T].X := Stars[T].X + 160;
                OldStars[T].Y := Stars[T].Y + 100;
                Star[T].Z := Star[T].Z - 1;
                X := Stars[T].X + 160;
                Y := Stars[T].Y + 100;
                If (X < 0) Or (X > 320) Or (Y < 0) Or (Y > 200) Then NewStar;
                If Star[T].Z = 0 Then NewStar;
            End;

    Until KeyPressed;

    SDL_Quit;

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

End.
