import 'package:flutter/material.dart';
import 'package:pppi/employee/add_emp.dart';
import 'package:pppi/home/home.dart';
import 'package:pppi/purchase/purchase_history.dart';

class EmployeeDrawer extends StatefulWidget {
  const EmployeeDrawer({super.key});

  @override
  State<EmployeeDrawer> createState() => _EmployeeDrawerState();
}

class _EmployeeDrawerState extends State<EmployeeDrawer> {
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
          title: Text('employee management '),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ADD_empScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: Text(
                'Add Employee Data',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewInventoryScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: Text(
                'Employee List',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
