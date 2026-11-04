
import wollok.game.*
import obstaculos.Obstaculos
import sonidos.*

class Llave inherits Obstaculos {
    var recogida = false
    var utilizada = false

    method image() = "llave.png"

    method fueRecogida() = recogida

    // Se ejecuta cuando el jugador pasa por encima de la llave
    method agarrar() {
        if (!recogida) {
            recogida = true
            game.removeVisual(self)
            sonidos.efecto("llave.wav")
        }
    }

    // Se ejecuta cuando el jugador interactúa con el escritorio
    method usar(escritorio) {
        if (recogida && !utilizada) {
            escritorio.abrir()
            utilizada = true
        }
    }

    override method reiniciar() {
        super()
        recogida = false
        utilizada = false
        if (not game.hasVisual(self)) {
            game.addVisual(self)
        }
    }
}


