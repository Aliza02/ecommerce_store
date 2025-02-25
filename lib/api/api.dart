import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:http/http.dart' as http;

import 'package:ecommerce_store/api/network_response.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Api {
  final http.Client client;
  Api(this.client);
  Future<NetworkEventResponse> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products'),
      );
      if (response.statusCode != 200) {
        return const NetworkEventResponse.failure(
            message: 'Failed to load data: Try Again');
      }
      List<dynamic> data = jsonDecode(response.body);
      await storeData(data);
      return NetworkEventResponse.success(data: response.body, status: true);
    } catch (e) {
      // print(e,s);
      return NetworkEventResponse.failure(message: e.toString());
    }
  }
}

Future<void> storeData(List<dynamic> data) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('api_data', json.encode(data));
}

Future<NetworkEventResponse<Map<String, dynamic>>> createPaymentIntent(
    {required String amount, required String currency}) async {
  try {
    Map<String, dynamic> body = {
      'amount': amount,
      'currency': currency,
      'payment_method_types[]': 'card'
    };

    var secretKey = dotenv.env['STRIPE_SECRET'];
    var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        });
    if (response.statusCode != 200) {
      print(response.body);
      print(response.reasonPhrase);
      return const NetworkEventResponse.failure(
        message: 'Failed to create payment intent',
        status: false,
      );
    }
    return NetworkEventResponse.success(
      message: 'Payment intent created successfully',
      status: true,
      response: jsonDecode(response.body.toString()),
    );
  } catch (e) {
    print(e);
    return NetworkEventResponse.failure(
      message: e.toString(),
      status: false,
    );
  }
}

Future<bool> makePayment(String totalAmount) async {
  try {
    final paymentIntent = await createPaymentIntent(
      amount: totalAmount,
      currency: 'USD',
    );
    if (paymentIntent.status == true) {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent.response!['client_secret'],
          // googlePay: const PaymentSheetGooglePay(
          //   testEnv: true,
          //   currencyCode: "USD",
          //   merchantCountryCode: "US",
          // ),
          style: ThemeMode.dark,
          merchantDisplayName: 'Flutter Stripe Store',
        ),
      );
      final response = await displayPaymentSheet();

      return response.status!;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<NetworkEventResponse<Map<String, dynamic>>> displayPaymentSheet() async {
  try {
    await Stripe.instance.presentPaymentSheet();

    return const NetworkEventResponse.success(
      status: true,
    );
  } on StripeException catch (e) {
    return NetworkEventResponse.failure(
      message: e.toString(),
      status: false,
    );
  } catch (e) {
    return NetworkEventResponse.failure(
      message: e.toString(),
      status: false,
    );
  }
}
