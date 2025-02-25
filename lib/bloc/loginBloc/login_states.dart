abstract class LoginStates {}

class InitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class InValidState extends LoginStates {
  final String errorMessage;
  InValidState({required this.errorMessage});
}

class GuestUserState extends LoginStates {}

class ValidState extends LoginStates {}
