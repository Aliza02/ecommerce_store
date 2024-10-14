import 'package:ecommerce_store/constants/colors.dart';
import 'package:ecommerce_store/routes/routes.dart';
import 'package:flutter/material.dart';

class GuestButton extends StatelessWidget {
  const GuestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text(
        'Continue as Guest',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
          color: AppColors.grey,
        ),
      ),
      onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
    );
  }
}
