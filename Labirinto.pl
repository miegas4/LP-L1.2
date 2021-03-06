/* * * * * * * * * * * * * * * * * * * * * * * * * * * 
 *   Projeto de LP - IST TagusPark                   *
 *        Resolve-Labirintos                         *
 *                                                   *
 *   Autores : Antonio Terra, nº 84702               *
 *             Miguel Viegas, nº 84747               *
 *                                                   *
 *   Docentes Responsaveis:                          *
 *             Ines Lynce                            *
 *             Luisa Coheur                          *
 *                                                   *
 *                       Grupo 3                     *  
 *                                                   *
 * * * * * * * * * * * * * * * * * * * * * * * * * * */
 

     /* * * * * * * * * * * * * * * * * * * *
      *          Codigo principal           *
      * * * * * * * * * * * * * * * * * * * */


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Um labiririnto, uma coordenada e uma lista                  *  
 *         de movimentos ja efetuados.                                 *
 * Retorna: Uma lista ordenada com os movimentos possiveis.            *
 * Descricao: A lista e' ordenada segundo a seguinte ordem:            *
 *            Cima (c), Baixo(b), Esquerda(e) e Direita(d).            *
 *            Ou seja, ha direcoes com prioridade.                     *
 *            O labirinto é uma matriz representada por uma            *
 *            lista de listas, que conteem as paredes de cada celula.  *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

    movs_possiveis(Lab, (X,Y), Movs, Movs_Poss) :- elem_matriz(Lab, (X,Y), Celula),
                                                   direcao_possivel(Celula, L_Dir_Poss),    
                                                   faz_jogada(L_Dir_Poss, (X,Y), L_Jogadas),
                                                   filtro(L_Jogadas, Movs, Movs_Poss), !.


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Duas coordenadas.                             *
 * Retorna: A distancia (=> 0) entre as coordenadas.     *
 * Descricao: A distancia e' calculada com a soma        *
 *            dos modulos da diferenca das coordenadas.  *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

    distancia((L1,C1),(L2,C2),Dist) :- Dist is abs(L1-L2) + abs(C1-C2).


/* * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Uma lista de movimentos possiveis.    *
 * Retorna: Uma lista ordenada com os mesmos     *
 *          movimentos que recebe.               *
 * * * * * * * * * * * * * * * * * * * * * * * * */

    ordena_poss([],[],_,_) :- !.
    ordena_poss(Poss, L_Out, Pos_inicial, Pos_final) :-  encontra_min(Poss, Pos_inicial, Pos_final, Elem),
                                                         remove_elem(Poss, Elem , Poss1), 
                                                         ordena_poss(Poss1, L_Out1, Pos_inicial, Pos_final),
                                                         a_pena([Elem], L_Out1, L_Out), !.



/* * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Um labirinto e as coordenadas do principio    *
 *         e o fim do mesmo.                             *
 * Retorna: A lista contendo a sequencia de jogadas,     *
 *          solucao do labirinto.                        *
 * Descricao: A solucao segue a prioridade de direcao    *
 *            da funcao 'movs_possiveis'.                *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    resolve1(Lab, Pos_inicial, Pos_final, Solucao) :- resolver1(Lab, Pos_inicial, Pos_final, Solucao, []). 
/* 
    Criou-se uma funcao auxiliar que contem um argumento a mais que guarda os movimentos efetuados.
        Inicializou-se a '[]' para ir-se guardando as jogadas.
*/
    resolver1(_, _, Pos_final, Solucao, Movs_ef) :- Movs_ef \== [],  /* Caso final */
                                                    ultimo_elem(Movs_ef, Pos_actual),
                                                    coord(Pos_actual,Pos_final), /* Se a coordenada atual for igual 'a final retorna solucao */
                                                    Solucao = Movs_ef, !.

    resolver1(Lab, (Xi,Yi), Pos_final, Solucao, Movs_ef) :- Movs_ef == [],            /* Caso inicial, jogada para a propria casa inicial. */
                                                            Mov_inicial = (i,Xi,Yi),  /*    E' realizado exatamente uma vez.               */
                                                            resolver1(Lab, (Xi,Yi), Pos_final, Solucao, [Mov_inicial]).

    resolver1(Lab, Pos_inicial, Pos_final, Solucao, Movs_ef) :- Movs_ef \== [],
                                                                ultimo_elem(Movs_ef, Pos_actual),
                                                                Pos_actual \== [],
                                                                coord(Pos_actual, Coord_actual),
                                                                movs_possiveis(Lab, Coord_actual, Movs_ef, Movs_Poss),
                                                                Movs_Poss \== [], !,
                                                                membro(Movs_Poss, Prox_Mov),    /* Se o ramo falhar, o Prox_Mov toma o valor  */
                                                                                                /*     do proximo elemento dos Movs_Poss.     */
                                                                a_pena(Movs_ef,[Prox_Mov],Aux),
                                                                resolver1(Lab, Pos_inicial, Pos_final, Solucao, Aux).



