import 'package:agattp/src/agattp_config.dart';
import 'package:agattp/src/agattp_method.dart';
import 'package:agattp/src/agattp_request.dart';
import 'package:agattp/src/agattp_response.dart';
import 'package:agattp/src/agattp_utils.dart';
import 'package:agattp/src/web/agattp_response.dart';

import 'package:http/http.dart';

/// A concrete implementation of the Request interface that implements the
/// request using Flutter's web classes
class AgattpRequest<T, R extends AgattpResponse>
    implements AgattpRequestInterface<T, R> {
  @override
  final AgattpConfig config;

  AgattpRequest(this.config);

  R _makeResponse(AgattpConfig config, Response response) {
    // (R is AgattpJsonResponse) doesn't work here, we need this workaround,
    // purely because "R" is ambiguous - do you mean the generic Type template
    // argument, or the value that resides in "R" at runtime? Instantiating a
    // list like this will work around this by removing the second possibility,
    // forcing the cast check to work properly.
    // https://github.com/dart-lang/sdk/issues/43390
    // ignore: always_specify_types
    return <R>[] is List<AgattpJsonResponse>
      ? AgattpJsonResponseWeb<T>(config, response) as R
      : AgattpResponseWeb(config, response) as R;
  }

  @override
  Future<R> send({
    required AgattpMethod method,
    required Uri uri,
    required Duration? timeout,
    required String? body,
    Map<String, String> headers = const <String, String>{},
  }) async {
    final Response response = await switch (method) {
      AgattpMethod.get => get(
          uri,
          headers: Utils.headers(headers, config.headerKeyCase),
        ).timeout(timeout ?? config.timeout),
      AgattpMethod.post => post(
          uri,
          headers: Utils.headers(headers, config.headerKeyCase),
          body: body,
          encoding: config.encoding,
        ).timeout(timeout ?? config.timeout),
      AgattpMethod.put => put(
          uri,
          headers: Utils.headers(headers, config.headerKeyCase),
          body: body,
          encoding: config.encoding,
        ).timeout(timeout ?? config.timeout),
      AgattpMethod.delete => delete(
          uri,
          headers: Utils.headers(headers, config.headerKeyCase),
          body: body,
          encoding: config.encoding,
        ).timeout(timeout ?? config.timeout),
      AgattpMethod.head => head(
          uri,
          headers: Utils.headers(headers, config.headerKeyCase),
        ).timeout(timeout ?? config.timeout),
      AgattpMethod.patch => patch(
          uri,
          headers: Utils.headers(headers, config.headerKeyCase),
          body: body,
          encoding: config.encoding,
        ).timeout(timeout ?? config.timeout),
    };

    return _makeResponse(config, response);
  }
}
