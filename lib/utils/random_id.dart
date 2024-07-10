import 'dart:math';

class RandomIds {
  static BigInt generateRandomId() {
    final random = Random();
    final maxInt8 = BigInt.from(9223372036854775807);

    // Generar un número aleatorio de 64 bits
    final randomBits = BigInt.from(random.nextInt(1 << 32)) << 32 |
      BigInt.from(
        random.nextInt(1 << 32)
      );
    
    // Escalar el número aleatorio a rango completo de int8
    final scaledValue = (randomBits % (maxInt8 + BigInt.one));

    return scaledValue;
  }
}