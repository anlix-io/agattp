import 'dart:convert';
import 'dart:io';

///
///
///
class AgattpConfig {
  final BadCertificateCallback? _badCertificateCallback;
  final int timeout;
  final Encoding encoding;
  final bool followRedirects;
  final bool forceClose;

  ///
  ///
  ///
  const AgattpConfig({
    BadCertificateCallback? badCertificateCallback,
    this.timeout = 60000,
    this.encoding = utf8,
    this.followRedirects = true,
    this.forceClose = false,
  }) : _badCertificateCallback = badCertificateCallback;

  ///
  ///
  ///
  BadCertificateCallback get badCertificateCallback =>
      _badCertificateCallback ?? (_, __, ___) => false;
}
