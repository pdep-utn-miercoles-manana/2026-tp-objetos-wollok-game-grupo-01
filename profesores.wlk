import buscador.*
import proyectiles.*
import wollok.game.*

// Pseudoaleatorio propio para que el juego no dependa de Math.random.
// Es una LCG chica: alcanza para que los profes cambien de dirección.
object azar {
  var semilla = 20261103

  method siguiente() {
    semilla = (semilla * 37 + 17) % 1000003
    return semilla
  }

  method entre(desde, hasta) {
    return desde + (self.siguiente() % (hasta - desde + 1))
  }
}

// Mi parte del TP: los profesores y su "inteligencia".
// La idea es que el Profesor no sepa qué hace. Le pasa el trabajo a sus
// comportamientos (moverse, lanzar, quedarse quieto) y a su reacción
// (qué hace cuando le tirás un machete o suena un celular).
class Profesor {
  var property position
  var posicionInicial = null         // la copio en initialize para poder reiniciar el piso
  const property nombre
  const property imagen = "DrOmar.png"
  const reaccion
  const comportamientos = []
  var congelado = false
  var ticksCongelado = 0            // si es 0 y congelado, es un congelamiento sin duración
  var senuelo = null                // la celda del celular que lo atrajo
  var siguiendoSenuelo = false      // uso esta bandera porque comparar Position con null explota

  // Los comportamientos los agrego desde afuera (ver la fábrica del final).
  method agregarComportamiento(comportamiento) {
    comportamientos.add(comportamiento)
  }

  // Ojo: si hago `const inicial = position`, Wollok lo recalcula y no guarda
  // el valor. Por eso la posición inicial la copio acá, después de los named args.
  method initialize() {
    posicionInicial = position
  }

  // El piso me llama esto una vez por tick.
  // Si está congelado no hace nada: solo descuenta el congelamiento.
  method actuar(alumno, piso) {
    if (congelado) {
      self.descontarCongelamiento()
    } else {
      comportamientos.forEach({ c => c.actuar(self, alumno, piso) })
      if (siguiendoSenuelo and position == senuelo) { siguiendoSenuelo = false }
    }
  }

  method descontarCongelamiento() {
    if (ticksCongelado > 0) {
      ticksCongelado -= 1
      if (ticksCongelado == 0) { congelado = false }
    }
  }

  // Si hay un celular sonando va hacia ahí; si no, va al alumno.
  method objetivo(alumno) = if (siguiendoSenuelo) senuelo else alumno.position()

  // El piso pregunta esto para saber si tiene que reiniciar el nivel.
  method atrapa(alumno) = position == alumno.position()

  // Congelar "a mano" no tiene duración; lo uso en los tests.
  method congelar() { congelado = true }

  // Esto es lo que usa el machete: se congela una cantidad de ticks.
  method congelarPorTicks(ticks) {
    if (ticks > 0) {
      congelado = true
      ticksCongelado = ticks
    }
  }

  method descongelar() {
    congelado = false
    ticksCongelado = 0
  }

  method estaCongelado() = congelado
  method ticksDeCongelamiento() = ticksCongelado

  method image() = imagen

  // Vuelve todo a como estaba cuando lo crearon. La usa el piso al reiniciar.
  method reiniciar() {
    position = posicionInicial
    congelado = false
    ticksCongelado = 0
    senuelo = null
    siguiendoSenuelo = false
    comportamientos.forEach({ c => c.reiniciar() })
  }

  method atraidoPor(posicion) {
    senuelo = posicion
    siguiendoSenuelo = true
  }

  // El machete no hace lo mismo con todos: a uno lo congela, a otro lo acelera.
  // Le aviso a todos los comportamientos y cada uno ve qué hace.
  method acelerar() { comportamientos.forEach({ c => c.acelerar() }) }

  // Los estímulos externos los maneja la reacción de cada profe.
  method recibirMachete() { reaccion.alMachete(self) }
  method escuchar(posicion) { reaccion.alCelular(self, posicion) }
}

// ---------- Comportamientos ----------
// Todos entienden actuar(profesor, alumno, piso), acelerar() y reiniciar().

// Quieto no hace nada. Lo usan Gallo y Filipo.
object quieto {
  method actuar(profesor, alumno, piso) {}
  method acelerar() {}
  method reiniciar() {}
}

class Perseguir {
  var property pasos = 1
  var anterior = game.at(-1, -1)

  method actuar(profesor, alumno, piso) {
    (1..pasos).forEach({ i => self.intentarAvanzar(profesor, alumno, piso) })
  }

  method intentarAvanzar(profesor, alumno, piso) {
    const origen = profesor.position()
    const destino = profesor.objetivo(alumno)
    const objetivo = if (piso.hayProfesorEn(destino, profesor))
      self.celdaCerca(destino, piso, profesor)
    else
      destino

    if (origen == objetivo) {
      anterior = game.at(-1, -1)
    } else {
      self.moverHacia(profesor, origen, objetivo, piso)
    }
  }

