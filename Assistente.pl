/* Importação de modulos */

:- use_module(library(pce)).
:- use_module(library(pce_style_item)).
:- encoding(utf8).
:- dynamic cervejaResposta/3.
:- dynamic cerveja/6.
:- dynamic max/1.
:- dynamic incrementar/1.
:- dynamic busca/2.


/*-------- Dados --------*/


/* Respostas possíveis */

cerveja(c1,'IPA',1,1,1,0).
cerveja(c2,'Sour Ale',1,1,0,0).
cerveja(c3,'Dubbel',1,0,1,0).
cerveja(c4,'Pilsen',1,0,0,0).
cerveja(c5,'Golden Ale',0,1,1,0).
cerveja(c6,'Fruit Bear',0,1,0,0).
cerveja(c7,'Pale Ale',0,0,1,0).
cerveja(c8,'Saison',0,0,0,0).

/* Para incremento da porcentagem das cervejas */
/* Primeiro o 'id' da cerveja, depois % de acordo com as respostas, de: amargor, teor alcolico e cor */

cervejaResposta(0,0,0).

/* Perguntas */

pergunta(p1,'Voce quer uma cerveja muito amarga?').
pergunta(p2,'Voce quer uma cerveja com um teor alcolico alto?').
pergunta(p3,'Voce quer uma cerveja escura?').


/*-------- Sistema Lógico -------- */

/* Reseta a porcentagem, para o programa ser capaz de rodar novamente */
limpar :- asserta(cervejaResposta(0,0,0)),fail.
limpar.

/* Responsável por chamar a função de perguntas */
perguntas :- 
	perguntar([p1,p2,p3]).

/* Busca Resposta */

busca([]).
busca([H|T]) :-
	cervejaResposta(X,Y,Z),
	cerveja(H,K,A,B,C,_),
	((A==X),(B==Y),(C==Z) -> asserta(cerveja(H,K,X,Y,Z,100)); busca(T)).

/*funcao recursiva */
	

/* Responsável por procurar a resposta e mostrar na tela */
respostas :-
	new(D,dialog('Assistente Cervejeiro')),
	
	busca([c1,c2,c3,c4,c5,c6,c7,c8]),
	cerveja(Id,Resposta,A1,A2,A3,100),

	new(L1,label(text,'A cerveja ideal para você é:')),
	new(L2,label(text,Resposta)),
	send(D,append(L1)),
	send(D,append(L2)),
	send(D,open_centered),
	limpar,
	asserta(cerveja(Id,Resposta,A1,A2,A3,0)).

/* Incrementa em cervejaPorcentagem */
/* É chamada na	 consulta perguntar */

incrementar(p1) :- 
	cervejaResposta(X,Y,Z),
	asserta(cervejaResposta(1,Y,Z)),!.
incrementar(p2) :- 
	cervejaResposta(X,Y,Z),
	asserta(cervejaResposta(X,1,Z)),!.
incrementar(p3) :- 
	cervejaResposta(X,Y,Z),
	asserta(cervejaResposta(X,Y,1)),!.


/* Faz as perguntas, mostra na tela, e trata a resposta */
perguntar([]).
perguntar([H|T]) :- 
	pergunta(H,Pergunta), 
	new(Questionario,dialog('Assistente Cervejeiro')),
	new(L1,label(text,'Responda a seguinte pergunta:')),
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
	((Resposta==sim) -> incrementar(H), perguntar(T);
	perguntar(T)).

/* Verifica se a Idade é um numero e se é de uma pessoa maior de idade */
verificar(Idade,Menu) :-
	number(Idade),
	((Idade>17) -> true;
	new(Alerta,dialog('Assistente Cervejeiro')),
	new(L1,label(text,'Você é menor de idade. Em tese, não pode comprar bebida. Vai estudar!')),
	new(B1,button('Ok',and(message(Menu, destroy),message(Menu,free),message(Alerta, destroy),message(Alerta,free)))),
	send(Alerta,append(L1)),
	send(Alerta,append(B1)),
	send(Alerta,open_centered), fail).

/* Consulta chamada pela consulta iniciar. */
/* Responsável chamar as consultas principais */

operacao(Idade,Menu):-
	verificar(Idade,Menu),
	perguntas,
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