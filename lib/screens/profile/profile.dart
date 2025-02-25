import 'dart:io';

import 'package:ecommerce_store/bloc/home_bloc/bloc.dart';
import 'package:ecommerce_store/bloc/profileBloc/profile_bloc.dart';
import 'package:ecommerce_store/bloc/profileBloc/profile_events.dart';
import 'package:ecommerce_store/bloc/profileBloc/profile_states.dart';
import 'package:ecommerce_store/bloc/signupBloc/signup_bloc.dart';
import 'package:ecommerce_store/constants/colors.dart';
import 'package:ecommerce_store/routes/routes.dart';
import 'package:ecommerce_store/utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final userCreated = BlocProvider.of<SignUpBloc>(context).userCreated;
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 0.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.black,
                      ),
                      onPressed: () {
                        Navigator.popAndPushNamed(context, AppRoutes.home);
                        BlocProvider.of<HomeBloc>(context)
                            .selectedDrawerTileIndex = 0;
                      },
                    ),
                    Text(
                      'Profile',
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              ProfilePhoto(auth: auth, userCreated: userCreated),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: BlocBuilder<ProfileBloc, ProfileStates>(
                  builder: (context, state) {
                    return Text(
                      auth.currentUser!.displayName.toString(),
                      style: theme.textTheme.titleLarge,
                    );
                  },
                ),
              ),
              Text(
                auth.currentUser!.email.toString(),
                style: theme.textTheme.displaySmall,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: OutlinedButton(
                  onPressed: () {
                    Utils.showPhotosOptionDialog(
                        context: context,
                        onCamera: () => takePhotoFromCamera(context),
                        onGallery: () => takePhotoFromGallery(context));
                  },
                  child: Text(
                    'Edit Profile Photo',
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              BlocBuilder<ProfileBloc, ProfileStates>(
                builder: (context, state) {
                  return Stack(
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: state is NameFieldDisplayed ? 0.0 : 1.0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          transform: Matrix4.translationValues(
                            0,
                            0, // Slide up and fade out
                            0,
                          ),
                          child: ProfileOptionsTile(
                            onTap: () => BlocProvider.of<ProfileBloc>(context)
                                .add(ShowNameField()),
                            title: 'Change Name',
                            theme: theme,
                          ),
                        ),
                      ),
                      if (state is NameFieldDisplayed)
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: 1.0,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            transform: Matrix4.translationValues(
                              0,
                              0,
                              0,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextField(
                                controller:
                                    BlocProvider.of<ProfileBloc>(context)
                                        .nameController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () => changeName(
                                        context,
                                        BlocProvider.of<ProfileBloc>(context)
                                            .nameController
                                            .text),
                                    icon: const Icon(Icons.check),
                                  ),
                                  labelText: 'Enter Name',
                                  labelStyle: theme.textTheme.labelSmall,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              BlocBuilder<ProfileBloc, ProfileStates>(
                builder: (context, state) {
                  return Stack(
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: state is PasswordFieldDisplayed ? 0.0 : 1.0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          transform: Matrix4.translationValues(
                            0,
                            0,
                            0,
                          ),
                          child: ProfileOptionsTile(
                              onTap: () => BlocProvider.of<ProfileBloc>(context)
                                  .add(ShowPasswordField()),
                              title: 'Change Password',
                              theme: theme),
                        ),
                      ),
                      if (state is PasswordFieldDisplayed)
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: 1.0,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            transform: Matrix4.translationValues(
                              0,
                              0,
                              0,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextField(
                                controller:
                                    BlocProvider.of<ProfileBloc>(context)
                                        .passwordController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () => changePassword(
                                        context,
                                        BlocProvider.of<ProfileBloc>(context)
                                            .passwordController
                                            .text),
                                    icon: const Icon(Icons.check),
                                  ),
                                  labelText: 'Enter new Password',
                                  labelStyle: theme.textTheme.labelSmall,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              ProfileOptionsTile(onTap: () {}, title: 'Location', theme: theme),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  onTap: () async {
                    await auth.signOut();

                    Navigator.popAndPushNamed(context, AppRoutes.login);
                  },
                  trailing: const Icon(
                    Icons.logout,
                    color: AppColors.white,
                  ),
                  tileColor: AppColors.primary.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  title: Text(
                    'Logout',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void changeName(BuildContext context, String updatedName) async {
    if (updatedName.isNotEmpty) {
      Utils.showLoadingDialog(context);
      await FirebaseAuth.instance.currentUser!.updateDisplayName(updatedName);
      Navigator.pop(context);
      FirebaseAuth.instance.currentUser!.reload();
      BlocProvider.of<ProfileBloc>(context).add(HideNameField());
      Utils.showSnackBar('User Name has been updated', context);
    } else {
      Utils.showSnackBar('Please fill in to proceed', context);
    }
  }

  void changePassword(BuildContext context, String updatedPassword) async {
    if (updatedPassword.isEmpty) {
      Utils.showSnackBar('Please fill in to proceed', context);
    } else {
      Utils.showLoadingDialog(context);
      try {
        await FirebaseAuth.instance.currentUser!
            .updatePassword(updatedPassword);
        Navigator.pop(context);
        FirebaseAuth.instance.currentUser!.reload();
        BlocProvider.of<ProfileBloc>(context).add(HidePasswordField());
        Utils.showSnackBar('Password has been updated', context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.pop(context);
          Utils.showSnackBar(
              'Password should be atleast 6 characters', context);
        }
        if (e.code == 'requires-recent-login') {
          Navigator.pop(context);
          Utils.showSnackBar(
              'Please Relogin again to change password', context);
        }
      }
    }
  }

  void takePhotoFromCamera(BuildContext context) async {
    Navigator.pop(context);
    BlocProvider.of<ProfileBloc>(context).add(LoadingProfilePhoto());
    await BlocProvider.of<ProfileBloc>(context).getFromCamera();
    BlocProvider.of<ProfileBloc>(context).add(CheckProfilePhoto());
  }

  void takePhotoFromGallery(BuildContext context) async {
    Navigator.pop(context);
    BlocProvider.of<ProfileBloc>(context).add(LoadingProfilePhoto());
    await BlocProvider.of<ProfileBloc>(context).getFromGallery();
    BlocProvider.of<ProfileBloc>(context).add(CheckProfilePhoto());
  }
}

class ProfilePhoto extends StatefulWidget {
  const ProfilePhoto({
    super.key,
    required this.auth,
    required this.userCreated,
  });

  final FirebaseAuth auth;
  final bool userCreated;

  @override
  State<ProfilePhoto> createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<ProfileBloc>(context).add(CheckProfilePhoto());

    // state is HasProfilePhoto ||
    //         state is NameFieldDisplayed ||
    //         state is NameFieldHide ||
    //         state is PasswordFieldDisplayed ||
    //         state is PasswordFieldHide
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileStates>(
      builder: (context, state) {
        final profileBloc = context.read<ProfileBloc>();

        if (profileBloc == null) {
          return const CircleAvatar(
            radius: 30.0,
            child: Icon(Icons.person),
          );
        }

        if (state is ProfilePhotoLoading) {
          return const CircleAvatar(
            child: CircularProgressIndicator(),
          );
        }

        return CircleAvatar(
          radius: 50.0,
          backgroundColor: AppColors.primary,
          child: (widget.auth.currentUser != null || widget.userCreated) &&
                  !(profileBloc.hasProfilePhoto ?? false) &&
                  profileBloc.imageFile == null
              ? Text(
                  widget.auth.currentUser?.displayName?.substring(0, 1) ?? 'G',
                  style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                )
              : ClipOval(
                  child: profileBloc.imageFile != null
                      ? Image.file(
                          profileBloc.imageFile!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.person),
                ),
        );
      },
    );
  }
}

class ProfileOptionsTile extends StatelessWidget {
  const ProfileOptionsTile({
    super.key,
    required this.theme,
    required this.title,
    required this.onTap,
  });

  final ThemeData theme;
  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        onTap: () => onTap(),
        trailing: title == 'Location'
            ? const LocationPermissionSwitch()
            : const SizedBox(),
        tileColor: AppColors.grey.withOpacity(0.25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Text(
          title,
          style: theme.textTheme.displayMedium,
        ),
      ),
    );
  }
}

class LocationPermissionSwitch extends StatefulWidget {
  const LocationPermissionSwitch({
    super.key,
  });

  @override
  State<LocationPermissionSwitch> createState() =>
      _LocationPermissionSwitchState();
}

class _LocationPermissionSwitchState extends State<LocationPermissionSwitch>
    with WidgetsBindingObserver {
  bool allowed = false;

  Future<void> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      allowed = serviceEnabled;
    });
  }

  Future<void> changePermission() async {
    await Geolocator.openLocationSettings();
    setState(() {
      allowed = !allowed;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      inactiveThumbColor: AppColors.primary,
      activeColor: AppColors.primary,
      activeTrackColor: AppColors.primary.withOpacity(0.5),
      value: allowed,
      onChanged: (val) {
        changePermission();
      },
    );
  }
}
