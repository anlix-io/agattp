import 'dart:collection';
import 'dart:io';

import 'package:agattp/src/agattp_utils.dart';

///
///
///
class AgattpWebHeaders implements HttpHeaders {
  final LinkedHashMap<String, List<String>> _headers =
      LinkedHashMap<String, List<String>>(
    equals: (String k1, String k2) => k1.toLowerCase() == k2.toLowerCase(),
    hashCode: (String k) => k.toLowerCase().hashCode,
  );

  // TODO(anyone): properly implement these stubbed properties and methods?
  /// All of these go unused for our current use cases, so they're being stubbed
  @override
  bool chunkedTransferEncoding = true;

  @override
  int contentLength = -1;

  @override
  ContentType? contentType;

  @override
  DateTime? date;

  @override
  DateTime? expires;

  @override
  String? host;

  @override
  DateTime? ifModifiedSince;

  @override
  bool persistentConnection = true;

  @override
  int? port;

  HeaderKeyCase keyCase = HeaderKeyCase.capitalize;

  ///
  ///
  ///
  AgattpWebHeaders.from(this.keyCase, Map<String, String> map) {
    map.forEach(_add);
  }

  ///
  ///
  ///
  @override
  void noFolding(String name) {}

  ///
  ///
  ///
  void _add(String name, String value) {
    switch (name.toLowerCase()) {
      case HttpHeaders.contentLengthHeader:
        contentLength = int.tryParse(value) ?? -1;
        break;
      // case HttpHeaders.dateHeader:
      //   try {
      //     date = DateFormat('EEE, dd MMM yyyy HH:mm:ss zzz').parse(value);
      //   } on Exception catch (_) {}
      //   break;
    }

    final String nameToUse = Utils.headerKey(keyCase, name);

    if (_headers.containsKey(nameToUse)) {
      if (!_headers[nameToUse]!.contains(value)) {
        _headers[nameToUse]!.add(value);
      }
    } else {
      _headers[nameToUse] = <String>[value];
    }
  }

  ///
  ///
  ///
  void _remove(String name, String value) {
    final String nameToUse = Utils.headerKey(keyCase, name);

    if (_headers.containsKey(nameToUse)) {
      _headers[nameToUse]!.remove(value);
      if (_headers[nameToUse]!.isEmpty) {
        _headers.remove(nameToUse);
      }
    }
  }

  ///
  ///
  ///
  void _addAll(String name, Iterable<String> values) {
    for (final String value in values) {
      _add(name, value);
    }
  }

  ///
  ///
  ///
  void _removeAll(String name, Iterable<String> values) {
    for (final String value in values) {
      _remove(name, value);
    }
  }

  ///
  ///
  ///
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    final String nameToUse = Utils.headerKey(keyCase, name);

    if (value is Iterable) {
      _headers[nameToUse] = value.map((dynamic v) => v.toString()).toList();
    } else {
      _headers[nameToUse] = <String>[value.toString()];
    }
  }

  ///
  ///
  ///
  @override
  void add(String name, Object value, {bool preserveHeaderCase = true}) {
    final String nameToUse = Utils.headerKey(keyCase, name);

    if (value is Iterable) {
      _addAll(nameToUse, value.map((dynamic v) => v.toString()));
    } else {
      _add(nameToUse, value.toString());
    }
  }

  ///
  ///
  ///
  @override
  void clear() => _headers.clear();

  ///
  ///
  ///
  @override
  void remove(String name, Object value) {
    if (value is Iterable) {
      _removeAll(name, value.map((dynamic v) => v.toString()));
    } else {
      _remove(name, value.toString());
    }
  }

  ///
  ///
  ///
  @override
  void removeAll(String name) => _headers.remove(name);

  ///
  ///
  ///
  @override
  void forEach(void Function(String name, List<String> values) action) =>
      _headers.forEach(action);

  ///
  ///
  ///
  @override
  String? value(String name) {
    final String nameToUse = Utils.headerKey(keyCase, name);
    if (_headers.containsKey(nameToUse) && _headers[nameToUse]!.isNotEmpty) {
      return _headers[nameToUse]!.first;
    }
    return null;
  }

  ///
  ///
  ///
  @override
  List<String>? operator [](String name) =>
      _headers[Utils.headerKey(keyCase, name)];

  ///
  ///
  ///
  @override
  String toString() => _headers.toString();

  ///
  ///
  ///
  bool get isEmpty => _headers.isEmpty;

  ///
  ///
  ///
  bool get isNotEmpty => _headers.isNotEmpty;

  ///
  ///
  ///
  List<Cookie> get cookies {
    if (!_headers.containsKey(HttpHeaders.setCookieHeader)) {
      return <Cookie>[];
    }

    final Map<String, String> rawInfo = <String, String>{};

    for (final String rawValue in _headers[HttpHeaders.setCookieHeader]!) {
      final Cookie cookie = Cookie.fromSetCookieValue(rawValue);
      rawInfo[cookie.name] = cookie.value; // This prevents duplicate cookies
    }

    return rawInfo.entries
        .map((MapEntry<String, String> entry) => Cookie(entry.key, entry.value))
        .toList();
  }
}
