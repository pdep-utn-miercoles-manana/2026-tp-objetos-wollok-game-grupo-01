object jugador {
    var property position = game.at(7, 4)

    var velocidad = 1

    method image() = "./assets/jugador.png" 

    method moverArriba() {
        if (position.y() < game.height() - 1) {
            position = position.up(velocidad)
        }
    }

    method moverAbajo() {
        if (position.y() > 0) {
            position = position.down(velocidad)
        }
    }

    method moverIzquierda() {
        if (position.x() > 0) {
            position = position.left(velocidad)
        }
    }

    method moverDerecha() {
        if (position.x() < game.width() - 1) {
            position = position.right(velocidad)
        }
    }
}