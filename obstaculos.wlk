class Obstaculos {
    var property position
    var posicionInicial = null

    method initialize() {
        posicionInicial = position
    }

    method reiniciar() {
        position = posicionInicial
    }

    method esPared() = false
}

// Límite invisible: marca celdas que se ven fuera del aula en el fondo.
class Pared inherits Obstaculos {
    override method esPared() = true
}

