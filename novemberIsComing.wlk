import jugador.*

object juego {
    method iniciar() {
        game.addVisual(jugador)
        keyboard.up().onPressDo({ jugador.moverArriba() })
        keyboard.down().onPressDo({ jugador.moverAbajo() })
        keyboard.left().onPressDo({ jugador.moverIzquierda() })
        keyboard.right().onPressDo({ jugador.moverDerecha() })
    }
}