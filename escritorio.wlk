import wollok.game.*
import obstaculos.Obstaculos
import sonidos.*

class Escritorio inherits Obstaculos {
    var estaAbierto = false
    var llave = null

    method image() {
    if (llave == null) {
        return "escritorios.png"
    } else if (estaAbierto) {
        return "escritorioAbiertocontapa.png"
    } else {
        return "escritorioConTapaCerrada.png"
    }
}

    method asignarLlave(unaLlave) {
        llave = unaLlave
    }

    method abrir() {
        if (llave != null && llave.fueRecogida() && not estaAbierto) {
            estaAbierto = true
            sonidos.efecto("escritorio.wav")
        }
    }

    method estaCerrado() = !estaAbierto

    method interactuar(alumno) {
        self.abrir()
    }

    override method reiniciar() {
        super()
        estaAbierto = false
    }
}
