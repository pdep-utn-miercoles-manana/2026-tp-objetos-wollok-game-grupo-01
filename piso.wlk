import profesores.*
import proyectiles.*
/*Parte Pisos (Lucca): Mi parte consiste en modelar los pisos, 
la progresion entre niveles y las "mecanicas especiales" */

class Piso{

    const ancho 
    const largo 
    const obstaculos = []
    const profesores = [] // no se puede poner como #{} ya que los gallitos son profesores y ellos son todos iguales
    const proyectiles = new Proyectiles()
    const parciales = []
    const llaves = []
    const escritorios = []
    const escaleras = []

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
        method agregarObstaculo(unObstaculo) = obstaculos.add(unObstaculo)
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
        method avanzarProyectiles(unAlumno) {
            proyectiles.avanzar(unAlumno)
            proyectiles.descartarFueraDe(self)
        }


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
            obstaculos 
                    .forEach({obstaculo => obstaculo.reiniciar()})
    }

       //Sobre escaleras
    method agregarEscalera(unaEscalera) {
       escaleras.add(unaEscalera)
       obstaculos.add(unaEscalera)
    }

    method interactuarEscaleraEn(unaPosicion, alumno, unJuego) {
       escaleras.filter({ escalera => escalera.position() == unaPosicion }).forEach({ escalera => escalera.interactuar(alumno, unJuego) })
    }

        //Sobre escritorio y llaves
         
    method agregarLlave(unaLlave) {
        llaves.add(unaLlave)
    }

    method agregarEscritorio(unEscritorio) {
       obstaculos.add(unEscritorio)
       escritorios.add(unEscritorio)
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

    method interactuarCon(alumno) {
    self.recogerLlaveEn(alumno.position())
    self.recogerParcialEn(alumno.position())
    self.interactuarEscritorioEn(alumno.position(), alumno)
    }

   method reiniciarLlaves() {
    llaves.forEach({ llave => llave.reiniciar() })
   }


    //Busca los parciales ubicados en la posición indicada y los marca como recogidos.
    method recogerParcialEn(unaPosicion) {
        parciales
        .filter({ parcial => parcial.position() == unaPosicion })
        .forEach({ parcial => parcial.agarrar() })
    }
       
       //Reinicia los parciales
    method reiniciarParciales() {
        parciales
         .filter({ parcial => parcial.seAgarro() })
         .forEach({ parcial => parcial.reiniciar() })
    }

        // <----- Condicion para pasar de nivel -----> 

    method agregarParcial(unParcial) = parciales.add(unParcial)
        
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



