import wollok.game.*
import jugador.*
import niveles.*
object juego{

    const pisos = []
    var numeroDePisoActual = 0

        method iniciar() {
            niveles.configurarPrimerPiso()
            self.agregarPiso(niveles.primerPiso())
            game.addVisual(jugador)
            keyboard.up().onPressDo({ jugador.moverArriba() })
            keyboard.down().onPressDo({ jugador.moverAbajo() })
            keyboard.left().onPressDo({ jugador.moverIzquierda() })
            keyboard.right().onPressDo({ jugador.moverDerecha() })
            //self.iniciarActualizaciones()


            //Interaccion al presionar la tecla e, con escaleras, llaves y parciales.
            keyboard.e().onPressDo({
            self.pisoActual().interactuarCon(jugador)
            self.pisoActual().interactuarEscaleraEn(
            jugador.position(),jugador,self )})

        }
        method agregarPiso(unPiso) = pisos.add(unPiso)
        method cantidadDePisos() = pisos.size()
        method pisoActual(){
            return pisos.get(numeroDePisoActual)
        }
        method iniciarActualizaciones() {
            const tick = game.tick(2000, {
                self.pisoActual().actualizar(jugador)
            }, false)

            tick.start()
        }
        method reiniciarPisoActual() {
            self.pisoActual().reiniciarPiso()
        }
        // mensaje creado para reiniciar estado de piso entre test
        method reiniciarConfiguracion() {
                pisos.clear()
                numeroDePisoActual = 0
        }

         method avanzarEntrePiso() {
                if (self.condicionOkDePasarEntrePisos()) {
                numeroDePisoActual += 1
                }
        }
        method condicionOkDePasarEntrePisos(){
            return self.haySiguientePiso() && self.pisoActual().tieneTodosLosParcialesAgarrados()
        }
        // mensaje creado para que no rompa al no haber otro piso
        method haySiguientePiso() {
             return numeroDePisoActual < pisos.size() - 1
        }

    

}