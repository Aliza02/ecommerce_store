import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:ecommerce_store/api/api.dart';
import 'package:ecommerce_store/bloc/home_bloc/home_events.dart';
import 'package:ecommerce_store/bloc/home_bloc/home_states.dart';
import 'package:ecommerce_store/models/product.model.dart';
// import 'package:ecommerce_store/models/product.model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeBloc extends Bloc<HomeEvent, HomeStates> {
  Connectivity connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;
  final Api api = Api(http.Client());

  Set<Product> products = {};
  int selectedDrawerTileIndex = 0;
  HomeBloc() : super(HomeInitialState()) {
    on<FetchDataEvent>((event, emit) async {
      emit(HomeLoadingData());

      connectivitySubscription =
          connectivity.onConnectivityChanged.listen((result) async {
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          products = await getStoredData();
          if (products.isEmpty) {
            products = await fetchProducts();
          }
        } else {
          products = await getStoredData();
          if (products.isEmpty) {
            emit(HomeStateWithNoData(
                message: 'Please connect to internet and try again'));
          }
        }
      });

      final ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();

      if (connectivityResult.name == 'mobile' ||
          connectivityResult.name == 'wifi') {
        products = await getStoredData();
        if (products.isEmpty) {
          products = await fetchProducts();
          emit(HomeStateWithData(product: products));
        } else {
          if (products.isNotEmpty) {
            emit(HomeStateWithData(product: products));
          }
          // emit(HomeStateWithNoData(message: 'No data found'));
        }
      } else {
        products = await getStoredData();

        if (products.isNotEmpty) {
          emit(HomeStateWithData(product: products));
        } else {
          emit(HomeStateWithNoData(
              message: 'Please connect to internet and try again'));
        }
      }
    });
  }

  Future<Set<Product>> fetchProducts() async {
    try {
      final response = await api.fetchData();

      if (response.status == true) {
        List<dynamic> jsonResponse = jsonDecode(response.data);

        Set<Product> products =
            jsonResponse.map((json) => Product.fromJson(json)).toSet();

        return products;
      }

      return {};
    } catch (e) {
      return {};
    }
  }

  Future<Set<Product>> getStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonData = prefs.getString('api_data');

    if (jsonData != null) {
      List<dynamic> jsonResponse = jsonDecode(jsonData);
      Set<Product> products =
          jsonResponse.map((json) => Product.fromJson(json)).toSet();

      return products;
    }
    return {};
  }
}
