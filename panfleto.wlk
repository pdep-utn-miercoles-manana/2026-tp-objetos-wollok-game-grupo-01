import obstaculos.*
class Panfleto inherits Obstaculos {
    var usado = false

    method usar(alumno) {
        if (!usado) {
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