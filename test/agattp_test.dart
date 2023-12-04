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
      expect(response.isRedirect, false);
      expect(response.isPersistentConnection, true);
      expect(response.headers, isA<HttpHeaders>());
      expect(response.cookies, isEmpty);
      expect(response.body, isEmpty);
    });

    test('GET 201', () async {
      final AgattpResponse response =
          await Agattp().get(Uri.parse('https://httpbingo.org/status/201'));

      expect(response.statusCode, 201);
      expect(response.reasonPhrase, 'Created');
      expect(response.body, isEmpty);
    });

    test('GET Json', () async {
      const String url = 'https://httpbingo.org/get?test=ok';

      final AgattpResponseJson<Map<String, dynamic>> response =
          await Agattp().getJson(Uri.parse(url));

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');
      expect(response.json['url'], url);
    });

    test('GET Json No Content', () async {
      const String url = 'https://httpbingo.org/status/204';

      final AgattpResponseJson<void> response =
          await Agattp().getJson(Uri.parse(url));

      expect(response.statusCode, 204);
      expect(response.reasonPhrase, 'No Content');
      expect(response.body, isEmpty);
    });

    test('HEAD', () async {
      final AgattpResponse response =
          await Agattp().head(Uri.parse('https://httpbingo.org/head'));

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');
      expect(response.body, isEmpty);
    });

    test('HEAD Json', () async {
      const String url = 'https://httpbingo.org/head?test=ok';

      final AgattpResponseJson<Map<String, dynamic>> response =
          await Agattp().headJson(Uri.parse(url));

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');
      expect(response.body, isEmpty);
    });

    test('HEAD Json No Content', () async {
      const String url = 'https://httpbingo.org/status/204';

      final AgattpResponseJson<void> response =
          await Agattp().headJson(Uri.parse(url));

      expect(response.statusCode, 204);
      expect(response.reasonPhrase, 'No Content');
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

    test('POST Json With Body', () async {
      const String url = 'https://httpbingo.org/post?test=ok';

      const Map<String, dynamic> body = <String, dynamic>{
        'message': 'Hello World!',
      };

      final AgattpResponseJson<Map<String, dynamic>> response =
          await Agattp().postJson(Uri.parse(url), body: body);

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');

      final Map<String, dynamic> json = response.json;

      expect(json['url'], url);
      expect(json['json'], body);
    });

    test('POST Json Without Body', () async {
      const String url = 'https://httpbingo.org/post?test=ok';

      final AgattpResponseJson<Map<String, dynamic>> response =
          await Agattp().postJson(Uri.parse(url));

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');

      final Map<String, dynamic> json = response.json;

      expect(json['json'], isNull);
      expect(json['url'], url);
    });

    test('POST Json No Content', () async {
      const String url = 'https://httpbingo.org/status/204';

      final AgattpResponseJson<void> response =
          await Agattp().postJson(Uri.parse(url));

      expect(response.statusCode, 204);
      expect(response.reasonPhrase, 'No Content');
      expect(response.body, isEmpty);
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

    test('PUT Json With Body', () async {
      const String url = 'https://httpbingo.org/put?test=ok';

      const Map<String, dynamic> body = <String, dynamic>{
        'message': 'Hello World!',
      };

      final AgattpResponseJson<Map<String, dynamic>> response =
          await Agattp().putJson(Uri.parse(url), body: body);

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');

      final Map<String, dynamic> json = response.json;

      expect(json['json'], body);
      expect(json['url'], url);
    });

    test('PUT Json Without Body', () async {
      const String url = 'https://httpbingo.org/put?test=ok';

      final AgattpResponseJson<Map<String, dynamic>> response =
          await Agattp().putJson(Uri.parse(url));

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');

      final Map<String, dynamic> json = response.json;

      expect(json['json'], isNull);
      expect(json['url'], url);
    });

    test('PUT Json No Content', () async {
      const String url = 'https://httpbingo.org/status/204';

      final AgattpResponseJson<void> response =
          await Agattp().putJson(Uri.parse(url));

      expect(response.statusCode, 204);
      expect(response.reasonPhrase, 'No Content');
      expect(response.body, isEmpty);
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

    test('PATCH Json With Body', () async {
      const String url = 'https://httpbingo.org/patch?test=ok';

      const Map<String, dynamic> body = <String, dynamic>{
        'message': 'Hello World!',
      };

      final AgattpResponseJson<Map<String, dynamic>> response =
          await Agattp().patchJson(Uri.parse(url), body: body);

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');

      final Map<String, dynamic> json = response.json;

      expect(json['json'], body);
      expect(json['url'], url);
    });

    test('PATCH Json Without Body', () async {
      const String url = 'https://httpbingo.org/patch?test=ok';

      final AgattpResponseJson<Map<String, dynamic>> response =
          await Agattp().patchJson(Uri.parse(url));

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');

      final Map<String, dynamic> json = response.json;

      expect(json['json'], isNull);
      expect(json['url'], url);
    });

    test('PATCH Json No Content', () async {
      const String url = 'https://httpbingo.org/status/204';

      final AgattpResponseJson<void> response =
          await Agattp().patchJson(Uri.parse(url));

      expect(response.statusCode, 204);
      expect(response.reasonPhrase, 'No Content');
      expect(response.body, isEmpty);
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

    test('DELETE Json With Body', () async {
      const String url = 'https://httpbingo.org/delete?test=ok';

      const Map<String, dynamic> body = <String, dynamic>{
        'message': 'Hello World!',
      };

      final AgattpResponseJson<Map<String, dynamic>> response =
          await Agattp().deleteJson(Uri.parse(url), body: body);

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');

      final Map<String, dynamic> json = response.json;

      expect(json['json'], body);
      expect(json['url'], url);
    });

    test('DELETE Json Without Body', () async {
      const String url = 'https://httpbingo.org/delete?test=ok';

      final AgattpResponseJson<Map<String, dynamic>> response =
          await Agattp().deleteJson(Uri.parse(url));

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');

      final Map<String, dynamic> json = response.json;

      expect(json['json'], isNull);
      expect(json['url'], url);
    });

    test('DELETE Json No Content', () async {
      const String url = 'https://httpbingo.org/status/204';

      final AgattpResponseJson<void> response =
          await Agattp().deleteJson(Uri.parse(url));

      expect(response.statusCode, 204);
      expect(response.reasonPhrase, 'No Content');
      expect(response.body, isEmpty);
    });

    test('Redirect', () async {
      final AgattpResponse response =
          await Agattp(config: const AgattpConfig(followRedirects: false))
              .get(Uri.parse('https://httpbingo.org/redirect/1'));

      expect(response.statusCode, 302);
      expect(response.reasonPhrase, 'Found');
      expect(response.isRedirect, true);
      expect(response.body, isEmpty);
    });

    test('Bearer Token', () async {
      final String token =
          DateTime.now().microsecondsSinceEpoch.toRadixString(16).toLowerCase();

      final AgattpResponseJson<Map<String, dynamic>> response =
          await Agattp.authBearer(token)
              .getJson(Uri.parse('https://httpbingo.org/bearer'));

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');
      expect(response.isRedirect, false);
      expect(response.json['authenticated'], true);
      expect(response.json['token'], token);
    });

    test('No Bearer Token', () async {
      final AgattpResponseJson<Map<String, dynamic>> response =
          await Agattp().getJson(Uri.parse('https://httpbingo.org/bearer'));

      expect(response.statusCode, 401);
      expect(response.reasonPhrase, 'Unauthorized');
      expect(response.isRedirect, false);
      expect(response.json, isNotEmpty);
    });

    test('Basic Auth', () async {
      const String user = 'user';
      const String pass = 'pass';

      final AgattpResponseJson<Map<String, dynamic>> response =
          await Agattp.authBasic(username: user, password: pass).getJson(
        Uri.parse('https://httpbingo.org/basic-auth/$user/$pass'),
      );

      expect(response.statusCode, 200);
      expect(response.reasonPhrase, 'OK');
      expect(response.isRedirect, false);
      expect(response.json['authorized'], true);
      expect(response.json['user'], user);
    });

    test('Basic Auth Fail', () async {
      const String user = 'user';
      const String pass = 'pass';

      final AgattpResponseJson<Map<String, dynamic>> response =
          await Agattp.authBasic(username: user, password: pass).getJson(
        Uri.parse('https://httpbingo.org/basic-auth/$user/a1$pass'),
      );

      expect(response.statusCode, 401);
      expect(response.reasonPhrase, 'Unauthorized');
      expect(response.isRedirect, false);
      expect(response.json['authorized'], false);
      expect(response.json['user'], user);
    });

    test('Timeout', () async {
      try {
        await Agattp().get(
          Uri.parse('https://httpbingo.org/delay/5'),
          headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'text/plain',
          },
          timeout: 2000,
        );
        fail('Should have thrown TimeoutException');
      } on Exception catch (e) {
        expect(e, isA<TimeoutException>());
      }
    });
  });
}
