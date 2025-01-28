import 'dart:convert';
import 'dart:io';

import 'package:agattp/agattp.dart';
import 'package:agattp/src/agattp_method.dart';

import 'package:agattp/src/agattp_request.dart'
    if (dart.library.io) 'package:agattp/src/native/agattp_request.dart'
    if (dart.library.js) 'package:agattp/src/web/agattp_request.dart';

/// This class holds a group of configs for requests, applied to all requests
/// made through it. Contains a collection of helpful methods and constructors
/// to easily integrate HTTP requests into most Anlix code bases
class Agattp {
  /// The config applied to every request
  final AgattpConfig config;

  Agattp({this.config = const AgattpConfig()});

  /// Use default config with Bearer authentication
  factory Agattp.authBearer(String? token) => Agattp(
    config: AgattpConfig(auth: AgattpAuthBearer(token)),
  );

  /// Use default config with Basic Auth authentication
  factory Agattp.authBasic({
    required String username,
    required String password,
  }) =>
      Agattp(
    config: AgattpConfig(
      auth: AgattpAuthBasic(username: username, password: password),
    ),
  );

  /// Use default config with Digest authentication
  factory Agattp.authDigest({
    required String username,
    required String password,
  }) =>
      Agattp(
    config: AgattpConfig(
      auth: AgattpAuthDigest(username: username, password: password),
    ),
  );

  /// Retrieve the headers for this request - will return a copy of extraHeaders
  /// with the authentication headers inserted
  Future<Map<String, String>> _headers({
    required AgattpMethod method,
    required Uri uri,
    required Map<String, String> extraHeaders,
  }) async {
    if (config.auth == null) {
      return extraHeaders;
    }
    return Map<String, String>.from(extraHeaders)..addAll(
      await config.auth!.getAuthHeaders(method, uri),
    );
  }

  /// Retrieve the headers for this request - will return a copy of extraHeaders
  /// with the authentication headers inserted, as well as the JSON content-type
  /// header
  Future<Map<String, String>> _jsonHeaders({
    required Uri uri,
    required AgattpMethod method,
    required Map<String, String> extraHeaders,
    required bool hasBody,
  }) async {
    if (config.auth == null && !hasBody) {
      return extraHeaders;
    }
    final Map<String, String> headers = Map<String, String>.from(extraHeaders);
    if (config.auth != null) {
      headers.addAll(await config.auth!.getAuthHeaders(method, uri));
    }
    if (hasBody) {
      headers[HttpHeaders.contentTypeHeader] =
          'application/json; charset=${config.encoding.name}';
    }
    return headers;
  }

