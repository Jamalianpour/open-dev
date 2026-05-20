enum NumberBase {
  binary(2, 'BIN'),
  octal(8, 'OCT'),
  decimal(10, 'DEC'),
  hexadecimal(16, 'HEX');

  const NumberBase(this.radix, this.label);
  final int radix;
  final String label;
}

enum BitWidth {
  bits8(8),
  bits16(16),
  bits32(32),
  bits64(64);

  const BitWidth(this.bits);
  final int bits;

  BigInt get mask => (BigInt.one << bits) - BigInt.one;
}

class NumberBaseUtils {
  static final _validChars = {
    NumberBase.binary: RegExp(r'^[01]+$'),
    NumberBase.octal: RegExp(r'^[0-7]+$'),
    NumberBase.decimal: RegExp(r'^-?[0-9]+$'),
    NumberBase.hexadecimal: RegExp(r'^[0-9a-fA-F]+$'),
  };

  static bool isValid(String input, NumberBase base) {
    if (input.isEmpty) return false;
    return _validChars[base]!.hasMatch(input);
  }

  /// Parses [input] in [base]. For non-decimal bases the input is treated as
  /// unsigned; for decimal the input may be signed.
  static BigInt parse(String input, NumberBase base) {
    if (input.isEmpty) throw const FormatException('empty');
    if (!isValid(input, base)) {
      throw FormatException('invalid ${base.label} value: $input');
    }
    return BigInt.parse(input, radix: base.radix);
  }

  /// Formats [value] as a string in [base]. Result is upper-case for hex.
  /// For non-decimal bases negative values are wrapped to [width] using
  /// two's-complement.
  static String format(BigInt value, NumberBase base, BitWidth width) {
    if (base == NumberBase.decimal) {
      return value.toString();
    }
    final BigInt wrapped = value.isNegative ? (value & width.mask) : value;
    final s = wrapped.toRadixString(base.radix);
    return base == NumberBase.hexadecimal ? s.toUpperCase() : s;
  }

  /// Returns the binary representation padded to [width] bits.
  static String toBits(BigInt value, BitWidth width) {
    final wrapped = value.isNegative ? (value & width.mask) : (value & width.mask);
    return wrapped.toRadixString(2).padLeft(width.bits, '0');
  }

  /// Interprets [value] as a signed integer of [width] bits (two's complement).
  static BigInt asSigned(BigInt value, BitWidth width) {
    final wrapped = value & width.mask;
    final signBit = BigInt.one << (width.bits - 1);
    if ((wrapped & signBit) != BigInt.zero) {
      return wrapped - (BigInt.one << width.bits);
    }
    return wrapped;
  }

  static BigInt and(BigInt a, BigInt b, BitWidth w) => (a & b) & w.mask;
  static BigInt or(BigInt a, BigInt b, BitWidth w) => (a | b) & w.mask;
  static BigInt xor(BigInt a, BigInt b, BitWidth w) => (a ^ b) & w.mask;
  static BigInt not(BigInt a, BitWidth w) => (~a) & w.mask;
  static BigInt shiftLeft(BigInt a, int n, BitWidth w) => (a << n) & w.mask;
  static BigInt shiftRight(BigInt a, int n, BitWidth w) => (a & w.mask) >> n;

  /// Toggles the bit at [position] (0 = least significant).
  static BigInt toggleBit(BigInt value, int position, BitWidth w) {
    final wrapped = value & w.mask;
    return wrapped ^ (BigInt.one << position);
  }
}
