import 'dart:io';

import 'package:ecommerce_store/bloc/profileBloc/profile_events.dart';
import 'package:ecommerce_store/bloc/profileBloc/profile_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileBloc extends Bloc<ProfileEvents, ProfileStates> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final String imageKey = FirebaseAuth.instance.currentUser!.uid;
  bool hasProfilePhoto = false;

  File? imageFile;
  SharedPreferences? _prefs;

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
    on<CheckProfilePhoto>((event, emit) async {
      await initPrefs();
      emit(HasProfilePhoto());
    });
    on<LoadingProfilePhoto>((event, emit) async {
      emit(ProfilePhotoLoading());
    });
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final String? imagePath = _prefs?.getString(imageKey);
    if (imagePath != null) {
      // setState(() {
      imageFile = File(imagePath);
      hasProfilePhoto = true;
      // });
    }
  }

  Future<void> getFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        final File image = File(pickedFile.path);
        await _saveImageToLocalStorage(image);
        print(imageFile!.path);
        // setState(() {
        imageFile = image;
        // });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> getFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        final File image = File(pickedFile.path);
        await _saveImageToLocalStorage(image);
        // setState(() {
        imageFile = image;
        // });
      }
    } catch (e) {
      debugPrint('Error taking photo: $e');
    }
  }

  Future<void> _saveImageToLocalStorage(File image) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = directory.path;
      const String fileName = 'profile_image.jpg';
      final String filePath = '$path/$fileName';

      // Copy the file to local storage
      await image.copy(filePath);

      // Save the file path in SharedPreferences
      await _prefs?.setString(imageKey, filePath);
    } catch (e) {
      debugPrint('Error saving image: $e');
    }
  }
}