  // Si otro profesor ya está sobre el alumno, este se conforma con quedar
  // pegado a una celda libre al lado. Así no se queda parado a mitad de camino.
  method celdaCerca(destino, piso, profesor) {
    const opciones = [destino.up(1), destino.down(1), destino.left(1), destino.right(1)]
    const libres = opciones.filter({ p =>
      piso.esTransitable(p) and not piso.hayProfesorEn(p, profesor)
    })
    return if (libres.isEmpty()) destino else libres.first()
  }

  // Movimiento directo con esquive local. No hago BFS en cada tick:
  // el piso es chico y los obstáculos están dispersos, así el profe se mueve
  // enseguida y no se queda esperando a que termine una búsqueda.
  method moverHacia(profesor, origen, destino, piso) {
    const dx = destino.x() - origen.x()
    const dy = destino.y() - origen.y()
    const candidatos = []

    if (dx != 0) {
      candidatos.add(if (dx > 0) origen.right(1) else origen.left(1))
    }
    if (dy != 0) {
      candidatos.add(if (dy > 0) origen.up(1) else origen.down(1))
    }
    if (dx != 0) {
      candidatos.add(origen.up(1))
      candidatos.add(origen.down(1))
    }
    if (dy != 0) {
      candidatos.add(origen.left(1))
      candidatos.add(origen.right(1))
    }
    candidatos.add(origen.up(1))
    candidatos.add(origen.down(1))
    candidatos.add(origen.left(1))
    candidatos.add(origen.right(1))

    const libres = candidatos.filter({ p =>
      self.puedeMoverA(profesor, p, piso) and not self.esAnterior(p)
    })
    const todos = candidatos.filter({ p => self.puedeMoverA(profesor, p, piso) })
    const elegido = if (not libres.isEmpty())
      libres.first()
    else if (not todos.isEmpty())
      todos.first()
    else
      origen

    if (elegido == origen) {
      return false
    } else {
      return self.moverA(profesor, origen, elegido)
    }
  }

  method moverA(profesor, origen, destino) {
    profesor.position(destino)
    anterior = origen
    return true
  }

  method puedeMoverA(profesor, posicion, piso) {
    return piso.esTransitable(posicion) and not piso.hayProfesorEn(posicion, profesor)
  }

  method esAnterior(posicion) = posicion == anterior

  method acelerar() {
    pasos += 1
  }

  method reiniciar() {
    pasos = 1
    anterior = game.at(-1, -1)
  }
}

// Movimiento deambulante: elige una celda libre al azar. Es barato,
// no busca caminos y no se traba esperando una ruta.
class CaminarRandom {
  var property pasos = 1

  method actuar(profesor, alumno, piso) {
    (1..pasos).forEach({ i => self.mover(profesor, piso) })
  }

  method mover(profesor, piso) {
    const origen = profesor.position()
    const opciones = [origen.up(1), origen.down(1), origen.left(1), origen.right(1)]
      .filter({ p => piso.esTransitable(p) and not piso.hayProfesorEn(p, profesor) })

    if (not opciones.isEmpty()) {
      const elegida = opciones.get(azar.entre(0, opciones.size() - 1))
      profesor.position(elegida)
    }
  }

  method acelerar() {
    pasos += 1
  }

  method reiniciar() {
    pasos = 1
  }
}










// Perseguir le pide el primer paso al BFS y se mueve.
// `pasos` lo agregué para que el machete acelere a los gallitos.
// class Perseguir {
//   var property pasos = 1

//   method actuar(profesor, alumno, piso) {
//     (1..pasos).forEach({ i =>
//       profesor.position(buscadorDeCaminos.primerPasoHacia(profesor.position(), profesor.objetivo(alumno), piso))
//     })
//   }

//   method acelerar() { pasos += 1 }

//   method reiniciar() { pasos = 1 }
// }

// Decorador: envuelve otro comportamiento y lo deja actuar cada n ticks.
// Así "velocidad baja" y "tira cada tanto" son números, no clases nuevas.
class CadaNTicks {
  var property n
  var nInicial = 0
  const comportamiento
  var ticks = 0

  // Guardo la frecuencia original para poder deshacer la aceleración del machete.
  method initialize() { nInicial = n }

  method actuar(profesor, alumno, piso) {
    ticks += 1
    if (ticks % n == 0) { comportamiento.actuar(profesor, alumno, piso) }
  }

  method acelerar() {
    if (n > 1) { n = n / 2 }
  }

  method reiniciar() {
    n = nInicial
    ticks = 0
    comportamiento.reiniciar()
  }
}

// Arma el proyectil en la celda del profesor y se lo deja al piso.
// La frecuencia la maneja el CadaNTicks que lo envuelve.
class LanzarProyectil {
  const tipo

  method actuar(profesor, alumno, piso) {
    piso.agregarProyectil(new Proyectil(
      position = profesor.position(),
      direccion = self.direccionAlAzar(),
      tipo = tipo))
  }

