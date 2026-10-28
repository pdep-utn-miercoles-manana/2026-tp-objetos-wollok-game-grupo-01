import obstaculos.Obstaculos

class BancosMoviles inherits Obstaculos {

    method image() = "./assets/sillas.png"

    method moverA(unaPosicion) {
        position = unaPosicion
    }

    method moverDerecha(cantidad) {
        position = position.right(cantidad)
    }

    method moverIzquierda(cantidad) {
        position = position.left(cantidad)
    }

    method moverArriba(cantidad) {
        position = position.up(cantidad)
    }

    method moverAbajo(cantidad) {
        position = position.down(cantidad)
    }

}