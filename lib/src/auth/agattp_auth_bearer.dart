import 'dart:io';

import 'package:agattp/src/auth/agattp_abstract_auth.dart';

/// Implementation of the Bearer Token authentication strategy
class AgattpAuthBearer implements AgattpAuthInterface {
  /// The Bearer Token used for authenticating in the server
  final String? token;

  const AgattpAuthBearer(this.token);

  @override
  Future<Map<String, String>> getAuthHeaders(_, __) async => <String, String>{
    if (token?.isNotEmpty ?? false)
      HttpHeaders.authorizationHeader: 'Bearer $token',
  };
}
