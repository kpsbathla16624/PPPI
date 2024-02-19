import 'package:flutter/material.dart';
import 'package:pppi/purchase/add_raw.dart';
import 'package:pppi/home/home.dart';
import 'package:pppi/purchase/purchase_history.dart';

class PurchaseDrawer extends StatefulWidget {
  const PurchaseDrawer({super.key});

  @override
  State<PurchaseDrawer> createState() => _PurchaseDrawerState();
}

class _PurchaseDrawerState extends State<PurchaseDrawer> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => home(),
        ));
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.shopping_cart_checkout_sharp,
            color: Colors.white,
          ),
          title: Text(
            'Purchase Management',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 1, 41, 46),
          centerTitle: false,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              color: Colors.blue[400],
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddRawMaterialScreen()));
                },
                leading: Icon(
                  Icons.raw_on,
                  size: 60,
                  color: Colors.black,
                ),
                title: Text(
                  'Add Purchase records',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 27,
                  ),
                ),
                subtitle: Text(
                  'PP,Ld, ink, ...',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              color: Colors.blue[400],
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewInventoryScreen()),
                  );
                },
                leading: Icon(
                  Icons.history,
                  size: 60,
                  color: Colors.black,
                ),
                title: Text(
                  'Purchase History',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 27,
                  ),
                ),
                subtitle: Text(
                  'Purchase book',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
