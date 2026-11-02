import wollok.game.* 
import profesores.*
import proyectiles.*
import obstaculos.*
/*Parte Pisos (Lucca): Mi parte consiste en modelar los pisos, 
la progresion entre niveles y las "mecanicas especiales" */

class Piso{

    const ancho 
    const largo 
    var property posicionDeEntrada = game.at(7, 4)
    const obstaculos = []
    const profesores = [] // no se puede poner como #{} ya que los gallitos son profesores y ellos son todos iguales
    const proyectiles = new Proyectiles()
    const parciales = []
    const parcialesConEscritorio = []
    const llaves = [] 
    const escritorios = []
    const escaleras = []
    const cafes = []
    const panfletos = []

        method estaDentroDelMapa(posicion){
                return self.requeridoDeAncho(posicion) &&  self.requeridoDeLargo(posicion)
        }
        method requeridoDeAncho(posicion){
            return posicion.x() >= 0 && posicion.x() < ancho
        }
        method requeridoDeLargo(posicion){
            return posicion.y() >= 0 && posicion.y() < largo
        }

        method esTransitable(unaPosicion){
                return self.estaDentroDelMapa(unaPosicion) && !(self.hayObstaculoEn(unaPosicion))
        }
        method hayObstaculoEn(unaPosicion){
             return  obstaculos
                        .any({obstaculo => obstaculo.position() == unaPosicion})
        }
            // Agregar obstáculos y mostrarlos en el tablero
            method agregarObstaculo(unObstaculo) {
            obstaculos.add(unObstaculo)
            game.addVisual(unObstaculo)
        }

        method agregarProfesor(unPorfesor) = profesores.add(unPorfesor)
        method tieneProfesor(unProfesor){
             return profesores.contains(unProfesor)
        }
        method actuarProfesores(unAlumno){
            profesores
                    .forEach({profesor => profesor.actuar(unAlumno,self)})
        }

        // <---- Sobre Proyectiles ---->
        method agregarProyectil(unProyectil) = proyectiles.agregar(unProyectil)
        method cantidadDeProyectiles() = proyectiles.cantidad()
        method avanzarProyectiles(unAlumno) = proyectiles.avanzar(unAlumno)
        method precargarProyectiles(cantidad) = proyectiles.precargar(cantidad)


        method actualizar(unAlumno) {
            self.actuarProfesores(unAlumno)
            self.avanzarProyectiles(unAlumno)
        }


        method reiniciarPiso() {
            self.reiniciarProfesores()
            self.reiniciarProyectiles()
            self.reiniciarObstaculos()
            self.reiniciarParciales()
            self.reiniciarLlaves()
            self.reiniciarCafes()
            self.reiniciarPanfletos()
        }
        
        // NACHO: aca te dejo el mensaje que tiene que entender proyectiles 
        method reiniciarProyectiles() = proyectiles.reiniciar()
        // NACHO: aca te dejo el mensaje que tiene que entender profesores
        method reiniciarProfesores(){
            profesores 
                .forEach({profesor => profesor.reiniciar()})
        }
        // MARIA : aca te dejo el mensaje que tiene que entender obstaculos
        method reiniciarObstaculos(){
            obstaculos.forEach({obstaculo => obstaculo.reiniciar()})
        }

        // Sobre escaleras
        method agregarEscalera(unaEscalera) {
        escaleras.add(unaEscalera)
        game.addVisual(unaEscalera)
        }

       method interactuarEscaleraEn(unaPosicion, alumno, unJuego) {
       escaleras.filter({ escalera => escalera.position() == unaPosicion })
       .forEach({ escalera => escalera.interactuar(alumno, unJuego) })
       }

        //Sobre escritorio y llaves
         
        method agregarLlave(unaLlave) {
        llaves.add(unaLlave)
        game.addVisual(unaLlave)
       }

       method agregarEscritorio(unEscritorio) {
        escritorios.add(unEscritorio)
        obstaculos.add(unEscritorio)
        game.addVisual(unEscritorio)
        }

     method recogerLlaveEn(unaPosicion) {
     llaves
     .filter({ llave => llave.position() == unaPosicion })
     .forEach({ llave => llave.agarrar() })
     }


