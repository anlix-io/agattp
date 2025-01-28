import 'dart:io';

import 'package:agattp/src/agattp_response.dart';

/// A concrete implementation of the Response interface that reads data from
/// Flutter's native HttpClientResponse
class AgattpResponseNative implements AgattpResponse {
  final HttpClientResponse _response;
  final String _body;

  AgattpResponseNative(HttpClientResponse response, String body) :
    _response = response,
    _body = body;

  @override
  String get body => _body;

  @override
  int get statusCode => _response.statusCode;

  @override
  String get reasonPhrase => _response.reasonPhrase;

  @override
  bool get isRedirect => _response.isRedirect;

  @override
  bool get isPersistentConnection => _response.persistentConnection;

  @override
  HttpHeaders get headers => _response.headers;

  @override
  List<Cookie> get cookies => _response.cookies;
}

/// A concrete implementation of the Response interface that reads data from
/// Flutter's native HttpClientResponse, mixed with the JsonResponse mixin
class AgattpJsonResponseNative<T> extends AgattpJsonResponse<T> {
  final HttpClientResponse _response;
  final String _body;

  AgattpJsonResponseNative(HttpClientResponse response, String body) :
    _response = response,
    _body = body;

  @override
  String get body => _body;

  @override
  int get statusCode => _response.statusCode;

  @override
  String get reasonPhrase => _response.reasonPhrase;

  @override
  bool get isRedirect => _response.isRedirect;

  @override
  bool get isPersistentConnection => _response.persistentConnection;

  @override
  HttpHeaders get headers => _response.headers;

  @override
  List<Cookie> get cookies => _response.cookies;
}
