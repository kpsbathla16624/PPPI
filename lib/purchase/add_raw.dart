import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pppi/orders/stock.dart';
import 'package:pppi/theme/appcolors.dart';

class AddRawMaterialScreen extends StatefulWidget {
  @override
  _AddRawMaterialScreenState createState() => _AddRawMaterialScreenState();
}

class _AddRawMaterialScreenState extends State<AddRawMaterialScreen> {
  String _material_type = 'PP';
  String _sellerName = '';
  double quantity = 0;
  String _inkcolor = '';
  String formattedDateTime = DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.now());

  final _formKey = GlobalKey<FormState>();

  // Firebase collections
  CollectionReference purchasePP = FirebaseFirestore.instance.collection('purchase-pp');
  CollectionReference purchaseLD = FirebaseFirestore.instance.collection('purchase-LD');
  CollectionReference purchaseFilm = FirebaseFirestore.instance.collection('purchase-Film');
  CollectionReference purchaseMoulding = FirebaseFirestore.instance.collection('purchase-moulding');
  CollectionReference purchaseink = FirebaseFirestore.instance.collection('purchase-ink');

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

  Future<void> insertFirestore() async {
    try {
      Map<String, dynamic> data = {
        'material type': _material_type,
        'seller Name': _sellerName,
        'quantity': quantity,
        'Date Time': formattedDateTime,
      };

      if (_material_type == "Ink") {
        data['Ink color'] = _inkcolor;
      }

      CollectionReference targetCollection;
      String stockField = '';

      switch (_material_type) {
        case "PP":
          targetCollection = purchasePP;
          stockField = 'stock-PP';
          break;
        case "LDPE":
          targetCollection = purchaseLD;
          stockField = 'stock-LD';
          break;
        case "film":
          targetCollection = purchaseFilm;
          break;
        case "moulding":
          targetCollection = purchaseMoulding;
          break;
        case "Ink":
          targetCollection = purchaseink;
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
    if (_formKey.currentState!.validate()) {
      try {
        await insertFirestore();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AddRawMaterialScreen()),
        );
        updateStock();
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
            'Add Raw Material',
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
                    'New Purchase Entry',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter the details of the new raw material purchase',
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
                      value: _material_type,
                      onChanged: (value) {
                        setState(() {
                          _material_type = value!;
                        });
                      },
                      items: ['PP', 'LDPE', 'film', 'moulding', 'Ink']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Material Type',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        border: InputBorder.none,
                        icon: Icon(Icons.category, color: AppColors.accentColor),
                      ),
                      dropdownColor: AppColors.cardDark,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                  _buildInputField(
                    label: 'Seller Name',
                    icon: Icons.person_outline,
                    onChanged: (value) => setState(() => _sellerName = value),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter seller name' : null,
                  ),
                  _buildInputField(
                    label: 'Quantity',
                    icon: Icons.add_shopping_cart,
                    onChanged: (value) =>
                        setState(() => quantity = double.tryParse(value) ?? 0),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        (double.tryParse(value ?? '') ?? 0) <= 0
                            ? 'Please enter valid quantity'
                            : null,
                  ),
                  if (_material_type == 'Ink')
                    _buildInputField(
                      label: 'Ink Color',
                      icon: Icons.color_lens,
                      onChanged: (value) => setState(() => _inkcolor = value),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter ink color' : null,
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
                          'Save Purchase Record',
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