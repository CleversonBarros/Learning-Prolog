:- use_module(library(pce)).
:- use_module(library(pce_style_item)).
:- encoding(utf8).
:- dynamic cerveja/6.
:- dynamic resposta/3.
:- dynamic max/2.

/* Base de Conhecimento */

cerveja(c1,'IPA',grauTeor,grauAmargor,grauCor,0).
cerveja(c2,'Sour Ale',grauTeor,grauAmargor,grauCor,0).
cerveja(c3,'Dubbel',grauTeor,grauAmargor,grauCor,0).
cerveja(c4,'Pilsen',grauTeor,grauAmargor,grauCor,0).
cerveja(c5,'Golden Ale',grauTeor,grauAmargor,grauCor,0).
cerveja(c6,'Fruit Bear',grauTeor,grauAmargor,grauCor,0).
cerveja(c7,'Pale Ale',grauTeor,grauAmargor,grauCor,0).
cerveja(c8,'Saison',grauTeor,grauAmargor,grauCor,0).

/* Teor Alcoolico */
teorAlcoolico(c1,5.5).
teorAlcoolico(c2,4.0).
teorAlcoolico(c3,6.0).
teorAlcoolico(c4,3.5).
teorAlcoolico(c5,6.0).
teorAlcoolico(c6,3.6).
teorAlcoolico(c7,4.2).
teorAlcoolico(c8,3.8).

/* Amargor da Cerveja (IBU) (0-120) */
amargorCerveja(c1,90).
amargorCerveja(c2,60).
amargorCerveja(c3,30).
amargorCerveja(c4,45).
amargorCerveja(c5,14).
amargorCerveja(c6,21).
amargorCerveja(c7,30).
amargorCerveja(c8,25).

/* Escala de Cor da Cerveja (0-15) */

corCerveja(c1,5).
corCerveja(c2,2).
corCerveja(c3,8).
corCerveja(c4,3).
corCerveja(c5,11).
corCerveja(c6,8).
corCerveja(c7,7).
corCerveja(c8,9).

/* Perguntas */

pergunta(p1,'Qual o teor alcoolico?').
pergunta(p2,'Qual o amargor da cerveja?').
pergunta(p3,'Qual a cor?').

resposta(0,0,0).

/* Gerar Graus */

gerarTeor([]).
gerarTeor([H|T]) :-
	cerveja(H,Cerveja,_,GA,GC,P),
	teorAlcoolico(H,X),
	Y is 7-X,
	Y1 is 1/Y,
	((Y1=<0.3) -> R=baixo;
		(Y1=<0.6) -> R=moderado;
		(Y1=<1) -> R=alto),
	asserta(cerveja(H,Cerveja,R,GA,GC,P)),
	gerarTeor(T).

gerarAmargor([]).
gerarAmargor([H|T]) :-
	cerveja(H,Cerveja,GT,_,GC,P),
	amargorCerveja(H,X),
	Y is 121-X,
	Y1 is 1/Y,
	((Y1=<0.3) -> R=baixo;
		(Y1=<0.6) -> R=moderado;
		(Y1=<1) -> R=alto),
	asserta(cerveja(H,Cerveja,GT,R,GC,P)),
	gerarAmargor(T).

gerarCor([]).
gerarCor([H|T]) :-
	cerveja(H,Cerveja,GT,GA,_,P),
	corCerveja(H,X),
	Y is 16-X,
	Y1 is 1/Y,
	((Y1=<0.3) -> R=baixo;
		(Y1=<0.6) -> R=moderado;
		(Y1=<1) -> R=alto),
	asserta(cerveja(H,Cerveja,GT,GA,R,P)),
	gerarCor(T).

/* ------ DEFUZZYFICAÇÃO ------ */
/* Função auxiliar de calcular */

pegarValor(X,Resposta,Valor) :-
	((Resposta==baixo),(X==baixo) -> Valor is 100.0/3;
		(Resposta==alto),(X==alto) -> Valor is 100.0/3;
		((Resposta==baixo);(Resposta==alto)),(X==moderado) -> Valor is 66.66/3;
		(Resposta==baixo),(X==alto) -> Valor is 25.0/3;
		(Resposta==alto),(X==baixo) -> Valor is 25.0/3;
		(Resposta==moderado),(X==moderado) -> Valor is 100.0/3;
		(Resposta==moderado) -> Valor is 55.0/3).

