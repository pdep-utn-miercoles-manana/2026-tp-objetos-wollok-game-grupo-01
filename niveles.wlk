import piso.*
import wollok.game.*
import profesores.*
import llave.*
import obstaculos.*
import escritorio.*
import escaleras.*
import bancoMovil.*
import parcial.*

object niveles {
    const pisoLettuceYOmar = new Piso(ancho = 20, largo = 12)
    const pisoGallo = new Piso( ancho = 20, largo = 12, posicionDeEntrada = game.at(2, 2))
    const llaveSegundoPiso = new Llave(position = game.at(4, 4))
    const escritorioSegundoPiso = new Escritorio(position = game.at(6, 6),llave = llaveSegundoPiso)
    const llavePrimerPiso = new Llave(position = game.at(5, 5)) 
    const escritorioPrimerPiso = new Escritorio(position = game.at(5, 7),
    llave = llavePrimerPiso)
    const escaleraPrimerPiso = new Escalera(position = game.at(13, 8)) 

    method configurarPrimerPiso() {
        const piso = self.primerPiso()
          piso.precargarProyectiles(20)
         //piso.agregarProfesor(profesores.omar(game.at(3, 3)))
         // piso.agregarProfesor(profesores.lettuce(game.at(11, 3)))
          piso.agregarLlave(llavePrimerPiso)
          piso.agregarEscritorio(escritorioPrimerPiso)
          const parcialPrimerPiso = new Parcial(position = game.at(6, 7))
          piso.agregarParcial(parcialPrimerPiso)
          piso.vincularParcialConEscritorio(parcialPrimerPiso, escritorioPrimerPiso)
          const banco = new BancosMoviles(position = game.at(9, 5))
          piso.agregarObstaculo(banco)
          escritorioPrimerPiso.asignarLlave(llavePrimerPiso)
          piso.agregarEscalera(escaleraPrimerPiso)
    }
    method configurarSegundoPiso() {
        const piso = self.segundoPiso()
        llaveSegundoPiso.initialize()
        escritorioSegundoPiso.initialize()

        // piso.agregarProfesor(profesores.gallo(game.at(15, 8)))
        // piso.agregarProfesor(profesores.gallito(game.at(7, 5)))
        // piso.agregarProfesor(profesores.gallito(game.at(12, 5)))
        
        const banco1 = new BancosMoviles(position = game.at(8, 3))
        const banco2 = new BancosMoviles(position = game.at(10, 7))
        const banco3 = new BancosMoviles(position = game.at(13, 9))

        banco1.initialize()
        banco2.initialize()
        banco3.initialize()

        piso.agregarObstaculo(banco1)
        piso.agregarObstaculo(banco2)
        piso.agregarObstaculo(banco3)
        piso.agregarLlave(llaveSegundoPiso)
        piso.agregarEscritorio(escritorioSegundoPiso)
        const parcialSegundoPiso = new Parcial(position = game.at(6, 6))
        piso.agregarParcial(parcialSegundoPiso)
        piso.vincularParcialConEscritorio(parcialSegundoPiso, escritorioSegundoPiso)
        const escaleraSegundoPiso = new Escalera(position = game.at(17, 10))
        piso.agregarEscalera(escaleraSegundoPiso)
    }   

    method primerPiso() = pisoLettuceYOmar
    method segundoPiso() = pisoGallo
}