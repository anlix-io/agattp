import 'dart:convert';
import 'dart:io';

/// An interface to standardize HTTP responses
abstract class AgattpResponse {
  /// The response body, already encoded
  String get body;

  /// The response status code
  int get statusCode;

  /// The response status reason phrase
  String get reasonPhrase;

  /// Whether this response is a redirect or not
  bool get isRedirect;

  /// Whether this connection is persistent or not
  bool get isPersistentConnection;

  /// The response's headers
  HttpHeaders get headers;

  /// The response's cookies, already parsed from the header
  List<Cookie> get cookies;
}

/// Mixing this into a Response allows for easy json decoding and casting to
/// the provided type
mixin JsonResponse<T> on AgattpResponse {
  /// Decode the body as a JSON and cast it to T
  T get json => jsonDecode(body) as T;
}

/// An extension on the AgattoResponse class mixed with JsonResponse
abstract class AgattpJsonResponse<T> extends AgattpResponse
    with JsonResponse<T> {}
