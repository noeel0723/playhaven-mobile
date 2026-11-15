import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../app/config/app_config.dart';
import 'api_client.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnvironment();
});

// Lazy: transport belum dibuat selama aplikasi menggunakan data demo.
final apiClientProvider = Provider<ApiClient>((ref) {
  final uri = ref.watch(appConfigProvider).apiUri;
  final api = ApiClient(baseUri: uri, client: http.Client());
  ref.onDispose(api.close);
  return api;
});
