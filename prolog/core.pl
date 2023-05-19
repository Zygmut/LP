cls :-
    write('\e[2J'), gotoXY(0,0).

gotoXY(X,Y) :-
    write('\e['),write(Y),write(";"),write(X),write("H").

colorsValids([negre,vermell,verd,groc,blau,lila,cel]).

color(negre) :-
    write("\e[1;90m").
color(vermell) :-
    write("\e[1;91m").
color(verd) :-
    write("\e[1;92m").
color(groc) :-
    write("\e[1;93m").
color(blau) :-
    write("\e[1;94m").
color(lila) :-
    write("\e[1;95m").
color(cel) :-
    write("\e[1;96m").
color(blanc) :-
    write("\e[1;97m").


% Ej 1
% List => Void
escriuNonograma([]).
escriuNonograma([X|L]) :-
    writeln(X), escriuNonograma(L).

% Ej 2
% color, int, int
writeAtColored(X, Y, Color, Value) :-
    gotoXY(X,Y),
    color(Color),
    write(Value),
    color(negre).

% [[Color]], int, int, int, int
mostraNonograma([], _, _, _, _).
mostraNonograma([Row | List], Y, X, IncY, IncX) :-
    writeRow(Row, X, Y, IncX),
    Y2 is Y + IncY,
    mostraNonograma(List, Y2, X, IncY, IncX).

% [Color], int, int, int
writeRow([], _, _, _).
writeRow([Val | List], X, Y, IncX) :-
    writeAtColored(X, Y, Val, "X"),
    X2 is X + IncX,
    writeRow(List, X2, Y, IncX).


% Ej3
% [Color], int, int | [[Color]]
ferNonograma(_, 0, _, []) :- !.
ferNonograma(Colors, Rows, Cols, [Row | NonoRest]) :-
    createRow(Colors, Cols, Row),
    Rows2 is Rows - 1,
    ferNonograma(Colors, Rows2, Cols, NonoRest).

createRow(_, 0, []) :- !.
createRow(Colors, Length, [Color | RowRest]) :-
    getRandom(Colors, Color),
    Length1 is Length - 1,
    createRow(Colors, Length1, RowRest).

getRandom(List, Elem) :-
    length(List, Length),
    random(0, Length, Index),
    nth0(Index, List, Elem).

% Ej 4
% T, [T] -> [T]
esborrar(_, [], []).
esborrar(X, [X|L], L).
esborrar(X, [Y|L1], [Y|L2]) :-
    esborrar(X, L1, L2).

% T, [T] -> int
vegades(_, [], 0).
vegades(X, [X | L], N) :-
    vegades(X, L, NL),
    N is NL + 1.
vegades(X, [_ | L], N) :-
    vegades(X, L, N).

% T, [T] -> int
seguits(_, [], 0).
seguits(X, [X | L], N) :-
    seguits(X, L, NL),
    N is NL + 1.
seguits(_, [_ | _], 0).

descriuNonograma([], []).
descriuNonograma([X | L1],[Y | L2]):-
    convertir(X, Y),
    descriuNonograma(L1, L2).

convertir([], []).
convertir([X | L1],[[seguits, X, 1] | L2]) :-
    vegades(X, [X | L1], 1),
    !,
    convertir(L1, L2).
convertir([X | L1],[[seguits, X, N] | L2]) :-
    vegades(X, [X | L1], N),
    seguits(X, [X | L1], N),
    !,
    esborrar(X, [X | L1], L3),
    convertir(L3, L2).
convertir([X | L1], [[no_seguits, X, N] | L2]) :-
    vegades(X, [X | L1], N),
    esborrar(X, [X | L1], L3),
    convertir(L3, L2).