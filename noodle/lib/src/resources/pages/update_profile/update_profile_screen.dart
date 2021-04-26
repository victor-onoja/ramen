import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noodle/src/resources/pages/profile/bloc/profile_cubit.dart';
import 'package:noodle/src/resources/pages/register/bloc/register_cubit.dart';
import 'package:noodle/src/resources/pages/update_profile/bloc/update_profile_cubit.dart';
import 'package:noodle/src/resources/pages/update_profile/bloc/update_profile_state.dart';
import 'package:noodle/src/core/models/ramen_api_response.dart';
import 'package:noodle/src/core/models/user.dart';
import 'package:noodle/src/resources/shared/backable_app_bar.dart';
import 'package:noodle/src/resources/shared/form_input.dart';
import 'package:noodle/src/resources/shared/submit_button.dart';

class UpdateProfileScreen extends StatelessWidget {
  final ProfileCubit profileCubit;
  final UpdateProfileCubit updateProfileCubit;

  UpdateProfileScreen(
      {required this.profileCubit, required this.updateProfileCubit});

  @override
  Widget build(BuildContext context) {
    void updateProfile() async {
      await updateProfileCubit.updateProfile();
      print("Profile updated on server");
      await profileCubit.fetchUser();
      print("Profile fetched to client");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Update profile succesfully!")));
    }

    User? user = profileCubit.getUser();
    if (user == null) {
      Navigator.pop(context);
      return Container();
    }
    updateProfileCubit.firstNameChanged(user.firstName);
    updateProfileCubit.lastNameChanged(user.lastName);
    updateProfileCubit.bioChanged(user.bio);
    updateProfileCubit.avatarPathChanged(user.avatarPath);
    return Scaffold(
        appBar: backableAppBar(context: context, title: "Update profile"),
        backgroundColor: Theme.of(context).accentColor,
        body: Center(
          child: Padding(
            child: ListView(
              children: [
                SizedBox(height: 15),
                _Avatar(updateProfileCubit: updateProfileCubit),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: _FirstNameInput(
                      initialValue: user.firstName,
                      updateProfileCubit: updateProfileCubit,
                    )),
                    SizedBox(width: 10),
                    Flexible(
                        child: _LastNameInput(
                      initialValue: user.lastName,
                      updateProfileCubit: updateProfileCubit,
                    )),
                  ],
                ),
                SizedBox(height: 15),
                _BioInput(
                  initialValue: user.bio,
                  updateProfileCubit: updateProfileCubit,
                ),
                SizedBox(height: 15),
                SubmitButton(
                  content: Text("Save changes"),
                  color: Theme.of(context).primaryColor,
                  onPressCallback: updateProfile,
                )
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 40),
          ),
        ));
  }
}

class _Avatar extends StatelessWidget {
  _Avatar({required this.updateProfileCubit});

  final UpdateProfileCubit updateProfileCubit;

  final ImagePicker picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      updateProfileCubit.newAvatarFilePathChanged(pickedFile.path);
      print(pickedFile.path);
    } else {
      print("No image selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
      cubit: updateProfileCubit,
      builder: (context, state) {
        return GestureDetector(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: state.image,
          ),
          onTap: () {
            getImage();
            print("Avatar tapped");
          },
        );
      },
    );
  }
}

class _FirstNameInput extends StatelessWidget {
  _FirstNameInput(
      {required this.initialValue, required this.updateProfileCubit});

  final String initialValue;
  final UpdateProfileCubit updateProfileCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
      cubit: updateProfileCubit,
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (context, state) {
        return Container(
            child: FormInput(
          initialValue: initialValue,
          onChangedCallback: (value) =>
              updateProfileCubit.firstNameChanged(value),
          labelText: 'First name',
          errorText: state.firstName.invalid ? 'Invalid name' : null,
        ));
      },
    );
  }
}

class _LastNameInput extends StatelessWidget {
  _LastNameInput(
      {required this.initialValue, required this.updateProfileCubit});

  final String initialValue;
  final UpdateProfileCubit updateProfileCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
      cubit: updateProfileCubit,
      buildWhen: (previous, current) => previous.lastName != current.lastName,
      builder: (context, state) {
        return Container(
            child: FormInput(
          initialValue: initialValue,
          onChangedCallback: (value) =>
              updateProfileCubit.lastNameChanged(value),
          labelText: 'Last name',
          errorText: state.lastName.invalid ? 'Invalid name' : null,
        ));
      },
    );
  }
}

class _BioInput extends StatelessWidget {
  _BioInput({required this.initialValue, required this.updateProfileCubit});

  final String initialValue;
  final UpdateProfileCubit updateProfileCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
      cubit: updateProfileCubit,
      buildWhen: (previous, current) => previous.bio != current.bio,
      builder: (context, state) {
        return Container(
          child: FormInput(
            initialValue: initialValue,
            onChangedCallback: (value) => updateProfileCubit.bioChanged(value),
            labelText: 'Bio',
            errorText: state.bio.invalid ? 'Maximum 500 characters' : null,
            textInputType: TextInputType.multiline,
            textAlignVertical: TextAlignVertical.top,
            lines: 3,
          ),
        );
      },
    );
  }
}
