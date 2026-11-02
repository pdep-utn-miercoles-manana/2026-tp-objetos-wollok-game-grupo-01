import wollok.game.*

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
  var property direccion
  var property tipo

  method avanzar() {
    position = direccion.siguiente(position)
  }

  method tocaA(alumno) = position == alumno.position()

  method impactar(alumno) { tipo.impactar(alumno) }

  method image() = "./assets/proyectil.png"

  // Para reutilizar el mismo objeto visual sin volver a agregarlo al juego.
  method copiarDe(otro) {
    position = otro.position()
    direccion = otro.direccion()
    tipo = otro.tipo()
  }

  method desactivar() {
    position = game.at(0, -1)
  }
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

// La lista de los proyectiles vivos. Avanza, impacta y recicla los que ya pegaron.
// Ojo: los visuales se crean una sola vez y después se reutilizan. Si se hace
// game.addVisual/removeVisual por cada tiro, el juego se tira tirones.
class Proyectiles {
  const property vivos = []
  const reciclables = []

  method agregar(proyectilNuevo) {
    if (reciclables.isEmpty()) {
      vivos.add(proyectilNuevo)
      game.addVisual(proyectilNuevo)
    } else {
      const reciclado = reciclables.first()
      reciclables.remove(reciclado)
      reciclado.copiarDe(proyectilNuevo)
      vivos.add(reciclado)
    }
  }

  method cantidad() = vivos.size()

  // Deja unos proyectiles ya dibujados afuera del tablero para que el primer
  // disparo no tenga que crear el visual en medio del juego.
  method precargar(cantidad) {
    (1..cantidad).forEach({ i =>
      const proyectil = new Proyectil(
        position = game.at(0, -1),
        direccion = este,
        tipo = tiza)
      reciclables.add(proyectil)
      game.addVisual(proyectil)
    })
  }

  method avanzar(alumno) {
    vivos.forEach({ p => p.avanzar() })

    const impactados = vivos.filter({ p => p.tocaA(alumno) })
    impactados.forEach({ p => p.impactar(alumno) })
    impactados.forEach({ p => self.sacar(p) })
  }

  // Cuando el proyectil sale del piso o se choca con una pared, no tiene sentido dejarlo vivo.
  method descartarFueraDe(piso) {
    vivos
      .filter({ p => not piso.esTransitable(p.position()) })
      .forEach({ p => self.sacar(p) })
  }

  // Al reiniciar el piso se apagan los proyectiles, pero los visuales se conservan
  // para reciclarlos en el próximo tiro.
  method reiniciar() {
    vivos.forEach({ p => p.desactivar() })
    reciclables.addAll(vivos)
    vivos.clear()
  }

  method sacar(proyectil) {
    vivos.remove(proyectil)
    proyectil.desactivar()
    reciclables.add(proyectil)
  }
}
