import wollok.game.*
import obstaculos.Obstaculos

class Escritorio inherits Obstaculos {
    var estaAbierto = false
    var llave

    method image() = "./assets/escritorio.png"
    method asignarLlave(unaLlave) {
        llave = unaLlave
    }

    method abrir() {
        if (llave.fueRecogida()) {
            estaAbierto = true
        }
    }

    method estaCerrado() = !estaAbierto

   //comprueba si el escritorio está cerrado y la llave fue recogida. Si ambas condiciones se cumplen, lo abre.
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
