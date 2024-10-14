import 'package:flutter_cart/flutter_cart.dart';

abstract class CartState {}

class CartItemInitialState extends CartState {}

class CartItemAdded extends CartState {
  final Set<CartModel> carItems;
  CartItemAdded({required this.carItems});
}

class CartItemRemoved extends CartState {
  final Set<CartModel> carItems;
  CartItemRemoved({required this.carItems});
}

class AllCartItemRemoved extends CartState {}

class ItemQuantityUpdated extends CartState {
  final CartModel item;
  final int quantity;
  ItemQuantityUpdated({required this.item, required this.quantity});
}

class DataAddedToDatabase extends CartState {}
