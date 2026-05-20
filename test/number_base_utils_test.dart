import 'package:flutter_test/flutter_test.dart';
import 'package:open_dev/utils/number_base_utils.dart';

void main() {
  group('NumberBaseUtils.isValid', () {
    test('accepts valid inputs per base', () {
      expect(NumberBaseUtils.isValid('1010', NumberBase.binary), isTrue);
      expect(NumberBaseUtils.isValid('755', NumberBase.octal), isTrue);
      expect(NumberBaseUtils.isValid('-42', NumberBase.decimal), isTrue);
      expect(NumberBaseUtils.isValid('CAFE', NumberBase.hexadecimal), isTrue);
    });

    test('rejects out-of-range characters', () {
      expect(NumberBaseUtils.isValid('102', NumberBase.binary), isFalse);
      expect(NumberBaseUtils.isValid('89', NumberBase.octal), isFalse);
      expect(NumberBaseUtils.isValid('xyz', NumberBase.hexadecimal), isFalse);
    });

    test('rejects empty input', () {
      expect(NumberBaseUtils.isValid('', NumberBase.decimal), isFalse);
    });
  });

  group('NumberBaseUtils.parse / format', () {
    test('round-trips across bases', () {
      final v = NumberBaseUtils.parse('FF', NumberBase.hexadecimal);
      expect(v.toInt(), 255);
      expect(NumberBaseUtils.format(v, NumberBase.binary, BitWidth.bits32),
          '11111111');
      expect(NumberBaseUtils.format(v, NumberBase.octal, BitWidth.bits32),
          '377');
      expect(NumberBaseUtils.format(v, NumberBase.decimal, BitWidth.bits32),
          '255');
    });

    test('wraps negative values to two\'s complement for non-decimal bases',
        () {
      final neg = BigInt.from(-1);
      expect(
          NumberBaseUtils.format(neg, NumberBase.hexadecimal, BitWidth.bits8),
          'FF');
      expect(
          NumberBaseUtils.format(neg, NumberBase.binary, BitWidth.bits8),
          '11111111');
      // Decimal still prints the signed form.
      expect(
          NumberBaseUtils.format(neg, NumberBase.decimal, BitWidth.bits8),
          '-1');
    });

    test('parse throws FormatException on invalid input', () {
      expect(() => NumberBaseUtils.parse('GG', NumberBase.hexadecimal),
          throwsFormatException);
    });
  });

  group('NumberBaseUtils.toBits', () {
    test('pads to bit width', () {
      expect(NumberBaseUtils.toBits(BigInt.from(5), BitWidth.bits8),
          '00000101');
    });
  });

  group('NumberBaseUtils.asSigned', () {
    test('converts high bit set to negative', () {
      // 0xFF in 8-bit signed = -1
      expect(NumberBaseUtils.asSigned(BigInt.from(0xFF), BitWidth.bits8),
          BigInt.from(-1));
      // 0x80 in 8-bit signed = -128
      expect(NumberBaseUtils.asSigned(BigInt.from(0x80), BitWidth.bits8),
          BigInt.from(-128));
    });

    test('keeps positive values unchanged', () {
      expect(NumberBaseUtils.asSigned(BigInt.from(0x7F), BitWidth.bits8),
          BigInt.from(127));
    });
  });

  group('NumberBaseUtils bitwise', () {
    const w = BitWidth.bits8;

    test('AND / OR / XOR', () {
      // a = 1100b = 12, b = 1010b = 10
      final a = BigInt.from(0xC);
      final b = BigInt.from(0xA);
      expect(NumberBaseUtils.and(a, b, w).toInt(), 0x8); // 1000b
      expect(NumberBaseUtils.or(a, b, w).toInt(), 0xE); // 1110b
      expect(NumberBaseUtils.xor(a, b, w).toInt(), 0x6); // 0110b
    });

    test('NOT respects bit width', () {
      expect(NumberBaseUtils.not(BigInt.zero, w).toInt(), 0xFF);
      expect(NumberBaseUtils.not(BigInt.from(0xFF), w).toInt(), 0);
    });

    test('left shift wraps within bit width', () {
      // 0xFF << 4 within 8 bits = 0xF0
      expect(NumberBaseUtils.shiftLeft(BigInt.from(0xFF), 4, w).toInt(), 0xF0);
    });

    test('right shift is logical (zero-fill)', () {
      expect(NumberBaseUtils.shiftRight(BigInt.from(0xFF), 4, w).toInt(),
          0x0F);
    });

    test('toggleBit flips the indicated position', () {
      final v = BigInt.from(0);
      final r1 = NumberBaseUtils.toggleBit(v, 3, w);
      expect(r1.toInt(), 0x8); // 1000b
      final r2 = NumberBaseUtils.toggleBit(r1, 3, w);
      expect(r2.toInt(), 0);
    });
  });
}
