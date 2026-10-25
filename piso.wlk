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
        method avanzarProyectiles(unAlumno) = proyectiles.avanzar(unAlumno)


        method actualizar(unAlumno) {
            self.actuarProfesores(unAlumno)
            self.avanzarProyectiles(unAlumno)
        }


        method reiniciarPiso() {
            self.reiniciarProfesores()
            self.reiniciarProyectiles()
            self.reiniciarObstaculos()
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



