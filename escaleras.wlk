import wollok.game.*
import obstaculos.Obstaculos

class Escalera inherits Obstaculos {

    method image() = "escaleras.png"

    method interactuar(alumno, unJuego) {
        if (self.estaEnLaPosicionDel(alumno)) {
            unJuego.avanzarEntrePiso()
        }
    }

    method estaEnLaPosicionDel(alumno) {
        return position == alumno.position()
    }
}
