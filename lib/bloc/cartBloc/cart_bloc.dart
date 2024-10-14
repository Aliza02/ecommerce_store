
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_events.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_states.dart';
import 'package:ecommerce_store/models/product.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/flutter_cart.dart';

class CartBloc extends Bloc<CartEvents, CartState> {
  FlutterCart flutterCart = FlutterCart();
  Set<CartModel> get getCartItems => flutterCart.cartItemsList.toSet();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  double get totalAmount => flutterCart.total;
  double get subTotal => flutterCart.subtotal;
  int get cartItemCount => flutterCart.cartLength;

  CartBloc() : super(CartItemInitialState()) {
    on<AddCartItem>((event, emit) {
      addToCart(event.product);
      emit(CartItemAdded(carItems: getCartItems));
    });

    on<RemoveCartItem>((event, emit) {
      final updatedCartitems = removeItemFromCart(event.cartItem);
      emit(CartItemRemoved(carItems: updatedCartitems));
    });

    on<RemoveAllCartItem>((event, emit) {
      clearCart();

      emit(AllCartItemRemoved());
    });

    on<UpdateItemQuantity>((event, emit) {
      updateQuantity(event.item, event.quantity);
      emit(ItemQuantityUpdated(item: event.item, quantity: event.quantity));
    });

    // on<AddDataToDatabase>((event, emit) async {
    //   await saveOrderToDB(event.cartItems, event.totalAmount);
    //   emit(DataAddedToDatabase());
    // });
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

  Set<CartModel> removeItemFromCart(CartModel item) {
    flutterCart.removeItem(
        item.productId, [ProductVariant(price: item.variants.first.price)]);
    return flutterCart.cartItemsList.toSet();
  }

  Future<bool> saveOrderToDB(
      Set<CartModel> cartItem, double totalAmount) async {
    for (int i = 0; i < cartItem.length; i++) {
      await firestore.collection('Orders').doc().set({
        'productName': cartItem.elementAt(i).productName,
        'productDescription': cartItem.elementAt(i).productDetails,
        'productImage': cartItem.elementAt(i).productImages!.first,
        'quantity': cartItem.elementAt(i).quantity,
        'price': cartItem.elementAt(i).variants.first.price.toString(),
        'total': totalAmount,
        'userName': auth.currentUser!.displayName,
      });
    }
    clearCart();
    return true;
  }
}
