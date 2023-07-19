![Anlix](https://anlix.io/wp-content/uploads/2020/05/anlix-horizontal_verde.png "Anlix")

[![Build With Love](https://img.shields.io/badge/%20built%20with-%20%E2%9D%A4-ff69b4.svg)](https://github.com/anlix-io/agattp/stargazers)
[![Version](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fapi.github.com%2Frepos%2Fanlix-io%2Fagattp%2Freleases%2Flatest&query=%24.name&label=version&color=orange)](https://github.com/anlix-io/agattp/releases/latest)
[![Licence](https://img.shields.io/github/license/anlix-io/agattp?color=blue)](https://github.com/anlix-io/agattp/blob/main/LICENSE)
[![Build](https://img.shields.io/github/actions/workflow/status/anlix-io/agattp/main.yml?branch=main)](https://github.com/anlix-io/agattp/releases/latest)
[![Coverage Report](https://img.shields.io/badge/coverage-report-C08EA1)](https://anlix-io.github.io/agattp/coverage/)

# Anlix Gateway Alternative Text Transfer Protocol (agattp)

Anlix Gateway Alternative Text Transfer Protocol is a package to standardize and make easy the processing of HTTP requests.

## How to use

### Add the package to pubspec.yaml

```yaml
dependencies:

  # https://github.com/anlix-io/agattp
  agattp:
    git:
      url: git@github.com:anlix-io/agattp.git
      ref: dev # Latest release or tag ou branch
```

### Send requests

```dart
void main() async {

  /// GET
  final AgattpResponse response =
    await Agattp().get(Uri.parse('https://httpbingo.org/status/200'));

  /// POST
  final AgattpResponse response = await Agattp().post(
    Uri.parse('https://httpbingo.org/post'),
    headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'text/plain',
    },
    body: 'Hello World!',
  );

  /// POST with JSON body and JSON response
  final AgattpResponseJson<Map<String, dynamic>> response =
    await Agattp().postJson(
      Uri.parse('https://httpbingo.org/post'),
      body: <String, dynamic>{
        'message': 'Hello World!',
      },
    );
}
```

---

### https://anlix.io
