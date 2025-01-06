import 'package:ecommerce_store/bloc/profileBloc/profile_events.dart';
import 'package:ecommerce_store/bloc/profileBloc/profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvents, ProfileStates> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ProfileBloc() : super(ProfileInitialState()) {
    on<ShowNameField>((event, emit) {
      emit(NameFieldDisplayed());
    });
    on<HideNameField>((event, emit) {
      emit(NameFieldHide());
    });

    on<ShowPasswordField>((event, emit) {
      emit(PasswordFieldDisplayed());
    });
    on<HidePasswordField>((event, emit) {
      emit(PasswordFieldHide());
    });
  }
}
