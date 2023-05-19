cls:-write('\e[2J'), gotoXY(0,0).
gotoXY(X,Y):-write('\e['),write(X),write(";"),write(Y),write("H").

colorsValids([negre,vermell,verd,groc,blau,lila,cel]).

color(negre):-write("\e[1;90m").
color(vermell):-write("\e[1;91m").
color(verd):-write("\e[1;92m").
color(groc):-write("\e[1;93m").
color(blau):-write("\e[1;94m").
color(lila):-write("\e[1;95m").
color(cel):-write("\e[1;96m").
color(blanc):-write("\e[1;97m").

% T, [T] -> [T]
esborrar(_, [], []).
esborrar(X, [X|L], L).
esborrar(X, [Y|L1], [Y|L2]) :-
    esborrar(X, L1, L2).

% T, [T] -> int
vegades(_, [], 0).
vegades(X, [X|L], N) :- 
    vegades(X, L, NL),
    N is NL + 1.
vegades(X, [_|L], N) :-
    vegades(X, L, N).

% T, [T] -> int
seguits(_, [], 0).
seguits(X, [X|L], N) :-
    seguits(X, L, NL),
    N is NL + 1.
seguits(_, [_|_], 0).

% TODO: Add signatures

treupistes([],[]).
treupistes([X|L1],[Y|L2]):-
    convertir(X,Y),
    treupistes(L1,L2).

convertir([],[]).
convertir([X|L1],[[seguits, X, 1]|L2]) :-
    vegades(X,[X|L1],1),
    convertir(L1,L2).
convertir([X|L1],[[seguits, X, N]|L2]) :-
    vegades(X,[X|_],N),
    seguits(X,[L1],N),
    esborrar(X,[X|L1],L3),
    convertir(L3,L2).
convertir([X|L1],[[no_seguits, X, N]|L2]) :-
    vegades(X,[X|_],N), 
    esborrar(X,[X|L1],L3),
    convertir(L3,L2).