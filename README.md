# November is Coming

**Trabajo Práctico de Paradigmas de Programación (PdeP) — UTN FRBA — Grupo 01 — 2026**

Juego de supervivencia ambientado en la facultad en noviembre: hay que recorrer los pisos,
esquivar a los profesores y juntar los parciales antes de que sea tarde.

---

## Integrantes

- María Belén López
- Lucca Matías Navarro
- Manuel Ignacio Kadomoto Brave
- Ignacio Cuevas

---

## Qué es el juego

**November is Coming** es un juego en 2D hecho con Wollok Game. El jugador entra a la facultad,
recorre la planta baja y los pisos, consigue llaves, abre escritorios, junta parciales y llega
a la escalera para seguir avanzando.

El juego tiene:

- Una **pantalla de inicio animada** con la trama, los controles y el menú.
- **Cuatro niveles**: planta baja, primer piso, segundo piso y tercer piso.
- **Profesores** que se mueven y disparan.
- **Obstáculos**, bancos fijos y móviles, escritorios, llaves y parciales.
- **Vidas**, congelamiento y reinicio de piso.
- **Talonario** en planta baja, **computadora y pendrive** en el tercer piso.
- **HUD de vidas** durante la partida.

---

## Cómo se ajusta a la temática

La temática es **la vida en la facultad en noviembre**: parciales, finales, profesores y la
sensación de que el tiempo no alcanza.

- **“November is Coming”** es un guiño a que noviembre trae los parciales y los finales.
- Los **profesores** son los enemigos: deambulan por el aula y disparan.
- Los **parciales** son el objetivo: hay que juntarlos para poder escapar.
- La **llave y el escritorio** representan los trámites y secretos de la facultad.
- El **talonario** y la **computadora** son parte del recorrido burocrático.
- El **café** y los **panfletos** son objetos de la vida universitaria.
- Las **escaleras** son la progresión: pasar de un piso a otro hasta salir.

---

## Demo para la presentación

La presentación es **sin mostrar código**. La demo sugerida es:

1. **Pantalla de inicio**
   - Mostrar el título y la animación de los profesores caminando.
   - Pasar por la trama y los controles con **ENTER** o **clic**.
   - Llegar al menú y arrancar con **ENTER** o **clic**.

2. **Planta baja**
   - Mostrar el talonario: al acercarse y apretar **E** aparece la guía.
   - Cerrar la guía con **Backspace**.
   - Subir por la escalera.

3. **Primer piso**
   - Moverse con las flechas.
   - Agarrar la llave y acercarse al escritorio: se abre y entrega el parcial.
   - Llegar a la escalera y apretar **E** para cambiar de piso.

4. **Si hay tiempo**
   - Mostrar el segundo piso y el tercer piso.
   - Mostrar la computadora/pendrive y los profesores del tercer piso.
   - Contar que si el jugador se queda sin vidas, se reinicia el piso.

> Si la demo en vivo falla, se pueden usar capturas del inicio y de los pisos. Los comandos
> para levantarlo están en “Cómo correrlo”.

---

## Cómo se juega

- **Flechas**: mover al jugador.
- **E**: interactuar con escritorios, talonarios y escaleras.
- **Backspace**: cerrar la guía del talonario.
- **M**: silenciar o reactivar el audio.
- **ENTER / ESPACIO / clic**: avanzar en la intro y arrancar la partida.

Objetivo de cada piso: juntar todos los parciales y llegar a la escalera. La planta baja es la
entrada y no pide parciales. Si el jugador se queda sin vidas, el piso se reinicia.

---

## Audio

La música arranca cuando el jugador hace el primer **ENTER o clic** en la intro, así el
navegador permite reproducirla. Queda en loop durante la partida, a volumen bajo. Los archivos
están en `assets/` para que el cliente los precargue junto con las imágenes.

Efectos de sonido:

- Agarrar una llave.
- Agarrar un parcial.
- Abrir un escritorio.
- Subir por la escalera.
- Disparar.
- Recibir daño.
- Ganar la partida.

La música se detiene al ganar. La tecla **M** silencia o reactiva todo el audio. Los sonidos
están envueltos en `game.running()` para que los tests no intenten reproducir audio.

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

Hay comportamientos como `CaminarRandom`, `Perseguir`, `CadaNTicks`, `LanzarProyectil` y
`quieto`. `CadaNTicks` además envuelve a otro comportamiento: es un decorador.

**Para contar:** “Si mañana queremos que un profesor camine en zigzag, creamos otro
comportamiento y se lo enchufamos al profesor. El profesor no cambia”.

La versión actual del juego usa `CaminarRandom` para que la partida sea estable y no se trabe.
`Perseguir` y el buscador de caminos quedan como comportamiento alternativo probado.

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

### 4. Movimiento del jugador

El jugador no sabe si los controles están normales o invertidos. Delega en un objeto de
movilidad:

- `movilidadNormal` y `movilidadInvertida` entienden `arriba`, `abajo`, `izquierda` y
  `derecha`.
- Cuando un parcial invierte los controles, cambia el objeto de movilidad y listo.

**Para contar:** “El jugador sigue mandando los mismos mensajes; cambia quién los recibe”.

### 5. Colecciones polimórficas

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
| `november.wlk` | Controlador: pisos, avance, reinicio, victoria y pantalla de inicio. |
| `pantallaInicio.wlk` | Intro animada: título, trama, controles, menú y animaciones. |
| `niveles.wlk` | Configuración de los cuatro niveles, ítems, obstáculos y profesores. |
| `piso.wlk` | Estado del piso, transitabilidad, interacciones y actualización. |
| `jugador.wlk` | Movimiento, colisiones, vidas, congelamiento y reinicio. |
| `profesores.wlk` | Profesor, comportamientos, reacciones y fábricas. |
| `proyectiles.wlk` | Proyectiles, tipos, direcciones y pool de visuales. |
| `buscador.wlk` | Búsqueda de caminos (comportamiento alternativo y tests). |
| `llave.wlk`, `escritorio.wlk`, `parcial.wlk` | Ítems e interacciones. |
| `talonario.wlk`, `escritorioConComputadora.wlk`, `pendrive.wlk` | Mecánicas del recorrido. |
| `bancoFijo.wlk`, `bancoMovil.wlk`, `escaleras.wlk` | Obstáculos y progresión. |
| `indicadorVidas.wlk` | HUD de vidas. |
| `sonidos.wlk` | Música de fondo, efectos, mute y guardas para tests. |
| `assets/*.wav` | Archivos de música y efectos. |
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

Estado actual: **81 tests pasan**, **lint limpio** y **audio integrado**.

---


