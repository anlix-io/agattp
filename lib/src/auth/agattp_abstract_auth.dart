import 'package:agattp/src/agattp_method.dart';

/// An interface for HTTP Authentication strategies
// ignore: one_member_abstracts
abstract class AgattpAuthInterface {
  const AgattpAuthInterface();

  /// Returns the headers to be used for authentication. Method and URI are only
  /// ever required for Digest, but we include them in the interface anyway
  Future<Map<String, String>> getAuthHeaders(AgattpMethod method, Uri uri);
}
