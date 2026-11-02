import wollok.game.*
import jugador.*

object indicadorVidas {

    method image() {
        if (jugador.vidas() == 3) {
            return "./assets/tresvidas.png"
        }
        if (jugador.vidas() == 2) {
            return "./assets/dosvidas.png"
        }
        if (jugador.vidas() == 1) {
            return "./assets/unavida.png"
        }
        return "./assets/unavida.png"
    }
}