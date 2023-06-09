% Clears the screen and moves the cursor to the top-left corner
cls :-
    write('\e[2J'), gotoXY(0,0).

% Moves the cursor to the specified position (X, Y) in the console
gotoXY(X,Y) :-
    write('\e['),write(Y),write(";"),write(X),write("H").

% Defines the valid colors for the nonogram
colorsValids([negre,vermell,verd,groc,blau,lila,cel]).

% Sets the console color to display text in the specified color
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

% Writes the nonogram to the console
escriuNonograma([]).
escriuNonograma([X|L]) :-
    writeln(X), escriuNonograma(L).

% Ej 2

% Writes a colored value at the specified position (X, Y) in the console
writeAtColored(X, Y, Color, Value) :-
    gotoXY(X,Y),
    color(Color),
    write(Value),
    color(negre).

% Displays the nonogram on the console
mostraNonograma([], _, _, _, _).
mostraNonograma([Row | List], Y, X, IncY, IncX) :-
    writeRow(Row, X, Y, IncX),
    Y2 is Y + IncY,
    mostraNonograma(List, Y2, X, IncY, IncX).

% Writes a row of colored values on a display or output.
writeRow([], _, _, _).
writeRow([Val | List], X, Y, IncX) :-
    writeAtColored(X, Y, Val, "X"),
    X2 is X + IncX,
    writeRow(List, X2, Y, IncX).

% Ej3
% Generates a nonogram with the specified number of rows and columns
ferNonograma(_, 0, _, []) :- !.
ferNonograma(Colors, Rows, Cols, [Row | NonoRest]) :-
    createRow(Colors, Cols, Row),
    Rows2 is Rows - 1,
    ferNonograma(Colors, Rows2, Cols, NonoRest).

% Creates a row of a matrix with the specified colors as posible values of the specified length
createRow(_, 0, []) :- !.
createRow(Colors, Length, [Color | RowRest]) :-
    getRandom(Colors, Color),
    Length1 is Length - 1,
    createRow(Colors, Length1, RowRest).

% Fetches a random values of the list
getRandom(List, Elem) :-
    length(List, Length),
    random(0, Length, Index),
    nth0(Index, List, Elem).

% Ej 4

% Removes the first element of a list
removeFirst(X, [X | L], L).
removeFirst(X, [Y | L1], [Y | L2]) :-
    removeFirst(X, L1, L2).

% Returns the amount of X elements inside the list
amount(_, [], 0).
amount(X, [X | L], N) :-
    amount(X, L, NL),
    N is NL + 1,
    !.
amount(X, [_ | L], N) :-
    amount(X, L, N),
    !.

% Returns the ammount of consecutive X elements inside the list
consecutive(_, [], 0) :- !.
consecutive(X, [X | L], N) :-
    consecutive(X, L, NL),
    !,
    N is NL + 1.
consecutive(_, _, 0).

% Generates all the hints of a nonogram, stating the continuity, color and amount
descriuNonograma(Nonogram, Result):-
    describeHint(Nonogram, NonTransposedResult),
    transposeMatrix(Nonogram, TransposedNonogram),
    describeHint(TransposedNonogram, TransposedResult),
    append([NonTransposedResult], [TransposedResult], Result),
    !.

% Transposes a matrix
transposeMatrix([], []).
transposeMatrix([[]|L], []):- transposeMatrix(L, []).
transposeMatrix(M, [C|T]):-
    transposeColumn(M, C, M1),
    transposeMatrix(M1, T).

% returns the transposed colum and the remainig slice of the matrix
transposeColumn([], [], []).
transposeColumn([[X|L1]|M], [X|C], [L1|M1]):-
    transposeColumn(M, C, M1).

% Describes the hints for a nonogram
describeHint([], []).
describeHint([X | L1], [Y | L2]) :-
    describe(X, Y),
    describeHint(L1, L2).

% Generates a hint for each different possible combination. To avoid possible representation errors
% we state that the "joker" element is to be avoided
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

% Replaces all the X elements inside the list with "joker" tokens
replaceAll(_, [], []).
replaceAll(X, [X | L], [joker | R]) :-
    replaceAll(X, L, R),
    !.
replaceAll(X, [Y | L], [Y | R]) :-
    replaceAll(X, L, R),
    !.

% Ej 5

