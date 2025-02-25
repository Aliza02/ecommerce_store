import 'package:ecommerce_store/bloc/orderBloc/order_bloc.dart';
import 'package:ecommerce_store/bloc/paymentBloc/payment_bloc.dart';
import 'package:ecommerce_store/bloc/profileBloc/profile_bloc.dart';
import 'package:ecommerce_store/bloc/signupBloc/signup_bloc.dart';
import 'package:ecommerce_store/routes/routes.dart';
import 'package:ecommerce_store/screens/authentication/login.dart';
import 'package:ecommerce_store/screens/authentication/signup.dart';
import 'package:ecommerce_store/screens/cart/cart.dart';
import 'package:ecommerce_store/screens/checkout/checkout.dart';
import 'package:ecommerce_store/screens/home/home.dart';
import 'package:ecommerce_store/screens/orders/orders.dart';
import 'package:ecommerce_store/screens/productDetail/product_detail.dart';
import 'package:ecommerce_store/screens/profile/profile.dart';
import 'package:ecommerce_store/screens/shipment/shipment_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Pages {
  static final pages = {
    AppRoutes.home: (context) => BlocProvider.value(
          value: BlocProvider.of<ProfileBloc>(context),
          child: const HomeScreen(),
        ),
    AppRoutes.productDetail: (context) => const ProductDetail(),
    AppRoutes.cart: (context) => const Cart(),
    AppRoutes.checkout: (context) => BlocProvider(
          create: (context) => PaymentBloc(),
          child: const Checkout(),
        ),
    AppRoutes.orders: (context) => BlocProvider(
          create: (context) => OrderBloc(),
          child: const OrdersScreen(),
        ),
    AppRoutes.profile: (context) => BlocProvider.value(
          value: BlocProvider.of<ProfileBloc>(context),
          child: const ProfileScreen(),
        ),
    AppRoutes.login: (context) => const Login(),
    AppRoutes.shipment: (context) => const ShipmentDetail(),
    AppRoutes.signup: (context) => BlocProvider(
          create: (context) => SignUpBloc(),
          child: const Signup(),
        ),
  };
}
