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
  const archivosDeEfectos = ["disparo.wav", "golpe.wav", "escalera.wav", "llave.wav", "flip.wav", "chiflido.wav", "gameover.wav", "ganar.wav"]
  var ultimoDisparo = -1000

  method precargar() {
    if (game.running()) {
      if (musica == null) {
        musica = game.sound("musica.wav")
      }
      archivosDeEfectos.forEach({ archivo => self.cargar(archivo) })
    }
  }

  method cargar(archivo) {
    if (not efectos.containsKey(archivo)) {
      efectos.put(archivo, game.sound(archivo))
    }
  }

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

  // Los disparos pueden ser muchos por segundo; limito el sonido para no saturar
  // el audio (y el render) cuando hay varios profesores disparando.
  method efectoDisparo() {
    if (game.running() and not silenciado) {
      const ahora = game.currentTime()
      if (ahora - ultimoDisparo >= 250) {
        ultimoDisparo = ahora
        self.efecto("disparo.wav")
      }
    }
  }

  method efecto(archivo) {
    if (game.running() and not silenciado) {
      self.cargar(archivo)
      const sonido = efectos.get(archivo)
      if (sonido.played()) {
        sonido.stop()
      }
      sonido.volume(volumenEfecto)
      sonido.play()
    }
  }
}
