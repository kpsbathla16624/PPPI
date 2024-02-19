import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pppi/orders/stock.dart';

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

  CollectionReference purchasePP = FirebaseFirestore.instance.collection('purchase-pp');
  CollectionReference purchaseLD = FirebaseFirestore.instance.collection('purchase-LD');
  CollectionReference purchaseFilm = FirebaseFirestore.instance.collection('purchase-Film');
  CollectionReference purchaseMoulding = FirebaseFirestore.instance.collection('purchase-moulding');
  CollectionReference purchaseink = FirebaseFirestore.instance.collection('purchase-ink');

  Future<void> insertFirestore() async {
    try {
      // Prepare data to insert
      Map<String, dynamic> data = {
        'material type': _material_type,
        'seller Name': _sellerName,
        'quantity': quantity,
        'Date Time': formattedDateTime,
      };

      if (_material_type == "Ink") {
        data = {
          'material type': _material_type,
          'seller Name': _sellerName,
          'Ink color': _inkcolor,
          'quantity': quantity,
          'Date Time': formattedDateTime,
        };
      } else if (_material_type != "Ink") {
        data = {
          'material type': _material_type,
          'seller Name': _sellerName,
          'quantity': quantity,
          'Date Time': formattedDateTime,
        };
      }
      // Insert data into Firestore
      if (_material_type == "PP") {
        await purchasePP.add(data);
        await FirebaseFirestore.instance.collection('stock').doc('wUNr03PFWTAx36YXldFy').update({
          'stock-PP': FieldValue.increment(quantity),
        });
      } else if (_material_type == "LDPE") {
        await purchaseLD.add(data);
        await FirebaseFirestore.instance.collection('stock').doc('wUNr03PFWTAx36YXldFy').update({
          'stock-LD': FieldValue.increment(quantity),
        });
      } else if (_material_type == "film") {
        await purchaseFilm.add(data);
      } else if (_material_type == "moulding") {
        await purchaseMoulding.add(data);
      } else if (_material_type == "Ink") {
        await purchaseink.add(data);
      }

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
        builder: (context) => AddRawMaterialScreen(),
      ));
      updateStock();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Add Raw Material',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 1, 41, 46),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _material_type,
                onChanged: (value) {
                  setState(() {
                    _material_type = value!;
                  });
                },
                items: ['PP', 'LDPE', 'film', 'moulding', 'Ink'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'material Type'),
              ),
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _sellerName = value;
                  });
                },
                decoration: InputDecoration(labelText: 'seller Name'),
              ),
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    quantity = double.tryParse(value) ?? 0;
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'quantity'),
              ),
              SizedBox(height: 10),
              if (_material_type == 'Ink')
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _inkcolor = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'ink color'),
                ),
              SizedBox(height: 20),
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
