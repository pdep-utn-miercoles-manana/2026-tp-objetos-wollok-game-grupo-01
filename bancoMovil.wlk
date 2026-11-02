
import wollok.game.*
import obstaculos.Obstaculos

class BancosMoviles inherits Obstaculos {

    var direccion = 1

    method image() = "sillas.png"

    method actuar() {
        if (position.x() >= 13) {
            direccion = -1
        }
        if (position.x() <= 7) {
            direccion = 1
        }

        if (direccion == 1) {
            self.moverDerecha(1)
        } else {
            self.moverIzquierda(1)
        }
    }

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
