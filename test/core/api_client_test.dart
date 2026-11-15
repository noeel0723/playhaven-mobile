import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:playhaven_mobile/core/network/api_client.dart';

void main() {
  test('request mempertahankan prefix API, query, dan bearer token', () async {
    final api = ApiClient(
      baseUri: Uri.parse('https://example.com/api/v1/'),
      client: MockClient((request) async {
        expect(request.url.path, '/api/v1/games');
        expect(request.url.queryParameters['search'], 'space & stars');
        expect(request.headers['Accept'], 'application/json');
        expect(request.headers['Authorization'], 'Bearer test-token');
        return http.Response('{"data": []}', 200);
      }),
    );
    addTearDown(api.close);
    expect(
      await api.getObject(
        '/games',
        query: {'search': 'space & stars'},
        accessToken: 'test-token',
      ),
      {'data': []},
    );
  });

  test('401 tidak mengekspos isi respons server', () async {
    final api = ApiClient(
      baseUri: Uri.parse('https://example.com/api'),
      client: MockClient(
        (_) async => http.Response('private-debug-output', 401),
      ),
    );
    addTearDown(api.close);
    await expectLater(
      api.getObject('me'),
      throwsA(
        isA<ApiException>()
            .having((error) => error.statusCode, 'statusCode', 401)
            .having(
              (error) => error.message,
              'message',
              isNot(contains('private-debug-output')),
            ),
      ),
    );
  });

  test('respons non-JSON dan JSON selain object ditolak', () async {
    for (final body in ['<html>error</html>', '[]']) {
      final api = ApiClient(
        baseUri: Uri.parse('https://example.com/api'),
        client: MockClient((_) async => http.Response(body, 200)),
      );
      addTearDown(api.close);
      await expectLater(api.getObject('games'), throwsA(isA<ApiException>()));
    }
  });

  test('endpoint tidak dapat mengganti host tujuan', () async {
    final api = ApiClient(
      baseUri: Uri.parse('https://example.com/api'),
      client: MockClient((_) async => fail('Request tidak boleh dikirim')),
    );
    addTearDown(api.close);
    for (final path in [
      'https://other.example/games',
      '//other.example',
      '../private',
    ]) {
      await expectLater(api.getObject(path), throwsArgumentError);
    }
  });

  test('network error diterjemahkan menjadi ApiException', () async {
    final api = ApiClient(
      baseUri: Uri.parse('https://example.com/api'),
      client: MockClient((_) async => throw http.ClientException('offline')),
    );
    addTearDown(api.close);
    await expectLater(api.getObject('games'), throwsA(isA<ApiException>()));
  });
}
