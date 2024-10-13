import 'dart:convert';

import 'package:ecommerce_store/api/network_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<NetworkEventResponse> fetchData() async {
  try {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode != 200) {
      return const NetworkEventResponse.failure(
          message: 'Failed to load data: Try Again');
    }
    List<dynamic> data = jsonDecode(response.body);
    await storeData(data);
    return NetworkEventResponse.success(data: response.body, status: true);
  } catch (e) {
    return NetworkEventResponse.failure(message: e.toString());
  }
}

Future<void> storeData(List<dynamic> data) async {
  print('shared');
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString('api_data', json.encode(data));
}
