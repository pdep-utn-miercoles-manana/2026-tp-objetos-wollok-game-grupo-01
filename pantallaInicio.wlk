import wollok.game.*

// Pantalla de inicio: cuenta la trama antes de arrancar la partida.
object tituloInicio {
  method position() = game.at(4, 10)
  method text() = "NOVEMBER IS COMING"
  method textColor() = "FFFFFFFF"
}

object subtituloInicio {
  method position() = game.at(5, 9)
  method text() = "UTN FRBA - PdeP"
  method textColor() = "FFD166FF"
}

object historiaInicio1 {
  method position() = game.at(5, 7)
  method text() = "Es noviembre en la facultad."
  method textColor() = "E8E8E8FF"
}

object historiaInicio2 {
  method position() = game.at(5, 6)
  method text() = "Los parciales se acumulan y los profes no perdonan."
  method textColor() = "E8E8E8FF"
}

object historiaInicio3 {
  method position() = game.at(5, 5)
  method text() = "Recorré los pisos, esquivá los tiros y juntá todos los parciales."
  method textColor() = "E8E8E8FF"
}

object historiaInicio4 {
  method position() = game.at(5, 4)
  method text() = "Si te quedás sin vidas, volvés al inicio."
  method textColor() = "E8E8E8FF"
}

object controlesInicio {
  method position() = game.at(5, 2)
  method text() = "Flechas: moverte. E: interactuar. Pisá la escalera para subir."
  method textColor() = "9FD8FFFF"
}

object empezarInicio {
  method position() = game.at(5, 1)
  method text() = "Presioná ENTER o ESPACIO para empezar"
  method textColor() = "00FF88FF"
}

object pantallaInicio {
  const visuales = [
    tituloInicio,
    subtituloInicio,
    historiaInicio1,
    historiaInicio2,
    historiaInicio3,
    historiaInicio4,
    controlesInicio,
    empezarInicio
  ]

  method mostrar() {
    game.boardGround("fondoInicio.png")
    visuales.forEach({ visual =>
      if (not game.hasVisual(visual)) {
        game.addVisual(visual)
      }
    })
  }

  method ocultar() {
    visuales.forEach({ visual =>
      if (game.hasVisual(visual)) {
        game.removeVisual(visual)
      }
    })
  }
}
