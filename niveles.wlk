import piso.*
import wollok.game.*
import profesores.*
object niveles {
    const pisoLettuceYOmar = new Piso(ancho = 15, largo = 10)
    
    method configurarPrimerPiso() {
        const piso = self.primerPiso()
          piso.agregarProfesor(profesores.omar(game.at(3, 3)))
          piso.agregarProfesor(profesores.lettuce(game.at(11, 3)))
    }

    method primerPiso() = pisoLettuceYOmar
}