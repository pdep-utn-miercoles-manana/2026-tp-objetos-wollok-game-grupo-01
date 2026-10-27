import wollok.game.*
import obstaculos.Obstaculos

class Llave inherits Obstaculos {
    var recogida = false

    method image() = "./assets/llaves.png"

    method fueRecogida() = recogida

    method agarrar() {
        if (!recogida) {
            recogida = true
            game.removeVisual(self)
        }
    }

    override method reiniciar() {
        super()
        recogida = false
        game.addVisual(self)
    }
}
