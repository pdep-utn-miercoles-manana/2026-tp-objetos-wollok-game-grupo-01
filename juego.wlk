import wollok.game.*
import jugador.*
object juego{

    const pisos = []
    var numeroDePisoActual = 0

        method iniciar() {
            game.addVisual(jugador)
            keyboard.up().onPressDo({ jugador.moverArriba() })
            keyboard.down().onPressDo({ jugador.moverAbajo() })
            keyboard.left().onPressDo({ jugador.moverIzquierda() })
            keyboard.right().onPressDo({ jugador.moverDerecha() })
        }
        method agregarPiso(unPiso) = pisos.add(unPiso)
        method cantidadDePisos() = pisos.size()
        method pisoActual(){
            return pisos.get(numeroDePisoActual)
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