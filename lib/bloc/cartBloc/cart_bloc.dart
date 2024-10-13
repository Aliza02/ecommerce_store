import 'dart:convert';

import 'package:ecommerce_store/bloc/cartBloc/cart_events.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_states.dart';
import 'package:ecommerce_store/models/product.model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartBloc extends Bloc<CartEvents, CartState> {
  FlutterCart flutterCart = FlutterCart();
  Set<CartModel> get getCartItems => flutterCart.cartItemsList.toSet();
  double get totalAmount => flutterCart.total;
  double get subTotal => flutterCart.subtotal;
  CartBloc() : super(CartItemInitialState()) {
    on<AddCartItem>((event, emit) {
      addToCart(event.product);
      emit(CartItemAdded(carItems: getCartItems));
    });

    on<RemoveCartItem>((event, emit) {
      removeItemFromCart(event.cartItem);

      emit(CartItemRemoved(carItems: getCartItems));
    });

    on<RemoveAllCartItem>((event, emit) {
      clearCart();

      emit(AllCartItemRemoved());
    });

    on<UpdateItemQuantity>((event, emit) {
      updateQuantity(event.item, event.quantity);
      emit(ItemQuantityUpdated(item: event.item, quantity: event.quantity));
    });
  }

  void addToCart(Product product) {
    FlutterCart flutterCart = FlutterCart();

    flutterCart.addToCart(
      cartModel: CartModel(
        productId: product.id.toString(),
        productDetails: product.description,
        variants: [
          ProductVariant(price: product.price),
        ],
        quantity: 1,
        productName: product.title,
        productImages: [product.image],
      ),
    );
  }

  void updateQuantity(CartModel item, int newQuantity) {
    flutterCart.updateQuantity(item.productId, item.variants, newQuantity);
  }

  void clearCart() {
    flutterCart.clearCart();
  }

  void removeItemFromCart(CartModel item) {
    flutterCart.removeItem(item.productId, []);
  }
}
