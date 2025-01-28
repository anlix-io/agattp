import 'dart:io';

import 'package:agattp/src/agattp_config.dart';
import 'package:agattp/src/agattp_response.dart';
import 'package:agattp/src/web/agattp_web_headers.dart';
import 'package:http/http.dart';

/// A concrete implementation of the Response interface that reads data from
/// Flutter's web Response
class AgattpResponseWeb implements AgattpResponse {
  final Response _response;
  final AgattpConfig _config;

  AgattpResponseWeb(AgattpConfig config, Response response) :
    _response = response,
    _config = config;

  @override
  String get body => _config.encoding.decode(_response.bodyBytes);

  @override
  int get statusCode => _response.statusCode;

  @override
  String get reasonPhrase => _response.reasonPhrase ?? '';

  @override
  bool get isRedirect => _response.isRedirect;

  @override
  bool get isPersistentConnection => _response.persistentConnection;

  @override
  HttpHeaders get headers =>
      AgattpWebHeaders.from(_config.headerKeyCase, _response.headers);

  @override
  List<Cookie> get cookies =>
      AgattpWebHeaders.from(_config.headerKeyCase, _response.headers).cookies;
}

/// A concrete implementation of the Response interface that reads data from
/// Flutter's web Response, mixed with the JsonResponse mixin
class AgattpJsonResponseWeb<T> extends AgattpJsonResponse<T> {
  final Response _response;
  final AgattpConfig _config;

  AgattpJsonResponseWeb(AgattpConfig config, Response response) :
    _response = response,
    _config = config;

  @override
  String get body => _config.encoding.decode(_response.bodyBytes);

  @override
  int get statusCode => _response.statusCode;

  @override
  String get reasonPhrase => _response.reasonPhrase ?? '';

  @override
  bool get isRedirect => _response.isRedirect;

  @override
  bool get isPersistentConnection => _response.persistentConnection;

  @override
  HttpHeaders get headers =>
      AgattpWebHeaders.from(_config.headerKeyCase, _response.headers);

  @override
  List<Cookie> get cookies =>
      AgattpWebHeaders.from(_config.headerKeyCase, _response.headers).cookies;
}
