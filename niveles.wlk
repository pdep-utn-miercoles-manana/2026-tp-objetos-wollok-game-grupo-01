import piso.*
import wollok.game.*
import profesores.*
import llave.*
import obstaculos.*
import escritorio.*
import escritorioConComputadora.*
import escaleras.*
import bancoMovil.*
import parcial.*
import bancoFijo.*
import cafe.*
import panfleto.*
import pendrive.*
import talonario.*

object niveles {
    const plantaBaja = new Piso(ancho = 20,largo = 12,posicionDeEntrada = game.at(2, 2))
    const pisoLettuceYOmar = new Piso(ancho = 20, largo = 12, posicionDeEntrada = game.at(5,2))
    const pisoGallo = new Piso( ancho = 20, largo = 12, posicionDeEntrada = game.at(7, 4))
    const pisoFilipoYFermin = new Piso(ancho = 20,largo = 12,posicionDeEntrada = game.at(2, 2))
    const llaveTercerPiso = new Llave(position = game.at(4, 4))
    const escritorioTercerPiso = new Escritorio(position = game.at(16, 9))
    const llaveSegundoParcial = new Llave(position = game.at(11, 4))
    const escritorioSegundoParcial = new Escritorio(position = game.at(12, 8))
    const llaveSegundoPiso = new Llave(position = game.at(6, 4))
    const escritorioSegundoPiso = new Escritorio(position = game.at(6, 6),llave = llaveSegundoPiso)
    const llavePrimerPiso = new Llave(position = game.at(5, 5)) 
    const escaleraPrimerPiso = new Escalera(position = game.at(19, 9)) 
    // Escritorio que contiene la llave
   const escritorioPrimerPiso = new Escritorio(
        position = game.at(18, 5)
    )

   //Declaración de los escritorios adicionales
    const escritorio2 = new Escritorio(position = game.at(12, 7))
    const escritorio3 = new Escritorio(position = game.at(10, 8))
    const escritorio4 = new Escritorio(position = game.at(8, 7))
    const escritorio5 = new Escritorio(position = game.at(15, 8))
    const escritorio6 = new Escritorio(position = game.at(11, 4))
    const escritorio7 = new Escritorio(position = game.at(6, 3))
    const escritorio8 = new Escritorio(position = game.at(9, 4))
    const escritorio9 = new Escritorio(position = game.at(14, 3))
    const escritorio10 = new Escritorio(position = game.at(10, 6))
    const escritorio11 = new Escritorio(position = game.at(9, 1))




    method agregarParedesDelFondo(unPiso) {
        // El fondo tiene un hueco negro abajo a la izquierda: esas celdas no
        // son parte del aula, así que las bloqueo con paredes invisibles.
        (0..5).forEach({ x =>
            (0..4).forEach({ y => unPiso.agregarPared(game.at(x, y)) })
        })
    }


    method configurarPlantaBaja() {
        const piso = self.pisoPlantaBaja()

        const escaleraPlantaBaja = new Escalera(position = game.at(17, 10))

        piso.agregarEscalera(escaleraPlantaBaja)
        const talonario = new Talonario(position = game.at(5, 4))

        talonario.initialize()
        piso.agregarTalonario(talonario)
    }

