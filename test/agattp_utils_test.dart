// ignore_for_file: avoid_print

import 'package:agattp/src/agattp_utils.dart';
import 'package:test/test.dart';

///
///
///
void main() {
  group('Agattp Utils', () {
    ///
    test('Capitalize Header Key', () {
      final Map<String, String> domain = <String, String>{
        'first-second-third': 'First-Second-Third',
        'first-second': 'First-Second',
        'first- ': 'First- ',
        'first--': 'First--',
        'first-s-': 'First-S-',
        'first': 'First',
      };

      for (final MapEntry<String, String> entry in domain.entries) {
        print('${entry.key} => ${entry.value}');

        expect(Utils.capitalizeHeaderKey(entry.key), entry.value);
      }
    });

    /// headerKey
    // TODO(edufolly): Create tests for headerKey

    /// headers
    // TODO(edufolly): Create tests for headers

    ///
    test('Remove Quotes', () {
      final Map<String, String> domain = <String, String>{
        '"simple"': 'simple',
        '"prefix': 'prefix',
        'suffix"': 'suffix',
        'none': 'none',
      };

      for (final MapEntry<String, String> entry in domain.entries) {
        print('${entry.key} => ${entry.value}');

        expect(Utils.removeQuotes(entry.key), entry.value);
      }
    });

    ///
    test('Split First Success', () {
      final Map<String, List<String>> domain = <String, List<String>>{
        'first=second=third': <String>['first', 'second=third'],
        'first=second': <String>['first', 'second'],
        'first= ': <String>['first', ' '],
        'first==': <String>['first', '='],
        'first=': <String>['first', ''],
        'first': <String>['first'],
        '': <String>[''],
      };

      for (final MapEntry<String, List<String>> entry in domain.entries) {
        print('${entry.key} => ${entry.value}');

        final List<String> result = Utils.splitFirst(entry.key, '=');

        expect(result.length, entry.value.length);

        for (int i = 0; i < result.length; i++) {
          expect(result[i], entry.value[i]);
        }
      }
    });
  });
}
