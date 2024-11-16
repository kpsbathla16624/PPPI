import 'package:flutter/material.dart';
import 'package:pppi/employee/add_emp.dart';
import 'package:pppi/employee/view_emp.dart';
import 'package:pppi/home/home.dart';

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
          leading: Icon(
            Icons.person,
            color: Colors.white,
          ),
          title: Text(
            'Employee Mnagement ',
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ADD_empScreen()));
                },
                leading: const Icon(
                  Icons.person_add_alt_1,
                  size: 60,
                  color: Colors.black,
                ),
                title: const Text(
                  'Add Employee',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 27,
                  ),
                ),
                subtitle: const Text(
                  'Add Employee Data ',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              color: Colors.blue[400],
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewEMPScreen()));
                },
                leading: const Icon(
                  Icons.person_pin,
                  size: 60,
                  color: Colors.black,
                ),
                title: const Text(
                  'Employee list ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 27,
                  ),
                ),
                subtitle: const Text(
                  'view all employees and workers list ',
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
