import obstaculos.*
class Panfleto inherits Obstaculos {
    var usado = false

    method image() = "panfleto.png"
    method usar(alumno) {
        if (!usado) {
            usado = true
            game.removeVisual(self)
        }
    }

    override method reiniciar() {
        super()
        usado = false
        if (not game.hasVisual(self)) {
            game.addVisual(self)
        }
    }
}