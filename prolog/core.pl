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
% T, [T] | [T]
removeFirst(X, [X | L], L).
removeFirst(X, [Y | L1], [Y | L2]) :-
    removeFirst(X, L1, L2).

% T, [T] | int
amount(_, [], 0).
amount(X, [X | L], N) :-
    amount(X, L, NL),
    N is NL + 1,
    !.
amount(X, [_ | L], N) :-
    amount(X, L, N),
    !.

% T, [T] | int
consecutive(_, [], 0) :- !.
consecutive(X, [X | L], N) :-
    consecutive(X, L, NL),
    !,
    N is NL + 1.
consecutive(_, _, 0).

descriuNonograma(Nonogram, Result):-
    describeHint(Nonogram, NonTransposedResult),
    transposeMatrix(Nonogram, TransposedNonogram),
    describeHint(TransposedNonogram, TransposedResult),
    append([NonTransposedResult], [TransposedResult], Result),
    !.

transposeMatrix([], []).
transposeMatrix([[]|L], []):- transposeMatrix(L, []).
transposeMatrix(M, [C|T]):-
    transposeColumn(M, C, M1),
    transposeMatrix(M1, T).

transposeColumn([], [], []).
transposeColumn([[X|L1]|M], [X|C], [L1|M1]):-
    transposeColumn(M, C, M1).

describeHint([], []).
describeHint([X | L1], [Y | L2]) :-
    describe(X, Y),
    describeHint(L1, L2).

describe([], []) :- !.
describe([joker | L1], L) :-
    describe(L1, L).
describe([X | L1], [[seguits, X, 1] | L2]) :-
    amount(X, [X | L1], N),
    N = 1,
    !,
    describe(L1, L2).
describe([X | L1], [[seguits, X, N] | L2]) :-
    amount(X, [X | L1], N),
    consecutive(X, [X | L1], N),
    replaceAll(X, [X | L1], L3),
    describe(L3, L2),
    !.
describe([X | L1], [[no_seguits, X, N] | L2]) :-
    amount(X, [X | L1], N),
    replaceAll(X, [X | L1], L3),
    describe(L3, L2).

replaceAll(_, [], []).
replaceAll(X, [X | L], [joker | R]) :-
    replaceAll(X, L, R),
    !.
replaceAll(X, [Y | L], [Y | R]) :-
    replaceAll(X, L, R),
    !.

% Ej 5

mostraPistesHorizontals([], _, _, _, _).
mostraPistesHorizontals([RowHints | Desc], Row, Col, IncY, IncX) :-
    showHintRow(RowHints, Row, Col, IncX),
    RowInc is Row + IncY,
    !,
    mostraPistesHorizontals(Desc, RowInc, Col, IncY, IncX).

showHintRow([], _, _, _).
showHintRow([Hint | Hints], Row, Col, IncX) :-
    showHint(Hint, Col, Row),
    ColInc is Col + IncX,
    showHintRow(Hints, Row, ColInc, IncX).

mostraPistesVerticals([], _, _, _, _).
mostraPistesVerticals([ColHints | Desc], Row, Col, IncY, IncX) :-
    showHintCol(ColHints, Row, Col, IncY),
    ColInc is Col + IncX,
    !,
    mostraPistesVerticals(Desc, Row ,ColInc, IncY, IncX).

showHintCol([], _, _, _).
showHintCol([Hint | Hints], Row, Col, IncY) :-
    showHint(Hint, Col, Row),
    RowInc is Row + IncY,
    showHintCol(Hints, RowInc, Col, IncY).

showHint([seguits, Color, 1], Col, Row) :-
    writeAtColored(Col, Row, Color, 1).
showHint([seguits, Color, N], Col, Row) :-
    MinusCol is Col - 1,
    writeAtColored(MinusCol, Row, Color, "<"),
    writeAtColored(Col, Row, Color, N),
    PlusCol is Col + 1,
    writeAtColored(PlusCol, Row, Color, ">").
showHint([no_seguits, Color, N], Col, Row) :-
    writeAtColored(Col, Row, Color, N).

% Ej 6

resolNonograma([HoriontalDesc, VerticalDesc], Nono):-
    solveRows(HoriontalDesc, Nono),
    transposeMatrix(Nono, TransposedNono),
    % IT breaks here :DDDDDDDDDD
    checkRows(VerticalDesc, TransposedNono),
    !.

checkRows([], []).
checkRows([RowDescription | RowDescriptions], [Row | Matrix]) :-
    isSolution(Row, RowDescription),
    !,
    checkRows(RowDescriptions, Matrix).

solveRows([], []).
solveRows([RowDescription | RowDescpritions], [RowSolution | Nono]) :-
    getColors(RowDescription, Colors),
    permute(Colors, RowSolution),
    isSolution(RowSolution, RowDescription),
    solveRows(RowDescpritions, Nono).

getColors([],[]).
getColors([[_, Color, Times] | Descriptions], ColorSolution) :-
    addRepeated(Color, Times, Colors),
    getColors(Descriptions, L),
    append(Colors, L, ColorSolution).

addRepeated(_, 0, []) :- !.
addRepeated(Color, Times, [Color | List]) :-
    Times1 is Times - 1,
    addRepeated(Color, Times1, List),
    !.

permute([], []).
permute(List, [Element | PermutedList]) :-
    removeFirst(Element, List, L1),
    permute(L1, PermutedList).

isSolution(Row, Description) :-
    describe(Row, RowDesc),
    !,
    Description == RowDesc.
