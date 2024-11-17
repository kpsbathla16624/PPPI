import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pppi/orders/stock.dart';
import 'package:pppi/theme/appcolors.dart';

class AddEmployeeScreen extends StatefulWidget {
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  String empName = "";
  double salary = 0;
  String empType = "Permanent";

  String formattedDateTime = DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.now());

  CollectionReference empData = FirebaseFirestore.instance.collection('emp');

  Future<void> insertFirestore() async {
    try {
      // Prepare data to insert
      Map<String, dynamic> data = {
        'Employee Name': empName,
        'Salary': salary,
        'type': empType,
        'date': formattedDateTime
      };
      await empData.add(data);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Data saved successfully'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      print('Error inserting data to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Failed to save data. Please try again.'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> _submit() async {
    try {
      await insertFirestore();
    } finally {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => AddEmployeeScreen(),
      ));
      updateStock();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.primaryDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.secondaryDark,
          elevation: 0,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add Employee',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dropdown for Employee Type
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accentColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: DropdownButtonFormField<String>(
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
                        child: Text(value, style: TextStyle(color: AppColors.textPrimary)),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Employee Type',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                      prefixIcon: const Icon(Icons.work, color: AppColors.accentColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.cardDark,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Employee Name
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accentColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        empName = value;
                      });
                    },
                    style: TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Employee Name',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                      prefixIcon: const Icon(Icons.person, color: AppColors.accentColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.cardDark,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Employee Salary
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accentColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        salary = double.tryParse(value) ?? 0;
                      });
                    },
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Employee Salary',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                      prefixIcon: const Icon(Icons.monetization_on, color: AppColors.accentColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.cardDark,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save),
                      SizedBox(width: 8),
                      Text('Submit'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
