:- use_module(library(pce)).
:- use_module(library(pce_style_item)).
:- encoding(utf8).
:- dynamic yes/1,no/1.

cerveja(c1,'IPA').
cerveja(c2,'Sour Ale').
cerveja(c3,'Dubbel').
cerveja(c4,'Pilsen').
cerveja(c5,'Golden Ale').
cerveja(c6,'Fruit Bear').
cerveja(c7,'Pale Ale').
cerveja(c8,'Saison').

pergunta(p1,'Voce quer uma cerveja muito amarga?').
pergunta(p2,'Voce quer uma cerveja com um teor alcolico alto?').
pergunta(p3,'Voce quer uma cerveja escura?').

/* busca a ser testada*/
busca(c1) :- c1, !.
busca(c2) :- c2, !.
busca(c3) :- c3, !.
busca(c4) :- c4, !.
busca(c5) :- c5, !.
busca(c6) :- c6, !.	
busca(c7) :- c7, !.
busca(c8) :- c8, !. 


c1:-verificar(p1), verificar(p2), verificar(p3).
c2:-verificar(p1), verificar(p2).
c3:-verificar(p1), verificar(p3).
c4:-verificar(p1).
c5:-verificar(p2), verificar(p3).
c6:-verificar(p2).
c7:-verificar(p3).
c8:-not(verificar(p1)), not(verificar(p2)), not(verificar(p3)).

perguntar(Pergunta):-
	new(D,dialog('Assistente Cervejeiro')),
	pergunta(Pergunta,Q),
	new(L1, label(perg, Q)),

	new(B1,button(sim,and(message(D,return,yes)))),
	new(B2,button(nao,and(message(D,return,no)))),

    send(D, append(L1)),
    send(D, append(B1)),
    send(D, append(B2)),

	send(D,default_button,sim),
	send(D,open_centered),
	get(D,confirm,Resposta),
	send(D, destroy),
	((Resposta == yes) -> assert(yes(Pergunta)) ; assert(no(Pergunta)), fail).



verificar(S) :- (yes(S) -> true ; (no(S) -> fail ; perguntar(S))).
limpar :- retract(yes(_)),fail.
limpar :- retract(no(_)),fail.
limpar.

operacao:-
	new(D,dialog('Assistente Cervejeiro')),
	new(L1, label(text, 'A cerveja ideal para você é:')),
	busca(Cerveja),
	cerveja(Cerveja,X),
	new(L2, label(pag, X)),
	limpar,
	send(D, append(L1)),
	send(D, append(L2)),
	send(D,open_centered).

iniciar:-
	new(Menu, dialog('Assistente Cervejeiro')),
	new(L1,label(text,'Olá, sou seu Assistente Cervejeiro. Irei ajudar a descobrir a cerveja ideal para você!')),
	new(L2,label(text,'Pode responder algumas perguntas?')),
	new(T1,text_item('Nome')),
	send(Menu,display,T1,point(150,110)),
	new(B1,button('Sim',message(@prolog,operacao,T1?selection))),
	new(B2,button('Fechar',and(message(Menu, destroy),message(Menu,free)))),

	send(Menu,display,L1,point(20,40)),
	send(Menu,display,L2,point(150,75)),
	send(Menu,display,B1,point(130,150)),
	send(Menu,display,B2,point(300,150)),
	send(Menu,open_centered).
	
