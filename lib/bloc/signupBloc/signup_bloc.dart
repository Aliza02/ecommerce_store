import 'package:connectivity/connectivity.dart';
import 'package:ecommerce_store/bloc/signupBloc/signup_events.dart';
import 'package:ecommerce_store/bloc/signupBloc/signup_states.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignupEvents, SignUpStates> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  UserCredential? userCredentials;
  User? user;
  bool userCreated = false;

  SignUpBloc() : super(InitialState()) {
    on<SignUpSubmitEvent>((event, emit) async {
      final ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();

      if (EmailValidator.validate(event.email) == false &&
          event.email.isNotEmpty) {
        emit(InvalidSignUpState(errorMessage: 'Enter correct email'));
      } else if (event.password.length < 7 && event.password.isNotEmpty ||
          event.confirmPassword.length < 7 &&
              event.confirmPassword.isNotEmpty) {
        emit(InvalidSignUpState(
            errorMessage: 'Password should be 7 characters long'));
      } else if (event.password != event.confirmPassword) {
        emit(InvalidSignUpState(errorMessage: 'Passwords do not match'));
      } else if (event.email.isEmpty &&
          event.name.isEmpty &&
          event.password.isEmpty &&
          event.confirmPassword.isEmpty) {
        emit(InvalidSignUpState(errorMessage: 'Enter all Details to Proceed'));
      } else if (event.email.isNotEmpty &&
          event.password.isNotEmpty &&
          event.name.isNotEmpty &&
          event.confirmPassword.isNotEmpty) {
        if (connectivityResult.name == 'mobile' ||
            connectivityResult.name == 'wifi') {
          emit(SignUpLoadingState());
          await userSignup(
              name: event.name,
              password: event.password,
              confirmPassword: event.confirmPassword,
              email: event.email);
          if (userCreated) {
            emit(ValidSignUpState());
          } else {
            emit(InvalidSignUpState(
                errorMessage: 'Account could not be created'));
          }
        } else {
          emit(InvalidSignUpState(
              errorMessage: 'Connect to internet and try again'));
        }
      }
    });
  }

  Future<void> userSignup(
      {required String name,
      required String email,
      required String password,
      required String confirmPassword}) async {
    try {
      userCredentials = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredentials?.user;

      userCreated = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        userCreated = false;
      }
    }
  }
}
