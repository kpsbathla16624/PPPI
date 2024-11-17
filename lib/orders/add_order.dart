import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pppi/theme/appcolors.dart';

class AddOrderScreen extends StatefulWidget {
  @override
  _AddOrderScreenState createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  String _selectedPolytheneType = 'PP';
  String _selectedPrintType = 'Plain';
  String _buyerName = '';
  double quantity = 0;
  int gauge = 0;
  String _polytheneSize = '';

  final String formattedDateTime = DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.now());
  final CollectionReference orderPP = FirebaseFirestore.instance.collection('order-pp');
  final CollectionReference orderLD = FirebaseFirestore.instance.collection('order-LD');

  final _formKey = GlobalKey<FormState>();

  // Method to build input fields with consistent styling
  Widget _buildInputField({
    required String label,
    required IconData icon,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
    String? initialValue,
    String? Function(String?)? validator,
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
        validator: validator,
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

  Future<void> _insertOrderToFirestore() async {
    try {
      // Prepare data for insertion
      Map<String, dynamic> data = {
        'material type': _selectedPolytheneType,
        'print type': _selectedPrintType,
        'Buyer Name': _buyerName,
        'Quantity': quantity,
        'Size': _polytheneSize,
        'Gauge': gauge,
        'Date and Time': formattedDateTime,
      };

      CollectionReference targetCollection;
      String stockField = '';

      switch (_selectedPolytheneType) {
        case "PP":
          targetCollection = orderPP;
          stockField = 'stock-PP';
          break;
        case "LDPE":
          targetCollection = orderLD;
          stockField = 'stock-LD';
          break;
        default:
          throw Exception('Invalid material type');
      }

      await targetCollection.add(data);

      if (stockField.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('stock')
            .doc('wUNr03PFWTAx36YXldFy')
            .update({stockField: FieldValue.increment(quantity)});
      }

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
      print('Error inserting order to Firestore: $e');
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

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _insertOrderToFirestore();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AddOrderScreen()),
        );
      } catch (e) {
        print('Error in submit: $e');
      }
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.textSecondary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Add Order',
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
                    'New Order Entry',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter the details of the new order',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Polythene Type Dropdown
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
                      onChanged: (value) {
                        setState(() {
                          _selectedPolytheneType = value!;
                        });
                      },
                      items: ['PP', 'LDPE'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value));
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
                  SizedBox(height: 16),
                  // Print Type Dropdown
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
                      onChanged: (value) {
                        setState(() {
                          _selectedPrintType = value!;
                        });
                      },
                      items: ['Plain', 'Printed'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value));
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
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter buyer name' : null,
                  ),
                  _buildInputField(
                    label: 'Polythene Size',
                    icon: Icons.crop_16_9,
                    onChanged: (value) => setState(() => _polytheneSize = value),
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter polythene size' : null,
                  ),
                  _buildInputField(
                    label: 'Gauge',
                    icon: Icons.format_list_numbered,
                    onChanged: (value) => setState(() => gauge = int.tryParse(value) ?? 0),
                    keyboardType: TextInputType.number,
                    validator: (value) => (int.tryParse(value ?? '') ?? 0) <= 0 ? 'Please enter valid gauge' : null,
                  ),
                  _buildInputField(
                    label: 'Quantity',
                    icon: Icons.add_shopping_cart,
                    onChanged: (value) => setState(() => quantity = double.tryParse(value) ?? 0),
                    keyboardType: TextInputType.number,
                    validator: (value) => (double.tryParse(value ?? '') ?? 0) <= 0 ? 'Please enter valid quantity' : null,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _submitOrder,
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
                          'Save Order',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
