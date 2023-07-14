import 'dart:convert';
import 'dart:io';

import 'package:agattp/agattp.dart';
import 'package:agattp/src/agattp_method.dart';

///
///
///
typedef BadCertificateCallback = bool Function(
  X509Certificate cert,
  String host,
  int port,
);

///
///
///
class Agattp {
  final BadCertificateCallback badCertificateCallback;
  final Duration timeout;
  final Encoding encoding;
  final bool forceClose;

  ///
  ///
  ///
  Agattp({
    BadCertificateCallback? badCertificateCallback,
    int? timeout,
    this.encoding = utf8,
    this.forceClose = false,
  })  : badCertificateCallback =
            badCertificateCallback ?? ((_, __, ___) => false),
        timeout = Duration(milliseconds: timeout ?? 60000);

  ///
  ///
  ///
  Map<String, String> _jsonHeaders({
    required String? bearerToken,
    required Map<String, String> extraHeaders,
    required bool hasBody,
  }) {
    return <String, String>{
      HttpHeaders.acceptCharsetHeader: 'application/json',
      if (hasBody)
        HttpHeaders.contentTypeHeader:
            'application/json; charset=${encoding.name}',
      if (bearerToken != null && bearerToken.isNotEmpty)
        HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
      ...extraHeaders,
    };
  }

  ///
  ///
  ///
  Future<AgattpResponse> _send<T>({
    required AgattpMethod method,
    required Uri uri,
    required Map<String, String> headers,
    String? body,
  }) async {
    final HttpClient client = HttpClient()
      ..badCertificateCallback = badCertificateCallback;

    late final HttpClientRequest request;

    switch (method) {
      case AgattpMethod.get:
        request = await client.getUrl(uri);
        break;
      case AgattpMethod.post:
        request = await client.postUrl(uri);
        break;
      case AgattpMethod.put:
        request = await client.putUrl(uri);
        break;
      case AgattpMethod.delete:
        request = await client.deleteUrl(uri);
        break;
      case AgattpMethod.head:
        request = await client.headUrl(uri);
        break;
      case AgattpMethod.patch:
        request = await client.patchUrl(uri);
        break;
    }

    for (final MapEntry<String, String> entry in headers.entries) {
      request.headers.set(entry.key, entry.value);
    }

    if (body != null) {
      request.write(body);
    }

    final HttpClientResponse response = await request.close().timeout(timeout);

    final String responseBody =
        await response.transform(encoding.decoder).join();

    final AgattpResponse agattpResponse =
        AgattpResponse(response, responseBody);

    client.close(force: forceClose);

    return agattpResponse;
  }

  ///
  ///
  ///
  Future<AgattpResponse> get(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  }) async =>
      _send(
        method: AgattpMethod.get,
        uri: uri,
        headers: headers,
      );

  ///
  ///
  ///
  Future<AgattpResponseJson<T>> getJson<T>(
    Uri uri, {
    String? bearerToken,
    Map<String, String> extraHeaders = const <String, String>{},
  }) async =>
      AgattpResponseJson<T>.fromAgattpResponse(
        await get(
          uri,
          headers: _jsonHeaders(
            bearerToken: bearerToken,
            extraHeaders: extraHeaders,
            hasBody: false,
          ),
        ),
      );

  ///
  ///
  ///
  Future<AgattpResponse> head(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  }) async =>
      _send(
        method: AgattpMethod.head,
        uri: uri,
        headers: headers,
      );

  ///
  ///
  ///
  Future<AgattpResponseJson<T>> headJson<T>(
    Uri uri, {
    String? bearerToken,
    Map<String, String> extraHeaders = const <String, String>{},
  }) async =>
      AgattpResponseJson<T>.fromAgattpResponse(
        await head(
          uri,
          headers: _jsonHeaders(
            bearerToken: bearerToken,
            extraHeaders: extraHeaders,
            hasBody: false,
          ),
        ),
      );

  ///
  ///
  ///
  Future<AgattpResponse> post(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
  }) async =>
      _send(
        method: AgattpMethod.post,
        uri: uri,
        headers: headers,
        body: body,
      );

  ///
  ///
  ///
  Future<AgattpResponseJson<T>> postJson<T>(
    Uri uri, {
    required dynamic body,
    String? bearerToken,
    Map<String, String> extraHeaders = const <String, String>{},
  }) async {
    return AgattpResponseJson<T>.fromAgattpResponse(
      await post(
        uri,
        headers: _jsonHeaders(
          bearerToken: bearerToken,
          extraHeaders: extraHeaders,
          hasBody: body != null,
        ),
        body: jsonEncode(body),
      ),
    );
  }

  ///
  ///
  ///
  Future<AgattpResponse> put(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
  }) async =>
      _send(
        method: AgattpMethod.put,
        uri: uri,
        headers: headers,
        body: body,
      );

  ///
  ///
  ///
  Future<AgattpResponseJson<T>> putJson<T>(
    Uri uri, {
    required dynamic body,
    String? bearerToken,
    Map<String, String> extraHeaders = const <String, String>{},
  }) async {
    return AgattpResponseJson<T>.fromAgattpResponse(
      await put(
        uri,
        headers: _jsonHeaders(
          bearerToken: bearerToken,
          extraHeaders: extraHeaders,
          hasBody: body != null,
        ),
        body: jsonEncode(body),
      ),
    );
  }

  ///
  ///
  ///
  Future<AgattpResponse> patch(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
  }) async =>
      _send(
        method: AgattpMethod.patch,
        uri: uri,
        headers: headers,
        body: body,
      );

  ///
  ///
  ///
  Future<AgattpResponseJson<T>> patchJson<T>(
    Uri uri, {
    required dynamic body,
    String? bearerToken,
    Map<String, String> extraHeaders = const <String, String>{},
  }) async {
    return AgattpResponseJson<T>.fromAgattpResponse(
      await patch(
        uri,
        headers: _jsonHeaders(
          bearerToken: bearerToken,
          extraHeaders: extraHeaders,
          hasBody: body != null,
        ),
        body: jsonEncode(body),
      ),
    );
  }

  ///
  ///
  ///
  Future<AgattpResponse> delete(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
  }) async {
    return _send(
      method: AgattpMethod.delete,
      uri: uri,
      headers: headers,
      body: body,
    );
  }

  ///
  ///
  ///
  Future<AgattpResponseJson<T>> deleteJson<T>(
    Uri uri, {
    required dynamic body,
    String? bearerToken,
    Map<String, String> extraHeaders = const <String, String>{},
  }) async {
    return AgattpResponseJson<T>.fromAgattpResponse(
      await delete(
        uri,
        headers: _jsonHeaders(
          bearerToken: bearerToken,
          extraHeaders: extraHeaders,
          hasBody: body != null,
        ),
        body: jsonEncode(body),
      ),
    );
  }
}
