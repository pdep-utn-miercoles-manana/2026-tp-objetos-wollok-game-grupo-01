import wollok.game.*
import jugador.*

object juego {
    method iniciar() {
        game.title("November is coming")
        game.width(15)
        game.height(10)
        game.cellSize(50)

        game.addVisual(jugador)
        self.configurarTeclas()

        game.start()
    }

    method configurarTeclas() {
        keyboard.up().onPressDo({ jugador.moverArriba() })
        keyboard.down().onPressDo({ jugador.moverAbajo() })
        keyboard.left().onPressDo({ jugador.moverIzquierda() })
        keyboard.right().onPressDo({ jugador.moverDerecha() })
    }
}