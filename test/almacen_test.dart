import 'package:dolores_rally/datos/almacen_prefs.dart';
import 'package:dolores_rally/dominio/almacen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Las mismas pruebas para cualquier implementación del contrato.
void probarContrato(String nombre, AlmacenColeccion Function() crear) {
  group(nombre, () {
    test('al inicio no hay capturados y el mejor puntaje es 0', () async {
      final a = crear();
      expect(await a.cargarCapturados(), isEmpty);
      expect(await a.cargarMejorPuntaje(), 0);
    });

    test('guarda y recupera los capturados', () async {
      final a = crear();
      await a.guardarCapturados({'hidalgo', 'allende'});
      expect(await a.cargarCapturados(), {'hidalgo', 'allende'});
    });

    test('guarda y recupera el mejor puntaje', () async {
      final a = crear();
      await a.guardarMejorPuntaje(350);
      expect(await a.cargarMejorPuntaje(), 350);
    });

    test('modificar el conjunto devuelto no cambia lo guardado', () async {
      final a = crear();
      await a.guardarCapturados({'hidalgo'});
      final copia = await a.cargarCapturados();
      copia.add('trampa');
      expect(await a.cargarCapturados(), {'hidalgo'});
    });
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Teléfono "limpio" antes de cada prueba.
    SharedPreferences.setMockInitialValues({});
  });

  probarContrato('AlmacenMemoria', () => AlmacenMemoria());
  probarContrato('AlmacenPrefs', () => AlmacenPrefs());
}