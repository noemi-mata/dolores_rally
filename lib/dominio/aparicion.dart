import 'dart:math' as math;

import 'geo.dart';
import 'personaje.dart';

/// Un personaje escondido en un punto del mapa.
class Aparicion {
  final Personaje personaje;
  final Coordenada coordenada;
  const Aparicion(this.personaje, this.coordenada);
}

/// Punto al azar entre [min] y [max] metros del [centro].
/// Se usa raíz cuadrada para que los puntos queden repartidos de forma PAREJA
/// por el área (sin ella, se amontonarían cerca del centro).
Coordenada puntoAleatorio(
    Coordenada centro, double min, double max, math.Random random) {
  final distancia =
      math.sqrt(min * min + random.nextDouble() * (max * max - min * min));
  return destino(centro, random.nextDouble() * 360, distancia);
}

/// El [random] se inyecta: con una semilla fija (Random(42)) el "azar" es repetible
/// y las pruebas son confiables; en el juego real se usa Random() sin semilla.
///
/// RETO: [separacionMin] evita que dos personajes queden demasiado juntos.
/// [maxIntentos] evita un ciclo infinito si la regla fuera imposible de cumplir.
List<Aparicion> generarApariciones({
  required Coordenada centro,
  required List<Personaje> personajes,
  required math.Random random,
  double radioMin = 60,
  double radioMax = 500,
  double separacionMin = 0,
  int maxIntentos = 50,
}) {
  final lista = <Aparicion>[];
  for (final p in personajes) {
    var punto = puntoAleatorio(centro, radioMin, radioMax, random);
    var intentos = 1;
    while (intentos < maxIntentos &&
        lista.any((x) => distanciaMetros(x.coordenada, punto) < separacionMin)) {
      punto = puntoAleatorio(centro, radioMin, radioMax, random);
      intentos++;
    }
    lista.add(Aparicion(p, punto));
  }
  return lista;
}