import 'dart:convert';
import 'dart:io';

import 'package:agattp/src/agattp_response.dart';

///
///
///
class AgattpResponseJson<T> extends AgattpResponse {
  final AgattpResponse _response;

  ///
  ///
  ///
  AgattpResponseJson(AgattpResponse response) : _response = response;

  ///
  ///
  ///
  T get json => jsonDecode(body) as T;

  ///
  ///
  ///
  @override
  String get body => _response.body;

  ///
  ///
  ///
  @override
  int get statusCode => _response.statusCode;

  ///
  ///
  ///
  @override
  String get reasonPhrase => _response.reasonPhrase;

  ///
  ///
  ///
  @override
  bool get isRedirect => _response.isRedirect;

  ///
  ///
  ///
  @override
  bool get isPersistentConnection => _response.isPersistentConnection;

  ///
  ///
  ///
  @override
  HttpHeaders get headers => _response.headers;

  ///
  ///
  ///
  @override
  List<Cookie> get cookies => _response.cookies;
}
