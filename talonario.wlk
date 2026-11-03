import wollok.game.*
import obstaculos.*


class Talonario inherits Obstaculos {
    var paginaActual = 0

    method image() = "escritorios.png"

   method interactuar() {
    if (game.running() and not game.hasVisual(pantallaGuia)) {
        game.addVisual(pantallaGuia)
        }
    }

    override method reiniciar() {
        super()
        paginaActual = 0
    }
    
}

object pantallaGuia {
    method position() = game.at(3, 2)
    method image() = "guiaTalonario.png"

    method cerrar() {
        if (game.hasVisual(self)) {
            game.removeVisual(self)
        }
    }

    method estaAbierta() = game.hasVisual(self)
}



