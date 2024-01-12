import 'dart:io';

import 'package:agattp/src/agattp_abstract_call.dart';
import 'package:agattp/src/agattp_method.dart';
import 'package:agattp/src/agattp_response.dart';
import 'package:agattp/src/agattp_utils.dart';
import 'package:agattp/src/native/agattp_response_native.dart';

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
    final HttpClient client = HttpClient()
      ..badCertificateCallback = config.badCertificateCallback;

    late final HttpClientRequest request;

    switch (method) {
      /// GET
      case AgattpMethod.get:
        request = await client.getUrl(uri);
        break;

      /// POST
      case AgattpMethod.post:
        request = await client.postUrl(uri);
        break;

      /// PUT
      case AgattpMethod.put:
        request = await client.putUrl(uri);
        break;

      /// DELETE
      case AgattpMethod.delete:
        request = await client.deleteUrl(uri);
        break;

      /// HEAD
      case AgattpMethod.head:
        request = await client.headUrl(uri);
        break;

      /// PATCH
      case AgattpMethod.patch:
        request = await client.patchUrl(uri);
        break;
    }

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

    final HttpClientResponse response = await request
        .close()
        .timeout(Duration(milliseconds: timeout ?? config.timeout));

    final String responseBody =
        await response.transform(config.encoding.decoder).join();

    final AgattpResponse agattpResponse =
        AgattpResponseNative(response, responseBody);

    client.close(force: config.forceClose);

    return agattpResponse;
  }
}
