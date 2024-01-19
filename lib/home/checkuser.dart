import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pppi/home/home.dart';

import 'package:pppi/home/login.dart';

class checkUser extends StatefulWidget {
  const checkUser({super.key});

  @override
  State<checkUser> createState() => _checkUserState();
}

class _checkUserState extends State<checkUser> {
  @override
  Widget build(BuildContext context) {
    return checkuser();
  }

  checkuser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return home();
    } else {
      return login();
    }
  }
}
