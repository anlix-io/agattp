import 'dart:convert';
import 'dart:io';

import 'package:agattp/agattp.dart';

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
  final bool forceClose;
  final Encoding encoding = utf8;

  ///
  ///
  ///
  Agattp({
    BadCertificateCallback? badCertificateCallback,
    this.forceClose = false,
  }) : badCertificateCallback =
            badCertificateCallback ?? ((_, __, ___) => false);

  ///
  ///
  ///
  HttpClient _prepareClient() =>
      HttpClient()..badCertificateCallback = badCertificateCallback;

  ///
  ///
  ///
  void _prepareHeaders(
    HttpClientRequest request,
    Map<String, String> headers,
  ) {
    for (final MapEntry<String, String> entry in headers.entries) {
      request.headers.set(entry.key, entry.value);
    }
  }

  ///
  ///
  ///
  Future<AgattpResponse> _processResponse(HttpClientResponse response) async {
    final String responseBody =
        await response.transform(encoding.decoder).join();

    return AgattpResponse(response, responseBody);
  }

  ///
  ///
  ///
  Future<AgattpResponse> _send(
    HttpClient client,
    HttpClientRequest request,
    Map<String, String> headers,
    String? body,
  ) async {
    _prepareHeaders(request, headers);

    if (body != null) {
      request.write(body);
    }

    final HttpClientResponse response = await request.close();

    final AgattpResponse agattpResponse = await _processResponse(response);

    client.close(force: forceClose);

    return agattpResponse;
  }

  ///
  ///
  ///
  Future<AgattpResponse> get(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  }) async {
    final HttpClient client = _prepareClient();
    final HttpClientRequest request = await client.getUrl(uri);
    return _send(client, request, headers, null);
  }

  ///
  ///
  ///
  Future<AgattpResponse> head(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  }) async {
    final HttpClient client = _prepareClient();
    final HttpClientRequest request = await client.headUrl(uri);
    return _send(client, request, headers, null);
  }

  ///
  ///
  ///
  Future<AgattpResponse> post(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
  }) async {
    final HttpClient client = _prepareClient();
    final HttpClientRequest request = await client.postUrl(uri);
    return _send(client, request, headers, body);
  }

  ///
  ///
  ///
  Future<AgattpResponse> put(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
  }) async {
    final HttpClient client = _prepareClient();
    final HttpClientRequest request = await client.putUrl(uri);
    return _send(client, request, headers, body);
  }

  ///
  ///
  ///
  Future<AgattpResponse> patch(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
  }) async {
    final HttpClient client = _prepareClient();
    final HttpClientRequest request = await client.patchUrl(uri);
    return _send(client, request, headers, body);
  }

  ///
  ///
  ///
  Future<AgattpResponse> delete(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
  }) async {
    final HttpClient client = _prepareClient();
    final HttpClientRequest request = await client.deleteUrl(uri);
    return _send(client, request, headers, body);
  }
}
