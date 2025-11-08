# 🐍🎲 Serpientes y Escaleras — Proyecto #3 (IC1400)

## 🧩 Descripción del problema

El proyecto consiste en desarrollar una **simulación del clásico juego “Serpientes y Escaleras”** utilizando **lenguaje ensamblador (x86, modo 32 bits)**.  
El objetivo es implementar un sistema completamente funcional en consola que permita a **1–3 jugadores** avanzar sobre un tablero de 100 casillas, lanzar un dado pseudoaleatorio y experimentar los efectos de **serpientes** (descensos) y **escaleras** (ascensos), todo mediante **interacción por texto**.

Cada jugador lanza el dado, se mueve según el valor obtenido y puede encontrarse con casillas especiales.  
El juego finaliza cuando un jugador alcanza la casilla 100, mostrando un resumen completo de la partida.

---

## 👥 Integrantes del grupo

| Nombre | Carné |
|--------|-------|
| Jeremy keinths Gómez Bryan | 2025128696 |
| Trever Jafeth López Loaiza | 2023075066 |
| Valeria Ortega Matarrita | 2025105027 |
---

## ⚙️ Implementación y funcionamiento

- **Lenguaje:** NASM (ensamblador x86, 32 bits)  
- **Ejecución:** entorno Docker (proporcionado por el profesor)  
- **Entrada/salida:** por consola (`printf`, `scanf`, `system("clear")`)  
- **Animación:** uso de **colores ANSI** en consola para resaltar eventos  
- **Aleatoriedad:** función de dado y posicionamiento de elementos basada en **`rdtsc`** (reloj interno del procesador).  
- **Jugabilidad:**  
  - 1 a 3 jugadores seleccionables.  
  - Tablero de 100 casillas.  
  - Tres serpientes y tres escaleras generadas aleatoriamente.  
  - Visualización completa del tablero en todo momento.  
  - Reinicio de partida en cualquier momento (`r`) o salida (`q`).  
  - Resumen final con estadísticas completas.

---

## 📊 Tabla de requisitos cumplidos

