# Software Requirements Specification

# Prode Mania 

## Introducion
 
ProdeMania es un juego de pronóstico de resultados de fútbol. El juego consiste en predecir los resultados de cada partido jugado en una determinada fecha en un torneo particular, buscando acertar la mayor cantidad de resultados posibles, y así, sumar "puntos".

Para cada partido, los jugadores podrán predecir tanto el ganador del partido (local, visitante, empate) como también la cantidad de goles marcados por cada equipo.  

La metodología del juego es la siguiente:  
1) Si el jugador acierta el resultado, se le otorgará 1 punto; 
2) Si acierta el resultado del partido, entonces sumará puntos por los goles acertados de la siguiente manera:
    - 1 punto por gol acertado del local.
    - 1 punto por gol acertado del visitante.


Los dueños de prodemania necesitan un sistema que los ayude a informatizar el juego, considerando que la elección del equipo ganador debe ser consistente con la cantidad de goles que se predice para cada equipo, i.e  si se elige como ganador el equipo local, se espera que la cantidad de goles predecidos para el equipo local sea mayor a la cantidad de goles predecidos para el equipo visitante, y viceversa. Además en los empates, se espera que la cantidad de goles predecidos para el equipo local sea igual a la cantidad de goles predecidos para el visitante.
A considerar también que en  distintos torneos, o , en distintas etapas del mismo pueden existir dos tipos de partidos: 
- Partido de liga o grupo: Partido de 90 minutos en los que se pueden dar los tres resultados (local, visitante, empate) i.e No hay penales.

- Partido de eliminación directa(ej: llave de octavos, cuartos, semifinal, final): Partido en los que no puede haber empate, los partidos si o si se definen en tiempo regular(primeros 90 minutos), tiempo suplementario(30 minutos adicionales al tiempo regular) o penales. En estos tipos de partidos se podrá dar el caso que para una predicción se elija como ganador a un equipo pero los goles marcados por cada equipo sean iguales; esto querrá decir que el equipo que seleccionó como ganador, gana por penales.

Cada torneo tendrá su propia tabla de puntos, donde se visualizarán los jugadores que hicieron predicciones a partidos de ese torneo y la cantidad de puntos obtenidos por los mismos. Podrán visualizarse los puntos obtenidos por fecha o la tabla general con los puntos obtenidos hasta la fecha jugada en el momento. 

Los jugadores seleccionan los torneos en los cuales quieren participar y hacer predicciones a partidos de esos torneos. Podrán predecir resultados de partidos de la fecha próxima a jugarse en ese momento, pudiendo cargar sus predicciones hasta 1 hora antes de cada partido. Solo tras finalizar todos los partidos de la fecha, el jugador podrá hacer predicciones de la fecha siguiente.
Los jugadores podrán acceder a visualizar la tabla de puntos obtenidos por cada torneo, como también podrán ver sus propias predicciones hechas a lo largo del tiempo, y cuál fue el resultado de su predicción.

Existirá un usuario administrador, que será el encargado de cargar los torneos, los equipos, los partidos de cada fecha y los resultados de los mismos.

## Requerimientos

### Requerimientos Funcionales

Usuario Jugador(Actor):
- Registrarse como jugador(nombre de usuario, contraseña, email)

- Iniciar sesión(nombre de usuario, contraseña)

- Cerrar sesión

- Modificar el perfil(nombre de usuario, contraseña , email)

- Recuperar contraseña(email)

- Visualizar la tabla de puntos de cada torneo en los que es participe.

- Visualizar las predicciones hechas a un torneo en particular

- Cargar predicciones

- Modificar predicciones 

- Eliminar predicciones


Usuario Administrador(Actor):
- Registrar a otros usuarios como administrador(nombre de usuario, contraseña, email)

- Iniciar sesión(nombre de usuario, contraseña)

- Cerrar sesión

- Recuperar contraseña(email)

- Cargar torneo(nombre)

