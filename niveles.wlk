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
    const escaleraPrimerPiso = new Escalera(position = game.at(19, 10)) 
    // Escritorio que contiene la llave
   const escritorioPrimerPiso = new Escritorio(
        position = game.at(18, 5)
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