/* Importação de modulos */

:- use_module(library(pce)).
:- use_module(library(pce_style_item)).
:- encoding(utf8).
:- dynamic cervejaPorcentagem/2.
:- dynamic max/1.

/*-------- Dados --------*/


/* Respostas possíveis */

cerveja(c1,'IPA').
cerveja(c2,'Sour Ale').
cerveja(c3,'Dubbel').
cerveja(c4,'Pilsen').
cerveja(c5,'Golden Ale').
cerveja(c6,'Fruit Bear').
cerveja(c7,'Pale Ale').
cerveja(c8,'Saison').

/* Para incremento da porcentagem das cervejas */

cervejaPorcentagem(c1,0).
cervejaPorcentagem(c2,0).
cervejaPorcentagem(c3,0).
cervejaPorcentagem(c4,0).
cervejaPorcentagem(c5,0).
cervejaPorcentagem(c6,0).
cervejaPorcentagem(c7,0).
cervejaPorcentagem(c8,0).

/* Perguntas */

pergunta(p1,'Voce quer uma cerveja muito amarga?',[c1,c2,c3,c4],[c5,c6,c7,c8]).
pergunta(p2,'Voce quer uma cerveja com um teor alcolico alto?',[c1,c2,c5,c6],[c3,c4,c7,c8]).
pergunta(p3,'Voce quer uma cerveja escura?',[c1,c3,c5,c7],[c2,c4,c6,c8]).


/*-------- Sistema Lógico -------- */

/* Reseta a porcentagem, para o programa ser capaz de rodar novamente */
limpar :-
	retract(cervejaPorcentagem(_,_)),
	asserta(cervejaPorcentagem(_,0)),
	fail.
limpar.

max([X],M):-
	cervejaPorcentagem(X,M).
max([H|T],M) :-
	cervejaPorcentagem(H,K),
	max(T,N),
	(K>N -> M=K; M=N).

/* Responsável por chamar a função de perguntas */
perguntas :- 
	perguntar([p1,p2,p3]).

/* Responsável por procurar a resposta e mostrar na tela */
respostas :-
	new(D,dialog('Assistente Cervejeiro')),
	new(L1, label(text, 'A cerveja ideal para você é:')),
	max([c1,c2,c3,c4,c5,c6,c7,c8],X),
	cervejaPorcentagem(H,X),
	cerveja(H,Resposta),

	new(L2,label(text,Resposta)),
	send(D, append(L1)),
	send(D,append(L2)),
	send(D,open_centered),
	limpar.

/* Gera a porcentagem e guarda em cervejaPorcentagem */
gerarPorcentagem([]).
gerarPorcentagem([H|T]) :-
	cervejaPorcentagem(H,X),
	Y is X/3,
	asserta(cervejaPorcentagem(H,Y*100)),
	gerarPorcentagem(T).

/* Faz as perguntas, mostra na tela, e trata a resposta */
perguntar([]).
perguntar([H|T]) :- 
	pergunta(H,Pergunta,Positiva,Negativa), 
	new(Questionario,dialog('Assistente Cervejeiro')),
	new(L1,label(texto,'Responda a seguinte pergunta:')),
	new(L2,label(text,Pergunta)),
	new(B1,button(sim,and(message(Questionario,return,sim)))),
	new(B2,button(não,and(message(Questionario,return,nao)))),

	send(Questionario,append(L1)),
	send(Questionario,append(L2)),
	send(Questionario,append(B1)),
	send(Questionario,append(B2)),

	send(Questionario,default_button,sim),
	send(Questionario,open_centered),get(Questionario,confirm,Resposta),
	send(Questionario,destroy),
	((Resposta==sim) -> incrementar(Positiva), perguntar(T);
	(perguntar(T),incrementar(Negativa))).

/* Incrementa em cervejaPorcentagem */
/* É chamada na consulta perguntar */
incrementar([]).							
incrementar([H|T]):- 
	cervejaPorcentagem(H,Quantidade),
	Y1 is Quantidade+1,
	retract(cervejaPorcentagem(H,_)),
	asserta(cervejaPorcentagem(H,Y1)),
	incrementar(T).

/* Verifica se a Idade é um numero e se é de uma pessoa maior de idade */
verificar(Idade,Menu) :-
	number(Idade),
	((Idade>17) -> true;
	new(Alerta,dialog('Assistente Cervejeiro')),
	new(L1,label(texto,'Você é menor de idade. Em tese, não pode comprar bebida. Vai estudar!')),
	new(B1,button('Ok',and(message(Menu, destroy),message(Menu,free),message(Alerta, destroy),message(Alerta,free)))),
	send(Alerta,append(L1)),
	send(Alerta,append(B1)),
	send(Alerta,open_centered), fail).

/* Consulta chamada pela consulta iniciar. */
/* Responsável chamar as consultas principais */

operacao(Idade,Menu):-
	verificar(Idade,Menu),
	perguntas,
	gerarPorcentagem([c1,c2,c3,c4,c5,c6,c7,c8]),
	respostas.

/* Consulta que deverá ser realizada para o ínicio do programa */
/* Responsável pela primeira interface e por chamar a função que realizará a logica do programa */

iniciar:-
	new(Menu, dialog('Assistente Cervejeiro')),
	new(L1,label(text,'Olá, sou seu Assistente Cervejeiro. Irei ajudar a descobrir a cerveja ideal para você!')),
	new(L2,label(text,'Antes de tudo: Qual a sua idade?')),
	new(T1,int_item('Idade')),
	send(Menu,display,T1,point(110,75)),
	new(B1,button('Ok',message(@prolog,operacao,T1?selection,Menu))),
	new(B2,button('Fechar',and(message(Menu, destroy),message(Menu,free)))),
	
	send(Menu,display,L1,point(20,40)),
	send(Menu,display,L2,point(150,100)),
	send(Menu,display,B1,point(130,150)),
	send(Menu,display,B2,point(300,150)),
	send(Menu,open_centered).