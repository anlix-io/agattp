import 'package:agattp/src/agattp_config.dart';
import 'package:agattp/src/agattp_method.dart';
import 'package:agattp/src/agattp_response.dart';

/// An interface to standardize HTTP requests with a given config
abstract class AgattpRequestInterface<T, R extends AgattpResponse> {
  /// The config to use when making the request
  AgattpConfig get config;

  /// Actually send the request and return a Future with the response
  Future<R> send({
    required AgattpMethod method,
    required Uri uri,
    required String? body,
    required Duration? timeout,
    Map<String, String> headers = const <String, String>{},
  });
}

/// A concrete implementation of the Request interface that stubs the send call
/// to throw an UnimplementedError, in case the native or web implementations
/// are not called for whatever reason
class AgattpRequest<T, R extends AgattpResponse>
    implements AgattpRequestInterface<T, R> {
  @override
  final AgattpConfig config;

  AgattpRequest(this.config);

  @override
  Future<R> send({
    required AgattpMethod method,
    required Uri uri,
    required String? body,
    required Duration? timeout,
    Map<String, String> headers = const <String, String>{},
  }) async {
    // The stub implementation throws an error since no implementation is
    // provided - likely missing an implementation like native / web
    throw UnimplementedError('AgattpStubCall.send() is not implemented.');
  }
}
