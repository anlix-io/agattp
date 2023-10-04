import 'package:agattp/src/agattp_abstract_call.dart';
import 'package:agattp/src/agattp_method.dart';
import 'package:agattp/src/agattp_response.dart';

///
///
///
class AgattpCall extends AgattpAbstractCall {
  ///
  ///
  ///
  AgattpCall(super.config);

  ///
  ///
  ///
  @override
  Future<AgattpResponse> send({
    required AgattpMethod method,
    required Uri uri,
    required Map<String, String> headers,
    required String? body,
    required int? timeout,
  }) async {
    throw UnimplementedError('AgattpStubCall.send() is not implemented.');
  }
}
