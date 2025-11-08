# 🐍 Serpientes y Escaleras - Proyecto 3 (IC1400)

## Descripción del problema

El trabajo consiste en crear una versión del juego Serpientes y Escaleras usando lenguaje ensamblador (x86, 32 bits).
La idea fue desarrollar un programa que funcione por consola, donde uno o varios jugadores puedan lanzar un dado, moverse en un tablero de 100 casillas y encontrarse con serpientes y escaleras que cambian su posición.
El juego termina cuando alguno de los jugadores llega a la casilla 100, y al final se muestra un resumen con los resultados.

Cada jugador lanza el dado, se mueve según el valor obtenido y puede encontrarse con casillas especiales.  
El juego finaliza cuando un jugador alcanza la casilla 100, mostrando un resumen completo de la partida.

---

## Integrantes del grupo

| Nombre | Carné |
|--------|-------|
| Jeremy keinths Gómez Bryan | 2025128696 |
| Trever Jafeth López Loaiza | 2023075066 |
| Valeria Ortega Matarrita | 2025105027 |
---

## Retos afrontados
Uno de los principales retos fue el manejo de los registros y la memoria, ya que se debía controlar cuidadosamente el uso de cada registro para no alterar valores importantes.
También resultó complejo implementar el tablero con un recorrido en zigzag, donde cada fila cambia de dirección.

Otro desafío fue generar números aleatorios de manera confiable. Para esto se usó la instrucción rdtsc, que toma el valor del reloj interno del procesador y permite obtener resultados diferentes en cada lanzamiento del dado.

Además, fue necesario controlar el flujo del juego, administrar los turnos de los jugadores, mostrar los resultados en consola y manejar correctamente la entrada de datos.
Por último, se añadieron colores y animaciones simples para mejorar la visualización, lo que también requirió pruebas para asegurar que el programa mantuviera un funcionamiento estable.


---

## Conclusiones
Este proyecto fue una buena oportunidad para practicar la lógica y la estructura del lenguaje ensamblador.
Aunque al principio fue complicado acostumbrarse al manejo de registros y al control del flujo del programa, con el tiempo se logró entender mejor cómo funciona el procesamiento de instrucciones a bajo nivel.

Durante el desarrollo aprendimos a usar subrutinas, a trabajar con la pila y a generar valores aleatorios con instrucciones del procesador.
También se reforzó el trabajo en equipo y la organización del código para que fuera más fácil de entender y mantener.

En general, el resultado fue un juego funcional y estable que cumple con los objetivos propuestos.
Quedaron algunas ideas pendientes, como animaciones más elaboradas o serpientes con movimiento, pero el proyecto permitió aplicar de forma práctica lo aprendido y entender mejor cómo se puede construir un programa completo en ensamblador.

---
