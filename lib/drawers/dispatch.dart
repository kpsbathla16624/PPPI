import 'package:flutter/material.dart';
import 'package:pppi/dispatch/dispatch.dart';
import 'package:pppi/dispatch/dispatch_history.dart';
import 'package:pppi/home/home.dart';

class dispatchdrawer extends StatefulWidget {
  const dispatchdrawer({super.key});

  @override
  State<dispatchdrawer> createState() => _dispatchdrawerState();
}

class _dispatchdrawerState extends State<dispatchdrawer> {
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
            Icons.fire_truck_outlined,
            color: Colors.white,
          ),
          title: Text(
            'Dispatch Management',
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DispatchScreen()));
                },
                leading: const Icon(
                  Icons.import_export_rounded,
                  size: 60,
                  color: Colors.black,
                ),
                title: const Text(
                  'Dispatch Goods',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 27,
                  ),
                ),
                subtitle: const Text(
                  'Add records of sent orders',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              color: Colors.blue[400],
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewDispatchScreen()));
                },
                leading: const Icon(
                  Icons.history,
                  size: 60,
                  color: Colors.black,
                ),
                title: const Text(
                  'Dispatch history',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 27,
                  ),
                ),
                subtitle: const Text(
                  'view history of sent orders',
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
