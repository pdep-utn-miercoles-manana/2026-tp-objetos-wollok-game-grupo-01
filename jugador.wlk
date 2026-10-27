import wollok.game.*

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
    var property position = game.at(7, 4)
    var velocidad = 1
    var movilidad = movilidadNormal
    var pasoAlterno = false

    method image() = if (pasoAlterno) "./assets/jugadorDerecha2.png" else "./assets/jugadorDerecha1.png"

    // Lo que llama juego.wlk: delegan en la movilidad actual
    method moverArriba()    { movilidad.arriba(self) }
    method moverAbajo()     { movilidad.abajo(self) }
    method moverIzquierda() { movilidad.izquierda(self) }
    method moverDerecha()   { movilidad.derecha(self) }

    // Movimientos reales (con tus chequeos de borde)
    method irArriba() {
        if (position.y() < game.height() - 1) {
            position = position.up(velocidad)
            self.alternarSprite()
        }
    }

    method irAbajo() {
        if (position.y() > 0) {
            position = position.down(velocidad)
            self.alternarSprite()
        }
    }

    method irIzquierda() {
        if (position.x() > 0) {
            position = position.left(velocidad)
            self.alternarSprite()
        }
    }

    method irDerecha() {
        if (position.x() < game.width() - 1) {
            position = position.right(velocidad)
            self.alternarSprite()
        }
    }

    method alternarSprite() { pasoAlterno = !pasoAlterno }

    // Controles
    method invertirControles()  { movilidad = movilidadInvertida }
    method restaurarControles() { movilidad = movilidadNormal }

    // Para cuando se reinicia el nivel
    method reiniciarEn(posicionInicial) {
        position = posicionInicial
        self.restaurarControles()
        velocidad = 1
        pasoAlterno = false
    }
}