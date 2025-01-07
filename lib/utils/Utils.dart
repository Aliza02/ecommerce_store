import 'package:ecommerce_store/bloc/cartBloc/cart_bloc.dart';
import 'package:ecommerce_store/bloc/cartBloc/cart_events.dart';
import 'package:ecommerce_store/bloc/profileBloc/profile_bloc.dart';
import 'package:ecommerce_store/constants/colors.dart';
import 'package:ecommerce_store/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Utils {
  static void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.transparent,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ],
          ),
        );
      },
    );
  }

  static void showSuccessDialog(BuildContext context, String message) {
    final theme = Theme.of(context);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: Text('Success', style: theme.textTheme.titleLarge),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                BlocProvider.of<CartBloc>(context).add(RemoveAllCartItem());
                Navigator.popUntil(
                    context, ModalRoute.withName(AppRoutes.home));
              },
              child: Text('Place another order',
                  style: theme.textTheme.titleSmall),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
          contentTextStyle: theme.textTheme.displayMedium,
          icon:
              const Icon(Icons.check_circle, color: AppColors.green, size: 50),
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  static void showFailedDialog(
      {required BuildContext context,
      required String message,
      required VoidCallback placeorder}) {
    final theme = Theme.of(context);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: Text('Failed', style: theme.textTheme.titleLarge),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                placeorder();
              },
              child: Text('Try Again', style: theme.textTheme.titleSmall),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: theme.textTheme.titleSmall),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
          contentTextStyle: theme.textTheme.displayMedium,
          icon: const Icon(Icons.check_circle, color: AppColors.red, size: 50),
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  static void showPhotosOptionDialog(
      {required BuildContext context,
      required Function onCamera,
      required Function onGallery}) {
    final theme = Theme.of(context);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: Text('Choose one', style: theme.textTheme.titleLarge),
          actionsAlignment: MainAxisAlignment.center,
          contentTextStyle: theme.textTheme.displayMedium,
          icon: const Icon(Icons.camera_alt, color: AppColors.black, size: 50),
          content: SizedBox(
            height: 120.0,
            child: Column(
              children: [
                ListTile(
                  title:
                      Text('Take Photo', style: theme.textTheme.displayMedium),
                  onTap: () {
                    onCamera();
                  },
                ),
                ListTile(
                    title: Text('Upload Image',
                        style: theme.textTheme.displayMedium),
                    onTap: () {
                      onGallery();
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}
