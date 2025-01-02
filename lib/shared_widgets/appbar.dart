import 'package:ecommerce_store/bloc/cartBloc/cart_bloc.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_states.dart';
import 'package:ecommerce_store/bloc/loginBloc/login_bloc.dart';
import 'package:ecommerce_store/constants/colors.dart';
import 'package:ecommerce_store/routes/routes.dart';
import 'package:ecommerce_store/utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefaultAppbar extends StatefulWidget implements PreferredSizeWidget {
  const DefaultAppbar({super.key});

  @override
  State<DefaultAppbar> createState() => _DefaultAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(67.0);
}

class _DefaultAppbarState extends State<DefaultAppbar> {
  @override
  Widget build(BuildContext context) {
    int cartItemCount = BlocProvider.of<CartBloc>(context).cartItemCount;
    FirebaseAuth auth = FirebaseAuth.instance;
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          'Ecommerce Store',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      scrolledUnderElevation: 0.0,
      iconTheme: const IconThemeData(color: AppColors.white),
      backgroundColor: AppColors.primary,
      actions: [
        IconButton(
          padding: const EdgeInsets.only(top: 8.0),
          icon: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return Badge(
                  label: Text(
                    (state is CartItemAdded)
                        ? state.carItems.length.toString()
                        : (state is CartItemRemoved)
                            ? state.carItems.length.toString()
                            : (state is AllCartItemRemoved)
                                ? '0'
                                : cartItemCount.toString(),
                    style: const TextStyle(color: AppColors.white),
                  ),
                  child: const Icon(Icons.shopping_cart));
            },
          ),
          color: AppColors.white,
          onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
        ),
        // PopupMenuButton(
        //   position: PopupMenuPosition.under,
        //   color: AppColors.white,
        //   itemBuilder: (context) {
        //     return [
        //       PopupMenuItem(
        //         child: ListTile(
        //           tileColor: AppColors.white,
        //           title: Text(auth.currentUser != null ? 'Logout' : 'Login'),
        //           onTap: () => auth.currentUser != null
        //               ? logout()
        //               : Navigator.pushNamed(context, AppRoutes.login),
        //         ),
        //       ),
        //     ];
        //   },
        // ),
      ],
    );
  }

  Future<void> logout() async {
    Utils.showLoadingDialog(context);
    await BlocProvider.of<LoginBloc>(context).userSignOut();
    Utils.showSnackBar('User has been logout', context);
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.login, (route) => false);
  }
}
