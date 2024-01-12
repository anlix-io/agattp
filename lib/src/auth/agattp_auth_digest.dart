import 'dart:convert';
import 'dart:io';

import 'package:agattp/src/agattp.dart';
import 'package:agattp/src/agattp_method.dart';
import 'package:agattp/src/agattp_response.dart';
import 'package:agattp/src/auth/agattp_abstract_auth.dart';
import 'package:crypto/crypto.dart';

///
///
///
class AgattpAuthDigest extends AgattpAbstractAuth {
  final String username;
  final String password;

  final Map<String, String> map = <String, String>{};

  bool _ready = false;
  int nc = 0;
  late String _realm;
  late String _nonce;
  late String _qop;
  late String _cnonce;

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
        final List<String> p2 = _splitFirst(part.trim(), '=');
        if (p2.length != 2) {
          continue;
        }

        map[p2.first.trim()] = p2.last.trim();
      }

      map.remove('stale');

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

    nc++;

    map['nc'] = nc.toString().padLeft(8, '0');

    map['response'] = '"${_getResponse(
      username: username,
      realm: _realm.replaceAll(RegExp(r'^"|"$'), ''),
      password: password,
      method: method.name.toUpperCase(),
      path: uri.path,
      nonce: _nonce.replaceAll(RegExp(r'^"|"$'), ''),
      nc: map['nc']!,
      cnonce: _cnonce,
      qop: _qop.replaceAll(RegExp(r'^"|"$'), ''),
    )}"';

    final String token = map.entries
        .map((MapEntry<String, String> e) => '${e.key}=${e.value}')
        .join(', ');

    print('Token: $token');

    return <String, String>{
      HttpHeaders.authorizationHeader: 'Digest $token',
    };
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
    final String h1 =
        md5.convert(utf8.encode('$username:$realm:$password')).toString();

    final String h2 = md5.convert(utf8.encode('$method:$path')).toString();

    return md5
        .convert(utf8.encode('$h1:$nonce:$nc:$cnonce:$qop:$h2'))
        .toString();
  }

  ///
  ///
  ///
  List<String> _splitFirst(String value, String separator) {
    final int index = value.indexOf(separator);

    if (index == -1) {
      return <String>[value];
    }

    return <String>[
      value.substring(0, index),
      value.substring(index + separator.length),
    ];
  }
}
