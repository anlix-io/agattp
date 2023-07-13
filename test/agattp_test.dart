import 'dart:io';

import 'package:agattp/agattp.dart';
import 'package:test/test.dart';

///
///
///
void main() {
  ///
  group('Basic Online Tests', () {
    test('GET 200', () async {
      final AgattpResponse response =
          await Agattp().get(Uri.parse('https://httpbingo.org/status/200'));

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');
      expect(response.body, isEmpty);
    });

    test('POST', () async {
      final AgattpResponse response = await Agattp().post(
        Uri.parse('https://httpbingo.org/post'),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'text/plain',
        },
        body: 'Hello World!',
      );

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');
      expect(response.body, contains('"data": "Hello World!"'));
    });
  });
}
