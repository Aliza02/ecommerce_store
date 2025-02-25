import 'package:connectivity/connectivity.dart';
import 'package:ecommerce_store/bloc/loginBloc/login_events.dart';
import 'package:ecommerce_store/bloc/loginBloc/login_states.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? userCredentials;
  User? user;
  bool userLoggedIn = false;

  LoginBloc() : super(InitialState()) {
    on<GuestUserEvents>((event, emit) {
      emit(GuestUserState());
    });
    on<LoginSubmitEvents>(
      (event, emit) async {
        final ConnectivityResult connectivityResult =
            await Connectivity().checkConnectivity();

        if (event.email.isEmpty || event.password.isEmpty) {
          emit(InValidState(errorMessage: 'Enter all Details to Proceed'));
        } else if (EmailValidator.validate(event.email) == false) {
          emit(InValidState(errorMessage: 'Enter correct email'));
        } else if (event.password.length < 7) {
          emit(InValidState(
              errorMessage: 'Password should be 7 characters long'));
        } else if (event.email.isNotEmpty && event.password.isNotEmpty) {
          if (connectivityResult.name == 'mobile' ||
              connectivityResult.name == 'wifi') {
            emit(LoginLoadingState());
            await userSignIn(email: event.email, password: event.password);
            if (userLoggedIn) {
              emit(ValidState());
            } else {
              emit(InValidState(errorMessage: 'Fail to login: try again'));
            }
          } else {
            emit(
              InValidState(errorMessage: 'Connect to internet and try again'),
            );
          }
        }
      },
    );
  }

  Future<void> userSignIn(
      {required String email, required String password}) async {
    try {
      userCredentials = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredentials?.user;
      if (user != null) {
        userLoggedIn = true;
      } else {
        userLoggedIn = false;
      }
    } on FirebaseException {
      userLoggedIn = false;
    }
  }

  Future<void> userSignOut() async {
    await auth.signOut();
  }
}
