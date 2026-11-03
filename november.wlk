import wollok.game.*
import jugador.*
import niveles.*
import profesores.*
import pantallaInicio.*
object juego{

    const pisos = []
    var numeroDePisoActual = 0
    var empezado = false

    method mostrarPantallaInicio() {
        pantallaInicio.mostrar()
        keyboard.enter().onPressDo({ self.avanzarInicio() })
        keyboard.space().onPressDo({ self.avanzarInicio() })
        game.onClickDo({ posicion => self.avanzarInicio() })
    }

    method avanzarInicio() {
        if (pantallaInicio.enMenu()) {
            self.empezar()
        } else {
            pantallaInicio.avanzar()
        }
    }

    method empezar() {
        if (not empezado) {
            empezado = true
            pantallaInicio.terminar()
            self.iniciar()
        }
    }

        method iniciar() {
            game.boardGround("fondoPiso.png")
            niveles.configurarPrimerPiso()
            niveles.configurarSegundoPiso()

            self.agregarPiso(niveles.primerPiso())
            self.agregarPiso(niveles.segundoPiso())

            niveles.segundoPiso().ocultarVisuales()

            jugador.establecerPiso(self.pisoActual())
            game.addVisual(jugador)
            keyboard.up().onPressDo({ jugador.moverArriba() })
            keyboard.down().onPressDo({ jugador.moverAbajo() })
            keyboard.left().onPressDo({ jugador.moverIzquierda() })
            keyboard.right().onPressDo({ jugador.moverDerecha() })
            self.iniciarActualizaciones()


            //Interaccion al presionar la tecla e, con escaleras, llaves y parciales.
            keyboard.e().onPressDo({
            self.pisoActual().interactuarCon(jugador)
            self.pisoActual().interactuarEscritoriosCercanos(jugador)
            self.pisoActual().interactuarEscaleraEn(
            jugador.position(), jugador, self)
            })
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
            jugador.position(self.pisoActual().posicionDeEntrada())
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
            jugador.establecerPiso(self.pisoActual())
            jugador.position(self.pisoActual().posicionDeEntrada())
            self.pisoActual().mostrarVisuales()
            }
        }
        method condicionOkDePasarEntrePisos(){
            return self.haySiguientePiso() && self.pisoActual().tieneTodosLosParcialesAgarrados()
        }
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