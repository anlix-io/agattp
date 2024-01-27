import 'dart:io';

import 'package:agattp/src/agattp_config.dart';
import 'package:agattp/src/agattp_response.dart';
import 'package:agattp/src/web/agattp_web_headers.dart';
import 'package:http/http.dart';

///
///
///
class AgattpResponseWeb extends AgattpResponse {
  final Response _response;
  final AgattpConfig _config;

  ///
  ///
  ///
  AgattpResponseWeb(AgattpConfig config, Response response)
      : _response = response,
        _config = config;

  ///
  ///
  ///
  @override
  String get body => _config.encoding.decode(_response.body.codeUnits);

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
  HttpHeaders get headers =>
      AgattpWebHeaders.from(_config.headerKeyCase, _response.headers);

  ///
  ///
  ///
  @override
  List<Cookie> get cookies =>
      AgattpWebHeaders.from(_config.headerKeyCase, _response.headers).cookies;
}
