import wollok.game.*
import jugador.*
import niveles.*
import profesores.*
import talonario.*
object juego{

    const pisos = []
    var numeroDePisoActual = 0
    var juegoGanado = false

        method iniciar() {
            niveles.configurarPlantaBaja()
            niveles.configurarPrimerPiso()
            niveles.configurarSegundoPiso()
            niveles.configurarTercerPiso()
            
            self.agregarPiso(niveles.pisoPlantaBaja())
            self.agregarPiso(niveles.primerPiso())
            self.agregarPiso(niveles.segundoPiso())
            self.agregarPiso(niveles.tercerPiso())

            niveles.primerPiso().ocultarVisuales()
            niveles.segundoPiso().ocultarVisuales()
            niveles.tercerPiso().ocultarVisuales()

            jugador.entrarAlPiso(self.pisoActual())
            game.addVisual(jugador)
            keyboard.up().onPressDo({ jugador.moverArriba() })
            keyboard.down().onPressDo({ jugador.moverAbajo() })
            keyboard.left().onPressDo({ jugador.moverIzquierda() })
            keyboard.right().onPressDo({ jugador.moverDerecha() })
            self.iniciarActualizaciones()


            //Interaccion al presionar la tecla e, con escaleras, llaves y parciales.
            keyboard.e().onPressDo({self.pisoActual().interactuarAlPresionarE(jugador, self)})
            keyboard.backspace().onPressDo({pantallaGuia.cerrar()})
        }
            
        method agregarPiso(unPiso) = pisos.add(unPiso)
        method cantidadDePisos() = pisos.size()
        method pisoActual(){
            return pisos.get(numeroDePisoActual)
        }

        method iniciarActualizaciones() {
          const tick = game.tick(tiempos.milisegundosPorTick(), {
            self.pisoActual().actualizar(jugador)
            jugador.actuar()
            self.verificarDerrota()
            }, false)

         tick.start()
        }
        // method iniciarActualizaciones() {
        //   const tick = game.tick(tiempos.milisegundosPorTick(), {
        // self.pisoActual().actualizar(jugador)
        // jugador.actuar()
        // self.verificarDerrota()
        //  }, false)

        //     tick.start()
        // }
       method reiniciarPisoActual() {
            self.pisoActual().reiniciarPiso()
            jugador.reiniciar()
            jugador.entrarAlPiso(self.pisoActual())
        }
        // mensaje creado para reiniciar estado de piso entre test
        method reiniciarConfiguracion() {
                pisos.clear()
                numeroDePisoActual = 0
        }

       method avanzarEntrePiso() {
            if (self.condicionOkDePasarEntrePisos()) {
                self.pisoActual().ocultarVisuales()
                numeroDePisoActual += 1
                jugador.entrarAlPiso(self.pisoActual())
                self.pisoActual().mostrarVisuales()
              } else {
                if (not self.haySiguientePiso() &&
                self.pisoActual().tieneTodosLosParcialesAgarrados() &&
                not juegoGanado) {

             juegoGanado = true

                if (game.running()) {
                    game.say(jugador, "¡Felicitaciones, probablemente no tengas que ir a final!")
                    game.schedule(3000, { game.stop() })
                        }
                }
            } 
        }
        method condicionOkDePasarEntrePisos() =
            self.haySiguientePiso() &&
            (self.pisoActual() == niveles.pisoPlantaBaja() || self.pisoActual().tieneTodosLosParcialesAgarrados())
        // mensaje creado para que no rompa al no haber otro piso
        method haySiguientePiso() {
             return numeroDePisoActual < pisos.size() - 1
        }

        method verificarDerrota() {
            if (jugador.sinVidas()) {
            self.reiniciarPisoActual()
            }
        }

    

}