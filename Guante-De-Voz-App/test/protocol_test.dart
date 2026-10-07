import 'package:flutter_test/flutter_test.dart';
import 'package:beyond_words/models.dart';

void main() {
  // Captura fija: pulgar/medio/meñique, -12.34°, 45.67°,
  // -0.25g, 0.50g, 1g, -12.3°/s, 45.6°/s, -78.9°/s.
  const packet = [
    0x15, 0x2e, 0xfb, 0xd7, 0x11, 0xe7, 0xff, 0x32, 0x00,
    0x64, 0x00, 0x85, 0xff, 0xc8, 0x01, 0xeb, 0xfc,
  ];

  test('decodifica máscara, signo, escalas y little-endian del ESP32', () {
    final frame = SensorFrame.fromBinary(packet)!;
    expect(frame.fingers, [1.0, 0.0, 1.0, 0.0, 1.0]);
    expect(frame.pitch, -12.34);
    expect(frame.roll, 45.67);
    expect([frame.ax, frame.ay, frame.az], [-0.25, 0.5, 1.0]);
    expect([frame.gx, frame.gy, frame.gz], [-12.3, 45.6, -78.9]);
  });

  test('rechaza notificaciones incompletas', () {
    for (var length = 0; length < 17; length++) {
      expect(SensorFrame.fromBinary(packet.take(length).toList()), isNull);
    }
  });

  test('un guante ausente no desplaza las dimensiones del otro', () {
    final frame = SensorFrame.fromBinary(packet)!;
    final vector = BimanualVector.fromFrames(null, frame);
    expect(vector.values.length, 26);
    expect(vector.leftHalf, List<double>.filled(13, 0));
    expect(vector.rightHalf.take(5), [1.0, 0.0, 1.0, 0.0, 1.0]);
    final disabled = BimanualVector.fromFrames(frame, frame, useRight: false);
    expect(disabled.rightHalf, List<double>.filled(13, 0));
  });
}
