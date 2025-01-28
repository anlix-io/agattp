import 'dart:io';

import 'package:agattp/src/agattp_config.dart';
import 'package:agattp/src/agattp_method.dart';
import 'package:agattp/src/agattp_request.dart';
import 'package:agattp/src/agattp_response.dart';
import 'package:agattp/src/agattp_utils.dart';
import 'package:agattp/src/native/agattp_response.dart';

/// A concrete implementation of the Request interface that implements the
/// request using Flutter's native HttpClientRequest and HttpClientResponse
/// classes
class AgattpRequest<T, R extends AgattpResponse>
    implements AgattpRequestInterface<T, R> {
  @override
  final AgattpConfig config;

  AgattpRequest(this.config);

  R _makeResponse(HttpClientResponse response, String body) {
    // (R is AgattpJsonResponse) doesn't work here, we need this workaround,
    // purely because "R" is ambiguous - do you mean the generic Type template
    // argument, or the value that resides in "R" at runtime? Instantiating a
    // list like this will work around this by removing the second possibility,
    // forcing the cast check to work properly.
    // https://github.com/dart-lang/sdk/issues/43390
    // ignore: always_specify_types
    return <R>[] is List<AgattpJsonResponse>
      ? AgattpJsonResponseNative<T>(response, body) as R
      : AgattpResponseNative(response, body) as R;
  }

  @override
  Future<R> send({
    required AgattpMethod method,
    required Uri uri,
    required Duration? timeout,
    required String? body,
    Map<String, String> headers = const <String, String>{},
  }) async {
    final HttpClient client = HttpClient()..badCertificateCallback =
        config.badCertificateCallback;

    final HttpClientRequest request = await switch (method) {
      AgattpMethod.get => client.getUrl(uri),
      AgattpMethod.post => client.postUrl(uri),
      AgattpMethod.put => client.putUrl(uri),
      AgattpMethod.delete => client.deleteUrl(uri),
      AgattpMethod.head => client.headUrl(uri),
      AgattpMethod.patch => client.patchUrl(uri),
    };

    request.followRedirects = config.followRedirects;

    final Map<String, String> newHeaders = Utils.headers(
      headers,
      config.headerKeyCase,
    );

    for (final MapEntry<String, String> entry in newHeaders.entries) {
      request.headers.set(entry.key, entry.value, preserveHeaderCase: true);
    }

    if (body != null) {
      request.write(body);
    }

    final HttpClientResponse response = await request.close().timeout(
      timeout ?? config.timeout,
    );

    final String responseBody =
        await response.transform(config.encoding.decoder).join();

    final R agattpResponse = _makeResponse(response, responseBody);

    client.close(force: config.forceClose);

    return agattpResponse;
  }
}
