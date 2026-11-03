// BFS para que los profes no se traben con las paredes.
// Le pregunto al piso si una celda se puede pisar.
//
// Wollok no tiene while, así que la cola la proceso con recursión.
// No puedo comparar una Position con null (explota), así que si no hay
// camino devuelvo el origen y listo.
//
// La cola la recorro con un índice en vez de ir sacando el primero: así no
// copio la lista en cada paso. Los visitados van en un Set para que contains
// sea O(1) y el BFS no se ponga pesado con dos o más profesores.

object buscadorDeCaminos {

  // Las cuatro de al lado, menos las que no se pueden pisar.
  // El destino lo dejo pasar aunque no sea transitable.
  method vecinos(posicion, piso, destino) {
    const candidatas = [posicion.up(1), posicion.down(1), posicion.left(1), posicion.right(1)]
    return candidatas.filter({ p => piso.esTransitable(p) or p == destino })
  }

  // Devuelvo el primer paso del camino más corto.
  // Si ya está en el destino, o no hay camino, se queda donde está.
  method primerPasoHacia(origen, destino, piso) {
    if (origen == destino) { return origen }

    if (self.caminoDirectoLibre(origen, destino, piso)) {
        if (origen.x() != destino.x()) {
            return if (origen.x() < destino.x())
                origen.right(1)
            else
                origen.left(1)
        }

        return if (origen.y() < destino.y())
            origen.up(1)
        else
            origen.down(1)
    }
    
    return self.buscar([[origen, origen]], 0, #{origen}, origen, destino, piso)
}
    method caminoDirectoLibre(actual, destino, piso) {
    if (actual.x() == destino.x()) {
        return self.caminoVerticalLibre(actual, destino, piso)
    }

    const siguiente = if (actual.x() < destino.x())
        actual.right(1)
    else
        actual.left(1)

    return piso.esTransitable(siguiente)
        && self.caminoDirectoLibre(siguiente, destino, piso)
}

method caminoVerticalLibre(actual, destino, piso) {
    if (actual.y() == destino.y()) {
        return true
    }

    const siguiente = if (actual.y() < destino.y())
        actual.up(1)
    else
        actual.down(1)

    return piso.esTransitable(siguiente)
        && self.caminoVerticalLibre(siguiente, destino, piso)
}

// nuevo (lucca)
  method buscar(pendientes, indice, visitados, origen, destino, piso) {
    const indiceFinal = (indice..1000).findOrElse({ i =>
        if (i >= pendientes.size()) {
            true
        } else {
            const actual = pendientes.get(i)
            const celda = actual.first()
            const primerPaso = actual.last()

            if (celda == destino) {
                true
            } else {
                const nuevos = self.vecinos(celda, piso, destino)
                    .filter({ v => not visitados.contains(v) })

                nuevos.forEach({ v => visitados.add(v) })
                nuevos.forEach({ v =>
                    pendientes.add([v, if (celda == origen) v else primerPaso])
                })

                false
            }
        }
    }, { -1 })

    return if (
        indiceFinal >= 0 &&
        indiceFinal < pendientes.size() &&
        pendientes.get(indiceFinal).first() == destino
    )
        pendientes.get(indiceFinal).last()
    else
        origen
}



  // // La cola guarda pares [celda, primer paso desde el origen].
  // // Cuando saco el destino, el primer paso guardado es la respuesta.
  // method buscar(pendientes, indice, visitados, origen, destino, piso) {
  //   if (indice >= pendientes.size()) { return origen }
  //   // Por las dudas: si algo raro hace crecer la cola, corto acá y no bloqueo el juego.
  //   if (visitados.size() > 1000) { return origen }

  //   const actual = pendientes.get(indice)
  //   const celda = actual.first()
  //   const primerPaso = actual.last()

  //   if (celda == destino) { return primerPaso }

  //   const nuevos = self.vecinos(celda, piso, destino).filter({ v => not visitados.contains(v) })
  //   nuevos.forEach({ v => visitados.add(v) })
  //   nuevos.forEach({ v => pendientes.add([v, if (celda == origen) v else primerPaso]) })

  //   return self.buscar(pendientes, indice + 1, visitados, origen, destino, piso)
  // }
}

class BusquedaIncremental {
    const origen
    const destino
    const piso

    const pendientes = []
    const visitados = #{}

    var indice = 0
    var finalizada = false
    var primerPaso = null
    const rutaInvertida = []

    method initialize() {
        pendientes.add([origen, origen])
        visitados.add(origen)
        primerPaso = origen
    }

    method avanzar() {
        (1..5).forEach({ i => self.procesarUnaCelda() })
    }

    method procesarUnaCelda() {
        if (not finalizada) {
            if (indice >= pendientes.size()) {
                finalizada = true
            } else {
                const actual = pendientes.get(indice)
                indice += 1

                const posicion = actual.first()
                const primerPasoActual = actual.get(1)

                if (posicion == destino) {
                      primerPaso = primerPasoActual
                      self.guardarRuta(actual)
                      finalizada = true
                    } else {
                    const nuevos = buscadorDeCaminos.vecinos(posicion, piso, destino)
                        .filter({ p => not visitados.contains(p) })

                    nuevos.forEach({ p =>
                        visitados.add(p)
                        pendientes.add([
                          p,
                          if (posicion == origen) p else primerPasoActual,
                          actual
                        ])
                    })
                }
            }
        }
    }
method guardarRuta(nodo) {
    if (nodo.first() != origen) {
        rutaInvertida.add(nodo.first())
        self.guardarRuta(nodo.get(2))
    }
}

    method ruta() = rutaInvertida
    method tienePasosPendientes() = not rutaInvertida.isEmpty()

    method siguientePaso() = rutaInvertida.last()

    method consumirSiguientePaso() {
    const siguiente = rutaInvertida.last()
    rutaInvertida.remove(siguiente)
    return siguiente
      }
    method estaFinalizada() = finalizada

    method resultado() = primerPaso
}
