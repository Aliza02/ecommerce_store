import 'package:cached_network_image/cached_network_image.dart';
import 'package:cart_item/cart_item.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_bloc.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_events.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_states.dart';
import 'package:ecommerce_store/models/product.model.dart';
import 'package:ecommerce_store/routes/routes.dart';
import 'package:ecommerce_store/shared_widgets/bottom_nav_bar.dart';
import 'package:ecommerce_store/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/cart.dart';
import 'package:flutter_cart/model/cart_model.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  FlutterCart flutterCart = FlutterCart();
  Set<CartModel> get cartItems => flutterCart.cartItemsList.toSet();

  @override
  Widget build(BuildContext context) {
    double totalAmount = BlocProvider.of<CartBloc>(context).totalAmount;
    double subTotal = BlocProvider.of<CartBloc>(context).subTotal;
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavbar(
          onPressed: () => cartItems.isEmpty
              ? Utils.showSnackBar('Add Item to Proceed', context)
              : Navigator.pushNamed(context, AppRoutes.checkout),
          title: 'Checkout',
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 0.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Cart',
                      style: theme.textTheme.titleLarge,
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => BlocProvider.of<CartBloc>(context)
                          .add(RemoveAllCartItem()),
                      child: const Icon(
                        Icons.delete,
                      ),
                    ),
                  ],
                ),
              ),
              BlocConsumer<CartBloc, CartState>(
                listener: (context, state) {
                  if (state is AllCartItemRemoved) {
                    Utils.showSnackBar('All item has been removed', context);
                  } else if (state is CartItemRemoved) {
                    Utils.showSnackBar('Item removed', context);
                  }
                },
                builder: (context, state) {
                  if (state is AllCartItemRemoved) {
                    return const NoItemMessage();
                  } else if (state is CartItemRemoved) {
                    return state.carItems.isEmpty
                        ? const NoItemMessage()
                        : Expanded(
                            child: ListView.builder(
                              itemCount: cartItems.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                CartModel item = cartItems.elementAt(index);

                                return CartItem(
                                  item: item,
                                );
                              },
                            ),
                          );
                  } else if (state is CartItemAdded) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          CartModel item = cartItems.elementAt(index);

                          return CartItem(
                            item: item,
                          );
                        },
                      ),
                    );
                  } else {
                    return cartItems.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: cartItems.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                CartModel item = cartItems.elementAt(index);

                                return CartItem(
                                  item: item,
                                );
                              },
                            ),
                          )
                        : const NoItemMessage();
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sub Total',
                    style: theme.textTheme.displaySmall,
                  ),
                  BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      subTotal = BlocProvider.of<CartBloc>(context).subTotal;
                      return Text(subTotal.round().toString().trimRight(),
                          style: theme.textTheme.displaySmall);
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: theme.textTheme.labelMedium,
                  ),
                  BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      totalAmount =
                          BlocProvider.of<CartBloc>(context).totalAmount;
                      return Text(totalAmount.round().toString(),
                          style: theme.textTheme.labelMedium);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final CartModel item;
  const CartItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    int itemQuantity = item.quantity;
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(item.productId),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Text(
          'swipe to delete',
          style: TextStyle(color: Colors.white),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Card(
          color: Colors.white,
          child: ListTile(
            leading: SizedBox(
              width: 50.0,
              child: CachedNetworkImage(imageUrl: item.productImages!.first),
            ),
            title: Text(item.productName, style: theme.textTheme.displaySmall),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "\$${item.variants.first.price.toString()}",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    if (itemQuantity == 0) {
                      return;
                    }
                    BlocProvider.of<CartBloc>(context).add(
                      UpdateItemQuantity(item: item, quantity: --itemQuantity),
                    );
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  item.quantity.toString(),
                  style:
                      const TextStyle(fontSize: 16, color: Colors.deepPurple),
                ),
                IconButton(
                  onPressed: () {
                    BlocProvider.of<CartBloc>(context).add(
                      UpdateItemQuantity(item: item, quantity: ++itemQuantity),
                    );
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
      onDismissed: (direction) => BlocProvider.of<CartBloc>(context).add(
        RemoveCartItem(cartItem: item),
      ),
    );
  }
}

class NoItemMessage extends StatelessWidget {
  const NoItemMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Center(
        child: Text(
          'No Item in the cart',
          style: theme.textTheme.labelMedium,
        ),
      ),
    );
  }
}
