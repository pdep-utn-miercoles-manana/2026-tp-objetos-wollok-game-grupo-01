import wollok.game.*
import profesores.*   // para usar tiempos.ticks(segundos)
import november.*

object movilidadNormal {
    method arriba(j)    { j.irArriba() }
    method abajo(j)     { j.irAbajo() }
    method izquierda(j) { j.irIzquierda() }
    method derecha(j)   { j.irDerecha() }
}

object movilidadInvertida {
    method arriba(j)    { j.irAbajo() }
    method abajo(j)     { j.irArriba() }
    method izquierda(j) { j.irDerecha() }
    method derecha(j)   { j.irIzquierda() }
}

object jugador {
    const posicionInicial = game.at(7, 4)
    const vidasIniciales = 3

    var property position = posicionInicial
    var velocidad = 1
    var movilidad = movilidadNormal
    var pasoAlterno = false
    var pendrive = null
    var pisoActual = null

    method establecerPiso(unPiso) {
        pisoActual = unPiso
    }

    // Si todavía no hay piso (por ejemplo en un test), uso los bordes del juego.
    method esTransitable(destino) {
        if (pisoActual == null) {
            return destino.x() >= 0 and destino.x() < game.width() and
                   destino.y() >= 0 and destino.y() < game.height()
        }
        return pisoActual.esTransitable(destino)
    }

    var vidas = vidasIniciales
    var ticksCongelado = 0

    method guardarPendrive(unPendrive) {
    pendrive = unPendrive
    }

    method tienePendrive() = pendrive != null

    method usarPendrive(computadora) {
    if (self.tienePendrive()) {
        pendrive.usar(computadora)
        pendrive = null
    }
   }
    method verificarInteraccion() {
    juego.pisoActual().interactuarCon(self)
   }
    method recuperarCorazon() {
    vidas = (vidas + 1).min(vidasIniciales)
    }


    method image() = if (pasoAlterno) "jugadorDerecha2.png" else "jugadorDerecha1.png"

    // Si está congelado, ignora las teclas
    method moverArriba()    { if (self.puedeMoverse()) movilidad.arriba(self) }
    method moverAbajo()     { if (self.puedeMoverse()) movilidad.abajo(self) }
    method moverIzquierda() { if (self.puedeMoverse()) movilidad.izquierda(self) }
    method moverDerecha()   { if (self.puedeMoverse()) movilidad.derecha(self) }

    method puedeMoverse() = !self.estaCongelado()

    // Movimientos reales (con bordes y obstáculos)
    method irArriba() {
        const destino = position.up(velocidad)
        if (self.esTransitable(destino)) {
            position = destino
            self.alternarSprite()
            self.verificarInteraccion()
        }
    }

    method irAbajo() {
        const destino = position.down(velocidad)
        if (self.esTransitable(destino)) {
            position = destino
            self.alternarSprite()
            self.verificarInteraccion()
        }
    }

    method irIzquierda() {
        const destino = position.left(velocidad)
        if (self.esTransitable(destino)) {
            position = destino
            self.alternarSprite()
            self.verificarInteraccion()
        }
    }

    method irDerecha() {
        const destino = position.right(velocidad)
        if (self.esTransitable(destino)) {
            position = destino
            self.alternarSprite()
            self.verificarInteraccion()
        }
    }

    method alternarSprite() { pasoAlterno = !pasoAlterno }

    // Controles
    method invertirControles()  { movilidad = movilidadInvertida }
    method restaurarControles() { movilidad = movilidadNormal }


    // Lo llaman tiza, borrador y huevo. Las vidas no bajan de 0.
    method recibirGolpe(cantidad) {
        vidas = (vidas - cantidad).max(0)
    }

    method vidas() = vidas
    method sinVidas() = vidas == 0

    // Lo llama el borrador. Si ya estaba congelado, se queda con el tiempo mayor.
    method congelarPor(segundos) {
        ticksCongelado = ticksCongelado.max(tiempos.ticks(segundos))
    }

    method estaCongelado() = ticksCongelado > 0

    // El piso lo llama una vez por tick (igual que a los profesores)
    method actuar() {
        if (self.estaCongelado()) {
            ticksCongelado -= 1
        }
    }
    
    // ---------- Reinicio ----------
    // Vuelve todo al estado inicial del piso
    method reiniciar() {
        position = posicionInicial
        movilidad = movilidadNormal
        velocidad = 1
        pasoAlterno = false
        vidas = vidasIniciales
        ticksCongelado = 0
    }
}