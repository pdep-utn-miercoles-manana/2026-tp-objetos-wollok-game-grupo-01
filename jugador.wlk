import wollok.game.*
import profesores.*   // para usar tiempos.ticks(segundos)
import november.*

object movilidadNormal {
    method arriba(j)    { j.irArriba() }
    method abajo(j)     { j.irAbajo() }
    method izquierda(j) { j.irIzquierda() }
    method derecha(j)   { j.irDerecha() }
}

object movilidadInvertida {
    method arriba(j)    { j.irAbajo() }
    method abajo(j)     { j.irArriba() }
    method izquierda(j) { j.irDerecha() }
    method derecha(j)   { j.irIzquierda() }
}

object jugador {
    const posicionInicial = game.at(7, 4)
    const vidasIniciales = 3
    const framesPorMovimiento = 4

    var property position = posicionInicial
    var velocidad = 1
    var movilidad = movilidadNormal
    var mirandoA = "Derecha"
    var frame = 0
    var pendrive = null
    var pisoActual = null

    method establecerPiso(unPiso) {
        pisoActual = unPiso
    }
    method entrarAlPiso(unPiso) {
    self.establecerPiso(unPiso)
    position = unPiso.posicionDeEntrada()
    }

    // Si todavía no hay piso (por ejemplo en un test), uso los bordes del juego.
    method esTransitable(destino) {
        if (pisoActual == null) {
            return destino.x() >= 0 and destino.x() < game.width() &&
                   destino.y() >= 0 and destino.y() < game.height()
        }
        return pisoActual.esTransitable(destino)
    }

    var vidas = vidasIniciales
    var ticksCongelado = 0

    method guardarPendrive(unPendrive) {
        pendrive = unPendrive
    }

    method tienePendrive() = pendrive != null

    method usarPendrive(computadora) {
        if (self.tienePendrive()) {
            pendrive.usar(computadora)
            pendrive = null
        }
    }

    method verificarInteraccion() {
        if (pisoActual != null) {
            pisoActual.interactuarCon(self)
        }
    }
    method recuperarCorazon() {
    vidas = (vidas + 1).min(vidasIniciales)
    }


    // Ej: jugadorArriba1.png ... jugadorArriba4.png
    method image() = "jugador" + mirandoA + (frame + 1) + "jugadorArriba.png.jpg"

    // Si está congelado, ignora las teclas
    method moverArriba()    { if (self.puedeMoverse()) movilidad.arriba(self) }
    method moverAbajo()     { if (self.puedeMoverse()) movilidad.abajo(self) }
    method moverIzquierda() { if (self.puedeMoverse()) movilidad.izquierda(self) }
    method moverDerecha()   { if (self.puedeMoverse()) movilidad.derecha(self) }

    method puedeMoverse() = !self.estaCongelado()

    // Movimientos reales
    method irArriba()    { self.avanzar("Arriba",    { p => p.up(1) }) }
    method irAbajo()     { self.avanzar("Abajo",     { p => p.down(1) }) }
    method irIzquierda() { self.avanzar("Izquierda", { p => p.left(1) }) }
    method irDerecha()   { self.avanzar("Derecha",   { p => p.right(1) }) }

    // Avanza celda por celda (hasta `velocidad` celdas) y se frena en la primera
    // que no sea transitable. Siempre gira hacia donde apretaste, aunque no avance.
        method avanzar(sentido, siguiente) {
        const posicionAnterior = position
        const pasos = (1..velocidad)
        mirandoA = sentido
        pasos.forEach({ i =>
            const destino = siguiente.apply(position)
            if (self.esTransitable(destino)) {
                position = destino
                self.verificarInteraccion()
            }
        })
        if (position != posicionAnterior) { self.avanzarFrame() }
    }
    method avanzarFrame() { frame = (frame + 1) % framesPorMovimiento }

    // Controles
    method invertirControles()  { movilidad = movilidadInvertida }
    method restaurarControles() { movilidad = movilidadNormal }

    // Lo llaman tiza, borrador y huevo. Las vidas no bajan de 0.
    method recibirGolpe(cantidad) {
        vidas = (vidas - cantidad).max(0)
    }

    method vidas() = vidas
    method sinVidas() = vidas == 0

    // Lo llama el borrador. Si ya estaba congelado, se queda con el tiempo mayor.
    method congelarPor(segundos) {
        ticksCongelado = ticksCongelado.max(tiempos.ticks(segundos))
    }

    method estaCongelado() = ticksCongelado > 0

    method usarObjetosDeLaCelda() {
        game.colliders(self).forEach({ objeto => objeto.usar(self) })
    }
    // El piso lo llama una vez por tick (igual que a los profesores)
    method actuar() {
        if (self.estaCongelado()) {
            ticksCongelado -= 1
        }
    }

    // ---------- Reinicio ----------
    // Vuelve todo al estado inicial del piso
    method reiniciar() {
        position = posicionInicial
        movilidad = movilidadNormal
        velocidad = 1
        mirandoA = "Derecha"
        frame = 0
        vidas = vidasIniciales
        ticksCongelado = 0
        pendrive = null
    }
}