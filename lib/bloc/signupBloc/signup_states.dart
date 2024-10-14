abstract class SignUpStates {}

class InitialState extends SignUpStates {}

class ValidSignUpState extends SignUpStates {}

class InvalidSignUpState extends SignUpStates {
  final String errorMessage;
  InvalidSignUpState({required this.errorMessage});
}

class SignUpLoadingState extends SignUpStates {}
