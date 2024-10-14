import 'package:ecommerce_store/bloc/cartBloc/cart_bloc.dart';
import 'package:ecommerce_store/bloc/home_bloc/bloc.dart';
import 'package:ecommerce_store/bloc/loginBloc/login_bloc.dart';
import 'package:ecommerce_store/bloc/signupBloc/signup_bloc.dart';
import 'package:ecommerce_store/routes/routes.dart';
import 'package:ecommerce_store/screens/authentication/login.dart';
import 'package:ecommerce_store/screens/authentication/signup.dart';
import 'package:ecommerce_store/screens/cart/cart.dart';
import 'package:ecommerce_store/screens/checkout/checkout.dart';
import 'package:ecommerce_store/screens/home/home.dart';
import 'package:ecommerce_store/screens/productDetail/product_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Pages {
  static final pages = {
    AppRoutes.home: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => HomeBloc(),
            ),
            BlocProvider.value(
              value: BlocProvider.of<CartBloc>(context),
            ),
          ],
          child: const HomeScreen(),
        ),
    AppRoutes.productDetail: (context) => BlocProvider.value(
          value: BlocProvider.of<CartBloc>(context),
          child: const ProductDetail(),
        ),
    AppRoutes.cart: (context) => BlocProvider.value(
          value: BlocProvider.of<CartBloc>(context),
          child: const Cart(),
        ),
    AppRoutes.checkout: (context) => BlocProvider.value(
          value: BlocProvider.of<CartBloc>(context),
          child: const Checkout(),
        ),
    AppRoutes.login: (context) => BlocProvider.value(
          value: BlocProvider.of<LoginBloc>(context),
          child: const Login(),
        ),
    AppRoutes.signup: (context) => BlocProvider(
          create: (context) => SignUpBloc(),
          child: const Signup(),
        ),
  };
}