  method direccionAlAzar() {
    const direcciones = [norte, sur, este, oeste]
    return direcciones.get(azar.entre(0, 3))
  }

  method acelerar() {}
  method reiniciar() {}
}

// ---------- Reacciones ----------
// Todas entienden alMachete(profesor) y alCelular(profesor, posicion).

// Omar se congela 5 segundos y el celular lo ignora.
object reaccionOmar {
  method alMachete(profesor) { profesor.congelarPorTicks(tiempos.ticks(5)) }
  method alCelular(profesor, posicion) {}
}

// Lettuce no siente el machete, pero el celular lo atrae.
object reaccionLettuce {
  method alMachete(profesor) {}
  method alCelular(profesor, posicion) { profesor.atraidoPor(posicion) }
}

// Gallo no se mueve, pero con el machete tira huevos más seguido.
object reaccionGallo {
  method alMachete(profesor) { profesor.acelerar() }
  method alCelular(profesor, posicion) {}
}

// Los gallitos van al celular y con el machete persiguen más rápido.
object reaccionGallito {
  method alMachete(profesor) { profesor.acelerar() }
  method alCelular(profesor, posicion) { profesor.atraidoPor(posicion) }
}

// Filipo y Fermin ignoran todo.
object reaccionFilipo {
  method alMachete(profesor) {}
  method alCelular(profesor, posicion) {}
}

// Paso segundos a ticks. El tick del juego tiene que durar lo mismo que dice acá:
// si no, los 5 segundos de congelamiento de Omar no son 5 segundos.
object tiempos {
  const property milisegundosPorTick = 200
  method ticks(segundos) = segundos * 1000 / milisegundosPorTick
  method ticksPorSegundo() = 1000 / milisegundosPorTick
}

// ---------- Armado de los profes ----------
// Los armo acá para no tener un constructor gigante. Los números son de prueba,
// después se ajustan jugando.

object profesores {

  // El profe ya queda en el juego: tiene position() e image(), así que se dibuja solo.
  method agregarAlJuego(profesor) {
    game.addVisual(profesor)
    return profesor
  }

  method omar(posicion) {
    const profesor = new Profesor(position = posicion, nombre = "Dr. Omar", reaccion = reaccionOmar, imagen = "DrOmar.png")
    profesor.agregarComportamiento(new CadaNTicks(n = 2, comportamiento = new CaminarRandom()))
    profesor.agregarComportamiento(new CadaNTicks(n = 6, comportamiento = new LanzarProyectil(tipo = tiza)))
    return self.agregarAlJuego(profesor)
  }

  method lettuce(posicion) {
    const profesor = new Profesor(position = posicion, nombre = "Ing. Lettuce", reaccion = reaccionLettuce, imagen = "lettuce.png")
    profesor.agregarComportamiento(new CadaNTicks(n = 2, comportamiento = new CaminarRandom()))
    profesor.agregarComportamiento(new CadaNTicks(n = 6, comportamiento = new LanzarProyectil(tipo = borrador)))
    return self.agregarAlJuego(profesor)
  }

  method gallo(posicion) {
    const profesor = new Profesor(position = posicion, nombre = "Gallo", reaccion = reaccionGallo, imagen = "galloDerecha.png")
    profesor.agregarComportamiento(new CadaNTicks(n = 4, comportamiento = new CaminarRandom()))
    profesor.agregarComportamiento(new CadaNTicks(n = 8, comportamiento = new LanzarProyectil(tipo = huevo)))
    return self.agregarAlJuego(profesor)
  }

  method gallito(posicion) {
    const profesor = new Profesor(position = posicion, nombre = "Gallito", reaccion = reaccionGallito, imagen = "gallo.png")
    profesor.agregarComportamiento(new CadaNTicks(n = 2, comportamiento = new CaminarRandom()))
    profesor.agregarComportamiento(new CadaNTicks(n = 8, comportamiento = new LanzarProyectil(tipo = huevo)))
    return self.agregarAlJuego(profesor)
  }

  method filipo(posicion) {
    const profesor = new Profesor(position = posicion, nombre = "Filipo", reaccion = reaccionFilipo, imagen = "filipoDerecha1.png")
    profesor.agregarComportamiento(new CadaNTicks(n = 4, comportamiento = new CaminarRandom()))
    profesor.agregarComportamiento(new CadaNTicks(n = 10, comportamiento = new LanzarProyectil(tipo = tiza)))
    return self.agregarAlJuego(profesor)
  }

  method fermin(posicion) {
    const profesor = new Profesor(position = posicion, nombre = "Fermin", reaccion = reaccionFilipo, imagen = "fermin.png")
    profesor.agregarComportamiento(new CadaNTicks(n = 4, comportamiento = new CaminarRandom()))
    profesor.agregarComportamiento(new CadaNTicks(n = 10, comportamiento = new LanzarProyectil(tipo = tiza)))
    return self.agregarAlJuego(profesor)
  }
}
