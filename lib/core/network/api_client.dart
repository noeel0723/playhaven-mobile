import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Transport JSON umum. Endpoint dan autentikasi ditambahkan setelah kontrak
/// API backend diverifikasi; aplikasi awal masih memakai repository demo.
class ApiClient {
  ApiClient({
    required Uri baseUri,
    required this._client,
    this.timeout = const Duration(seconds: 20),
  }) : _baseUri = baseUri {
    if (!baseUri.hasAuthority ||
        !{'http', 'https'}.contains(baseUri.scheme) ||
        baseUri.hasQuery ||
        baseUri.hasFragment ||
        baseUri.userInfo.isNotEmpty) {
      throw ArgumentError.value(baseUri, 'baseUri', 'URL HTTP(S) tidak valid');
    }
  }

  final Uri _baseUri;
  final http.Client _client;
  final Duration timeout;

  Future<Map<String, dynamic>> getObject(
    String path, {
    Map<String, String>? query,
    String? accessToken,
  }) async {
    final relative = Uri.parse(path);
    if (relative.hasScheme ||
        relative.hasAuthority ||
        relative.hasQuery ||
        relative.hasFragment ||
        relative.pathSegments.contains('..')) {
      throw ArgumentError.value(path, 'path', 'Gunakan path endpoint relatif');
    }
    final prefix = _baseUri.path.replaceFirst(RegExp(r'/+$'), '');
    final suffix = relative.path.replaceFirst(RegExp(r'^/+'), '');
    final uri = _baseUri.replace(
      path: '$prefix/$suffix',
      queryParameters: query,
    );
    try {
      final response = await _client
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
              if (accessToken != null) 'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(timeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          response.statusCode == 401
              ? 'Sesi berakhir. Silakan masuk kembali.'
              : 'Permintaan gagal. Silakan coba lagi.',
          statusCode: response.statusCode,
        );
      }
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic>) {
        throw const ApiException('Format respons server tidak sesuai.');
      }
      return decoded;
    } on TimeoutException {
      throw const ApiException('Koneksi terlalu lama. Silakan coba lagi.');
    } on http.ClientException {
      throw const ApiException('Tidak dapat terhubung ke server.');
    } on FormatException {
      throw const ApiException('Respons server bukan JSON yang valid.');
    }
  }

  void close() => _client.close();
}

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
