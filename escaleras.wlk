import wollok.game.*
import obstaculos.Obstaculos
import sonidos.*

class Escalera inherits Obstaculos {

    method image() = "escaleras.png"
    method esVisible() = true

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

// Escalera exclusiva para regresar del primer piso a planta baja.
class EscaleraDeBajada inherits Escalera {
    override method esVisible() = false

    override method interactuar(alumno, unJuego) {
        if (self.estaEnLaPosicionDel(alumno)) {
            sonidos.efecto("escalera.wav")
            unJuego.bajarAPlantaBaja()
        }
    }
}