/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Um labirinto e as coordenadas do principio e o fim do mesmo.            *
 * Retorna: A lista contendo a sequencia de jogadas, solucao do labirinto.         *
 * Descricao: A solucao segue a prioridade de direcao da funcao 'ordena_poss'.     *
 *            Funcao analoga 'a funcao 'resolve1'. Ler documentacao e comentarios  *
 *            da funcao anterior em caso de duvida.                                *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

    resolve2(Lab, Pos_inicial, Pos_final, Solucao) :- resolver2(Lab, Pos_inicial, Pos_final, Solucao, []).

    resolver2(_, _, Pos_final, Solucao, Movs_ef) :- Movs_ef \== [],
                                                    ultimo_elem(Movs_ef, Pos_actual),
                                                    coord(Pos_actual,Pos_final),
                                                    Solucao = Movs_ef, !.

    resolver2(Lab, (Xi,Yi), Pos_final, Solucao, Movs_ef) :- Movs_ef == [],
                                                            Mov_inicial = (i,Xi,Yi),
                                                            resolver2(Lab, (Xi,Yi), Pos_final, Solucao, [Mov_inicial]).

    resolver2(Lab, Pos_inicial, Pos_final, Solucao, Movs_ef) :- Movs_ef \== [],
                                                                ultimo_elem(Movs_ef, Pos_actual),
                                                                Pos_actual \== [],
                                                                coord(Pos_actual, Coord_actual),
                                                                movs_possiveis(Lab, Coord_actual, Movs_ef, Movs_Poss),
                                                                Movs_Poss \== [],
                                                                ordena_poss(Movs_Poss, Movs_Poss_Ord, Pos_inicial, Pos_final), !,
                                                                /* Ordenacao que diferencia da funcao anterior */
                                                                membro(Movs_Poss_Ord, Prox_Mov),
                                                                a_pena(Movs_ef,[Prox_Mov],Aux),
                                                                resolver2(Lab, Pos_inicial, Pos_final, Solucao, Aux).






/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *          Funcoes Auxiliares - Funcionais sobre listas       *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */



/* * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Uma lista e uma constante.            *
 * Retorna: Nada                                 *
 * Descricao: So unifica se a constante estiver  *
 *            contida na lista.                  *
 * * * * * * * * * * * * * * * * * * * * * * * * */
    ha_elem([],[]).
    ha_elem([X | _ ], X).
    ha_elem([ _ | B], X) :- ha_elem(B, X), !.   
	

/* * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Uma lista.                      *
 * Retorna: O ultimo elemento da lista     *
 * * * * * * * * * * * * * * * * * * * * * */
    ultimo_elem([], []).
    ultimo_elem([X], X).
    ultimo_elem([_|B], X) :- ultimo_elem(B, X), !.


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Uma lista e um inteiro.                             *
 * Retorna: O elemeto generico da lista na posicao fornecida.  *
 * Descricao: A primeira posicao e' 1.                         *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    elem_lista([X | _ ], 1, X) :- !.
    elem_lista([ _ | B], Pos, Elem) :- Pos1 is Pos - 1,
                                       elem_lista(B, Pos1, Elem), !.

														
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Uma matriz e uma coordenada.                            *
 * Retorna: O elemeto generico da matriz na coordenada fornecida.  *
 * Descricao: A primeira posicao e' a coordenada (1,1).            *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */														
    elem_matriz(Matriz, (CoorX, CoorY), Elem_Out) :- elem_lista(Matriz, CoorX, Linha),
                                                     elem_lista(Linha, CoorY, Elem_Out), !.


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Duas listas.                                        *
 * Retorna: A primeira lista privada dos elementos da segunda. *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    filtro(L_In, [], L_Out) :- L_Out = L_In.
    filtro(L_In, [H | B], L_Out) :- remove_coor(L_In, H, Aux),
                                    filtro(Aux, B, L_Out), !.


/* * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Duas listas genericas.                    *
 * Retorna: Uma lista.                               *
 * Descricao: A lista retornada é a concatenacao das *
 *            duas listas, sendo os elementos da     *
 *            primeira lista na primeira parte da    *
 *            lista retornada.                       *
 * * * * * * * * * * * * * * * * * * * * * * * * * * */
    a_pena([],L,L). 
    a_pena([H | T], L2, [H | L3])  :-  a_pena(T, L2, L3), !.


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Uma lista e um elemento.                      *
 * Retorna: A lista anterior sem o elemento selecionado. *
 * Descricao: O elemento e' removido se pertencer 'a     *
 *            lista. Caso contrario retorna a mesma.     *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    remove_elem([X], Elem, []) :- X == Elem.
    remove_elem([X], Elem, [X]) :- X \== Elem.
    remove_elem([H | B], Elem, L_Out) :- Elem == H,
                                         remove_elem(B, Elem, L_Out), !.
    remove_elem([H | B], Elem, L_Out) :- Elem \== H,
                                         remove_elem(B, Elem, Aux), !,
                                         a_pena([H], Aux, L_Out).

/* * * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Uma lista.                              *
 * Retorna: Um elemetoda lista.                    *
 * Descricao: A funcao retorna todos os elementos  *
              por ordem crescente de posicao, cada *
              vez que e' chamada.                  *
 * * * * * * * * * * * * * * * * * * * * * * * * * */
    membro([Elem | _], Elem).
    membro([H|T], Elem) :- H \== Elem,
                           membro(T, Elem), !.






/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *        Funcoes Auxiliares - Manipulacao de movimentos       *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */



/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Uma lista de direcoes das paredes.                      *
 * Retorna: Uma lista com as direcoes dos caminhos possiveis.      *
 * Descricao: A funcao calcula o complementar da lista que recebe, *
 *            face 'a lista [c,b,e,d]                              *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    direcao_possivel([], L_Out) :- L_Out = [c,b,e,d].
    direcao_possivel([X], Out) :- remove_elem([c,b,e,d], X, Out).
    direcao_possivel([H | B], L_Out) :- B \== [],
                                        direcao_possivel(B, Aux_Out), !,
                                        remove_elem(Aux_Out, H, L_Out).


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 * Recebe: Uma lista de coordenadas e uma coordenada.        *
 * Retorna: A lista sem a coordenada selecionada.            *
 * Descricao: O elemento e' removido se pertencer 'a         *
 *            lista. Caso contrario retorna a mesma lista.   *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    remove_coor([X], Elem, []) :- coord(X, A), coord(Elem, E), A == E.
    remove_coor([X], Elem, [X]) :- coord(X, A), coord(Elem, E), A \== E.

    remove_coor([H | B], Elem, L_Out) :- coord(Elem, E),
                                         coord(H, A),
                                         E == A,
                                         remove_coor(B, Elem, L_Out), !.

    remove_coor([H | B], Elem, L_Out) :- coord(Elem, E),
                                         coord(H,A),
                                         E \== A,
                                         remove_coor(B, Elem, Aux), !,
                                         a_pena([H], Aux, L_Out).


/* * * * * * * * * * * * * * * * * * *
 * Recebe: Uma jogada.               *
 * Retorna: A coordenada da jogada.  *
 * * * * * * * * * * * * * * * * * * */
    coord((_, X, Y), Out) :- Out = (X,Y).

															
/* * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Uma direcao e uma coordenada.   *
 * Retorna: Uma jogada.                    *
 * * * * * * * * * * * * * * * * * * * * * */
    constroi_mov(D, (X,Y), Mov) :- Mov = [(D, X, Y)].


/* * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Uma lista com direcoes e uma coordenada.  *
 * Retorna: Uma lista com as jogadas na coordenada   *
 *          fornecida com as direcoes dadas.         *
 * * * * * * * * * * * * * * * * * * * * * * * * * * */
    faz_jogada(['c'], (X,Y), L_Out) :- X1 is X - 1, constroi_mov(c, (X1,Y), L_Out).
    faz_jogada(['b'], (X,Y), L_Out) :- X1 is X + 1, constroi_mov(b, (X1,Y), L_Out).
    faz_jogada(['e'], (X,Y), L_Out) :- Y1 is Y - 1, constroi_mov(e, (X,Y1), L_Out).
    faz_jogada(['d'], (X,Y), L_Out) :- Y1 is Y + 1, constroi_mov(d, (X,Y1), L_Out).
    faz_jogada([H | B], (X, Y), L_Out) :- faz_jogada(B, (X,Y), Aux),
                                          faz_jogada([H], (X,Y), Mov), !,
                                          a_pena(Mov, Aux, L_Out).


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Uma coordenada.                                 *
 * Retorna: O digito correspondente a cada uma das letras. *
 * Descricao: c = 1                                        *
 *            b = 2                                        *
 *            e = 3                                        *
 *            d = 4                                        *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    primeiro_tuple(('c', _ , _ ), Out) :- Out is 1.
    primeiro_tuple(('b', _ , _ ), Out) :- Out is 2.
    primeiro_tuple(('e', _ , _ ), Out) :- Out is 3.
    primeiro_tuple(('d', _ , _ ), Out) :- Out is 4.


