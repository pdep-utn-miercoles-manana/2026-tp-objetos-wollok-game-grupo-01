import wollok.game.*

// Audio del juego. Todo está envuelto en game.running() para que los tests
// no intenten reproducir sonidos.
object sonidos {
  const volumenMusica = 0.25
  const volumenEfecto = 0.25

  var musica = null
  var musicaIniciada = false
  var silenciado = false
  const efectos = new Dictionary()

  method iniciarMusica() {
    if (game.running()) {
      if (musica == null) {
        musica = game.sound("musica.wav")
      }
      if (not musicaIniciada) {
        musica.shouldLoop(true)
        musica.volume(if (silenciado) 0 else volumenMusica)
        musica.play()
        musica.shouldLoop(true)
        musicaIniciada = true
      }
    }
  }

  method detenerMusica() {
    if (musicaIniciada) {
      musica.stop()
      musicaIniciada = false
      musica = null
    }
  }

  method alternarMute() {
    silenciado = not silenciado
    if (musicaIniciada) {
      musica.volume(if (silenciado) 0 else volumenMusica)
    }
  }

  method efecto(archivo) {
    if (game.running() and not silenciado) {
      if (not efectos.containsKey(archivo)) {
        efectos.put(archivo, game.sound(archivo))
      }
      const sonido = efectos.get(archivo)
      if (sonido.played()) {
        sonido.stop()
      }
      sonido.volume(volumenEfecto)
      sonido.play()
    }
  }
}
