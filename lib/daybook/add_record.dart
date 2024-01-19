import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pppi/main.dart';

class add_record extends StatefulWidget {
  const add_record({super.key});

  @override
  State<add_record> createState() => _add_recordState();
}

class _add_recordState extends State<add_record> {
  TextEditingController _expenseController = TextEditingController();
  String? description;
  DateTime _selectedDate = DateTime.now();
  String? _selectedEmployee;

  Future<void> _recordExpense() async {
    try {
      // Format the selected date as a string (e.g., '2022-01-14')
      String formattedDate = _selectedDate.toLocal().toString().split(' ')[0];

      // Ensure the amount is a valid numeric value
      double amount;
      try {
        amount = double.parse(_expenseController.text.trim());
      } catch (e) {
        throw Exception('Invalid amount format');
      }

      // Get the description from the user

      String date = DateFormat('dd/MM/yyyy, hh:mm a').format(_selectedDate);

      // Convert expense data to a Map
      Map<String, dynamic> expenseData = {
        'amount': amount,
        'description': _selectedEmployee != null
            ? 'Salary ($_selectedEmployee)'
            : description,
        'Date and time': date,
        // You can add more fields as needed
      };

      // Convert temp data to a Map
      Map<String, dynamic> temp = {
        'temp': 0,
        // You can add more fields as needed
      };

      final databaseReference = FirebaseFirestore.instance;
      // Add the expense data to the subcollection
      await databaseReference
          .collection('daybook')
          .doc(formattedDate)
          .collection('expenses')
          .add(expenseData);

      // Set the temp data directly in the document with name formattedDate
      await databaseReference
          .collection('daybook')
          .doc(formattedDate)
          .set({'temp': temp});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Expense recorded successfully.'),
        ),
      );

      // Clear the text fields after recording
      _expenseController.clear();
    } catch (e) {
      print('Error recording expense: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error recording expense.'),
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Expenses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Date: ${DateFormat('dd/MM/yyyy, hh:mm a').format(_selectedDate)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Date'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _expenseController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Expense Amount',
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                    decoration:
                        InputDecoration(labelText: 'Expense Description'),
                  ),
                ),
              ],
            ),
            if (description == 'salary')
              DropdownButtonFormField<String>(
                value: _selectedEmployee,
                items: employee.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Employee name'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedEmployee = newValue;
                  });
                },
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _recordExpense(),
              child: Text('Record Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
