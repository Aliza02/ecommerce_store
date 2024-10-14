import 'package:ecommerce_store/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: widget.controller,
      obscureText:
          widget.hintText == 'Password' || widget.hintText == 'Confirm Password'
              ? obscureText
              : !obscureText,
      decoration: InputDecoration(
        suffixIcon: widget.hintText == 'Password' ||
                widget.hintText == 'Confirm Password'
            ? InkWell(
                onTap: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                child: Icon(obscureText == false
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
              )
            : null,
        hintText: widget.hintText,
        hintStyle: theme.textTheme.displaySmall,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.black,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColors.grey,
              width: 2.0,
            )),
      ),
    );
  }
}
