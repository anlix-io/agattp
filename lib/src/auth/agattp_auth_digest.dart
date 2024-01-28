import 'dart:convert';
import 'dart:io';

import 'package:agattp/src/agattp.dart';
import 'package:agattp/src/agattp_method.dart';
import 'package:agattp/src/agattp_response.dart';
import 'package:agattp/src/agattp_utils.dart';
import 'package:agattp/src/auth/agattp_abstract_auth.dart';
import 'package:crypto/crypto.dart';

///
///
///
enum DigestAlgorithm {
  md5,
  sha256;

  ///
  ///
  ///
  static DigestAlgorithm parse(dynamic value) {
    final String name =
        value.toString().toLowerCase().replaceAll(RegExp(r'-|\s|_'), '');

    for (final DigestAlgorithm algorithm in DigestAlgorithm.values) {
      if (algorithm.name == name) {
        return algorithm;
      }
    }

    return DigestAlgorithm.md5;
  }
}

///
///
///
class AgattpAuthDigest extends AgattpAbstractAuth {
  final String username;
  final String password;

  final Map<String, String> map = <String, String>{};

  bool _ready = false;
  int _nc = 0;
  late String _realm;
  late String _nonce;
  late String _qop;
  late String _cnonce;
  late DigestAlgorithm _algorithm;

  ///
  ///
  ///
  AgattpAuthDigest({
    required this.username,
    required this.password,
  }) : super();

  ///
  ///
  ///
  void reset() {
    _ready = false;
    _nc = 0;
  }

  ///
  ///
  ///
  bool get ready => _ready;

  ///
  ///
  ///
  @override
  Future<Map<String, String>> getAuthHeaders(
    AgattpMethod method,
    Uri uri,
  ) async {
    if (!_ready) {
      final AgattpResponse response = await Agattp().get(uri);

      final String wwwAuthenticate =
          response.headers.value(HttpHeaders.wwwAuthenticateHeader) ?? '';

      if (wwwAuthenticate.isEmpty) {
        throw Exception('WWW-Authenticate header not found');
      }

      final List<String> parts =
          wwwAuthenticate.replaceAll(RegExp('^[Dd]igest'), '').split(',');

      for (final String part in parts) {
        final List<String> p2 = Utils.splitFirst(part.trim(), '=');
        if (p2.length != 2) {
          continue;
        }

        map[p2.first.trim()] = p2.last.trim();
      }

      map.remove('stale');

      _algorithm = DigestAlgorithm.parse(map['algorithm']);

      _realm = map['realm'] ?? '';

      _nonce = map['nonce'] ?? '';

      _qop = map['qop'] ?? '';

      _cnonce =
          md5.convert(DateTime.now().toIso8601String().codeUnits).toString();

      _ready = true;
    }

    map['username'] = '"$username"';

    map['uri'] = '"${uri.path}"';

    map['realm'] = _realm;

    map['nonce'] = _nonce;

    map['qop'] = _qop;

    map['cnonce'] = '"$_cnonce"';

    _nc++;

    map['nc'] = _nc.toString().padLeft(8, '0');

    map['response'] = '"${_getResponse(
      username: username,
      realm: Utils.removeQuotes(_realm),
      password: password,
      method: method.name.toUpperCase(),
      path: uri.path,
      nonce: Utils.removeQuotes(_nonce),
      nc: map['nc']!,
      cnonce: _cnonce,
      qop: Utils.removeQuotes(_qop),
    )}"';

    final String token = map.entries
        .map((MapEntry<String, String> e) => '${e.key}=${e.value}')
        .join(', ');

    return <String, String>{HttpHeaders.authorizationHeader: 'Digest $token'};
  }

  ///
  ///
  ///
  String _getResponse({
    required String username,
    required String realm,
    required String password,
    required String method,
    required String path,
    required String nonce,
    required String nc,
    required String cnonce,
    required String qop,
  }) {
    late Hash hash;

    switch (_algorithm) {
      case DigestAlgorithm.md5:
        hash = md5;
        break;
      case DigestAlgorithm.sha256:
        hash = sha256;
        break;
    }

    final String h1 =
        hash.convert(utf8.encode('$username:$realm:$password')).toString();

    final String h2 = hash.convert(utf8.encode('$method:$path')).toString();

    return hash
        .convert(utf8.encode('$h1:$nonce:$nc:$cnonce:$qop:$h2'))
        .toString();
  }


}
