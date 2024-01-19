import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pppi/home/home.dart';

import 'package:pppi/uihelper.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  signUP(String email, String pass) async {
    if (email == "" && pass == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('enter required fields'),
        backgroundColor: Colors.red,
      ));
    } else {
      // ignore: unused_local_variable
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pass)
            .then((value) => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => home())));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          uihelper.customtextfield(
              emailcontroller, "Email ID ", Icons.mail, false),
          uihelper.customtextfield(
              passcontroller, " password  ", Icons.password, true),
          SizedBox(
            height: 30,
          ),
          uihelper.custombutton(() {
            signUP(emailcontroller.text.toString(),
                passcontroller.text.toString());
          }, "LOGIN"),
        ],
      ),
    );
  }
}
