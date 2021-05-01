import 'package:flutter/material.dart';
import 'package:noodle/src/core/models/user.dart';
import 'package:noodle/src/resources/pages/auth/bloc/auth_bloc.dart';
import 'package:noodle/src/resources/pages/profile/bloc/user_cubit.dart';
import 'package:noodle/src/resources/shared/home_app_bar.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        authBloc: Provider.of<AuthenticationBloc>(context, listen: false),
        title: 'Notifications',
        userCubit: Provider.of<UserCubit>(context, listen: false),
      ),
      backgroundColor: Theme.of(context).accentColor,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            _Card(user: User.mock),
            _Card(user: User.mock),
            _Card(user: User.mock),
            _Card(user: User.mock),
            _Card(user: User.mock),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  _Card({required this.user});

  final User user;
  String _timestamp = "1m";

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {},
        //TODO: when the user tap, a function will call to mark notification as read
        leading: CircleAvatar(
            radius: 30, backgroundImage: Image.network(user.avatarPath).image),
        title: Text(
          user.username,
          style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor)),
                child: Text(
                  'Accept',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1!.color),
                )),
            //TODO: when click, call a function to add a user to the current user friend list, then delete the friend request
            const SizedBox(width: 8),

            TextButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).secondaryHeaderColor)),
                child: Text(
                  'Deny',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1!.color),
                )),
            //TODO: when click, delete the friend request
            const SizedBox(width: 8),
          ],
        ),
        trailing: Text(
          _timestamp,
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
        ));
  }
}
