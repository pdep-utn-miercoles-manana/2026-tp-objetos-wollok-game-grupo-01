import wollok.game.*

class Llave {
    var property position
    var posicionInicial = game.at(0, 0)
    var recogida = false

    method initialize(unaPosicion) {
        position = unaPosicion
        posicionInicial = unaPosicion
    }

    method fueRecogida() = recogida

    method agarrar() {
        if (!recogida) {
            recogida = true
            game.removeVisual(self)
        }
    }

    method reiniciar() {
        position = posicionInicial

        if (recogida) {
            recogida = false
            game.addVisual(self)
        }
    }
}
