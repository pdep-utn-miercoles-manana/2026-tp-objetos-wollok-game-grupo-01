import buscador.*
import proyectiles.*
import wollok.game.*

// Mi parte del TP: los profesores y su "inteligencia".
// La idea es que el Profesor no sepa qué hace. Le pasa el trabajo a sus
// comportamientos (moverse, lanzar, quedarse quieto) y a su reacción
// (qué hace cuando le tirás un machete o suena un celular).
class Profesor {
  var property position
  var posicionInicial = null         // la copio en initialize para poder reiniciar el piso
  const property nombre
  const property imagen = "./assets/profesor.png"
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

// Perseguir le pide el primer paso al BFS y se mueve.
// `pasos` lo agregué para que el machete acelere a los gallitos.
class Perseguir {
  var property pasos = 1

  method actuar(profesor, alumno, piso) {
    (1..pasos).forEach({ i =>
      profesor.position(buscadorDeCaminos.primerPasoHacia(profesor.position(), profesor.objetivo(alumno), piso))
    })
  }

  method acelerar() { pasos += 1 }

  method reiniciar() { pasos = 1 }
}

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
      direccion = trayectorias.hacia(profesor.position(), alumno.position()),
      tipo = tipo))
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
    const profesor = new Profesor(position = posicion, nombre = "Dr. Omar", reaccion = reaccionOmar, imagen = "./assets/Dr Omar.png")
    profesor.agregarComportamiento(new CadaNTicks(n = 2, comportamiento = new Perseguir()))
    profesor.agregarComportamiento(new CadaNTicks(n = 6, comportamiento = new LanzarProyectil(tipo = tiza)))
    return self.agregarAlJuego(profesor)
  }

  method lettuce(posicion) {
    const profesor = new Profesor(position = posicion, nombre = "Ing. Lettuce", reaccion = reaccionLettuce, imagen = "./assets/letucce.png")
    profesor.agregarComportamiento(new CadaNTicks(n = 2, comportamiento = new Perseguir()))
    profesor.agregarComportamiento(new CadaNTicks(n = 6, comportamiento = new LanzarProyectil(tipo = borrador)))
    return self.agregarAlJuego(profesor)
  }

  method gallo(posicion) {
    const profesor = new Profesor(position = posicion, nombre = "Gallo", reaccion = reaccionGallo, imagen = "./assets/galo.png")
    profesor.agregarComportamiento(quieto)
    profesor.agregarComportamiento(new CadaNTicks(n = 8, comportamiento = new LanzarProyectil(tipo = huevo)))
    return self.agregarAlJuego(profesor)
  }

  method gallito(posicion) {
    const profesor = new Profesor(position = posicion, nombre = "Gallito", reaccion = reaccionGallito, imagen = "./assets/galo.png")
    profesor.agregarComportamiento(new Perseguir())
    return self.agregarAlJuego(profesor)
  }

  method filipo(posicion) {
    const profesor = new Profesor(position = posicion, nombre = "Filipo", reaccion = reaccionFilipo, imagen = "./assets/filipo.png")
    profesor.agregarComportamiento(quieto)
    return self.agregarAlJuego(profesor)
  }

  method fermin(posicion) {
    const profesor = new Profesor(position = posicion, nombre = "Fermin", reaccion = reaccionFilipo, imagen = "./assets/fermin.png")
    profesor.agregarComportamiento(quieto)
    return self.agregarAlJuego(profesor)
  }
}
