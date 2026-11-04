import escritorio.*
import profesores.*
import wollok.game.*

    class EscritorioConComputadora inherits Escritorio {

    var descargaIniciada = false
    var descargaTerminada = false
    var ticksRestantes = 0
    var parcialAsociado = null

    override method interactuar(alumno) {
        if (not descargaIniciada) {
            alumno.usarPendrive(self)
        }
    }

    method activar() {
        if (not descargaIniciada) {
            descargaIniciada = true
            ticksRestantes = tiempos.ticks(10)
        }
    }
    method vincularParcial(unParcial) {
        parcialAsociado = unParcial
    }

    method entregarParcial() {
        if (parcialAsociado != null and not parcialAsociado.seAgarro()) {
            parcialAsociado.agarrar()

        if (game.running()) {
            game.say(self, "¡Descarga completa! ¡Parcial conseguido!")
         }
        }
    }

    method actualizar() {
    if (descargaIniciada and not descargaTerminada) {
        ticksRestantes -= 1

        if (ticksRestantes <= 0) {
            descargaTerminada = true
            self.entregarParcial()
        }
      }
    }

    method estaDescargando() =
        descargaIniciada and not descargaTerminada

    method terminoDescarga() = descargaTerminada

    override method reiniciar() {
        super()
        descargaIniciada = false
        descargaTerminada = false
        ticksRestantes = 0
    }
}