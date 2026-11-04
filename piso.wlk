import wollok.game.* 
import profesores.*
import proyectiles.*
import obstaculos.*
/*Parte Pisos (Lucca): Mi parte consiste en modelar los pisos, 
la progresion entre niveles y las "mecanicas especiales" */

class Piso{

    const ancho 
    const largo 
    const margen = 0
    var property posicionDeEntrada = game.at(7, 4)
    var property fondo = "fondoPiso.png"
    const obstaculos = []
    const profesores = [] // no se puede poner como #{} ya que los gallitos son profesores y ellos son todos iguales
    const proyectiles = new Proyectiles()
    const parciales = []
    const parcialesConEscritorio = []
    const llaves = [] 
    const pendrives = []
    const escritorios = []
    const escaleras = []
    const cafes = []
    const panfletos = []
    const bancosMoviles = []
    var property requierePendrive = false
    const efectosDeParciales = []
    var escritorioConComputadora = null
    const talonarios = []

  
     method agregarBancoMovil(unBanco) {
        bancosMoviles.add(unBanco)
        self.agregarObstaculo(unBanco)
    }

    method actuarBancosMoviles() {
        bancosMoviles.
            forEach({ banco => banco.actuar() })
    }
    method estaDentroDelMapa(posicion){
                return self.requeridoDeAncho(posicion) &&  self.requeridoDeLargo(posicion)
    }
    method requeridoDeAncho(posicion){
            return posicion.x() >= margen && posicion.x() < ancho - margen
    }
    method requeridoDeLargo(posicion){
            return posicion.y() >= margen && posicion.y() < largo - margen
    }

    method esTransitable(unaPosicion){
         return self.estaDentroDelMapa(unaPosicion) && !(self.hayObstaculoEn(unaPosicion))
    }
    method hayObstaculoEn(unaPosicion){
        return obstaculos
                .any({obstaculo => obstaculo.position() == unaPosicion})
    }
            // Agregar obstáculos y mostrarlos en el tablero
    method agregarObstaculo(unObstaculo) {
            obstaculos.add(unObstaculo)
            game.addVisual(unObstaculo)
    }
    method agregarTalonario(unTalonario) {
         talonarios.add(unTalonario)
        self.agregarObstaculo(unTalonario)
    }
    method interactuarTalonariosCercanos(alumno) {
        talonarios
            .filter({ talonario => talonario.estaCercaDe(alumno) })
            .forEach({ talonario => talonario.interactuar() })
    }
       

        // Pared invisible para las celdas que el fondo muestra fuera del aula.
    method agregarPared(unaPosicion) {
        obstaculos.add(new Pared(position = unaPosicion))
    }

    method agregarProfesor(unPorfesor) = profesores.add(unPorfesor)
    method tieneProfesor(unProfesor){
         return profesores.contains(unProfesor)
    }

    method hayProfesorEn(unaPosicion, excepto) {
        return profesores.any({ p => p != excepto and p.position() == unaPosicion })
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
        self.dañarSiAtrapa(unAlumno)
        self.avanzarProyectiles(unAlumno)
        self.descartarProyectilesFueraDelPiso()

        if (escritorioConComputadora != null) {
        escritorioConComputadora.actualizar()
        }
    }

    method descartarProyectilesFueraDelPiso() = proyectiles.descartarFueraDe(self)

    method dañarSiAtrapa(unAlumno) {
        profesores
            .filter({ profesor => profesor.atrapa(unAlumno) })
            .forEach({ profesor => unAlumno.recibirGolpe(1) })
    }


    method reiniciarPiso() {
        self.reiniciarProfesores()
        self.reiniciarProyectiles()
        self.reiniciarObstaculos()
        self.reiniciarParciales()
        self.reiniciarLlaves()
        self.reiniciarCafes()
        self.reiniciarPanfletos()
        self.reiniciarPendrives()
    }
        
        // NACHO: aca te dejo el mensaje que tiene que entender proyectiles 
    method reiniciarProyectiles() = proyectiles.reiniciar()
        // NACHO: aca te dejo el mensaje que tiene que entender profesores
    method reiniciarProfesores(){
        profesores 
            .forEach({profesor => profesor.reiniciar()})
        self.limpiarMensajesDeProfesores()
    }

