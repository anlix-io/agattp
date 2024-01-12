///
///
///
enum HeaderKeyCase {
  lowercase,
  capitalize,
  preserve;
}

///
///
///
class Utils {
  ///
  ///
  ///
  static String capitalizeHeaderKey(String key) {
    final List<String> parts = key.split('-');

    for (int i = 0; i < parts.length; i++) {
      parts[i] =
          parts[i][0].toUpperCase() + parts[i].substring(1).toLowerCase();
    }

    return parts.join('-');
  }

  ///
  ///
  ///
  static Map<String, String> headers(
    Map<String, String> headers,
    HeaderKeyCase keyCase,
  ) {
    final Map<String, String> newHeaders = <String, String>{};

    for (final MapEntry<String, String> entry in headers.entries) {
      switch (keyCase) {
        case HeaderKeyCase.lowercase:
          newHeaders[entry.key.toLowerCase()] = entry.value;
          break;
        case HeaderKeyCase.capitalize:
          newHeaders[capitalizeHeaderKey(entry.key)] = entry.value;
          break;
        case HeaderKeyCase.preserve:
          newHeaders[entry.key] = entry.value;
          break;
      }
    }

    return newHeaders;
  }
}
