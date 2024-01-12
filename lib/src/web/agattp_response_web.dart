import 'dart:io';

import 'package:agattp/agattp.dart';
import 'package:agattp/src/agattp_response.dart';
import 'package:agattp/src/agattp_utils.dart';
import 'package:agattp/src/web/agattp_web_headers.dart';
import 'package:http/http.dart';

///
///
///
class AgattpResponseWeb extends AgattpResponse {
  final Response _response;
  final AgattpWebHeaders _headers;

  ///
  ///
  ///
  AgattpResponseWeb( HeaderKeyCase keyCase, Response response)
      : _response = response,
        _headers = AgattpWebHeaders.from(keyCase, response.headers);

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
  String get reasonPhrase => _response.reasonPhrase ?? '';

  ///
  ///
  ///
  @override
  bool get isRedirect => _response.isRedirect;

  ///
  ///
  ///
  @override
  bool get isPersistentConnection => _response.persistentConnection;

  ///
  ///
  ///
  @override
  HttpHeaders get headers => _headers;

  ///
  ///
  ///
  @override
  List<Cookie> get cookies => _headers.cookies;
}
