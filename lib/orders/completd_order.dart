import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewCompletedOrdersScreen extends StatefulWidget {
  @override
  _ViewCompletedOrdersScreenState createState() =>
      _ViewCompletedOrdersScreenState();
}

class _ViewCompletedOrdersScreenState extends State<ViewCompletedOrdersScreen> {
  List<Map<String, dynamic>> _completedOrdersPP = [];
  List<Map<String, dynamic>> _completedOrdersLDPE = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompletedOrdersFromFirestore();
  }

  Future<void> _loadCompletedOrdersFromFirestore() async {
    try {
      final completedOrders =
          await FirebaseFirestore.instance.collection('completed-order').get();

      setState(() {
        _completedOrdersPP = completedOrders.docs
            .where((doc) =>
                doc.data()['material type'] == 'PP' &&
                doc.data()['print type'] != null &&
                doc.data()['Buyer Name'] != null &&
                doc.data()['Quantity'] != null &&
                doc.data()['Size'] != null &&
                doc.data()['Guage'] != null &&
                doc.data()['Date and Time'] != null)
            .map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['documentId'] = doc.id;
          return data;
        }).toList();

        _completedOrdersLDPE = completedOrders.docs
            .where((doc) =>
                doc.data()['material type'] == 'LDPE' &&
                doc.data()['print type'] != null &&
                doc.data()['Buyer Name'] != null &&
                doc.data()['Quantity'] != null &&
                doc.data()['Size'] != null &&
                doc.data()['Guage'] != null &&
                doc.data()['Date and Time'] != null)
            .map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['documentId'] = doc.id;
          return data;
        }).toList();

        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data from Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data from Firestore.'),
        ),
      );
    }
  }

  List<DataColumn> _buildDataColumns(List<String> columns) {
    return columns.map(
      (column) {
        return DataColumn(
          label: Text(
            '$column',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    ).toList();
  }

  Widget _buildDataTable(
      List<Map<String, dynamic>> data, List<String> columns) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: _buildDataColumns(columns),
          rows: data
              .asMap()
              .entries
              .map(
                (entry) => DataRow(
                  cells: columns
                      .map(
                        (column) => DataCell(
                          Text('${entry.value[column]}'),
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSection(
      List<Map<String, dynamic>> data, List<String> columnsOrder, String name) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.isEmpty)
          Center(child: Text('No completed orders available  for $name '))
        else
          _buildDataTable(data, columnsOrder),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Orders'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            _buildSection(
                _completedOrdersPP,
                [
                  'material type',
                  'print type',
                  'Buyer Name',
                  'Quantity',
                  'Size',
                  'Guage',
                  'Date and Time',
                ],
                'PP'),
            SizedBox(height: 16), // Adjust the spacing between sections
            _buildSection(
                _completedOrdersLDPE,
                [
                  'material type',
                  'print type',
                  'Buyer Name',
                  'Quantity',
                  'Size',
                  'Guage',
                  'Date and Time',
                ],
                'LD'),
          ],
        ),
      ),
    );
  }
}