/* * * * * * * * * * * * * * * *
 * Recebe: Um movimento.       *
 * Retorna: O numero da linha. *
 * * * * * * * * * * * * * * * */
    segundo_tuple((_, Y, _), Out) :- Out is Y.


/* * * * * * * * * * * * * * * * *
 * Recebe: Um movimento.         *
 * Retorna: O numero da coluna.  *
 * * * * * * * * * * * * * * * * */
    terceiro_tuple((_, _, Z), Out) :- Out is Z. 


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Dois movimentos, a posicao inicial e a posicao final. *
 * Retorna: Qual a posicao com menor distancia a' posicao final. *
 * Descricao: No caso de a distancia a' posicao final ser igual, *
 *            e' chamada a funcao 'maior'.                       *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    menor(X, Y, _, Pos_final, Out) :- segundo_tuple(X, L1), terceiro_tuple(X, C1), 
                                      segundo_tuple(Y, L2), terceiro_tuple(Y, C2),
                                      distancia( (L1,C1), Pos_final, S1),
                                      distancia( (L2, C2), Pos_final, S2),
                                      S1 < S2, Out = X.

    menor(X, Y, _, Pos_final, Out) :- segundo_tuple(X, L1), terceiro_tuple(X, C1), 
                                      segundo_tuple(Y, L2), terceiro_tuple(Y, C2),
                                      distancia( (L1,C1), Pos_final, S1),
                                      distancia( (L2, C2), Pos_final, S2),
                                      S2 < S1, Out = Y.

    menor(X, Y, Pos_inicial, Pos_final, Out) :- segundo_tuple(X, L1), terceiro_tuple(X, C1), 
                                                segundo_tuple(Y, L2), terceiro_tuple(Y, C2),
                                                distancia( (L1,C1), Pos_final, S1),
                                                distancia( (L2, C2), Pos_final, S2),
                                                S1 == S2, maior(X, Y, Pos_inicial, Out).


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Dois movimentos e a posicao inicial.                    *
 * Retorna: Qual a posicao com maior distancia a posicao inicial.  *
 * Descricao: No caso de a distancia a' posicao inical ser igual,  *
 *            e' chamada a funcao 'letras'.                        *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    maior(X, Y, Pos_inicial, Out) :- segundo_tuple(X, L1), terceiro_tuple(X, C1), 
                                     segundo_tuple(Y, L2), terceiro_tuple(Y, C2),
                                     distancia( (L1,C1), Pos_inicial, S1),
                                     distancia( (L2, C2), Pos_inicial, S2),
                                     S1 > S2, Out = X.

    maior(X, Y, Pos_inicial, Out) :- segundo_tuple(X, L1), terceiro_tuple(X, C1), 
                                     segundo_tuple(Y, L2), terceiro_tuple(Y, C2),
                                     distancia( (L1,C1), Pos_inicial, S1),
                                     distancia( (L2, C2), Pos_inicial, S2),
                                     S2 > S1, Out = Y.

    maior(X, Y, Pos_inicial, Out) :- segundo_tuple(X, L1), terceiro_tuple(X, C1), 
                                     segundo_tuple(Y, L2), terceiro_tuple(Y, C2),
                                     distancia( (L1,C1), Pos_inicial, S1),
                                     distancia( (L2, C2), Pos_inicial, S2),
                                     S1 == S2, letras(X, Y, Out).


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Dois movimentos.                                        *
 * Retorna: Qual o movimento com a letra com maior prioridade.     *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    letras(X, Y, Out) :- (primeiro_tuple(X, L1), primeiro_tuple(Y, L2), L1 < L2, Out = X ); 
                                 (primeiro_tuple(X, L1), primeiro_tuple(Y, L2), L2 < L1, Out = Y ).



/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Recebe: Lista de movimentos, a posicao inicial e a posicao final. *
 * Retorna: Qual a posicao com maior prioridade.                     *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    encontra_min([H | B], Pos_inicial, Pos_final, Out) :- encontra_min(B, H, Pos_inicial, Pos_final, Out).
    encontra_min([C | T], Aux, Pos_inicial, Pos_final, Out) :- menor(C, Aux, Pos_inicial, Pos_final, Aux1),
                                                               encontra_min(T, Aux1, Pos_inicial, Pos_final, Out), !.
    encontra_min([], Aux, _, _, Out) :- Out = Aux .





































/* Made in Azores*/
