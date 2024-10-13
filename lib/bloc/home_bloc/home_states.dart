import 'package:ecommerce_store/models/product.model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeLoadingData extends HomeStates {}

class HomeStateWithData extends HomeStates {
  final Set<Product> product;
  HomeStateWithData({required this.product});
}

class HomeStateWithNoData extends HomeStates {
  final String message;
  HomeStateWithNoData({required this.message});
}
