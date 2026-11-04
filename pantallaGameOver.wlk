import wollok.game.*
import pantallaInicio.*

// Pantalla que aparece cuando el jugador se queda sin vidas.
object pantallaGameOver {
  const imagen = new ImagenInicio(position = game.at(0, 0), imagen = "gameOver.png")

  const visuales = [imagen]
  var activo = false

  method mostrar() {
    if (not activo) {
      activo = true
      visuales.forEach({ visual =>
        if (not game.hasVisual(visual)) {
          game.addVisual(visual)
        }
      })
    }
  }

  method ocultar() {
    if (activo) {
      activo = false
      visuales.forEach({ visual =>
        if (game.hasVisual(visual)) {
          game.removeVisual(visual)
        }
      })
    }
  }
}
