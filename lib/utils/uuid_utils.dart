import 'package:uuid/uuid.dart';

class UuidUtils {
  static String generateV4() {
    return const Uuid().v4();
  }

  static String generateV5(String namespace, String name) {
    return const Uuid().v5(namespace, name);
  }

  static String generateV6() {
    return const Uuid().v6();
  }

  static String generateV7() {
    return const Uuid().v7();
  }

  static String generateV8() {
    return const Uuid().v8();
  }

  static String generateV1() {
    return const Uuid().v1();
  }

  /// Decodes a UUID and extracts its version, variant, timestamp, clock sequence, and node.
  ///
  /// - param `String` uuid - The UUID to decode.
  /// - return `Tuple` A tuple containing the version, variant, timestamp, clock sequence, and node.
  static (int, String, int, int, String) decode(String uuid) {
    // Parse the UUID to a list of bytes
    List<int> bytes = Uuid.parse(uuid);

    // Extracting information from the UUID
    var version = bytes[6] >> 4; // Version is in the 7th byte
    var variant = (bytes[8] & 0xC0) >> 6; // Variant is in the 9th byte

    // Extract timestamp (60 bits: 4 bits from byte 6, all bits from byte 7, 5, 4, 3, 2, and 1)
    var timestamp = ((bytes[6] & 0x0F) << 56) |
        (bytes[7] << 48) |
        (bytes[4] << 40) |
        (bytes[5] << 32) |
        (bytes[0] << 24) |
        (bytes[1] << 16) |
        (bytes[2] << 8) |
        bytes[3];

    // UUID timestamp is in 100-nanosecond intervals since 1582-10-15
    // Convert to Unix epoch (1970-01-01)
    const UUID_EPOCH = 0x01B21DD213814000;
    timestamp -= UUID_EPOCH;
    var millisecondsSinceEpoch = timestamp ~/ 10000; // Convert to milliseconds

    // Extract clock sequence
    var clockSeq = ((bytes[8] & 0x3F) << 8) | bytes[9];

    // Extract node (MAC address)
    var node = [
      bytes[10].toRadixString(16).padLeft(2, '0'),
      bytes[11].toRadixString(16).padLeft(2, '0'),
      bytes[12].toRadixString(16).padLeft(2, '0'),
      bytes[13].toRadixString(16).padLeft(2, '0'),
      bytes[14].toRadixString(16).padLeft(2, '0'),
      bytes[15].toRadixString(16).padLeft(2, '0')
    ].join(':');

    String variantName = '';

    if (variant == 0) {
      variantName = '0 (NCS backward compatibility)';
    } else if (variant == 1) {
      variantName = '1 (RFC 4122/DCE 1.1)';
    } else if (variant == 2) {
      variantName = '2 (Microsoft\'s GUIDs)';
    } else if (variant == 3) {
      variantName = '3 (Reserved for future use)';
    } else {
      variantName = 'Unknown';
    }

    return (version, variantName, millisecondsSinceEpoch, clockSeq, node);
  }
}
