import wollok.game.*
import obstaculos.Obstaculos
import sonidos.*

class Escalera inherits Obstaculos {

    method image() = "escaleras.png"

    method interactuar(alumno, unJuego) {
        if (self.estaEnLaPosicionDel(alumno)) {
            sonidos.efecto("escalera.wav")
            unJuego.avanzarEntrePiso()
        }
    }

    method estaEnLaPosicionDel(alumno) {
        return position == alumno.position()
    }
}
