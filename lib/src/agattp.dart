import 'dart:convert';
import 'dart:io';

import 'package:agattp/agattp.dart';

import 'package:agattp/src/agattp_call.dart'
    if (dart.library.io) 'package:agattp/src/native/agattp_call.dart'
    if (dart.library.js) 'package:agattp/src/web/agattp_call.dart';

import 'package:agattp/src/agattp_method.dart';
import 'package:agattp/src/auth/agattp_auth_digest.dart';

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
  factory Agattp.authBearer(String? token) => Agattp(
        config: AgattpConfig(
          auth: AgattpAuthBearer(token),
        ),
      );

  ///
  ///
  ///
  factory Agattp.authBasic({
    required String username,
    required String password,
  }) =>
      Agattp(
        config: AgattpConfig(
          auth: AgattpAuthBasic(username: username, password: password),
        ),
      );

  ///
  ///
  ///
  factory Agattp.authDigest({
    required String username,
    required String password,
  }) =>
      Agattp(
        config: AgattpConfig(
          auth: AgattpAuthDigest(username: username, password: password),
        ),
      );

  ///
  ///
  ///
  Future<Map<String, String>> _headers({
    required AgattpMethod method,
    required Uri uri,
    required Map<String, String> extraHeaders,
  }) async =>
      <String, String>{
        if (config.auth != null)
          ...await config.auth!.getAuthHeaders(method, uri),
        ...extraHeaders,
      };

  ///
  ///
  ///
  Future<Map<String, String>> _jsonHeaders({
    required Uri uri,
    required AgattpMethod method,
    required Map<String, String> extraHeaders,
    required bool hasBody,
  }) async =>
      <String, String>{
        // HttpHeaders.acceptEncodingHeader: 'application/json',
        if (hasBody)
          HttpHeaders.contentTypeHeader:
              'application/json; charset=${config.encoding.name}',
        ...await _headers(uri: uri, method: method, extraHeaders: extraHeaders),
      };

  ///
  ///
  ///
  Future<AgattpResponse> get(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    int? timeout,
  }) async =>
      AgattpCall(config).send(
        method: AgattpMethod.get,
        uri: uri,
        headers: await _headers(
          uri: uri,
          method: AgattpMethod.get,
          extraHeaders: headers,
        ),
        body: null,
        timeout: timeout,
      );

  ///
  ///
  ///
  Future<AgattpResponseJson<T>> getJson<T>(
    Uri uri, {
    Map<String, String> extraHeaders = const <String, String>{},
    int? timeout,
  }) async =>
      AgattpResponseJson<T>(
        await AgattpCall(config).send(
          method: AgattpMethod.get,
          uri: uri,
          headers: await _jsonHeaders(
            uri: uri,
            method: AgattpMethod.get,
            extraHeaders: extraHeaders,
            hasBody: false,
          ),
          body: null,
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
        headers: await _headers(
          uri: uri,
          method: AgattpMethod.head,
          extraHeaders: headers,
        ),
        body: null,
        timeout: timeout,
      );

  ///
  ///
  ///
  Future<AgattpResponseJson<T>> headJson<T>(
    Uri uri, {
    Map<String, String> extraHeaders = const <String, String>{},
    int? timeout,
  }) async =>
      AgattpResponseJson<T>(
        await AgattpCall(config).send(
          method: AgattpMethod.head,
          uri: uri,
          headers: await _jsonHeaders(
            uri: uri,
            method: AgattpMethod.head,
            extraHeaders: extraHeaders,
            hasBody: false,
          ),
          body: null,
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
        headers: await _headers(
          uri: uri,
          method: AgattpMethod.post,
          extraHeaders: headers,
        ),
        body: body,
        timeout: timeout,
      );

  ///
  ///
  ///
  Future<AgattpResponseJson<T>> postJson<T>(
    Uri uri, {
    dynamic body,
    Map<String, String> extraHeaders = const <String, String>{},
    int? timeout,
  }) async =>
      AgattpResponseJson<T>(
        await AgattpCall(config).send(
          method: AgattpMethod.post,
          uri: uri,
          headers: await _jsonHeaders(
            uri: uri,
            method: AgattpMethod.post,
            extraHeaders: extraHeaders,
            hasBody: body != null,
          ),
          body: jsonEncode(body),
          timeout: timeout,
        ),
      );

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
        headers: await _headers(
          uri: uri,
          method: AgattpMethod.put,
          extraHeaders: headers,
        ),
        body: body,
        timeout: timeout,
      );

  ///
  ///
  ///
  Future<AgattpResponseJson<T>> putJson<T>(
    Uri uri, {
    dynamic body,
    Map<String, String> extraHeaders = const <String, String>{},
    int? timeout,
  }) async =>
      AgattpResponseJson<T>(
        await AgattpCall(config).send(
          method: AgattpMethod.put,
          uri: uri,
          headers: await _jsonHeaders(
            uri: uri,
            method: AgattpMethod.put,
            extraHeaders: extraHeaders,
            hasBody: body != null,
          ),
          body: jsonEncode(body),
          timeout: timeout,
        ),
      );

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
        headers: await _headers(
          uri: uri,
          method: AgattpMethod.patch,
          extraHeaders: headers,
        ),
        body: body,
        timeout: timeout,
      );

  ///
  ///
  ///
  Future<AgattpResponseJson<T>> patchJson<T>(
    Uri uri, {
    dynamic body,
    Map<String, String> extraHeaders = const <String, String>{},
    int? timeout,
  }) async =>
      AgattpResponseJson<T>(
        await AgattpCall(config).send(
          method: AgattpMethod.patch,
          uri: uri,
          headers: await _jsonHeaders(
            uri: uri,
            method: AgattpMethod.patch,
            extraHeaders: extraHeaders,
            hasBody: body != null,
          ),
          body: jsonEncode(body),
          timeout: timeout,
        ),
      );

  ///
  ///
  ///
  Future<AgattpResponse> delete(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
    int? timeout,
  }) async =>
      AgattpCall(config).send(
        method: AgattpMethod.delete,
        uri: uri,
        headers: await _headers(
          uri: uri,
          method: AgattpMethod.delete,
          extraHeaders: headers,
        ),
        body: body,
        timeout: timeout,
      );

  ///
  ///
  ///
  Future<AgattpResponseJson<T>> deleteJson<T>(
    Uri uri, {
    dynamic body,
    Map<String, String> extraHeaders = const <String, String>{},
    int? timeout,
  }) async =>
      AgattpResponseJson<T>(
        await AgattpCall(config).send(
          method: AgattpMethod.delete,
          uri: uri,
          headers: await _jsonHeaders(
            uri: uri,
            method: AgattpMethod.delete,
            extraHeaders: extraHeaders,
            hasBody: body != null,
          ),
          body: jsonEncode(body),
          timeout: timeout,
        ),
      );
}
