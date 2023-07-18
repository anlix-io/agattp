import 'package:agattp/src/agattp.dart';
import 'package:agattp/src/agattp_method.dart';
import 'package:agattp/src/agattp_response.dart';

///
///
///
abstract class AgattpAbstractCall {
  final Agattp parent;

  ///
  ///
  ///
  AgattpAbstractCall(this.parent);

  ///
  ///
  ///
  Future<AgattpResponse> send<T>({
    required AgattpMethod method,
    required Uri uri,
    required Map<String, String> headers,
    required String? body,
  });
}
