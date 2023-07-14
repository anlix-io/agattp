import 'dart:async';
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

    test('GET 201', () async {
      final AgattpResponse response =
          await Agattp().get(Uri.parse('https://httpbingo.org/status/201'));

      expect(response.statusCode, 201);
      expect(response.reasonPhrase, 'Created');
      expect(response.body, isEmpty);
    });

    test('HEAD', () async {
      final AgattpResponse response =
          await Agattp().head(Uri.parse('https://httpbingo.org/head'));

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

    test('POST Json', () async {
      final Map<String, dynamic> body = <String, dynamic>{
        'message': 'Hello World!',
      };

      final AgattpResponseJson<Map<String, dynamic>> response =
          await Agattp().postJson(
        Uri.parse('https://httpbingo.org/post'),
        body: body,
      );

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');
      expect(response.json['json'], body);
    });

    test('PUT', () async {
      final AgattpResponse response = await Agattp().put(
        Uri.parse('https://httpbingo.org/put'),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'text/plain',
        },
        body: 'Hello World!',
      );

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');
      expect(response.body, contains('"data": "Hello World!"'));
    });

    test('PATCH', () async {
      final AgattpResponse response = await Agattp().patch(
        Uri.parse('https://httpbingo.org/patch'),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'text/plain',
        },
        body: 'Hello World!',
      );

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');
      expect(response.body, contains('"data": "Hello World!"'));
    });

    test('DELETE', () async {
      final AgattpResponse response = await Agattp().delete(
        Uri.parse('https://httpbingo.org/delete'),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'text/plain',
        },
        body: 'Hello World!',
      );

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');
      expect(response.body, contains('"data": "Hello World!"'));
    });

    test('Timeout', () async {
      try {
        await Agattp(timeout: 2000).get(
          Uri.parse('https://httpbingo.org/delay/5'),
          headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'text/plain',
          },
        );
        fail('Should have thrown TimeoutException');
      } on Exception catch (e) {
        expect(e, isA<TimeoutException>());
      }
    });
  });
}
