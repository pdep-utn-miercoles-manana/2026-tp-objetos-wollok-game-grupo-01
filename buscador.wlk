// BFS para que los profes no se traben con las paredes.
// Le pregunto al piso si una celda se puede pisar.
//
// Dos cosas que aprendí a la mala:
// - Wollok no tiene while, así que la cola la proceso con recursión.
// - No puedo comparar una Position con null (explota), así que si no hay
//   camino devuelvo el origen y listo.

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
    return self.buscar([[origen, origen]], [origen], origen, destino, piso)
  }

  // La cola guarda pares [celda, primer paso desde el origen].
  // Cuando saco el destino, el primer paso guardado es la respuesta.
  method buscar(pendientes, visitados, origen, destino, piso) {
    if (pendientes.isEmpty()) { return origen }

    const actual = pendientes.first()
    const celda = actual.first()
    const primerPaso = actual.last()

    if (celda == destino) { return primerPaso }

    const nuevos = self.vecinos(celda, piso, destino).filter({ v => not visitados.contains(v) })
    nuevos.forEach({ v => visitados.add(v) })
    nuevos.forEach({ v => pendientes.add([v, if (celda == origen) v else primerPaso]) })

    return self.buscar(pendientes.filter({ p => p != actual }), visitados, origen, destino, piso)
  }
}