    method configurarPrimerPiso() {
        const piso = self.primerPiso()
          piso.precargarProyectiles(20)
          self.agregarParedesDelFondo(piso)
          //piso.agregarProfesor(profesores.omar(game.at(7, 2)))
          //piso.agregarProfesor(profesores.lettuce(game.at(11, 3)))
          piso.agregarLlave(llavePrimerPiso)
          piso.agregarEscritorio(escritorioPrimerPiso)
          const parcialPrimerPiso = new Parcial(position = game.at(6, 7))
          piso.agregarParcial(parcialPrimerPiso)
          piso.vincularParcialConEscritorio(parcialPrimerPiso, escritorioPrimerPiso)
          const banco = new BancosMoviles(position = game.at(7, 5))
          
           const cafePrimerPiso = new Cafe(position = game.at(4, 8))
           piso.agregarCafe(cafePrimerPiso)

        
          const panfletoPrimerPiso = new Panfleto(position = game.at(2, 8))
          piso.agregarPanfleto(panfletoPrimerPiso)
        
          const bancoFijo1 = new BancosFijos(position = game.at(11, 8))
          piso.agregarObstaculo(bancoFijo1)
          const bancoFijo2 = new BancosFijos(position = game.at(10, 1))
          piso.agregarObstaculo(bancoFijo2)
          piso.agregarBancoMovil(banco)          escritorioPrimerPiso.asignarLlave(llavePrimerPiso)
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
        self.agregarParedesDelFondo(piso)
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
    method configurarTercerPiso() {
     const piso = self.tercerPiso()
     const pendriveTercerPiso = new Pendrive(position = game.at(3, 9))
     pendriveTercerPiso.initialize()
     piso.agregarPendrive(pendriveTercerPiso)
     const filipo = profesores.filipo(game.at(15, 3))
     piso.agregarProfesor(filipo)
     const fermin = profesores.fermin(game.at(5, 8))
     piso.agregarProfesor(fermin)
        const banco1 = new BancosMoviles(position = game.at(7, 3))
        const banco2 = new BancosMoviles(position = game.at(10, 6))
        const banco3 = new BancosMoviles(position = game.at(14, 8))

        banco1.initialize()
        banco2.initialize()
        banco3.initialize()
        escritorioTercerPiso.initialize()
        llaveTercerPiso.initialize()
        llaveSegundoParcial.initialize()
        escritorioSegundoParcial.initialize()
        

        piso.agregarObstaculo(banco1)
        piso.agregarObstaculo(banco2)
        piso.agregarObstaculo(banco3)
        piso.agregarLlave(llaveTercerPiso)
        piso.agregarEscritorio(escritorioTercerPiso)
        const parcialTercerPiso = new Parcial(position = game.at(16, 9))
        piso.agregarParcial(parcialTercerPiso)
        piso.vincularParcialConEscritorio(parcialTercerPiso, escritorioTercerPiso)
        escritorioSegundoParcial.asignarLlave(llaveSegundoParcial)
        piso.agregarLlave(llaveSegundoParcial)
        piso.agregarEscritorio(escritorioSegundoParcial)
        const parcialSegundo = new Parcial(position = game.at(12, 8))
        piso.agregarParcial(parcialSegundo)
        piso.vincularParcialConEscritorio(parcialSegundo, escritorioSegundoParcial)
        piso.vincularEfectoConParcial(parcialTercerPiso, { alumno =>alumno.invertirControles()
             if (game.running()) {
              game.say(filipo, "¡Ahí tenés un .flip!")
               }
            })
        piso.vincularEfectoConParcial(parcialSegundo, { alumno =>alumno.congelarPor(2)
            if (game.running()) {
                game.say(fermin, "¡Ahí tenés un chiflido!")
                }
            })
        escritorioTercerPiso.asignarLlave(llaveTercerPiso)
        const escritorioComputadora = new EscritorioConComputadora(position = game.at(8, 9))
        escritorioComputadora.initialize() 
        piso.agregarEscritorioConComputadora(escritorioComputadora)
        const parcialPendrive = new Parcial(position = game.at(8, 9))
        piso.agregarParcial(parcialPendrive)
        piso.vincularParcialConComputadora(parcialPendrive)
        const escaleraFinal = new Escalera(position = game.at(18, 10))
        piso.agregarEscalera(escaleraFinal)

    }

    method primerPiso() = pisoLettuceYOmar
    method segundoPiso() = pisoGallo
    method tercerPiso() = pisoFilipoYFermin
    method pisoPlantaBaja() = plantaBaja
}