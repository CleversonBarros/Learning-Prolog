pai(marcos,joao).
pai(marcos,maria).
pai(marcos,pedro).
pai(pedro,carlos).
mae(marta,joao).
mae(marta,maria).
mae(ana,pedro).
mae(eva,carlos).
homem(marcos).
homem(joao).
homem(pedro).
homem(carlos).
mulher(marta).
mulher(maria).
mulher(ana).
mulher(eva).

gerou(X,Y) :- pai(X,Y); mae(X,Y).

avô(X,Y) :- pai(X,Z), pai(Z,Y), homem(X); pai(X,Z), mae(Z,Y), homem(X).
avó(X,Y) :- mae(X,Z), mae(Z,Y), mulher(X); mae(X,Z), pai(Z,Y), mulher(X).
irmão(X,Y) :- pai(Z,X), pai(Z,Y), X\=Y, homem(X); mae(Z,X), mae(Z,Y), X\=Y, homem(X).
irmã(X,Y) :- pai(Z,X), pai(Z,Y), X\=Y, mulher(X); mae(Z,X), mae(Z,Y), X\=Y, mulher(X).
tio(X,Y) :- irmão(X,Z), pai(Z,Y), homem(X); irmão(X,Z), mae(Z,Y), homem(X).