import wollok.game.*
import jugador.*
import niveles.*
import profesores.*
import talonario.*
import pantallaInicio.*
import indicadorVidas.*
import sonidos.*
import pantallaGameOver.*
import pantallaVictoria.*
object juego{

    const pisos = []
    var numeroDePisoActual = 0
    var juegoGanado = false
    var empezado = false
    var enGameOver = false

    method mostrarPantallaInicio() {
        pantallaInicio.mostrar()
        keyboard.enter().onPressDo({ self.avanzarInicio() })
        keyboard.space().onPressDo({ self.avanzarInicio() })
        keyboard.m().onPressDo({ sonidos.alternarMute() })
        game.onClickDo({ posicion => self.avanzarInicio() })
    }

        method avanzarInicio() {
        if (not juegoGanado) {
            if (enGameOver) {
                self.reiniciarDespuesDeGameOver()
            } else {
                sonidos.iniciarMusica()
                if (pantallaInicio.enMenu()) {
                    self.empezar()
                } else {
                    pantallaInicio.avanzar()
                }
            }
        }
    }

    method empezar() {
        if (not empezado) {
            empezado = true
            sonidos.iniciarMusica()
            pantallaInicio.terminar()
            self.iniciar()
        }
    }

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
            game.boardGround(self.pisoActual().fondo())

            jugador.entrarAlPiso(self.pisoActual())
            game.addVisual(jugador)
            game.addVisual(indicadorVidas)
            keyboard.up().whilePressedDo({ if (self.jugando()) jugador.moverArriba() }, 100)
            keyboard.down().whilePressedDo({ if (self.jugando()) jugador.moverAbajo() }, 100)
            keyboard.left().whilePressedDo({ if (self.jugando()) jugador.moverIzquierda() }, 100)
            keyboard.right().whilePressedDo({ if (self.jugando()) jugador.moverDerecha() }, 100)
            keyboard.m().onPressDo({ sonidos.alternarMute() })
            keyboard.q().onPressDo({ self.salir() })
            keyboard.enter().onPressDo({ self.avanzarInicio() })
            keyboard.space().onPressDo({ self.avanzarInicio() })
            game.onClickDo({ posicion => self.avanzarInicio() })
            self.iniciarActualizaciones()


            //Interaccion al presionar la tecla e, con escaleras, llaves y parciales.
            keyboard.e().onPressDo({ if (not enGameOver) self.pisoActual().interactuarAlPresionarE(jugador, self) })
            keyboard.backspace().onPressDo({pantallaGuia.cerrar()})
        }
            
        method agregarPiso(unPiso) = pisos.add(unPiso)
        method cantidadDePisos() = pisos.size()
        method salir() {
            sonidos.detenerMusica()
            game.stop()
        }
        method pisoActual(){
            return pisos.get(numeroDePisoActual)
        }

        method iniciarActualizaciones() {
          const tick = game.tick(tiempos.milisegundosPorTick(), {
            if (self.jugando()) {
                self.pisoActual().actualizar(jugador)
                jugador.actuar()
                self.verificarDerrota()
            }
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
                enGameOver = false
                pantallaGameOver.ocultar()
        }

              method avanzarEntrePiso() {
            if (self.condicionOkDePasarEntrePisos()) {
                self.pisoActual().ocultarVisuales()
                numeroDePisoActual += 1
                game.boardGround(self.pisoActual().fondo())
                jugador.entrarAlPiso(self.pisoActual())
                self.pisoActual().mostrarVisuales()
            } else {
                if (not self.haySiguientePiso() &&
                self.pisoActual().tieneTodosLosParcialesAgarrados() &&
                not juegoGanado) {
                    self.mostrarVictoria()
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
            if (jugador.sinVidas() and not enGameOver) {
                self.mostrarGameOver()
            }
        }

        method estaEnGameOver() = enGameOver

        method mostrarGameOver() {
            enGameOver = true
            self.pisoActual().limpiarMensajesDeProfesores()
            sonidos.detenerMusica()
            sonidos.efecto("gameover.wav")
            pantallaGameOver.mostrar()
        }

        method reiniciarDespuesDeGameOver() {
            pantallaGameOver.ocultar()
            enGameOver = false
            self.reiniciarPisoActual()
            sonidos.iniciarMusica()
        }
            method jugando() = not enGameOver and not juegoGanado

            method mostrarVictoria() {
            juegoGanado = true
            sonidos.detenerMusica()
            sonidos.efecto("ganar.wav")
            pantallaGuia.cerrar()
            self.pisoActual().limpiarMensajesDeProfesores()
            self.pisoActual().ocultarVisuales()
            game.removeVisual(jugador)
            game.removeVisual(indicadorVidas)
            pantallaVictoria.mostrar()
        }
    

}