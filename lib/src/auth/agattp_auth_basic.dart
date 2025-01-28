import 'dart:convert';
import 'dart:io';

import 'package:agattp/src/auth/agattp_abstract_auth.dart';

/// Implementation of the Basic Auth authentication strategy
class AgattpAuthBasic implements AgattpAuthInterface {
  /// The Basic Auth username
  final String username;

  /// The Basic Auth password
  final String password;

  const AgattpAuthBasic({
    required this.username,
    required this.password,
  });

  @override
  Future<Map<String, String>> getAuthHeaders(_, __) async => <String, String>{
    // Simply encode the username and password in base64
    HttpHeaders.authorizationHeader:
        'Basic ${base64.encode(utf8.encode('$username:$password'))}',
  };
}
