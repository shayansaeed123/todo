import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/home_screen.dart';

class AuthForms extends StatefulWidget {
  const AuthForms({super.key});

  @override
  State<AuthForms> createState() => _AuthFormsState();
}

class _AuthFormsState extends State<AuthForms> {
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;
  final emailCon = TextEditingController();
  final passCon = TextEditingController();
  final userCon = TextEditingController();

  startAuthentication(){
    final validity = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(validity){
      _formKey.currentState!.save();
      submitForm();
    }
  }
  submitForm()async{
    final auth = FirebaseAuth.instance;
    try{
      if(isLoginPage){
       await auth.signInWithEmailAndPassword(email: emailCon.text.toString(), password: passCon.text.toString());
       Navigator.push(context, MaterialPageRoute(builder: (context) => Home(),));
      }else{
        await auth.createUserWithEmailAndPassword(email: emailCon.text.toString(), password: passCon.text.toString());
        final uid = DateTime.now().microsecondsSinceEpoch.toString();
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username' : userCon.text.toString(),
          'email' : emailCon.text.toString(),
        });
        // Navigator.push(context, MaterialPageRoute(builder: (context) => Home(),));
        isLoginPage = true;
        setState(() {

        });
      }

    }catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            height: height * .3,
            width: width,
            child: Center(child: Icon(Icons.login_rounded, size: 150)),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(top: height* 0.01, left: width*0.01,right: width*0.01),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(!isLoginPage)
                      TextFormField(
                        controller: userCon,
                        keyboardType: TextInputType.text,
                        key: ValueKey('username'),
                        validator: (value) {
                          if(value!.isEmpty){
                            return 'incorrect username';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'enter username',
                            labelStyle: GoogleFonts.roboto(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: new BorderSide(),
                            )
                        ),
                      ),
                    SizedBox(height: height*0.03,),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('email'),
                      validator: (value) {
                        if(value!.isEmpty){
                          return 'incorrect Email';
                        }
                        return null;
                      },
                      controller: emailCon,
                      decoration: InputDecoration(
                        labelText: 'enter email',
                        labelStyle: GoogleFonts.roboto(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: new BorderSide(),
                        )
                      ),
                    ),
                    SizedBox(height: height * 0.03,),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      key: ValueKey('password'),
                      validator: (value) {
                        if(value!.isEmpty){
                          return 'incorrect password';
                        }
                        return null;
                      },
                      obscureText: true,
                      controller: passCon,
                      decoration: InputDecoration(
                          labelText: 'enter password',
                          labelStyle: GoogleFonts.roboto(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: new BorderSide(),
                          )
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        startAuthentication();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(8)),
                        height: height * .05,
                        width: width,
                        margin: EdgeInsets.symmetric(vertical: height*0.02,horizontal: width*.3),
                        child: isLoginPage? Center(child: Text('Login',style: GoogleFonts.roboto()),)
                            : Center(child: Text('SignUp',style: GoogleFonts.roboto()),)
                      ),
                    ),
                    SizedBox(height: height * 0.01,),
                    TextButton(onPressed: (){
                      setState(() {

                      });
                      isLoginPage=!isLoginPage;
                    }, child: isLoginPage ? Text('Not a Member?') : Text('Already a Member?'))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
