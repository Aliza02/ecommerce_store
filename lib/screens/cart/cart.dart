import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_bloc.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_events.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_states.dart';
import 'package:ecommerce_store/bloc/home_bloc/bloc.dart';
import 'package:ecommerce_store/constants/colors.dart';
import 'package:ecommerce_store/routes/routes.dart';
import 'package:ecommerce_store/shared_widgets/bottom_nav_bar.dart';
import 'package:ecommerce_store/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/model/cart_model.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    double totalAmount = BlocProvider.of<CartBloc>(context).totalAmount;
    double subTotal = BlocProvider.of<CartBloc>(context).subTotal;
    final cartItems = BlocProvider.of<CartBloc>(context).getCartItems;
    final cartItemCount = BlocProvider.of<CartBloc>(context).cartItemCount;
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavbar(
          onPressed: () => BlocProvider.of<CartBloc>(context)
              .checkout(cartItems, context, AppRoutes.shipment),
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
                      icon: const Icon(Icons.arrow_back_ios,
                          color: AppColors.black),
                      onPressed: () {
                        Navigator.pop(context);
                        BlocProvider.of<HomeBloc>(context)
                            .selectedDrawerTileIndex = 0;
                      },
                    ),
                    Text(
                      'Cart',
                      style: theme.textTheme.titleLarge,
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: cartItemCount == 0
                          ? null
                          : () => BlocProvider.of<CartBloc>(context)
                              .add(RemoveAllCartItem()),
                      child: Icon(
                        Icons.delete,
                        color: cartItemCount == 0
                            ? AppColors.grey
                            : AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              BlocConsumer<CartBloc, CartState>(
                listener: (context, state) {
                  if (state is AllCartItemRemoved) {
                    Utils.showSnackBar('Cart has been emptied', context);
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
                              itemCount: state.carItems.length,
                              shrinkWrap: true,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                CartModel item =
                                    state.carItems.elementAt(index);

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
                        // physics: const NeverScrollableScrollPhysics(),
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
                              // physics: const NeverScrollableScrollPhysics(),
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

class CartItem extends StatefulWidget {
  final CartModel item;
  const CartItem({super.key, required this.item});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int itemQuantity = 1;
  @override
  void initState() {
    super.initState();

    itemQuantity = widget.item.quantity;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(widget.item.productId),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.red,
        child: const Text(
          'swipe to delete',
          style: TextStyle(color: AppColors.white),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Card(
          color: AppColors.white,
          child: ListTile(
            leading: SizedBox(
              width: 50.0,
              child: CachedNetworkImage(
                  imageUrl: widget.item.productImages!.first),
            ),
            title: Text(widget.item.productName,
                maxLines: 2, style: theme.textTheme.displaySmall),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "\$${widget.item.variants.first.price.toString()}",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: decreaseQuantity,
                  icon: Icon(
                    Icons.remove,
                    color: itemQuantity == 1 ? AppColors.grey : AppColors.black,
                  ),
                ),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    return Text(
                      itemQuantity.toString(),
                      style: const TextStyle(
                          fontSize: 16, color: AppColors.deepPurple),
                    );
                  },
                ),
                IconButton(
                  onPressed: increaseQuantity,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
      onDismissed: (direction) => BlocProvider.of<CartBloc>(context)
          .add(RemoveCartItem(cartItem: widget.item)),
    );
  }

  void decreaseQuantity() {
    if (itemQuantity == 1) {
      return;
    }
    BlocProvider.of<CartBloc>(context).add(
      UpdateItemQuantity(item: widget.item, quantity: --itemQuantity),
    );
  }

  void increaseQuantity() {
    BlocProvider.of<CartBloc>(context).add(
      UpdateItemQuantity(item: widget.item, quantity: ++itemQuantity),
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
