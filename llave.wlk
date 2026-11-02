
import wollok.game.*
import obstaculos.Obstaculos

class Llave inherits Obstaculos {
    var recogida = false
    var utilizada = false

    method image() = "llaves.png"

    method fueRecogida() = recogida

    // Se ejecuta cuando el jugador pasa por encima de la llave
    method agarrar() {
        if (!recogida) {
            recogida = true
            game.removeVisual(self)
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
        game.addVisual(self)
    }
}


