import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtUtils {
  static JWT decode(String token) {
    return JWT.decode(token);
  }

  static String encode(
    Map payload,
    String secret,
    JWTAlgorithm algorithm, {
    String? subject,
    String? issuer,
    String? jwtId,
    Map<String, dynamic>? header,
    Duration? expiresIn,
    Duration? notBefore,
  }) {
    final jwt = JWT(payload, header: header);
    return jwt.sign(SecretKey(secret), algorithm: algorithm);
    // final jwt = JWT(payload, subject: subject, issuer: issuer, jwtId: jwtId, header: header);
    // return jwt.sign(SecretKey(secret), algorithm: algorithm, expiresIn: expiresIn, notBefore: notBefore);
  }

  static Map<String, dynamic> decodePayload(String token) {
    return JWT.decode(token).payload;
  }

  static int verify(String token, String secret) {
    try {
      JWT.verify(token, SecretKey(secret));
      return 1;
    } on JWTExpiredException {
      return 0;
    } catch (_) {
      return -1;
    }
  }
}
