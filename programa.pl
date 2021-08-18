canta(megurineLuka, cancion(nightFever, 4)).
canta(megurineLuka, cancion(foreverYoung , 5)).
canta(hatsuneMiku , cancion(tellYourWorld , 4)).
canta(gumi, cancion(foreverYoung , 4)).
canta(gumi, cancion(tellYourWorld , 5)).
canta(seeU, cancion(novemberRain , 6)).
canta(seeU, cancion(nightFever , 5)).
canta(megurineLuka, cancion(nightFever, 4)).

%%% PUNTO 1 %%% 

esNovedoso(Vocaloid):-
    sabeAlMenosDosCanciones(Vocaloid),
    tiempoTotalQueTardaEnCantar(Vocaloid, Minutos),
    Minutos < 15.

sabeAlMenosDosCanciones(Vocaloid):-
    canta(Vocaloid, cancion(Cancion, _)),
    canta(Vocaloid, cancion(OtraCancion, _)),
    Cancion \= OtraCancion.

tiempoTotalQueTardaEnCantar(Vocaloid, TiempoTotal):-
    findall(TiempoDeUnaCancion, tiempoDeUnaCancion(Vocaloid, TiempoDeUnaCancion), Tiempos),
    sum_list(Tiempos, TiempoTotal).

tiempoDeUnaCancion(Vocaloid, TiempoDeUnaCancion):-
    canta(Vocaloid, cancion(_, TiempoDeUnaCancion)). 

%%% PUNTO 2 %%% 

cantante(Vocaloid):-
    canta(Vocaloid, _).

esAcelerado(Vocaloid):-
    cantante(Vocaloid),
    not(cantaCancionesLargas(Vocaloid)).

cantaCancionesLargas(Vocaloid):-
    canta(Vocaloid, cancion(_, Tiempo)),
    Tiempo > 4. 
    
/* ”No canta una canción que dure más de 4 minutos” (not/1) es lo mismo que 
“Todas sus canciones duran 4 o menos minutos” (forall/2). */

%%%%%%%%%%% CONCIERTOS %%%%%%%%%%

%%% PUNTO 1 %%%
%concierto(Nombre, Pais, CantidadDeFama, Tipo).

concierto(mikuExpo, eeuu, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocalektVisions, eeuu, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, chico(4)).

%%% PUNTO 2 %%% 

puedeParticipar(hatsuneMiku, Concierto):-
	concierto(Concierto, _, _, _).

puedeParticipar(Vocaloid, Concierto):-
    cantante(Vocaloid),
    concierto(Concierto, _, _, Requisitos),
    cumpleRequisito(Vocaloid, Requisitos).

cumpleRequisito(Vocaloid, gigante(CantCancionesMinima, DuracionTotalCancionesMinima)):-
    cantidadDeCanciones(Vocaloid, CantCanciones),
    CantCanciones >= CantCancionesMinima,
    tiempoTotalQueTardaEnCantar(Vocaloid, TiempoTotal),
    TiempoTotal > DuracionTotalCancionesMinima.

cumpleRequisito(Vocaloid, mediano(DuracionTotalCancionesMaxima)):-
    tiempoTotalQueTardaEnCantar(Vocaloid, TiempoTotal),
    TiempoTotal < DuracionTotalCancionesMaxima.

cumpleRequisito(Vocaloid, chico(TiempoMinimoDeUnaCancion)):-
    canta(Vocaloid, cancion(_, TiempoCancion)),
    TiempoCancion > TiempoMinimoDeUnaCancion.

cantidadDeCanciones(Vocaloid, CantCanciones):-
    findall(Cancion, canta(Vocaloid, Cancion), Canciones),
    length(Canciones, CantCanciones).

%%% PUNTO 3 %%% 

 masFamoso(Vocaloid):-
    nivelDeFama(Vocaloid, NivelMasFamoso),
    forall(nivelDeFama(_, Nivel), tieneMasNivel(NivelMasFamoso, Nivel)).

tieneMasNivel(NivelMasFamoso, Nivel):-
    NivelMasFamoso >= Nivel.

nivelDeFama(Vocaloid, NivelDeFama):-
    famaDeCantante(Vocaloid, Cantidad),
    cantidadDeCanciones(Vocaloid, CantCanciones),
    NivelDeFama is Cantidad * CantCanciones.

famaDeCantante(Vocaloid, Cantidad):-
    cantante(Vocaloid),
    findall(Fama, famaDeConcierto(Vocaloid, Fama), Famas),
    sum_list(Famas, Cantidad).

famaDeConcierto(Vocaloid, Fama):-
    puedeParticipar(Vocaloid, Concierto),
    concierto(Concierto, _, Fama, _). 

%%% PUNTO 4 %%%

/* Queremos verificar si un vocaloid es el único que participa de un concierto, esto se cumple si ninguno de sus conocidos ya sea directo o indirectos 
(en cualquiera de los niveles) participa en el mismo concierto. */ 

% conoce(Conocedor, Conocido).
conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

unicoQueParticipa(Vocaloid, Concierto):-
    puedeParticipar(Vocaloid, Concierto),
    not(puedeParticiparConocido(Vocaloid, Concierto)).

puedeParticiparConocido(Vocaloid, Concierto):-
    conocidoDe(Vocaloid, OtroVocaloid),
    puedeParticipar(OtroVocaloid, Concierto).

conocidoDe(Vocaloid, OtroVocaloid):-
    conoce(Vocaloid, OtroVocaloid).
conocidoDe(Vocaloid, OtroVocaloid):-
    conoce(Vocaloid, Intermedio),
    conocidoDe(Intermedio, OtroVocaloid).

%%% PUNTO 5 %%% 

/* En la solución planteada habría que agregar una claúsula en el predicado cumpleRequisitos/2  que tenga en cuenta el nuevo functor con sus respectivos requisitos 
El concepto que facilita los cambios para el nuevo requerimiento es el polimorfismo, que nos permite dar un tratamiento en particular a cada uno de los conciertos en 
la cabeza de la cláusula. */ 

    