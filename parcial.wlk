import wollok.game.*
import sonidos.*

class Parcial {
    var property position
    var agarrado = false

    method image() = "parcial.png"

    // Indica si el parcial ya fue recogido.
    method seAgarro() = agarrado

    // Recoge el parcial y lo elimina visualmente del juego.
    method agarrar() {
        if (!agarrado) {
            agarrado = true
            game.removeVisual(self)
            sonidos.efecto("parcial.wav")
        }
    }

    // Reinicia el parcial para que pueda recogerse nuevamente.
    method reiniciar() {
        agarrado = false
        game.addVisual(self)
    }
}