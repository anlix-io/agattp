import 'dart:convert';
import 'dart:io';

import 'package:agattp/src/agattp_utils.dart';
import 'package:agattp/src/auth/agattp_abstract_auth.dart';

/// A collection of parameters for HTTP requests, including:
///
/// - A bad certificate callback to bypass TLS handshake errors
/// - An authentication strategy
/// - The request timeout
/// - How to encode the body
/// - Whether redirects will be followed or returned immediately
/// - Whether to force a connection close after the request
/// - Which algorithm to use when capitalizing headers
class AgattpConfig {
  /// The callback to use when a TLS handshake fails - defaults to error
  final BadCertificateCallback? badCertificateCallback;

  /// The authentication strategy to use
  final AgattpAuthInterface? auth;

  /// The request timeout - defaults to 1 minute
  final Duration timeout;

  /// The body encoding - defaults to UTF-8
  final Encoding encoding;

  /// Whether redirect responses will be followed or returned as-is - defaults
  /// to TRUE
  final bool followRedirects;

  /// Whether the connection should be closed after the request is sent -
  /// defaults to FALSE
  final bool forceClose;

  /// How to capitalize the headers - defaults to CAPITALIZE
  final HeaderKeyCase headerKeyCase;

  const AgattpConfig({
    this.auth,
    this.badCertificateCallback = blockAllCertificates,
    this.timeout = const Duration(minutes: 1),
    this.encoding = utf8,
    this.followRedirects = true,
    this.forceClose = false,
    this.headerKeyCase = HeaderKeyCase.capitalize,
  });

  /// Shorthand function to block all invalid certificates
  static bool blockAllCertificates(_, __, ___) => false;

  /// Shorthand function to allow all invalid certificates
  static bool allowAllCertificates(_, __, ___) => true;
}
