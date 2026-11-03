import wollok.game.*
import jugador.*

object indicadorVidas {
    method position() = game.at(0, 1)

    method image() {
        if (jugador.vidas() >= 3) {
            return "tresvidas.png"
        }
        if (jugador.vidas() == 2) {
            return "dosvidas.png"
        }
        return "unavida.png"
    }
}