import 'dart:io';

import 'package:agattp/src/auth/agattp_abstract_auth.dart';

///
///
///
class AgattpAuthBearer extends AgattpAbstractAuth {
  final String? token;

  ///
  ///
  ///
  const AgattpAuthBearer(this.token) : super();

  ///
  ///
  ///
  @override
  Future<Map<String, String>> getAuthHeaders(_, __) async => <String, String>{
        if (token != null && token!.isNotEmpty)
          HttpHeaders.authorizationHeader: 'Bearer $token',
      };
}
