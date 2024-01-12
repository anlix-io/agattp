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
  static String capitalizeHeaderKey(
    String key, {
    String separator = '-',
  }) {
    final List<String> parts = key.split(separator);

    for (int i = 0; i < parts.length; i++) {
      parts[i] =
          parts[i][0].toUpperCase() + parts[i].substring(1).toLowerCase();
    }

    return parts.join(separator);
  }

  ///
  ///
  ///
  static String headerKey(HeaderKeyCase keyCase, String key) {
    switch (keyCase) {
      case HeaderKeyCase.lowercase:
        return key.toLowerCase();
      case HeaderKeyCase.capitalize:
        return capitalizeHeaderKey(key);
      case HeaderKeyCase.preserve:
        return key;
    }
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
      newHeaders[headerKey(keyCase, entry.key)] = entry.value;
    }

    return newHeaders;
  }
}
