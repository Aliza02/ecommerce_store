import 'package:ecommerce_store/models/product.model.dart';
import 'package:flutter_cart/flutter_cart.dart';

abstract class CartEvents {}

class AddCartItem extends CartEvents {
  final Product product;
  AddCartItem({required this.product});
}

class RemoveCartItem extends CartEvents {
  final CartModel cartItem;
  RemoveCartItem({required this.cartItem});
}

class RemoveAllCartItem extends CartEvents {}

class UpdateItemQuantity extends CartEvents {
  final CartModel item;
  final int quantity;
  UpdateItemQuantity({required this.item, required this.quantity});
}

class AddDataToDatabase extends CartEvents {
  final Set<CartModel> cartItems;
  final double totalAmount;
  AddDataToDatabase({required this.cartItems, required this.totalAmount});
}
