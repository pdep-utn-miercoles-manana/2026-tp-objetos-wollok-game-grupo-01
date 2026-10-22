# November is Coming

TP de Paradigmas de Programación (PdeP) en Wollok Game.
La idea y los acuerdos están en el [documento del equipo](https://docs.google.com/document/d/1ngXDE2ez-ztIsfwtkWnmAS3YSEobYEeRV0DU9r4TmRo/edit).

## Mi parte

Me tocaron los profesores y la inteligencia: la clase `Profesor`, los comportamientos,
las reacciones al machete y al celular, la persecución con BFS, los proyectiles y sus tests.

## Qué hice

- `profesores.wlk`: el `Profesor`, los comportamientos (`quieto`, `Perseguir`, `CadaNTicks`,
  `LanzarProyectil`) y la reacción de cada profe.
- `buscador.wlk`: el BFS que devuelve el primer paso hacia una celda.
- `proyectiles.wlk`: `Proyectil`, las direcciones, `tiza` / `borrador` / `huevo` y `Proyectiles`.
- `soporteDePruebas.wlk`: `PisoDePrueba` y `AlumnoDePrueba` para testear sin depender de los demás.
- Los `.wtest`: 32 tests.

## Cómo correrlo

```
npm install -g wollok-ts-cli
wollok test
```

## Cómo está pensado

El profesor no sabe qué hace: les pasa el trabajo a sus comportamientos y a su reacción.
Si cambia la forma de perseguir, toco un comportamiento y listo. Los proyectiles igual:
`tiza`, `borrador` y `huevo` entienden `impactar(alumno)` y cada uno hace lo suyo.
No hay ningún `if` preguntando por el tipo de nada.

## lo que propongo para ustedes

- **Lucca**: `piso.esTransitable(posicion)`, `piso.agregarProyectil(proyectil)` y
  `piso.avanzarProyectiles(alumno)`. Y que en el tick llame a `profesor.actuar(alumno, piso)`
  y mire `profesor.atrapa(alumno)`.
- **Manu**: `alumno.position()`, `alumno.recibirGolpe(cantidad)` y `alumno.congelarPor(segundos)`.

## Pendientes

- Integrar con el `Piso` real cuando esté.
- Ajustar los números (frecuencias, congelamiento) cuando esté el `game.onTick`.
