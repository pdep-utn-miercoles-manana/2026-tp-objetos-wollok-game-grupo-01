import piso.*
import wollok.game.*
import profesores.*
import llave.*
import escritorio.*
import parcial.*
import bancoFijo.*
object niveles {
    const pisoLettuceYOmar = new Piso(ancho = 20, largo = 12)
    
    method configurarPrimerPiso() {
        const piso = self.primerPiso()
          piso.agregarProfesor(profesores.omar(game.at(3, 3)))
          //piso.agregarProfesor(profesores.lettuce(game.at(11, 3)))
        const banco = new BancosFijos(position = game.at(9, 5))
          banco.initialize(game.at(9, 5))
          piso.agregarObstaculo(banco)
          game.addVisual(banco)
        const llave = new Llave(position = game.at(5, 5))
          piso.agregarLlave(llave)
          game.addVisual(llave)
        const escritorio = new Escritorio(position = game.at(7, 5), llave = llave)
          escritorio.initialize(game.at(7, 5))
          escritorio.asignarLlave(llave)
          piso.agregarEscritorio(escritorio)
        const parcial = new Parcial(position = game.at(8, 5))
          piso.agregarParcial(parcial)
    }

    method primerPiso() = pisoLettuceYOmar
}