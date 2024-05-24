import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

/// This class, is a utility class for converting strings into
/// various cryptographic hashes and HMACs (Hash-based Message Authentication Codes).
/// It takes a string value in its constructor and optionally a secret string.
class HashUtils {
  late Uint8List bytes;
  late Uint8List? secretBytes;
  String? secret;

  HashUtils(String value, {this.secret}) {
    bytes = utf8.encode(value);
    if (secret != null) {
      secretBytes = utf8.encode(secret!);
    }
  }

  /// A function that converts the given string value to an MD5 hash.
  ///
  /// Returns a `Future<String>` that resolves to the MD5 hash of the string value.
  Future<String> md5Convertor() {
    var digest = md5.convert(bytes);

    return Future.value(digest.toString());
  }

  /// A function that converts the given string value to an Sha1 hash.
  ///
  /// Returns a `Future<String>` that resolves to the Sha1 hash of the string value.
  Future<String> sha1Convertor() {
    var digest = sha1.convert(bytes);

    return Future.value(digest.toString());
  }

  /// A function that converts the given string value to an Sha224 hash.
  ///
  /// Returns a `Future<String>` that resolves to the Sha224 hash of the string value.
  Future<String> sha224Convertor() {
    var digest = sha224.convert(bytes);

    return Future.value(digest.toString());
  }

  /// A function that converts the given string value to an Sha256 hash.
  ///
  /// Returns a `Future<String>` that resolves to the Sha256 hash of the string value.
  Future<String> sha256Convertor() {
    var digest = sha256.convert(bytes);

    return Future.value(digest.toString());
  }

  /// A function that converts the given string value to an Sha384 hash.
  ///
  /// Returns a `Future<String>` that resolves to the Sha384 hash of the string value.
  Future<String> sha384Convertor() {
    var digest = sha384.convert(bytes);

    return Future.value(digest.toString());
  }

  /// A function that converts the given string value to an Sha512 hash.
  ///
  /// Returns a `Future<String>` that resolves to the Sha512 hash of the string value.
  Future<String> sha512Convertor() {
    var digest = sha512.convert(bytes);

    return Future.value(digest.toString());
  }

  //------------------- HMAC -------------------\\

  /// Converts the given bytes to an MD5 HMAC digest and returns it as a string.
  ///
  /// Returns a `Future<String>` that resolves to the MD5 HMAC digest of the bytes.
  Future<String> md5HmacConvertor() {
    var hmacMd5 = Hmac(md5, secretBytes!);
    var digest = hmacMd5.convert(bytes);

    return Future.value(digest.toString());
  }

  Future<String> sha1HmacConvertor() {
    var hmacSha1 = Hmac(sha1, secretBytes!);
    var digest = hmacSha1.convert(bytes);

    return Future.value(digest.toString());
  }

  Future<String> sha224HmacConvertor() {
    var hmacSha224 = Hmac(sha224, secretBytes!);
    var digest = hmacSha224.convert(bytes);

    return Future.value(digest.toString());
  }

  Future<String> sha256HmacConvertor() {
    var hmacSha256 = Hmac(sha256, secretBytes!);
    var digest = hmacSha256.convert(bytes);

    return Future.value(digest.toString());
  }

  Future<String> sha384HmacConvertor() {
    var hmacSha384 = Hmac(sha384, secretBytes!);
    var digest = hmacSha384.convert(bytes);

    return Future.value(digest.toString());
  }

  Future<String> sha512HmacConvertor() {
    var hmacSha512 = Hmac(sha512, secretBytes!);
    var digest = hmacSha512.convert(bytes);

    return Future.value(digest.toString());
  }
}
