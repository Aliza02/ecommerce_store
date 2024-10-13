import 'package:ecommerce_store/bloc/cartBloc/cart_bloc.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_events.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_states.dart';
import 'package:ecommerce_store/constants/colors.dart';
import 'package:ecommerce_store/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/cart.dart';

class DefaultAppbar extends StatefulWidget implements PreferredSizeWidget {
  const DefaultAppbar({super.key});

  @override
  State<DefaultAppbar> createState() => _DefaultAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(67.0);
}

class _DefaultAppbarState extends State<DefaultAppbar> {
  FlutterCart flutterCart = FlutterCart();
  int get cartItemCount => flutterCart.cartLength;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          'Ecommerce Store',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      scrolledUnderElevation: 0.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      elevation: 0.0,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: AppColors.primary,
      actions: [
        IconButton(
          padding: const EdgeInsets.only(top: 8.0),
          icon: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              print(state);
              return Badge(
                  label: Text(
                    (state is CartItemAdded)
                        ? state.carItems.length.toString()
                        : (state is CartItemRemoved)
                            ? state.carItems.length.toString()
                            : cartItemCount.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: const Icon(Icons.shopping_cart));
            },
          ),
          color: Colors.white,
          onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
        ),
      ],
    );
  }
}
