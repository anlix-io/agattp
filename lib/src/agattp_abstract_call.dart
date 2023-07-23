import 'package:agattp/src/agattp_config.dart';
import 'package:agattp/src/agattp_method.dart';
import 'package:agattp/src/agattp_response.dart';

///
///
///
abstract class AgattpAbstractCall {
  final AgattpConfig config;

  ///
  ///
  ///
  AgattpAbstractCall(this.config);

  ///
  ///
  ///
  Future<AgattpResponse> send({
    required AgattpMethod method,
    required Uri uri,
    required Map<String, String> headers,
    required String? body,
    required int? timeout,
  });
}
