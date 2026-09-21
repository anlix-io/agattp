import 'dart:io';
import 'dart:typed_data';

import 'package:agattp/agattp.dart';
import 'package:agattp/src/agattp_method.dart';
import 'package:agattp/src/agattp_utils.dart';
import 'package:agattp/src/native/agattp_request.dart';
import 'package:test/test.dart';
import 'package:testainers/testainers.dart';

///
///
///
void main() {
  group(
    'Agattp Local',
    () {
      const String server = 'localhost';
      final TestainersHttpbucket container = TestainersHttpbucket();

      ///
      setUpAll(() async {
        await container.start();
      });

      test('Capitalize Headers', () async {
        final Map<String, String> extraHeaders = <String, String>{
          HttpHeaders.acceptHeader: '*/*',
          'accept-encoding': 'gzip',
          'User-Agent': 'Agattp',
          'Host': '$server:${container.httpPort}',
          'X-tesT': 'test',
        };

        final List<String> results = <String>[
          'Accept',
          'Accept-Encoding',
          'User-Agent',
          'Host',
          'X-Test',
        ];

        final AgattpJsonResponse<Map<String, dynamic>> response =
            await Agattp().getJson(
          Uri.parse('http://$server:${container.httpPort}/status/200'),
          extraHeaders: extraHeaders,
        );

        expect(response.statusCode, 200);
        expect(response.reasonPhrase, 'OK');
        expect(response.isRedirect, false);
        expect(response.json['headers'] is Map<String, dynamic>, true);

        final Map<String, dynamic> headers = response.json['headers'];

        for (final String key in headers.keys) {
          expect(results.contains(key), true);
        }
      });

      test('Lowercase Headers', () async {
        final Map<String, String> extraHeaders = <String, String>{
          HttpHeaders.acceptHeader: '*/*',
          'accept-encoding': 'gzip',
          'User-Agent': 'Agattp',
          'Host': '$server:${container.httpPort}',
          'X-tesT': 'test',
        };

        final List<String> results = <String>[
          'accept',
          'accept-encoding',
          'user-agent',
          'host',
          'x-test',
        ];

        final AgattpJsonResponse<Map<String, dynamic>> response = await Agattp(
          config: const AgattpConfig(
            headerKeyCase: HeaderKeyCase.lowercase,
          ),
        ).getJson(
          Uri.parse('http://$server:${container.httpPort}/status/200'),
          extraHeaders: extraHeaders,
        );

        expect(response.statusCode, 200);
        expect(response.reasonPhrase, 'OK');
        expect(response.isRedirect, false);
        expect(response.json['headers'] is Map<String, dynamic>, true);

        final Map<String, dynamic> headers = response.json['headers'];

        for (final String key in headers.keys) {
          expect(results.contains(key), true);
        }
      });

      test('Preserve Headers', () async {
        final Map<String, String> extraHeaders = <String, String>{
          HttpHeaders.acceptHeader: '*/*',
          'accept-encoding': 'gzip',
          'User-Agent': 'Agattp',
          'Host': '$server:${container.httpPort}',
          'X-tesT': 'test',
        };

        final List<String> results = <String>[
          'accept',
          'accept-encoding',
          'User-Agent',
          'Host',
          'X-tesT',
        ];

        final AgattpJsonResponse<Map<String, dynamic>> response = await Agattp(
          config: const AgattpConfig(
            headerKeyCase: HeaderKeyCase.preserve,
          ),
        ).getJson(
          Uri.parse('http://$server:${container.httpPort}/status/200'),
          extraHeaders: extraHeaders,
        );

        expect(response.statusCode, 200);
        expect(response.reasonPhrase, 'OK');
        expect(response.isRedirect, false);
        expect(response.json['headers'] is Map<String, dynamic>, true);

        final Map<String, dynamic> headers = response.json['headers'];

        for (final String key in headers.keys) {
          expect(results.contains(key), true);
        }
      });

      test('Send Bytes GET', () async {
        final Uint8List bytes = Uint8List.fromList(<int>[1, 2, 3]);

        expect(
          () => AgattpRequest<void, AgattpResponse>(const AgattpConfig())
              .sendBytes(
            method: AgattpMethod.get,
            uri: Uri.parse('http://$server:${container.httpPort}/status/200'),
            timeout: null,
            bytes: bytes,
          ),
          throwsArgumentError,
        );
      });

      test('Send Bytes HEAD', () async {
        final Uint8List bytes = Uint8List.fromList(<int>[1, 2, 3]);

        expect(
          () => AgattpRequest<void, AgattpResponse>(const AgattpConfig())
              .sendBytes(
            method: AgattpMethod.head,
            uri: Uri.parse('http://$server:${container.httpPort}/status/200'),
            timeout: null,
            bytes: bytes,
          ),
          throwsArgumentError,
        );
      });

      ///
      tearDownAll(container.stop);
    },
    onPlatform: <String, dynamic>{
      'mac-os': const Skip('No docker installed on GitHub actions.'),
      'windows': const Skip('Need a windows container image.'),
    },
  );
}
