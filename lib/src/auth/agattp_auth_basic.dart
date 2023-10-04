import 'dart:convert';
import 'dart:io';

import 'package:agattp/src/auth/agattp_abstract_auth.dart';

///
///
///
class AgattpAuthBasic extends AgattpAbstractAuth {
  final String username;
  final String password;

  ///
  ///
  ///
  const AgattpAuthBasic({
    required this.username,
    required this.password,
  }) : super();

  ///
  ///
  ///
  @override
  Map<String, String> get authHeaders => <String, String>{
        HttpHeaders.authorizationHeader:
            'Basic ${base64.encode(utf8.encode('$username:$password'))}',
      };
}