/* Calcula o valor da porcentagem final */
calcular(Pergunta,Resposta,[]).
calcular(Pergunta,Resposta,[H|T]) :-
	cerveja(H,Cerveja,GT,GA,GC,P),
	((Pergunta==p1) -> pegarValor(GT,Resposta,Valor), asserta(cerveja(H,Cerveja,GT,GA,GC,Valor));
		(Pergunta==p2) -> pegarValor(GA,Resposta,Valor),Y1 is P+Valor,asserta(cerveja(H,Cerveja,GT,GA,GC,Y1));
		(Pergunta==p3) -> pegarValor(GC,Resposta,Valor),Y1 is P+Valor,asserta(cerveja(H,Cerveja,GT,GA,GC,Y1))),
	calcular(Pergunta,Resposta,T).
/* ------ FIM DEFUZZYFICAÇÃO ------ */

/* Maior valor de uma lista */
max([X],M):-
	cerveja(X,_,_,_,_,M).
max([H|T],M) :-
	cerveja(H,_,_,_,_,K),
	max(T,N),
	(K>N -> M=K; M=N).

/*Limpar*/
limpar :- cerveja(H,A,B,C,D,_),asserta(cerveja(H,A,B,C,D,0)),fail.
limpar.

/* Fazer as perguntas */

perguntar(p3) :-
	pergunta(p3,Pergunta), 
	new(Questionario,dialog('Assistente Cervejeiro')),
	new(L1,label(text,'Responda a seguinte pergunta:')),
	new(L2,label(text,Pergunta)),

	new(B1,button(dourado,and(message(Questionario,return,baixo)))),
	new(B2,button(cobre,and(message(Questionario,return,moderado)))),
	new(B3,button(marrom,and(message(Questionario,return,alto)))),

	send(Questionario,append(L1)),
	send(Questionario,append(L2)),
	send(Questionario,append(B1)),
	send(Questionario,append(B2)),
	send(Questionario,append(B3)),

	send(Questionario,default_button,dourado),
	send(Questionario,open_centered),get(Questionario,confirm,Resposta),
	send(Questionario,destroy),
	calcular(p3,Resposta,[c1,c2,c3,c4,c5,c6,c7,c8]).
	
perguntar([]).
perguntar([H|T]) :- 
	pergunta(H,Pergunta), 
	new(Questionario,dialog('Assistente Cervejeiro')),
	new(L1,label(text,'Responda a seguinte pergunta:')),
	new(L2,label(text,Pergunta)),

	new(B1,button(baixo,and(message(Questionario,return,baixo)))),
	new(B2,button(moderado,and(message(Questionario,return,moderado)))),
	new(B3,button(alto,and(message(Questionario,return,alto)))),

	send(Questionario,append(L1)),
	send(Questionario,append(L2)),
	send(Questionario,append(B1)),
	send(Questionario,append(B2)),
	send(Questionario,append(B3)),

	send(Questionario,default_button,baixo),
	send(Questionario,open_centered),get(Questionario,confirm,Resposta),
	send(Questionario,destroy),
	calcular(H,Resposta,[c1,c2,c3,c4,c5,c6,c7,c8]),
	perguntar(T).

/* Gerar todos os graus */

gerador :-
	gerarTeor([c1,c2,c3,c4,c5,c6,c7,c8]),
	gerarAmargor([c1,c2,c3,c4,c5,c6,c7,c8]),
	gerarCor([c1,c2,c3,c4,c5,c6,c7,c8]).

/* Respostas */
respostas :-
	new(D,dialog('Assistente Cervejeiro')),
	max([c1,c2,c3,c4,c5,c6,c7,c8],M),
	cerveja(_,Resposta,_,_,_,M),

	new(L1,label(text,'A cerveja ideal para você é:')),
	new(L2,label(text,Resposta)),
	new(L3,label(text,M)),
	send(D,append(L1)),
	send(D,append(L2)),
	send(D,append(L3)),
	send(D,open_centered),
	limpar,
	asserta(resposta(0,0,0)).

/* Verificar Idade e Afins */

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
	gerador,
	verificar(Idade,Menu),
	perguntar([p1,p2]),
	perguntar(p3),
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
