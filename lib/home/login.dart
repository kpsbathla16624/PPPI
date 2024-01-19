import 'package:flutter/material.dart';
import 'package:pppi/home/home.dart';

import 'package:pppi/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  loginbutton(String email, String pass) async {
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
            .signInWithEmailAndPassword(email: email, password: pass)
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
        title: Text("login/register"),
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
            loginbutton(emailcontroller.text.toString(),
                passcontroller.text.toString());
          }, "login"),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
