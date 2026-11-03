# November is Coming

**Trabajo Práctico de Paradigmas de Programación (PdeP) — UTN FRBA — Grupo 01 — 2026**

Un juego de supervivencia ambientado en la facultad en noviembre: hay que recorrer los pisos,
esquivar a los profesores y juntar los parciales antes de que sea tarde.

---

## Integrantes

- Ignacio Cuevas (Nacho)
- Belén
- Lucca Matías Navarro
- Manuel Ignacio Kadomoto Brave
- María

---

## Qué es el juego

**November is Coming** es un juego en 2D hecho con Wollok Game. El jugador empieza en el hall
de la facultad, tiene que conseguir la llave, abrir el escritorio para recuperar el parcial,
y después llegar a la escalera para pasar al siguiente piso.

El juego tiene una **pantalla de inicio animada** con la historia y los controles, dos pisos,
profesores que se mueven y disparan, obstáculos, ítems, vidas y un reinicio de piso cuando el
jugador se queda sin vidas.

---

## Cómo se ajusta a la temática

La temática del TP es **la vida en la facultad en noviembre**: parciales, finales, profesores
y esa sensación de que el tiempo no alcanza.

- **“November is Coming”** es un guiño a que noviembre trae los parciales y los finales.
- Los **profesores** son los enemigos: deambulan por el aula y disparan.
- Los **parciales** son el objetivo: hay que juntarlos para poder escapar.
- La **llave y el escritorio** representan los trámites y secretos de la facultad.
- El **café** y los **panfletos** son objetos de la vida universitaria.
- Las **escaleras** son la progresión: pasar de un piso a otro hasta salir.

La idea es que sea reconocible para cualquier estudiante: entrar al hall, esquivar profesores,
encontrar la llave, abrir el escritorio y salir por la escalera.

---

## Demo para la presentación

La presentación es **sin mostrar código**. La demo sugerida es:

1. **Pantalla de inicio**
   - Mostrar el título y la animación de los profesores caminando.
   - Pasar por la trama y los controles con **ENTER** o **clic**.
   - Llegar al menú y arrancar con **ENTER** o **clic**.

2. **Primer piso**
   - Moverse con las flechas.
   - Mostrar que los profesores se mueven y disparan.
   - Agarrar la llave y acercarse al escritorio: se abre solo y entrega el parcial.
   - Mostrar que el parcial queda contabilizado.

3. **Escalera**
   - Caminar hasta la escalera.
   - Al pisarla, cambiar de piso automáticamente.

4. **Cierre**
   - Mostrar el segundo piso y los ítems.
   - Contar que la partida se reinicia si el jugador se queda sin vidas.

> Si la demo en vivo falla, se pueden usar las capturas del inicio y del primer piso. Los
> comandos para levantarlo están en “Cómo correrlo”.

---

## Cómo se juega

- **Flechas**: mover al jugador.
- **E**: interactuar con objetos cercanos (escritorios y elementos del piso).
- **Pisar la escalera**: cambia de piso si ya están todos los parciales.
- **ENTER / ESPACIO / clic**: avanzar en la intro y arrancar la partida.

Objetivo de cada piso: juntar todos los parciales y llegar a la escalera. Si el jugador se queda
sin vidas, el piso se reinicia.

---

## Polimorfismo: lo que vamos a contar

El juego está armado para que los objetos **sepan resolver sus propias responsabilidades**.
La idea es no preguntar por el tipo de cada cosa con `if`, sino mandar el mismo mensaje y que
cada objeto responda lo suyo.

### 1. Comportamientos de los profesores

`Profesor` no sabe si persigue, camina al azar, se queda quieto o tira proyectiles.
Delega en un **comportamiento** que entiende:

- `actuar(profesor, alumno, piso)`
- `acelerar()`
- `reiniciar()`

Hay comportamientos como `Perseguir`, `CaminarRandom`, `CadaNTicks`, `LanzarProyectil` y
`quieto`. `CadaNTicks` además envuelve a otro comportamiento: es un decorador.

**Para contar:** “Si mañana queremos que un profesor camine en zigzag, creamos otro
comportamiento y se lo enchufamos al profesor. El profesor no cambia”.

