import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pppi/orders/stock.dart';

class ADD_empScreen extends StatefulWidget {
  @override
  _ADD_empScreenState createState() => _ADD_empScreenState();
}

class _ADD_empScreenState extends State<ADD_empScreen> {
  String Emp_name = "";

  double Salary = 0;
  String empType = "Permanent";

  String formattedDateTime =
      DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.now());

  CollectionReference empData = FirebaseFirestore.instance.collection('emp');

  Future<void> insertFirestore() async {
    try {
      // Prepare data to insert
      Map<String, dynamic> data = {
        'Employee Name': Emp_name,
        'Salary': Salary,
        'type': empType,
        'date': formattedDateTime
      };
      await empData.add(data);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data saved successfully'),
        ),
      );
    } catch (e) {
      print('Error inserting data to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save data. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _submit() async {
    try {
      await insertFirestore();
    } finally {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ADD_empScreen(),
      ));
      updateStock();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add employee'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: empType,
                onChanged: (value) {
                  setState(() {
                    empType = value!;
                  });
                },
                items: ['Permanent', 'Temporary']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Employee Type'),
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    Emp_name = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Employee Name '),
              ),
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    Salary = double.tryParse(value) ?? 0;
                  });
                },
                decoration: InputDecoration(labelText: 'Employee Salary '),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _submit,
                child: Text('submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