    method interactuarEscritorioEn(unaPosicion, alumno) {
    escritorios
        .filter({ escritorio => escritorio.position() == unaPosicion })
        .forEach({ escritorio => escritorio.interactuar(alumno) })
     }

    method ocultarVisuales() {
        [profesores, obstaculos, escritorios, llaves,
        escaleras, cafes, panfletos, parciales]
                .forEach({ coleccion =>
                 coleccion.forEach({ elemento =>
                    if (game.hasVisual(elemento)) {
                    game.removeVisual(elemento)
                    }
                })
            })
        
    }
    method mostrarVisuales() {
        [profesores, obstaculos, escritorios,
        escaleras, cafes, panfletos]
            .forEach({ coleccion =>
                coleccion.forEach({ elemento =>
                if (not game.hasVisual(elemento)) {
                    game.addVisual(elemento)
                }
            })
        })

        llaves
            .filter({ llave => not llave.fueRecogida() })
            .forEach({ llave =>
             if (not game.hasVisual(llave)) {
                game.addVisual(llave)
            }
        })
    }   
    method interactuarEscritoriosCercanos(alumno) {
        escritorios
            .filter({ escritorio =>
                (escritorio.position().x() - alumno.position().x()).abs() +
                (escritorio.position().y() - alumno.position().y()).abs() == 1
            })
            .forEach({ escritorio =>
                escritorio.interactuar(alumno)

               if (not escritorio.estaCerrado()) {
                parcialesConEscritorio
                    .filter({ relacion =>
                        relacion.get(1) == escritorio &&
                        not relacion.first().seAgarro()
                        })
                    .forEach({ relacion =>
                        relacion.first().agarrar()
                        if (game.running()) {
                            game.say(escritorio, "¡Parcial conseguido!")
                             }
                        })
                }
             })
    }

    method interactuarCon(alumno) {
    self.recogerLlaveEn(alumno.position())
    self.recogerCafeEn(alumno.position(), alumno)
    self.recogerPanfletoEn(alumno.position(), alumno)
    self.interactuarEscritorioEn(alumno.position(), alumno)
    }


   method reiniciarLlaves() {
    llaves.forEach({ llave => llave.reiniciar() })
   }
   
   method reiniciarCafes() {
   cafes.forEach({ cafe => cafe.reiniciar() })
   }

   method reiniciarPanfletos() {
   panfletos.forEach({ panfleto => panfleto.reiniciar() })
   }

    method agregarCafe(unCafe) {
    cafes.add(unCafe)
    game.addVisual(unCafe)
   }

    method agregarPanfleto(unPanfleto) {
    panfletos.add(unPanfleto)
    game.addVisual(unPanfleto)
   }

    method recogerCafeEn(unaPosicion, alumno) {
    cafes
        .filter({ cafe => cafe.position() == unaPosicion })
        .forEach({ cafe => cafe.usar(alumno) })
  }

  method recogerPanfletoEn(unaPosicion, alumno) {
    panfletos
        .filter({ panfleto => panfleto.position() == unaPosicion })
        .forEach({ panfleto => panfleto.usar(alumno) })
  }

       //Busca los parciales ubicados en la posición indicada y los marca como recogidos.
         method recogerParcialEn(unaPosicion) {
         parciales
        .filter({ parcial => parcial.position() == unaPosicion })
        .forEach({ parcial => parcial.agarrar() })
         }
       
       //Reinicia los parciales
       method reiniciarParciales() {
         parciales.forEach({ parcial =>
        parcial.reiniciar()
        game.removeVisual(parcial)
        })
        }

        // <----- Condicion para pasar de nivel -----> 

        method agregarParcial(unParcial) = parciales.add(unParcial)

        method vincularParcialConEscritorio(unParcial, unEscritorio) {
            parcialesConEscritorio.add([unParcial, unEscritorio])
        }
        method tieneParcial(unParcial) {
            return parciales.contains(unParcial)
        }
        method tieneTodosLosParcialesAgarrados(){
            return self.noHayParcialesEnElPiso() && self.quedaAlgunParcial()
        }
        method noHayParcialesEnElPiso(){
            return parciales
                .all({parcial => parcial.seAgarro()})
        }
        method quedaAlgunParcial(){
            return !(parciales.isEmpty())
        }


}       



