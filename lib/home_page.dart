import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sub/sign_in.dart';
import 'package:firebase_sub/sign_iup.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSignedIn =false;
  String userId ="";

  void checkSignInState(){
     FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user){
      if (user == null) {
        setState(() {
          _isSignedIn = false;
        });
      } else {
          userId = user.uid;
        setState(() {
          _isSignedIn = true;
        });
      }
    });
  }
  @override
  void initState() {
    super.initState();
    checkSignInState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isSignedIn? Chat(id: userId):const SignUp(),
    );
  }
}
