import obstaculos.Obstaculos

class Escritorio inherits Obstaculos {
    var estaAbierto = false
    var llave

    method asignarLlave(unaLlave) {
        llave = unaLlave
    }

    method abrir() {
        if (llave.fueRecogida()) {
            estaAbierto = true
        }
    }

    method estaCerrado() = !estaAbierto

    method interactuar(alumno) {
        if (self.estaCerrado() && llave.fueRecogida()) {
            self.abrir()
        }
    }

    override method reiniciar() {
        super()
        estaAbierto = false
    }
}
