import 'package:agattp/src/agattp_abstract_call.dart';
import 'package:agattp/src/agattp_method.dart';
import 'package:agattp/src/agattp_response.dart';
import 'package:agattp/src/web/agattp_response_web.dart';

import 'package:http/http.dart';

///
///
///
class AgattpCall extends AgattpAbstractCall {
  ///
  ///
  ///
  AgattpCall(super.config);

  ///
  ///
  ///
  @override
  Future<AgattpResponse> send({
    required AgattpMethod method,
    required Uri uri,
    required Map<String, String> headers,
    required String? body,
    required int? timeout,
  }) async {
    late final Response response;

    switch (method) {
      /// GET
      case AgattpMethod.get:
        response = await get(
          uri,
          headers: headers,
        ).timeout(Duration(milliseconds: timeout ?? config.timeout));
        break;

      /// POST
      case AgattpMethod.post:
        response = await post(
          uri,
          headers: headers,
          body: body,
          encoding: config.encoding,
        ).timeout(Duration(milliseconds: timeout ?? config.timeout));
        break;

      /// PUT
      case AgattpMethod.put:
        response = await put(
          uri,
          headers: headers,
          body: body,
          encoding: config.encoding,
        ).timeout(Duration(milliseconds: timeout ?? config.timeout));
        break;

      /// DELETE
      case AgattpMethod.delete:
        response = await delete(
          uri,
          headers: headers,
          body: body,
          encoding: config.encoding,
        ).timeout(Duration(milliseconds: timeout ?? config.timeout));
        break;

      /// HEAD
      case AgattpMethod.head:
        response = await head(
          uri,
          headers: headers,
        ).timeout(Duration(milliseconds: timeout ?? config.timeout));
        break;

      /// PATCH
      case AgattpMethod.patch:
        response = await patch(
          uri,
          headers: headers,
          body: body,
          encoding: config.encoding,
        ).timeout(Duration(milliseconds: timeout ?? config.timeout));
        break;
    }

    return AgattpResponseWeb(response);
  }
}
