import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pppi/main.dart';
import 'stock.dart';

class Add_order extends StatefulWidget {
  @override
  _Add_orderState createState() => _Add_orderState();
}

class _Add_orderState extends State<Add_order> {
  String _selectedPolytheneType = 'PP';
  String _selectedPrintType = 'Plain';
  String _buyerName = '';
  double quanity = 0;
  int gauge = 0;
  String _polytheneSize = '';

  String formattedDateTime =
      DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.now());
  CollectionReference orderPP =
      FirebaseFirestore.instance.collection('order-pp');
  CollectionReference orderLD =
      FirebaseFirestore.instance.collection('order-LD');
  Future<void> insertFirestore() async {
    try {
      // Prepare data to insert
      Map<String, dynamic> data = {
        'material type': _selectedPolytheneType,
        'print type': _selectedPrintType,
        'Buyer Name': _buyerName,
        'Quantity': quanity,
        'Size': _polytheneSize,
        'Guage': gauge,
        'Date and Time': formattedDateTime,
      };

      if (_selectedPolytheneType == "PP") {
        await orderPP.add(data);

        // Update stock-PP in the 'stock' collection
        await FirebaseFirestore.instance
            .collection('stock')
            .doc('wUNr03PFWTAx36YXldFy')
            .update({
          'order-PP': FieldValue.increment(quanity),
        });
      } else if (_selectedPolytheneType == "LDPE") {
        await orderLD.add(data);

        // Update stock-LD in the 'stock' collection
        await FirebaseFirestore.instance
            .collection('stock')
            .doc('wUNr03PFWTAx36YXldFy')
            .update({
          'order-LD': FieldValue.increment(quanity),
        });
      }
    } catch (e) {
      print('Error inserting data to database:  $e');
    }
  }

  Future<void> _submit() async {
    try {
      await insertFirestore();
    } finally {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Add_order(),
      ));
      updateStock();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Order '),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedPolytheneType,
                  onChanged: (value) {
                    setState(() {
                      _selectedPolytheneType = value!;
                    });
                  },
                  items: ['PP', 'LDPE']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Polythene Type'),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedPrintType,
                  onChanged: (value) {
                    setState(() {
                      _selectedPrintType = value!;
                    });
                  },
                  items: ['Plain', 'Printed']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Print Type'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _buyerName = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Buyer Name'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _polytheneSize = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Polythene Size'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      gauge = int.tryParse(value) ?? 0;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Guage'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      quanity = double.tryParse(value) ?? 0;
                      ;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Quantity'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _submit();
                  },
                  child: Text('Add Order'),
                ),
                SizedBox(height: 20),
                if (_selectedPolytheneType == 'PP' &&
                    (order_PP + quanity > Stock_PP))
                  Text('you are short on PP by ' +
                      (order_PP + quanity - Stock_PP).toString() +
                      'KG'),
                SizedBox(height: 20),
                if (_selectedPolytheneType == 'LDPE' &&
                    (order_LD + quanity > Stock_LD))
                  Text('you are short on LD by ' +
                      (order_LD + quanity - Stock_LD).toString() +
                      'KG'),
              ],
            ),
          ),
        ));
  }
}