En la versión actual del juego los profesores usan `CaminarRandom` para que la partida sea
estable y no se trabe. `Perseguir` y el buscador de caminos quedan como comportamiento
alternativo probado.

### 2. Reacciones de los profesores

Todos los profesores entienden los mismos mensajes:

- `recibirMachete()`
- `escuchar(posicion)`

Pero cada uno tiene una **reacción** distinta: Omar se congela, Lettuce sigue el celular,
Gallo acelera, los gallitos reaccionan de otra forma y Filipo/Fermín ignoran todo.

**Para contar:** “El profesor no tiene un `if` diciendo ‘si soy Omar, congelate’. Le manda el
mensaje a su reacción y cada reacción decide”.

### 3. Proyectiles

`Proyectil` no sabe qué efecto produce: le delega el impacto a su **tipo**.

- `tiza` → saca una vida.
- `borrador` → saca dos vidas y congela.
- `huevo` → saca una vida.

Todos entienden `impactar(alumno)`. Además, las direcciones (`norte`, `sur`, `este`, `oeste`)
entienden `siguiente(posicion)`, así el proyectil avanza sin preguntar hacia dónde va.

**Para contar:** “Si agregamos un `compas`, solo tiene que entender `impactar`; el proyectil
no cambia”.

### 4. Colecciones polimórficas

`Piso` tiene listas de profesores, proyectiles y obstáculos, y les manda el mismo mensaje a
todos:

- a los profesores: `actuar(...)`, `reiniciar()`
- a los proyectiles: `avanzar(...)`, `descartarFueraDe(...)`
- a los obstáculos: `reiniciar()`

No le importa si el obstáculo es un banco fijo, un banco móvil, un escritorio o una pared:
todos responden `reiniciar()`.

---

## Arquitectura

| Archivo | Responsabilidad |
|---|---|
| `juego.wpgm` | Configura el tablero y arranca la pantalla de inicio. |
| `november.wlk` | Controlador del juego: pisos, avance, reinicio y pantalla de inicio. |
| `pantallaInicio.wlk` | Intro animada: título, trama, controles, menú y animaciones. |
| `niveles.wlk` | Configuración de los dos pisos, ítems, obstáculos y profesores. |
| `piso.wlk` | Estado del piso, transitabilidad, interacciones y actualización. |
| `jugador.wlk` | Movimiento, colisiones, vidas, congelamiento y reinicio. |
| `profesores.wlk` | Profesor, comportamientos, reacciones y fábricas. |
| `proyectiles.wlk` | Proyectiles, tipos, direcciones y pool de visuales. |
| `buscador.wlk` | Búsqueda de caminos (comportamiento alternativo y tests). |
| `llave.wlk`, `escritorio.wlk`, `parcial.wlk` | Ítems e interacciones del piso. |
| `bancoFijo.wlk`, `bancoMovil.wlk`, `escaleras.wlk` | Obstáculos y progresión. |
| `*.wtest` | Tests de lógica, integración y gameplay. |

---

## Cómo correrlo

```bash
npm install -g wollok-ts-cli
wollok test
wollok run juego.programaPrincipal
```

El juego queda disponible en `http://localhost:3000`.

Para verificar el código:

```bash
wollok lint
```

Estado actual: **85 tests pasan** y **lint limpio**.

---

## Estado y limitaciones

- La pantalla de inicio tiene **título, trama, controles, menú y animaciones**.
- El juego tiene **dos pisos** y progresión por escalera.
- Los profesores se mueven y disparan al azar para que la demo sea estable.
- **“Cargar partida”** está mostrado en el menú como opción deshabilitada; no hay sistema de guardado.
- La música queda pendiente.
- El segundo piso es más corto que el primero; la demo principal se hace en el primero.

---

## Guion corto para la exposición (5 minutos)

1. **Nombre y juego** (30 s): “Somos el Grupo 01 y el juego se llama November is Coming”.
2. **Demo** (2 min): pantalla de inicio → primer piso → llave/escritorio/parcial → escalera.
3. **Temática** (1 min): noviembre, parciales, profesores, cafetería y la facultad.
4. **Polimorfismo** (1 min): comportamientos, reacciones y proyectiles; mismo mensaje,
   distintas respuestas.
5. **Cierre** (30 s): dos pisos, 85 tests y lo que dejaríamos para la próxima.
