import proyectiles.*

// Dobles de prueba para no depender del Piso de Lucca ni del Alumno de Manu.
// Cuando estén los reales, estos quedan para los tests.

// Un piso de mentira: solo me interesa qué celdas se pueden pisar y guardar proyectiles.
class PisoDePrueba {
  const ancho
  const alto
  const property obstaculos = []
  const property proyectiles = new Proyectiles()

  // Adentro del tablero y que no sea obstáculo.
  method esTransitable(posicion) {
    return posicion.x() >= 0 and posicion.x() < ancho and
      posicion.y() >= 0 and posicion.y() < alto and
      not obstaculos.contains(posicion)
  }

  method agregarProyectil(proyectil) { proyectiles.agregar(proyectil) }

  method avanzarProyectiles(alumno) { proyectiles.avanzar(alumno) }

  // En el piso de prueba no hay otros profesores.
  method hayProfesorEn(unaPosicion, excepto) = false
}

// Un alumno de mentira con lo mínimo: posición, vida y congelamiento.
class AlumnoDePrueba {
  var property position
  var property vida = 3
  var congelado = false
  var property segundosDeCongelamiento = 0

  method recibirGolpe(cantidad) { vida -= cantidad }

  method congelarPor(segundos) {
    congelado = true
    segundosDeCongelamiento = segundos
  }

  method estaCongelado() = congelado

  method descongelar() { congelado = false }
}
