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
  AgattpCall(super.parent);

  ///
  ///
  ///
  @override
  Future<AgattpResponse> send<T>({
    required AgattpMethod method,
    required Uri uri,
    required Map<String, String> headers,
    required String? body,
  }) async {
    throw UnimplementedError('AgattpStubCall.send() is not implemented.');
  }
}
