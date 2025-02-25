import 'package:ecommerce_store/api/api.dart';
import 'package:ecommerce_store/api/network_response.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late Api api;

  setUp(() {
    mockClient = MockClient();
    api = Api(mockClient);
  });

  group('api test', () {
    test('returns an Album if the http call completes successfully', () async {
      // final mockClient = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(mockClient.get(Uri.parse('https://fakestoreapi.com/products')))
          .thenAnswer((_) async => http.Response('''{
        "id": 1,
        "title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
        "price": 109.95,
        "description":
            "Your perfect pack for everyday use and walks in the forest.",
        "category": "men's clothing",
        "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
        "rating": {"rate": 3.9, "count": 120}
      }''', 200));

      final result = await api.fetchData();
      expect(result, isA<NetworkEventResponse>());
    });

    test('throws an exception un 404', () async {
      when(mockClient.get(Uri.parse('https://fakestoreapi.com/products')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final result = await api.fetchData();
      expect(result, isA<NetworkEventResponse>());
    });
  });
}
