class AppConfig {
  const AppConfig({this.apiBaseUrl = ''});

  factory AppConfig.fromEnvironment() =>
      const AppConfig(apiBaseUrl: String.fromEnvironment('API_BASE_URL'));

  /// URL publik backend, bukan tempat menyimpan API key atau token.
  final String apiBaseUrl;

  Uri get apiUri {
    final uri = Uri.tryParse(apiBaseUrl);
    if (uri == null ||
        !uri.hasAuthority ||
        !{'http', 'https'}.contains(uri.scheme) ||
        uri.hasQuery ||
        uri.hasFragment ||
        uri.userInfo.isNotEmpty) {
      throw StateError(
        'API_BASE_URL harus berupa URL HTTP(S) tanpa kredensial, query, atau fragment.',
      );
    }
    return uri;
  }
}
