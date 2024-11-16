import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pppi/home/checkuser.dart';
import 'package:pppi/orders/stock.dart';

double Stock_PP = 0;
double Stock_LD = 0;
double Stock_film = 0;
double Stock_moulding = 0;
double order_PP = 0;
double order_LD = 0;
List<String> employee = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          ));
  updateStock();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parmarth print pack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: checkUser(),
    );
  }
}
