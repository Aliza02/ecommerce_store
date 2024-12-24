import 'package:ecommerce_store/bloc/signupBloc/signup_bloc.dart';
import 'package:ecommerce_store/bloc/signupBloc/signup_events.dart';
import 'package:ecommerce_store/bloc/signupBloc/signup_states.dart';
import 'package:ecommerce_store/constants/colors.dart';
import 'package:ecommerce_store/routes/routes.dart';
import 'package:ecommerce_store/shared_widgets/guest_button.dart';
import 'package:ecommerce_store/shared_widgets/textfield.dart';
import 'package:ecommerce_store/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => SignupState();
}

class SignupState extends State<Signup> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: BlocProvider(
        create: (context) => SignUpBloc(),
        child: Scaffold(
          // resizeToAvoidBottomInset: true,
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_cart,
                  size: 100,
                  color: AppColors.primary,
                ),
                Text(
                  'Ecommerce Store',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hintText: 'Name',
                  controller: name,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Email',
                  controller: email,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Password',
                  controller: password,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Confirm Password',
                  controller: confirmPassword,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an Account? ',
                      style: theme.textTheme.displaySmall,
                    ),
                    InkWell(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.login),
                      child: Text(
                        'Login',
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
                const GuestButton(),
                BlocConsumer<SignUpBloc, SignUpStates>(
                    listener: (context, state) {
                  if (state is InvalidSignUpState) {
                    Navigator.pop(context);
                    Utils.showSnackBar(state.errorMessage, context);
                  } else if (state is SignUpLoadingState) {
                    Utils.showLoadingDialog(context);
                  } else if (state is ValidSignUpState) {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.home);
                  }
                }, builder: (context, state) {
                  if (state is InitialState || state is InvalidSignUpState) {
                    return ElevatedButton(
                      child: Text(
                        'Signup',
                        style: theme.textTheme.titleSmall,
                      ),
                      onPressed: () {
                        BlocProvider.of<SignUpBloc>(context).add(
                          SignUpSubmitEvent(
                            name: name.text,
                            email: email.text,
                            password: password.text,
                            confirmPassword: confirmPassword.text,
                          ),
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
