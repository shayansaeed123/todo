import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/screens/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void login(BuildContext context){
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if(user != null){
      Timer(Duration(seconds: 3), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(),));
      });
    }
    // else{
    //   Timer(Duration(seconds: 3), () {
    //     Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen(),));
    //   });
    // }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    login(context);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false,title: Text("Authentication"),),
        body: AuthForms(),
      ),
    );
  }
}
