import 'dart:convert';
import 'dart:io';

///
///
///
void main() {
  final Map<String, String> agattp = <String, String>{
    'name': 'agattp',
    'rootUri': '../',
    'packageUri': 'lib/',
    'languageVersion': '2.0',
  };

  final Map<String, dynamic> package = <String, dynamic>{
    'configVersion': 2,
    'packages': <Map<String, String>>[agattp],
    'generated': DateTime.now().toIso8601String(),
    'generator': 'pub',
    'generatorVersion': '2.0.0',
  };

  File('coverage/package.json')
    ..createSync(recursive: true)
    ..writeAsStringSync(json.encode(package));
}
