import wollok.game.*

// Un texto que se puede cambiar mientras corre la animación.
class TextoInicio {
  var property position
  var contenido
  var colorActual

  method text() = contenido
  method textColor() = colorActual

  method cambiar(nuevoTexto, nuevoColor) {
    contenido = nuevoTexto
    colorActual = nuevoColor
  }
}

// Una imagen que se puede mover por la pantalla de inicio.
class ImagenInicio {
  var property position
  const imagen

  method image() = imagen
}

object pantallaInicio {

  const titulo = new TextoInicio(position = game.at(4, 10), contenido = "NOVEMBER IS COMING", colorActual = "FFFFFFFF")
  const subtitulo = new TextoInicio(position = game.at(5, 9), contenido = "UTN FRBA - PdeP", colorActual = "FFD166FF")
  const linea1 = new TextoInicio(position = game.at(5, 7), contenido = "", colorActual = "E8E8E8FF")
  const linea2 = new TextoInicio(position = game.at(5, 6), contenido = "", colorActual = "E8E8E8FF")
  const linea3 = new TextoInicio(position = game.at(5, 5), contenido = "", colorActual = "E8E8E8FF")
  const menu1 = new TextoInicio(position = game.at(5, 5), contenido = "", colorActual = "FFFFFFFF")
  const menu2 = new TextoInicio(position = game.at(5, 4), contenido = "", colorActual = "888888FF")
  const prompt = new TextoInicio(position = game.at(5, 2), contenido = "", colorActual = "00FF88FF")

  const jugadorIntro = new ImagenInicio(position = game.at(0, 0), imagen = "jugadorDerecha1.png")
  const omarIntro = new ImagenInicio(position = game.at(19, 1), imagen = "Dr Omar.png")
  const lettuceIntro = new ImagenInicio(position = game.at(10, 0), imagen = "letucce.png")

  const visuales = [
    titulo, subtitulo, linea1, linea2, linea3,
    menu1, menu2, prompt,
    jugadorIntro, omarIntro, lettuceIntro
  ]

  var fase = 0
  var frame = 0
  var activa = false

  method mostrar() {
    if (not activa) {
      activa = true
      fase = 0
      frame = 0
      game.boardGround("fondoInicio.png")
      visuales.forEach({ visual =>
        if (not game.hasVisual(visual)) {
          game.addVisual(visual)
        }
      })
      self.actualizarFase()
      game.onTick(120, "animacionInicio", { self.animar() })
    }
  }

  method avanzar() {
    if (fase < 3) {
      fase += 1
      self.actualizarFase()
    }
  }

  method enMenu() = fase == 3

  method terminar() {
    activa = false
    game.removeTickEvent("animacionInicio")
    visuales.forEach({ visual =>
      if (game.hasVisual(visual)) {
        game.removeVisual(visual)
      }
    })
  }

  method actualizarFase() {
    if (fase == 0) {
      subtitulo.cambiar("UTN FRBA - PdeP", "FFD166FF")
      linea1.cambiar("", "E8E8E8FF")
      linea2.cambiar("", "E8E8E8FF")
      linea3.cambiar("", "E8E8E8FF")
      menu1.cambiar("", "FFFFFFFF")
      menu2.cambiar("", "888888FF")
      prompt.cambiar("PRESIONÁ ENTER O HACÉ CLIC", "00FF88FF")
    } else if (fase == 1) {
      subtitulo.cambiar("LA TRAMA", "FFD166FF")
      linea1.cambiar("Es noviembre en la facultad.", "E8E8E8FF")
      linea2.cambiar("Los parciales se acumulan y los profes no perdonan.", "E8E8E8FF")
      linea3.cambiar("Recorré los pisos y juntá todos los parciales.", "E8E8E8FF")
      menu1.cambiar("", "FFFFFFFF")
      menu2.cambiar("", "888888FF")
      prompt.cambiar("ENTER / CLIC PARA SEGUIR", "9FD8FFFF")
    } else if (fase == 2) {
      subtitulo.cambiar("CÓMO JUGAR", "FFD166FF")
      linea1.cambiar("Flechas: moverte.", "E8E8E8FF")
      linea2.cambiar("E: interactuar con escritorios.", "E8E8E8FF")
      linea3.cambiar("Pisá la escalera para cambiar de piso.", "E8E8E8FF")
      menu1.cambiar("", "FFFFFFFF")
      menu2.cambiar("", "888888FF")
      prompt.cambiar("ENTER / CLIC PARA SEGUIR", "9FD8FFFF")
    } else {
      subtitulo.cambiar("MENÚ PRINCIPAL", "FFD166FF")
      linea1.cambiar("", "E8E8E8FF")
      linea2.cambiar("", "E8E8E8FF")
      linea3.cambiar("", "E8E8E8FF")
      menu1.cambiar("♥ INICIAR NUEVO JUEGO", "FFFFFFFF")
      menu2.cambiar("CARGAR PARTIDA", "777777FF")
      prompt.cambiar("PRESIONE ENTER O CLIC", "00FF88FF")
    }
  }

  method animar() {
    if (activa) {
      frame += 1
      jugadorIntro.position(game.at(frame % 20, 0))
      omarIntro.position(game.at(19 - (frame % 20), 1))
      lettuceIntro.position(game.at((frame * 2) % 20, 0))

      if (fase == 0) {
        titulo.cambiar("NOVEMBER IS COMING", if (frame % 10 < 5) "FFFFFFFF" else "FF6666FF")
      }
      if (fase == 3) {
        menu1.cambiar(if (frame % 8 < 4) "♥ INICIAR NUEVO JUEGO" else "  INICIAR NUEVO JUEGO", "FFFFFFFF")
      }
      prompt.cambiar(prompt.text(), if (frame % 8 < 4) "00FF88FF" else "007744FF")
    }
  }
}
