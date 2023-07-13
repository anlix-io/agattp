import 'dart:io';

///
///
///
class AgattpResponse {
  final HttpClientResponse response;
  final String body;

  ///
  ///
  ///
  AgattpResponse(this.response, this.body);

  ///
  ///
  ///
  int get statusCode => response.statusCode;

  ///
  ///
  ///
  String get reasonPhrase => response.reasonPhrase;

  ///
  ///
  ///
  bool get isRedirect => response.isRedirect;

  ///
  ///
  ///
  bool get isPersistentConnection => response.persistentConnection;

  ///
  ///
  ///
  HttpHeaders get headers => response.headers;

  ///
  ///
  ///
  List<Cookie> get cookies => response.cookies;
}
