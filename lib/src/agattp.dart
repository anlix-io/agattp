import 'dart:convert';
import 'dart:io';

import 'package:agattp/agattp.dart';

import 'package:agattp/src/agattp_call.dart'
    if (dart.library.io) 'package:agattp/src/native/agattp_call.dart'
    if (dart.library.js) 'package:agattp/src/web/agattp_call.dart';

import 'package:agattp/src/agattp_method.dart';

///
///
///
class Agattp {
  final AgattpConfig config;

  ///
  ///
  ///
  Agattp({this.config = const AgattpConfig()});

  ///
  ///
  ///
  Map<String, String> _jsonHeaders({
    required String? bearerToken,
    required Map<String, String> extraHeaders,
    required bool hasBody,
  }) {
    return <String, String>{
      HttpHeaders.acceptEncodingHeader: 'application/json',
      if (hasBody)
        HttpHeaders.contentTypeHeader:
            'application/json; charset=${config.encoding.name}',
      if (bearerToken != null && bearerToken.isNotEmpty)
        HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
      ...extraHeaders,
    };
  }

  ///
  ///
  ///
  Future<AgattpResponse> get(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    int? timeout,
  }) =>
      AgattpCall(config).send(
        method: AgattpMethod.get,
        uri: uri,
        headers: headers,
        body: null,
        timeout: timeout,
      );

  ///
  ///
  ///
  Future<AgattpResponseJson<T>> getJson<T>(
    Uri uri, {
    String? bearerToken,
    Map<String, String> extraHeaders = const <String, String>{},
    int? timeout,
  }) async =>
      AgattpResponseJson<T>(
        await get(
          uri,
          headers: _jsonHeaders(
            bearerToken: bearerToken,
            extraHeaders: extraHeaders,
            hasBody: false,
          ),
          timeout: timeout,
        ),
      );

  ///
  ///
  ///
  Future<AgattpResponse> head(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    int? timeout,
  }) async =>
      AgattpCall(config).send(
        method: AgattpMethod.head,
        uri: uri,
        headers: headers,
        body: null,
        timeout: timeout,
      );

  ///
  ///
  ///
  Future<AgattpResponseJson<T>> headJson<T>(
    Uri uri, {
    String? bearerToken,
    Map<String, String> extraHeaders = const <String, String>{},
    int? timeout,
  }) async =>
      AgattpResponseJson<T>(
        await head(
          uri,
          headers: _jsonHeaders(
            bearerToken: bearerToken,
            extraHeaders: extraHeaders,
            hasBody: false,
          ),
          timeout: timeout,
        ),
      );

  ///
  ///
  ///
  Future<AgattpResponse> post(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
    int? timeout,
  }) async =>
      AgattpCall(config).send(
        method: AgattpMethod.post,
        uri: uri,
        headers: headers,
        body: body,
        timeout: timeout,
      );

  ///
  ///
  ///
  Future<AgattpResponseJson<T>> postJson<T>(
    Uri uri, {
    dynamic body,
    String? bearerToken,
    Map<String, String> extraHeaders = const <String, String>{},
    int? timeout,
  }) async {
    return AgattpResponseJson<T>(
      await post(
        uri,
        headers: _jsonHeaders(
          bearerToken: bearerToken,
          extraHeaders: extraHeaders,
          hasBody: body != null,
        ),
        body: jsonEncode(body),
        timeout: timeout,
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
    int? timeout,
  }) async =>
      AgattpCall(config).send(
        method: AgattpMethod.put,
        uri: uri,
        headers: headers,
        body: body,
        timeout: timeout,
      );

  ///
  ///
  ///
  Future<AgattpResponseJson<T>> putJson<T>(
    Uri uri, {
    dynamic body,
    String? bearerToken,
    Map<String, String> extraHeaders = const <String, String>{},
    int? timeout,
  }) async {
    return AgattpResponseJson<T>(
      await put(
        uri,
        headers: _jsonHeaders(
          bearerToken: bearerToken,
          extraHeaders: extraHeaders,
          hasBody: body != null,
        ),
        body: jsonEncode(body),
        timeout: timeout,
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
    int? timeout,
  }) async =>
      AgattpCall(config).send(
        method: AgattpMethod.patch,
        uri: uri,
        headers: headers,
        body: body,
        timeout: timeout,
      );

  ///
  ///
  ///
  Future<AgattpResponseJson<T>> patchJson<T>(
    Uri uri, {
    dynamic body,
    String? bearerToken,
    Map<String, String> extraHeaders = const <String, String>{},
    int? timeout,
  }) async {
    return AgattpResponseJson<T>(
      await patch(
        uri,
        headers: _jsonHeaders(
          bearerToken: bearerToken,
          extraHeaders: extraHeaders,
          hasBody: body != null,
        ),
        body: jsonEncode(body),
        timeout: timeout,
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
    int? timeout,
  }) async {
    return AgattpCall(config).send(
      method: AgattpMethod.delete,
      uri: uri,
      headers: headers,
      body: body,
      timeout: timeout,
    );
  }

  ///
  ///
  ///
  Future<AgattpResponseJson<T>> deleteJson<T>(
    Uri uri, {
    dynamic body,
    String? bearerToken,
    Map<String, String> extraHeaders = const <String, String>{},
    int? timeout,
  }) async {
    return AgattpResponseJson<T>(
      await delete(
        uri,
        headers: _jsonHeaders(
          bearerToken: bearerToken,
          extraHeaders: extraHeaders,
          hasBody: body != null,
        ),
        body: jsonEncode(body),
        timeout: timeout,
      ),
    );
  }
}
