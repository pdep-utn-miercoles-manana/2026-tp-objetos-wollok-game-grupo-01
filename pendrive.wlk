import wollok.game.*
import obstaculos.*
class Pendrive inherits Obstaculos {

    var recogido = false

    method image() = "pendrive.png"

    method fueRecogido() = recogido

    method agarrar(alumno) {
        if (not recogido) {
            recogido = true
            alumno.guardarPendrive(self)

            if (game.hasVisual(self)) {
                game.removeVisual(self)
            }
        }
    }

    method usar(computadora) {
        computadora.activar()
    }

    override method reiniciar() {
        super()
        recogido = false
    }
}