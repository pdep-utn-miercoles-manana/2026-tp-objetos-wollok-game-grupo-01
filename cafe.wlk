import obstaculos.*
class Cafe inherits Obstaculos {
    var usado = false

    method image() = "cafe.png"
    method usar(alumno) {
        if (!usado) {
            alumno.recuperarCorazon()
            usado = true
            game.removeVisual(self)
        }
    }

    override method reiniciar() {
        super()
        usado = false
        game.addVisual(self)
    }
}