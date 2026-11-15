import 'package:flutter_test/flutter_test.dart';
import 'package:playhaven_mobile/app/config/app_config.dart';

void main() {
  test('config menerima URL emulator dengan prefix API', () {
    const config = AppConfig(apiBaseUrl: 'http://10.0.2.2:8000/api/v1');
    expect(config.apiUri.path, '/api/v1');
  });

  test('config menolak URL kosong, protokol lain, dan kredensial', () {
    for (final url in [
      '',
      'api.example.com',
      'file:///tmp/api',
      'https://user:pass@example.com',
      'https://example.com?token=secret',
    ]) {
      expect(() => AppConfig(apiBaseUrl: url).apiUri, throwsStateError);
    }
  });
}
