import 'package:ecommerce_store/bloc/cartBloc/cart_bloc.dart';
import 'package:ecommerce_store/bloc/home_bloc/bloc.dart';
import 'package:ecommerce_store/constants/colors.dart';
import 'package:ecommerce_store/routes/pages.dart';
import 'package:ecommerce_store/routes/routes.dart';
import 'package:ecommerce_store/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/flutter_cart.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var cart = FlutterCart();
  await cart.initializeCart(isPersistenceSupportEnabled: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 26.0,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            titleMedium: TextStyle(
              fontSize: 24.0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            titleSmall: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            displaySmall: TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
            displayMedium: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
            labelMedium: TextStyle(
              fontSize: 23.0,
              fontWeight: FontWeight.w600,
            ),
            labelSmall: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: Colors.black,
            contentTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.home,
        routes: Pages.pages,

        // {
        //   AppRoutes.home: (context) => BlocProvider(
        //         create: (context) => HomeBloc(),
        //         child: const HomeScreen(),
        //       ),
        //   AppRoutes.productDetail: (context) => const HomeScreen(),
        // },
        // home: BlocProvider(
        //   create: (context) => HomeBloc(),
        //   child: const HomeScreen(),
        // ),
      ),
    );
  }
}
