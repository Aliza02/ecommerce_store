import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_bloc.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_events.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_states.dart';
import 'package:ecommerce_store/constants/colors.dart';
import 'package:ecommerce_store/models/product.model.dart';
import 'package:ecommerce_store/shared_widgets/appbar.dart';
import 'package:ecommerce_store/shared_widgets/bottom_nav_bar.dart';
import 'package:ecommerce_store/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/flutter_cart.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  // FlutterCart flutterCart = FlutterCart();
  // Set<CartModel> get getCartItems => flutterCart.cartItemsList.toSet();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final getCartItems = BlocProvider.of<CartBloc>(context).getCartItems;
    final CartModel cartItem = CartModel(
        productId: product.id.toString(),
        productName: product.title,
        variants: [ProductVariant(price: product.price)],
        productDetails: product.description,
        discount: 0.0,
        quantity: 1,
        productImages: [product.image]);

    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: const DefaultAppbar(),
        bottomNavigationBar: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartItemAdded) {
              Utils.showSnackBar('Item Added to Cart', context);
            }
          },
          builder: (context, state) {
            return BottomNavbar(
              onPressed: () => ((state is CartItemAdded &&
                          state.carItems.contains(cartItem)) ||
                      getCartItems.contains(cartItem))
                  ? null
                  : BlocProvider.of<CartBloc>(context)
                      .add(AddCartItem(product: product)),
              title: ((state is CartItemAdded &&
                          state.carItems.contains(cartItem)) ||
                      getCartItems.contains(cartItem))
                  ? 'Already Added to Cart'
                  : 'Add to Cart',
            );
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                  child: Text(
                    'Product Details',
                    style: theme.textTheme.labelMedium,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    imageUrl: product.image,
                    fit: BoxFit.fill,
                    height: 400.0,
                  ),
                ),
                const Divider(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${product.price.toString()}",
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.star,
                      color: AppColors.yellow,
                    ),
                    Text(
                      product.rating.rate.toString(),
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child:
                      Text(product.title, style: theme.textTheme.displayMedium),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    'Description',
                    style: theme.textTheme.labelMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    product.description,
                    style: theme.textTheme.displayMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Category: ',
                          style: theme.textTheme.labelSmall,
                        ),
                        TextSpan(
                          text: product.category,
                          style: theme.textTheme.displayMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Reviews: ',
                          style: theme.textTheme.labelSmall,
                        ),
                        TextSpan(
                          text: product.rating.count.toString(),
                          style: theme.textTheme.displayMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