- Cargar equipo(nombre, torneo)

- Cargar partido(equipo local, equipo visitante, fecha, hora)

- Cargar resultado(resultado, goles local, goles visitante)

- Visualizar la tabla de puntos de cada torneo

- Visualizar las predicciones hechas a lo largo del tiempo

- Visualizar las predicciones hechas a un torneo en particular

- Visualizar los resultados cargados

- Al cargar un resultado se deben recalcular los puntos para los jugadores que hicieron predicciones.
### Requerimientos No Funcionales

- No se puede registrar un usuario con el mismo nombre de usuario o email que otro usuario ya registrado

- Un usuario no puede cambiar su nombre de usuario a uno que ya exista

- La contraseña no se guarda en texto plano


## Diagrama UML
        Aclaración
        Punto, es una clase asociación entre Jugador y Torneo, 
        su atributo cantPunto es el conteo de puntos totales que un jugador acumula en un determinado torneo.

[![](https://mermaid.ink/img/pako:eNqdVNtKw0AQ_ZWwj0WLvoYiBFrbQmtLbREhL0N2tMEkGzYbJGj-3b1lt41Ri3may9lzZmYn-0ESRpGEJMmgqqYpvHLI4yKQ36FCHkw-r6-DiOZp0Q9uM2iQ6-hJKgwKyPEsgDmk2VmklFLvjFN32GQNYxCT2_H4NiaBFInJzXg8kvY945hAJQyy8wx21GHtuTWI5GiA2hxGTUGgFTbmEGjPaq4aKsSffHuEXPYG79AEl4KPLMeB5k_Ro4Eqfm-_j9ZaF_EOXoDFblnqYMq8TDu2a6O3y9X9YYLq41jVmZCj2O-05TNqNnMGWeVDara9UKlqsX7babqVNLL6Hr5p_luSQnN6pObeE02JkvdkAVufdLWZqqy6r2sywaLOkYNIWXF35-KLzXrmnOgpenbOdBc92Qm33aQ79l7TP5HPd5vDdrWcH7zEbLVcLx-i_XLzsF1Ej7OeguFXv4xnp1glPC0V9wBWLaDHuvehB3KbMww9H55eQQ8UTEDmN1Qz2yS5IrJt-QRR-cjpEzERR5TEJJQmBf4Wk7hoJa4uqexqRlPBOAlf5KXjFYFasMemSEgoeI0dyD6UFtV-AWTigXQ)](https://mermaid-js.github.io/mermaid-live-editor/edit#pako:eNqdVNtKw0AQ_ZWwj0WLvoYiBFrbQmtLbREhL0N2tMEkGzYbJGj-3b1lt41Ri3may9lzZmYn-0ESRpGEJMmgqqYpvHLI4yKQ36FCHkw-r6-DiOZp0Q9uM2iQ6-hJKgwKyPEsgDmk2VmklFLvjFN32GQNYxCT2_H4NiaBFInJzXg8kvY945hAJQyy8wx21GHtuTWI5GiA2hxGTUGgFTbmEGjPaq4aKsSffHuEXPYG79AEl4KPLMeB5k_Ro4Eqfm-_j9ZaF_EOXoDFblnqYMq8TDu2a6O3y9X9YYLq41jVmZCj2O-05TNqNnMGWeVDara9UKlqsX7babqVNLL6Hr5p_luSQnN6pObeE02JkvdkAVufdLWZqqy6r2sywaLOkYNIWXF35-KLzXrmnOgpenbOdBc92Qm33aQ79l7TP5HPd5vDdrWcH7zEbLVcLx-i_XLzsF1Ej7OeguFXv4xnp1glPC0V9wBWLaDHuvehB3KbMww9H55eQQ8UTEDmN1Qz2yS5IrJt-QRR-cjpEzERR5TEJJQmBf4Wk7hoJa4uqexqRlPBOAlf5KXjFYFasMemSEgoeI0dyD6UFtV-AWTigXQ)