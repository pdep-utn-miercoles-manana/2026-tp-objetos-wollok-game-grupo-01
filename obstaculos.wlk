class Obstaculos {
    var property position
    var posicionInicial = game.at(0, 0)

    method initialize(unaPosicion) {
        position = unaPosicion
        posicionInicial = unaPosicion
    }

    method reiniciar() {
        position = posicionInicial
    }
}

