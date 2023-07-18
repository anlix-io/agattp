import 'dart:io';

///
///
///
abstract class AgattpResponse {
  ///
  ///
  ///
  String get body;

  ///
  ///
  ///
  int get statusCode;

  ///
  ///
  ///
  String get reasonPhrase;

  ///
  ///
  ///
  bool get isRedirect;

  ///
  ///
  ///
  bool get isPersistentConnection;

  ///
  ///
  ///
  HttpHeaders get headers;

  ///
  ///
  ///
  List<Cookie> get cookies;
}
