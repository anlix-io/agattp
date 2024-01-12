import 'package:agattp/src/agattp_method.dart';

///
///
///
abstract class AgattpAbstractAuth {
  ///
  ///
  ///
  const AgattpAbstractAuth();

  ///
  ///
  ///
  Future<Map<String, String>> getAuthHeaders(AgattpMethod method, Uri uri);
}
