import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  String formattedDateTime =
      DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.now());

  Future<void> insertFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Prepare data to insert
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
          content: Text('Please enter weight for each packet.'),
        ),
      );
      return;
    }

    for (var i = 0; i < _weights.length; i++) {
      _total = _total + _weights[i];
    }
    _total = double.parse(_total.toStringAsFixed(2));
    await insertFirestore();

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => DispatchScreen(),
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data saved '),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dispatch Goods'),
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
                    _numberOfPackets = int.tryParse(value) ?? 0;
                    _weights = List.filled(_numberOfPackets, 0.0);
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Number of Packets'),
              ),
              SizedBox(height: 10),
              for (int i = 0; i < _numberOfPackets; i++)
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _weights[i] = double.tryParse(value) ?? 0.0;
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: 'Weight of Packet ${i + 1}'),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submit();
                },
                child: Text('Dispatch Material'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
