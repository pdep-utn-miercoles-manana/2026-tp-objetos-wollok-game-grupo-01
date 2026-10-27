# November is Coming

TP de Paradigmas de Programación (PdeP) en Wollok Game.


## Parte de Nacho

Me tocaron los profesores y la inteligencia: la clase `Profesor`, los comportamientos,
las reacciones al machete y al celular, la persecución con BFS, los proyectiles y sus tests.

### Qué hizo

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

### Cómo está pensado

El profesor no sabe qué hace: les pasa el trabajo a sus comportamientos y a su reacción.
Si cambia la forma de perseguir, toco un comportamiento y listo. Los proyectiles igual:
`tiza`, `borrador` y `huevo` entienden `impactar(alumno)` y cada uno hace lo suyo.
No hay ningún `if` preguntando por el tipo de nada.

### Interfaces propuestas inicialmente

- **Lucca**: `piso.esTransitable(posicion)`, `piso.agregarProyectil(proyectil)` y
  `piso.avanzarProyectiles(alumno)`. Y que en el tick llame a `profesor.actuar(alumno, piso)`
  y mire `profesor.atrapa(alumno)`.
- **Manu**: `alumno.position()`, `alumno.recibirGolpe(cantidad)` y `alumno.congelarPor(segundos)`.

## Parte de Maria - Objetos interactivos y recursos

Implemente la logica e integracion con Piso de :
-Parciales, se pueden agarrar, cada parcial solo se puede tomar una vez.
-Llaves, se recoge, desaparece del juego y puede volver a su posición inicial al reiniciar.  
-Escritorio, se abre cuando el alumno tiene la llave y vuelve a cerrarse al reiniciar.
-Bancos fijos y bancos moviles, heredan de Obstaculos; los móviles, además, pueden desplazarse.
-Escaleras, permiten avanzar al siguiente piso, consultando las condiciones de avance propuestas en Piso.



## Parte de Lucca — pisos y progresión

### Implementado

- `piso.wlk`: clase `Piso` con límites del mapa, transitabilidad y obstáculos.
- Administración de profesores, proyectiles y parciales en cada piso.
- `Piso.actualizar(alumno)`: delega las acciones a los profesores y el avance de los proyectiles.
- Condición para completar un piso: todos sus parciales deben haber sido agarrados y debe existir al menos uno.
- `Piso.reiniciarPiso()`: delega el reinicio a profesores, proyectiles y obstáculos.
- `november.wlk`: objeto `juego`, registro de pisos, piso actual, condición de avance, avance y pedido de reinicio.
- `niveles.wlk`: configuración inicial del primer piso con Omar y Lettuce.
- Tests de gestión de pisos y progresión. Los tests activos pasan al momento de esta actualización.

### Pendiente de integración

- **Nacho:** optimizar o revisar la persecución/BFS, que actualmente produce pausas cuando actúan los profesores; implementar `reiniciar()` en `Proyectiles` y en los profesores para que `Piso.reiniciarPiso()` pueda ejecutarse completamente; confirmar los métodos necesarios para mostrar a los profesores en pantalla.
- **María:** implementar `reiniciar()` en los obstáculos, conectar las interacciones de llaves, escritorios, parciales y escaleras con el piso y avisar al juego cuando corresponda intentar avanzar.
- **Manu:** conectar el estado de vida/derrota del jugador con `juego.reiniciarPisoActual()` y coordinar el reposicionamiento del jugador. Mantener compatibles los mensajes `position()`, `recibirGolpe(cantidad)` y `congelarPor(...)` que usan los profesores/proyectiles.
- **Integración general:** realizar el cambio visual de un piso a otro al avanzar; verificar que los parciales recolectados disparen efectivamente la condición de avance.

### Estado de ejecución

La llamada a `juego.iniciarActualizaciones()` permanece comentada temporalmente en `iniciar()` porque la ejecución  de los profesores provoca congelamientos. La estructura para activar el Tick está implementada, pero la persecución y los proyectiles todavía deben probarse juntos en el juego. El test del reinicio total está comentado hasta que los objetos dependientes implementen `reiniciar()`.

## Pendientes generales

- Resolver rendimiento de persecución, reactivar el Tick y probar con profesores y proyectiles.
- Completar integración visual y de interacciones del primer piso.
- Ejecutar nuevamente la batería completa de tests, incluyendo los de reinicio, una vez implementadas las dependencias.

