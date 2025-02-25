import 'package:ecommerce_store/bloc/cartBloc/cart_bloc.dart';
import 'package:ecommerce_store/bloc/home_bloc/bloc.dart';
import 'package:ecommerce_store/bloc/loginBloc/login_bloc.dart';
import 'package:ecommerce_store/bloc/profileBloc/profile_bloc.dart';
import 'package:ecommerce_store/bloc/signupBloc/signup_bloc.dart';
import 'package:ecommerce_store/firebase_options.dart';
import 'package:ecommerce_store/routes/pages.dart';
import 'package:ecommerce_store/routes/routes.dart';
import 'package:ecommerce_store/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var cart = FlutterCart();
  await cart.initializeCart(isPersistenceSupportEnabled: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CartBloc(),
        ),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => SignUpBloc(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        initialRoute:
            auth.currentUser != null ? AppRoutes.home : AppRoutes.login,
        routes: Pages.pages,
      ),
    );
  }
}
