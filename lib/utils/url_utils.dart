class UrlUtils {
  String urlEncode(String url) {
    return Uri.encodeFull(url);
  }

  String urlDecode(String url) {
    return Uri.decodeFull(url);
  }
}
