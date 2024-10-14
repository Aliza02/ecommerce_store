import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_bloc.dart';
import 'package:ecommerce_store/constants/colors.dart';
import 'package:ecommerce_store/shared_widgets/bottom_nav_bar.dart';
import 'package:ecommerce_store/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/model/cart_model.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = BlocProvider.of<CartBloc>(context).getCartItems;
    final totalAmount = BlocProvider.of<CartBloc>(context).totalAmount;
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavbar(
            onPressed: () => saveData(
                cartItems: cartItems,
                context: context,
                totalAmount: totalAmount),
            title: 'Place Order'),
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
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Checkout',
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: AppColors.white,
                      child: ListTile(
                        leading: CachedNetworkImage(
                            imageUrl: cartItems
                                .elementAt(index)
                                .productImages!
                                .first),
                        title: Text(cartItems.elementAt(index).productName),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                " Quantity: ${cartItems.elementAt(index).quantity.toString()}"),
                            Text(
                              "\$ ${cartItems.elementAt(index).variants.first.price.toString()}",
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: theme.textTheme.labelMedium,
                  ),
                  Text(totalAmount.round().toString(),
                      style: theme.textTheme.labelMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveData(
      {required BuildContext context,
      required Set<CartModel> cartItems,
      required double totalAmount}) async {
    Utils.showLoadingDialog(context);

    bool isSuccess = await BlocProvider.of<CartBloc>(context)
        .saveOrderToDB(cartItems, totalAmount);

    Navigator.pop(context);

    if (isSuccess) {
      Utils.showSuccessDialog(context, 'Order placed successfully');
    } else {
      Utils.showFailedDialog(
          context: context,
          message: 'Order could not be placed',
          placeorder: () => saveData(
              cartItems: cartItems,
              context: context,
              totalAmount: totalAmount));
    }
  }
}
