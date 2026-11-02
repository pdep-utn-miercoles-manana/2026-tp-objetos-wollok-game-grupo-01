import piso.*
import wollok.game.*
import profesores.*
import llave.*
import obstaculos.*
import escritorio.*
import escaleras.*

object niveles {
    const pisoLettuceYOmar = new Piso(ancho = 20, largo = 12)
    const llavePrimerPiso = new Llave(position = game.at(5, 5)) 
    const escaleraPrimerPiso = new Escalera(position = game.at(19, 10)) 
    // Escritorio que contiene la llave
   const escritorioPrimerPiso = new Escritorio(
        position = game.at(5, 7)
    )

   //Declaración de los escritorios adicionales
    const escritorio2 = new Escritorio(position = game.at(2, 7))
    const escritorio3 = new Escritorio(position = game.at(5, 6))
    const escritorio4 = new Escritorio(position = game.at(8, 7))
    const escritorio5 = new Escritorio(position = game.at(11, 6))
    const escritorio6 = new Escritorio(position = game.at(3, 4))
    const escritorio7 = new Escritorio(position = game.at(6, 3))
    const escritorio8 = new Escritorio(position = game.at(9, 4))
    const escritorio9 = new Escritorio(position = game.at(14, 3))
    const escritorio10 = new Escritorio(position = game.at(4, 1))
    const escritorio11 = new Escritorio(position = game.at(9, 1))


    

    method configurarPrimerPiso() {
        const piso = self.primerPiso()
          piso.precargarProyectiles(20)
          piso.agregarProfesor(profesores.omar(game.at(3, 3)))
          piso.agregarProfesor(profesores.lettuce(game.at(11, 3)))
          piso.agregarLlave(llavePrimerPiso)
          escritorioPrimerPiso.asignarLlave(llavePrimerPiso)
          piso.agregarEscalera(escaleraPrimerPiso)
          
          // Agregamos los escritorios al mapa
        piso.agregarEscritorio(escritorioPrimerPiso)
        piso.agregarEscritorio(escritorio2)
        piso.agregarEscritorio(escritorio3)
        piso.agregarEscritorio(escritorio4)
        piso.agregarEscritorio(escritorio5)
        piso.agregarEscritorio(escritorio6)
        piso.agregarEscritorio(escritorio7)
        piso.agregarEscritorio(escritorio8)
        piso.agregarEscritorio(escritorio9)
        piso.agregarEscritorio(escritorio10)
        piso.agregarEscritorio(escritorio11)
    }

    method primerPiso() = pisoLettuceYOmar
}