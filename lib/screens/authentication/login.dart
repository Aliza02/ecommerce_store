import 'package:ecommerce_store/bloc/loginBloc/login_bloc.dart';
import 'package:ecommerce_store/bloc/loginBloc/login_events.dart';
import 'package:ecommerce_store/bloc/loginBloc/login_states.dart';
import 'package:ecommerce_store/constants/colors.dart';
import 'package:ecommerce_store/routes/routes.dart';
import 'package:ecommerce_store/shared_widgets/guest_button.dart';
import 'package:ecommerce_store/shared_widgets/textfield.dart';
import 'package:ecommerce_store/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an Account? ",
                    style: theme.textTheme.displaySmall,
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
                    child: Text(
                      'Sign up',
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const GuestButton(),
              BlocConsumer<LoginBloc, LoginStates>(
                listener: (context, state) {
                  if (state is InValidState) {
                    Navigator.pop(context);
                    Utils.showSnackBar(state.errorMessage, context);
                  } else if (state is LoginLoadingState) {
                    Utils.showLoadingDialog(context);
                  } else if (state is ValidState) {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.home);
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    child: Text(
                      'Login',
                      style: theme.textTheme.titleSmall,
                    ),
                    onPressed: () {
                      BlocProvider.of<LoginBloc>(context).add(
                        LoginSubmitEvents(
                          email: email.text,
                          password: password.text,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
