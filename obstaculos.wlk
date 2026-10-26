class Obstaculos {
    var property position
    var posicionInicial

    method initialize(unaPosicion) {
        position = unaPosicion
        posicionInicial = unaPosicion
    }

    method reiniciar() {
        position = posicionInicial
    }
}

