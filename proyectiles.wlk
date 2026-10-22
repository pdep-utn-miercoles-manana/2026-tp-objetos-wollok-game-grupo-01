// Los proyectiles. La gracia es que el proyectil no pregunta de qué tipo es:
// el tipo sabe qué hacer cuando pega.

// ---------- Direcciones ----------

// Cada dirección sabe cuál es la celda siguiente. Me ahorro un if por dirección.
object norte {
  method siguiente(posicion) = posicion.up(1)
}

object sur {
  method siguiente(posicion) = posicion.down(1)
}

object este {
  method siguiente(posicion) = posicion.right(1)
}

object oeste {
  method siguiente(posicion) = posicion.left(1)
}

object trayectorias {

  // La dirección dominante desde el origen hasta el destino.
  // El tiro va en línea recta, no persigue.
  method hacia(origen, destino) {
    const dx = destino.x() - origen.x()
    const dy = destino.y() - origen.y()
    if (dx.abs() >= dy.abs()) { return if (dx >= 0) este else oeste }
    return if (dy >= 0) norte else sur
  }
}

// ---------- Proyectiles ----------

// El proyectil solo avanza y dice a quién toca. El efecto lo pone el tipo.
class Proyectil {
  var property position
  const direccion
  const tipo

  method avanzar() {
    position = direccion.siguiente(position)
  }

  method tocaA(alumno) = position == alumno.position()

  method impactar(alumno) { tipo.impactar(alumno) }
}

// Tiza: saca 1.
object tiza {
  method impactar(alumno) { alumno.recibirGolpe(1) }
}

// Borrador: saca 2 y congela 2 segundos.
object borrador {
  method impactar(alumno) {
    alumno.recibirGolpe(2)
    alumno.congelarPor(2)
  }
}

// Huevo: saca 1.
object huevo {
  method impactar(alumno) { alumno.recibirGolpe(1) }
}

// La lista de los proyectiles vivos. Avanza, impacta y saca los que ya pegaron.
// Lucca puede usar esto desde el Piso para no repetir el recorrido en cada tick.
class Proyectiles {
  const property vivos = []

  method agregar(proyectil) { vivos.add(proyectil) }

  method cantidad() = vivos.size()

  method avanzar(alumno) {
    vivos.forEach({ p => p.avanzar() })

    const impactados = vivos.filter({ p => p.tocaA(alumno) })
    impactados.forEach({ p => p.impactar(alumno) })
    impactados.forEach({ p => vivos.remove(p) })
  }
}
