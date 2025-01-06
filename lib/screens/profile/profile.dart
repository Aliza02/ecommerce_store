import 'package:ecommerce_store/bloc/signupBloc/signup_bloc.dart';
import 'package:ecommerce_store/constants/colors.dart';
import 'package:ecommerce_store/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Profile',
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 50.0,
                backgroundColor: AppColors.primary,
                child: auth.currentUser != null || userCreated
                    ? Text(
                        auth.currentUser!.displayName![0],
                        style: const TextStyle(
                          fontSize: 40.0,
                          color: AppColors.white,
                        ),
                      )
                    : const Icon(
                        Icons.person,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  auth.currentUser!.displayName.toString(),
                  style: theme.textTheme.titleLarge,
                ),
              ),
              Text(
                auth.currentUser!.email.toString(),
                style: theme.textTheme.displaySmall,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: OutlinedButton(
                  onPressed: () => print('edit profile'),
                  child: Text(
                    'Edit Profile Photo',
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ProfileOptionsTile(title: 'Change Name', theme: theme),
              ProfileOptionsTile(title: 'Change Password', theme: theme),
              ProfileOptionsTile(title: 'Location', theme: theme),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  onTap: () {},
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
}

class ProfileOptionsTile extends StatelessWidget {
  const ProfileOptionsTile({
    super.key,
    required this.theme,
    required this.title,
  });

  final ThemeData theme;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        onTap: () {},
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

class _LocationPermissionSwitchState extends State<LocationPermissionSwitch> {
  bool allowed = false;
  @override
  Widget build(BuildContext context) {
    return Switch(
      inactiveThumbColor: AppColors.primary,
      activeColor: AppColors.primary,
      activeTrackColor: AppColors.primary.withOpacity(0.5),
      value: allowed,
      onChanged: (val) {
        setState(() {
          allowed = val;
        });
      },
    );
  }
}
