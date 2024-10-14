import 'package:ecommerce_store/constants/colors.dart';
import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  const BottomNavbar({super.key, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 50.0,
      child: ElevatedButton(
        style: theme.elevatedButtonTheme.style,
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
