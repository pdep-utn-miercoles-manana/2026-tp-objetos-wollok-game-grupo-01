import wollok.game.*

class Parcial {
    var property position
    var agarrado = false

    method image() = "./assets/parcial.png"

    // Indica si el parcial ya fue recogido.
    method seAgarro() = agarrado

    // Recoge el parcial y lo elimina visualmente del juego.
    method agarrar() {
        if (!agarrado) {
            agarrado = true
            game.removeVisual(self)
        }
    }

    // Reinicia el parcial para que pueda recogerse nuevamente.
    method reiniciar() {
        agarrado = false
        game.addVisual(self)
    }
}