import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  Loading({Key key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void fetchUserData() async {
    // Do some API calls during loading state
    print("Fetching user data");
    String username = await Future.delayed(Duration(seconds: 2), () {
      return "khaitruong922";
    });
    print(username);
    Navigator.pushReplacementNamed(context, "/home", arguments: {
      "username": username,
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.orange[50],
        body: Center(
          child: SpinKitWave(
            color: Colors.orange,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}