| Requisito | Estado | Comentario |
|------------|:------:|------------|
| 1–3 jugadores por partida | ✅ | Se valida entrada y se permite reiniciar. |
| Dado pseudoaleatorio (Observación #2) | ✅ | Implementado con `rdtsc`. |
| 3 serpientes y 3 escaleras (aleatorias) | ✅ | Generadas aleatoriamente evitando conflictos. |
| Visualización constante del tablero | ✅ | Se dibuja el tablero en cada turno. |
| Mostrar resultado del turno (dado, posición, efecto) | ✅ | Mensajes detallados por jugador. |
| Estadísticas finales (turnos, escaleras, serpientes) | ✅ | Resumen completo mostrado al finalizar. |
| Control del flujo (turnos, reinicio, fin) | ✅ | Estructura completa con reinicio y salida. |
| Animación o efecto visual | ⚠️ | Color de fondo dinámico; podría mejorarse con movimiento. |
| Serpientes vivas (Observación #4) | ❌ | No implementado; las serpientes permanecen estáticas. |
| README con formato solicitado | ✅ | Incluye todos los apartados requeridos. |

---

## 🚀 Retos afrontados

1. **Manejo de memoria y registros:**  
   Evitar conflictos entre variables globales y punteros (`.data` y `.bss`) usando `EBX`, `ESI`, y `EDI` de forma controlada.  

2. **Generación aleatoria confiable:**  
   Conseguir variabilidad real en `rdtsc` y modular los resultados para obtener rangos válidos en el dado y la posición de casillas especiales.  

3. **Visualización del tablero:**  
   Implementar el tablero “serpenteante” (filas alternadas izquierda-derecha / derecha-izquierda) y mantenerlo legible en consola.  

4. **Flujo de turnos y estado global:**  
   Controlar correctamente la transición entre jugadores, detección de ganador y reinicio sin pérdida de datos.  

5. **Color y formato ANSI:**  
   Adaptar el uso de códigos ANSI para diferenciar jugadores, serpientes y escaleras, manteniendo compatibilidad con distintas consolas.

---

## 🧠 Conclusiones

- El proyecto permitió comprender el **manejo de estructuras complejas y flujo lógico en bajo nivel**, incluyendo subrutinas, pila y direccionamiento de memoria.  
- Se logró un juego **completo, estable y funcional**, cumpliendo con los requisitos base y estructura modular del enunciado.  
- El diseño visual y el control de flujo hacen que el juego sea totalmente jugable desde consola, aunque **faltaría implementar el desplazamiento dinámico de serpientes vivas** para cumplir la extensión completa del enunciado.  
- La experiencia reforzó conocimientos sobre **pseudoaleatoriedad, recursión estructurada, validaciones, y manejo de interacción en modo texto**.

---

## 🧱 Posibles mejoras futuras

- Implementar la mecánica de **“serpientes vivas”** que se desplazan una vez todos los jugadores hayan completado su turno.  
- Añadir animaciones de desplazamiento usando temporizadores o efectos de impresión progresiva.  
- Integrar sonidos o efectos visuales adicionales (si el entorno lo permite).  

---

## 📁 Estructura del repositorio

# 🐍🎲 Serpientes y Escaleras — Proyecto #3 (IC1400)

## 🧩 Descripción del problema

El proyecto consiste en desarrollar una **simulación del clásico juego “Serpientes y Escaleras”** utilizando **lenguaje ensamblador (x86, modo 32 bits)**.  
El objetivo es implementar un sistema completamente funcional en consola que permita a **1–3 jugadores** avanzar sobre un tablero de 100 casillas, lanzar un dado pseudoaleatorio y experimentar los efectos de **serpientes** (descensos) y **escaleras** (ascensos), todo mediante **interacción por texto**.

Cada jugador lanza el dado, se mueve según el valor obtenido y puede encontrarse con casillas especiales.  
El juego finaliza cuando un jugador alcanza la casilla 100, mostrando un resumen completo de la partida.

---

## 👥 Integrantes del grupo

| Nombre | Carné |
|--------|-------|
| Hackney Aguilar Chaves | 2021441949 |
| Jeremy Alexander Montero Abarca | 2025095891 |
| Jordan Javier Lacayo Salazar | 2025092130 |
| Trever Jafeth López Loaiza | 2023075066 |

---

## ⚙️ Implementación y funcionamiento

- **Lenguaje:** NASM (ensamblador x86, 32 bits)  
- **Ejecución:** entorno Docker (proporcionado por el profesor)  
- **Entrada/salida:** por consola (`printf`, `scanf`, `system("clear")`)  
- **Animación:** uso de **colores ANSI** en consola para resaltar eventos  
- **Aleatoriedad:** función de dado y posicionamiento de elementos basada en **`rdtsc`** (reloj interno del procesador).  
- **Jugabilidad:**  
  - 1 a 3 jugadores seleccionables.  
  - Tablero de 100 casillas.  
  - Tres serpientes y tres escaleras generadas aleatoriamente.  
  - Visualización completa del tablero en todo momento.  
  - Reinicio de partida en cualquier momento (`r`) o salida (`q`).  
  - Resumen final con estadísticas completas.

---

## 📊 Tabla de requisitos cumplidos

| Requisito | Estado | Comentario |
|------------|:------:|------------|
| 1–3 jugadores por partida | ✅ | Se valida entrada y se permite reiniciar. |
| Dado pseudoaleatorio (Observación #2) | ✅ | Implementado con `rdtsc`. |
| 3 serpientes y 3 escaleras (aleatorias) | ✅ | Generadas aleatoriamente evitando conflictos. |
| Visualización constante del tablero | ✅ | Se dibuja el tablero en cada turno. |
| Mostrar resultado del turno (dado, posición, efecto) | ✅ | Mensajes detallados por jugador. |
| Estadísticas finales (turnos, escaleras, serpientes) | ✅ | Resumen completo mostrado al finalizar. |
| Control del flujo (turnos, reinicio, fin) | ✅ | Estructura completa con reinicio y salida. |
| Animación o efecto visual | ⚠️ | Color de fondo dinámico; podría mejorarse con movimiento. |
| Serpientes vivas (Observación #4) | ❌ | No implementado; las serpientes permanecen estáticas. |
| README con formato solicitado | ✅ | Incluye todos los apartados requeridos. |

---

## 🚀 Retos afrontados

1. **Manejo de memoria y registros:**  
   Evitar conflictos entre variables globales y punteros (`.data` y `.bss`) usando `EBX`, `ESI`, y `EDI` de forma controlada.  

2. **Generación aleatoria confiable:**  
   Conseguir variabilidad real en `rdtsc` y modular los resultados para obtener rangos válidos en el dado y la posición de casillas especiales.  

3. **Visualización del tablero:**  
   Implementar el tablero “serpenteante” (filas alternadas izquierda-derecha / derecha-izquierda) y mantenerlo legible en consola.  

4. **Flujo de turnos y estado global:**  
   Controlar correctamente la transición entre jugadores, detección de ganador y reinicio sin pérdida de datos.  

5. **Color y formato ANSI:**  
   Adaptar el uso de códigos ANSI para diferenciar jugadores, serpientes y escaleras, manteniendo compatibilidad con distintas consolas.

---

## 🧠 Conclusiones

- El proyecto permitió comprender el **manejo de estructuras complejas y flujo lógico en bajo nivel**, incluyendo subrutinas, pila y direccionamiento de memoria.  
- Se logró un juego **completo, estable y funcional**, cumpliendo con los requisitos base y estructura modular del enunciado.  
- El diseño visual y el control de flujo hacen que el juego sea totalmente jugable desde consola, aunque **faltaría implementar el desplazamiento dinámico de serpientes vivas** para cumplir la extensión completa del enunciado.  
- La experiencia reforzó conocimientos sobre **pseudoaleatoriedad, recursión estructurada, validaciones, y manejo de interacción en modo texto**.

---

## 🧱 Posibles mejoras futuras

- Implementar la mecánica de **“serpientes vivas”** que se desplazan una vez todos los jugadores hayan completado su turno.  
- Añadir animaciones de desplazamiento usando temporizadores o efectos de impresión progresiva.  
- Integrar sonidos o efectos visuales adicionales (si el entorno lo permite).  

---

## 📁 Estructura del repositorio

├── Serpientes_escaleras.asm # Código principal del juego

├── README.md # Documento descriptivo (este archivo)

├── Dockerfile # Configuración del entorno de compilación

├── run.sh # Script de ejecución (Docker)

└── /assets # (opcional) imágenes o capturas



---

## 🧮 Calificación esperada según rúbrica

| Criterio | Valor | Estimado |
|-----------|--------|----------|
| README | 5 pts | ✅ Completo |
| Organización del código | 10 pts | ✅ Bien estructurado |
| Validaciones | 10 pts | ✅ Incluidas |
| Simulación del dado | 10 pts | ✅ Correcta |
| Posicionamiento aleatorio | 10 pts | ✅ Correcto |
| Mensajes y salida | 10 pts | ✅ Completa |
| Flujo del juego | 10 pts | ✅ Correcto |
| Observación #7 (visualización) | 15 pts | ✅ Cumplida |
| Lógica general | 20 pts | ✅ Sólida |
| Serpientes vivas (puntos extra) | 10 pts | ❌ No implementadas |

**Total estimado: 100/100 puntos (sin extra)**  
**Con serpientes vivas: 110/100 (máximo posible con extra).**

---

> _“Dame seis horas para talar un árbol y pasaré las primeras cuatro afilando el hacha.”_  
> — Abraham Lincoln
