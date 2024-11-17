import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pppi/main.dart';
import 'package:pppi/theme/appcolors.dart';

class AddRecord extends StatefulWidget {
  const AddRecord({super.key});

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  TextEditingController _expenseController = TextEditingController();
  String? description;
  DateTime _selectedDate = DateTime.now();
  String? _selectedEmployee;
  TimeOfDay _selectedTime = TimeOfDay(hour: 12, minute: 0); // Default time 12:00 PM

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

      // Combine the date and time
      DateTime combinedDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      String date = DateFormat('dd/MM/yyyy, hh:mm a').format(combinedDateTime);

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
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Expense recorded successfully.'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      // Clear the text fields after recording
      _expenseController.clear();
    } catch (e) {
      print('Error recording expense: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Error recording expense.'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
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
            'Record Expenses',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _selectDate(context),
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
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text('Select Date'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _selectTime(context),
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
                    Icon(Icons.access_time),
                    SizedBox(width: 8),
                    Text('Select Time'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Selected Time: ${_selectedTime.format(context)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.accentColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _expenseController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Expense Amount',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.money, color: AppColors.accentColor),
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
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
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
                      description = value;
                    });
                  },
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Expense Description',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.description, color: AppColors.accentColor),
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
              if (description == 'salary')
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
                    value: _selectedEmployee,
                    items: employee.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Employee name',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                      border: InputBorder.none,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedEmployee = newValue;
                      });
                    },
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _recordExpense(),
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
                    Text('Record Expense'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
