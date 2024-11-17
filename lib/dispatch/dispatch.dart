import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pppi/theme/appcolors.dart'; // Assuming AppColors exists for color consistency

class DispatchScreen extends StatefulWidget {
  @override
  _DispatchScreenState createState() => _DispatchScreenState();
}

class _DispatchScreenState extends State<DispatchScreen> {
  String _selectedPolytheneType = 'PP';
  String _selectedPrintType = 'Plain';
  String _buyerName = '';
  int _numberOfPackets = 0;
  List<double> _weights = List.filled(0, 0.0);
  String _polytheneSize = '';
  double _total = 0;

  String formattedDateTime = DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.now());

  final _formKey = GlobalKey<FormState>();

  Future<void> insertFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final data = {
        'polythene Type': _selectedPolytheneType,
        'print Type': _selectedPrintType,
        'buyer Name': _buyerName,
        'number Of Packets': _numberOfPackets,
        'weights': _weights,
        'polythene Size': _polytheneSize,
        'total': _total,
        'date Time': formattedDateTime,
      };
      await firestore.collection('dispatch').add(data);
    } catch (e) {
      print('Error inserting data to Firestore: $e');
    }
  }

  Future<void> _submit() async {
    if (_numberOfPackets != _weights.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Please enter weight for each packet.'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    _total = _weights.fold(0, (sum, weight) => sum + weight);
    _total = double.parse(_total.toStringAsFixed(2));
    await insertFirestore();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => DispatchScreen()),
    );
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
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
    String? initialValue,
  }) {
    return Container(
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
        initialValue: initialValue,
        onChanged: onChanged,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.textSecondary),
          prefixIcon: Icon(icon, color: AppColors.accentColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.cardDark,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.textSecondary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Dispatch Goods',
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'New Dispatch Entry',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter the details for dispatching goods',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
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
                      value: _selectedPolytheneType,
                      onChanged: (value) => setState(() => _selectedPolytheneType = value!),
                      items: ['PP', 'LDPE'].map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Polythene Type',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        border: InputBorder.none,
                        icon: Icon(Icons.category, color: AppColors.accentColor),
                      ),
                      dropdownColor: AppColors.cardDark,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                      value: _selectedPrintType,
                      onChanged: (value) => setState(() => _selectedPrintType = value!),
                      items: ['Plain', 'Printed'].map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Print Type',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        border: InputBorder.none,
                        icon: Icon(Icons.print, color: AppColors.accentColor),
                      ),
                      dropdownColor: AppColors.cardDark,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildInputField(
                    label: 'Buyer Name',
                    icon: Icons.person_outline,
                    onChanged: (value) => setState(() => _buyerName = value),
                  ),
                  _buildInputField(
                    label: 'Number of Packets',
                    icon: Icons.local_offer,
                    onChanged: (value) {
                      setState(() {
                        _numberOfPackets = int.tryParse(value) ?? 0;
                        _weights = List.filled(_numberOfPackets, 0.0);
                      });
                    },
                    keyboardType: TextInputType.number,
                  ),
                  for (int i = 0; i < _numberOfPackets; i++)
                    _buildInputField(
                      label: 'Weight of Packet ${i + 1}',
                      icon: Icons.scale,
                      onChanged: (value) => setState(() {
                        _weights[i] = double.tryParse(value) ?? 0.0;
                      }),
                      keyboardType: TextInputType.number,
                    ),
                  _buildInputField(
                    label: 'Polythene Size',
                    icon: Icons.straighten,
                    onChanged: (value) => setState(() => _polytheneSize = value),
                  ),
                  const SizedBox(height: 32),
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
                        Icon(Icons.save_rounded),
                        SizedBox(width: 8),
                        Text(
                          'Dispatch Material',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