    method limpiarMensajesDeProfesores() {
        if (game.running()) {
            profesores.forEach({profesor => game.say(profesor, "")})
        }
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

    method interactuarEscaleraEn(alumno, unJuego) {
        escaleras
            .forEach({ escalera =>escalera.interactuar(alumno, unJuego)})
    }

    method interactuarAlPresionarE(alumno, unJuego) {
        self.interactuarCon(alumno)
        self.interactuarEscritoriosCercanos(alumno)
        self.interactuarTalonariosCercanos(alumno)
        self.interactuarEscaleraEn(alumno, unJuego)
    }

        //Sobre escritorio y llaves
         
    method agregarLlave(unaLlave) {
        llaves.add(unaLlave)
        game.addVisual(unaLlave)
    }
    method agregarPendrive(unPendrive) {
        pendrives.add(unPendrive)
        game.addVisual(unPendrive)
    }

    method agarrarPendriveEn(alumno) {
        pendrives
            .filter({ pendrive => pendrive.position() == alumno.position() &&not pendrive.fueRecogido()})
            .forEach({ pendrive => pendrive.agarrar(alumno) })
    }

    method agregarEscritorio(unEscritorio) {
           escritorios.add(unEscritorio)
            self.agregarObstaculo(unEscritorio)
    }
    method agregarEscritorioConComputadora(unEscritorio) {
            escritorioConComputadora = unEscritorio
            self.agregarEscritorio(unEscritorio)
    }

    method vincularParcialConComputadora(unParcial) {
        escritorioConComputadora.vincularParcial(unParcial)
    }

        method agarrarLlaveEn(unaPosicion) {
            llaves
            .filter({ llave => llave.position() == unaPosicion })
            .forEach({ llave => llave.agarrar() })
        }


    method interactuarEscritorioEn(unaPosicion, alumno) {
    escritorios
        .filter({ escritorio => escritorio.position() == unaPosicion })
        .forEach({ escritorio => escritorio.interactuar(alumno) })
     }
     method mostrarVisualSiFalta(elemento) {
        if (not game.hasVisual(elemento)) {
        game.addVisual(elemento)
                }
    }

    method ocultarVisualSiEsta(elemento) {
        if (game.hasVisual(elemento)) {
        game.removeVisual(elemento)
        }
    }

    method ocultarVisuales() {
    [profesores, obstaculos, llaves, escaleras, cafes, panfletos, parciales, pendrives, proyectiles.visuales()]
        .forEach({ coleccion => coleccion.forEach({ elemento => self.ocultarVisualSiEsta(elemento)})})
    }
    method mostrarVisuales() {
    [profesores, escaleras, cafes, panfletos, proyectiles.visuales()]
        .forEach({ coleccion => coleccion.forEach({ elemento => self.mostrarVisualSiFalta(elemento)})})

    obstaculos
        .filter({ obstaculo => not obstaculo.esPared() })
        .forEach({ obstaculo => self.mostrarVisualSiFalta(obstaculo)})

    llaves
        .filter({ llave => not llave.fueRecogida() })
        .forEach({ llave => self.mostrarVisualSiFalta(llave)})

    pendrives
        .filter({ pendrive => not pendrive.fueRecogido() })
        .forEach({ pendrive => self.mostrarVisualSiFalta(pendrive)})
    }  
    
    
    method interactuarEscritoriosCercanos(alumno) {
    escritorios
        .filter({ escritorio => escritorio.estaCercaDe(alumno) })
        .forEach({ escritorio =>
            if (not requierePendrive or alumno.tienePendrive()) {
                escritorio.interactuar(alumno)

                if (not escritorio.estaCerrado()) {
                    self.entregarParcialesDe(escritorio, alumno)
                }
            }
        })
    }

    
    method entregarParcialesDe(escritorio, alumno) {
        parcialesConEscritorio
            .filter({ relacion => relacion.get(1) == escritorio && not relacion.first().seAgarro()})
            .forEach({ relacion =>  const parcial = relacion.first() parcial.agarrar()

            efectosDeParciales
                .filter({ efecto => efecto.first() == parcial })
                .forEach({ efecto =>
                    efecto.get(1).apply(alumno)
                })

            if (game.running()) {
                game.say(escritorio, "¡Parcial conseguido!")
            }
        })
    }



    method interactuarCon(alumno) {
    self.agarrarLlaveEn(alumno.position())
    self.agarrarPendriveEn(alumno)
    self.agarrarCafeEn(alumno.position(), alumno)
    self.agarrarPanfletoEn(alumno.position(), alumno)
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
   method reiniciarPendrives() {
    pendrives.forEach({ pendrive => pendrive.reiniciar()
            if (game.running() and not game.hasVisual(pendrive)) {
                game.addVisual(pendrive)
            }
        })
    }
   

    method agregarCafe(unCafe) {
    cafes.add(unCafe)
    game.addVisual(unCafe)
   }

    method agregarPanfleto(unPanfleto) {
    panfletos.add(unPanfleto)
    game.addVisual(unPanfleto)
   }

    method usarObjetosEn(unaColeccion, unaPosicion, alumno) {
        unaColeccion
            .filter({ objeto => objeto.position() == unaPosicion })
            .forEach({ objeto => objeto.usar(alumno) })
    }

    method agarrarCafeEn(unaPosicion, alumno) {
        self.usarObjetosEn(cafes, unaPosicion, alumno)
    }

    method agarrarPanfletoEn(unaPosicion, alumno) {
        self.usarObjetosEn(panfletos, unaPosicion, alumno)
    }

       //Busca los parciales ubicados en la posición indicada y los marca como recogidos.
    method agarrarParcialEn(unaPosicion) {
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

    method vincularEfectoConParcial(unParcial, unEfecto) {
        efectosDeParciales.add([unParcial, unEfecto])
    }
}       