  Future<AgattpResponse> _sendRequest(
    AgattpMethod method,
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
    Duration? timeout,
  }) async {
    return AgattpRequest<void, AgattpResponse>(config).send(
      method: method,
      uri: uri,
      headers: await _headers(
        uri: uri,
        method: method,
        extraHeaders: headers,
      ),
      body: body,
      timeout: timeout,
    );
  }

  Future<AgattpJsonResponse<T>> _sendJsonRequest<T>(
    AgattpMethod method,
    Uri uri, {
    Map<String, String> extraHeaders = const <String, String>{},
    String? body,
    Duration? timeout,
  }) async {
    return AgattpRequest<T, AgattpJsonResponse<T>>(config).send(
      method: method,
      uri: uri,
      headers: await _jsonHeaders(
        uri: uri,
        method: method,
        extraHeaders: extraHeaders,
        hasBody: body != null,
      ),
      body: body,
      timeout: timeout,
    );
  }

  /// A simple GET HTTP request
  Future<AgattpResponse> get(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    Duration? timeout,
  }) {
    return _sendRequest(
      AgattpMethod.get,
      uri,
      headers: headers,
      timeout: timeout,
    );
  }

  /// A simple GET HTTP request that converts the response body to a JSON of
  /// type T - usually a Map<String, dynamic>
  Future<AgattpJsonResponse<T>> getJson<T>(
    Uri uri, {
    Map<String, String> extraHeaders = const <String, String>{},
    Duration? timeout,
  }) async {
    return _sendJsonRequest(
      AgattpMethod.get,
      uri,
      extraHeaders: extraHeaders,
      timeout: timeout,
    );
  }

  /// A simple HEAD HTTP request
  Future<AgattpResponse> head(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    Duration? timeout,
  }) async {
    return _sendRequest(
      AgattpMethod.head,
      uri,
      headers: headers,
      timeout: timeout,
    );
  }

  /// A simple HEAD HTTP request that converts the response body to a JSON of
  /// type T - usually a Map<String, dynamic>
  Future<AgattpJsonResponse<T>> headJson<T>(
    Uri uri, {
    Map<String, String> extraHeaders = const <String, String>{},
    Duration? timeout,
  }) async {
    return _sendJsonRequest(
      AgattpMethod.head,
      uri,
      extraHeaders: extraHeaders,
      timeout: timeout,
    );
  }

  /// A simple POST HTTP request
  Future<AgattpResponse> post(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
    Duration? timeout,
  }) async {
    return _sendRequest(
      AgattpMethod.post,
      uri,
      headers: headers,
      timeout: timeout,
      body: body,
    );
  }

  /// A simple POST HTTP request that converts the response body to a JSON of
  /// type T - usually a Map<String, dynamic>
  Future<AgattpJsonResponse<T>> postJson<T>(
    Uri uri, {
    dynamic body,
    Map<String, String> extraHeaders = const <String, String>{},
    Duration? timeout,
  }) async {
    return _sendJsonRequest(
      AgattpMethod.post,
      uri,
      extraHeaders: extraHeaders,
      body: body != null ? jsonEncode(body) : null,
      timeout: timeout,
    );
  }

  /// A simple PUT HTTP request
  Future<AgattpResponse> put(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
    Duration? timeout,
  }) async {
    return _sendRequest(
      AgattpMethod.put,
      uri,
      headers: headers,
      timeout: timeout,
      body: body,
    );
  }

  /// A simple PUT HTTP request that converts the response body to a JSON of
  /// type T - usually a Map<String, dynamic>
  Future<AgattpJsonResponse<T>> putJson<T>(
    Uri uri, {
    dynamic body,
    Map<String, String> extraHeaders = const <String, String>{},
    Duration? timeout,
  }) async {
    return _sendJsonRequest(
      AgattpMethod.put,
      uri,
      extraHeaders: extraHeaders,
      body: body != null ? jsonEncode(body) : null,
      timeout: timeout,
    );
  }

  /// A simple PATCH HTTP request
  Future<AgattpResponse> patch(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
    Duration? timeout,
  }) async {
    return _sendRequest(
      AgattpMethod.patch,
      uri,
      headers: headers,
      timeout: timeout,
      body: body,
    );
  }

  /// A simple PATCH HTTP request that converts the response body to a JSON of
  /// type T - usually a Map<String, dynamic>
  Future<AgattpJsonResponse<T>> patchJson<T>(
    Uri uri, {
    dynamic body,
    Map<String, String> extraHeaders = const <String, String>{},
    Duration? timeout,
  }) async {
    return _sendJsonRequest(
      AgattpMethod.patch,
      uri,
      extraHeaders: extraHeaders,
      body: body != null ? jsonEncode(body) : null,
      timeout: timeout,
    );
  }

  /// A simple DELETE HTTP request
  Future<AgattpResponse> delete(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
    Duration? timeout,
  }) async {
    return _sendRequest(
      AgattpMethod.delete,
      uri,
      headers: headers,
      timeout: timeout,
      body: body,
    );
  }

  /// A simple DELETE HTTP request that converts the response body to a JSON of
  /// type T - usually a Map<String, dynamic>
  Future<AgattpJsonResponse<T>> deleteJson<T>(
    Uri uri, {
    dynamic body,
    Map<String, String> extraHeaders = const <String, String>{},
    Duration? timeout,
  }) async {
    return _sendJsonRequest(
      AgattpMethod.delete,
      uri,
      extraHeaders: extraHeaders,
      body: body != null ? jsonEncode(body) : null,
      timeout: timeout,
    );
  }
}
