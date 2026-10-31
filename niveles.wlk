import piso.*
import wollok.game.*
import profesores.*
import llave.*
import obstaculos.*
import escritorio.*
import escaleras.*

object niveles {
    const pisoLettuceYOmar = new Piso(ancho = 15, largo = 10)
    const llavePrimerPiso = new Llave(position = game.at(5, 5)) 
    const escritorioPrimerPiso = new Escritorio(position = game.at(5, 7),
    llave = llavePrimerPiso)
    const escaleraPrimerPiso = new Escalera(position = game.at(13, 8)) 

    method configurarPrimerPiso() {
        const piso = self.primerPiso()
          piso.agregarProfesor(profesores.omar(game.at(3, 3)))
          piso.agregarProfesor(profesores.lettuce(game.at(11, 3)))
          piso.agregarLlave(llavePrimerPiso)
          piso.agregarEscritorio(escritorioPrimerPiso)
          escritorioPrimerPiso.asignarLlave(llavePrimerPiso)
          piso.agregarEscalera(escaleraPrimerPiso)
          
          
    }

    method primerPiso() = pisoLettuceYOmar
}