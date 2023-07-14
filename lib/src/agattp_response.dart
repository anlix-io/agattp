import 'dart:convert';
import 'dart:io';

///
///
///
class AgattpResponse {
  final HttpClientResponse clientResponse;
  final String body;

  ///
  ///
  ///
  AgattpResponse(this.clientResponse, this.body);

  ///
  ///
  ///
  int get statusCode => clientResponse.statusCode;

  ///
  ///
  ///
  String get reasonPhrase => clientResponse.reasonPhrase;

  ///
  ///
  ///
  bool get isRedirect => clientResponse.isRedirect;

  ///
  ///
  ///
  bool get isPersistentConnection => clientResponse.persistentConnection;

  ///
  ///
  ///
  HttpHeaders get headers => clientResponse.headers;

  ///
  ///
  ///
  List<Cookie> get cookies => clientResponse.cookies;
}

///
///
///
class AgattpResponseJson<T> extends AgattpResponse {
  ///
  ///
  ///
  AgattpResponseJson(super.clientResponse, super.body);

  ///
  ///
  ///
  T get json => jsonDecode(body) as T;
}