% Shows the horizontal hints
mostraPistesHorizontals([], _, _, _, _).
mostraPistesHorizontals([RowHints | Desc], Row, Col, IncY, IncX) :-
    showHintRow(RowHints, Row, Col, IncX),
    RowInc is Row + IncY,
    !,
    mostraPistesHorizontals(Desc, RowInc, Col, IncY, IncX).

% Displays a single row of hints
showHintRow([], _, _, _).
showHintRow([Hint | Hints], Row, Col, IncX) :-
    showHint(Hint, Col, Row),
    ColInc is Col + IncX,
    showHintRow(Hints, Row, ColInc, IncX).

% Shows the vertical hints
mostraPistesVerticals([], _, _, _, _).
mostraPistesVerticals([ColHints | Desc], Row, Col, IncY, IncX) :-
    showHintCol(ColHints, Row, Col, IncY),
    ColInc is Col + IncX,
    !,
    mostraPistesVerticals(Desc, Row ,ColInc, IncY, IncX).

% Displays a single column of hints
showHintCol([], _, _, _).
showHintCol([Hint | Hints], Row, Col, IncY) :-
    showHint(Hint, Col, Row),
    RowInc is Row + IncY,
    showHintCol(Hints, RowInc, Col, IncY).

% Displays a single hint
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

% Tries to solve a nonogram
resolNonograma([HoriontalDesc, VerticalDesc], Nono):-
    solveRows(HoriontalDesc, Nono),
    transposeMatrix(Nono, TransposedNono),
    checkRows(VerticalDesc, TransposedNono),
    !.

% Checks if all the rows of the nonogram are a possible solution given the descriptions
checkRows([], []).
checkRows([RowDescription | RowDescriptions], [Row | Matrix]) :-
    describe(Row, RowDescription),
    !,
    checkRows(RowDescriptions, Matrix).

% Tries to find a solution row given the description
solveRows([], []).
solveRows([RowDescription | RowDescpritions], [RowSolution | Nono]) :-
    getColors(RowDescription, Colors),
    permute(Colors, RowSolution),
    describe(RowSolution, RowDescription),
    solveRows(RowDescpritions, Nono).

% Gets all possible colors of a given Row description
getColors([],[]).
getColors([[_, Color, Times] | Descriptions], ColorSolution) :-
    addRepeated(Color, Times, Colors),
    getColors(Descriptions, L),
    append(Colors, L, ColorSolution).

% Append repeated times the specified color Times times
addRepeated(_, 0, []) :- !.
addRepeated(Color, Times, [Color | List]) :-
    Times1 is Times - 1,
    addRepeated(Color, Times1, List),
    !.

% Generate permutations of the given list
permute([], []).
permute(List, [Element | PermutedList]) :-
    removeFirst(Element, List, L1),
    permute(L1, PermutedList).

% Testing
nono(
        [
            [verd, lila, vermell, vermell],
            [blau, verd, blau, blau],
            [lila, blau, verd, verd],
            [verd, blau, vermell, verd]
        ]
).

ej1 :-
    cls,
    nono(Nono),
    escriuNonograma(Nono),
    !.

ej2 :-
    cls,
    nono(Nono),
    mostraNonograma(
        Nono,
        6,
        15,
        1,
        3
    ),
    !.

ej3 :-
    cls,
    ferNonograma(
        [verd, blau, vermell],
        3,
        4,
        Nono
    ),
    writeln(Nono),
    !.

ej4 :-
    cls,
    nono(Nono),
    descriuNonograma(
        Nono,
        [H, V | _]
    ),
    writeln(H),
    nl,
    writeln(V),
    !.

ej5 :-
    cls,
    nono(Nono),
    descriuNonograma(
        Nono,
        [H, V | _ ]
    ),
    mostraPistesVerticals(V, 2, 15, 1, 3),
    mostraPistesHorizontals(H, 6, 5, 1, 3),
    !.

ej6 :-
    cls,
    nono(Nono),
    descriuNonograma(
        Nono,
        Pistes
    ),
    resolNonograma(Pistes, Result),
    writeln(Result),
    !.

display:-
    cls,
    nono(Nono),
    descriuNonograma(
        Nono,
        [H, V | _ ]
    ),
    resolNonograma([
        H,
        V
    ], Result),

    mostraPistesVerticals(V, 2, 15, 1, 3),
    mostraPistesHorizontals(H, 6, 5, 1, 3),
    mostraNonograma(
        Result,
        6,
        15,
        1,
        3
    ),
    !.

