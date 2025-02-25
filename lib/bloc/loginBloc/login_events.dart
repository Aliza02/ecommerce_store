abstract class LoginEvents {}

class LoginSubmitEvents extends LoginEvents {
  String email;
  String password;
  LoginSubmitEvents({required this.email, required this.password});
}

class GuestUserEvents extends LoginEvents {}
