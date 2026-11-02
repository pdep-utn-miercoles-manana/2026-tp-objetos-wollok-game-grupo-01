import wollok.game.*
import obstaculos.Obstaculos

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
        if (llave != null && llave.fueRecogida()) {
            estaAbierto = true
        }
    }

    method estaCerrado() = !estaAbierto

    method interactuar(alumno) {
        if (llave != null && self.estaCerrado() && llave.fueRecogida()) {
            self.abrir()
        }
    }

    override method reiniciar() {
        super()
        estaAbierto = false
    }
}
