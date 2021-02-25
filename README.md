
--método hiding vs método overriding
https://www.youtube.com/watch?v=lG4ntSkKuh4
https://www.youtube.com/watch?v=yooCE5B0SRA&list=PLLEUtp5eGr7Dz3fWGUpiSiG3d_WgJe-KJ&index=10
https://www.youtube.com/watch?v=-rw8iIsAF5I
https://www.youtube.com/watch?v=oYXivKMSEqM - pfta



2. É possivel sobrescrever método estático? 
Não, por que sobrescrita de método é feito em runtime com o dynamic binding. Static métodé 
feito em tempo de compilação usando static binding. Porém é possivel ter um efeito similar declarando um método com mesmo nome e assinatura
na sublass, mas isso é chamado método hiding.

3. Método hiding e método overriding;
hiding -> quando uma subclasse define um método com mesma assinatura e nome de um método da superclasse. A versão do método é determinada pelo
tipo da variável. overriding -> quando uma sublasse define um método com mesma assinatura e nome de um método da superclasse, mas a versão do 
método escolhida é determinada pelo objeto que está invocando ela. 

4. Podemos acessar métodos privados?
Sim, podemos acessar eles na mesma classe. 

5. Como usar final keyword? 
Pode ser usada em diferentes contextos, para tornar final uma variável, método ou classe. Quando usamos final com uma variável, o valor dela não pode
ser mudado uma vez que atribuido. Com método, ele não pode ser sobrescrito por uma classe herdeira. E a classe, ela não pode ser extendida, não
pode ser uma superclasse. 

6. Diferença entre checked exception e unchecked exception.
Checked exception são checadas em tempo de compilação. Então tipo, se um método pode lançar ela exception, ele deve tratar ela com um try cacth,
por exemplo, ou especificar que lança essa exception usando o throws. Ex: SQL Exception.
Unchecked exception não são checadas em tempo de compilação. Tipo divisão por 0, NullPointerException, ArrayIndexOutOfBound, IllegalArgument.

7. Diferença entre abstract class vs interface.

8. Quando usar abstract class e quando usar interface? 

9. Method overloading vs overriding.

10. Encapsulamento vs Abstração

11. Object Cloning. 

12. HashSet vs HashMap. 

13. Quando usar Trasient Variable. 

14. Quando usar ArrayList e quando usar LinkedList?

15. StringBuffer vs StringBuilder

16. User Defined Exception.

17. Tipos de exceção e como resolver

18. Java 8 features

19. Pq precisamos de generics.

20. Baixo acoplamento vs alto acoplamento. 

21. BufferedReader vs Scanner

22. Conceitos de Collections com real time

23. OOP em real time

24. Sigleton class em java

25. Heap vs Stack

26. Arquitetura de projeto

